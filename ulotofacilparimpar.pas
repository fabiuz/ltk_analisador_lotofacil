{
 Esta unit armazena todas as procedures referentes à combinaçaõ de pares x ímpares.

      Autor: Fábio Moura de Oliveira
}


unit uLotofacilParImpar;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, sqlDb, DB, Dialogs;

procedure ConfigurarControlesParImpar(objControle: TStringGrid);
procedure ConfigurarControlesParImparPorConcurso(objControle : TStringGrid);

procedure CarregarParImparAgrupado(objControle : TStringGrid);
procedure CarregarParImparConsolidadoIntervaloConcurso(objControle : TStringGrid; concursoInicial, concursoFinal : integer);

procedure CarregarParImparPorConcurso(objControle: TStringGrid);


//type

  { TLotofacilParImpar }

  {
  TLotofacilParImpar = class
  private
    fobjComponent: TComponent;

  public
    constructor Create(objComponent: TComponent);

  private
    procedure ConfigurarControlesParImpar(objControle: TStringGrid);
    procedure ConfigurarControlesParImparPorConcurso(objControle : TStringGrid);

  public
    procedure CarregarParImparAgrupado(objControle : TStringGrid);
    procedure CarregarParImparConsolidadoIntervaloConcurso(objControle : TStringGrid; concursoInicial,
      concursoFinal : integer);

    procedure CarregarParImparPorConcurso(objControle: TStringGrid);


  end;
  }


implementation

uses
  uLotofacilModulo;

