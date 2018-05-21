unit uLotofacilNovosRepetidos;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, dbugintf, grids ;

procedure CarregarNovosRepetidos(objControle: TStringGrid);
procedure ConfigurarControlesNovosRepetidosAgrupado(objControle: TStringGrid);
procedure CarregarNovosRepetidosConsolidadoIntervaloConcurso(objControle: TStringGrid; concursoInicial, concursoFinal: integer);

procedure ConfigurarControlesNovosRepetidosPorConcurso(objControle: TStringGrid);
procedure CarregarNovosRepetidosPorConcurso(objControle: TStringGrid);





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
      fStatusAtualizacao   : TLotofacilNovosRepetidosStatusAtualizacao;
      fStatusErro          : TLotofacilNovosRepetidosStatusErro;
      fStatusConcluido     : TLotofacilNovosRepetidosStatusConcluido;
      fConcurso            : Integer;
      fLtf_id              : Integer;
      fLtf_qt              : Integer;
      fMsg                 : AnsiString;
      fMsg_Erro            : AnsiString;
      bolasConcurso: array[0..15] of Integer;

      fComponentParent: TComponent;
      fParar: Boolean;


    private
      procedure AtualizarNovosRepetidos;
      procedure GravarLinhasNoArquivo(arquivo_novos_repetidos : TFileStream; str_linhas : AnsiString);
      function ObterBolasDoConcurso(numero_do_concurso : Integer) : boolean;
      procedure AtualizarInterface;

      procedure DoStatus;
      procedure DoStatusAtualizacao;
      procedure DoStatusConcluido;
      procedure DoStatusErro;

    public
      constructor Create (objComponent: TComponent; bCriarSuspenso : boolean ) ;
      procedure atualizar ( numero_do_concurso : Integer ) ;
      procedure Execute; override;

      property PararAtualizacao: boolean read fParar write fParar;

      property OnStatus: TLotofacilNovosRepetidosStatus read fStatus write fStatus;
      property OnStatusAtualizacao: TLotofacilNovosRepetidosStatusAtualizacao read fStatusAtualizacao write fStatusAtualizacao;
      property OnStatusConcluido: TLotofacilNovosRepetidosStatusConcluido read fStatusConcluido write fStatusConcluido;
      property OnStatusErro: TLotofacilNovosRepetidosStatusErro read fStatusErro write fStatusErro;

    public



  end;

implementation
uses
  uLotofacilModulo, sqlDb, db, dialogs;

procedure ConfigurarControlesNovosRepetidosAgrupado(objControle: TStringGrid);
var
  indice_ultima_coluna, uA: Integer;
  novos_repetidos_campos: array[0..5] of string = (
                    'novos_repetidos_id',
                    'novos',
                    'repetidos',
                    'ltf_qt',
                    'res_qt',
                    'marcar');
  coluna_atual : TGridColumn;
begin
  // No controle novo, haverá as colunas:
  // novos_repetidos_id
  // novos
  // repetidos
  // ltf_qt
  // res_qt
  // marcar

  indice_ultima_coluna := High(novos_repetidos_campos);

  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_Coluna do begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := novos_repetidos_campos[uA];
    objControle.Cells[uA, 0] := novos_repetidos_campos[uA];
  end;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

procedure CarregarNovosRepetidos(objControle: TStringGrid);
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha: integer;
  qtRegistros : LongInt;
