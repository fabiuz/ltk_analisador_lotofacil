unit uLotofacilSomaFrequencia;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


type
  TLotofacilSomaFrequenciaStatus = procedure (status: string) of object;
  TLotofacilSomaFrequenciaStatusConcluido = procedure (status: string) of object;
  TLotofacilSomaFrequenciaStatusErro = procedure (status_erro: string) of object;


  { TLotofacilSomaFrequenciaThread }

  TLotofacilSomaFrequenciaThread = class(TThread)
    private
      fTempo_Inicio: TDateTime;
      fTempo_Fim: TDateTime;

      fStatus: TLotofacilSomaFrequenciaStatus;
      fStatus_Concluido: TLotofacilSomaFrequenciaStatusConcluido;
      fStatus_Erro : TLotofacilSomaFrequenciaStatusErro;

      fStatus_Mensagem : String;

      objParent_Component: TComponent;

      // Armazena o valor de cada frequência de cada grupo.
      frequencia_por_grupo: array of Integer;

      // Armazena a soma de frequência de cada combinação
      // A primeira combinação começa no índice 0.
      lotofacil_combinacoes: array of array of LongWord;

      //procedure AtualizarSomaFrequencia;
      procedure AtualizarSomaFrequencia_2;
      procedure DoStatus;
      procedure DoStatus_Concluido;
      procedure DoStatus_Erro;
      procedure Exibir_Mensagem_de_Termino;
      //procedure Gravar_Soma_Frequencia_no_banco_de_dados;
      //procedure Gravar_Soma_Frequencia_no_banco_de_dados_2;
      //procedure Gravar_Soma_Frequencia_no_banco_de_dados_3;
      procedure Gravar_Soma_Frequencia_no_banco_de_dados_4;
      function ObterFrequencia : boolean;

    public
      property OnStatus : TLotofacilSomaFrequenciaStatus read fStatus write fStatus;
      property OnStatus_Concluido : TLotofacilSomaFrequenciaStatusConcluido read fStatus_Concluido write fStatus_Concluido;
      property OnStatus_Erro: TLotofacilSomaFrequenciaStatusErro read fStatus_Erro write fStatus_Erro;

    public
      procedure Execute; override;
      constructor Create(objParent: TComponent; CreateSuspended: Boolean);

    public
      // Indica o grupo de frequência que queremos somar as frequências de combinação.
      // Por exemplo, em um grupo de frequência com duas bolas, por exemplo, 1 e 2
      // é um grupo, então, iremos pegar a frequência desta bola e somar com todos os outras
      // frequências de grupos de 2 bolas que está em uma combinação.
      qt_bolas_por_grupo: Integer;

      // Indica o concurso inicial e final em que a frequência dos grupos será baseada.
      concurso_inicial: Integer;
      concurso_final: Integer;
  end;

implementation
uses
  sqlDb, db, uLotofacilModulo, dialogs, dateUtils;

{ TLotofacilSomaFrequenciaThread }

procedure TLotofacilSomaFrequenciaThread.DoStatus;
begin
  if Assigned(fStatus) then
  begin
     OnStatus(fStatus_Mensagem);
  end;
end;

procedure TLotofacilSomaFrequenciaThread.DoStatus_Concluido;
begin
  if Assigned(fStatus_Concluido) then
  begin
     OnStatus_Concluido(fStatus_Mensagem);
  end;
end;

procedure TLotofacilSomaFrequenciaThread.DoStatus_Erro;
begin
  if Assigned(fStatus_Erro) then
  begin
    OnStatus_Erro(fStatus_Mensagem);
  end;
end;

procedure TLotofacilSomaFrequenciaThread.Execute;
begin
  // Validar entrada.
  if not(qt_bolas_por_grupo in [1..4]) then
  begin
    fStatus_Mensagem := 'Erro, quantidade de bolas por grupo inválido.' +
                        '#10#13' + 'Faixa válida é entre 1 e 4.';
    Synchronize(@DoStatus_Erro);
    Exit;
  end;

  if Not ObterFrequencia then begin
    Synchronize(@DoStatus_Erro);
    Exit;
  end;

  fTempo_Inicio:= Now;
  AtualizarSomaFrequencia_2;

