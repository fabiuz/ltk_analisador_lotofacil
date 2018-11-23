unit uLotofacilNovosRepetidos;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, dbugintf, grids, ZConnection, ZDataset ;

//procedure CarregarNovosRepetidos(objControle: TStringGrid);
//procedure ConfigurarControlesNovosRepetidosAgrupado(objControle: TStringGrid);
//procedure CarregarNovosRepetidosConsolidadoIntervaloConcurso(objControle: TStringGrid; concursoInicial, concursoFinal: integer);

procedure ConfigurarControlesNovosRepetidosPorConcurso(objControle: TStringGrid);
//procedure CarregarNovosRepetidosPorConcurso(objControle: TStringGrid);

type
  TLotofacilNovosRepetidosStatus = procedure (ltf_msg: string) of object;
  TLotofacilNovosRepetidosStatusAtualizacao = procedure (ltf_id: LongWord; ltf_qt: Byte) of object;
  TLotofacilNovosRepetidosStatusErro =  procedure(ltf_erro: string) of object;
  TLotofacilNovosRepetidosStatusConcluido = procedure(ltf_status: string) of object;

  TLotofacilBolasArquivo = record
    ltf_id : LongWord;   // 4 bytes.
    ltf_qt : Byte;
    ltf_bolas: array [0..17] of Byte;
  end;


type

  { TLotofacilNovosRepetidos }

  TLotofacilNovosRepetidos = class(TThread)
      fStatus              : TLotofacilNovosRepetidosStatus;
      fStatus_Atualizacao   : TLotofacilNovosRepetidosStatusAtualizacao;
      fStatus_Erro          : TLotofacilNovosRepetidosStatusErro;
      fStatus_Concluido     : TLotofacilNovosRepetidosStatusConcluido;
      fConcurso            : Integer;
      fLtf_id              : Integer;
      fLtf_qt              : Integer;
      fStatus_Mensagem                 : AnsiString;
      fStatus_Mensagem_Erro            : AnsiString;
      lotofacil_bolas_do_concurso: array[0..15] of Integer;

      f_ltf_id_bolas_na_mesma_coluna : array of array of array of byte;

      fComponentParent: TComponent;
      fParar: Boolean;

      fInicio_da_atualizacao : TDateTime;
      fFim_da_atualizacao : TDateTime;

      f_sql_conexao: TZConnection;

    private
      // procedure AtualizarNovosRepetidos;
      // procedure AtualizarNovosRepetidos_2;
      //procedure AtualizarNovosRepetidos_3;
      procedure AtualizarNovosRepetidos_4;
      procedure atualizar_resultado_novos_repetidos;
      procedure Exibir_Mensagem_de_Termino;
      //procedure GravarLinhasNoArquivo(arquivo_novos_repetidos : TFileStream; str_linhas : AnsiString);
      function ObterBolasDoConcurso(numero_do_concurso : Integer) : boolean;
      procedure AtualizarInterface;

      procedure DoStatus;
      procedure DoStatusAtualizacao;
      procedure DoStatusConcluido;
      procedure DoStatusErro;
      function Obter_id_de_comparacao_de_bolas_na_mesma_coluna(qt_de_bolas_comuns,
        qt_de_bolas_subindo, qt_de_bolas_descendo: Integer): Integer; inline;
      function Obter_todos_id_de_comparacao_de_bolas_na_mesma_coluna: boolean;

      public
      procedure verificar_tabela_de_id_novos_repetidos;

    public
      constructor Create (objComponent: TComponent; bCriarSuspenso : boolean ) ;
      procedure atualizar ( numero_do_concurso : Integer ) ;
      procedure Execute; override;

      property PararAtualizacao: boolean read fParar write fParar;

      property OnStatus: TLotofacilNovosRepetidosStatus read fStatus write fStatus;
      property OnStatusAtualizacao: TLotofacilNovosRepetidosStatusAtualizacao read fStatus_Atualizacao write fStatus_Atualizacao;
      property OnStatusConcluido: TLotofacilNovosRepetidosStatusConcluido read fStatus_Concluido write fStatus_Concluido;
      property OnStatusErro: TLotofacilNovosRepetidosStatusErro read fStatus_Erro write fStatus_Erro;

      property sql_conexao: TZconnection read f_sql_conexao write f_sql_conexao;

      property concurso: Integer read fConcurso write fConcurso;

    public



  end;

implementation
uses
  uLotofacilModulo, sqlDb, db, dialogs, DateUtils, Math;

//procedure ConfigurarControlesNovosRepetidosAgrupado(objControle: TStringGrid);
//var
//  indice_ultima_coluna, uA: Integer;
//  novos_repetidos_campos: array[0..5] of string = (
//                    'novos_repetidos_id',
//                    'novos',
//                    'repetidos',
//                    'ltf_qt',
//                    'res_qt',
//                    'marcar');
//  coluna_atual : TGridColumn;
//begin
//  // No controle novo, haverá as colunas:
//  // novos_repetidos_id
//  // novos
//  // repetidos
//  // ltf_qt
//  // res_qt
//  // marcar
//
//  indice_ultima_coluna := High(novos_repetidos_campos);
//
//  objControle.Columns.Clear;
//  for uA := 0 to indice_ultima_Coluna do begin
//    coluna_atual := objControle.Columns.Add;
//    coluna_atual.title.Alignment := TAlignment.taCenter;
//    coluna_atual.Alignment := TAlignment.taCenter;
//    coluna_atual.title.Caption := novos_repetidos_campos[uA];
//    objControle.Cells[uA, 0] := novos_repetidos_campos[uA];
//  end;
//
//  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
//  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
//  objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;
//
//  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
//  objControle.FixedCols := 0;
//  objControle.FixedRows := 1;
//end;

//procedure CarregarNovosRepetidos(objControle: TStringGrid);
//var
//  strSql: TStrings;
//  dsLotofacil: TSqlQuery;
//  uLinha: integer;
//  qtRegistros : LongInt;
//begin
//  ConfigurarControlesNovosRepetidosAgrupado(objControle);
//
//  // Inicia o módulo de dados.
//  dmLotofacil := TdmLotofacil.Create(objControle.Parent);
//
//  strSql := TStringList.Create;
//
//  strSql.add('Select novos_repetidos_id, novos, repetidos, ltf_qt, res_qt from');
//  strSql.add('lotofacil.v_lotofacil_resultado_novos_repetidos_agrupado');
//  strSql.add('order by res_qt desc, ltf_qt desc');
//
//  dsLotofacil := dmLotofacil.sqlLotofacil;
//
//  dsLotofacil.Active := False;
//  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
//  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
//  dmLotofacil.sqlLotofacil.UniDirectional := false;
//  dmLotofacil.sqlLotofacil.Prepare;
//  dsLotofacil.Open;
//
//  // A propriedade recordCount retorna 10 por padrão, pra pegar todos os dados
//  // vamos pra o último registro.
//  dsLotofacil.First;
//  dsLotofacil.Last;
//  qtRegistros := dsLotofacil.RecordCount;
//
//  if qtRegistros = 0 then
//  begin
//       objControle.Columns.Clear;
//    objControle.RowCount := 1;
//    objControle.Cells[0, 0] := 'Não há registros...';
//    // Redimensiona as colunas.
//    objControle.AutoSizeColumns;
//    exit;
//  end;
//
//  // Devemos, 1 registro a mais por causa do cabeçalho.
//  objControle.RowCount := qtRegistros + 1;
//
//
//  // Agora, iremos percorrer o registro e inserir na grade de strings.
//  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
//  // na linha 1.
//  uLinha := 1;
//  dsLotofacil.First;
//  while dsLotofacil.EOF = False do
//  begin
//    // As células são strings, entretanto, não iremos atribuir o string diretamente,
//    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
//    // string, assim, se o campo for zero, não aparece nulo, em branco.
//    objControle.Cells[0, uLinha] := IntToSTr(dsLotofacil.FieldByName('novos_repetidos_id').AsInteger);
//    objControle.Cells[1, uLinha] := IntToStr(dsLotofacil.FieldByName('novos').AsInteger);
//    objControle.Cells[2, uLinha] := IntToSTr(dsLotofacil.FieldByName('repetidos').AsInteger);
//    objControle.Cells[3, uLinha] := IntToStr(dsLotofacil.FieldByName('ltf_qt').AsInteger);
//    objControle.Cells[4, uLinha] := IntToSTr(dsLotofacil.FieldByName('res_qt').AsInteger);
//    objControle.Cells[5, uLinha] := '0';
//
//    dsLotofacil.Next;
//    Inc(uLinha);
//  end;
//
//  // Oculta a primeira coluna
//  objControle.Columns[0].Visible := false;
//
//  // Fecha o dataset.
//  dsLotofacil.Close;
//
//  // Redimensiona as colunas.
//  objControle.AutoSizeColumns;
//
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//end;

{
 Carrega o controle sgrParImparPorConcurso, neste caso, o usuário deve informar
 um concurso inicial e um concurso final
}
//procedure CarregarNovosRepetidosConsolidadoIntervaloConcurso(
//  objControle: TStringGrid; concursoInicial, concursoFinal: integer);
//const
//  novos_repetidos_campos: array[0..4] of string = (
//    'novos_repetidos_id',
//    'novos',
//    'repetidos',
//    'ltf_qt',
//    'res_qt'
//    );
//var
//  strSql: TStrings;
//  dsLotofacil: TSqlQuery;
//  uLinha, uA: integer;
//  qt_registros: longint;
//  concurso_parametro: TParam;
//begin
//  // Cria o sql
//  // No banco de dados alteramos o nome da função
//  // de: fn_lotofacil_resultado_novos_repetidos_agrupado_intervalo_concurso
//  // pra: fn_ltf_resultado_novos_repetidos_agrupado_intervalo_concurso
//  strSql := TStringList.Create;
//  strSql.add('Select novos_repetidos_id, novos, repetidos, ltf_qt, res_qt from');
//  strSql.add('lotofacil.fn_ltf_resultado_novos_repetidos_agrupado_intervalo_concurso($1, $2)');
//  strSql.add('order by res_qt desc, ltf_qt desc');
//
//  // Inicia o módulo de dados.
//  if dmLotofacil = nil then
//  begin
//    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
//  end;
//  dsLotofacil := dmLotofacil.sqlLotofacil;
//
//  dsLotofacil.Active := False;
//  dsLotofacil.DataBase := dmLotofacil.pgLtk;
//  dsLotofacil.SQL.Text := strSql.Text;
//  dsLotofacil.UniDirectional := False;
//
//  // Insere os parâmetros.
//  concurso_parametro := dsLotofacil.Params.CreateParam(TFieldType.ftInteger,
//    '$1', TParamType.ptInput);
//  concurso_parametro.AsInteger := concursoInicial;
//
//  concurso_parametro := dsLotofacil.Params.CreateParam(TFieldType.ftInteger,
//    '$2', TParamType.ptInput);
//  concurso_parametro.AsInteger := concursoFinal;
//
//  try
//     dsLotofacil.Prepare;
//     dsLotofacil.Open;
//  except
//    On exc: EDataBaseError do
//    begin
//       MessageDlg('Erro', 'Erro: ' + exc.Message, mtError, [mbok], 0);
//       Exit;
//    end;
//  end;
//
//  // RecordCount retorna por padrão 10, então, pra retornar a quantidade certa
//  // iremos percorrer do ínicio pra o fim, assim, apos isto temos a quantidade de
//  // registros.
//  dsLotofacil.First;
//  dsLotofacil.Last;
//  qt_registros := dsLotofacil.RecordCount;
//
//  if qt_registros = 0 then
//  begin
//    objControle.Columns.Clear;
//    objControle.Columns.Add;
//    objControle.RowCount := 1;
//    objControle.Cells[0, 0] := 'Não há registros...';
//    // Redimensiona as colunas.
//    objControle.AutoSizeColumns;
//    exit;
//  end;
//
//  ConfigurarControlesNovosRepetidosAgrupado(objControle);
//
//  // Inserir 1 registro a mais por causa do cabeçalho.
//  objControle.RowCount := qt_registros + 1;
//
//  // Agora, iremos percorrer o registro e inserir na grade de strings.
//  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
//  // na linha 1.
//  uLinha := 1;
//  dsLotofacil.First;
//  while dsLotofacil.EOF = False do
//  begin
//    // As células são strings, entretanto, não iremos atribuir o string diretamente,
//    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
//    // string, assim, se o campo for zero, não aparece nulo, em branco.
//    for uA := 0 to High(novos_repetidos_campos) do
//    begin
//      objControle.Cells[uA, uLinha] :=
//        IntToStr(dsLotofacil.FieldByName(novos_repetidos_campos[uA]).AsInteger);
//    end;
//    objControle.Cells[Length(novos_repetidos_campos), uLinha] := '0';
//
//    dsLotofacil.Next;
//    Inc(uLinha);
//  end;
//
//  // Oculta a primeira coluna
//  objControle.Columns[0].Visible := False;
//
//  // Fecha o dataset.
//  dsLotofacil.Close;
//
//  // Redimensiona as colunas.
//  objControle.AutoSizeColumns;
//
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//
//  FreeAndNil(strSql);
//end;