begin
  ConfigurarControlesNovosRepetidosAgrupado(objControle);

  // Inicia o módulo de dados.
  dmLotofacil := TdmLotofacil.Create(objControle.Parent);

  strSql := TStringList.Create;

  strSql.add('Select novos_repetidos_id, novos, repetidos, ltf_qt, res_qt from');
  strSql.add('lotofacil.v_lotofacil_resultado_novos_repetidos_agrupado');
  strSql.add('order by res_qt desc, ltf_qt desc');

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := false;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // A propriedade recordCount retorna 10 por padrão, pra pegar todos os dados
  // vamos pra o último registro.
  dsLotofacil.First;
  dsLotofacil.Last;
  qtRegistros := dsLotofacil.RecordCount;

  if qtRegistros = 0 then
  begin
       objControle.Columns.Clear;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  // Devemos, 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qtRegistros + 1;


  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    // As células são strings, entretanto, não iremos atribuir o string diretamente,
    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
    // string, assim, se o campo for zero, não aparece nulo, em branco.
    objControle.Cells[0, uLinha] := IntToSTr(dsLotofacil.FieldByName('novos_repetidos_id').AsInteger);
    objControle.Cells[1, uLinha] := IntToStr(dsLotofacil.FieldByName('novos').AsInteger);
    objControle.Cells[2, uLinha] := IntToSTr(dsLotofacil.FieldByName('repetidos').AsInteger);
    objControle.Cells[3, uLinha] := IntToStr(dsLotofacil.FieldByName('ltf_qt').AsInteger);
    objControle.Cells[4, uLinha] := IntToSTr(dsLotofacil.FieldByName('res_qt').AsInteger);
    objControle.Cells[5, uLinha] := '0';

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Oculta a primeira coluna
  objControle.Columns[0].Visible := false;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;

  dmLotofacil.Free;
  dmLotofacil := nil;
end;

{
 Carrega o controle sgrParImparPorConcurso, neste caso, o usuário deve informar
 um concurso inicial e um concurso final
}
procedure CarregarNovosRepetidosConsolidadoIntervaloConcurso(
  objControle: TStringGrid; concursoInicial, concursoFinal: integer);
const
  novos_repetidos_campos: array[0..4] of string = (
    'novos_repetidos_id',
    'novos',
    'repetidos',
    'ltf_qt',
    'res_qt'
    );
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;
  concurso_parametro: TParam;
begin
  // Só iremos manipular StringGrid
  if not (objControle is TStringGrid) then
  begin
    Exit;
  end;

  // Cria o sql
  // No banco de dados alteramos o nome da função
  // de: fn_lotofacil_resultado_novos_repetidos_agrupado_intervalo_concurso
  // pra: fn_ltf_resultado_novos_repetidos_agrupado_intervalo_concurso
  strSql := TStringList.Create;
  strSql.add('Select novos_repetidos_id, novos, repetidos, ltf_qt, res_qt from');
  strSql.add('lotofacil.fn_ltf_resultado_novos_repetidos_agrupado_intervalo_concurso($1, $2)');
  strSql.add('order by res_qt desc, ltf_qt desc');

  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
  end;
  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dsLotofacil.DataBase := dmLotofacil.pgLtk;
  dsLotofacil.SQL.Text := strSql.Text;
  dsLotofacil.UniDirectional := False;

  // Insere os parâmetros.
  concurso_parametro := dsLotofacil.Params.CreateParam(TFieldType.ftInteger,
    '$1', TParamType.ptInput);
  concurso_parametro.AsInteger := concursoInicial;

  concurso_parametro := dsLotofacil.Params.CreateParam(TFieldType.ftInteger,
    '$2', TParamType.ptInput);
  concurso_parametro.AsInteger := concursoFinal;

  try
     dsLotofacil.Prepare;
     dsLotofacil.Open;
  except
    On exc: EDataBaseError do
    begin
       MessageDlg('Erro', 'Erro: ' + exc.Message, mtError, [mbok], 0);
       Exit;
    end;
  end;

  // RecordCount retorna por padrão 10, então, pra retornar a quantidade certa
  // iremos percorrer do ínicio pra o fim, assim, apos isto temos a quantidade de
  // registros.
  dsLotofacil.First;
  dsLotofacil.Last;
  qt_registros := dsLotofacil.RecordCount;

  if qt_registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  ConfigurarControlesNovosRepetidosAgrupado(objControle);

  // Inserir 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qt_registros + 1;

  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    // As células são strings, entretanto, não iremos atribuir o string diretamente,
    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
    // string, assim, se o campo for zero, não aparece nulo, em branco.
    for uA := 0 to High(novos_repetidos_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(novos_repetidos_campos[uA]).AsInteger);
    end;
    objControle.Cells[Length(novos_repetidos_campos), uLinha] := '0';

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Oculta a primeira coluna
  objControle.Columns[0].Visible := False;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;

  dmLotofacil.Free;
  dmLotofacil := nil;

  FreeAndNil(strSql);