end;

{
 Retorna true, se a consulta das frequências baseada em grupos e no
 intervalo de concurso retornou algum registro.
}
function TLotofacilSomaFrequenciaThread.ObterFrequencia: boolean;
// A quantidade de bolas em cada grupo, determina a quantidade
// de registros que são retornados.
// Então, iremos validar isto também.
const
  qt_registros_retornados : array[1..4] of Integer = (
                          25, 300, 2300, 12650
  );
var
  sql_registros : TSqlQuery;
  qt_registros , grp_id, grp_id_qt_vezes: Integer;
  concurso_parametro : TParam;
begin
  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TdmLotofacil.Create(objParent_Component);
  end;

  sql_registros := dmLotofacil.sqlLotofacil;
  sql_registros.SQL.Clear;
  sql_registros.SQL.Add('Select grp_id, qt_vezes from');

  // Gera a sql dinamicamente, baseada na quantidade de bolas de cada grupo.
  case qt_bolas_por_grupo of
       1:  sql_registros.SQL.Add('lotofacil.fn_lotofacil_resultado_grupo_1_bola($1, $2)');
       2..4:
         sql_registros.Sql.Add('lotofacil.fn_lotofacil_resultado_grupo_' + IntToStr(qt_bolas_por_grupo) + '_bolas($1, $2)');
       else begin
         fStatus_Mensagem := 'Erro, quantidade de bolas por grupo inválido.' +
                        '#10#13' + 'Faixa válida é entre 1 e 4.';
         Exit(False);
       end;
  end;

  sql_registros.Active := false;
  sql_registros.DataBase := dmLotofacil.pgLTK;
  sql_registros.UniDirectional := false;

  // Insere o valor do concurso inicial e concurso final.
  concurso_parametro := sql_registros.Params.CreateParam(TFieldType.ftInteger,
    '$1', TParamType.ptInput);
  concurso_parametro.AsInteger := concurso_inicial;

  concurso_parametro := sql_registros.Params.CreateParam(TFieldType.ftInteger,
    '$2', TParamType.ptInput);
  concurso_parametro.AsInteger := concurso_final;

  // Agora, vamos executar a consulta.
  try
    sql_registros.Prepare;
    sql_registros.Open;
  except
    On exc: EDataBaseError do
    begin
       fStatus_Mensagem := 'Erro: ' + exc.Message;
       dmLotofacil.pgLTK.Close(true);

       Exit(False);
    end;
  end;

  // Vai do primeiro ao último registro pra descobrir a quantidade de registros
  // retornados.
  sql_registros.First;
  sql_registros.Last;
  sql_registros.First;

  qt_registros := sql_registros.RecordCount;

  // Se a quantidade é 0, quer dizer, que não há registros e é um erro.
  if qt_registros = 0 then begin
     fStatus_Mensagem := 'Erro, nenhum registro de frequência de grupos localizado.';
     Exit(False);
  end;

  // Se a quantidade de registros não coincide com a quantidade de registros
  // definida pra aquele grupo, retornar com erro.
  if qt_registros <> qt_registros_retornados[qt_bolas_por_grupo] then begin
     fStatus_Mensagem := 'Erro, retornou ' + IntToStr(qt_registros) + ' registros, entretanto, ' +
                         'era pra retornar: ' + IntToStr(qt_registros_retornados[qt_bolas_por_grupo]) + ' registros.';
     Exit(False);
  end;

  // Criar o arranjo que armazena a soma das frequencias.
  try
     SetLength(frequencia_por_grupo, qt_registros_retornados[qt_bolas_por_grupo] + 1);

  except
    On exc: Exception do begin
       fStatus_Mensagem := 'Erro, ' + exc.Message;
       Exit(False);
    end;
  end;

  // Agora, vamos armazenar as frequências.
  // Na tabela no sistema, o campo 'grp_id', começa em 'zero' ou '1', e sempre o próximo 'grp_id' é igual
  // ao 'grp_id' anterior mais 'um', então, no sistema aqui, o índice do arranjo 'frequencia_por_grupo'
  // armazenar o valor atual do 'grp_id' e o valor da célula será o valor do campo 'qt_vezes'.
  // Se na tabela, os identificadores 'grp_id' não fosse incrementado de 'um em um', deveríamos armazenar
  // os identificadores e o valor da frequência de outra forma.
  try
    sql_registros.First;
    while sql_registros.EOF = false do begin
         grp_id := sql_registros.FieldByName('grp_id').AsInteger;
         grp_id_qt_vezes := sql_registros.FieldByName('qt_vezes').AsInteger;
         frequencia_por_grupo[grp_id] := grp_id_qt_vezes;
         sql_registros.Next;
    end;
    sql_registros.Close;
    FreeAndNil(sql_registros);
    FreeAndNil(dmLotofacil);

  except
    On exc: Exception do begin
      fStatus_Mensagem := 'Erro, ' + exc.Message;
      Exit(False);
    end;
  end;

  Exit(True);

