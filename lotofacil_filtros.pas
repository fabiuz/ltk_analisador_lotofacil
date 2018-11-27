{
 Unit que refere-se a tudo relacionado a filtros.
}
unit lotofacil_filtros;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Grids, ZConnection, ZDataset, lotofacil_var_global, Controls,
    //lotofacil_sgr_controle,
    strutils, ExtCtrls;

procedure carregar_filtro_sgr_controle(sgr_controle: TStringGrid; sql_conexao: TZConnection);
procedure marcar_sim_nao_pra_coluna(sgr_controle: TStringGrid; sim_ou_nao: string);
procedure obter_filtro(sgr_controle: TStringGrid; sql_conexao: TZConnection);
procedure alterar_marcador_sim_nao(sgr_controle: TStringGrid; aCol, aRow: integer);
function configurar_sgr_controle(sgr_controle: TStringGrid): boolean;

procedure Filtro_Excluir(filtro_data_hora_brasil: ansistring; sql_conexao: TZConnection);

procedure filtro_chk_controle_obter_opcoes_selecionadas(chk_controle: TCheckGroup);
procedure atualizar_filtro_controle_binario(controle_tag_id: integer; sql_conexao: TZConnection);

function configurar_filtro_estatistica_por_concurso(sgr_controle: TStringGrid): boolean;
procedure atualizar_estatistica_por_concurso(controle_tag_id: Integer; sql_conexao: TZConnection);
procedure obter_estatistica_por_concurso(sgr_controle: TStringGrid; sql_conexao: TZConnection);

procedure obter_filtro_binario(sgr_controle: TStringGrid; sql_conexao: TZConnection);
function configurar_filtro_binario_sgr_controle(sgr_controle: TStringGrid): boolean;
procedure filtro_binario_rd_controle_alterou(rd_controle: TRadioGroup);

procedure filtro_excluir_todos(sql_conexao: TZConnection);

implementation

uses Dialogs;

{
 Exclui filtro selecionado pelo usuário, a filtro a excluir é igual a data no formato brasileiro:
 dd-mm-yyyy hh:nn:ss.mi
}
procedure Filtro_Excluir(filtro_data_hora_brasil: ansistring; sql_conexao: TZConnection);
var
    sql_query: TZQuery;
    data_hora, Data: TStringArray;
    filtro_data_hora_brasil_original: string;