end;

procedure ConfigurarControlesNovosRepetidosPorConcurso(objControle: TStringGrid);
const
  // Nome das colunas que estarão no controle.
  novos_repetidos_campo: array[0..2] of string = (
    'concurso',
    'par',
    'impar'
    );
var
  indice_ultima_coluna, uA: integer;
  coluna_atual: TGridColumn;
begin
  // Esta procedure somente pode mainpular somente stringGrid, evitar que o usuário
  // passe um outro tipo de controle.
  if not (objControle is TStringGrid) then
  begin
    Exit;
  end;

  // Evitar que adicionemos novas colunas, se já houver.
  objControle.Columns.Clear;

  // Adicionar colunas.
  indice_ultima_coluna := High(novos_repetidos_campo);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := novos_repetidos_campo[uA];
    objControle.Cells[uA, 0] := novos_repetidos_campo[uA];
  end;

  // A primeira coluna é o campo id, que passou quando iremos gerar os ids,
  // necessita ficar oculta.
  // objControle.Columns[0].Visible := False;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  //objControle.Columns[indice_ultima_coluna].ButtonStyle :=     TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.RowCount := 1;
  objControle.FixedRows := 1;
  objControle.FixedCols := 0;

end;

{
 Carrega o controle com todas as combinações pares e ímpares de todos os
 concursos que saíram em ordem decrescente de concurso.
}
procedure CarregarNovosRepetidosPorConcurso(objControle: TStringGrid);
const
  externo_interno_campos: array[0..2] of string = (
    'concurso',
    'novos',
    'repetidos'
    );
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;