end;

{
 Na lotofacil, se analisamos estatisticamente a frequência que uma bola sai,
 estamos analisando a bola sem nenhuma relação com outras bolas que fazem parte
 também da mesma combinação, se jogarmos as bolas que mais sai nem sempre vc terá
 êxito em acertar alguma pontuação, isto, na minha opinião provavelmente acontece
 por que estamos analisando a frequência das bolas isoladamente sem considerar as outras
 bolas. Então, se analisarmos a bolas em grupos, provavelmente, talvez a precisão pra
 acertar aumente.
 No meu banco de dados, existe uma tabela 'lotofacil.lotofacil_num_bolas', nela, há
 os campos 'ltf_id', 'ltf_qt', 'concurso_inicial', 'concurso_final' e 'concurso_soma_frequencia'.
 Por exemplo, em uma combinação de 15 bolas, temos pra cada bola, um valor de frequência
 considerando um intervalo de concurso considerado, com isto, podemos atualizar o campo
 'concurso_soma_frequencia' com a soma da frequência de todas as bolas daquela combinação.
 Em grupos de 1 bola, por exemplo, em uma combinação com 15 bolas, há 15 grupos de 1 bolas,
 então, haverá a soma da frequência de cada grupo.
 Entretanto, pra aumentar a precisão podermos obter a frequência de um grupo de bolas, por exemplo,
 em um grupo de 2 bolas, por exemplo, 1 e 2, quantas vezes a bola 1 e 2 saíram juntas???
 Entretanto, diferente de um grupo de 1 bolas, em que há 15 bolas pra uma combinação de 15 bolas.
 Em uma combinação de 15 bolas, há 145 grupos de 2 bolas, por exemplo, dado a combinação:
 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15, temos os grupos [1,2],[1,3], ...[1,15],[2,3],[2,4],...[2,15]
 e assim por diante.
 Então, o campo 'frequencia_soma_bolas' terá a soma da frequência de cada grupo, como há 145 grupos
 de 2 bolas, haverá a soma da frequência dos 145 grupos.

 Resumindo, o objetivo desta procedure é realizar isto, atualizar o campo 'frequencia_soma_bolas'
 conforme a frequência dos grupos, conforme o intervalo do concurso escolhido.

 O objetivo de ter uma tabela com a soma de frequência por combinação é que conseguirmos obter as combinações
 baseada na frequência das bolas, ou seja, as bolas em grupos que tem a maior frequência apareceram primeiro,
 fazendo com que aumentemos a chance de acertos na lotofacil.

}

procedure TLotofacilSomaFrequenciaThread.AtualizarSomaFrequencia_2;
const
  nome_dos_arquivos : array[1..4] of string = (
                    'lotofacil_grupo_1_bola.ltfbin',
                    'lotofacil_grupo_2_bolas.ltfbin',
                    'lotofacil_grupo_3_bolas.ltfbin',
                    'lotofacil_grupo_4_bolas.ltfbin'
  );
const
  qt_registros_retornados : array[1..4] of Integer = (25, 300, 2300, 12650);