procedure ConfigurarControlesNovosRepetidosPorConcurso(objControle: TStringGrid);
//const
//  // Nome das colunas que estarão no controle.
//  novos_repetidos_campo: array[0..2] of string = (
//    'concurso',
//    'par',
//    'impar'
//    );
//var
//  indice_ultima_coluna, uA: integer;
//  coluna_atual: TGridColumn;
begin

  //// Evitar que adicionemos novas colunas, se já houver.
  //objControle.Columns.Clear;
  //
  //// Adicionar colunas.
  //indice_ultima_coluna := High(novos_repetidos_campo);
  //for uA := 0 to indice_ultima_coluna do
  //begin
  //  coluna_atual := objControle.Columns.Add;
  //  coluna_atual.title.Alignment := TAlignment.taCenter;
  //  coluna_atual.Alignment := TAlignment.taCenter;
  //  coluna_atual.title.Caption := novos_repetidos_campo[uA];
  //  objControle.Cells[uA, 0] := novos_repetidos_campo[uA];
  //end;
  //
  //// A primeira coluna é o campo id, que passou quando iremos gerar os ids,
  //// necessita ficar oculta.
  //// objControle.Columns[0].Visible := False;
  //
  //// A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  //// da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  ////objControle.Columns[indice_ultima_coluna].ButtonStyle :=     TColumnButtonStyle.cbsCheckboxColumn;
  //
  //// Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  //objControle.RowCount := 1;
  //objControle.FixedRows := 1;
  //objControle.FixedCols := 0;
  //
end;

{
 Carrega o controle com todas as combinações pares e ímpares de todos os
 concursos que saíram em ordem decrescente de concurso.
}
//procedure CarregarNovosRepetidosPorConcurso(objControle: TStringGrid);
//const
//  externo_interno_campos: array[0..2] of string = (
//    'concurso',
//    'novos',
//    'repetidos'
//    );
//var
//  strSql: TStrings;
//  dsLotofacil: TSqlQuery;
//  uLinha, uA: integer;
//  qt_registros: longint;
//
//begin
//  // Configurar controle.
//  ConfigurarControlesNovosRepetidosPorConcurso(objControle);
//
//  // Cria o sql
//  strSql := TStringList.Create;
//  strSql.add('Select concurso, novos, repetidos from');
//  strSql.add('lotofacil.v_lotofacil_resultado_novos_repetidos_por_concurso');
//  strSql.add('order by concurso desc');
//
//  // Inicia o módulo de dados.
//  if dmLotofacil = nil then
//  begin
//    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
//  end;
//  dsLotofacil := dmLotofacil.sqlLotofacil;
//
//  dsLotofacil.Active := False;
//  dsLotofacil.DataBase := dmLotofacil.pgLtk;
//  dsLotofacil.SQL.Text := strSql.Text;
//  dsLotofacil.UniDirectional := False;
//
//  dsLotofacil.Prepare;
//  dsLotofacil.Open;
//
//  // RecordCount retorna por padrão 10, então, pra retornar a quantidade certa
//  // iremos percorrer do ínicio pra o fim, assim, apos isto temos a quantidade de
//  // registros.
//  dsLotofacil.First;
//  dsLotofacil.Last;
//  qt_registros := dsLotofacil.RecordCount;
//
//  if qt_registros = 0 then
//  begin
//    objControle.Columns.Clear;
//    objControle.Columns.Add;
//    objControle.RowCount := 1;
//    objControle.Cells[0, 0] := 'Não há registros...';
//    // Redimensiona as colunas.
//    objControle.AutoSizeColumns;
//    exit;
//  end;
//
//  // Inserir 1 registro a mais por causa do cabeçalho.
//  objControle.RowCount := qt_registros + 1;
//
//  // Agora, iremos percorrer o registro e inserir na grade de strings.
//  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
//  // na linha 1.
//  uLinha := 1;
//  dsLotofacil.First;
//  while dsLotofacil.EOF = False do
//  begin
//    // As células são strings, entretanto, não iremos atribuir o string diretamente,
//    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
//    // string, assim, se o campo for zero, não aparece nulo, em branco.
//    for uA := 0 to High(externo_interno_campos) do
//    begin
//      objControle.Cells[uA, uLinha] := IntToStr(dsLotofacil.FieldByName(externo_interno_campos[uA]).AsInteger);
//    end;
//    //objControle.Cells[High(externo_interno_campos), uLinha] := '0';
//
//    dsLotofacil.Next;
//    Inc(uLinha);
//  end;
//
//  // Oculta a primeira coluna
//  //objControle.Columns[0].Visible := False;
//
//  // Fecha o dataset.
//  dsLotofacil.Close;
//
//  // Redimensiona as colunas.
//  objControle.AutoSizeColumns;
//
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//end;


{ TLotofacilNovosRepetidos }

{
 Iremos usar o component: dmLotofacil, pra isto, precisamos passar um objeto Component.
}

constructor TLotofacilNovosRepetidos.Create ( objComponent : TComponent; bCriarSuspenso : boolean ) ;
begin
  inherited Create(bCriarSuspenso);
  fComponentParent := objComponent;;
end;

{
 Atualizar a tabela de novos x repetidos, baseado no número do concurso indicado.
 }
procedure TLotofacilNovosRepetidos.atualizar ( numero_do_concurso : Integer ) ;
begin
  fConcurso := numero_do_concurso;
end;


procedure TLotofacilNovosRepetidos.Execute;
begin
  if not ObterBolasDoConcurso(fConcurso) then begin
    Exit;
  end;

  //AtualizarNovosRepetidos;
  //AtualizarNovosRepetidos_2
  //AtualizarNovosRepetidos_3;
  AtualizarNovosRepetidos_4;

end;

{
 Obtém todas as bolas do concurso.
}
function TLotofacilNovosRepetidos.ObterBolasDoConcurso(numero_do_concurso: Integer): boolean;
var
  sql_registro : TSqlQuery;
  qt_registros : LongInt;
  uA : Integer;
begin
  if not Assigned(dmLotofacil) or (dmLotofacil = nil) then begin
    dmLotofacil := TdmLotofacil.Create(nil);
  end;

  try
    sql_registro := dmLotofacil.sqlLotofacil;
    sql_registro.Active := false;
    sql_registro.Database := dmLotofacil.pgLtk;

    sql_registro.Sql.Clear;
    sql_registro.Sql.Add('Select b_1, b_2, b_3, b_4, b_5,');
    sql_registro.Sql.Add('b_6, b_7, b_8, b_9, b_10, b_11, b_12, b_13, b_14, b_15');
    sql_registro.Sql.Add('from lotofacil.lotofacil_resultado_bolas');
    sql_registro.Sql.Add('where concurso = ' + IntToStr(numero_do_concurso));

    sql_registro.UniDirectional := False;
    sql_registro.Open;

    sql_registro.First;
    sql_registro.Last;
    qt_registros := sql_registro.RecordCount;
    sql_registro.First;

    if qt_registros = 0 then begin
      fStatus('Nenhum registro encontrado pra o concurso: ' + IntToStr(numero_do_concurso));
      Exit(False);
    end;

    for uA := 1 to 15 do begin
      lotofacil_bolas_do_concurso[uA] := sql_registro.FieldByName('b_' + IntToStr(uA)).AsInteger;
    end;

    sql_registro.Close;
    dmLotofacil.pgLTK.CloseDataSets;

  Except
    On exc: Exception do begin
      fStatus_Mensagem_Erro := 'Erro: ' + Exc.Message;
      Exit(False);
    end;
  end;

  Exit(True);
end;

//procedure TLotofacilNovosRepetidos.GravarLinhasNoArquivo(arquivo_novos_repetidos: TFileStream; str_linhas: AnsiString);
//const
//  BYTES_ALOCADOS: LongInt = 10240;
//var
//  buffer: array[0..10239] of Char;
//  qt_bytes_alocados , qt_caracteres: Integer;
//  str_temp : String;
//begin
//  qt_bytes_alocados := sizeof(buffer);
//
//  // Zera o arranjo pra evitar lixo de memória.
//  FillChar(buffer, BYTES_ALOCADOS, #0);
//
//  while str_linhas <> '' do
//  begin
//    try
//    qt_caracteres := Length(str_linhas);
//    if qt_caracteres > qt_bytes_alocados then begin
//      str_temp := copy(str_linhas, 0, qt_bytes_alocados);
//      str_temp := str_temp + #0;
//      strlcopy(buffer, pchar(str_temp), qt_bytes_alocados);
//
//      // +1 na linha abaixo, pois os caracteres começa na posição 1, se fosse
//      // zero, não seria necessário.
//      str_linhas := Copy(str_linhas, qt_bytes_alocados+1 , qt_caracteres);
//      qt_caracteres := qt_caracteres - qt_bytes_alocados;
//      arquivo_novos_repetidos.Write(buffer, qt_bytes_alocados);
//    end else begin
//        qt_caracteres := Length(str_linhas);
//        strlcopy(buffer, pchar(str_linhas), qt_caracteres);
//        str_linhas := '';
//        arquivo_novos_repetidos.Write(buffer, qt_caracteres);
//    end;
//
//    except
//      On exc: Exception do begin
//        fStatus_Mensagem_Erro := 'Erro, ' + exc.Message;
//        Exit;
//        ;
//      end;
//    end;
//  end;
//  str_linhas := '';
//end;

