unit uLotofacil_Colunas_B;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

procedure ConfigurarControlesBolas_B1(objControle: TStringGrid);
procedure ConfigurarControlesBolas_b1_b2(objControle: TStringGrid);
procedure ConfigurarControlesBolas_b1_b2_b3(objControle: TStringGrid);
procedure ConfigurarControlesBolas_b1_b2_b3_b4(objControle: TStringGrid);
procedure ConfigurarControlesBolas_b1_b2_b3_b4_b5(objControle: TStringGrid);

procedure ConfigurarControlesBolas_b1_b15(objControle: TStringGrid);
procedure ConfigurarControlesBolas_b1_b8_b15(objControle: TStringGrid);
procedure ConfigurarControlesBolas_b1_b4_b8_b12_b15(objControle: TStringGrid);

procedure Configurar_Controle_Bolas_Por_Posicao(objControle: TStringGrid);
procedure Carregar_Controle_Bolas_Por_Posicao(objControle: TStringGrid);

implementation

uses
  strUtils, sqlDb, uLotofacilModulo, Dialogs;

procedure ConfigurarControlesBolas_B1(objControle: TStringGrid);
const
  b1_campos: array[0..4] of string = (
    'b1_id',
    'b1',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
  coluna_atual: TGridColumn;
begin
  indiceUltimaColuna := High(b1_campos);

  // Insere nome das colunas, centraliza título e conteúdo.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimacoluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.Title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.Title.Caption := b1_campos[uA];
    objControle.Cells[uA, 0] := b1_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=  TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b2(objControle: TStringGrid);
const
  b1_b2_campos: array[0..5] of string = (
    'b1_b2_id',
    'b1',
    'b2',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
  coluna_atual: TGridColumn;
begin
  indiceUltimaColuna := High(b1_b2_campos);

  // Insere nome das colunas, centraliza título e conteúdo.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimacoluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.Title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b2_campos[uA];
    coluna_atual.Title.Caption := b1_b2_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b2_b3(objControle: TStringGrid);
const
  b1_b2_b3_campos: array[0..6] of string = (
    'b1_b2_b3_id',
    'b1',
    'b2',
    'b3',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
begin
  indiceUltimaColuna := High(b1_b2_b3_campos);

  // Adiciona colunas para podermos criar títulos.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimaColuna do
  begin
    objControle.Columns.Add;
  end;

  // Insere nome das colunas, centraliza título e conteúdo.
  for uA := 0 to indiceUltimacoluna do
  begin
    objControle.Columns[uA].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b2_b3_campos[uA];
    objControle.Columns[uA].Title.Caption := b1_b2_b3_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b2_b3_b4(objControle: TStringGrid);
const
  b1_b2_b3_b4_campos: array[0..7] of string = (
    'b1_b2_b3_b4_id',
    'b1',
    'b2',
    'b3',
    'b4',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
begin
  indiceUltimaColuna := High(b1_b2_b3_b4_campos);

  // Insere nome das colunas, centraliza título e conteúdo.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimacoluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.Title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b2_b3_b4_campos[uA];
    coluna_atual.Title.Caption := b1_b2_b3_b4_campos[uA];

  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b2_b3_b4_b5(objControle: TStringGrid);
const
  b1_b2_b3_b4_b5_campos: array[0..8] of string = (
    'b1_b2_b3_b4_b5_id',
    'b1',
    'b2',
    'b3',
    'b4',
    'b5',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
begin
  indiceUltimaColuna := High(b1_b2_b3_b4_b5_campos);

  // Adiciona colunas para podermos criar títulos.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimaColuna do
  begin
    objControle.Columns.Add;
  end;

  // Insere nome das colunas, centraliza título e conteúdo.
  for uA := 0 to indiceUltimacoluna do
  begin
    objControle.Columns[uA].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b2_b3_b4_b5_campos[uA];
    objControle.Columns[uA].Title.Caption := b1_b2_b3_b4_b5_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=  TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b15(objControle: TStringGrid);
const
  b1_b15_campos: array[0..5] of string = (
    'b1_b15_id',
    'b1',
    'b15',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
begin
  indiceUltimaColuna := High(b1_b15_campos);

  // Adiciona colunas para podermos criar títulos.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimaColuna do
  begin
    objControle.Columns.Add;
  end;

  // Insere nome das colunas, centraliza título e conteúdo.
  for uA := 0 to indiceUltimacoluna do
  begin
    objControle.Columns[uA].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b15_campos[uA];
    objControle.Columns[uA].Title.Caption := b1_b15_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b8_b15(objControle: TStringGrid);
const
  b1_b8_b15_campos: array[0..6] of string = (
    'b1_b8_b15_id',
    'b1',
    'b8',
    'b15',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
begin
  indiceUltimaColuna := High(b1_b8_b15_campos);

  // Adiciona colunas para podermos criar títulos.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimaColuna do
  begin
    objControle.Columns.Add;
  end;

  // Insere nome das colunas, centraliza título e conteúdo.
  for uA := 0 to indiceUltimacoluna do
  begin
    objControle.Columns[uA].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b8_b15_campos[uA];
    objControle.Columns[uA].Title.Caption := b1_b8_b15_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure ConfigurarControlesBolas_b1_b4_b8_b12_b15(objControle: TStringGrid);
const
  b1_b4_b8_b12_b15_campos: array[0..8] of string = (
    'b1_b4_b8_b12_b15_id',
    'b1',
    'b4',
    'b8',
    'b12',
    'b15',
    'ltf_qt',
    'res_qt',
    'Marcar');
var
  uA: integer;
  indiceUltimaColuna: integer;
begin
  indiceUltimaColuna := High(b1_b4_b8_b12_b15_campos);

  // Adiciona colunas para podermos criar títulos.
  objControle.Columns.Clear;
  for uA := 0 to indiceUltimaColuna do
  begin
    objControle.Columns.Add;
  end;

  // Insere nome das colunas, centraliza título e conteúdo.
  for uA := 0 to indiceUltimacoluna do
  begin
    objControle.Columns[uA].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
    objControle.Cells[uA, 0] := b1_b4_b8_b12_b15_campos[uA];
    objControle.Columns[uA].Title.Caption := b1_b4_b8_b12_b15_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indiceUltimaColuna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure Configurar_Controle_Bolas_Por_Posicao(objControle: TStringGrid);
var
  coluna_b_campos: array[0..3] of string = ('Bola', 'ltf_qt', 'res_qt', 'marcar');
  indice_ultima_coluna, uA: integer;
  coluna_atual: TGridColumn;
begin
  indice_ultima_coluna := High(coluna_b_campos);

  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.Title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.Title.Caption := coluna_b_campos[uA];

    // Isto server pra identificar ao marcar o controle.
    objControle.Cells[uA, 0] := coluna_b_campos[uA];
  end;

  // Define a última coluna com um estilo checkbox.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

procedure Carregar_Controle_Bolas_Por_Posicao(objControle: TStringGrid);
var
  str_sql: TStrings;
  dsLotofacil: TSqlQuery;
  qt_registros, numero_do_campo: longint;
  nome_do_controle: TComponentName;
  coluna_b_campos: array[0..2] of string = ('b', 'ltf_qt', 'res_qt');
  nome_do_campo: string;
  uLinha, uA: integer;
begin
  Configurar_Controle_Bolas_Por_Posicao(objControle);

  // Pega o nome do controle e coloca em minúscula pra evitar possíveis
  // mistura de maiúsculas com minúsculas.
  nome_do_controle := LowerCase(objControle.Name);

  // Todos os controles aqui, começa com 'sgrColuna', iremos substituir
  // por vazio pra pegar o nome do campo que será utilizado na tabela.
  nome_do_controle := stringReplace(nome_do_controle, 'sgrcolunab', '', [rfIgnoreCase]);

  // Após substituir deve ter somente número, neste caso, um número de 1 a 15.
  try
    numero_do_campo := StrToInt(nome_do_controle);
  except
    On exc: Exception do
    begin
      // Se há erro, devemos exibir pra o usuário
      MessageDlg('', 'O sufixo do nome do controle não termina um número entre 1 e 15',
        mtError, [mbOK], 0);
      exit;
    end;
  end;

  // O nome do campo está neste formato: 'b_' + número
  nome_do_campo := 'b_' + IntToStr(numero_do_campo);
  coluna_b_campos[0] := nome_do_campo;

  // Cria o sql
  str_sql := TStringList.Create;
  str_sql.Clear;

  str_sql.Add('Select');
  str_sql.Add(nome_do_campo);
  str_sql.Add(', ltf_qt, res_qt from');

  // O sufixo da view está neste formato: '_b' + número
  str_sql.Add('lotofacil.v_lotofacil_bolas_por_posicao_' +
    stringReplace(nome_do_campo, '_', '', [rfIgnoreCase]));
  str_sql.Add('order by res_qt desc, ltf_qt desc');

  if not (Assigned(dmLotofacil)) or (dmLotofacil = nil) then
  begin
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
  end;

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.DataBase := dmLotofacil.pgLtk;
  dsLotofacil.SQL.Text := str_sql.Text;
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
    objControle.FixedRows := 0;
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
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
    for uA := 0 to High(coluna_b_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(coluna_b_campos[uA]).AsInteger);
    end;
    // Ultima coluna.
    objControle.Cells[Length(coluna_b_campos), uLinha] := '0';

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Oculta a coluna ltf_qt, que está na coluna 1.
  objControle.Columns[1].Visible := False;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;

  dmLotofacil.Free;
  dmLotofacil := nil;

end;

end.
