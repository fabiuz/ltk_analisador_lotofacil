unit lotofacil_frequencia;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fgl, ZConnection, ZDataset, Dialogs, Math, db, Grids;

type
    TInt_Int  = specialize TFPGMap<integer, integer>;
    TList_Int = specialize TFPGList<TInt_Int>;

    // No banco de dados, há uma tabela de nome 'lotofacil_resultado_frequencia', que armazena
    // a frequência das 25 bolas pra cada concurso.
    // Então, toda vez que um concurso é inserido nas tabelas do banco de dados, uma trigger
    // é responsável por realizar esta análise.
    // Na análise da frequência, é considerado os seguintes parâmetros:
    // Se a bola é nova no concurso atual, em relação ao anterior;
    // Se a bola é repetida no concurso atual, em relação ao anterior;
    // Se a bola ainda não saiu no concurso atual, nem no concurso atual;
    // Se a bola deixou de sair no concurso atual, em relação ao concurso anterior;
    TFreq_array_bidimensional = array of array of Integer;

    TFrequencia_de_para = record
      concurso: Integer;
      bola_rank_de_para: array[1..25] of array[1..25] of Array[1..25] of Byte;
      bola_freq_de_para: array[1..25] of array[1..25] of array[1..25] of Integer;
    end;

    TFrequencia_Status = record
      concurso: Integer;

      bola_da_coluna_atual: array[1..25] of Byte;
      bola_anterior_da_coluna_atual: array[1..25] of Byte;
      coluna_anterior_da_bola_atual: array[1..25] of Byte;
      id_coluna_da_bola: array[1..25] of Byte;

      frequencia_da_bola: array[1..25] of Integer;
      frequencia_anterior_da_bola: array[1..25] of Integer;

      //bola_na_posicao_do_rank: array [1..25] of Byte;
      //frequencia_na_posicao_do_rank: array [1..25] of Integer;
      //rank_da_bola: array[1..25] of Byte;

      //bola_na_posicao_do_rank_anterior: array[1..25] of Byte;

      //frequencia_da_bola: array[1..25] of Integer;
      //frequencia_da_bola_rank_anterior: array[1..25] of Integer;
      //frequencia_na_posicao_do_rank_anterior: array[1..25] of Integer;
      //rank_anterior_da_bola: array[1..25] of Byte;

      bola_se_repetindo: array[1..25] of Boolean;
      frequencia_se_repetindo: array[1..25] of Boolean;

      bola_qt_vz_mesma_posicao_do_rank: array [1..25] of Byte;
      frequencia_qt_vz_mesma_posicao_do_rank: array [1..25] of Byte;

      frequencia_status : array [1..25] of string;
    end;
    TFrequencia_Status_Array = array of TFrequencia_Status;

    TFrequencia_comparacao_opcoes = record
      concurso_inicial: Integer;
      concurso_final: Integer;
      sql_conexao: TZConnection;
    end;

    TFrequencia_opcoes = record
      concurso_inicial: Integer;
      concurso_final : Integer;
      sql_conexao: TZConnection;
      sgr_controle: TStringGrid;
    end;



procedure frequencia_gerar_estatistica(sql_conexao: TZConnection);
procedure frequencia_atualizar_combinacoes_lotofacil(sql_conexao: TZConnection; concurso: integer);
procedure frequencia_gerar_comparacao(frequencia_opcoes: TFrequencia_opcoes);

function frequencia_obter_todas(frequencia_opcoes: TFrequencia_opcoes;
  var frequencia_status: TFrequencia_Status_Array
  ): boolean;

procedure frequencia_exibir_comparacao(frequencia_opcoes: TFrequencia_opcoes;
  frequencia_status: TFrequencia_Status_Array);

implementation