{
 Esta procedure atualiza a tabela lotofacil.lotofacil_novos_repetidos.
 Nesta procedure é comparado cada combinação com a combinação do concurso escolhido,
 Haverá nesta tabela tais campos:
 ltf_id                        ==> o identificador da combinação;
 ltf_qt                        ==> a quantidade de bolas desta combinação;
 novos_repetidos_id            ==> o identificador da combinação de novos x repetidos, há 11 identificadores
                               que identifica exclusivamente cada combinação;
 novos_repetidos_id_alternado  ==> Ao percorrer cada combinação, haverá um identificador sequencial pra cada tipo de
                               combinação novos x repetidos, por exemplo, se sair a combinação de id 0, duas vezes e
                               em seguida, sair a combinação de id 3, 5 vezes, haverá neste campo, pra cada combinação,
                               estes valores, na ordem que saiu os identificadores acima:
                               1, 2, pra o tipo id 0 da combinação novos x repetidos;
                               1, 2, 3, 4, 5, pra o tipo id 3, da combinação novos x repetidos.
                               Observe acima, que haverá identificadores sequenciais independentes pra cada id da combinação
                               novos x repetidos.
 qt_alt_seq                    ==> Aqui, no programa ele terá o valor zero, antigamente, era utilizado como um identificador
                               sequencial, pra pegar a quantidade de alternadores de diferenças. Isto em breve, será
                               excluído da tabela e do código dentro desta procedure.
}
//procedure TLotofacilNovosRepetidos.AtualizarNovosRepetidos;
//const
//  CRLF = {$IFDEF LINUX}
//                 #10;
//         {$ELSE}
//                {$IFDEF WINDOW}
//                        #10#13;
//                {$ELSE}
//                       #13;
//                 {$ENDIF}
//         {$ENDIF}
//
//var
//  ltf_id, ltf_qt: LongInt;
//  b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18: byte;
//  lotofacil_concurso : array[0..25] of Byte;
//  lotofacil_combinacao: array[0..25] of Byte;
//
//  {
//   Conforme relatado acima no comentário da procedure, pra cada combinação novos x repetidos, haverá
//   um identificador sequencial. A medida que fomos encontrando as combinações novos x repetidos, iremos
//   incrementar o identificador sequencial, pra cada combinação novos x repetidos haverá um identificador
//   sequencial independente.
//   Na lotofacil, há 11 identificadores de novos x repetidos, númerados de 0 a 10, então, no arranjo abaixo
//   criaremos um arranjo com 11 (onze) posições, pra armazenar cada id sequencial a medida que cada
//   combinação novos x repetidos for encontrado.
//  }
//  novos_repetidos_id_sequencial: array[0..10] of LongInt;
//
//  qt_repetidos , uA, qt_id_novos_repetidos: Integer;
//
//  arquivo_novos_repetidos: Text;
//  arq_novos_repetidos : TFileStream;
//
//  str_linhas: AnsiString;
//  qt_linhas: Integer;
//  qt_bytes_alocados: SizeInt;
//  bola_atual : Integer;
//
//  buffer : array[0..8195] of char;         // 10240 bytes alocados. 10 MB
//
//  nome_do_arquivo , str_temp: String;
//begin
//
//  qt_bytes_alocados := sizeof(buffer);
//
//  // Zera o conteúdo do buffer, pra evitar lixos de memória.
//  FillChar(buffer, qt_bytes_alocados, #0);
//
//  // Zera o arranjo pra evitar lixos de memória.
//  FillChar(lotofacil_concurso, sizeof(Byte) * 25, 0);
//
//    // Preenche o arranjo com as bolas do concurso.
//  for uA := 1 to 15 do begin
//    bola_atual := lotofacil_bolas_do_concurso[uA];
//    lotofacil_concurso[bola_atual] := 1;
//  end;
//
//  // Zera o arranjo pra não haver lixos de memória.
//  FillChar(lotofacil_combinacao, sizeof(Byte) * 25, 0);
//  FillChar(novos_repetidos_id_sequencial, sizeof(LongInt) * 10, 0);
//
//  // Abri arquivo pra gravação
//  nome_do_arquivo := './lotofacil_novos_repetidos_concurso_' + IntToStr(fConcurso) + '_' +
//                  FormatDateTime('YYYY_MM_DD-HH_NN_SS', Now) + '.csv';
//  try
//  arq_novos_repetidos := TFileStream.Create(nome_do_arquivo, fmCreate);
//  //FreeAndNil(arq_novos_repetidos);
//  //arq_novos_repetidos := TFileStream.Create(nome_do_arquivo, fmOpenWrite);
//  except
//    On exc: Exception do begin
//      fStatus_Erro('Erro: ' + exc.Message);
//      fStatus_Concluido('Erro: ' + exc.Message);
//      exit;
//    end;
//  end;
//
//  // Grava cabeçalho:
//  // ltf_id;ltf_qt;novo_repetidos_id;novos_repetidos_id_alternado;concurso;qt_alt_seq
//  str_linhas := 'ltf_id;ltf_qt;novo_repetidos_id;novos_repetidos_id_alternado;concurso;qt_alt_seq';
//
//  GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//  str_linhas := '';
//
//  ltf_id := 0;
//  ltf_qt := 15;
//
//  // qt_linhas, serve pra contar quantas linhas já foram analisadas, iremos definir o valor de 1000 linhas analisadas
//  // pra gravar no arquivo.
//  qt_linhas := -1;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//
//    qt_repetidos := 0;
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Mensagem_erro := 'Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    try
//    str_linhas := str_linhas + CRLF;
//    str_linhas := str_linhas + IntToStr(ltf_id);
//    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    str_linhas := str_linhas + ';0';
//
//    except
//      On exc: Exception do begin
//        fStatus_Mensagem_Erro := 'Erro, provavelmente, sem memória pra alocar mais caracteres pra o string.';
//        Synchronize(@DoStatusErro);
//        Exit;
//      end;
//    end;
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = 1000 then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//
//  ltf_qt := 16;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  for b16 := b15 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//    lotofacil_combinacao[b16] := 1;
//
//    qt_repetidos := 0;
//
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Erro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
//       Close(arquivo_novos_repetidos);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    str_linhas := str_linhas + CRLF;
//    str_linhas := str_linhas + IntToStr(ltf_id);
//    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    str_linhas := str_linhas + ';0';
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = 1000 then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  ltf_qt := 17;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  for b16 := b15 + 1 to 25 do
//  for b17 := b16 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//    lotofacil_combinacao[b16] := 1; lotofacil_combinacao[b17] := 1;
//
//    qt_repetidos := 0;
//
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Erro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
//       Close(arquivo_novos_repetidos);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    str_linhas := str_linhas + CRLF;
//    str_linhas := str_linhas + IntToStr(ltf_id);
//    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    str_linhas := str_linhas + ';0';
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = 1000 then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  ltf_qt := 18;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  for b16 := b15 + 1 to 25 do
//  for b17 := b16 + 1 to 25 do
//  for b18 := b17 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//    lotofacil_combinacao[b16] := 1; lotofacil_combinacao[b17] := 1; lotofacil_combinacao[b18] := 1;
//
//    qt_repetidos := 0;
//
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Erro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
//       Close(arquivo_novos_repetidos);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    // Grava no arquivo, os valores dos campos correspondentes.
//    str_linhas := str_linhas + CRLF;
//    str_linhas := str_linhas + IntToStr(ltf_id);
//    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    str_linhas := str_linhas + ';0';
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = 1000 then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  // Após sairmos de todos os loops, pode haver, ítens que não foram gravados no arquivos
//  // Por exemplo, a gravação é a cada 1000 linhas, então, devemos verificar se a variável
//  // qt_linhas é diferente de -1, se sim, há linhas a serem gravadas.
//  if qt_linhas <> -1 then
//  begin
//   qt_linhas := -1;
//   // Ao gravar, devemos verificar por possíveis erros.
//   try
//      GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//   except
//     On exc:Exception do
//     begin
//          fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//          Synchronize(@DoStatusErro);
//          Exit;
//     end;
//   end;
//  end;
//
//  FreeAndNil(arq_novos_repetidos);
//  arq_novos_repetidos := nil;
//
//  Synchronize(@DoStatusConcluido);
//end;

{
    Percorre todas as combinações de 15, 16, 17 e 18 bolas da lotofacil, pra cada combinação
    é contabilizada a quantidade de bolas que são iguais à combinação do concurso escolhido,
    em seguida, é gerada pra cada combinação da lotofacil um identificador que corresponde
    à quantidade de bolas que são comuns a ambas combinações e um identificador sequencial
    exclusivo pra cada quantidade de bolas que são iguais em ambas as combinações.
}
//procedure TLotofacilNovosRepetidos.AtualizarNovosRepetidos_2;
//const
//  CRLF = {$IFDEF LINUX}
//                 #10;
//         {$ELSE}
//                {$IFDEF WINDOWS}
//                        #10#13;
//                {$ELSE}
//                       #13;
//                 {$ENDIF}
//         {$ENDIF}
//  TOTAL_DE_REGISTROS = 6874010;
//  QT_REGISTROS_ANTES_DE_EXIBIR = 250000;
//type
//  ltf_novos_repetidos = record
//    ltf_id: integer;
//    ltf_qt: integer;
//    novos_repetidos_id: Integer;
//    id_sequencial: Integer;
//  end;
//  pt_ltf_novos_repetidos = ^ltf_novos_repetidos;
//var
//  pt_buffer_ltf_novos_repetidos : pt_ltf_novos_repetidos;
//  pt_buffer : pt_ltf_novos_repetidos;
//
//  ltf_id, ltf_qt: LongInt;
//  b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18: byte;
//  lotofacil_concurso : array[0..25] of Byte;
//  lotofacil_combinacao: array[0..25] of Byte;
//
//  // Armazena pra cada id de novos x repetidos um identificador sequencial independente.
//  novos_repetidos_id_sequencial: array[0..10] of LongInt;
//
//  qt_repetidos , uA, qt_id_novos_repetidos: Integer;
//
//  //arquivo_novos_repetidos: Text;
//  //arq_novos_repetidos : TFileStream;
//
//  //str_linhas: AnsiString;
//  qt_linhas: Integer;
//  qt_bytes_alocados: SizeInt;
//  bola_atual , total_de_bytes_alocados: Integer;
//
//  //buffer : array[0..8195] of char;         // 10240 bytes alocados. 10 MB
//
//  //nome_do_arquivo , str_temp: String;
//
//begin
//  // Vamos alocar memória.
//  total_de_bytes_alocados := sizeof(ltf_novos_repetidos) * TOTAL_DE_REGISTROS;
//  try
//     pt_buffer_ltf_novos_repetidos := GetMem(total_de_bytes_alocados);
//  except
//    On exc: Exception do begin
//      fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//      Synchronize(@DoStatusErro);
//    end;
//  end;
//
//  // Zera buffer de memória.
//  FillChar(pt_buffer_ltf_novos_repetidos^, total_de_bytes_alocados, 0);
//  FillChar(lotofacil_concurso, sizeof(Byte) * 25, 0);
//  FillChar(lotofacil_combinacao, sizeof(Byte) * 25, 0);
//  FillChar(novos_repetidos_id_sequencial, sizeof(LongInt) * 11, 0);
//
//    // Preenche o arranjo com as bolas do concurso.
//  for uA := 1 to 15 do begin
//    bola_atual := lotofacil_bolas_do_concurso[uA];
//    lotofacil_concurso[bola_atual] := 1;
//  end;
//
//  //// Abri arquivo pra gravação
//  //nome_do_arquivo := './lotofacil_novos_repetidos_concurso_' + IntToStr(fConcurso) + '_' +
//  //                FormatDateTime('YYYY_MM_DD-HH_NN_SS', Now) + '.csv';
//  //try
//  //arq_novos_repetidos := TFileStream.Create(nome_do_arquivo, fmCreate);
//  ////FreeAndNil(arq_novos_repetidos);
//  ////arq_novos_repetidos := TFileStream.Create(nome_do_arquivo, fmOpenWrite);
//  //except
//  //  On exc: Exception do begin
//  //    fStatus_Erro('Erro: ' + exc.Message);
//  //    fStatus_Concluido('Erro: ' + exc.Message);
//  //    exit;
//  //  end;
//  //end;
//
//  //// Grava cabeçalho:
//  //// ltf_id;ltf_qt;novo_repetidos_id;novos_repetidos_id_alternado;concurso;qt_alt_seq
//  //str_linhas := 'ltf_id;ltf_qt;novo_repetidos_id;novos_repetidos_id_alternado;concurso;qt_alt_seq';
//
//  //GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//  //str_linhas := '';
//
//  ltf_id := 0;
//  ltf_qt := 15;
//
//  // Vamos apontar pra o ínicio.
//  pt_buffer := pt_buffer_ltf_novos_repetidos;
//
//  // qt_linhas, serve pra contar quantas linhas já foram analisadas, iremos definir o valor de 1000 linhas analisadas
//  // pra gravar no arquivo.
//  qt_linhas := 1;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//
//    // Vamos contabilizar quantas bolas são comuns à combinação atual e
//    // à combinação do concurso escolhido.
//    qt_repetidos := 0;
//    for uA := 1 to 25 do begin
//      // No arranjo, em cada célula do arranjo, o valor 1 indica se a bola
//      // está naquela combinação.
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Mensagem_erro := 'Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//    // Pra cada combinação de novos x repetidos, haverá um identificador
//    // sequencial exclusivo.
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    // Agora, salva as informações:
//    pt_buffer^.ltf_id := ltf_id;
//    pt_buffer^.ltf_qt := ltf_qt;
//    pt_buffer^.novos_repetidos_id := qt_id_novos_repetidos;
//    pt_buffer^.id_sequencial := novos_repetidos_id_sequencial[qt_id_novos_repetidos];
//
//    Inc(pt_buffer);
//
//
//    //try
//    //str_linhas := str_linhas + CRLF;
//    //str_linhas := str_linhas + IntToStr(ltf_id);
//    //str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    //str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    //str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    //str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    //str_linhas := str_linhas + ';0';
//    //
//    //except
//    //  On exc: Exception do begin
//    //    fStatus_Mensagem_Erro := 'Erro, provavelmente, sem memória pra alocar mais caracteres pra o string.';
//    //    Synchronize(@DoStatusErro);
//    //    Exit;
//    //  end;
//    //end;
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = QT_REGISTROS_ANTES_DE_EXIBIR then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          //GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          //str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  ltf_qt := 16;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  for b16 := b15 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//    lotofacil_combinacao[b16] := 1;
//
//    qt_repetidos := 0;
//
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Erro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
//       //Close(arquivo_novos_repetidos);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    // Agora, salva as informações:
//    pt_buffer^.ltf_id := ltf_id;
//    pt_buffer^.ltf_qt := ltf_qt;
//    pt_buffer^.novos_repetidos_id := qt_id_novos_repetidos;
//    pt_buffer^.id_sequencial := novos_repetidos_id_sequencial[qt_id_novos_repetidos];
//
//    Inc(pt_buffer);
//
//    //str_linhas := str_linhas + CRLF;
//    //str_linhas := str_linhas + IntToStr(ltf_id);
//    //str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    //str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    //str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    //str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    //str_linhas := str_linhas + ';0';
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = QT_REGISTROS_ANTES_DE_EXIBIR then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          //GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          //str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  ltf_qt := 17;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  for b16 := b15 + 1 to 25 do
//  for b17 := b16 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//    lotofacil_combinacao[b16] := 1; lotofacil_combinacao[b17] := 1;
//
//    qt_repetidos := 0;
//
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Erro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
//       //Close(arquivo_novos_repetidos);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    // Agora, salva as informações:
//    pt_buffer^.ltf_id := ltf_id;
//    pt_buffer^.ltf_qt := ltf_qt;
//    pt_buffer^.novos_repetidos_id := qt_id_novos_repetidos;
//    pt_buffer^.id_sequencial := novos_repetidos_id_sequencial[qt_id_novos_repetidos];
//
//    Inc(pt_buffer);
//
//    //str_linhas := str_linhas + CRLF;
//    //str_linhas := str_linhas + IntToStr(ltf_id);
//    //str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    //str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    //str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    //str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    //str_linhas := str_linhas + ';0';
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = QT_REGISTROS_ANTES_DE_EXIBIR then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          //GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          //str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  ltf_qt := 18;
//  for b1 := 1 to 25 do
//  for b2 := b1 + 1 to 25 do
//  for b3 := b2 + 1 to 25 do
//  for b4 := b3 + 1 to 25 do
//  for b5 := b4 + 1 to 25 do
//  for b6 := b5 + 1 to 25 do
//  for b7 := b6 + 1 to 25 do
//  for b8 := b7 + 1 to 25 do
//  for b9 := b8 + 1 to 25 do
//  for b10 := b9 + 1 to 25 do
//  for b11 := b10 + 1 to 25 do
//  for b12 := b11 + 1 to 25 do
//  for b13 := b12 + 1 to 25 do
//  for b14 := b13 + 1 to 25 do
//  for b15 := b14 + 1 to 25 do
//  for b16 := b15 + 1 to 25 do
//  for b17 := b16 + 1 to 25 do
//  for b18 := b17 + 1 to 25 do
//  begin
//    inc(ltf_id);
//
//    fLtf_id := ltf_id;
//    fLtf_qt := ltf_qt;
//
//
//    // O valor 1 indica que a bola saiu na combinação.
//    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
//    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
//    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
//    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
//    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
//    lotofacil_combinacao[b16] := 1; lotofacil_combinacao[b17] := 1; lotofacil_combinacao[b18] := 1;
//
//    qt_repetidos := 0;
//
//    for uA := 1 to 25 do begin
//      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
//         Inc(qt_repetidos);
//      end;
//    end;
//
//    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
//    qt_id_novos_repetidos := 15 - qt_repetidos;
//
//    // O identificador novos x repetidos deve está na faixa de 0 a 11.
//    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
//       fStatus_Erro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
//       //Close(arquivo_novos_repetidos);
//       Exit;
//    end;
//
//    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;
//
//    // Agora, salva as informações:
//    pt_buffer^.ltf_id := ltf_id;
//    pt_buffer^.ltf_qt := ltf_qt;
//    pt_buffer^.novos_repetidos_id := qt_id_novos_repetidos;
//    pt_buffer^.id_sequencial := novos_repetidos_id_sequencial[qt_id_novos_repetidos];
//
//    Inc(pt_buffer);
//
//    // Grava no arquivo, os valores dos campos correspondentes.
//    //str_linhas := str_linhas + CRLF;
//    //str_linhas := str_linhas + IntToStr(ltf_id);
//    //str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
//    //str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
//    //str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
//    //str_linhas := str_linhas + ';' + IntToStr(fConcurso);
//    //str_linhas := str_linhas + ';0';
//
//    // A cada 1000 linhas, iremos armazenar no arquivo.
//    Inc(qt_linhas);
//    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));
//
//    if qt_linhas = 1000 then
//    begin
//       qt_linhas := -1;
//       // Ao gravar, devemos verificar por possíveis erros.
//       try
//          //GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//          //str_linhas := '';
//       except
//         On exc:Exception do
//         begin
//              fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//              Synchronize(@DoStatusErro);
//              Exit;
//         end;
//       end;
//    end;
//
//    // Reseta todos os valores;
//    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);
//
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//  end;
//
//  for uA := 1 to TOTAL_DE_REGISTROS do begin
//
//  end;
//
//
//
//
//  // Após sairmos de todos os loops, pode haver, ítens que não foram gravados no arquivos
//  // Por exemplo, a gravação é a cada 1000 linhas, então, devemos verificar se a variável
//  // qt_linhas é diferente de -1, se sim, há linhas a serem gravadas.
//  if qt_linhas <> -1 then
//  begin
//   qt_linhas := -1;
//   // Ao gravar, devemos verificar por possíveis erros.
//   try
//      //GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
//   except
//     On exc:Exception do
//     begin
//          fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//          Synchronize(@DoStatusErro);
//          Exit;
//     end;
//   end;
//  end;
//
//  //FreeAndNil(arq_novos_repetidos);
//  //arq_novos_repetidos := nil;
//
//  Synchronize(@DoStatusConcluido);
//end;

