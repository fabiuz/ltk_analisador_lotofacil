unit lotofacil_gerar_filtros;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, lotofacil_constantes, fgl, Grids, Dialogs,
    ZDataSet, ZConnection, lotofacil_var_global;

type
    TList_StringGrid = specialize TFPGList<TStringGrid>;

{
 Ao gerar filtros, iremos pegar o campo id de cada controle,
 pois esta é a informação que precisamos.
}
procedure configurar_campo_id_dos_controles(var campo_id: TStringArray);
procedure Gerar_Filtros(lista_sgr_controle: TList_StringGrid; sql_conexao: TZConnection);
function obter_id_dos_filtros(lista_sgr_controle: TList_StringGrid): string;
function gerar_sql_dos_ids_obtidos(id_obtidos: string;
    sql_conexao: TZConnection): boolean;
procedure atualizar_controle_sgr_filtros(sgr_filtros: TStringGrid;
    str_filtro_data_hora: string; sql_conexao: TZConnection);
procedure configurar_sgr_filtros(sgr_filtros: TStringGrid);
procedure atualizar_sgr_filtros(sgr_filtros: TStringGrid;
    str_filtro_data_hora: string; sql_conexao: TZConnection);
procedure filtro_excluir(sql_conexao: TZConnection; filtro_data_hora: string);
procedure filtro_excluir_todos(sql_conexao: TZConnection);


implementation

uses
    Controls;

var
    campo_id_temporario: TStringArray;

const
    sgr_filtros_cabecalho: array[0..12] of string = (
        'filtros_id',
        'data',
        'acertos',
        'd_sorte_id',
        'd_sorte_qt',
        'b_1', 'b_2', 'b_3', 'b_4', 'b_5', 'b_6', 'b_7',
        'id_seq_cmb_em_grupos'
        );

procedure configurar_campo_id_dos_controles(var campo_id: TStringArray);
begin
    SetLength(campo_id, 27);
    campo_id[ID_PAR_IMPAR] := 'par_impar_id';
    campo_id[ID_PRIMO_NAO_PRIMO] := 'prm_id';
    campo_id[ID_EXTERNO_INTERNO] := 'ext_int_id';
    //campo_id[ID_HORIZONTAL] := 'hrz_id';
    //campo_id[ID_VERTICAL] := 'vrt_id';
    //campo_id[ID_DIAGONAL_ESQUERDA] := 'dge_id';
    //campo_id[ID_DIAGONAL_DIREITA] := 'dgd_id';
    //campo_id[ID_QUADRANTE] := 'qd_id';
    //campo_id[ID_ESQUERDA_DIREITA] := 'esq_dir_id';
    //campo_id[ID_SUPERIOR_INFERIOR] := 'sup_inf_id';
    //campo_id[ID_DEZENA] := 'dz_id';
    //campo_id[ID_UNIDADE] := 'un_id';
    //campo_id[ID_ALGARISMO] := 'alg_id';
    //campo_id[ID_SOMA_ALGARISMO] := 'sm_id';
    //campo_id[ID_SOMA_BOLAS] := 'sm_bolas';
    //campo_id[ID_B1_QT_VEZES] := 'b_1';
    //campo_id[ID_B2_QT_VEZES] := 'b_2';
    //campo_id[ID_B3_QT_VEZES] := 'b_3';
    //campo_id[ID_B4_QT_VEZES] := 'b_4';
    //campo_id[ID_B5_QT_VEZES] := 'b_5';
    //campo_id[ID_B6_QT_VEZES] := 'b_6';
    //campo_id[ID_B7_QT_VEZES] := 'b_7';
    campo_id[ID_NOVOS_REPETIDOS] := 'novos_repetidos_id';

    campo_id_temporario := campo_id;
end;

{
 Esta procedure chama outras funtions e procedures pra gerar
 o filtro.
}
procedure Gerar_Filtros(lista_sgr_controle: TList_StringGrid; sql_conexao: TZConnection);
var
    id_obtidos:     string;
    sql_foi_gerado: boolean;
begin
    id_obtidos := obter_id_dos_filtros(lista_sgr_controle);

    if id_obtidos = '' then
    begin
        MessageDlg('', 'Nenhum filtro foi selecionado!!!', mtError, [mbOK], 0);
        Exit;
    end;

    sql_foi_gerado := gerar_sql_dos_ids_obtidos(id_obtidos, sql_conexao);
    if sql_foi_gerado then
    begin
        MessageDlg('', 'Filtros gerados com sucesso!!!', mtError, [mbOK], 0);
    end;

end;

{
 Gera o sql dos id_obtidos dos controles, por exemplo, se o usuário selecionou
 os ids do controle 'sgr_par_impar', então, a variável 'id_obtidos' ficará desta forma:
 (par_impar_id in (1, 2))
}
function gerar_sql_dos_ids_obtidos(id_obtidos: string;
    sql_conexao: TZConnection): boolean;