begin
  // Só iremos manipular StringGrid
  if not (objControle is TStringGrid) then
  begin
    Exit;
  end;

  // Configurar controle.
  ConfigurarControlesNovosRepetidosPorConcurso(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select concurso, novos, repetidos from');
  strSql.add('lotofacil.v_lotofacil_resultado_novos_repetidos_por_concurso');
  strSql.add('order by concurso desc');

  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
  end;
  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dsLotofacil.DataBase := dmLotofacil.pgLtk;
  dsLotofacil.SQL.Text := strSql.Text;
  dsLotofacil.UniDirectional := False;

  dsLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount retorna por padrão 10, então, pra retornar a quantidade certa
  // iremos percorrer do ínicio pra o fim, assim, apos isto temos a quantidade de
  // registros.
  dsLotofacil.First;
  dsLotofacil.Last;
  qt_registros := dsLotofacil.RecordCount;

  if qt_registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  // Inserir 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qt_registros + 1;

  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    // As células são strings, entretanto, não iremos atribuir o string diretamente,
    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
    // string, assim, se o campo for zero, não aparece nulo, em branco.
    for uA := 0 to High(externo_interno_campos) do
    begin
      objControle.Cells[uA, uLinha] := IntToStr(dsLotofacil.FieldByName(externo_interno_campos[uA]).AsInteger);
    end;
    //objControle.Cells[High(externo_interno_campos), uLinha] := '0';

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Oculta a primeira coluna
  //objControle.Columns[0].Visible := False;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;

  dmLotofacil.Free;
  dmLotofacil := nil;
end;





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
  //Execute;
end;


procedure TLotofacilNovosRepetidos.Execute;
begin
  if not ObterBolasDoConcurso(fConcurso) then begin
    Exit;
  end;

  AtualizarNovosRepetidos;

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
    bolasConcurso[uA] := sql_registro.FieldByName('b_' + IntToStr(uA)).AsInteger;
  end;

  sql_registro.Close;
  dmLotofacil.pgLTK.CloseDataSets;

  Exit(True);
end;

procedure TLotofacilNovosRepetidos.GravarLinhasNoArquivo(arquivo_novos_repetidos: TFileStream; str_linhas: AnsiString);
const
  BYTES_ALOCADOS: LongInt = 10239;
var
  buffer: array[0..10239] of Char;
  qt_bytes_alocados , qt_caracteres: Integer;
  str_temp : String;
begin
  qt_bytes_alocados := sizeof(buffer);

  // Zera o arranjo pra evitar lixo de memória.
  FillChar(buffer, BYTES_ALOCADOS, #0);

  while str_linhas <> '' do
  begin
    qt_caracteres := Length(str_linhas);
    if qt_caracteres > qt_bytes_alocados then begin
      str_temp := copy(str_linhas, 0, qt_bytes_alocados);
      str_temp := str_temp + #0;
      strlcopy(buffer, pchar(str_temp), qt_bytes_alocados);

      // +1 na linha abaixo, pois os caracteres começa na posição 1, se fosse
      // zero, não seria necessário.
      str_linhas := Copy(str_linhas, qt_bytes_alocados+1 , qt_caracteres);
      qt_caracteres := qt_caracteres - qt_bytes_alocados;
      arquivo_novos_repetidos.Write(buffer, qt_bytes_alocados);
    end else begin
        qt_caracteres := Length(str_linhas);
        strlcopy(buffer, pchar(str_linhas), qt_caracteres);
        str_linhas := '';
        arquivo_novos_repetidos.Write(buffer, qt_caracteres);
    end;
  end;
  str_linhas := '';
end;

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
                               Observe acima, que haverá identificadores sequenciais idependentes pra cada id da combinação
                               novos x repetidos.
 qt_alt_seq                    ==> Aqui, no programa ele terá o valor zero, antigamente, era utilizado como um identificador
                               sequencial, pra pegar a quantidade de alternadores de diferenças. Isto em breve, será
                               excluído da tabela e do código dentro desta procedure.
}
procedure TLotofacilNovosRepetidos.AtualizarNovosRepetidos;
const
  CRLF = {$IFDEF LINUX}
                 #10;
         {$ELSE}
                {$IFDEF WINDOW}
                        #10#13;
                {$ELSE}
                       #13;
                 {$ENDIF}
         {$ENDIF}
  BYTES_ALOCADOS = 8196;
var
  ltf_id, ltf_qt: LongInt;
  b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18: byte;
  lotofacil_concurso : array[0..25] of Byte;
  lotofacil_combinacao: array[0..25] of Byte;

  {
   Conforme relatado acima no comentário da procedure, pra cada combinação novos x repetidos, haverá
   um identificador sequencial. A medida que fomos encontrando as combinações novos x repetidos, iremos
   incrementar o identificador sequencial, pra cada combinação novos x repetidos haverá um identificador
   sequencial independente.
   Na lotofacil, há 11 identificadores de novos x repetidos, númerados de 0 a 10, então, no arranjo abaixo
   criaremos um arranjo com 11 (onze) posições, pra armazenar cada id sequencial a medida que cada
   combinação novos x repetidos for encontrado.
  }
  novos_repetidos_id_sequencial: array[0..10] of LongInt;

  qt_repetidos , uA, qt_id_novos_repetidos: Integer;

  arquivo_novos_repetidos: Text;
  arq_novos_repetidos : TFileStream;

  str_linhas: AnsiString;
  qt_linhas: Integer;
  qt_bytes_alocados: SizeInt;
  bola_atual : Integer;

  buffer : array[0..8195] of char;         // 10240 bytes alocados. 10 MB

  nome_do_arquivo , str_temp: String;
begin

  qt_bytes_alocados := sizeof(buffer);

  // Zera o conteúdo do buffer, pra evitar lixos de memória.
  FillChar(buffer, qt_bytes_alocados, #0);

  // Zera o arranjo pra evitar lixos de memória.
  FillChar(lotofacil_concurso, sizeof(Byte) * 25, 0);

    // Preenche o arranjo com as bolas do concurso.
  for uA := 1 to 15 do begin
    bola_atual := bolasConcurso[uA];
    lotofacil_concurso[bola_atual] := 1;
  end;

  // Zera o arranjo pra não haver lixos de memória.
  FillChar(lotofacil_combinacao, sizeof(Byte) * 25, 0);
  FillChar(novos_repetidos_id_sequencial, sizeof(LongInt) * 10, 0);

  // Abri arquivo pra gravação
  nome_do_arquivo := './lotofacil_novos_repetidos_concurso_' + IntToStr(fConcurso) + '_' +
                  FormatDateTime('YYYY_MM_DD-HH_NN_SS', Now) + '.csv';
  try
  arq_novos_repetidos := TFileStream.Create(nome_do_arquivo, fmCreate);
  //FreeAndNil(arq_novos_repetidos);
  //arq_novos_repetidos := TFileStream.Create(nome_do_arquivo, fmOpenWrite);
  except
    On exc: Exception do begin
      fStatusErro('Erro: ' + exc.Message);
      fStatusConcluido('Erro: ' + exc.Message);
      exit;
    end;
  end;

  // Grava cabeçalho:
  // ltf_id;ltf_qt;novo_repetidos_id;novos_repetidos_id_alternado;concurso;qt_alt_seq
  str_linhas := 'ltf_id;ltf_qt;novo_repetidos_id;novos_repetidos_id_alternado;concurso;qt_alt_seq';

  GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
  str_linhas := '';

  ltf_id := 0;
  ltf_qt := 15;

  // qt_linhas, serve pra contar quantas linhas já foram analisadas, iremos definir o valor de 1000 linhas analisadas
  // pra gravar no arquivo.
  qt_linhas := -1;
  for b1 := 1 to 25 do
  for b2 := b1 + 1 to 25 do
  for b3 := b2 + 1 to 25 do
  for b4 := b3 + 1 to 25 do
  for b5 := b4 + 1 to 25 do
  for b6 := b5 + 1 to 25 do
  for b7 := b6 + 1 to 25 do
  for b8 := b7 + 1 to 25 do
  for b9 := b8 + 1 to 25 do
  for b10 := b9 + 1 to 25 do
  for b11 := b10 + 1 to 25 do
  for b12 := b11 + 1 to 25 do
  for b13 := b12 + 1 to 25 do
  for b14 := b13 + 1 to 25 do
  for b15 := b14 + 1 to 25 do
  begin
    inc(ltf_id);
    if ltf_id = 11012 then
    begin
       Writeln('');
    end;
    Writeln(ltf_id);

    fLtf_id := ltf_id;
    fLtf_qt := ltf_qt;

    // O valor 1 indica que a bola saiu na combinação.
    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;

    qt_repetidos := 0;
    for uA := 1 to 25 do begin
      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
         Inc(qt_repetidos);
      end;
    end;

    if ltf_id = 9009 then begin
       fltf_id := ltf_id;
    end;

    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
    qt_id_novos_repetidos := 15 - qt_repetidos;

    // O identificador novos x repetidos deve está na faixa de 0 a 11.
    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
       fMsg_erro := 'Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]';
       Synchronize(@DoStatusErro);
       Exit;
    end;

    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;

    str_linhas := str_linhas + CRLF;
    str_linhas := str_linhas + IntToStr(ltf_id);
    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
    str_linhas := str_linhas + ';0';

    SendDebug('ltf_id: ' + IntToStr(ltf_id) + ', Length(str_linhas): ' + IntToStr(Length(str_linhas)));


    // A cada 1000 linhas, iremos armazenar no arquivo.
    Inc(qt_linhas);
    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));

    if qt_linhas = 1000 then
    begin
       qt_linhas := -1;
       // Ao gravar, devemos verificar por possíveis erros.
       try
          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
          str_linhas := '';
       except
         On exc:Exception do
         begin
              fMsg_Erro := 'Erro: ' + exc.Message;
              Synchronize(@DoStatusErro);
              Exit;
         end;
       end;
    end;

    // Reseta todos os valores;
    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);

    Synchronize(@DoStatus);
    Synchronize(@DoStatusAtualizacao);

    if self.Terminated then begin
       fMsg_Erro := 'Cancelamento solicitado pelo usuário!';
       Synchronize(@DoStatusErro);
       Exit;
    end;

  end;


  ltf_qt := 16;
  for b1 := 1 to 25 do
  for b2 := b1 + 1 to 25 do
  for b3 := b2 + 1 to 25 do
  for b4 := b3 + 1 to 25 do
  for b5 := b4 + 1 to 25 do
  for b6 := b5 + 1 to 25 do
  for b7 := b6 + 1 to 25 do
  for b8 := b7 + 1 to 25 do
  for b9 := b8 + 1 to 25 do
  for b10 := b9 + 1 to 25 do
  for b11 := b10 + 1 to 25 do
  for b12 := b11 + 1 to 25 do
  for b13 := b12 + 1 to 25 do
  for b14 := b13 + 1 to 25 do
  for b15 := b14 + 1 to 25 do
  for b16 := b15 + 1 to 25 do
  begin
    inc(ltf_id);

    fLtf_id := ltf_id;
    fLtf_qt := ltf_qt;

    // O valor 1 indica que a bola saiu na combinação.
    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
    lotofacil_combinacao[b16] := 1;

    qt_repetidos := 0;

    for uA := 1 to 25 do begin
      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
         Inc(qt_repetidos);
      end;
    end;

    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
    qt_id_novos_repetidos := 15 - qt_repetidos;

    // O identificador novos x repetidos deve está na faixa de 0 a 11.
    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
       fStatusErro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
       Close(arquivo_novos_repetidos);
       Exit;
    end;

    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;

    str_linhas := str_linhas + CRLF;
    str_linhas := str_linhas + IntToStr(ltf_id);
    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
    str_linhas := str_linhas + ';0';

    // A cada 1000 linhas, iremos armazenar no arquivo.
    Inc(qt_linhas);
    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));

    if qt_linhas = 1000 then
    begin
       qt_linhas := -1;
       // Ao gravar, devemos verificar por possíveis erros.
       try
          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
          str_linhas := '';
       except
         On exc:Exception do
         begin
              fMsg_Erro := 'Erro: ' + exc.Message;
              Synchronize(@DoStatusErro);
              Exit;
         end;
       end;
    end;

    // Reseta todos os valores;
    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);

    Synchronize(@DoStatus);
    Synchronize(@DoStatusAtualizacao);

    if self.Terminated then begin
       fMsg_Erro := 'Cancelamento solicitado pelo usuário!';
       Synchronize(@DoStatusErro);
       Exit;
    end;

  end;

  ltf_qt := 17;
  for b1 := 1 to 25 do
  for b2 := b1 + 1 to 25 do
  for b3 := b2 + 1 to 25 do
  for b4 := b3 + 1 to 25 do
  for b5 := b4 + 1 to 25 do
  for b6 := b5 + 1 to 25 do
  for b7 := b6 + 1 to 25 do
  for b8 := b7 + 1 to 25 do
  for b9 := b8 + 1 to 25 do
  for b10 := b9 + 1 to 25 do
  for b11 := b10 + 1 to 25 do
  for b12 := b11 + 1 to 25 do
  for b13 := b12 + 1 to 25 do
  for b14 := b13 + 1 to 25 do
  for b15 := b14 + 1 to 25 do
  for b16 := b15 + 1 to 25 do
  for b17 := b16 + 1 to 25 do
  begin
    inc(ltf_id);

    fLtf_id := ltf_id;
    fLtf_qt := ltf_qt;


    // O valor 1 indica que a bola saiu na combinação.
    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
    lotofacil_combinacao[b16] := 1; lotofacil_combinacao[b17] := 1;

    qt_repetidos := 0;

    for uA := 1 to 25 do begin
      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
         Inc(qt_repetidos);
      end;
    end;

    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
    qt_id_novos_repetidos := 15 - qt_repetidos;

    // O identificador novos x repetidos deve está na faixa de 0 a 11.
    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
       fStatusErro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
       Close(arquivo_novos_repetidos);
       Exit;
    end;

    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;

    str_linhas := str_linhas + CRLF;
    str_linhas := str_linhas + IntToStr(ltf_id);
    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
    str_linhas := str_linhas + ';0';

    // A cada 1000 linhas, iremos armazenar no arquivo.
    Inc(qt_linhas);
    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));

    if qt_linhas = 1000 then
    begin
       qt_linhas := -1;
       // Ao gravar, devemos verificar por possíveis erros.
       try
          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
          str_linhas := '';
       except
         On exc:Exception do
         begin
              fMsg_Erro := 'Erro: ' + exc.Message;
              Synchronize(@DoStatusErro);
              Exit;
         end;
       end;
    end;

    // Reseta todos os valores;
    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);

    Synchronize(@DoStatus);
    Synchronize(@DoStatusAtualizacao);

    if self.Terminated then begin
       fMsg_Erro := 'Cancelamento solicitado pelo usuário!';
       Synchronize(@DoStatusErro);
       Exit;
    end;

  end;

  ltf_qt := 18;
  for b1 := 1 to 25 do
  for b2 := b1 + 1 to 25 do
  for b3 := b2 + 1 to 25 do
  for b4 := b3 + 1 to 25 do
  for b5 := b4 + 1 to 25 do
  for b6 := b5 + 1 to 25 do
  for b7 := b6 + 1 to 25 do
  for b8 := b7 + 1 to 25 do
  for b9 := b8 + 1 to 25 do
  for b10 := b9 + 1 to 25 do
  for b11 := b10 + 1 to 25 do
  for b12 := b11 + 1 to 25 do
  for b13 := b12 + 1 to 25 do
  for b14 := b13 + 1 to 25 do
  for b15 := b14 + 1 to 25 do
  for b16 := b15 + 1 to 25 do
  for b17 := b16 + 1 to 25 do
  for b18 := b17 + 1 to 25 do
  begin
    inc(ltf_id);

    fLtf_id := ltf_id;
    fLtf_qt := ltf_qt;


    // O valor 1 indica que a bola saiu na combinação.
    lotofacil_combinacao[b1] := 1; lotofacil_combinacao[b2] := 1; lotofacil_combinacao[b3] := 1;
    lotofacil_combinacao[b4] := 1; lotofacil_combinacao[b5] := 1; lotofacil_combinacao[b6] := 1;
    lotofacil_combinacao[b7] := 1; lotofacil_combinacao[b8] := 1; lotofacil_combinacao[b9] := 1;
    lotofacil_combinacao[b10] := 1; lotofacil_combinacao[b11] := 1; lotofacil_combinacao[b12] := 1;
    lotofacil_combinacao[b13] := 1; lotofacil_combinacao[b14] := 1; lotofacil_combinacao[b15] := 1;
    lotofacil_combinacao[b16] := 1; lotofacil_combinacao[b17] := 1; lotofacil_combinacao[b18] := 1;

    qt_repetidos := 0;

    for uA := 1 to 25 do begin
      if (lotofacil_concurso[uA] = 1) and (lotofacil_combinacao[uA] = 1) then begin
         Inc(qt_repetidos);
      end;
    end;

    // Na tabela lotofacil_id_novos_repetidos, o id é o mesmo que a quantidade de novos.
    qt_id_novos_repetidos := 15 - qt_repetidos;

    // O identificador novos x repetidos deve está na faixa de 0 a 11.
    if not((qt_id_novos_repetidos >= 0) and (qt_id_novos_repetidos <= 10)) then begin
       fStatusErro('Id encontrado: ' + QuotedStr(IntToStr(qt_id_novos_repetidos)) + ' esperado id na faixa: ' + '[0-10]');
       Close(arquivo_novos_repetidos);
       Exit;
    end;

    novos_repetidos_id_sequencial[qt_id_novos_repetidos] := novos_repetidos_id_sequencial[qt_id_novos_repetidos]  + 1;

    // Grava no arquivo, os valores dos campos correspondentes.
    str_linhas := str_linhas + CRLF;
    str_linhas := str_linhas + IntToStr(ltf_id);
    str_linhas := str_linhas + ';' + IntToStr(ltf_qt);
    str_linhas := str_linhas + ';' + IntToStr(qt_id_novos_repetidos);
    str_linhas := str_linhas + ';' + IntToStr(novos_repetidos_id_sequencial[qt_id_novos_repetidos]);
    str_linhas := str_linhas + ';' + IntToStr(fConcurso);
    str_linhas := str_linhas + ';0';

    // A cada 1000 linhas, iremos armazenar no arquivo.
    Inc(qt_linhas);
    //Writeln('ltf_id: ' + IntToStr(ltf_id) + 'Tamanho_string: ' + IntToStr(Length(str_linhas)));

    if qt_linhas = 1000 then
    begin
       qt_linhas := -1;
       // Ao gravar, devemos verificar por possíveis erros.
       try
          GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
          str_linhas := '';
       except
         On exc:Exception do
         begin
              fMsg_Erro := 'Erro: ' + exc.Message;
              Synchronize(@DoStatusErro);
              Exit;
         end;
       end;
    end;

    // Reseta todos os valores;
    FillChar(lotofacil_combinacao, sizeof(byte) * 26, 0);

    Synchronize(@DoStatus);
    Synchronize(@DoStatusAtualizacao);

    if self.Terminated then begin
       fMsg_Erro := 'Cancelamento solicitado pelo usuário!';
       Synchronize(@DoStatusErro);
       Exit;
    end;

  end;

  // Após sairmos de todos os loops, pode haver, ítens que não foram gravados no arquivos
  // Por exemplo, a gravação é a cada 1000 linhas, então, devemos verificar se a variável
  // qt_linhas é diferente de -1, se sim, há linhas a serem gravadas.
  if qt_linhas <> -1 then
  begin
   qt_linhas := -1;
   // Ao gravar, devemos verificar por possíveis erros.
   try
      GravarLinhasNoArquivo(arq_novos_repetidos, str_linhas);
   except
     On exc:Exception do
     begin
          fMsg_Erro := 'Erro: ' + exc.Message;
          Synchronize(@DoStatusErro);
          Exit;
     end;
   end;
  end;

  FreeAndNil(arq_novos_repetidos);
  arq_novos_repetidos := nil;

  Synchronize(@DoStatusConcluido);