{
 Vamos obter todos os registros da tabela 'lotofacil.lotofacil_resultado_frequencia', nesta
 tabela, há os campos com o prefixo 'num_' e onde cada campo com tal prefixo, tem o sufixo
 que corresponde a cada bola da lotofacil, então, num_1 e num_2, por exemplo, corresponde,
 às bolas 1 e 2.
 O valor de tais campo será:
 Menor que -1, se a bola do concurso atual em relação ao último concurso ainda não saiu.
 Igual a -1, se a bola do concurso atual em relação ao último concurso deixou de sair.
 Igual a 1, se a bola do concurso atual em relação ao último concurso é nova.
 Maior que 1, se a bola do concurso atual em relação ao último concurso está se repetindo.
 Então, por exemplo, seja bola 1 em vários concursos, sequenciais e consecutivos:
 -1,-2,-3,1,2,3,4,5,-1,-2,1,2,3,
 acima, valores negativos indica que a bola não saiu e valores positivos indica que a bola
 saiu, então, toda vez que houver uma transição de sair pra não-sair ou de não-sair pra sair, devemos
 registrar o maior valor da transição, então, no exemplo acima:
 -3 e 5, é o maior valor antes da transição, poderíamos contabilizar de outra forma, mas assim,
 não conseguíriamos identificar a frequência com facilidade.
 Então, na procedure abaixo, nosso objetivo é contabilizar, quantas vezes, cada valor apareceu
 na transição entre sair e não-sair ou de não-sair pra sair.
}
procedure frequencia_gerar_estatistica(sql_conexao: TZConnection);
var
    frequencia_lista:    TList_Int;
    frequencia_num_mapa: TInt_Int;
    uA, uB, frequencia_atual: integer;

    // Armazena todos os registros da tabela de frequência.
    frequencia: array of array of integer;

    // Armazena a frequência anterior, quando estivermos processando os registros.
    frequencia_anterior: array[0..25] of integer;

    sql_query: TZQuery;
    qt_registros, valor_atual, valor_frequencia_atual, frequencia_contabilizacao, chave_atual: longint;