var
    sql_query: TZQuery;
begin

    try
        sql_query := TZQuery.Create(nil);
        sql_query.connection := sql_conexao;
        sql_query.Sql.Add('Insert into d_sorte.d_sorte_filtros');
        sql_query.Sql.Add('(');
        sql_query.Sql.Add('data,');
        sql_query.Sql.Add('d_sorte_id,');
        sql_query.Sql.Add('d_sorte_qt,');
        sql_query.Sql.Add('concurso,');
        sql_query.Sql.Add('acertos,');
        sql_query.Sql.Add('id_seq_cmb_em_grupos,');
        sql_query.Sql.Add('id_seq_exc_novos_repetidos_id');
        sql_query.Sql.Add(')');
        sql_query.Sql.Add('Select Now(),');
        sql_query.Sql.Add('d_sorte.d_sorte_bolas.d_sorte_id,');
        sql_query.Sql.Add('d_sorte.d_sorte_bolas.d_sorte_qt,');
        sql_query.Sql.Add('1,');
        sql_query.Sql.Add('0,');
        sql_query.Sql.Add('id_seq_cmb_em_grupos,');
        sql_query.Sql.Add('id_seq_exc_novos_repetidos_id');
        sql_query.Sql.Add('from');
        sql_query.Sql.Add('d_sorte.d_sorte_bolas,');
        sql_query.Sql.Add('d_sorte.d_sorte_id,');
        sql_query.Sql.Add('d_sorte.d_sorte_combinacoes_em_grupos,');
        sql_query.Sql.Add('d_sorte.d_sorte_novos_repetidos');
        sql_query.Sql.Add('where d_sorte.d_sorte_bolas.d_sorte_id = d_sorte.d_sorte_id.d_sorte_id');
        sql_query.Sql.Add('and   d_sorte.d_sorte_bolas.d_sorte_id = d_sorte.d_sorte_combinacoes_em_grupos.d_sorte_id');
        sql_query.Sql.Add('and   d_sorte.d_sorte_bolas.d_sorte_id = d_sorte.d_sorte_novos_repetidos.d_sorte_id');
        sql_query.Sql.Add('and   d_sorte.d_sorte_id.d_sorte_id = d_sorte.d_sorte_combinacoes_em_grupos.d_sorte_id');
        sql_query.Sql.Add('and   d_sorte.d_sorte_id.d_sorte_id = d_sorte.d_sorte_novos_repetidos.d_sorte_id');
        sql_query.Sql.Add('and   d_sorte.d_sorte_combinacoes_em_grupos.d_sorte_id = d_sorte.d_sorte_novos_repetidos.d_sorte_id');
        sql_query.Sql.Add('and ' + id_obtidos);
        //sql_query.Sql.Add('order by id_seq_exc_novos_repetidos_id asc');
        sql_query.Sql.Add('order by id_seq_cmb_em_grupos asc');
        sql_query.Sql.Add('limit 1000');

        Writeln(sql_query.Sql.Text);

        sql_query.ExecSQL;
        sql_query.Close;
    except
        On exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
            sql_query.Close;
            Exit(False);
        end;
    end;
    Exit(True);
end;

procedure atualizar_controle_sgr_filtros(sgr_filtros: TStringGrid;
    str_filtro_data_hora: string; sql_conexao: TZConnection);
begin
    configurar_sgr_filtros(sgr_filtros);
    atualizar_sgr_filtros(sgr_filtros, str_filtro_data_hora, sql_conexao);
end;

procedure configurar_sgr_filtros(sgr_filtros: TStringGrid);
var
    uA: integer;
    coluna_atual: TGridColumn;
begin
    sgr_filtros.Columns.Clear;

    for uA := 0 to High(sgr_filtros_cabecalho) do
    begin
        coluna_atual := sgr_filtros.Columns.Add;
        coluna_atual.Title.Caption := sgr_filtros_cabecalho[uA];
        coluna_atual.Alignment := taCenter;
    end;
    sgr_filtros.RowCount := 1;
    sgr_filtros.FixedRows := 1;
end;

{
 Atualiza o controle conforme a data e hora.
}
procedure atualizar_sgr_filtros(sgr_filtros: TStringGrid;
    str_filtro_data_hora: string; sql_conexao: TZConnection);
var
    sql_query: TZQuery;
    uA, qt_registros, linha_sgr_filtros: integer;