{
 Ler o arquivo binário 'lotofacil_num_bolas.ltfbin' que armazena todas as combinações
 da lotofacil e em seguida, compara cada bola da combinação do concurso escolhido
 pela bola correspondente de cada combinação possível na lotofacil, em seguida,
 insere na tabela 'lotofacil_novos_repetidos', o identificador da combinação de novos x repetidos
 que é um número que identifica cada combinação novos x repetidos da lotofacil.
 Dado duas combinação A e B, uma bola diz-se repetida, se a bola que está em B está
 também em A, e uma bola diz-se repetida, se a bola que está em B, não está em A.
 Também haverá a comparação da bola que está na mesma coluna em ambas as combinações,
 indicando se a bola se repete ou não, na mesma coluna em ambas as combinações.
}
//procedure TLotofacilNovosRepetidos.AtualizarNovosRepetidos_3;
//const
//  ARQUIVO_LTF_NUM_BOLAS = 'lotofacil_dados/lotofacil_bolas_novos_repetidos.ltf_bin';
//const
//  CRLF = {$IFDEF LINUX}
//                 #10;
//         {$ELSE}
//                {$IFDEF WINDOWS}
//                        #10#13;
//                {$ELSE}
//                       #13;
//                 {$ENDIF}
//         {$ENDIF}
//  TOTAL_DE_REGISTROS = 6874010;
//  QT_REGISTROS_ANTES_DE_EXIBIR = 250000;
//  TOTAL_DE_BYTES_MAXIMO = 1024 * 1024 * 1024 * 500;
//type
//  // ********************
//  // A estrutura abaixo é usada no arquivo 'lotofacil_num_bolas.ltf_bin'.
//  // A ordem dos campos abaixo é importante, não modifica, pois, o arquivo
//  // é armazenada conforme a estrutura abaixo.
//  // ********************
//  {$ALIGN 1}
//  ltf_novos_repetidos = record
//    ltf_id: Cardinal;                         // 4 bytes: de 1 a 6874010.
//    ltf_qt: byte;                             // 1 byte: de 15 a 18.
//    novos_repetidos_id: byte;                 // 1 byte: de 0 a 10.
//    qt_de_bolas_comuns_b1_a_b15: byte;        // 1 byte: de 0 a 10.
//    qt_de_bolas_subindo_b1_a_b15: byte;
//    qt_de_bolas_descendo_b1_a_b15: byte;
//    nao_usado: array[0..2] of byte;           // Não usado, somente pra alinhar o próximo campo
//    novos_repetidos_id_alternado: Cardinal;
//    id_sequencial: Integer;                   // id sequencial.
//    bolas: array[0..19] of ShortInt;          // No código, pode acontecer ao realizar a diferença
//                                              // o número ser negativo.
//                                              // 1 byte.
//  end;
//  pt_ltf_novos_repetidos = ^ltf_novos_repetidos;
//var
//  pt_buffer_ltf_novos_repetidos : pt_ltf_novos_repetidos;
//  pt_buffer : pt_ltf_novos_repetidos;
//
//  // ltf_id, ltf_qt,
//  total_de_bytes_lidos: LongInt;
//  // b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18: byte;
//  lotofacil_concurso : array[0..25] of Byte;
//  lotofacil_combinacao: array[0..25] of Byte;
//
//  // Armazena pra cada id de novos x repetidos um identificador sequencial independente.
//  novos_repetidos_id_sequencial: array[0..10] of Cardinal;
//
//  qt_repetidos , uA, qt_id_novos_repetidos: Integer;
//
//  //arquivo_novos_repetidos: Text;
//  //arq_novos_repetidos : TFileStream;
//
//  bola_atual , total_de_bytes_alocados, uB, qt_registros,
//    qt_registros_lidos, id_novos_repetidos,
//    qt_bolas_iguais_na_mesma_coluna, qt_bolas_subindo_na_mesma_coluna,
//    qt_bolas_descendo_na_mesma_coluna: Integer;
//  arquivo_novos_repetidos: TFileStream;
//  sql_registro, sql_query: TSQLQuery;
//  str_sql_inicio, str_sql_a_inserir: String;
//
//begin
//  // Armazena o horário de início da atualização.
//  fInicio_da_atualizacao:= Now;
//
//  // Vamos alocar memória.
//  total_de_bytes_alocados := sizeof(ltf_novos_repetidos) * TOTAL_DE_REGISTROS;
//  try
//     pt_buffer_ltf_novos_repetidos := GetMem(total_de_bytes_alocados);
//  except
//    On exc: Exception do begin
//      fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
//      Synchronize(@DoStatusErro);
//    end;
//  end;
//
//  // Zera buffer de memória.
//  FillChar(pt_buffer_ltf_novos_repetidos^, total_de_bytes_alocados, 0);
//  FillChar(lotofacil_concurso, sizeof(Byte) * 26, 0);
//  FillChar(novos_repetidos_id_sequencial, sizeof(Byte) * 11, 0);
//
//  // Preenche o arranjo com as bolas do concurso.
//  for uA := 1 to 15 do begin
//    bola_atual := lotofacil_bolas_do_concurso[uA];
//    lotofacil_concurso[bola_atual] := 1;
//  end;
//
//  // Verifica se arquivo existe, antes de abrir.
//  if not FileExists(ARQUIVO_LTF_NUM_BOLAS) then begin
//     fStatus_Mensagem_Erro := 'Erro, arquivo ' + ARQUIVO_LTF_NUM_BOLAS + ' não existe.';
//     Synchronize(@DoStatusErro);
//     Exit;
//  end;
//
//  // Abre o arquivo.
//  try
//     arquivo_novos_repetidos := TFileStream.Create(ARQUIVO_LTF_NUM_BOLAS, fmOpenRead);
//  except
//    On exc: Exception do begin
//      fStatus_Mensagem_Erro := 'Erro ao abrir arquivo.';
//      Synchronize(@DoStatusErro);
//      Exit;
//    end;
//  end;
//
//  // Verifica se o tamanho do arquivo, é igual ao número de bytes alocados.
//  if arquivo_novos_repetidos.Size <> total_de_bytes_alocados then begin
//     fStatus_Mensagem_Erro := 'Quantidade de bytes do arquivo inválido.';
//     Synchronize(@DoStatusErro);
//     Exit;
//  end;
//
//  // Aloca tudo de uma vez na memória.
//  total_de_bytes_lidos := arquivo_novos_repetidos.Read(pt_buffer_ltf_novos_repetidos^, total_de_bytes_alocados);
//  if total_de_bytes_lidos <> total_de_bytes_alocados then begin
//     fStatus_Mensagem_Erro := 'Arquivo incompleto, possíveis combinações em falta.';
//     Synchronize(@DoStatusErro);
//     Exit;
//  end;
//
//  // Percorre todas as combinações comparando os arquivos.
//  pt_buffer:= pt_buffer_ltf_novos_repetidos;
//  qt_registros_lidos := 0;
//  for uA := 1 to TOTAL_DE_REGISTROS do
//  begin
//    qt_repetidos := 0;
//
//    //fLtf_id := pt_buffer^.ltf_id;
//    //fLtf_qt := pt_buffer^.ltf_qt;
//
//    // Verifica o campo ltf_qt
//    if (pt_buffer^.ltf_qt < 15) or (pt_buffer^.ltf_qt > 18) then begin
//       fStatus_Mensagem_Erro:= 'Erro, ltf_qt inválido: ' + IntToStr(pt_buffer^.ltf_id);
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//    // No próximo loop, iremos comparar a combinação do concurso escolhido pelo
//    // usuário com cada combinação possível da lotofacil.
//    // Esta comparação será realização por coluna, será comparada a mesma coluna
//    // de ambas as combinações.
//    // A comparação será realizada comparando uma bola de uma combinação com
//    // a outra bola da outra combinação na mesma coluna.
//    qt_bolas_iguais_na_mesma_coluna := 0;
//    qt_bolas_subindo_na_mesma_coluna := 0;
//    qt_bolas_descendo_na_mesma_coluna := 0;
//
//    // No loop abaixo, iremos verificar se a mesma bola está em ambas as combinações
//    // E também iremos verificar se na mesma coluna em ambas as combinações,
//    // é a mesma bola ou bolas diferentes.
//    for uB := 1 to pt_buffer^.ltf_qt do
//    begin
//      // As bolas estão organizadas em ordem crescente, então devemos saber
//      // qual bola está naquela coluna, pra em seguida, verifica se está bola
//      // também está na outra combinação.
//      bola_atual := pt_buffer^.bolas[uB];
//      if (lotofacil_concurso[bola_atual] = 1) then begin
//       Inc(qt_repetidos);
//      end;
//
//      // Iremos comparar a combinação do concurso escolhido pelo usuário com cada
//      // combinação possível da lotofacil, neste caso, a comparação será por coluna.
//      // As colunas a serem comparadas, serão as colunas b1 a b15, pois, são comuns
//      // a todas as combinações de 15, 16, 17 e 18 bolas.
//      // Iremos comparar a bola de uma combinação com a bola de outra combinação
//      // que estão na mesma coluna.
//      // No registro que criamos, ao ler o conteúdo, o arranjo bolas contém
//      // as bolas de cada combinação, como não iremos armazenar na tabela do banco
//      // de dados tais as bolas, somente outros campos do registro, então
//      // iremos usar o próprio arranjo pra armazenar os cálculos de comparação.
//
//      // Só iremos comparar bolas das colunas b_1 a b_15 pois elas são comuns
//      // a todas as combinações de 15 a 18 bolas.
//      if uB <= 15 then
//      begin
//         pt_buffer^.bolas[uB] := pt_buffer^.bolas[uB] - lotofacil_bolas_do_concurso[uB];
//
//         // Se a diferença for:
//         // Zero, as bolas são iguais.
//         // Negativo, a bola da combinação atual é menor que a bola da combinação do concurso.
//         // Positivo, a bola da combinação atual é maior que a bola da combinação do concurso.
//         case sign(pt_buffer^.bolas[uB]) of
//              -1: Inc(qt_bolas_descendo_na_mesma_coluna);
//               0: Inc(qt_bolas_iguais_na_mesma_coluna);
//               1: Inc(qt_bolas_subindo_na_mesma_coluna);
//               else begin
//                 fStatus_Mensagem_Erro:= 'Bug: Função sign nunca retornar valores diferente de -1, 0, 1' +
//                                         'ltf_id: ' + IntToStr(pt_buffer^.ltf_id) + ', ' +
//                                         'uB: ' + IntToStr(uB) + ', bola atual: ' + IntToStr(pt_buffer^.bolas[uB]);
//                 Exibir_Mensagem_de_Termino;
//                 Synchronize(@DoStatusErro);
//                 FreeMem(pt_buffer_ltf_novos_repetidos);
//                 Exit;
//               end;
//         end;
//      end;
//    end;
//
//    // Verifica se a quantidade de repetidos está dentro da faixa válida pra lotofacil.
//    if (qt_repetidos < 5) and (qt_repetidos > 15) then begin
//       fStatus_Mensagem_Erro:= 'Erro, quantidade de repetidos x novos fora do intervalo de 0 a 10';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//    id_novos_repetidos := 15 - qt_repetidos;
//
//    // Pra cada quantidade de novos x repetidos, haverá um identificador sequencial,
//    // ou seja, cada quantidade terá um identificador sequencial indepedente das
//    // outras quantidades.
//    novos_repetidos_id_sequencial[id_novos_repetidos] := novos_repetidos_id_sequencial[id_novos_repetidos]  + 1;
//    pt_buffer^.id_sequencial := novos_repetidos_id_sequencial[id_novos_repetidos];
//
//    // A quantidade de repetidos na tabela lotofacil.lotofacil_novos_repetidos é
//    // igual ao identificador 'novos_repetidos_id'.
//    pt_buffer^.novos_repetidos_id := qt_repetidos;
//
//    // Aponta pra o próximo registro.
//    Inc(pt_buffer);
//
//    // Verifica se o usuário solicitou parar o processamento.
//    if self.Terminated then begin
//       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//       Synchronize(@DoStatusErro);
//       Exit;
//    end;
//
//    // Exibe a tela pra o usuário
//    if qt_registros_lidos mod 500000 = 0 then begin
//       fStatus_Mensagem:= 'Gerando id novos x repetidos, ltf_id: ' + IntToStr(pt_buffer^.ltf_id);
//       Synchronize(@DoStatus);
//       Synchronize(@DoStatusAtualizacao);
//    end;
//
//    Inc(qt_registros_lidos);
//
//  end;
//
//  // Fecha o arquivo.
//  FreeAndNil(arquivo_novos_repetidos);
//
//  // Ao saírmos do loop, devemos atualizar a tela pra indicar o último ítem
//  // foi gerado.
//  // Decrementa, pois, ao sair do loop, pt_buffer estará apontado pra um registro
//  // após o último.
//  Dec(pt_buffer);
//  fStatus_Mensagem:= 'Gerando id novos x repetidos, ltf_id: ' + IntToStr(pt_buffer^.ltf_id);
//  Synchronize(@DoStatus);
//  Synchronize(@DoStatusAtualizacao);
//
//  // Agora, inserir os dados no banco de dados.
//  if not Assigned(dmLotofacil) then begin
//   dmLotofacil := TDmLotofacil.Create(fComponentParent);
//  end;
//
//  try
//     sql_query := dmLotofacil.sqlLotofacil;
//     sql_query.DataBase := dmLotofacil.pgLTK;
//
//     if not dmLotofacil.pgLTK.Transaction.Active then begin
//        dmLotofacil.pgLTK.StartTransaction;
//     end;
//
//     fStatus_Mensagem:= fStatus_Mensagem + #10#13 +
//                        'Atualizando novos x repetidos, aguarde....';
//     Synchronize(@DoStatus);
//
//     sql_query.SQL.Clear;
//     sql_query.Sql.Add('truncate lotofacil.lotofacil_novos_repetidos');
//     sql_query.ExecSQL;
//
//     // Percorre todos os registros inserindo no banco de dados;
//     qt_registros_lidos := 0;
//
//     // A parte inicial do sql
//     str_sql_inicio := 'Insert into lotofacil.lotofacil_novos_repetidos';
//     str_sql_inicio := str_sql_inicio + '(ltf_id,ltf_qt';
//     str_sql_inicio := str_sql_inicio + ',novos_repetidos_id';
//     str_sql_inicio := str_sql_inicio + ',novos_repetidos_id_alternado';
//     str_sql_inicio := str_sql_inicio + ', qt_bolas_comuns_b1_a_b15';
//     str_sql_inicio := str_sql_inicio + ', qt_bolas_subindo_b1_a_b15';
//     str_sql_inicio := str_sql_inicio + ', qt_bolas_descendo_b1_a_b15';
//
//     for uA := 1 to 15 do begin
//       str_sql_inicio := str_sql_inicio + ', cmp_b' + IntToStr(uA);
//     end;
//
//     str_sql_inicio := str_sql_inicio + ',concurso,qt_alt_seq)values';
//
//     str_sql_a_inserir := '';
//     pt_buffer := pt_buffer_ltf_novos_repetidos;
//     for uA := 1 to TOTAL_DE_REGISTROS do
//     begin
//
//         if str_sql_a_inserir <> '' then begin
//            str_sql_a_inserir := str_sql_a_inserir + ',';
//         end;
//
//         str_sql_a_inserir := str_sql_a_inserir + '(';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.ltf_id) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.ltf_qt) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.novos_repetidos_id) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.novos_repetidos_id_alternado) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.qt_de_bolas_comuns_b1_a_b15) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.qt_de_bolas_subindo_b1_a_b15) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.qt_de_bolas_descendo_b1_a_b15) + ',';
//
//         for uB := 1 to 15 do begin
//             str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.bolas[uB]) + ',';
//         end;
//
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(fConcurso) + ',';
//         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.id_sequencial) + ')';
//
//         // A cada 250000 registros lidos, ou quando atingir mais de 500 mb
//         Inc(qt_registros_lidos);
//         if (Length(str_sql_a_inserir) > TOTAL_DE_BYTES_MAXIMO) or  (qt_registros_lidos mod 500000 = 0) then begin
//            sql_query.SQL.Clear;
//            sql_query.Sql.Add(str_sql_inicio);
//            sql_query.Sql.Add(str_sql_a_inserir);
//            sql_query.ExecSQL;
//
//            str_sql_a_inserir := '';
//
//            // fStatus_Mensagem := 'Inserindo registros... ltf_id: ' + IntToStr(ltf_id);
//            fStatus_Mensagem := 'Inserindo registros: ' + IntToStr(pt_buffer^.ltf_id) + ' de 6874010 [' +
//             Format('%.2f', [fLtf_id / 6874010 * 100]) + '%]';
//            Synchronize(@DoStatus);
//
//         end;
//
//         if qt_registros_lidos mod 500000 = 0 then begin
//            fStatus_Mensagem := 'Inserindo registros: ' + IntToStr(pt_buffer^.ltf_id) + ' de 6874010 [' +
//                                Format('%.2f', [pt_buffer^.ltf_id / 6874010 * 100]) + '%]';
//            Synchronize(@DoStatus);
//         end;
//
//         // Aponta pra o próximo registro.
//         Inc(pt_buffer);
//
//         // Verifica se o usuário solicitou cancelamento.
//         // Se sim, fazer rollback.
//         if self.Terminated then
//         begin
//            fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
//            Synchronize(@DoStatusErro);
//
//            dmLotofacil.pgLTK.Transaction.Rollback;
//            dmLotofacil.pgLTK.Close(true);
//            sql_query.Close;
//            FreeAndNil(dmLotofacil);
//            FreeMem(pt_buffer_ltf_novos_repetidos);
//            Exit;
//         end;
//     end;
//
//     // Se há registros ainda pra inserir, então, devemos inserí-los.
//     if str_sql_a_inserir <> '' then begin
//        sql_query.SQL.Clear;
//        sql_query.Sql.Add(str_sql_inicio);
//        sql_query.Sql.Add(str_sql_a_inserir);
//        sql_query.ExecSQL;
//
//        fStatus_Mensagem := 'Inserindo registros: ' + IntToStr(pt_buffer^.ltf_id) + ' de 6874010 [' +
//                            Format('%.2f', [pt_buffer^.ltf_id / 6874010 * 100]) + '%]';
//        Synchronize(@DoStatusAtualizacao);
//     end;
//
//     // Tudo ocorreu normalmente, então, confirmar transação.
//     dmLotofacil.pgLTK.Transaction.Commit;
//     dmLotofacil.pgLTK.Close(true);
//     sql_query.Close;
//     FreeAndNil(dmLotofacil);
//
//    fStatus_Mensagem := 'Inserindo registros: ' + IntToStr(fLtf_id) + ' de 6874010 [' +
//    Format('%.2f', [pt_buffer^.ltf_id / 6874010 * 100]) + '%]';
//    Synchronize(@DoStatus);
//    Synchronize(@DoStatusAtualizacao);
//
//  except
//        On Exc: EDatabaseError do
//        begin
//             dmLotofacil.pgLTK.Transaction.Rollback;
//             dmLotofacil.pgLTK.Close;
//             fStatus_Mensagem_Erro:= 'Erro: ' + Exc.Message;
//             Synchronize(@DoStatusErro);
//             Exit;
//        end;
//        On Exc: Exception do
//        begin
//          dmLotofacil.pgLTK.Transaction.Rollback;
//          dmLotofacil.pgLTK.Close;
//          fStatus_Mensagem_Erro:= 'Erro: ' + Exc.Message;
//          Synchronize(@DoStatusErro);
//          Exit;
//        end;
//  end;
//
//  // Se chegarmos aqui, quer dizer, que todos os ítens foram atualizados com sucesso!!!;
//  fStatus_Mensagem := 'Itens atualizado com sucesso!!!';
//  Exibir_Mensagem_de_Termino;
//
//  Synchronize(@DoStatusConcluido);
//
//  // Libera memória alocada.
//  FreeMem(pt_buffer_ltf_novos_repetidos);
//
//
//
//
//end;