{ TLotofacilParImpar }
{
constructor TLotofacilParImpar.Create(objComponent: TComponent);
begin
  fobjComponent := objComponent;
end;

procedure TLotofacilParImpar.ConfigurarControlesParImpar(objControle: TStringGrid);
const
  // Nome das colunas que estarão no controle.
  par_impar_campos: array[0..5] of string = (
    'par_impar_id',
    'par',
    'impar',
    'ltf_qt',
    'res_qt',
    'marcar');
var
  qtColunas, indice_ultima_coluna, uA, qt_linhas, qt_coluna: integer;
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
  indice_ultima_coluna := High(par_impar_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := par_impar_campos[uA];
    objControle.Cells[uA, 0] := par_impar_campos[uA];
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

end;

{
 Carrega no controle, a estatística de pares x ímpares da lotofacil.
 }
procedure TLotofacilParImpar.CarregarParImparAgrupado(objControle: TStringGrid);
const
  par_impar_campos: array[0..4] of string = (
    'par_impar_id',
    'par',
    'impar',
    'ltf_qt',
    'res_qt'
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

  // Configurar controle inicialmente.
  ConfigurarControlesParImpar(objControle);

  // Cria o sql
  strSql := TStringList.Create;

  strSql.add('Select par_impar_id, par, impar, ltf_qt, res_qt from');
  strSql.add('lotofacil.v_lotofacil_resultado_par_impar_agrupado');
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
    for uA := 0 to High(par_impar_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    // Ultima coluna.
    objControle.Cells[Length(par_impar_campos), uLinha] := '0';

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
end;


{
 Carrega o controle sgrParImparPorConcurso, neste caso, o usuário deve informar
 um concurso inicial e um concurso final
}
procedure TLotofacilParImpar.CarregarParImparConsolidadoIntervaloConcurso(
  objControle: TStringGrid; concursoInicial, concursoFinal: integer);
const
  par_impar_campos: array[0..4] of string = (
    'par_impar_id',
    'par',
    'impar',
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

  // ConfigurarControle
  ConfigurarControlesParImpar(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select par_impar_id, par, impar, ltf_qt, res_qt from');
  strSql.add('lotofacil.fn_lotofacil_resultado_par_impar_agrupado_intervalo_concurso($1, $2)');
  strSql.add('order by res_qt desc, ltf_qt desc');

  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(fobjComponent);
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
    for uA := 0 to High(par_impar_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    objControle.Cells[Length(par_impar_campos), uLinha] := '0';

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
end;


procedure TLotofacilParImpar.ConfigurarControlesParImparPorConcurso(objControle: TStringGrid);
const
  // Nome das colunas que estarão no controle.
  par_impar_campos: array[0..2] of string = (
    'concurso',
    'par',
    'impar'
    );
var
  qtColunas, indice_ultima_coluna, uA: integer;
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
  indice_ultima_coluna := High(par_impar_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := par_impar_campos[uA];
    objControle.Cells[uA, 0] := par_impar_campos[uA];
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
procedure TLotofacilParImpar.CarregarParImparPorConcurso(objControle: TStringGrid);
const
  par_impar_campos: array[0..2] of string = (
    'concurso',
    'par',
    'impar'
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

  // Configurar controle.
  ConfigurarControlesParImparPorConcurso(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select concurso, par, impar from');
  strSql.add('lotofacil.v_lotofacil_resultado_par_impar');
  strSql.add('order by concurso desc');

  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(fobjComponent);
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
    for uA := 0 to High(par_impar_campos) do
    begin
      objControle.Cells[uA, uLinha] := IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    //objControle.Cells[High(par_impar_campos), uLinha] := '0';

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

}

// INÍCIO
procedure ConfigurarControlesParImpar(objControle: TStringGrid);
const
  // Nome das colunas que estarão no controle.
  par_impar_campos: array[0..5] of string = (
    'par_impar_id',
    'par',
    'impar',
    'ltf_qt',
    'res_qt',
    'marcar');
var
  qtColunas, indice_ultima_coluna, uA, qt_linhas, qt_coluna: integer;
  coluna_atual: TGridColumn;
begin

  // Evitar que adicionemos novas colunas, se já houver.
  objControle.Columns.Clear;

  // Adicionar colunas.
  indice_ultima_coluna := High(par_impar_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := par_impar_campos[uA];
    objControle.Cells[uA, 0] := par_impar_campos[uA];
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

end;

{
 Carrega no controle, a estatística de pares x ímpares da lotofacil.
 }
procedure CarregarParImparAgrupado(objControle: TStringGrid);
const
  par_impar_campos: array[0..4] of string = (
    'par_impar_id',
    'par',
    'impar',
    'ltf_qt',
    'res_qt'
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

  // Configurar controle inicialmente.
  ConfigurarControlesParImpar(objControle);

  // Cria o sql
  strSql := TStringList.Create;

  strSql.add('Select par_impar_id, par, impar, ltf_qt, res_qt from');
  strSql.add('lotofacil.v_lotofacil_resultado_par_impar_agrupado');
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
    for uA := 0 to High(par_impar_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    // Ultima coluna.
    objControle.Cells[Length(par_impar_campos), uLinha] := '0';

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
end;


{
 Carrega o controle sgrParImparPorConcurso, neste caso, o usuário deve informar
 um concurso inicial e um concurso final
}
procedure CarregarParImparConsolidadoIntervaloConcurso(
  objControle: TStringGrid; concursoInicial, concursoFinal: integer);
const
  par_impar_campos: array[0..4] of string = (
    'par_impar_id',
    'par',
    'impar',
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

  // ConfigurarControle
  ConfigurarControlesParImpar(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select par_impar_id, par, impar, ltf_qt, res_qt from');
  strSql.add('lotofacil.fn_lotofacil_resultado_par_impar_agrupado_intervalo_concurso($1, $2)');
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
    for uA := 0 to High(par_impar_campos) do
    begin
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    objControle.Cells[Length(par_impar_campos), uLinha] := '0';

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
end;


procedure ConfigurarControlesParImparPorConcurso(objControle: TStringGrid);
const
  // Nome das colunas que estarão no controle.
  par_impar_campos: array[0..2] of string = (
    'concurso',
    'par',
    'impar'
    );
var
  qtColunas, indice_ultima_coluna, uA: integer;
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
  indice_ultima_coluna := High(par_impar_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := par_impar_campos[uA];
    objControle.Cells[uA, 0] := par_impar_campos[uA];
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
procedure CarregarParImparPorConcurso(objControle: TStringGrid);
const
  par_impar_campos: array[0..2] of string = (
    'concurso',
    'par',
    'impar'
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

  // Configurar controle.
  ConfigurarControlesParImparPorConcurso(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select concurso, par, impar from');
  strSql.add('lotofacil.v_lotofacil_resultado_par_impar');
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
    for uA := 0 to High(par_impar_campos) do
    begin
      objControle.Cells[uA, uLinha] := IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    //objControle.Cells[High(par_impar_campos), uLinha] := '0';

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
// FIM


end.
