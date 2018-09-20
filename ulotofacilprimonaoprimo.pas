unit uLotofacilPrimoNaoPrimo;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils,
    Grids, sqlDb, DB;

procedure ConfigurarControlesPrimoNaoPrimo(objControle: TStringGrid);
procedure CarregarPrimoNaoPrimo(objControle: TStringGrid);
procedure CarregarPrimoNaoPrimoConsolidadoIntervaloConcurso(objControle: TStringGrid;
    concursoInicial, concursoFinal: integer);
procedure CarregarPrimoNaoPrimoPorConcurso(objControle: TStringGrid);

implementation

uses uLotofacilModulo;

procedure ConfigurarControlesPrimoNaoPrimo(objControle: TStringGrid);
var
    indice_ultima_coluna, uA: integer;
    primo_campos: array[0..5] of string = ('prm_id', 'primo', 'nao_primo', 'ltf_qt', 'res_qt', 'marcar');
    coluna_atual: TGridColumn;
begin
    // Na descrição acima, haverá 6 colunas, no controle stringGrid, ao exibir,
    // a primeira coluna com o id da combinação estará oculta, pois, não é necessário
    // para o usuário, entretanto, ao filtrar será necessário.


    indice_ultima_coluna := High(primo_campos);
    objControle.Columns.Clear;
    for uA := 0 to indice_ultima_Coluna do
    begin
        coluna_atual := objControle.Columns.Add;
        coluna_atual.title.Alignment := TAlignment.taCenter;
        coluna_atual.Alignment := TAlignment.taCenter;
        coluna_atual.title.Caption := primo_campos[uA];
        objControle.Cells[uA, 0] := primo_campos[uA];
    end;

    // A coluna marcar será do tipo checkbox, pois, serve pra o usuário marcar qual combinação
    // deseja.
    objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
    objControle.FixedCols := 0;
    objControle.FixedRows := 1;
end;

 {
  Este procedimento carrega todas as combinações possíveis de primo x não primo
  da lotofacil, os registros correspondentes a quantas vezes a combinação saiu
  até hoje nos concursos sorteados.
  }
procedure CarregarPrimoNaoPrimo(objControle: TStringGrid);
const
    externo_interno_campos: array [0..4] of string = (
        'prm_id',
        'primo',
        'nao_primo',
        'ltf_qt',
        'res_qt');
var
    strSql:     TStrings;
    sql_query:  TSqlQuery;
    uLinha, uA: integer;
    qt_registros: longint;
begin
    if not Assigned(dmLotofacil) then
    begin
        dmLotofacil := TdmLotofacil.Create(objControle.parent);
    end;

    //strSql := TStringList.Create;
    //sql_query.add('Select prm_id, primo, nao_primo, ltf_qt, res_qt from');
    //sql_query.add('lotofacil.v_lotofacil_resultado_primo_nao_primo_agrupado');
    //sql_query.add('order by res_qt desc, ltf_qt desc');

    sql_query := dmLotofacil.sqlLotofacil;
    sql_query.Active := False;
    sql_query.DataBase := dmLotofacil.pgLtk;

    sql_query.Sql.Clear;
    sql_query.Sql.Add('Select prm_id, primo, nao_primo, ltf_qt, res_qt from');
    sql_query.Sql.Add('lotofacil.v_lotofacil_resultado_primo_nao_primo_agrupado');
    sql_query.Sql.add('order by res_qt desc, ltf_qt desc');

    sql_query.UniDirectional := False;
    sql_query.Prepare;
    sql_query.Open;

    // RecordCount ele retorna por padrão 10, pois, ele bufferiza os registros, pra
    // retornar o total deve-se percorrer até no fim, assim tem a quantidade correta.
    sql_query.First;
    sql_query.Last;
    qt_registros := sql_query.RecordCount;

    if qt_registros = 0 then
    begin
        objControle.Columns.Clear;
        objControle.ColCount := 1;
        objControle.RowCount := 1;
        objControle.FixedRows := 0;
        objControle.Cells[0, 0] := 'Não há registros...';
        objControle.AutoSizeColumns;
        exit;
    end;

    // Devemos, 1 registro a mais por causa do cabeçalho.
    objControle.RowCount := qt_registros + 1;

    ConfigurarControlesPrimoNaoPrimo(objControle);

    // Agora, iremos percorrer o registro e inserir na grade de strings.
    // A primeira linha, de índice zero, é o nome dos campos, devemos começar
    // na linha 1.
    uLinha := 1;
    sql_query.First;
    while sql_query.EOF = False do
    begin
        for uA := 0 to High(externo_interno_campos) do
        begin
            objControle.Cells[uA, uLinha] :=
                IntToStr(sql_query.FieldByName(externo_interno_campos[uA]).AsInteger);
        end;
        objControle.Cells[5, uLinha] := '0';

        sql_query.Next;
        Inc(uLinha);
    end;

    // Oculta a primeira coluna
    objControle.Columns[0].Visible := False;

    // Fecha o dataset.
    sql_query.Close;

    // Redimensiona as colunas.
    objControle.AutoSizeColumns;

    dmLotofacil.Free;
    dmLotofacil := nil;