procedure TLotofacilNovosRepetidos.AtualizarNovosRepetidos_4;
const
  ARQUIVO_LTF_NUM_BOLAS = '../analisador_lotofacil_dados/lotofacil_bolas_novos_repetidos.ltf_bin';
const
  CRLF = {$IFDEF LINUX}
                 #10;
         {$ELSE}
                {$IFDEF WINDOWS}
                        #10#13;
                {$ELSE}
                       #13;
                 {$ENDIF}
         {$ENDIF}
  TOTAL_DE_REGISTROS = 6874010;
  QT_REGISTROS_ANTES_DE_EXIBIR = 250000;
  TOTAL_DE_BYTES_MAXIMO = 10240;
type
  // ********************
  // A estrutura abaixo é usada no arquivo 'lotofacil_num_bolas.ltf_bin'.
  // A ordem dos campos abaixo é importante, não modifica, pois, o arquivo
  // é armazenada conforme a estrutura abaixo.
  // ********************
  {$ALIGN 1}
  ltf_novos_repetidos = record
    ltf_id: Cardinal;                         // 4 bytes: de 1 a 6874010.
    ltf_qt: byte;                             // 1 byte: de 15 a 18.
    novos_repetidos_id: byte;                 // 1 byte: de 0 a 10.
    qt_de_bolas_comuns_b1_a_b15: byte;        // 1 byte: de 0 a 10.
    qt_de_bolas_subindo_b1_a_b15: byte;
    qt_de_bolas_descendo_b1_a_b15: byte;
    cmp_b_id: byte;
    nao_usado: array[0..1] of byte;           // Não usado, somente pra alinhar o próximo campo
    novos_repetidos_id_alternado: Cardinal;
    id_sequencial: Integer;                   // id sequencial.
    bolas: array[0..19] of ShortInt;          // No código, pode acontecer ao realizar a diferença
                                              // o número ser negativo.
                                              // 1 byte.
  end;
  pt_ltf_novos_repetidos = ^ltf_novos_repetidos;
