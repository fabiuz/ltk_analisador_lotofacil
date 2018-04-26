unit ulotofacilexternointerno2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, sqlDb, DB,  uLotofacilModulo;

type

  { TLotofacilExternoInterno }

  TLotofacilExternoInterno = class
  private
    procedure ConfigurarControlesExternoInternoAgrupado(objControle: TStringGrid);
    procedure ConfigurarControlesExternoInternoPorConcurso(objControle : TStringGrid);

  public
    procedure CarregarExternoInternoAgrupado(objControle: TStringGrid);
    procedure CarregarExternoInternoConsolidadoIntervaloConcurso(
      objControle: TStringGrid;
      concursoInicial, concursoFinal: integer);
    procedure CarregarExternoInternoPorConcurso(objControle : TStringGrid);

  public
    constructor Create;


  end;

implementation



{ TLotofacilExternoInterno }


procedure TLotofacilExternoInterno.ConfigurarControlesExternoInternoPorConcurso(objControle: TStringGrid);
const
  // Nome das colunas que estarão no controle.
  externo_interno_campos: array[0..2] of string = (
    'ext_int_id',
    'externo',
    'interno'
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
  indice_ultima_coluna := High(externo_interno_campos);
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := externo_interno_campos[uA];
    objControle.Cells[uA, 0] := externo_interno_campos[uA];
  end;

  // A primeira coluna é o campo id, que passou quando iremos gerar os ids,
  // necessita ficar oculta.
  objControle.Columns[0].Visible := False;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.RowCount := 1;
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

end;

{
 Carrega o controle com todas as combinações externo e interno de todos os
 concursos que saíram em ordem decrescente de concurso.
}
procedure TLotofacilExternoInterno.CarregarExternoInternoPorConcurso(objControle: TStringGrid);
const
  par_impar_campos: array[0..2] of string = (
    'concurso',
    'ext',
    'int'
    );
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;
  // concurso_parametro: TParam;
begin
  // Só iremos manipular StringGrid
  if not (objControle is TStringGrid) then
  begin
    Exit;
  end;

  // Configurar Controle
  ConfigurarControlesExternoInternoPorConcurso(objControle);

  // Cria o sql
  strSql := TStringList.Create;
  strSql.add('Select concurso, externo, interno from');
  strSql.add('lotofacil.v_lotofacil_resultado_externo_interno');
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
    objControle.FixedRows := 0;
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
      objControle.Cells[0, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(par_impar_campos[uA]).AsInteger);
    end;
    objControle.Cells[High(par_impar_campos), uLinha] := '0';

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

constructor TLotofacilExternoInterno. Create;
begin

end;


procedure TLotofacilExternoInterno.ConfigurarControlesExternoInternoAgrupado(
  objControle: TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  externo_interno_campos: array[0..5] of
  string = ('ext_int_id', 'Ext',
    'Int', 'ltf_qt',
    'res_qt', 'marcar');
  coluna_atual: TGridColumn;
begin
  // No controle par x impar, haverá as colunas:
  // ext_int_id      -> identificador de combinação Externo x Interno.
  // externo         -> Quantidade de bolas na seção externa
  // interno         -> Quantidade de bolas na seção interna
  // ltf_qt
  // res_qt
  // marcar
  if not (objControle is TStringGrid) then
  begin
    Exit;
  end;

  indice_ultima_coluna := High(externo_interno_campos);
  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := externo_interno_campos[uA];
    objControle.Cells[uA, 0] := externo_interno_campos[uA];
  end;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.RowCount := 0;
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;


{
 Este procedimento carrega todas as combinações possíveis de Externo_Interno x não Externo_Interno
 da lotofacil, os registros correspondentes a quantas vezes a combinação saiu
 até hoje nos concursos sorteados.
 }
procedure TLotofacilExternoInterno.CarregarExternoInternoAgrupado(
  objControle: TStringGrid);
const
  externo_interno_campos: array[0..4] of string = (
    'ext_int_id',
    'externo',
    'interno',
    'ltf_qt',
    'res_qt'
    );
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
  qt_registros: longint;
begin
  // Verifica se é um component stringGrid
  if not (objControle is TStringGrid) then
  begin
    Exit;
  end;

  // Configurar Controle.
  ConfigurarControlesExternoInternoAgrupado(objControle);

  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(objControle.Parent);
  end;

  strSql := TStringList.Create;
  strSql.add('Select ext_int_id, externo, interno, ltf_qt, res_qt from');
  strSql.add('lotofacil.v_lotofacil_resultado_externo_interno_agrupado');
  strSql.add('order by res_qt desc, ltf_qt desc');

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := False;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  qt_registros := 0;
  dsLotofacil.First;
  dsLotofacil.Last;
  qt_registros := dsLotofacil.RecordCount;

  if qt_registros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.FixedRows := 0;
    objControle.Columns.Add;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  // Devemos, 1 registro a mais por causa do cabeçalho.
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
      objControle.Cells[uA, uLinha] :=
        IntToStr(dsLotofacil.FieldByName(externo_interno_campos[uA]).AsInteger);
    end;
    objControle.Cells[Length(externo_interno_campos), uLinha] := '0';

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
procedure TLotofacilExternoInterno.CarregarExternoInternoConsolidadoIntervaloConcurso(
  objControle: TStringGrid; concursoInicial, concursoFinal: integer);
const
  par_impar_campos: array[0..4] of string = (
    'ext_int_id',
    'externo',
    'interno',
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
  strSql := TStringList.Create;
  strSql.add('Select ext_int_id, externo, interno, ltf_qt, res_qt from');
  strSql.add(
    'lotofacil.fn_lotofacil_resultado_externo_interno_agrupado_intervalo_concurso($1, $2)');
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
    objControle.ColCount := 1;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  // Inserir 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qt_registros + 1;

  ConfigurarControlesExternoInternoAgrupado(objControle);

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
      objControle.Cells[0, uLinha] :=
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


end.