const
  diretorio_dos_arquivos = '/run/media/fabiuz/000E4C3400030AE7/LTK/ltk_gerador_binario_de_grupos/arquivos_csv/';
const
  TOTAL_DE_ITENS = 5000000;
  LOTOFACIL_TOTAL_ITENS = 6874010;
type
  rd_lotofacil_arquivo = record
    ltf_id: Integer;
    ltf_qt: Integer;
    grp_id: Integer;
  end;
  pt_rd_lotofacil_arquivo = ^ rd_lotofacil_arquivo;
var
  bytes_por_registro, total_de_bytes_lidos, total_max_de_bytes_a_ler, registros_lidos, uA, frequencia_atual,
    frequencia_do_grp_id, ltf_id, ltf_qt, grp_id, soma_frequencia,
    qt_linhas_processadas, total_de_linhas_antes_de_exibir: Integer;
  ltf_arquivo : TFileStream;

  buffer_rd_lotofacil_arquivo : Pointer;
  pt_buffer : pt_rd_lotofacil_arquivo;
begin
  total_de_bytes_lidos := 0;
  bytes_por_registro := sizeof(rd_lotofacil_arquivo);
  total_max_de_bytes_a_ler := bytes_por_registro * TOTAL_DE_ITENS;

  // Indica o total de linhas já processadas, antes de exibir, a informação
  // na tela pra o usuário, a vantagem disto, é que o processamento será mais
  // rápido.
  total_de_linhas_antes_de_exibir := TOTAL_DE_ITENS;
  qt_linhas_processadas := 0;

  // Há na lotofacil 6874010 combinações, então, iremos criar um arranjo com 6874010 ítens
  // Este arranjo armazenar a soma das frequências.
  // Ao criarmos o arranjo é baseado em zero, entretanto, o id 'ltf_id' começa em zero, por
  // isso, criamos um arranjo com 1 ítem a mais.
  // No arranjo, na dimensão 1, índice 0, armazenaremos o valor do campo 'ltf_qt' e
  // no arranjo, na dimensão 1, índice 1, armazenaremos o valor do campo 'soma_frequencia_bolas'.
  // Então, ao acabarmos de percorrer o arquivo binário com os ids dos grupos, o
  // arranjo lotofacil_combinações, terá a soma da frequência de todas as combinações.

  try
     SetLength(lotofacil_combinacoes, LOTOFACIL_TOTAL_ITENS + 1, 2);

     ltf_arquivo := TFileStream.Create(diretorio_dos_arquivos + nome_dos_arquivos[qt_bolas_por_grupo], fmOpenRead);

     if ltf_arquivo.Size <= 0 then begin
        fStatus_Mensagem := 'Arquivo binário de grupos vazio.';
        SetLength(lotofacil_combinacoes, 0);
        Synchronize(@DoStatus_Erro);
        Exit;
     end;

  Except
    On exc:Exception do begin
        fStatus_Mensagem := 'Erro: ' + exc.Message;
        Exibir_Mensagem_de_Termino;
        SetLength(lotofacil_combinacoes, 0);
        Synchronize(@DoStatus_Erro);
        Exit;
    end;
  end;

  // Vamos tentar alocar memória
  try
    buffer_rd_lotofacil_arquivo := AllocMem(total_max_de_bytes_a_ler);
  except
    On exc: Exception do begin
      fStatus_Mensagem := 'Erro: ' + exc.Message;
      Exibir_Mensagem_de_Termino;
      SetLength(lotofacil_combinacoes, 0);
      Synchronize(@DoStatus_Erro);
      Exit;
    end;
  end;

  // Ler o arquivo binário que contém pra cada combinação possível da lotofacil,
  // os grupos que aquela combinação contém.
  total_de_bytes_lidos := ltf_arquivo.Read(buffer_rd_lotofacil_arquivo^, total_max_de_bytes_a_ler);
  while total_de_bytes_lidos > 0 do begin
        registros_lidos := total_de_bytes_lidos div bytes_por_registro;

        // Aponta pra o primeiro byte
        pt_buffer := buffer_rd_lotofacil_arquivo;

        for uA := 0 to Pred(registros_lidos) do begin
             ltf_id := pt_buffer^.ltf_id;
             ltf_qt := pt_buffer^.ltf_qt;
             grp_id := pt_buffer^.grp_id;

             // Garantir que ltf_id esteja dentro da faixa.
             if (ltf_id < 0) or (ltf_id > LOTOFACIL_TOTAL_ITENS) then begin
               fStatus_Mensagem:= 'Erro, ltf_id inválido.';
               Synchronize(@DoStatus_Erro);
               Exit;
             end;

             // Índice 0, armazena ltf_qt.
             // Índice 1, armazena a soma das frequências.
             lotofacil_combinacoes[ltf_id][0] := ltf_qt;

             frequencia_do_grp_id := frequencia_por_grupo[grp_id];
             soma_frequencia := lotofacil_combinacoes[ltf_id][1] + frequencia_do_grp_id;
             lotofacil_combinacoes[ltf_id][1] := soma_frequencia;

             Inc(qt_linhas_processadas);
             if (qt_linhas_processadas mod total_de_linhas_antes_de_exibir) = 0 then begin
                fStatus_Mensagem := 'Lendo arquivo binário, ltf_id atual: ' + IntToStr(ltf_id);
                Synchronize(@DoStatus);
             end;

             Inc(pt_buffer, 1);
        end;

        total_de_bytes_lidos := ltf_arquivo.Read(buffer_rd_lotofacil_arquivo^, total_max_de_bytes_a_ler);
  end;

  FreeMem(buffer_rd_lotofacil_arquivo);
  FreeAndNil(ltf_arquivo);

  // Gravar_Soma_Frequencia_no_banco_de_dados;
  // Gravar_Soma_Frequencia_no_banco_de_dados_2
  //Gravar_Soma_Frequencia_no_banco_de_dados_3;
  Gravar_Soma_Frequencia_no_banco_de_dados_4