var
  pt_buffer_ltf_novos_repetidos : pt_ltf_novos_repetidos;
  pt_buffer : pt_ltf_novos_repetidos;

  // ltf_id, ltf_qt,
  total_de_bytes_lidos: LongInt;
  // b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18: byte;
  lotofacil_concurso : array[0..25] of Byte;

  // Armazena pra cada id de novos x repetidos um identificador sequencial independente.
  novos_repetidos_id_sequencial: array[0..10] of Cardinal;

  qt_repetidos , uA, qt_id_novos_repetidos: Integer;

  //arquivo_novos_repetidos: Text;
  //arq_novos_repetidos : TFileStream;

  bola_atual , total_de_bytes_alocados, uB, qt_registros,
    qt_registros_lidos, id_novos_repetidos,
    qt_bolas_iguais_na_mesma_coluna, qt_bolas_subindo_na_mesma_coluna,
    qt_bolas_descendo_na_mesma_coluna, tamanho_do_string,
    qt_max_de_bytes_ja_alocados, qt_de_bolas_comuns_na_mesma_coluna,
    qt_de_bolas_subindo_na_mesma_coluna,
    qt_de_bolas_descendo_na_mesma_coluna: Integer;
  arquivo_novos_repetidos: TFileStream;
  str_sql_inicio,
    str_sql_a_inserir: String;

  buffer_texto : PChar;
  sql_memory: TStringStream;

  sql_query: TSQLQuery;

