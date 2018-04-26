unit ulotofacil_diferenca_entre_bolas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, grids;


procedure ConfigurarControleDiferenca_qt_alt(objControle: TStringGrid);
procedure ConfigurarControleDiferenca_qt_alt_1(objControle: TStringGrid);
procedure ConfigurarControleDiferenca_qt_alt_2(objControle: TStringGrid);

procedure CarregarControleDiferenca_qt_alt(objControle: TStringGrid);
procedure CarregarControleDiferenca_qt_alt_1(objControle: TStringGrid; strWhere: string);
procedure CarregarControleDiferenca_qt_alt_2(objControle: TStringGrid; strWhere: string);

procedure ConfigurarControleDiferencaEntreBolas_qt_1_qt_2(objControle: TStringGrid);
procedure ConfigurarControleDiferencaEntreBolas_qt_1(objControle: TStringGrid);

procedure CarregarControleDiferencaEntreBolas_qt_1(objControle: TStringGrid);
procedure CarregarControleDiferencaEntreBolas_Qt_1_Qt_2(objControle: TStringGrid; strWhere: string);


implementation
uses
  sqlDb, uLotofacilModulo;

procedure ConfigurarControleDiferencaEntreBolas_qt_1_qt_2(objControle: TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  campos_do_controle: array[0..5] of
  string = ('qt_dif_1', 'qt_dif_2',
    'qt_dif_cmb', 'ltf_qt_vezes',
    'res_qt', 'Marcar');
  coluna_atual : TGridColumn;
begin
  indice_ultima_coluna := High(campos_do_controle);
  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    objControle.RowCount := 1;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := campos_do_controle[uA];
    objControle.Cells[uA, 0] := campos_do_controle[uA];
  end;
  // Ocultar a coluna qt_cmb pois esta coluna é utilizada pra concatenar pra
  // concatenar os campos qt_1 e qt_2.
  objControle.Columns[2].Visible := False;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

end;

procedure ConfigurarControleDiferencaEntreBolas_qt_1(objControle: TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  campos_do_controle: array[0..3] of
  string = ('qt_dif_1', 'ltf_qt_vezes',
    'res_qt', 'Marcar');
  coluna_atual: TGridColumn;
begin

  indice_ultima_coluna := High(campos_do_controle);
  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    objControle.RowCount := 1;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := campos_do_controle[uA];
    objControle.Cells[uA, 0] := campos_do_controle[uA];
  end;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

end;

procedure ConfigurarControleDiferenca_qt_alt(objControle : TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  campos_do_controle: array[0..3] of
  string = ('qt_alt', 'ltf_qt',
    'res_qt', 'Marcar');
  coluna_atual : TGridColumn;
begin
  objControle.Columns.Clear;
  objControle.RowCount := 1;
  indice_ultima_coluna := High(campos_do_controle);
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := campos_do_controle[uA];
    objControle.Cells[uA, 0] := campos_do_controle[uA];
  end;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

end;

procedure ConfigurarControleDiferenca_qt_alt_1(objControle: TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  campos_do_controle: array[0..5] of
  string = ('qt_alt', 'qt_dif_1',
    'qt_cmb', 'ltf_qt',
    'res_qt', 'Marcar');
  coluna_atual: TGridColumn;
begin

  objControle.Columns.Clear;
  indice_ultima_coluna := High(campos_do_controle);
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := campos_do_controle[uA];
    objControle.Cells[uA, 0] := campos_do_controle[uA];
  end;
  // Ocultar a coluna 2, pois, ela é uma combinação dos campos 'qt_alt' e 'qt_dif_1'
  objControle.Columns[2].Visible := False;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

procedure ConfigurarControleDiferenca_qt_alt_2(objControle: TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  campos_do_controle: array[0..6] of string = (
                      'qt_alt',
                      'qt_dif_1',
                      'qt_dif_2',
                      'qt_cmb',
                      'ltf_qt',
                      'res_qt',
                      'Marcar');
  coluna_atual: TGridColumn;
begin
  indice_ultima_coluna := High(campos_do_controle);

  // Cria os campos do controle.
  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := campos_do_controle[uA];
    objControle.cells[uA, 0] := campos_do_controle[uA];
  end;
  objControle.RowCount := 1;

  // Ocultar a coluna 3, pois, ela é uma combinação dos campos 'qt_alt' e 'qt_dif_1' e 'qt_dif_2'
  objControle.Columns[3].Visible := False;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

procedure CarregarControleDiferenca_qt_alt(objControle: TStringGrid);
var
  strSql: TStringList;
  sqlLotofacil: TSqlQuery;
  uLinha, qt_registros: integer;
begin
  if dmLotofacil = nil then
    dmLotofacil := TdmLotofacil.Create(objControle.parent);

  strSql := TStringList.Create;
  strSql.Add('Select qt_alt, ltf_qt, res_qt');
  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_alt');
  strSql.Add('order by res_qt desc, ltf_qt desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
  // a propriedade RecordCount o valor 1.
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  //ConfigurarControleDiferenca_qt_alt;
  ConfigurarControleDiferenca_qt_alt(objControle);

  sqlLotofacil.First;
  sqlLotofacil.Last;
  qt_registros := sqlLotofacil.RecordCount;

  if qt_Registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 0;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Erro, Nao há registros';
    objControle.AutoSizeColumns;
    Exit;
  end;

  // Define o número de linhas, conforme a quantidade de registro
  // Haverá uma linha mais por causa do título.
  objControle.RowCount := qt_Registros + 1;

  // Percorrer registro
  uLinha := 1;
  sqlLotofacil.First;
  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
  begin
    objControle.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_alt').AsInteger);
    objControle.Cells[1, uLinha] := sqlLotofacil.FieldByName('ltf_qt').AsString;
    objControle.Cells[2, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
    objControle.Cells[3, uLinha] := '0';

    Inc(uLinha);
    Dec(qt_Registros);

    sqlLotofacil.Next;
  end;
  sqlLotofacil.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;

  objControle.AutoSizeColumns;
end;

procedure CarregarControleDiferenca_qt_alt_1(objControle: TStringGrid; strWhere: string);
var
  strSql: TStringList;
  sqlLotofacil: TSqlQuery;
  uLinha, qt_registros: integer;
begin
  if strWhere = '' then
  begin
    objControle.Columns.Clear;
    exit;
  end;

  if dmLotofacil = nil then
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);

  strSql := TStringList.Create;
  strSql.Add('Select qt_alt, qt_dif_1, qt_cmb, ltf_qt, res_qt');
  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_alt_1');
  strSql.Add('where ' + strWhere);
  strSql.Add('order by res_qt desc, ltf_qt desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
  // a propriedade RecordCount o valor 1.
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  // Todo: Alterar controle pra ser chamado de outro arquivo.
  //ConfigurarControleDiferenca_qt_alt_1;
  ConfigurarControleDiferenca_qt_alt_1(objControle);

  qt_registros := 0;
  sqlLotofacil.First;
  while not sqlLotofacil.EOF do
  begin
    Inc(qt_Registros);
    sqlLotofacil.Next;
  end;

  if qt_Registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 0;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Erro, Nao há registros';
    objControle.AutoSizeColumns;
    Exit;
  end;

  // Define o número de linhas, conforme a quantidade de registro
  // Haverá uma linha mais por causa do título.
  objControle.RowCount := qt_Registros + 1;

  // Percorrer registro
  uLinha := 1;
  sqlLotofacil.First;
  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
  begin
    objControle.Cells[0, uLinha] :=
      IntToStr(sqlLotofacil.FieldByName('qt_alt').AsInteger);
    objControle.Cells[1, uLinha] :=
      IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
    objControle.Cells[2, uLinha] :=
      sqlLotofacil.FieldByName('qt_cmb').AsString;
    objControle.Cells[3, uLinha] :=
      sqlLotofacil.FieldByName('ltf_qt').AsString;
    objControle.Cells[4, uLinha] :=
      IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
    objControle.Cells[5, uLinha] := '0';

    Inc(uLinha);
    Dec(qt_Registros);

    sqlLotofacil.Next;
  end;
  sqlLotofacil.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;

  objControle.AutoSizeColumns;
end;

procedure CarregarControleDiferenca_qt_alt_2(objControle: TStringGrid; strWhere: string);
var
  strSql: TStringList;
  sqlLotofacil: TSqlQuery;
  uLinha, qt_registros: integer;
begin
  if strWhere = '' then
  begin
    objControle.Columns.Clear;
    exit;
  end;

  if dmLotofacil = nil then
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);

  strSql := TStringList.Create;
  strSql.Add('Select qt_alt, qt_dif_1, qt_dif_2, qt_cmb, ltf_qt, res_qt');
  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_alt_2');
  strSql.Add('where ' + strWhere);
  strSql.Add('order by res_qt desc, ltf_qt desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
  // a propriedade RecordCount o valor 1.
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  // TODO: Alterei o código abaixo, pra aparecer o nome do controle.
  //ConfigurarControleDiferenca_qt_alt_2;
  ConfigurarControleDiferenca_qt_alt_2(objControle);

  qt_registros := 0;
  sqlLotofacil.First;
  while not sqlLotofacil.EOF do
  begin
    Inc(qt_Registros);
    sqlLotofacil.Next;
  end;

  if qt_Registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 0;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Erro, Nao há registros';
    objControle.AutoSizeColumns;
    Exit;
  end;

  // Define o número de linhas, conforme a quantidade de registro
  // Haverá uma linha mais por causa do título.
  objControle.RowCount := qt_Registros + 1;

  // Percorrer registro
  uLinha := 1;
  sqlLotofacil.First;
  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
  begin
    objControle.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_alt').AsInteger);
    objControle.Cells[1, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
    objControle.Cells[2, uLinha] := sqlLotofacil.FieldByName('qt_dif_2').AsString;
    objControle.Cells[3, uLinha] := sqlLotofacil.FieldByName('qt_cmb').AsString;
    objControle.Cells[4, uLinha] := sqlLotofacil.FieldByName('ltf_qt').AsString;
    objControle.Cells[5, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
    objControle.Cells[6, uLinha] := '0';

    Inc(uLinha);
    Dec(qt_Registros);

    sqlLotofacil.Next;
  end;
  sqlLotofacil.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;

  objControle.AutoSizeColumns;
end;

procedure CarregarControleDiferencaEntreBolas_qt_1(objControle: TStringGrid);
var
  strSql: TStringList;
  sqlLotofacil: TSqlQuery;
  uLinha, qt_registros: integer;
begin
  if dmLotofacil = nil then
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);

  strSql := TStringList.Create;
  strSql.Add('Select qt_dif_1, ltf_qt_vezes, res_qt');
  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_dif_1');
  strSql.Add('order by res_qt desc, ltf_qt_vezes desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
  // a propriedade RecordCount o valor 1.
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  // ConfigurarControleDiferencaEntreBolas_qt_1;
  ConfigurarControleDiferencaEntreBolas_qt_1(objControle);

  qt_registros := 0;
  sqlLotofacil.First;
  while not sqlLotofacil.EOF do
  begin
    Inc(qt_Registros);
    sqlLotofacil.Next;
  end;

  if qt_Registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 0;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Erro, Nao há registros';
    objControle.AutoSizeColumns;
    Exit;
  end;

  // Define o número de linhas, conforme a quantidade de registro
  // Haverá uma linha mais por causa do título.
  objControle.RowCount := qt_Registros + 1;

  // Percorrer registro
  uLinha := 1;
  sqlLotofacil.First;
  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
  begin
    objControle.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
    objControle.Cells[1, uLinha] := sqlLotofacil.FieldByName('ltf_qt_vezes').AsString;
    objControle.Cells[2, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
    objControle.Cells[3, uLinha] := '0';

    Inc(uLinha);
    Dec(qt_Registros);

    sqlLotofacil.Next;
  end;
  sqlLotofacil.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;

  objControle.AutoSizeColumns;
end;

procedure CarregarControleDiferencaEntreBolas_Qt_1_Qt_2(objControle: TStringGrid; strWhere: string);
var
  strSql: TStringList;
  sqlLotofacil: TSqlQuery;
  uLinha, qt_registros: integer;
begin
  if Trim(strWhere) = '' then
  begin
    objControle.Clear;
    Exit;
  end;

  if dmLotofacil = nil then
    dmLotofacil := TdmLotofacil.Create(objControle);

  strSql := TStringList.Create;
  strSql.Add('Select qt_dif_1, qt_dif_2, qt_dif_cmb, ltf_qt_vezes, res_qt');
  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_Qt_dif_1_a_Qt_dif_2');
  strSql.Add('where qt_dif_1');
  strSql.Add('in (' + strWhere + ')');
  strSql.Add('order by res_qt desc, ltf_qt_vezes desc');
  //Writeln('sql: ', strSql.Text);

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
  // a propriedade RecordCount o valor 1.
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  //ConfigurarControleDiferencaEntreBolas_Qt_1_Qt_2;
  ConfigurarControleDiferencaEntreBolas_qt_1_qt_2(objControle);

  qt_registros := 0;
  sqlLotofacil.First;
  while not sqlLotofacil.EOF do
  begin
    Inc(qt_Registros);
    sqlLotofacil.Next;
  end;

  if qt_Registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 0;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Erro, Nao há registros';
    objControle.AutoSizeColumns;
    Exit;
  end;

  // Define o número de linhas, conforme a quantidade de registro
  // Haverá uma linha mais por causa do título.
  objControle.RowCount := qt_Registros + 1;

  // Percorrer registro
  uLinha := 1;
  sqlLotofacil.First;
  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
  begin
    objControle.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
    objControle.Cells[1, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_2').AsInteger);
    objControle.Cells[2, uLinha] := sqlLotofacil.FieldByName('qt_dif_cmb').AsString;
    objControle.Cells[3, uLinha] := sqlLotofacil.FieldByName('ltf_qt_vezes').AsString;
    objControle.Cells[4, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
    objControle.Cells[5, uLinha] := '0';

    Inc(uLinha);
    Dec(qt_Registros);

    sqlLotofacil.Next;
  end;

  // Oculta a coluna qt_dif_cmb
  objControle.Columns[2].Visible := False;

  sqlLotofacil.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;

  objControle.AutoSizeColumns;
end;


end.