end;

{
 Após obtermos a soma de frequência de cada combinação, iremos gravar os dados na tabela
 'lotofacil.lotofacil_num_bolas_frequencia_concurso'
}
procedure TLotofacilSomaFrequenciaThread.Gravar_Soma_Frequencia_no_banco_de_dados_4;
const
  LTF_ID_ULTIMO_INDICE = 6874010;
  TOTAL_DE_REGISTROS_A_INSERIR = 500000;
var
  sql_registros: TSqlQuery;
  lista_sql_a_inserir: TStringList;

  uA, qt_registros_lidos: Integer;


  sql_a_inserir: String;
begin

  // Em postgresql, é possível inserir mais de 2 registros ao mesmo tempo desta forma:
  // Insert into tabela (campo1, campo2) values
  //  (valor1, valor2)
  // ,(valor1, valor2)
  // ,(valor1, valor2)

  fStatus_Mensagem := 'Gravando no banco de dados... Aguarde...';
  Synchronize(@DoStatus);

  // Agora, vamos inserir o conteúdo na tabela 'lotofacil_num_bolas
  if Not Assigned(dmLotofacil) then begin
     dmLotofacil := TdmLotofacil.Create(objParent_Component);
  end;

  try
    dmLotofacil.pgLTK.Transaction.StartTransaction;

    sql_registros := dmLotofacil.sqlLotofacil;
    sql_registros.Database := dmLotofacil.pgLTK;
    sql_registros.Active := false;
    sql_registros.Sql.Clear;
    sql_registros.Sql.Add('Truncate lotofacil.lotofacil_num_bolas_concurso');
    sql_registros.ExecSQL;

    // Vamos preparar a consulta e depois, somente alterar os parâmetros.
    sql_a_inserir := 'Insert into lotofacil.lotofacil_num_bolas_concurso ' +
                   '(ltf_id, ltf_qt, concurso, concurso_soma_frequencia_bolas) values ' +
                   '(:$1, :$2, :$3, :$4)';

    qt_registros_lidos := 0;

    lista_sql_a_inserir := TStringList.Create;

    // Vamos percorrer cada registro.
    for uA := 1 to LTF_ID_ULTIMO_INDICE do
    begin

      // Iremos gerar um sql dinamico desta forma:
      // Insert into tabela (campo1, campo) values
      // (valor1, valor2),
      // ,(valor1, valor2)
      // Observe, que há uma vírgula separando cada registro:
      // (valor1, valor2), (valor1, valor2).
      // Então, toda vez que o registro for maior que 1, iremos inserir
      // a vírgula.
      if qt_registros_lidos <> 0 then begin
        sql_a_inserir := sql_a_inserir + ',';
      end
      else begin
        lista_sql_a_inserir.Clear;
        lista_sql_a_inserir.Add('Insert into lotofacil.lotofacil_num_bolas_concurso ' +
                   '(ltf_id, ltf_qt, concurso, concurso_soma_frequencia_bolas) values ');
        sql_a_inserir := '';
      end;

      sql_a_inserir := sql_a_inserir + Format('(%d,%d,%d,%d)',
                       [uA, lotofacil_combinacoes[uA, 0], concurso_final, lotofacil_combinacoes[uA, 1]]);
      lista_sql_a_inserir.add(sql_a_inserir);
      sql_a_inserir := '';

      Inc(qt_registros_lidos);

      // A cada 10 mil registros lidos, iremos inserir no banco.
      if qt_registros_lidos = TOTAL_DE_REGISTROS_A_INSERIR then begin
        qt_registros_lidos := 0;
        sql_registros.Sql.Clear;
        sql_registros.Sql.Text := lista_sql_a_inserir.Text;
        sql_registros.ExecSql;
        fStatus_Mensagem:= 'Inserindo registro, ltf_id: ' + IntToStr(uA);
        Synchronize(@DoStatus);
      end;

    end;

    if qt_registros_lidos <> 0 then begin
     qt_registros_lidos := 0;
     qt_registros_lidos := 0;
     sql_registros.Sql.Clear;
     sql_registros.Sql.Text := lista_sql_a_inserir.Text;
     sql_registros.ExecSql;
     fStatus_Mensagem:= 'Inserindo registro, ltf_id: ' + IntToStr(uA);
     Synchronize(@DoStatus);
    end;

    dmLotofacil.pgLTK.Transaction.Commit;
    sql_registros.Close;
    dmLotofacil.pgLTK.Close;

  except
    on Exc: EDataBaseError do
    begin
      fStatus_Mensagem := 'Erro: ' + Exc.Message;
      Synchronize(@DoStatus_Erro);
      Exit;
    end;
  end;

  fStatus_Mensagem := 'Soma da frequência das bolas em cada combinação atualizada ' +
                      'com a precisão de ' + IntToStr(qt_bolas_por_grupo) + ' bolas por grupo.' + #10#13;

  Exibir_Mensagem_de_Termino;
  Synchronize(@DoStatus_Concluido);

end;


{
 Exibe mensagem de término pra o usuário.
}
procedure TLotofacilSomaFrequenciaThread.Exibir_Mensagem_de_Termino;
begin
  fTempo_Fim := Now;
  fStatus_Mensagem:= fStatus_Mensagem + #10#13 +
                            'Início: ' + FormatDateTime('hh:nn:ss.zzz', fTempo_Inicio) + #10#13 +
                            'Fim: ' + FormatDateTime('hh:nn:ss.zzz', fTempo_Fim);
  fStatus_Mensagem := fStatus_Mensagem + #10#13 + 'Tempo decorrido:' + #10#13 +
                      IntToStr(HoursBetween(fTempo_Inicio, fTempo_fim)) + ':' +
                      IntToStr(MinutesBetween(fTempo_Inicio, fTempo_fim) mod 60) + ':' +
                      IntToStr(SecondsBetween(fTempo_Inicio, fTempo_fim) mod 60);
end;

constructor TLotofacilSomaFrequenciaThread.Create(objParent : TComponent; CreateSuspended : Boolean);
begin
  inherited Create(CreateSuspended);

  concurso_inicial := 0;
  concurso_final := -1;
  qt_bolas_por_grupo := -1;
  objParent_Component := objParent;
end;



end.