begin
  // Armazena o horário de início da atualização.
  fInicio_da_atualizacao:= Now;

  // Vamos alocar memória.
  total_de_bytes_alocados := sizeof(ltf_novos_repetidos) * TOTAL_DE_REGISTROS;
  try
     pt_buffer_ltf_novos_repetidos := GetMem(total_de_bytes_alocados);
  except
    On exc: Exception do begin
      fStatus_Mensagem_Erro := 'Erro: ' + exc.Message;
      Synchronize(@DoStatusErro);
    end;
  end;

  // Zera buffer de memória.
  FillChar(pt_buffer_ltf_novos_repetidos^, total_de_bytes_alocados, 0);
  FillChar(lotofacil_concurso, sizeof(Byte) * 26, 0);
  FillChar(novos_repetidos_id_sequencial, sizeof(Cardinal) * 11, 0);

  // Preenche o arranjo com as bolas do concurso.
  for uA := 1 to 15 do begin
    bola_atual := lotofacil_bolas_do_concurso[uA];
    lotofacil_concurso[bola_atual] := 1;
  end;

  // Verifica se arquivo existe, antes de abrir.
  if not FileExists(ARQUIVO_LTF_NUM_BOLAS) then begin
     fStatus_Mensagem_Erro := 'Erro, arquivo ' + ARQUIVO_LTF_NUM_BOLAS + ' não existe.';
     Synchronize(@DoStatusErro);
     Exit;
  end;

  // Tenta abrir arquivo, se houver erro, devemos sair da atualização.
  try
     arquivo_novos_repetidos := TFileStream.Create(ARQUIVO_LTF_NUM_BOLAS, fmOpenRead);
  except
    On exc: Exception do begin
      fStatus_Mensagem_Erro := 'Erro ao abrir arquivo.';
      Synchronize(@DoStatusErro);
      Exit;
    end;
  end;

  // Verifica se o tamanho do arquivo, é igual ao número de bytes alocados.
  if arquivo_novos_repetidos.Size <> total_de_bytes_alocados then begin
     fStatus_Mensagem_Erro := 'Quantidade de bytes do arquivo inválido.';
     Synchronize(@DoStatusErro);
     Exit;
  end;

  // Aloca todo o conteúdo do arquivo na memória, é um arquivo binário de 275 Megabytes.
  total_de_bytes_lidos := arquivo_novos_repetidos.Read(pt_buffer_ltf_novos_repetidos^, total_de_bytes_alocados);
  if total_de_bytes_lidos <> total_de_bytes_alocados then begin
     fStatus_Mensagem_Erro := 'Arquivo incompleto, possíveis combinações em falta.';
     Synchronize(@DoStatusErro);
     Exit;
  end;

  // Antes de percorrer o buffer em memória do arquivo que lemos do disco
  // precisamos alocar memória pra o arranjo que armazenará o identificador
  // de comparação de bolas na mesma coluna.
  // TODO:
  //if Obter_todos_id_de_comparacao_de_bolas_na_mesma_coluna = false then begin
  //   FreeMem(pt_buffer_ltf_novos_repetidos);
  //   Exibir_Mensagem_de_Termino;
  //   Synchronize(@DoStatusErro);
  //   Exit;
  //end;

  pt_buffer:= pt_buffer_ltf_novos_repetidos;
  qt_registros_lidos := 0;
  for uA := 1 to TOTAL_DE_REGISTROS do
  begin
    qt_repetidos := 0;

    // Verifica se o campo ltf é válido.
    if (pt_buffer^.ltf_qt < 15) or (pt_buffer^.ltf_qt > 18) then begin
       fStatus_Mensagem_Erro:= 'Erro, ltf_qt inválido: ' + IntToStr(pt_buffer^.ltf_id);
       Synchronize(@DoStatusErro);
       Exit;
    end;

    // No próximo loop, iremos comparar a combinação do concurso escolhido pelo
    // usuário com cada combinação possível da lotofacil.
    // Esta comparação será realização por coluna, será comparada a mesma coluna
    // de ambas as combinações.
    // A comparação será realizada comparando uma bola de uma combinação com
    // a outra bola da outra combinação na mesma coluna.
    qt_de_bolas_comuns_na_mesma_coluna := 0;
    qt_de_bolas_subindo_na_mesma_coluna := 0;
    qt_de_bolas_descendo_na_mesma_coluna := 0;

    //pt_buffer^.qt_de_bolas_descendo_b1_a_b15 := 0;
    //pt_buffer^.qt_de_bolas_comuns_b1_a_b15 := 0;
    //pt_buffer^.qt_de_bolas_subindo_b1_a_b15 := 0;

    // No loop abaixo, iremos verificar se a mesma bola está em ambas as combinações
    // E também iremos verificar se na mesma coluna em ambas as combinações,
    // é a mesma bola ou bolas diferentes.
    for uB := 1 to pt_buffer^.ltf_qt do
    begin
      // As bolas estão organizadas em ordem crescente, então devemos saber
      // qual bola está naquela coluna, pra em seguida, verifica se está bola
      // também está na outra combinação.
      bola_atual := pt_buffer^.bolas[uB];
      if (lotofacil_concurso[bola_atual] = 1) then begin
       Inc(qt_repetidos);
      end;

      // Iremos comparar a combinação do concurso escolhido pelo usuário com cada
      // combinação possível da lotofacil, neste caso, a comparação será por coluna.
      // As colunas a serem comparadas, serão as colunas b1 a b15, pois, são comuns
      // a todas as combinações de 15, 16, 17 e 18 bolas.
      // Iremos comparar a bola de uma combinação com a bola de outra combinação
      // que estão na mesma coluna.
      // No registro que criamos, ao ler o conteúdo, o arranjo bolas contém
      // as bolas de cada combinação, como não iremos armazenar na tabela do banco
      // de dados tais as bolas, somente outros campos do registro, então
      // iremos usar o próprio arranjo pra armazenar os cálculos de comparação.

      // Só iremos comparar bolas das colunas b_1 a b_15 pois elas são comuns
      // a todas as combinações de 15 a 18 bolas.
      if uB <= 15 then
      begin
         pt_buffer^.bolas[uB] := pt_buffer^.bolas[uB] - lotofacil_bolas_do_concurso[uB];

         // Se a diferença for:
         // Zero, as bolas são iguais.
         // Negativo, a bola da combinação atual é menor que a bola da combinação do concurso.
         // Positivo, a bola da combinação atual é maior que a bola da combinação do concurso.
         case sign(pt_buffer^.bolas[uB]) of
              -1: Inc(qt_de_bolas_descendo_na_mesma_coluna);
               0: Inc(qt_de_bolas_comuns_na_mesma_coluna);
               1: Inc(qt_de_bolas_subindo_na_mesma_coluna);
               else begin
                 fStatus_Mensagem_Erro:= 'Bug: Função sign nunca retornar valores diferente de -1, 0, 1' +
                                         'ltf_id: ' + IntToStr(pt_buffer^.ltf_id) + ', ' +
                                         'uB: ' + IntToStr(uB) + ', bola atual: ' + IntToStr(pt_buffer^.bolas[uB]);
                 Exibir_Mensagem_de_Termino;
                 Synchronize(@DoStatusErro);
                 FreeMem(pt_buffer_ltf_novos_repetidos);
                 Exit;
               end;
         end;
      end;
    end;

    // Validar dados.
    //pt_buffer^.cmp_b_id:= Obter_id_de_comparacao_de_bolas_na_mesma_coluna(qt_de_bolas_comuns_na_mesma_coluna,
    //   qt_de_bolas_subindo_na_mesma_coluna, qt_de_bolas_descendo_na_mesma_coluna);
    //
    //
    //
    //if pt_buffer^.cmp_b_id= -1 then
    //   begin
    //      FreeMem(pt_buffer_ltf_novos_repetidos);
    //      Exibir_Mensagem_de_Termino;
    //      Synchronize(@DoStatusErro);
    //      Exit;
    //   end;
    //

    // Vamos garantir que está na faixa válida.
    if not(
       (qt_de_bolas_comuns_na_mesma_coluna in [0..15]) and
       (qt_de_bolas_subindo_na_mesma_coluna in [0..15]) and
       (qt_de_bolas_descendo_na_mesma_coluna in [0..15])
       )then begin
          fStatus_Mensagem_Erro:= 'Soma dos valores dos campos: ' +
          QuotedStr('qt_de_bolas_comuns_na_mesma_coluna') + ', ' +
          QuotedStr('qt_de_bolas_subindo_na_mesma_coluna') + ', ' +
          QuotedStr('qt_de_bolas_descendo_na_mesma_coluna') + ' não é igual a 15.';
          Exibir_Mensagem_de_Termino;
          Synchronize(@DoStatusErro);
          Exit;
       end;


    // TODO: Utilizar posteriormente.
    {
    pt_buffer^.cmp_b_id := f_ltf_id_bolas_na_mesma_coluna[qt_de_bolas_comuns_na_mesma_coluna,
                           qt_de_bolas_subindo_na_mesma_coluna, qt_de_bolas_descendo_na_mesma_coluna];
                           }

    // Verifica se a quantidade de repetidos está dentro da faixa válida pra lotofacil.
    if (qt_repetidos < 5) and (qt_repetidos > 15) then begin
       fStatus_Mensagem_Erro:= 'Erro, quantidade de repetidos x novos fora do intervalo de 0 a 10';
       Synchronize(@DoStatusErro);
       Exit;
    end;

    // Sempre estamos comparando todas as combinações de 15, 16, 17 e 18 bolas,
    // com a combinação de 15 bolas que é a combinação de 15 bolas que é sempre sorteada
    // no jogo da lotofacil.
    // A quantidade de bolas repetidas é no mínimo de 5 bolas e no máximo de 15 bolas.
    // A quantidade de novos é no mínimo de 0 bolas e no máximo de 10 bolas.
    // Pra obter a quantidade de bolas novas, fazemos a diferença de 15 bolas -
    // a quantidade de bolas repetidas.
    id_novos_repetidos := 15 - qt_repetidos;

    // Pra cada quantidade de novos x repetidos, haverá um identificador sequencial,
    // ou seja, cada quantidade terá um identificador sequencial indepedente das
    // outras quantidades.
    novos_repetidos_id_sequencial[id_novos_repetidos] := novos_repetidos_id_sequencial[id_novos_repetidos]  + 1;
    pt_buffer^.novos_repetidos_id_alternado := novos_repetidos_id_sequencial[id_novos_repetidos];

    // A quantidade de novos na tabela lotofacil.lotofacil_novos_repetidos é
    // igual ao identificador 'novos_repetidos_id'.
    pt_buffer^.novos_repetidos_id := id_novos_repetidos;

    // Aponta pra o próximo registro.
    Inc(pt_buffer);

    // Verifica se o usuário solicitou parar o processamento.
    if self.Terminated then begin
       fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
       Synchronize(@DoStatusErro);
       Exit;
    end;

    // Exibe a tela pra o usuário
    if qt_registros_lidos mod 500000 = 0 then begin
       fStatus_Mensagem:= 'Gerando id novos x repetidos, ltf_id: ' + IntToStr(pt_buffer^.ltf_id);
       Synchronize(@DoStatus);
       Synchronize(@DoStatusAtualizacao);
    end;

    Inc(qt_registros_lidos);

  end;

  // Fecha o arquivo.
  FreeAndNil(arquivo_novos_repetidos);

  // Ao saírmos do loop, devemos atualizar a tela pra indicar o último ítem
  // foi gerado.
  // Decrementa, pois, ao sair do loop, pt_buffer estará apontado pra um registro
  // após o último.
  Dec(pt_buffer);
  fStatus_Mensagem:= 'Gerando id novos x repetidos, ltf_id: ' + IntToStr(pt_buffer^.ltf_id);
  Synchronize(@DoStatus);
  Synchronize(@DoStatusAtualizacao);

  // Agora, inserir os dados no banco de dados.
  if not Assigned(dmLotofacil) then begin
   dmLotofacil := TDmLotofacil.Create(fComponentParent);
  end;

  try
     sql_query := dmLotofacil.sqlLotofacil;
     sql_query.DataBase := dmLotofacil.pgLTK;

     if not dmLotofacil.pgLTK.Transaction.Active then begin
        dmLotofacil.pgLTK.StartTransaction;
     end;

     fStatus_Mensagem:= fStatus_Mensagem + #10#13 +
                        'Atualizando novos x repetidos, aguarde....';
     Synchronize(@DoStatus);

     sql_query.SQL.Clear;
     sql_query.Sql.Add('truncate lotofacil.lotofacil_novos_repetidos');
     sql_query.ExecSQL;

     // Apagar restrições da tabela pra inserção ser mais rápida.
     sql_query.Sql.Clear;
     sql_query.Sql.Add('Select from lotofacil.fn_lotofacil_novos_repetidos_drop_constraint()');
     sql_query.ExecSql;

     // Percorre todos os registros inserindo no banco de dados;
     qt_registros_lidos := 0;

     // A parte inicial do sql
     str_sql_inicio := 'Insert into lotofacil.lotofacil_novos_repetidos';
     str_sql_inicio := str_sql_inicio + '(ltf_id,ltf_qt';
     str_sql_inicio := str_sql_inicio + ',novos_repetidos_id';
     str_sql_inicio := str_sql_inicio + ',novos_repetidos_id_alternado';
     str_sql_inicio := str_sql_inicio + ', cmp_b_id';

     for uA := 1 to 15 do begin
       str_sql_inicio := str_sql_inicio + ', cmp_b' + IntToStr(uA);
     end;

     str_sql_inicio := str_sql_inicio + ',concurso,qt_alt_seq)values';

     qt_max_de_bytes_ja_alocados := 0;
     sql_memory := TStringStream.Create('');

     str_sql_a_inserir := '';
     pt_buffer := pt_buffer_ltf_novos_repetidos;
     for uA := 1 to TOTAL_DE_REGISTROS do
     begin

         if sql_memory.Position <> 0 then begin
            str_sql_a_inserir := ',';
         end;

         writeln('Antes de atribuir str_sql_a_inserir.');
         str_sql_a_inserir := str_sql_a_inserir + '(';
         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.ltf_id) + ',';
         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.ltf_qt) + ',';
         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.novos_repetidos_id) + ',';
         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.novos_repetidos_id_alternado) + ',';
         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.cmp_b_id) + ', ';
         writeln('Apos de atribuir str_sql_a_inserir.');
         for uB := 1 to 15 do begin
             str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.bolas[uB]) + ',';
         end;

         str_sql_a_inserir := str_sql_a_inserir + IntToStr(fConcurso) + ',';
         str_sql_a_inserir := str_sql_a_inserir + IntToStr(pt_buffer^.id_sequencial) + ')';

         tamanho_do_string := str_sql_a_inserir.Length;

         //Writeln('Antes do if: tamanho_do_string > qt_max_de_bytes_ja_alocados.');
         //Writeln('Tamanho do string: ', tamanho_do_string);
         //Writeln('qt_max_de_bytes_ja_alocados: ', qt_max_de_bytes_ja_alocados);
         if tamanho_do_string >= qt_max_de_bytes_ja_alocados then begin
            // Se já foi alocado memória, deslocar da memória.
            //Writeln('Dentro do if: tamanho_do_string > qt_max_de_bytes_ja_alocados.');
            //Writeln('Tamanho do string: ', tamanho_do_string);
            //Writeln('qt_max_de_bytes_ja_alocados', qt_max_de_bytes_ja_alocados);

            if qt_max_de_bytes_ja_alocados <> 0 then begin
               //Writeln('Antes de liberar: FreemMem');
               //Writeln(Format('buffer_texto: %p', [Addr(buffer_texto)]));
               FreeMem(buffer_texto);
               //Writeln('Após liberar');
               Format('Após liberar: buffer_texto: %p', [Addr(buffer_texto)]);
               buffer_texto := nil;
            end;
            //Writeln('Expandindo memória de ', qt_max_de_bytes_ja_alocados, ' pra ', tamanho_do_string);
            // Devemos colocar 1 caractere a mais por causa do caractere 'nulo', que será utilizada
            // quando usarmos strlcat
            qt_max_de_bytes_ja_alocados:= tamanho_do_string + 1;

            Writeln('Antes de fazer: GetMem(qt_max_de_bytes_ja_alocados');
            buffer_texto:= GetMem(qt_max_de_bytes_ja_alocados);
            Writeln('Antes de fazer: GetMem(qt_max_de_bytes_ja_alocados');
         end;

         // Garantir que o string termino em nulo.
         //Writeln('Antes de buffer_texto^');
         //Writeln(Format('buffer_texto: %p', [Addr(buffer_texto)]));
         buffer_texto^ := #0;
         //Writeln('Antes de strlcat');
         strlcat(buffer_texto, PChar(str_sql_a_inserir), tamanho_do_string);
         //Writeln('Apos strlcat');
         //Writeln(Format('buffer_texto: %p', [Addr(buffer_texto)]));

         //Writeln('Antes de sql_memory');
         sql_memory.Write(buffer_texto^, tamanho_do_string);
         str_sql_a_inserir := '';

         // Writeln('ltf_id: ', pt_buffer^.ltf_id, ', tam_string: ', tamanho_do_string, ', qt_max_de_bytes_ja_alocados:', qt_max_de_bytes_ja_alocados);
         // Writeln('sql_memory.size: ', sql_memory.Size, ', TOTAL_DE_BYTES_MAXIMO: ', TOTAL_DE_BYTES_MAXIMO);

         // A cada 250000 registros lidos, ou quando atingir mais de 500 mb
         Inc(qt_registros_lidos);
         if sql_memory.Size > TOTAL_DE_BYTES_MAXIMO then begin
            // Writeln('Entrou no if..');
            sql_query.SQL.Clear;
            sql_query.Sql.Add(str_sql_inicio);
            sql_query.Sql.Add(sql_memory.DataString);
            sql_query.ExecSQL;
            Writeln('Executou sql_query.ExecSql');

            str_sql_a_inserir := '';

            // Deve-se mover pra a posição 0 e também definir o tamanho do fluxo pra 0.
            // Senão haverá erro ao tentar inserir pois, iremos inserir dados já inseridos
            // no banco de dados.
            //Writeln('Antes de sql_memory.Position=0');
            sql_memory.Position:=0;
            //Writeln('Apos de sql_memory.Position=0');

            //Writeln('Antes de sql_memory.Size = 0');
            sql_memory.Size := 0;
            //Writeln('Depois de sql_memory.Size = 0');

            fStatus_Mensagem := 'Inserindo registros: ' + IntToStr(pt_buffer^.ltf_id) + ' de 6874010 [' +
             Format('%.2f', [pt_buffer^.ltf_id / 6874010 * 100]) + '%]';
            Synchronize(@DoStatus);

         end;


         // Aponta pra o próximo registro.
         // Writeln('Inc(pt_buffer);');
         Inc(pt_buffer);

         // Verifica se o usuário solicitou cancelamento.
         // Se sim, fazer rollback.
         if self.Terminated then
         begin
            fStatus_Mensagem_Erro := 'Cancelamento solicitado pelo usuário!';
            Synchronize(@DoStatusErro);

            dmLotofacil.pgLTK.Transaction.Rollback;
            dmLotofacil.pgLTK.Close(true);
            sql_query.Close;
            FreeAndNil(dmLotofacil);
            FreeMem(pt_buffer_ltf_novos_repetidos);
            Exit;
         end;
     end;

     Dec(pt_Buffer);
     fStatus_Mensagem := 'Inserindo registros: ' + IntToStr(pt_buffer^.ltf_id) + ' de 6874010 [' +
                        Format('%.2f', [pt_buffer^.ltf_id / 6874010 * 100]) + '%]';
     Synchronize(@DoStatusAtualizacao);

     // Se ainda há registros ainda pra inserir, então, devemos inserí-los.
     if sql_memory.Position <> 0 then begin;
        sql_query.SQL.Clear;
        sql_query.Sql.Add(str_sql_inicio);
        sql_query.Sql.Add(sql_memory.DataString);
        sql_query.ExecSQL;
     end;

     // Liberar a memória.
     FreeMem(pt_buffer_ltf_novos_repetidos);

     fStatus_mensagem := 'Registros inseridos.';
     Synchronize(@DoStatusAtualizacao);

     fStatus_mensagem := 'Reativando constraints da tabela';
     Synchronize(@DoStatusAtualizacao);

     // Em seguida, devemos ativar as restrições novamente (constraint) da tabela.
     sql_query.Sql.Clear;
     sql_query.Sql.Add('Select from lotofacil.fn_lotofacil_novos_repetidos_add_constraint()');
     sql_query.ExecSql;

     fStatus_Mensagem:='Realizando commit...';
     Synchronize(@DoStatus);

     // Tudo ocorreu normalmente, então, confirmar transação.
     dmLotofacil.pgLTK.Transaction.Commit;

     // Verifica se a tabela lotofacil_id_novos_repetidos_agrupados e
     // lotofacil_id_novos_repetidos_agrupados_por_qt está vazia, se sim
     // devemos atualizar
     fStatus_Mensagem:='Verificando tabela de id novos x repetidos';
     Synchronize(@DoStatus);
     verificar_tabela_de_id_novos_repetidos;

     // Em seguida, atualiza a tabela lotofacil.lotofacil_resultado_novos_repetidos;
     fStatus_Mensagem := 'Atualizando tabela lotofacil.lotofacil_resultado_novos_repetidos';
     Synchronize(@DoStatus);
     atualizar_resultado_novos_repetidos;

     //Writeln('Executou... sql_query.Execsql na linha 2595');

     // Tudo ocorreu normalmente, então, confirmar transação.
     dmLotofacil.pgLTK.Transaction.Commit;

     //Writeln('Executou o commit');
     dmLotofacil.pgLTK.Close(true);

     //Writeln('Fechou o banco.');
     sql_query.Close;
     //Writeln('Fechou sql_query.');

     FreeAndNil(dmLotofacil);

     //Writeln('Desalocou sql_memory');
     FreeAndNil(sql_memory);

     //Writeln('Antes de executar @doSTatus');
    Synchronize(@DoStatus);
    Synchronize(@DoStatusAtualizacao);
    //Writeln('Após executar @doStatus');

  except
        On Exc: EDatabaseError do
        begin
             dmLotofacil.pgLTK.Transaction.Rollback;
             dmLotofacil.pgLTK.Close;
             fStatus_Mensagem_Erro:= 'Erro: ' + Exc.Message;
             Synchronize(@DoStatusErro);
             Exit;
        end;
        On Exc: Exception do
        begin
          dmLotofacil.pgLTK.Transaction.Rollback;
          dmLotofacil.pgLTK.Close;
          fStatus_Mensagem_Erro:= 'Erro: ' + Exc.Message;
          Synchronize(@DoStatusErro);
          Exit;
        end;
  end;

  // Se chegarmos aqui, quer dizer, que todos os ítens foram atualizados com sucesso!!!;
  fStatus_Mensagem := 'Itens atualizado com sucesso!!!';
  Exibir_Mensagem_de_Termino;

  //Writeln('Antes de sair da procedure, antes de @doStatusConcluido');
  Synchronize(@DoStatusConcluido);
  //Writeln('Antes de sair da procedure, depois de @doStatusConcluido');

