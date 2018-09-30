unit ulotofacil_algarismo_nas_dezenas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

procedure Configurar_Controle_Algarismo_na_Dezena(objControle: TStringGrid);
procedure Carregar_algarismo_nas_dezenas_agrupado(objControle: TStringGrid);
procedure Carregar_algarismo_na_dezena_consolidado_intervalo_concurso(objControle: TStringGrid; concursoInicial, concursoFinal: integer);

procedure Configurar_controle_algarismo_na_dezena_por_concurso(objControle: TStringGrid);
procedure Carregar_algarismo_na_dezena_por_concurso(objControle: TStringGrid);

implementation
uses
  sqlDb, uLotofacilModulo, db, dialogs;

procedure Configurar_Controle_Algarismo_na_Dezena(objControle: TStringGrid);
{
const
  // Nome das colunas que estarão no controle.
  algarismo_nas_dezenas_campos: array[0..6] of string = (
    'dz_id',
    'dz_0',
    'dz_1',
    'dz_2',
    'ltf_qt_vz',
    'res_qt',
    'marcar');
    }
{
var
  qtColunas, indice_ultima_coluna, uA, qt_linhas, qt_coluna: integer;
  coluna_atual: TGridColumn;
}
begin

  {
  // Evitar que adicionemos novas colunas, se já houver.
  objControle.Columns.Clear;

  // Adicionar colunas.
  indice_ultima_coluna := High(algarismo_nas_dezenas_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := algarismo_nas_dezenas_campos[uA];
    objControle.Cells[uA, 0] := algarismo_nas_dezenas_campos[uA];
  end;

  // A primeira coluna é o campo id, que passou quando iremos gerar os ids,
  // necessita ficar oculta.
  objControle.Columns[0].Visible := False;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  objControle.RowCount := 1;
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
  }

end;

{
 Carrega no controle, a estatística de pares x ímpares da lotofacil.
}
procedure Carregar_algarismo_nas_dezenas_agrupado(objControle: TStringGrid);
{
const
  algarismo_nas_dezenas_campos: array[0..5] of string = (
    'dz_id',
    'dz_0',
    'dz_1',
    'dz_2',
    'ltf_qt_vz',
    'res_qt'
    );
 }
{
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;
}
begin
{
  // Configurar controle inicialmente.
  Configurar_Controle_Algarismo_na_Dezena(objControle);

  // Cria o sql
  strSql := TStringList.Create;

  strSql.Add('Select dz_id, dz_0, dz_1, dz_2, ltf_qt_vz, res_qt from');
  strSql.Add('lotofacil.v_lotofacil_resultado_algarismo_na_dezena');
  strSql.add('order by res_qt desc, ltf_qt_vz desc');

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
    objControle.FixedRows := 0;
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

  {TODO: Deletar a linha abaixo posteriormente }
  // ConfigurarControlesParImpar(objControle);

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
    for uA := 0 to High(algarismo_nas_dezenas_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(algarismo_nas_dezenas_campos[uA]).AsInteger);
    end;
    // Ultima coluna.
    objControle.Cells[Length(algarismo_nas_dezenas_campos), uLinha] := '0';

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
  }
end;

{
 Carrega o controle sgrParImparPorConcurso, neste caso, o usuário deve informar
 um concurso inicial e um concurso final
}
procedure Carregar_algarismo_na_dezena_consolidado_intervalo_concurso(
  objControle: TStringGrid; concursoInicial, concursoFinal: integer);
{
const
  algarismo_nas_dezenas_campos: array[0..5] of string = (
    'dz_id',
    'dz_0',
    'dz_1',
    'dz_2',
    'ltf_qt_vz',
    'res_qt'
    );
    }
{
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;
  concurso_parametro: TParam;
}
begin
  {

  // ConfigurarControle
  Configurar_Controle_Algarismo_na_Dezena(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.Add('Select dz_id, dz_0, dz_1, dz_2, ltf_qt_vz, res_qt from');
  strSql.add('lotofacil.fn_ltf_res_algarismo_na_dezena_agrupado_intervalo_concurso($1, $2)');
  strSql.add('order by res_qt desc, ltf_qt_vz desc');

  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
  end;
  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dsLotofacil.DataBase := dmLotofacil.pgLtk;
  dsLotofacil.SQL.Text := strSql.Text;
  FreeAndNil(strSql);

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
    On exc:EDatabaseError do begin
      MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbok], 0);
      dmLotofacil.pgLTK.CloseDataSets;
      exit;
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
    for uA := 0 to High(algarismo_nas_dezenas_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(algarismo_nas_dezenas_campos[uA]).AsInteger);
    end;
    objControle.Cells[Length(algarismo_nas_dezenas_campos), uLinha] := '0';

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
  }
end;

//procedure ConfigurarControlesParImparPorConcurso(objControle: TStringGrid);
procedure Configurar_controle_algarismo_na_dezena_por_concurso(objControle: TStringGrid);
{
const
  // Nome das colunas que estarão no controle.
  algarismo_nas_dezenas_campos: array[0..3] of string = (
    'concurso',
    'dz_0',
    'dz_1',
    'dz_2'
    );
    }
{
var
  qtColunas, indice_ultima_coluna, uA: integer;
  coluna_atual: TGridColumn;
}
begin
{
  // Evitar que adicionemos novas colunas, se já houver.
  objControle.Columns.Clear;

  // Adicionar colunas.
  indice_ultima_coluna := High(algarismo_nas_dezenas_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := algarismo_nas_dezenas_campos[uA];
    objControle.Cells[uA, 0] := algarismo_nas_dezenas_campos[uA];
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
  }
end;

{
 Carrega o controle com todas as combinações pares e ímpares de todos os
 concursos que saíram em ordem decrescente de concurso.
}
procedure Carregar_algarismo_na_dezena_por_concurso(objControle: TStringGrid);
{
const
  algarismo_nas_dezenas_campos: array[0..3] of string = (
    'concurso',
    'dz_0',
    'dz_1',
    'dz_2'
    );
    }
{
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;
  concurso_parametro: TParam;
}
begin
  {
  // Configurar controle.
  Configurar_controle_algarismo_na_dezena_por_concurso(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select concurso, dz_0, dz_1, dz_2 from');
  strSql.Add('lotofacil.v_ltf_res_algarismo_na_dezena_por_concurso');
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
    for uA := 0 to High(algarismo_nas_dezenas_campos) do
    begin
      objControle.Cells[uA, uLinha] := IntToStr(dsLotofacil.FieldByName(algarismo_nas_dezenas_campos[uA]).AsInteger);
    end;
    //objControle.Cells[High(algarismo_nas_dezenas_campos), uLinha] := '0';

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
  }
end;
// FIM


end.