begin

    // Verifica se realmente deseja excluir o filtro.
    if mrNo = MessageDlg('', 'Deseja excluir o filtro criado em ' + filtro_data_hora_brasil +
        '?', mtConfirmation, [mbYes, mbNo], 0) then
    begin
        Exit;
    end;

    if filtro_data_hora_brasil = '' then
    begin
        Exit;
    end;

    // Armazena o filtro original, pra ser exibido caso o filtro seja
    // excluído com sucesso.
    filtro_data_hora_brasil_original := filtro_data_hora_brasil;

    // A data está em formato brasileiro, assim: dd-mm-yyyy hh:nn:ss.mi
    // Vamos criar um arranjo, pra isto, o campo data é separado do campo tempo por um
    // espaço.
    data_hora := filtro_data_hora_brasil.Split(' ');

    if Length(data_hora) <> 2 then
    begin
        MessageDlg('', 'Erro, deve haver um espaço separado a data e hora.',
            mtError, [mbOK], 0);
        Exit;
    end;

    // Agora, iremos separar a parte data, em dia, mes e ano.
    Data := data_hora[0].Split('-');

    // Deve haver 3 valores.
    if Length(Data) <> 3 then
    begin
        MessageDlg('',
            'Erro, os campos de dia, mês e ano, deve ser interseparados pelo caractere ' +
            '-', mtError, [mbOK], 0);
        Exit;
    end;

    // Ficará desta forma:
    // data[0] => dia
    // data[1] => mes
    // data[2] => ano

    // Na tabela 'lotofacil_filtros', o campo data está em formato americano,
    // entretanto, o string de data passado na procedure está no formato brasileiro,
    // pois, a caixa de combinação exibe sempre no formato brasileiro,
    // na atribuição abaixo, iremos converter pra o formato americano.
    filtro_data_hora_brasil := Data[2] + '-' + Data[1] + '-' + Data[0] + ' ' + data_hora[1];

    try
        sql_query := TZQuery.Create(nil);

        sql_query.Connection := sql_conexao;
        sql_query.Connection.Connected := False;
        sql_query.Connection.AutoCommit := False;

        sql_query.Close;
        sql_query.SQL.Clear;
        sql_query.Sql.Add('Delete from lotofacil.lotofacil_filtros');
        sql_query.Sql.Add('where data = ' + QuotedStr(filtro_data_hora_brasil));
        sql_query.ExecSQL;

        sql_query.Connection.Commit;
        sql_query.Connection.Connected := False;

        sql_query.Close;
        FreeAndNil(sql_query);

    except
        on Exc: Exception do
        begin
            MessageDlg('', 'Erro, ' + exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    MessageDlg('', 'Filtro ' + filtro_data_hora_brasil_original,
        mtInformation, [mbOK], 0);

end;

{
 Na análise estatística por bolas, ou estatística baseada nas tabelas binárias, temos três
 controles: checkGroup, que armazena a quantidade de bolas que devemos excluir, o controle
 button que chama esta procedure passando um id da tag do controle, este id corresponde
 a uma chave na variável global 'mapa_filtro_binario_info', que armazena todos os controles
 que está relacionada a estatística de onde o button foi chamado.
}
procedure atualizar_filtro_controle_binario(controle_tag_id: integer; sql_conexao: TZConnection);
var
    chk_controle: TCheckGroup;
    filtro_info: R_Filtro_Binario_Controle;
    bolas_a_excluir: string;
    uA: integer;
    sgr_controle: TStringGrid;
begin
    if mapa_filtro_binario_info.IndexOf(controle_tag_id) = -1 then
    begin
        Exit;
    end;

    // Obter informações dos controles que iremos utilizar.
    filtro_info := mapa_filtro_binario_info.KeyData[controle_tag_id];
    chk_controle := filtro_info.chk_controle;
    filtro_chk_controle_obter_opcoes_selecionadas(chk_controle);

    // Popula o controle com os filtros.
    sgr_controle := filtro_info.sgr_controle;
    obter_filtro_binario(sgr_controle, sql_conexao);

    // Configura o controle, antes de atualizar.
    //sgr_controle := filtro_info.sgr_controle;
    //configurar_filtro_binario_sgr_controle(sgr_controle);
end;

procedure atualizar_filtro_por_concurso(controle_tag_id: Integer;
  sql_conexao: TZConnection);
begin

end;

{
 Obtém as opções selecionadas pelo usuário referente às bolas por combinação
 que deve ser excluída dos filtros.
}
procedure filtro_chk_controle_obter_opcoes_selecionadas(chk_controle: TCheckGroup);
var
    controle_tag_id, uA: integer;
    bolas_a_excluir: string;
    filtro_info: R_Filtro_Binario_Controle;
begin
    controle_tag_id := chk_controle.Tag;
    if mapa_filtro_binario_info.IndexOf(controle_tag_id) = -1 then
    begin
        Exit;
    end;

    bolas_a_excluir := '';
    for uA := 0 to Pred(chk_controle.Items.Count) do
    begin
        if chk_controle.Checked[uA] then
        begin
            if bolas_a_excluir <> '' then
            begin
                bolas_a_excluir := bolas_a_excluir + ',';
            end;
            bolas_a_excluir := bolas_a_excluir + chk_controle.Items[uA];
        end;
    end;
    if bolas_a_excluir <> '' then
    begin
        bolas_a_excluir := 'where bin_qt not in(' + bolas_a_excluir + ')';
    end;
    filtro_info := mapa_filtro_binario_info.KeyData[controle_tag_id];
    filtro_info.chk_controle_excluir_bolas := bolas_a_excluir;
    mapa_filtro_binario_info.KeyData[controle_tag_id] := filtro_info;
end;

{
 Todos os controles de filtros, é configurado através desta procedure.
}
function configurar_sgr_controle(sgr_controle: TStringGrid): boolean;
var
    ultima_coluna, uA: integer;
    coluna_atual: TGridColumn;
    cabecalho_do_controle: array of string;
    indice_tag: integer;
    sgr_controle_info: R_Filtro_Controle;
begin
    // Se a tag tem o valor -1, quer dizer, que não há um arranjo
    // pra configurar os campos.
    indice_tag := sgr_controle.Tag;
    if (indice_tag < 0) or (indice_tag > high(sgr_filtro_cabecalho)) then
    begin
        Exit(False);
    end;

    sgr_controle_info := sgr_filtro_controle_info[indice_tag];

    // Obtém o cabeçalho, que está no na dimensão 1, no índice 1,
    // Vamos colocar o string todo em maiúsculas antes de retornar o arranjo.
    //cabecalho_do_controle := AnsiLowerCase(sgr_filtro_cabecalho[indice_tag]).Split(',');
    cabecalho_do_controle := sgr_controle_info.sgr_controle_cabecalho.Split(',');
    ultima_coluna := High(cabecalho_do_controle);

    sgr_controle.Columns.Clear;
    for uA := 0 to ultima_coluna do
    begin
        coluna_atual := sgr_controle.Columns.Add;
        coluna_atual.Title.Caption := cabecalho_do_controle[uA];
        coluna_atual.Title.Alignment := taCenter;
        coluna_atual.Alignment := taCenter;
    end;

    // Coluna 0 contém o id, deve está oculta.
    sgr_controle.columns[0].Visible := False;

    // As duas últimas colunas 'SIM', 'NAO'
    sgr_controle.Columns[ultima_coluna].ButtonStyle := cbsCheckboxColumn;
    sgr_controle.Columns[ultima_coluna - 1].ButtonStyle := cbsCheckboxColumn;

    sgr_controle.RowCount := 1;
    sgr_controle.FixedRows := 1;
    sgr_controle.AutoSizeColumns;

    Exit(True);
end;

{
 Todos os controles de filtros binários, é configurado através desta procedure.
}
function configurar_filtro_binario_sgr_controle(sgr_controle: TStringGrid): boolean;
var
    ultima_coluna, uA: integer;
    coluna_atual:    TGridColumn;
    cabecalho_do_controle: array of string;
    indice_tag:      integer;
    sgr_controle_info: R_Filtro_Controle;
    controle_tag_id: integer;
    filtro_info:     R_Filtro_Binario_Controle;
begin
    controle_tag_id := sgr_controle.Tag;
    if mapa_filtro_binario_info.IndexOf(controle_tag_id) = -1 then
    begin
        Exit(False);
    end;
    filtro_info := mapa_filtro_binario_info.KeyData[controle_tag_id];

    // Vamos colocar o string todo em maiúsculas antes de retornar o arranjo.
    cabecalho_do_controle := filtro_info.sgr_controle_cabecalho.Split(',');
    ultima_coluna := High(cabecalho_do_controle);

    sgr_controle.Columns.Clear;
    for uA := 0 to ultima_coluna do
    begin
        coluna_atual := sgr_controle.Columns.Add;
        coluna_atual.Title.Caption := cabecalho_do_controle[uA];
        coluna_atual.Title.Alignment := taCenter;
        coluna_atual.Alignment := taCenter;
    end;

    // Coluna 0 contém o id, deve está oculta.
    sgr_controle.columns[0].Visible := False;

    // As duas últimas colunas 'SIM', 'NAO'
    sgr_controle.Columns[ultima_coluna].ButtonStyle := cbsCheckboxColumn;
    sgr_controle.Columns[ultima_coluna - 1].ButtonStyle := cbsCheckboxColumn;

    sgr_controle.RowCount := 1;
    sgr_controle.FixedRows := 1;
    sgr_controle.AutoSizeColumns;

    Exit(True);
end;

{
    ************************** ESTATÍSTICA POR CONCURSO *************************

}
function configurar_filtro_estatistica_por_concurso(sgr_controle: TStringGrid): boolean;
var
    ultima_coluna, uA: integer;
    coluna_atual:    TGridColumn;
    cabecalho_do_controle: array of string;
    indice_tag:      integer;
    //sgr_controle_info: R_Filtro_Controle;
    controle_tag_id: integer;
    filtro_info:     R_Filtro_Info;
begin
    controle_tag_id := sgr_controle.Tag;
    if mapa_filtro_estatistica_por_concurso.IndexOf(controle_tag_id) = -1 then
    begin
        Exit(False);
    end;
    filtro_info := mapa_filtro_estatistica_por_concurso.KeyData[controle_tag_id];

    // Vamos colocar o string todo em maiúsculas antes de retornar o arranjo.
    cabecalho_do_controle := filtro_info.sgr_controle_cabecalho.Split(',');
    ultima_coluna := High(cabecalho_do_controle);

    sgr_controle.Columns.Clear;
    for uA := 0 to ultima_coluna do
    begin
        coluna_atual := sgr_controle.Columns.Add;
        coluna_atual.Title.Caption := cabecalho_do_controle[uA];
        coluna_atual.Title.Alignment := taCenter;
        coluna_atual.Alignment := taCenter;
    end;

    // Na estatística por concurso, não temos id.
    // Coluna 0 contém o id, deve está oculta.
    //sgr_controle.columns[0].Visible := False;

    // As duas últimas colunas 'SIM', 'NAO'
    // Nos controles de estatísticas por concurso, não haverá as colunas 'nao' e 'sim'.
    //sgr_controle.Columns[ultima_coluna].ButtonStyle := cbsCheckboxColumn;
    //sgr_controle.Columns[ultima_coluna - 1].ButtonStyle := cbsCheckboxColumn;

    sgr_controle.RowCount := 1;
    sgr_controle.FixedRows := 1;
    sgr_controle.AutoSizeColumns;

    Exit(True);
end;


procedure atualizar_estatistica_por_concurso(controle_tag_id: Integer;
  sql_conexao: TZConnection);
var
    chk_controle: TCheckGroup;
    //filtro_info: R_Filtro_Binario_Controle;
    filtro_info: R_Filtro_Info;
    bolas_a_excluir: string;
    uA: integer;
    sgr_controle: TStringGrid;
begin
    if mapa_filtro_estatistica_por_concurso.IndexOf(controle_tag_id) = -1 then
    begin
        Exit;
    end;

    // Obter informações dos controles que iremos utilizar.
    filtro_info := mapa_filtro_estatistica_por_concurso.KeyData[controle_tag_id];
    //chk_controle := filtro_info.chk_controle;
    //filtro_chk_controle_obter_opcoes_selecionadas(chk_controle);

    // Popula o controle com os filtros.
    sgr_controle := filtro_info.sgr_controle;
    //obter_filtro_binario(sgr_controle, sql_conexao);
    obter_estatistica_por_concurso(sgr_controle, sql_conexao);

    // Configura o controle, antes de atualizar.
    //sgr_controle := filtro_info.sgr_controle;
    //configurar_filtro_binario_sgr_controle(sgr_controle);
end;

procedure obter_estatistica_por_concurso(sgr_controle: TStringGrid; sql_conexao: TZConnection);
var
    ultima_coluna: integer;
    sql_query:     TZQuery;
    sql_campos:    array of string;
    qt_registros, linha_sgr_controle, uA: integer;
    valor_do_campo_atual: string;
    //sgr_controle_info: R_Filtro_Controle;
    controle_tag_id: integer;
    filtro_info:   R_Filtro_Info;
begin
    // Verifica se a tag existe no mapa de filtros.
    controle_tag_id := sgr_controle.Tag;
    if mapa_filtro_estatistica_por_concurso.IndexOf(controle_tag_id) = -1 then
    begin
        Exit;
    end;

    // Configura o controle.
    if configurar_filtro_estatistica_por_concurso(sgr_controle) = False then
    begin
        Exit;
    end;

    filtro_info := mapa_filtro_estatistica_por_concurso.KeyData[controle_tag_id];
    sql_campos := filtro_info.sql_campos.Split(',');

    ultima_coluna := High(sql_campos);
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;

        sql_query.Sql.Clear;
        sql_query.Sql.Add(filtro_info.sql);
        sql_query.Sql.Add(filtro_info.sql_order_by);

        sql_query.Open;

        // Vamos do primeiro ao último registro pra descobrir a quantidade de registros.
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        // Se não há registros, apagar o controle e exibir mensagem.
        if qt_registros <= 0 then
        begin
            sgr_controle.Columns.Clear;
            sgr_controle.Columns.Add;
            sgr_controle.Columns[0].Alignment := tacenter;
            sgr_controle.FixedRows := 0;
            sgr_controle.cells[0, 0] := 'Erro, não há filtros';
            sgr_controle.AutoSizeColumns;
            Exit;
        end;

        // Será 1 linha a mais por causa do cabeçalho na linha 0.
        sgr_controle.RowCount := qt_registros + 1;
        linha_sgr_controle := 1;
        sgr_controle.BeginUpdate;
        // Iremos percorre todos os registros e iremos inserir no controle
        sql_query.First;
        while sql_query.EOF = False do
        begin
            for uA := 0 to ultima_coluna do
            begin
                valor_do_campo_atual := sql_query.FieldByName(sql_campos[uA]).AsString;
                sgr_controle.Cells[uA, linha_sgr_controle] := valor_do_campo_atual;
            end;
            // Observe no loop for acima, que somente populamos as colunas que vem dados
            // da tabela, há duas outras colunas 'SIM' e 'NAO' que não está incluída no loop
            // for acima, devemos definir o valor de ambas pra zero.
            // Na guia por concurso não haverá os campos 'nao' e 'sim'.
            //sgr_controle.Cells[ultima_coluna + 1, linha_sgr_controle] := '0';
            //sgr_controle.Cells[ultima_coluna + 2, linha_sgr_controle] := '0';

            sql_query.Next;
            Inc(linha_sgr_controle);
        end;
        sgr_controle.EndUpdate(True);
        sql_query.Close;
        FreeAndNil(sql_query);
    except
        On exc: Exception do
        begin
            sql_query.Close;
            FreeAndNil(sql_query);
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    FreeAndNil(sql_query);
    sgr_controle.AutoSizeColumns;
end;

{
 Nesta procedure, iremos popular o controle TStringGrid, com os filtros obtidos
 da estatística a qual o controle se relaciona.
}
procedure obter_filtro_binario(sgr_controle: TStringGrid; sql_conexao: TZConnection);
var
    ultima_coluna: integer;
    sql_query:     TZQuery;
    sql_campos:    array of string;
    qt_registros, linha_sgr_controle, uA: integer;
    valor_do_campo_atual: string;
    sgr_controle_info: R_Filtro_Controle;
    controle_tag_id: integer;
    filtro_info:   R_Filtro_Binario_Controle;
begin
    // Verifica se a tag existe no mapa de filtros.
    controle_tag_id := sgr_controle.Tag;
    if mapa_filtro_binario_info.IndexOf(controle_tag_id) = -1 then
    begin
        Exit;
    end;

    // Configura o controle.
    if configurar_filtro_binario_sgr_controle(sgr_controle) = False then
    begin
        Exit;
    end;

    filtro_info := mapa_filtro_binario_info.KeyData[controle_tag_id];
    sql_campos := filtro_info.sql_campos.Split(',');

    ultima_coluna := High(sql_campos);
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;

        sql_query.Sql.Clear;
        sql_query.Sql.Add(filtro_info.sql);
        // Indica as bolas a excluir
        // ex: bin_qt not in (1, 2)
        sql_query.SQL.Add(filtro_info.chk_controle_excluir_bolas);
        sql_query.Sql.Add(filtro_info.sql_order_by);

        sql_query.Open;

        // Vamos do primeiro ao último registro pra descobrir a quantidade de registros.
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        // Se não há registros, apagar o controle e exibir mensagem.
        if qt_registros <= 0 then
        begin
            sgr_controle.Columns.Clear;
            sgr_controle.Columns.Add;
            sgr_controle.Columns[0].Alignment := tacenter;
            sgr_controle.FixedRows := 0;
            sgr_controle.cells[0, 0] := 'Erro, não há filtros';
            sgr_controle.AutoSizeColumns;
            Exit;
        end;

        // Será 1 linha a mais por causa do cabeçalho na linha 0.
        sgr_controle.RowCount := qt_registros + 1;
        linha_sgr_controle := 1;
        sgr_controle.BeginUpdate;
        // Iremos percorre todos os registros e iremos inserir no controle
        sql_query.First;
        while sql_query.EOF = False do
        begin
            for uA := 0 to ultima_coluna do
            begin
                valor_do_campo_atual := sql_query.FieldByName(sql_campos[uA]).AsString;
                sgr_controle.Cells[uA, linha_sgr_controle] := valor_do_campo_atual;
            end;
            // Observe no loop for acima, que somente populamos as colunas que vem dados
            // da tabela, há duas outras colunas 'SIM' e 'NAO' que não está incluída no loop
            // for acima, devemos definir o valor de ambas pra zero.
            sgr_controle.Cells[ultima_coluna + 1, linha_sgr_controle] := '0';
            sgr_controle.Cells[ultima_coluna + 2, linha_sgr_controle] := '0';

            sql_query.Next;
            Inc(linha_sgr_controle);
        end;
        sgr_controle.EndUpdate(True);
        sql_query.Close;
        FreeAndNil(sql_query);
    except
        On exc: Exception do
        begin
            sql_query.Close;
            FreeAndNil(sql_query);
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    FreeAndNil(sql_query);
    sgr_controle.AutoSizeColumns;
end;

{
 Carrega o controle do tipo 'TStringGrid' com os filtros conforme a estatística a qual
 aquele controle se refere.
}
procedure carregar_filtro_sgr_controle(sgr_controle: TStringGrid; sql_conexao: TZConnection);
begin
    obter_filtro(sgr_controle, sql_conexao);
end;

{
 Nesta procedure, iremos conectar no banco de dados e recuperar
 a tabela corresponde ao filtro conforme o controle que foi passado
 no parâmetro.
}
procedure obter_filtro(sgr_controle: TStringGrid; sql_conexao: TZConnection);
var
    ultima_coluna: integer;
    sql_query:     TZQuery;
    sql_campos:    array of string;
    qt_registros, linha_sgr_controle, uA: integer;
    valor_do_campo_atual: string;
    indice_tag:    integer;
    sgr_controle_info: R_Filtro_Controle;
begin

    if configurar_sgr_controle(sgr_controle) = False then
    begin
        Exit;
    end;

    // Pra os controles que começa em 'sgr_cmp_b', não iremos popular
    // nenhum conteúdo pois, será renderizado, de outra forma.
    if AnsiStartsStr('sgr_cmp_', LowerCase(sgr_controle.Name)) then
    begin
        Exit;
    end;

    // Obtém o índice.
    indice_tag := sgr_controle.tag;

    // Verifica se o índice está na faixa válida.
    indice_tag := sgr_controle.Tag;
    if (indice_tag < 0) or (indice_tag > high(sgr_filtro_controle_info)) then
    begin
        Exit;
    end;

    // Obtém o registro que corresponde ao controle.
    sgr_controle_info := sgr_filtro_controle_info[indice_tag];

    // Se não há sql, devemos retornar pois, provavelmente, o controle será populado
    // posteriormente.
    if trim(sgr_controle_info.sql) = '' then
    begin
        Exit;
    end;

    sql_campos := sgr_controle_info.sql_campos.Split(',');
    ultima_coluna := High(sql_campos);

    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;

        sql_query.Sql.Clear;
        sql_query.Sql.Add(sgr_controle_info.sql);

        sql_query.Open;

        // Vamos do primeiro ao último registro pra descobrir a quantidade de registros.
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        // Se não há registros, apagar o controle e exibir mensagem.
        if qt_registros <= 0 then
        begin
            sgr_controle.Columns.Clear;
            sgr_controle.Columns.Add;
            sgr_controle.Columns[0].Alignment := tacenter;
            sgr_controle.FixedRows := 0;
            sgr_controle.cells[0, 0] := 'Erro, não há filtros';
            sgr_controle.AutoSizeColumns;
            Exit;
        end;

        // Será 1 linha a mais por causa do cabeçalho na linha 0.
        sgr_controle.RowCount := qt_registros + 1;
        linha_sgr_controle := 1;

        // Iremos percorre todos os registros e iremos inserir no controle
        sql_query.First;
        while sql_query.EOF = False do
        begin
            for uA := 0 to ultima_coluna do
            begin
                valor_do_campo_atual := sql_query.FieldByName(sql_campos[uA]).AsString;
                sgr_controle.Cells[uA, linha_sgr_controle] := valor_do_campo_atual;
            end;
            // Observe no loop for acima, que somente populamos as colunas que vem dados
            // da tabela, há duas outras colunas 'SIM' e 'NAO' que não está incluída no loop
            // for acima, devemos definir o valor de ambas pra zero.
            sgr_controle.Cells[ultima_coluna + 1, linha_sgr_controle] := '0';
            sgr_controle.Cells[ultima_coluna + 2, linha_sgr_controle] := '0';

            sql_query.Next;
            Inc(linha_sgr_controle);
        end;
        sql_query.Close;
        FreeAndNil(sql_query);
    except
        On exc: Exception do
        begin
            sql_query.Close;
            FreeAndNil(sql_query);
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    FreeAndNil(sql_query);
    sgr_controle.AutoSizeColumns;
end;

{
 Na procedure abaixo irá funcionar desta forma:
 Se a célula clicada está na coluna 'sim' ou 'não', devemos alterar o valor da célula de 0 pra 1,
 ou de 1 pra 0.
 Devemos fazer isto, pois, a coluna que tem o estilo 'cbsCheckboxColumn' quando clicamos em
 qualquer célula desta coluna o estado do checkbox não se altera.
 Então, quando a célula tem o valor '0' quer dizer que o estado dela é unchecked, senão se tem
 o valor '1', o estado dela é 'checked'.
 Então, se ao clicar na célula, o valor é '0', devemos alterar pra '1' e se o valor é '1' devemos
 alterar pra '0'.
 Observe, que neste programa, temos duas colunas que tem o estilo 'cbsCheckboxColumn', tais colunas
 tem o nome de 'sim' ou 'não'.
 As duas células da mesma linhas não podem ter o mesmo valor '1'.

 Nos controles de filtros, o objetivo é marcar 'sim' se deseja que aquele filtro saia e 'não'
 se não quer que o filtro não saía.
 Entretanto, aqui temos um detalhe, se o usuário não marca nenhum filtro, isto quer dizer
 que todos os filtros irão ser escolhidos, pois não limitamos os resultados.

 Então, devemos fazer isto
 Se o usuário escolhe uma célula da coluna 'sim' devemos desmarcar automaticamente a célula
 da coluna 'não' da mesma linha que a célula 'sim'.
 O mesmo ocorre pra o 'não', se o usuário escolhe 'não' devemos desmarcar automaticamente a célula
 corresponde na coluna 'sim'.
 Se o usuário desmarca o 'sim', não precisa desmarcar a outra célula da mesma linha da coluna 'nao'.
}
procedure alterar_marcador_sim_nao(sgr_controle: TStringGrid; aCol, aRow: integer);
var
    ultima_coluna, penultima_coluna: integer;
    celula_ultima_coluna: string;
    celula_penultima_coluna: string;
    titulo_da_coluna: string;
begin
    // Se não há colunas retornar.
    if sgr_controle.Columns.Count <= 0 then
        Exit;

    // Em todas as colunas dos controles TStringGrid, deve haver títulos, pois
    // assim, conseguirmos identificar qual coluna estamos manipulando.
    if not Assigned(sgr_controle.Columns[aCol].Title) then
    begin
        Exit;
    end;

    // Aqui, iremos analisar somente colunas com o título sim e com o título não.
    titulo_da_coluna := LowerCase(sgr_controle.Columns[aCol].Title.Caption);
    if (titulo_da_coluna <> 'sim') and (titulo_da_coluna <> 'nao') then
    begin
        Exit;
    end;

    // Por padrão, as colunas 'não' e 'sim'
    // Última coluna: 'SIM'.
    // Penúltima coluna: 'NAO'.
    ultima_coluna := Pred(sgr_controle.Columns.Count);
    penultima_coluna := ultima_coluna - 1;

    // Aqui, a célula pode estar em uma linha qualquer, quando
    // informamos celula_ultima_coluna, não quer dizer todas as células
    // daquela coluna e sim a célula da linha e coluna especificada.
    celula_ultima_coluna := sgr_controle.Cells[ultima_coluna, ARow];
    celula_penultima_coluna := sgr_controle.Cells[penultima_coluna, ARow];

    // Vamos alterar o valor da célula atual e depois
    // analisar se devemos desmarcar a outra coluna.
    if ACol = ultima_coluna then
    begin
        if celula_ultima_coluna = '0' then
        begin
            celula_ultima_coluna := '1';
            celula_penultima_coluna := '0';
        end
        else if celula_ultima_coluna = '1' then
        begin
            celula_ultima_coluna := '0';
            celula_penultima_coluna := '0';
        end;
    end
    else if ACol = penultima_coluna then
    begin
        if celula_penultima_coluna = '0' then
        begin
            celula_penultima_coluna := '1';
            celula_ultima_coluna := '0';
        end
        else if celula_penultima_coluna = '1' then
        begin
            celula_penultima_coluna := '0';
            celula_ultima_coluna := '0';
        end;
    end;

    // Agora, atualiza o controle.
    sgr_controle.Cells[ultima_coluna, ARow] := celula_ultima_coluna;
    sgr_controle.Cells[penultima_coluna, ARow] := celula_penultima_coluna;

end;

{
 Este procedure marcar/desmarca todas as células de uma coluna com o título 'não' ou 'sim'.
 Esta procedure é utiliza pelo controles:
}
procedure marcar_sim_nao_pra_coluna(sgr_controle: TStringGrid; sim_ou_nao: string);
var
    indice_ultima_coluna: integer;
    indice_penultima_coluna, linha_atual, indice_ultima_linha, coluna_atual: integer;
    titulo_ultima_linha, titulo_ultima_coluna, titulo_penultima_coluna: string;
begin
    indice_ultima_coluna := Pred(sgr_controle.Columns.Count);
    indice_penultima_coluna := indice_ultima_coluna - 1;

    if indice_ultima_coluna <= 0 then
    begin
        Exit;
    end;

    // Verifica se tem um título a coluna, pois
    // os controles de filtros, tem título no cabeçalho.
    if not Assigned(sgr_controle.Columns[indice_ultima_coluna].Title) then
    begin
        Exit;
    end;

    if not Assigned(sgr_controle.Columns[indice_penultima_coluna].Title) then
    begin
        Exit;
    end;

    // No controle que armazena os filtros, a última coluna tem o título 'sim'
    // e a penúltima coluna, o título 'não'.
    titulo_ultima_coluna := AnsiLowerCase(sgr_controle.Columns[indice_ultima_coluna].Title.Caption);

    titulo_penultima_coluna :=
        AnsiUpperCase(sgr_controle.Columns[indice_penultima_coluna].Title.Caption);

    if (titulo_ultima_coluna <> 'sim') and (titulo_penultima_coluna <> 'nao') then
    begin
        Exit;
    end;

    // Só iremos marcar se houver registros.
    indice_ultima_linha := Pred(sgr_controle.RowCount);
    if indice_ultima_linha <= 0 then
    begin
        Exit;
    end;

    // Aqui, iremos indicar qual coluna alterar.
    sim_ou_nao := AnsiLowerCase(sim_ou_nao);
    if sim_ou_nao = 'nao' then
    begin

        linha_atual := 1;
        for linha_atual := 1 to indice_ultima_linha do
        begin
            sgr_controle.Cells[indice_penultima_coluna, linha_atual] := '1';
            sgr_controle.Cells[indice_ultima_coluna, linha_atual] := '0';
        end;

    end
    else if sim_ou_nao = 'sim' then
    begin

        linha_atual := 1;
        for linha_atual := 1 to indice_ultima_linha do
        begin
            sgr_controle.Cells[indice_penultima_coluna, linha_atual] := '0';
            sgr_controle.Cells[indice_ultima_coluna, linha_atual] := '1';
        end;

    end
    else if sim_ou_nao = '' then
    begin

        linha_atual := 1;
        for linha_atual := 1 to indice_ultima_linha do
        begin
            sgr_controle.Cells[indice_penultima_coluna, linha_atual] := '0';
            sgr_controle.Cells[indice_ultima_coluna, linha_atual] := '0';
        end;

    end;
end;

{
 Todo os controles com o prefixo 'rd_bin_' chamará este procedure toda vez
 que o evento 'OnSelectionChanged' ocorrer.
 Cada estatística tem três controles principais, com os prefixos:
 'chk_bin_', indica quais bolas por combinação excluir ao atualizar.
 'btn_bin_', botão que serve pra atualizar os filtros.
 'sgr_bin_', controle 'TStringGrid' que armazena os filtros.
 'rd_bin_',  controle que facilita marcar todas as células da coluna 'sim' ou 'não'.
 Tais controles estão interligados através da propriedade 'tag' do controle,
 então, toda vez, que por exemplo, o usuário clicar no botão com o prefixo 'btn_bin',
 iremos identificar de qual estatística aquele botão pertence.
 Cada controle tem a tag definida pra uma constante que indica de qual estatística
 se refere, então, por exemplo, se a tag do controle for 'ID_BIN_PAR', então,
 aquele controle refere-se ao filtro binário de números pares.
 Então, existe uma variável global 'mapa_filtro_binario' que mapea a constante
 pra um variável do tipo 'r_filtro_binario_info', que armazena todos os controles
 e outras informações referente àquela estatística.
 Então, toda vez que o usuário altera o controle com o prefixo 'rd_bin_', o
 controle 'sgr_bin_' corresponde é atualizado.
}
procedure filtro_binario_rd_controle_alterou(rd_controle: TRadioGroup);
const
    ID_MARCAR_NAO     = 0;
    ID_MARCAR_SIM     = 1;
    ID_DESMARCAR_TUDO = 2;
    ID_MARCACAO_PARCIAL = 3;
var
    controle_tag_id: integer;
    sgr_controle:    TStringGrid;
    filtro_info:     R_Filtro_Binario_Controle;
begin
    controle_tag_id := rd_controle.Tag;
    if mapa_filtro_binario_info.IndexOf(controle_tag_id) = -1 then
    begin
        Exit;
    end;

    filtro_info := mapa_filtro_binario_info.KeyData[controle_tag_id];

    sgr_controle := filtro_info.sgr_controle;
    if not Assigned(sgr_controle) then
    begin
        Exit;
    end;

    // Se índice é 0, o usuário deseja selecionar todas as células da coluna 'sim'.
    if rd_controle.ItemIndex = ID_MARCAR_SIM then
    begin
        marcar_sim_nao_pra_coluna(sgr_controle, 'sim');
    end
    else if rd_controle.ItemIndex = ID_MARCAR_NAO then
    begin
        marcar_sim_nao_pra_coluna(sgr_controle, 'nao');
    end
    else if rd_controle.ItemIndex = ID_DESMARCAR_TUDO then
    begin
        marcar_sim_nao_pra_coluna(sgr_controle, '');
    end;
end;

{
 Exclui todos os filtros, pergunta antes se deseja realmente excluir.
}
procedure filtro_excluir_todos(sql_conexao: TZConnection);
var
    sql_query: TZQuery;
begin
    if mrNo = MessageDlg('', 'Deseja excluir todos os concurso???', mtInformation, [mbYes, mbNo], 0) then
    begin
        Exit;
    end;

    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Truncate d_sorte.d_sorte_filtros');
        sql_query.ExecSql;
    except
        On exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            sql_conexao.Rollback;
        end;
    end;
    FreeAndNil(sql_query);
    MessageDlg('', 'Todos os filtros foram excluídos com sucesso!!!', mtInformation, [mbOK], 0);
end;

end.