begin
    try
        sql_query := TZquery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Close;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select');

        for uA := 0 to High(sgr_filtros_cabecalho) do
        begin
            if uA <> 0 then
            begin
                sql_query.Sql.Add(',');
            end;
            sql_query.Sql.Add(sgr_filtros_cabecalho[uA]);
        end;
        sql_query.Sql.Add('from d_sorte.v_d_sorte_filtros');
        sql_query.sql.Add('Where to_char(data,');
        sql_query.Sql.Add(QuotedStr('dd-MM-YYYY HH24:MI:SS.US') + ')');
        sql_query.Sql.Add('= ' + QuotedStr(str_filtro_data_hora));
        sql_query.SQL.Add('order by');
        sql_query.SQL.Add('filtros_id asc');

        sql_query.Open;
        sql_query.First;
        sql_query.Last;

        qt_registros := sql_query.RecordCount;
        sgr_filtros.RowCount := qt_registros + 1;

        sql_query.First;
        linha_sgr_filtros := 1;
        while (sql_query.EOF = False) and (qt_registros <> 0) do
        begin
            for uA := 0 to High(sgr_filtros_cabecalho) do
            begin
                sgr_filtros.Cells[uA, linha_sgr_filtros] :=
                    sql_query.FieldByName(sgr_filtros_cabecalho[uA]).AsString;
            end;
            sql_query.Next;
            Dec(qt_registros);
            Inc(linha_sgr_filtros);
        end;
        sql_query.Close;
        sql_query.Free;
    except
        On exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    sgr_filtros.AutoSizeColumns;
end;

procedure filtro_excluir(sql_conexao: TZConnection; filtro_data_hora: string);
var
    sql_query: TZQuery;
    filtro_data_hora_original: string;
    data_hora, Data, hora: TStringArray;