end;

{
 Carrega o controle sgrPrimoNaoPrimo, neste caso, o usuário deve informar
 um concurso inicial e um concurso final
}
procedure CarregarPrimoNaoPrimoConsolidadoIntervaloConcurso(objControle: TStringGrid;
    concursoInicial, concursoFinal: integer);
const
    primo_naoprimo_campos: array[0..4] of string = (
        'prm_id',
        'primo',
        'nao_primo',
        'ltf_qt',
        'res_qt');
var
    strSql:      TStrings;
    dsLotofacil: TSqlQuery;
    uLinha, uA:  integer;
    qt_registros: longint;
    concurso_parametro: TParam;
begin
    // Só iremos manipular StringGrid
    if not (objControle is TStringGrid) then
    begin
        Exit;
    end;

    ConfigurarControlesPrimoNaoPrimo(objControle);

    // Cria o sql
    strSql := TStringList.Create;
    strSql.add('Select prm_id, primo, nao_primo, ltf_qt, res_qt from');
    strSql.add(
        'lotofacil.fn_lotofacil_resultado_primo_nao_primo_agrupado_intervalo_concurso($1, $2)');
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
    concurso_parametro := dsLotofacil.Params.CreateParam(TFieldType.ftInteger, '$1', TParamType.ptInput);
    concurso_parametro.AsInteger := concursoInicial;

    concurso_parametro := dsLotofacil.Params.CreateParam(TFieldType.ftInteger, '$2', TParamType.ptInput);
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
        for uA := 0 to High(primo_naoprimo_campos) do
        begin
            objControle.Cells[uA, uLinha] :=
                IntToStr(dsLotofacil.FieldByName(primo_naoprimo_campos[uA]).AsInteger);
        end;
        objControle.Cells[Length(primo_naoprimo_campos), uLinha] := '0';

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



procedure ConfigurarControlesPrimoNaoPrimoPorConcurso(objControle: TStringGrid);
const
    // Nome das colunas que estarão no controle.
    primo_nao_primo_campos: array[0..2] of string = (
        'concurso',
        'primo',
        'naoprimo'
        );
var
    indice_ultima_coluna, uA: integer;
    coluna_atual: TGridColumn;
begin

    // Evitar que adicionemos novas colunas, se já houver.
    objControle.Columns.Clear;

    // Adicionar colunas.
    indice_ultima_coluna := High(primo_nao_primo_campos);
    for uA := 0 to indice_ultima_coluna do
    begin
        coluna_atual := objControle.Columns.Add;
        coluna_atual.title.Alignment := TAlignment.taCenter;
        coluna_atual.Alignment := TAlignment.taCenter;
        coluna_atual.title.Caption := primo_nao_primo_campos[uA];
        objControle.Cells[uA, 0] := primo_nao_primo_campos[uA];
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
 Carrega o controle com todas as combinações primo e nao-primo de todos os
 concursos que saíram em ordem decrescente de concurso.
}
procedure CarregarPrimoNaoPrimoPorConcurso(objControle: TStringGrid);
const
    primo_nao_primo_campos: array[0..2] of string = (
        'concurso',
        'primo',
        'nao_primo'
        );
var
    strSql:      TStrings;
    dsLotofacil: TSqlQuery;
    uLinha, uA:  integer;
    qt_registros: longint;
begin
    // Só iremos manipular StringGrid
    if not (objControle is TStringGrid) then
    begin
        Exit;
    end;

    // Configurar controle.
    ConfigurarControlesPrimoNaoPrimoPorConcurso(objControle);

    // Cria o sql
    strSql := TStringList.Create;
    strSql.add('Select concurso, primo, nao_primo from');
    strSql.add('lotofacil.v_lotofacil_resultado_primo_nao_primo');
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
        for uA := 0 to High(primo_nao_primo_campos) do
        begin
            objControle.Cells[uA, uLinha] :=
                IntToStr(dsLotofacil.FieldByName(primo_nao_primo_campos[uA]).AsInteger);
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




end.