end;


procedure TLotofacilNovosRepetidos.AtualizarInterface;
begin
  fStatusAtualizacao(fltf_id, fltf_qt);
  fStatus('ltf_id: ' + IntToStr(fltf_id) + ', gravando...');
  Sleep(5);
end;

procedure TLotofacilNovosRepetidos.DoStatus;
begin
  if Assigned(OnStatus) then begin
     fMsg := 'Atualizando: ' + IntToStr(fLtf_id) + ' de 6874010 [' +
             Format('%.2f', [fLtf_id / 6874010 * 100]) + '%]';
             //FloatToStr(fLtf_id / 6874010 * 100) + '%]';

     OnStatus(fMsg);
  end;
end;

procedure TLotofacilNovosRepetidos.DoStatusAtualizacao;
begin
  if Assigned(OnStatusAtualizacao) then begin
     OnStatusAtualizacao(fltf_id, fltf_qt);
  end;
end;

procedure TLotofacilNovosRepetidos.DoStatusConcluido;
begin
  if Assigned(OnStatusConcluido) then begin
     fMsg := '6874010 combinações atualizadas com sucesso!!!';
     OnStatusConcluido(fMsg);
  end;
end;

procedure TLotofacilNovosRepetidos.DoStatusErro;
begin
  if Assigned(fStatusErro) then begin
     OnStatusErro(fMsg_erro);
  end;
end;

end.