begin
    // Vamos criar a lista e o mapa que armazena as frequências.
    frequencia_lista := TList_Int.Create;
    frequencia_lista.Clear;

    // O índice da lista corresponde ao número da bola,
    // não iremos usar o índice 0.
    frequencia_lista.Add(nil);
    for uA := 1 to 25 do
    begin
        frequencia_num_mapa := TInt_Int.Create;
        frequencia_lista.Add(frequencia_num_mapa.Create);
        frequencia_lista[uA].Clear;
    end;

    // Vamos obter todos os registros;
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select * from lotofacil.lotofacil_resultado_num_frequencia');
        sql_query.Sql.Add('order by concurso asc');
        sql_query.Open;
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        // Armazena em arranjo todos os registros, pra posterior análise.
        // Devemos inserir 1 a mais, pois, ao criar dinamicamente, o arranjo
        // será baseado em zero, iremos preferencialmente começar em 1.
        // Na dimensão 1, iremos criar 26 posições de 0 a 25, pois, se
        // indicássemos 25, ficaria de 0 a 24, e estaría errado.
        // Iremos fazer desta forma pois, assim, conseguirmos identificar em qual coluna
        // estamos.
        SetLength(frequencia, qt_registros + 1, 26);

        // A variável abaixo, serve pra percorrer o arranjo 'frequencia'.
        // Iremos começar do índice 1.
        uA := 1;
        sql_query.First;
        while (not sql_query.EOF) or (uA <= qt_registros) do
        begin
            for uB := 1 to 25 do
            begin
                valor_frequencia_atual := sql_query.FieldByName('num_' + IntToStr(uB)).AsInteger;
                frequencia[uA, uB] := valor_frequencia_atual;
            end;
            sql_query.Next;
            Inc(uA);
        end;
        sql_query.Close;

        // Agora, iremos pegar a frequência do primeiro registro.
        for uA := 1 to 25 do
        begin
            frequencia_anterior[uA] := frequencia[1, uA];
        end;

        // Agora, iremos comparar o sinal da frequência atual com o valor da frequência anterior.
        // se, o sinal forem diferentes, quer dizer que houve transição, então, devemos, pegar
        // o valor da frequência anterior e verificar se já estive este valor como chave na variável
        // do tipo mapa, se sim, devemos somar mais ao valor da chave, senão, contabilizaremos como 1.
        for uA := 2 to qt_registros do
        begin
            for uB := 1 to 25 do
            begin

                // Se o sinal da frequência anterior e da frequência atual são
                // diferentes, quer dizer que há uma transição, que quer dizer que
                // a bola do concurso anterior saiu e no concurso atual não saiu ou
                // que a bola do concurso anterior ainda não havia saído e neste concurso saiu.
                if Sign(frequencia_anterior[uB]) <> Sign(frequencia[uA, uB]) then
                begin
                    // Se é a primeira vez deste valor de frequência, iremos armazenar na variável
                    // do tipo map com o valor 1, se não for, quer dizer, que iremos somar mais
                    // 1, ao valor da chave que corresponde à esta frequência.

                    // Obtém o mapa atual.
                    frequencia_num_mapa := frequencia_lista[uB];

                    // Valor da frequência a ser contabilizada.
                    frequencia_atual := frequencia_anterior[uB];

                    if frequencia_num_mapa.IndexOf(frequencia_atual) = -1 then
                    begin
                        frequencia_num_mapa.Add(frequencia_atual, 1);
                    end
                    else
                    begin
                        // Se chegarmos aqui, quer dizer, que a frequência já existe no
                        // mapa, devemos obter a contabilização atual.
                        frequencia_contabilizacao := frequencia_num_mapa.KeyData[frequencia_atual];
                        Inc(frequencia_contabilizacao);
                        frequencia_num_mapa.AddOrSetData(frequencia_atual, frequencia_contabilizacao);
                    end;
                    frequencia_lista[ub] := frequencia_num_mapa;

                end;
                frequencia_anterior[uB] := frequencia[uA, uB];
            end;
        end;

        // Agora, contabiliza a última frequência, pois, p
        for uB := 1 to 25 do
        begin
            // Obtém o mapa atual.
            frequencia_num_mapa := frequencia_lista[uB];

            // Valor da frequência a ser contabilizada.
            frequencia_atual := frequencia_anterior[uB];

            if frequencia_num_mapa.IndexOf(frequencia_atual) = -1 then
            begin
                frequencia_num_mapa.Add(frequencia_atual, 1);
            end
            else
            begin
                // Se chegarmos aqui, quer dizer, que a frequência já existe no
                // mapa, devemos obter a contabilização atual.
                frequencia_contabilizacao := frequencia_num_mapa.KeyData[frequencia_atual];
                Inc(frequencia_contabilizacao);
                frequencia_num_mapa.AddOrSetData(frequencia_atual, frequencia_contabilizacao);
            end;
        end;

        // Agora, exibe os dados.
        for uA := 1 to 25 do
        begin
            frequencia_num_mapa := frequencia_lista[uA];
            for uB := 0 to Pred(frequencia_num_mapa.Count) do
            begin
                chave_atual := frequencia_num_mapa.Keys[uB];
            end;
        end;

        FreeAndNil(sql_query);

    except
        On Exc: Exception do
        begin
            FreeAndNil(sql_query);
            MessageDlg('', 'Erro, ' + Exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;
end;

{
 Atualiza todas as combinações da lotofacil de 15 números, com a frequência relativa
 ao concurso escolhido pelo usuário.
}
procedure frequencia_atualizar_combinacoes_lotofacil(sql_conexao: TZConnection; concurso: integer);
const
    // Quantidade de combinações de 15 números na lotofacil.
    LTF_CMB_15_BOLAS = 3268760;
var
    frequencia_num_concurso: array [0..25] of integer;
    sql_query : TZQuery;
    frequencia_concurso, qt_registros, zero_um: longint;
    frequencia_combinacoes: array of array of integer;
    uA, soma_frequencia, uB, qt_ainda_nao_saiu, qt_saiu, qt_repetindo, qt_deixou_de_sair,
    qt_novo, qt_registros_lidos: integer;
    sql_insert, zero_um_anterior, zero_um_atual: string;
begin
    // Obtém a frequência do concurso escolhido.
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;

        // Deleta os dados da tabela.
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Truncate lotofacil.lotofacil_frequencia');
        sql_query.ExecSql;

        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select * from lotofacil.lotofacil_resultado_num_frequencia');
        sql_query.Sql.Add('where concurso = ' + IntToStr(concurso));
        sql_query.Open;
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        if qt_registros = 0 then
        begin
            MessageDlg('', 'Nenhum registro localizado', mtError, [mbOK], 0);
            Exit;
        end;

        // Copia a frequencia pra o vetor.
        sql_query.First;
        for uA := 1 to 25 do
        begin
            frequencia_concurso := sql_query.FieldByName('num_' + IntToStr(uA)).AsInteger;
            frequencia_num_concurso[uA] := frequencia_concurso;
        end;

        // Vamos percorrer todas as combinações e comparar com a frequência do concurso.
        sql_query.Sql.Clear;
        sql_query.SQL.Add('Select * from lotofacil.lotofacil_num');
        sql_query.Sql.Add('where ltf_qt = 15');
        sql_query.Sql.Add('Order by ltf_id asc');
        sql_query.Open;
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;
        if qt_registros <> LTF_CMB_15_BOLAS then
        begin
            MessageDlg('', 'Erro, não há 3268760 registros com 15 bolas', mtError, [mbOK], 0);
            Exit;
        end;

        // Na dimensão 2, há 8 campos:
        // ltf_id,sm_df,qt_ainda_nao_saiu,qt_novo,qt_repetindo,qt_deixou_de_sair.
        SetLength(frequencia_combinacoes, qt_registros + 1, 8);


        zero_um_anterior := '';
        sql_query.First;
        for uA := 1 to qt_registros do
        begin
            soma_frequencia := 0;
            qt_ainda_nao_saiu := 0;
            qt_novo := 0;
            qt_repetindo := 0;
            qt_deixou_de_sair := 0;

            zero_um_atual := '';

            for uB := 1 to 25 do
            begin
                zero_um := sql_query.FieldByName('num_' + IntToStr(uB)).AsInteger;

                // Vamos verificar se o registro anterior é igual ao atual.
                if zero_um_atual <> '' then begin
                    zero_um_atual := zero_um_atual + '_';
                end;
                zero_um_atual := zero_um_atual + IntToStr(zero_um);

                frequencia_concurso := frequencia_num_concurso[uB];
                //Writeln('uB:', uB, 'zero_um:', zero_um, 'freq_conc: ', frequencia_concurso);

                // Nos ifs abaixo, funciona assim, a variável 'zero_um' tem o valor
                // '1' se a bola saiu naquela combinação, '0' caso contrário,
                // então, iremos comparar com a frequência do concurso.
                // Na frequência do concurso, temos, números positivos e negativos,
                // um número positivo e maior que zero, indica se a bola é nova
                // naquele concurso em relação a outro ou está se repetindo e
                // se um número negativo, quer dizer, que a bola ainda não saiu ou deixou
                // de sair.

                if (zero_um = 1) and (sign(frequencia_concurso) = 1) then
                begin
                    Inc(frequencia_concurso);
                    Inc(qt_repetindo);
                end
                else
                if (zero_um = 1) and (sign(frequencia_concurso) = -1) then
                begin
                    frequencia_concurso := 1;
                    Inc(qt_novo);
                end
                else if (zero_um = 0) and (sign(frequencia_concurso) = 1) then
                begin
                    frequencia_concurso := -1;
                    Inc(qt_deixou_de_sair);
                end
                else if (zero_um = 0) and (sign(frequencia_concurso) = -1) then
                begin
                    Inc(frequencia_concurso, -1);
                    Inc(qt_ainda_nao_saiu);
                end else begin
                    //Writeln('Caiu aqui, verificar.');
                end;
                // Após alterar.
                //Writeln('uB:', uB, 'zero_um:', zero_um, 'freq_conc: ', frequencia_concurso);


                soma_frequencia := soma_frequencia + frequencia_concurso;
            end;

            if zero_um_anterior = zero_um_atual then begin
                    //Writeln('zero_um=zero_um_anterior');
            end;
            zero_um_anterior := zero_um_atual;

            sql_query.Next;
            if sql_query.EOF = true then begin
                //Writeln('EOF');
            END;;


            frequencia_combinacoes[uA, 0] := uA;
            frequencia_combinacoes[uA, 1] := concurso;
            frequencia_combinacoes[uA, 2] := soma_frequencia;
            frequencia_combinacoes[uA, 3] := qt_ainda_nao_saiu;
            frequencia_combinacoes[uA, 4] := qt_novo;
            frequencia_combinacoes[uA, 5] := qt_repetindo;
            frequencia_combinacoes[uA, 6] := qt_deixou_de_sair;

        end;

        sql_insert := 'Insert into lotofacil.lotofacil_frequencia(' +
            'ltf_id,concurso,sm_df,qt_ainda_nao_saiu,qt_novo' +
            ',qt_repetindo,qt_deixou_de_sair)values';
        sql_query.Sql.Clear;
        qt_registros_lidos := 0;
        for uA := 1 to qt_registros do
        begin
            if qt_registros_lidos = 0 then
            begin
                sql_query.Sql.Clear;
                sql_query.Sql.Add(sql_insert);
            end;
            if qt_registros_lidos > 0 then
            begin
                sql_query.Sql.Add(',');
            end;
            sql_query.Sql.Add(Format('(%d,%d,%d,%d,%d,%d,%d)',
                [frequencia_combinacoes[uA, 0], frequencia_combinacoes[uA, 1],
                frequencia_combinacoes[uA, 2], frequencia_combinacoes[uA, 3],
                frequencia_combinacoes[uA, 4], frequencia_combinacoes[uA, 5],
                frequencia_combinacoes[uA, 6]]));
            Inc(qt_registros_lidos);
            if qt_registros_lidos = 1000 then
            begin
                //Writeln(sql_query.SQL.Text);
                sql_query.ExecSql;
                sql_query.SQL.Clear;
                qt_registros_lidos := 0;
            end;
        end;
        // Se restou algo, iremos gravar
        if qt_registros <> 0 then begin
            sql_query.ExecSql;
        end;


        sql_query.Close;
        FreeAndNil(sql_query);

    except
        On Exc: Exception do
        begin
            Exit;
        end;
    end;

end;

{
 Gera uma estatística comparando todas as frequências.
}
procedure frequencia_gerar_comparacao(frequencia_opcoes: TFrequencia_opcoes);
var
  frequencia_status: TFrequencia_Status_Array;
begin
    frequencia_opcoes.sql_conexao := frequencia_opcoes.sql_conexao;
    if frequencia_obter_todas(frequencia_opcoes, frequencia_status) = false then begin
        Exit;
    end;

    // Agora, vamos exibir a estatística de frequência.
    frequencia_exibir_comparacao(frequencia_opcoes, frequencia_status);

end;

{
 Obtém a informação de cada frequência da tabela 'lotofacil.lotofacil_resultado_frequencia'.
}
function frequencia_obter_todas(frequencia_opcoes: TFrequencia_opcoes;
  var frequencia_status: TFrequencia_Status_Array): boolean;
var
  sql_query: TZQuery;
  qt_registros: LongInt;
  indice_registro, uA, rank_atual: Integer;
  concurso_atual, bola_atual, frequencia_atual, concurso_anterior,
    indice_registro_anterior, frequencia_anterior_da_bola,
    frequencia_anterior_na_posicao_do_rank,
    frequencia_na_posicao_do_rank_anterior, id_coluna: Integer;
  bola_na_posicao_do_rank_anterior, rank_anterior_da_bola,
    id_coluna_anterior_da_bola_atual, bola_anterior_da_coluna: Byte;
begin
  try
      sql_query := TZQuery.Create(Nil);
      sql_query.Connection := frequencia_opcoes.sql_conexao;
      sql_query.Sql.Clear;
      sql_query.Sql.Add('Select * from lotofacil.v_lotofacil_resultado_bolas_frequencia');
      sql_query.Sql.Add('order by concurso desc, frequencia desc, bola asc');
      sql_query.Open;
      sql_query.First;
      sql_query.Last;

      qt_registros := sql_query.RecordCount;
      if qt_registros = 0 then begin
          Exit(False);
      end;
      // Verifica se a quantidade de registros é múltipla de 25.
      if qt_registros mod 25 <> 0 then begin
          Exception.Create('Erro, a quantidade de registros retornadas, deve ser uma ' +
                                  ' quantidade múltipla de 25');
          Exit(False);
      end;

      // Cada frequência de bola de cada combinação, é armazenada em um registro
      // por isso, devemos dividir por 5, pois, ao processar no loop, em breve,
      // a seguir, iremos colocar todas as bolas, dentro de um única variável
      // do tipo registro.
      SetLength(frequencia_status, qt_registros div 25 );
      Writeln(Length(frequencia_status));
      if Length(frequencia_status) <= 0 then begin
          Exception.Create('Não há memória pra alocar o arranjo.');
          Exit(False);
      end;

      // Reseta o primeiro arranjo.
      FillByte(frequencia_status[0], sizeof(TFrequencia_Status), 0);

      sql_query.First;
      indice_registro := -1;
      while (qt_registros > 0) and (sql_query.EOF = false) do begin
          // No sql, iremos percorrer do menor concurso até o último concurso
          // referente a frequência e de tal forma que as bolas esteja disposta
          // em ordem decrescente de frequência, caso, duas bolas tenha a mesma
          // frequência, então, a menor bola aparece primeiro.
          // Cada concurso, gera a frequência pra cada bola, por isto, há 25 registros
          // por combinação.
          // No loop abaixo, iremos percorrer as 25 posições e inserir em uma
          // única variável do tipo 'record', assim fica fácil manipular
          // a informação.
          Inc(indice_registro);
          if indice_registro = 0 then begin
              indice_registro_anterior := 0;
          end else begin
              indice_registro_anterior := indice_registro - 1;
          end;

          for uA := 1 to 25 do begin
              id_coluna := uA;
              concurso_atual := sql_query.FieldByName('concurso').AsInteger;
              bola_atual := sql_query.FieldByName('bola').AsInteger;
              frequencia_atual := sql_query.FieldByName('frequencia').AsInteger;

              // Vamos armazenar os dados.
              frequencia_status[indice_registro].concurso:= concurso_atual;
              frequencia_status[indice_registro].bola_da_coluna_atual[id_coluna] := bola_atual;
              frequencia_status[indice_registro].frequencia_da_bola[bola_atual] := frequencia_atual;
              frequencia_status[indice_registro].id_coluna_da_bola[bola_atual] := id_coluna;

              if frequencia_atual > 0 then begin
                  frequencia_status[indice_registro].frequencia_status[uA]:= 'REP';
              end else if frequencia_atual = 1 then begin
                  frequencia_status[indice_registro].frequencia_status[uA]:= 'NOVO';
              end else if frequencia_atual = -1 then begin
                  frequencia_status[indice_registro].frequencia_status[uA]:= 'DX_S';
              end else begin
                  frequencia_status[indice_registro].frequencia_status[uA]:= 'AI_NS';
              end;

              // Aqui, iremos pegar a estatística da frequência anterior:
              // Bola que estava na mesma posição do rank, na frequência anterior.
              bola_anterior_da_coluna := frequencia_status[indice_registro_anterior].bola_anterior_da_coluna_atual[id_coluna];
              id_coluna_anterior_da_bola_atual := frequencia_status[indice_registro_anterior].coluna_anterior_da_bola_atual[bola_atual];

              //bola_na_posicao_do_rank_anterior := frequencia_status[indice_registro_anterior].bola_na_posicao_do_rank[rank_atual];
              //rank_anterior_da_bola := frequencia_status[indice_registro_anterior].rank_anterior_da_bola[bola_atual];

              // A frequência anterior da bola atual.
              frequencia_anterior_da_bola := frequencia_status[indice_registro_anterior].frequencia_da_bola[bola_atual];

              // A frequência na posição do rank anterior.
              // frequencia_na_posicao_do_rank_anterior := frequencia_status[indice_registro_anterior].frequencia_na_posicao_do_rank[rank_atual];

              // Agora, insere estas informações no registro atual.
              frequencia_status[indice_registro].bola_anterior_da_coluna_atual[id_coluna] := bola_anterior_da_coluna;
              frequencia_status[indice_registro].frequencia_anterior_da_bola[bola_atual] := frequencia_anterior_da_bola;
              //frequencia_status[indice_registro].frequencia_na_posicao_do_rank_anterior[rank_atual] := frequencia_na_posicao_do_rank_anterior;
              frequencia_status[indice_registro].coluna_anterior_da_bola_atual[bola_atual] := id_coluna_anterior_da_bola_atual;

              // Cada bola é disposta de tal forma, que as bolas que mais sai estão ordenadas da
              // esquerda pra direita, conforme o valor de frequência, então é possível que
              // a mesma bola na mesma posição do rank se repita e também pode acontecer
              // da frequência de um concurso anterior de um rank ser igual à frequência do concurso atual,
              // no mesmo rank, isto ocorre se a frequência do concurso anterior, de um outro rank,
              // deslocar pra um outro rank, também, descreveremos isto.

              if bola_atual = bola_na_posicao_do_rank_anterior then begin
                 Inc(frequencia_status[indice_registro].bola_qt_vz_mesma_posicao_do_rank[rank_atual]);
              end else begin
                 frequencia_status[indice_registro].bola_qt_vz_mesma_posicao_do_rank[rank_atual] := 0;
              end;

              if frequencia_anterior_na_posicao_do_rank = frequencia_atual then begin
                 Inc(frequencia_status[indice_registro].frequencia_qt_vz_mesma_posicao_do_rank[rank_atual]);
              end else begin
                  frequencia_status[indice_registro].frequencia_qt_vz_mesma_posicao_do_rank[rank_atual] := 0;
              end;

              sql_query.Next;
              Dec(qt_registros);
          end;
      end;
      FreeAndNil(sql_query);
  except
      On Exc: Exception do begin
          MessageDlg('', 'Erro, ' + Exc.Message, mtError, [mbok], 0);
          Exit(False);
      end;
  end;
  Exit(True);
end;

procedure frequencia_exibir_comparacao(frequencia_opcoes: TFrequencia_opcoes;
  frequencia_status: TFrequencia_Status_Array);
const
    sgr_controle_campos : array[0..26] of string = (
    'Concurso', '#', '1', '2','3', '4','5',
                     '6', '7','8', '9','10',
                     '11', '12','13', '14','15',
                     '16', '17','18', '19','20',
                     '21', '22','23', '24','25');

var
  sgr_controle: TStringGrid;
  coluna_atual: TGridColumn;
  uA, indice_linha_sgr_controle, indice_coluna, indice_linha,
    sgr_controle_total_de_linhas, indice_freq_status, frequencia_atual: Integer;
  concurso_numero: QWord;
  frequencia_anterior, bola_anterior, frequencia_rank_atual,
    frequencia_rank_anterior, frequencia_bola_rank_anterior,
    frequencia_bola_atual, frequencia_anterior_bola_atual: Integer;
  qt_vz_freq_repetindo, bola_rank_atual, bola_rank_anterior,
    rank_anterior_da_bola_atual, bola_da_coluna_atual,
    coluna_anterior_da_bola_atual, bola_anterior_da_coluna_atual: Byte;
  frq_status: String;
  bola_se_repetindo, frequencia_se_repetindo: Boolean;
begin
  if Length(frequencia_status) <= 0 then begin
     MessageDlg('', 'Não há nenhum registro.', mtError, [mbok], 0);
     Exit;
  end;

  sgr_controle := frequencia_opcoes.sgr_controle;
  sgr_controle.Columns.Clear;
  sgr_controle.RowCount := 1;
  sgr_controle.FixedRows:=1;

  // No controle, haverá as colunas:
  // concurso, sigla, rnk_1, até rnk_25.
  // rnk, significa o rank da bola quanto mais a esquerda, mais frequente é a bola.
  for uA := 0 to High(sgr_controle_campos) do begin
      coluna_atual := sgr_controle.columns.Add;
      coluna_atual.Alignment:= taCenter;
      coluna_atual.Font.Size := 12;
      coluna_atual.Font.Name := 'Consolas';
      coluna_atual.Title.Alignment := taCenter;
      coluna_atual.Title.Caption := sgr_controle_campos[uA];
      coluna_atual.Title.Font.Name := 'Consolas';
      coluna_atual.Title.Font.Size := 12;
  end;
  // A frequẽncia pra cada combinação, ocupará mais de uma linha,
  // então, precisamos multiplicar pelo números de linhas.
  // Haverá 8 linhas, por concurso.
  sgr_controle_total_de_linhas := Length(frequencia_status) * 10;

  // Haverá 1 linha a mais por causa do cabeçalho.
  sgr_controle.RowCount := sgr_controle_total_de_linhas + 1;

  // Agora, vamos gerar os dados.
  indice_linha := 1;
  indice_coluna := 2;
  indice_freq_status := 0;
  while indice_linha <= sgr_controle_total_de_linhas do begin
      // Concurso.
      concurso_numero := frequencia_status[indice_freq_status].concurso;
      sgr_controle.Cells[0, indice_linha] := IntToStr(concurso_numero);

      // Pra cada frequência, haverá 5 linhas, que representa as informações de frequência.
      sgr_controle.Cells[1, indice_linha] := 'STATUS';
      sgr_controle.Cells[1, indice_linha + 1] := 'BL_RNK_AT';
      sgr_controle.Cells[1, indice_linha + 2] := 'BL_RNK_ANT';
      sgr_controle.Cells[1, indice_linha + 3] := 'RNK_ANT_BL_AT';
      sgr_controle.Cells[1, indice_linha + 4] := 'BL_RPT';
      sgr_controle.Cells[1, indice_linha + 5] := 'FRQ_RNK_AT';
      sgr_controle.Cells[1, indice_linha + 6] := 'FRQ_RNK_ANT';
      sgr_controle.Cells[1, indice_linha + 7] := 'FRQ_BL_RNK_ANT';
      //sgr_controle.Cells[1, indice_linha + 7] := 'QT_VZ_BL_RPT';
      //sgr_controle.Cells[1, indice_linha + 8] := 'FRQ_RPT';

      indice_coluna := 2;
      for uA := 1 to 25 do begin
          bola_da_coluna_atual := frequencia_status[indice_freq_status].bola_da_coluna_atual[uA];
          bola_anterior_da_coluna_atual := frequencia_status[indice_freq_status].bola_anterior_da_coluna_atual[uA];
          coluna_anterior_da_bola_atual := frequencia_status[indice_freq_status].coluna_anterior_da_bola_atual[bola_rank_atuaL];

          frequencia_bola_atual := frequencia_status[indice_freq_status].frequencia_da_bola[uA];
          frequencia_anterior_bola_atual := frequencia_status[indice_freq_status].frequencia_anterior_da_bola[uA];

          //frequencia_bola_rank_anterior := frequencia_status[indice_freq_status].frequencia_da_bola_rank_anterior[bola_rank_atual];


          bola_se_repetindo := frequencia_status[indice_freq_status].bola_se_repetindo[uA];
          frequencia_se_repetindo := frequencia_status[indice_freq_status].frequencia_se_repetindo[uA];

          qt_vz_freq_repetindo := frequencia_status[indice_freq_status].frequencia_qt_vz_mesma_posicao_do_rank[uA];
          frq_status := frequencia_status[indice_freq_status].frequencia_status[uA];

          sgr_controle.Cells[indice_coluna, indice_linha] := frq_status;
          sgr_controle.Cells[indice_coluna, indice_linha + 1] := IntToStr(bola_da_coluna_atual);
          sgr_controle.Cells[indice_coluna, indice_linha + 2] := IntToStr(bola_anterior_da_coluna_atual);
          sgr_controle.Cells[indice_coluna, indice_linha + 3] := IntToStr(rank_anterior_da_bola_atual);

          if bola_se_repetindo then begin
             sgr_controle.Cells[indice_coluna, indice_linha + 4] := 'BL_S';
          end else begin
             sgr_controle.Cells[indice_coluna, indice_linha + 4] := 'BL_N';
          end;

          sgr_controle.Cells[indice_coluna, indice_linha + 5] := IntToStr(frequencia_rank_atual);
          sgr_controle.Cells[indice_coluna, indice_linha + 6] := IntToStr(frequencia_rank_anterior);
          if frequencia_se_repetindo then begin
             sgr_controle.Cells[indice_coluna, indice_linha + 7] := 'FQ_S';
          end else begin
             sgr_controle.Cells[indice_coluna, indice_linha + 7] := 'FQ_N';
          end;

          sgr_controle.Cells[indice_coluna, indice_linha + 7] := IntToStr(frequencia_bola_rank_anterior);

          Inc(indice_coluna);
      end;

      Inc(indice_linha, 10);
      Inc(indice_freq_status);
  end;
  sgr_controle.AutoSizeColumns;


end;

end.
