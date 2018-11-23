unit lotofacil_frequencia;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fgl, ZConnection, ZDataset, Dialogs, Math;

type
    TInt_Int  = specialize TFPGMap<integer, integer>;
    TList_Int = specialize TFPGList<TInt_Int>;

procedure frequencia_gerar_estatistica(sql_conexao: TZConnection);
procedure frequencia_atualizar_combinacoes_lotofacil(sql_conexao: TZConnection; concurso: integer);

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

end.