end;

procedure TLotofacilNovosRepetidos.atualizar_resultado_novos_repetidos;
var
  sql_query: TZQuery;
begin
  sql_query := TZQuery.Create(Nil);
  sql_query.Connection := f_sql_conexao;
  sql_query.Connection.Autocommit := True;
  sql_query.Sql.Clear;
  sql_query.Sql.Add('Select from lotofacil.fn_ltf_res_novos_repetidos_atualizar(0,');
  sql_query.Sql.Add(IntToStr(fConcurso));
  sql_query.Sql.Add(')');
  sql_query.ExecSql;
  sql_query.Close;
  sql_query.Connection.Connected := false;
  FreeAndNil(sql_query);
end;

procedure TLotofacilNovosRepetidos.verificar_tabela_de_id_novos_repetidos;
var
  sql_query: TZQuery;
  qt_registros: LongInt;
begin
     sql_query := TZquery.Create(Nil);
     sql_query.Connection := f_sql_conexao;
     sql_query.Connection.Connected := false;
     sql_query.Connection.AutoCommit := false;
     sql_query.Sql.Clear;
     sql_query.Sql.Add('Select * from lotofacil.lotofacil_id_novos_repetidos_agrupado');
     sql_query.Open;
     sql_query.First;
     sql_query.Last;

     qt_registros := sql_query.RecordCount;

     // A tabela lotofacil_id_novos_repetidos_agrupado, tem que ter
     // 11 registros.
     if qt_registros <> 11 then begin
        sql_query.SQL.Clear;
        sql_query.Sql.Add('Select from lotofacil.fn_lotofacil_id_novos_repetidos_agrupado()');
        sql_query.ExecSql;
     end;

     // A tabela lotofacil_id_novos_repetidos_agrupado_por_qt tem que ter 38 registros.
     sql_query.Sql.Clear;
     sql_query.Sql.Add('Select * from lotofacil.lotofacil_id_novos_repetidos_agrupado_por_qt');
     //sql_query.ExecSql;
     sql_query.Open;
     sql_query.First;
     sql_query.Last;

     qt_registros := sql_query.RecordCount;

     if qt_registros <> 38 then begin
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select * from lotofacil.fn_lotofacil_id_novos_repetidos_agrupado_por_qt()');
        sql_query.ExecSql;
     end;

     sql_query.Connection.Commit;
     sql_query.Connection.Connected := false;

     sql_query.Close;
     FreeAndNil(sql_query);

end;

{
 Retorna um número maior que zero, que é o identificador de comparação de bolas na mesma coluna.
 Retorna -1, se houver erro, nos dados enviado.
}
function TLotofacilNovosRepetidos.Obter_id_de_comparacao_de_bolas_na_mesma_coluna(qt_de_bolas_comuns,
  qt_de_bolas_subindo, qt_de_bolas_descendo: Integer): Integer;
begin
  fStatus_Mensagem_Erro:= '';

  if not (qt_de_bolas_comuns in [0..15]) then begin
     fStatus_Mensagem_Erro:= fStatus_Mensagem_Erro + #10#13 + 'Campo: qt_de_bolas_comuns_b1_a_b15 fora do intervalo';
  end;

  if not (qt_de_bolas_subindo in [0..15]) then begin
     fStatus_Mensagem_Erro:= fStatus_Mensagem_Erro + #10#13 + 'Campo: qt_de_bolas_subindo_b1_a_b15 fora do intervalo';
  end;

  if not (qt_de_bolas_descendo in [0..15]) then begin
     fStatus_Mensagem_Erro:= fStatus_Mensagem_Erro + #10#13 + 'Campo: qt_de_bolas_descendo_b1_a_b15 fora do intervalo';
  end;

  if 15 <> (qt_de_bolas_comuns + qt_de_bolas_subindo + qt_de_bolas_descendo) then begin
     fStatus_Mensagem_Erro:= fStatus_Mensagem_Erro + #10#13 + ' A soma dos campos: ' +
                             QuotedStr('qt_de_bolas_comuns_b1_a_b15') + ', ' +
                             QuotedStr('qt_de_bolas_subindo_b1_a_b15') + ', ' +
                             QuotedStr('qt_de_bolas_descendo_b1_a_15') + ' não é igual a 15.';
  end;

  if fStatus_Mensagem_Erro <> '' then
  begin
     Exit(-1);
  end else
  begin
    Exit(f_ltf_id_bolas_na_mesma_coluna[qt_de_bolas_subindo, qt_de_bolas_subindo, qt_de_bolas_descendo]);
  end;
end;

{
 Retorna true, se conseguirmos obter todos os identificadores, falso, caso contrário.
}
function TLotofacilNovosRepetidos.Obter_todos_id_de_comparacao_de_bolas_na_mesma_coluna: boolean;
var
  sql_query: TSQLQuery;
  qt_bolas_comuns_b1_a_b15, qt_bolas_subindo_b1_a_b15,
    qt_bolas_descendo_b1_a_b15, qt_registros: LongInt;
begin
  // Iremos colocar dentro de um bloco try, pois se ocorrer erro, devemos
  // retornar como falso, que quer dizer, que não devemos continuar o processamento.
  try
    if not Assigned(dmLotofacil) then begin
       dmLotofacil := TDmLotofacil.Create(fComponentParent);
    end;

    sql_query := dmLotofacil.sqlLotofacil;
    sql_query.DataBase := dmLotofacil.pgLTK;
    sql_query.Close;

    sql_query.Sql.Clear;
    sql_query.SQL.Add('Select cmp_b_id');
    sql_query.Sql.Add(', qt_bolas_comuns_b1_a_b15');
    sql_query.Sql.Add(', qt_bolas_subindo_b1_a_b15');
    sql_query.Sql.Add(', qt_bolas_descendo_b1_a_b15');
    sql_query.Sql.Add('from lotofacil.lotofacil_id_comparacao_de_bolas_na_mesma_coluna');
    sql_query.Sql.Add('order by cmp_b_id');

    Writeln(sql_query.Sql.Text);

    sql_query.UniDirectional:= false;
    sql_query.Open;

    // Deve-se ir até o último registro pra obter
    // recordcount corretamente.
    sql_query.First;
    sql_query.Last;

    qt_registros := sql_query.RecordCount;

    // Há somente 136 registros com a soma dos três campos igual a 15
    // entretanto, iremos criar um arranjo de 16 x 16 x 16.
    // Futuramente, irei implementar um tipo 'map' pra substituir este arranjo.
    SetLength(f_ltf_id_bolas_na_mesma_coluna, 16, 16, 16);

    sql_query.First;
    while sql_query.Eof = False do begin
      qt_bolas_comuns_b1_a_b15 := sql_query.FieldByName('qt_bolas_comuns_b1_a_b15').AsInteger;
      qt_bolas_subindo_b1_a_b15 := sql_query.FieldByName('qt_bolas_subindo_b1_a_b15').AsInteger;
      qt_bolas_descendo_b1_a_b15 := sql_query.FieldByName('qt_bolas_descendo_b1_a_b15').AsInteger;

      // Verificar se está dentro da faixa válida.
      if not ((qt_bolas_comuns_b1_a_b15 in [0..15]) and
             (qt_bolas_subindo_b1_a_b15 in [0..15]) and
             (qt_bolas_descendo_b1_a_b15 in [0..15])) then begin
                fStatus_Mensagem_Erro := 'Erro, no registro: cmp_b_id: ' +
                                      IntToStr(sql_query.FieldByName('cmp_b_id').AsInteger) +
                                      'A soma dos valores dos campos ' +
                                      QuotedStr('qt_bolas_comuns_b1_a_15') + ', ' +
                                      QuotedStr('qt_bolas_subindo_b1_a_15') + ', ' +
                                      QuotedStr('qt_bolas_descendo_b1_a_15') +
                                      ' não é igual a 15';
                Exit(False);
             end;
      f_ltf_id_bolas_na_mesma_coluna[qt_bolas_comuns_b1_a_b15,
      qt_bolas_subindo_b1_a_b15, qt_bolas_descendo_b1_a_b15] := Byte(sql_query.FieldByName('cmp_b_id').AsInteger);

      sql_query.Next;
    end;

    sql_query.Close;
    dmLotofacil.pgLTK.Close(true);
  except
        On exc: EDatabaseError do begin
          fStatus_Mensagem_Erro:= 'Erro: ' + exc.Message;
          Exit(False);
        end;
        On exc: Exception do begin
          fStatus_Mensagem_Erro := 'Erro ' + exc.Message;
          Exit(False);
        end;
  end;

  Exit(True);
end;


procedure TLotofacilNovosRepetidos.Exibir_Mensagem_de_Termino;
begin
     fFim_da_atualizacao := Now;
     fStatus_Mensagem:= fStatus_Mensagem + #10#13 +
                               'Início: ' + FormatDateTime('hh:nn:ss.zzz', fInicio_da_atualizacao) + #10#13 +
                               'Fim: ' + FormatDateTime('hh:nn:ss.zzz', fFim_da_atualizacao);
     fStatus_Mensagem := fStatus_Mensagem + #10#13 + 'Tempo decorrido:' + #10#13 +
                         IntToStr(HoursBetween(fInicio_da_atualizacao, fFim_da_atualizacao)) + ':' +
                         IntToStr(MinutesBetween(fInicio_da_atualizacao, fFim_da_atualizacao) mod 60) + ':' +
                         IntToStr(SecondsBetween(fInicio_da_atualizacao, fFim_da_atualizacao) mod 60);

end;



procedure TLotofacilNovosRepetidos.AtualizarInterface;
begin
  fStatus_Atualizacao(fltf_id, fltf_qt);
  fStatus('ltf_id: ' + IntToStr(fltf_id) + ', gravando...');
  Sleep(5);
end;

procedure TLotofacilNovosRepetidos.DoStatus;
begin
  if Assigned(fStatus) then begin
     //fStatus_Mensagem := 'Atualizando: ' + IntToStr(fLtf_id) + ' de 6874010 [' +
     //        Format('%.2f', [fLtf_id / 6874010 * 100]) + '%]';
     //        //FloatToStr(fLtf_id / 6874010 * 100) + '%]';

     OnStatus(fStatus_Mensagem);
  end;
end;

procedure TLotofacilNovosRepetidos.DoStatusAtualizacao;
begin
  if Assigned(fStatus_Atualizacao) then begin
     //OnStatusAtualizacao(fltf_id, fltf_qt);
     ;
  end;
end;

procedure TLotofacilNovosRepetidos.DoStatusConcluido;
begin
  if Assigned(fStatus_Concluido) then begin
     OnStatusConcluido(fStatus_Mensagem);
  end;
end;

procedure TLotofacilNovosRepetidos.DoStatusErro;
begin
  if Assigned(fStatus_Erro) then begin
     OnStatusErro(fStatus_Mensagem_erro);
  end;
end;

end.