begin
    // Aqui, verificaremos se o usuário deseja excluir o filtro
    // Se a resposta for não, retornaremos imediatamente.
    if mrNo = MessageDlg('', 'Deseja excluir o filtro criado em ' +
        filtro_data_hora + '?', mtConfirmation, [mbYes, mbNo], 0) then
    begin
        Exit;
    end;

    if filtro_data_hora = '' then
    begin
        Exit;
    end;
    // Armazena o filtro original, pra ser exibido caso o filtro seja
    // excluído com sucesso.
    filtro_data_hora_original := filtro_data_hora;

    // A data está em formato brasileiro, assim: dd-mm-yyyy hh:nn:ss.mi
    // Vamos criar um arranjo, pra isto, o campo data é separado do campo tempo por um
    // espaço.
    data_hora := filtro_data_hora.Split(' ');

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
            'Erro, os campos de dia, mês e ano, deve ser interseparados pelo caractere '
            +
            '-', mtError, [mbOK], 0);
        Exit;
    end;

    // Ficará desta forma:
    // data[0] => dia
    // data[1] => mes
    // data[2] => ano

    // Agora, iremos colocar a data no formato americano.
    filtro_data_hora := Data[2] + '-' + Data[1] + '-' + Data[0] + ' ' + data_hora[1];

    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Delete from d_sorte.d_sorte_filtros');
        sql_query.Sql.Add('where data = ' + QuotedStr(filtro_data_hora));
        Writeln(sql_query.Sql.Text);
        sql_query.ExecSql;
        sql_query.Close;
    except
        On exc: Exception do
        begin
            sql_query.Close;
            sql_conexao.Rollback;
            MessageDlg('', 'Erro, ' + exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    MessageDlg('', 'Filtro ' + filtro_data_hora_original, mtInformation, [mbOK], 0);
end;

procedure filtro_excluir_todos(sql_conexao: TZConnection);
var
    sql_query: TZQuery;
begin
    if mrNo = MessageDlg('', 'Deseja excluir todos os concurso???', mtInformation, [mbYes, mbNo], 0) then begin
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
    MessageDlg('', 'Todos os filtros foram excluídos com sucesso!!!', mtInformation, [mbok], 0);
end;


{
 Retorna os 'ids' selecionados de cada controle, se o usuário marcou
 algum item.
 Os ítens retornados já formatados, por exemplo, no controle
 'sgr_par_impar', se o usuário marcou os identificadores 1, 2, 3,
 ao retornar o resultado é: par_impar_id in (1,2,3), se houver
 mais de um ítem tais ítens serão interseparados, por virgula,
 por exemplo, foram selecionados alguns ítens dos controles
 'sgr_par_impar' e 'sgr_primo_nao_primo', ao retornar, será algo
 similar a isto:
 ((par_impar_id in (1, 2, 3)) and (prm_id in (1, 2, 7)))
}
function obter_id_dos_filtros(lista_sgr_controle: TList_StringGrid): string;
var
    id_atual, titulo_coluna, titulo_ultima_coluna, titulo_penultima_coluna,
    id_atual_sim, id_atual_nao, lista_de_id_pra_retornar, id_atual_sim_nao: string;
    sgr_controle: TStringGrid;
    indice_ultima_coluna, indice_penultima_coluna, uA, indice_ultima_linha, uB: integer;
    indice_tag:   PtrInt;
begin
    lista_de_id_pra_retornar := '';

    for uA := 0 to Pred(lista_sgr_controle.Count) do
    begin
        if uA = 19 then
        begin
            Writeln('');
        end;

        sgr_controle := lista_sgr_controle.Items[uA];
        indice_ultima_coluna := Pred(sgr_controle.Columns.Count);
        indice_penultima_coluna := indice_ultima_coluna - 1;
        indice_ultima_linha := Pred(sgr_controle.RowCount);

        // Verifica se há linhas ou colunas.
        if (indice_ultima_coluna <= 0) or (indice_ultima_linha <= 0) then
        begin
            continue;
        end;

        // Verifica se a última coluna possui título.
        if not Assigned(sgr_controle.Columns[indice_ultima_coluna].Title) then
        begin
            Continue;
        end;

        // Verifica se a penúltima coluna possui título.
        if not Assigned(sgr_controle.Columns[indice_penultima_coluna].Title) then
        begin
            Continue;
        end;

        titulo_ultima_coluna :=
            AnsiLowerCase(sgr_controle.Columns[indice_ultima_coluna].Title.Caption);
        titulo_penultima_coluna :=
            AnsiLowercase(sgr_controle.Columns[indice_penultima_coluna].Title.Caption);
        if (titulo_ultima_coluna <> 'sim') and (titulo_penultima_coluna <> 'nao') then
        begin
            continue;
        end;

        // Verifica se a primeira coluna tem um título.
        if not Assigned(sgr_controle.Columns[0].Title) then
        begin
            continue;
        end;

        // Verifica se o nome do campo na primeira coluna coincide
        // com o nome do campo.
        indice_tag := sgr_controle.tag;
        if AnsiLowerCase(sgr_controle.Columns[0].Title.Caption) <>
            sgr_filtro_sql[indice_tag, 2] then
        begin
            Continue;
        end;

        // Agora, vamos pegar os ids.
        id_atual_sim := '';
        id_atual_nao := '';
        for uB := 1 to indice_ultima_linha do
        begin
            // Na mesma fileira, não pode estar selecionada o 'sim' e o 'nao'
            // ao mesmo tempo.
            if (sgr_controle.cells[indice_ultima_coluna, uB] = '1') and
                (sgr_controle.cells[indice_penultima_coluna, uB] = '1') then
            begin
                MessageDlg('', 'Erro, não pode haver na mesma linha, ' +
                    'uma marcação sim e nao ao mesmo tempo.',
                    mtError, [mbOK], 0);
                Exit('');
            end;

            if sgr_controle.Cells[indice_ultima_coluna, uB] = '1' then
            begin
                if id_atual_sim <> '' then
                begin
                    id_atual_sim := id_atual_sim + ',';
                end;
                id_atual_sim := id_atual_sim + sgr_controle.Cells[0, uB];
            end;
            if sgr_controle.Cells[indice_penultima_coluna, uB] = '1' then
            begin
                if id_atual_nao <> '' then
                begin
                    id_atual_nao := id_atual_nao + ',';
                end;
                id_atual_nao := id_atual_nao + sgr_controle.Cells[0, uB];
            end;
        end;

        // Se não houve filtros, continuar a iteração.
        if (id_atual_sim = '') and (id_atual_nao = '') then
        begin
            Continue;
        end;

        // Agora, vamos formatar a informação.
        if id_atual_sim <> '' then
        begin
            id_atual_sim := '(' + sgr_filtro_sql[indice_tag, 2] +
                ' in (' + id_atual_sim + '))';
        end;

        if id_atual_nao <> '' then
        begin
            id_atual_nao := '(' + sgr_filtro_sql[indice_tag, 2] +
                ' not in (' + id_atual_nao + '))';
        end;

        if lista_de_id_pra_retornar <> '' then
        begin
            lista_de_id_pra_retornar := lista_de_id_pra_retornar + ' and ';
        end;

        if (id_atual_sim <> '') and (id_atual_nao <> '') then
        begin
            id_atual_sim_nao := '((' + id_atual_sim + ') and (' + id_atual_nao + '))';

            lista_de_id_pra_retornar := lista_de_id_pra_retornar + id_atual_sim_nao;
        end
        else if id_atual_sim <> '' then
        begin
            lista_de_id_pra_retornar := lista_de_id_pra_retornar + id_atual_sim;
        end
        else if id_atual_nao <> '' then
        begin
            lista_de_id_pra_retornar := lista_de_id_pra_retornar + id_atual_nao;
        end;
        lista_de_id_pra_retornar := lista_de_id_pra_retornar + LineEnding;
    end;

    if lista_de_id_pra_retornar <> '' then
    begin
        lista_de_id_pra_retornar := '(' + lista_de_id_pra_retornar + ')';
    end;
    Writeln(lista_de_id_pra_retornar);
    Exit(lista_de_id_pra_retornar);
end;

end.
