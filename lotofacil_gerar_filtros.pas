unit lotofacil_gerar_filtros;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, lotofacil_constantes, fgl, Grids, Dialogs, StdCtrls,
    ZDataset, ZConnection, lotofacil_var_global, lotofacil_sgr_controle, strUtils;

type
    TList_StringGrid = specialize TFPGList<TStringGrid>;

    // Este record armazena as opções de filtro escolhido pelo usuário.
    R_Filtro_Opcoes = record
        excluir_cmb_com_15_bolas: boolean;
        excluir_cmb_com_16_bolas: boolean;
        excluir_cmb_com_17_bolas: boolean;
        excluir_cmb_com_18_bolas: boolean;
        excluir_jogos_ja_sorteados: boolean;
        total_de_registros: integer;
        ordenar_pelo_campo: string;
        sql_order_by_asc_desc: string;
        sql_offset: integer;
        sql_limit:  integer;
        Concurso:   integer;
    end;

procedure configurar_campo_id_dos_controles(var campo_id: TStringArray);
procedure Gerar_Filtros(lista_sgr_controle: array of R_Filtro_Controle; sql_conexao: TZConnection;
    opcoes_do_filtro: R_Filtro_Opcoes; cmb_minimo_maximo: R_Frequencia_Minimo_Maximo);
function obter_id_dos_filtros(lista_sgr_controle: array of R_Filtro_Controle): string;
function gerar_sql_dos_ids_obtidos(id_obtidos: string; sql_conexao: TZConnection;
    opcoes_do_filtro: R_Filtro_Opcoes): boolean;
procedure atualizar_controle_sgr_filtros(sgr_filtros: TStringGrid; str_filtro_data_hora: string;
    sql_conexao: TZConnection);
procedure configurar_sgr_filtros(sgr_filtros: TStringGrid);
procedure atualizar_sgr_filtros(sgr_filtros: TStringGrid; str_filtro_data_hora: string; sql_conexao: TZConnection);
function obter_id_da_frequencia(sgr_controle: TStringGrid; cmb_minimo_maximo: R_Frequencia_Minimo_Maximo): string;
function filtro_binario_obter_ids: string;

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
 Esta procedure chama outras functions e procedures pra gerar o filtro.
}
procedure Gerar_Filtros(lista_sgr_controle: array of R_Filtro_Controle;
  sql_conexao: TZConnection; opcoes_do_filtro: R_Filtro_Opcoes;
  cmb_minimo_maximo: R_Frequencia_Minimo_Maximo);
var
    id_obtidos, id_obtidos_frequencia, id_obtidos_binario:     string;
    sql_foi_gerado: boolean;
    lista_de_ids: TStringList;
    uA: Integer;
begin
    id_obtidos := obter_id_dos_filtros(lista_sgr_controle);
    id_obtidos_frequencia := obter_id_da_frequencia(lista_sgr_controle[ID_FREQUENCIA].sgr_controle, cmb_minimo_maximo);
    id_obtidos_binario := filtro_binario_obter_ids;

    // Armazena em um vetor pra ficar mais fácil processar.
    lista_de_ids := TStringList.Create;
    lista_de_ids.Clear;
    lista_de_ids.Add(Trim(id_obtidos));
    lista_de_ids.Add(Trim(id_obtidos_frequencia));
    lista_de_ids.Add(Trim(id_obtidos_binario));

    for uA := 1 to Pred(lista_de_ids.Count) do begin
        if (id_obtidos <> '') and (lista_de_ids[uA] <> '') then begin
            id_obtidos := id_obtidos + ' and ';
        end;
        id_obtidos := id_obtidos + lista_de_ids[uA];
    end;

    sql_foi_gerado := gerar_sql_dos_ids_obtidos(id_obtidos, sql_conexao, opcoes_do_filtro);
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
function gerar_sql_dos_ids_obtidos(id_obtidos: string; sql_conexao: TZConnection;
    opcoes_do_filtro: R_Filtro_Opcoes): boolean;

    procedure DeletarSqlTabela(var lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas: TStringList;
        nome_da_tabela: ansistring);
    var
        indice_a_deletar, uA: integer;
    begin
        indice_a_deletar := lista_de_tabelas_selecionadas.IndexOf(nome_da_tabela);
        if indice_a_deletar > -1 then
        begin
            lista_de_tabelas_selecionadas.Delete(indice_a_deletar);
        end;

        // Agora, da lista de tabelas relacionadas.
        uA := 0;
        while uA < lista_de_tabelas_relacionadas.Count do
        begin
            if AnsiContainsStr(lista_de_tabelas_relacionadas.Strings[uA], nome_da_tabela) then
            begin
                lista_de_tabelas_relacionadas.Delete(uA);
                continue;
            end;
            Inc(uA);
        end;
    end;

const
    tabelas_utilizadas: array [0..4] of string = (
        'lotofacil.lotofacil_num',
        'lotofacil.lotofacil_bolas',
        'lotofacil.lotofacil_novos_repetidos',
        //'lotofacil.lotofacil_num_bolas_concurso',
        //'lotofacil.lotofacil_diferenca_entre_bolas',
        'lotofacil.lotofacil_id',
        'lotofacil.v_lotofacil_num_nao_sorteado' //,
        //'lotofacil.lotofacil_coluna_b',
        //'lotofacil.lotofacil_combinacoes_em_grupos',
        //'lotofacil.lotofacil_algarismo_na_dezena'
        );
var
    sql_query: TZQuery;
    lista_de_campos_insert, lista_de_campos_select, lista_de_tabelas_relacionadas,
    lista_de_tabelas_selecionadas, lista_where, sql_gerado: TStringList;
    uA, uB:    integer;
    ltf_qt_excluir, sql_excluir_ltf_qt, tabela_esquerda, tabela_direita: string;

    // Armazena true, se o usuário deseja excluir ou false.
    excluir_ltf_qt: array[15..18] of boolean;
begin
    lista_de_campos_insert := TStringList.Create;
    lista_de_campos_select := TStringList.Create;

    lista_de_campos_insert.Clear;
    lista_de_campos_select.Clear;

    // Insere os campos do insert que são fixos.
    lista_de_campos_insert.Add('data');
    lista_de_campos_select.Add('Now()');

    lista_de_campos_insert.Add('ltf_id');
    lista_de_campos_select.Add('lotofacil.lotofacil_num.ltf_id');               // ltf_id

    lista_de_campos_insert.Add('ltf_qt');
    lista_de_campos_select.Add('lotofacil.lotofacil_num.ltf_qt');               // ltf_qt

    lista_de_campos_insert.Add('concurso');
    lista_de_campos_select.Add(IntToStr(opcoes_do_filtro.Concurso));

    lista_de_campos_insert.Add('acertos');
    lista_de_campos_select.Add('0');

    // lista_de_campos_insert.Add('id_seq_cmb_em_grupos');
    // lista_de_campos_select.Add('id_seq_cmb_em_grupos');

    lista_de_campos_insert.Add('novos_repetidos_id_alternado');
    lista_de_campos_select.Add('novos_repetidos_id_alternado');

    lista_de_campos_insert.Add('novos_repetidos_id');
    lista_de_campos_select.Add('novos_repetidos_id');

    //lista_de_campos_insert.Add('concurso_soma_frequencia_bolas');
    //lista_de_campos_select.Add('concurso_soma_frequencia_bolas');

    // Toda as tabelas utilizadas, tem em comum o campo 'ltf_id',
    // Iremos relacionar um tabela com todas as outras tabelas
    // Depois, em código posteriores iremos retirar desta lista, relacionamento entre tabelas
    // desnecessários, por exemplo, se o usuário não seleciona
    // nenhuma informação da tabela de soma, então, não é necessário
    // fazer este relacionamento.
    lista_de_tabelas_relacionadas := TStringList.Create;
    lista_de_tabelas_relacionadas.Clear;
    for uA := 0 to High(tabelas_utilizadas) do
    begin
        for uB := uA + 1 to High(tabelas_utilizadas) do
        begin
            tabela_esquerda := tabelas_utilizadas[uA];
            tabela_direita := tabelas_utilizadas[uB];

            if lista_de_tabelas_relacionadas.Count > 0 then
            begin
                lista_de_tabelas_relacionadas.Add('and');
            end;
            lista_de_tabelas_relacionadas.add(tabela_esquerda + '.ltf_id = ' + tabela_direita + '.ltf_id');
        end;
    end;

    lista_de_tabelas_selecionadas := TStringList.Create;
    for uA := 0 to High(tabelas_utilizadas) do
    begin
        lista_de_tabelas_selecionadas.Add(tabelas_utilizadas[uA]);
    end;

    lista_where := TStringList.Create;
    lista_where.Clear;

    lista_where.Add(id_obtidos);

    // A view 'lotofacil.v_lotofacil_num_nao_sorteado' contém somente
    // combinações não-sorteadas, se o usuário não marcar, quer dizer
    // que ele deseja incluir combinações já sorteadas no resultado.
    if opcoes_do_filtro.excluir_jogos_ja_sorteados = False then
    begin
        DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas,
            'lotofacil_v_lotofacil_num_nao_sorteado');
    end;

    // Vamos verificar se o usuário deseja excluir alguma combinação
    // de bolas.
    sql_excluir_ltf_qt := '';
    excluir_ltf_qt[15] := opcoes_do_filtro.excluir_cmb_com_15_bolas;
    excluir_ltf_qt[16] := opcoes_do_filtro.excluir_cmb_com_16_bolas;
    excluir_ltf_qt[17] := opcoes_do_filtro.excluir_cmb_com_17_bolas;
    excluir_ltf_qt[18] := opcoes_do_filtro.excluir_cmb_com_18_bolas;

    for uA := 15 to 18 do
    begin
        if excluir_ltf_qt[uA] then
        begin
            if sql_excluir_ltf_qt <> '' then
            begin
                sql_excluir_ltf_qt := sql_excluir_ltf_qt + ',';
            end;
            sql_excluir_ltf_qt := sql_excluir_ltf_qt + IntToStr(uA);
        end;
    end;

    // Vamos verificar se algo foi selecionado
    if sql_excluir_ltf_qt <> '' then
    begin
        lista_where.Add('(lotofacil.lotofacil_num.ltf_qt not in (' + sql_excluir_ltf_qt + '))');
    end;

    // Vamos gerar o sql gerado dinamicamente.
    sql_gerado := TStringList.Create;
    sql_gerado.Clear;
    sql_gerado.Add('Insert into lotofacil.lotofacil_filtros(');

    lista_de_campos_insert.Delimiter := ',';
    sql_gerado.Add(lista_de_campos_insert.DelimitedText);
    sql_gerado.Add(')');

    sql_gerado.Add('Select');
    lista_de_campos_select.Delimiter := ',';
    sql_gerado.Add(lista_de_campos_select.DelimitedText);

    sql_gerado.Add('from ');
    lista_de_tabelas_selecionadas.Delimiter := ',';
    sql_gerado.Add(lista_de_tabelas_selecionadas.DelimitedText);

    sql_gerado.Add('where');

    // Pega as tabelas relacionadas.
    sql_gerado.Add(lista_de_tabelas_relacionadas.Text);

    for uA := 0 to Pred(lista_where.Count) do
    begin
        sql_gerado.Add('and');
        sql_gerado.Add(lista_where.Strings[uA]);
    end;

    if opcoes_do_filtro.ordenar_pelo_campo <> '' then
    begin
        sql_gerado.Add('order by ' + opcoes_do_filtro.ordenar_pelo_campo);
    end;

    if opcoes_do_filtro.sql_limit <> 0 then
    begin
        sql_gerado.Add('limit ' + IntToStr(opcoes_do_filtro.sql_limit));
    end;

    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Sql.Add(sql_gerado.Text);
        sql_query.ExecSql;
        sql_query.Close;
        FreeAndNil(sql_query);

    except
        On Exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
            sql_query.Close;
            Exit(False);
        end;
    end;

    /// Código daqui pra baixo não será utilizado.
    exit;
    //try
    //    sql_query := TZQuery.Create(nil);
    //    sql_query.connection := sql_conexao;
    //    sql_query.Sql.Add('Insert into d_sorte.d_sorte_filtros');
    //    sql_query.Sql.Add('(');
    //    sql_query.Sql.Add('data,');
    //    sql_query.Sql.Add('d_sorte_id,');
    //    sql_query.Sql.Add('d_sorte_qt,');
    //    sql_query.Sql.Add('concurso,');
    //    sql_query.Sql.Add('acertos,');
    //    sql_query.Sql.Add('id_seq_cmb_em_grupos,');
    //    sql_query.Sql.Add('id_seq_exc_novos_repetidos_id');
    //    sql_query.Sql.Add(')');
    //    sql_query.Sql.Add('Select Now(),');
    //    sql_query.Sql.Add('d_sorte.d_sorte_bolas.d_sorte_id,');
    //    sql_query.Sql.Add('d_sorte.d_sorte_bolas.d_sorte_qt,');
    //    sql_query.Sql.Add('1,');
    //    sql_query.Sql.Add('0,');
    //    sql_query.Sql.Add('id_seq_cmb_em_grupos,');
    //    sql_query.Sql.Add('id_seq_exc_novos_repetidos_id');
    //    sql_query.Sql.Add('from');
    //    sql_query.Sql.Add('d_sorte.d_sorte_bolas,');
    //    sql_query.Sql.Add('d_sorte.d_sorte_id,');
    //    sql_query.Sql.Add('d_sorte.d_sorte_combinacoes_em_grupos,');
    //    sql_query.Sql.Add('d_sorte.d_sorte_novos_repetidos');
    //    sql_query.Sql.Add('where d_sorte.d_sorte_bolas.d_sorte_id = d_sorte.d_sorte_id.d_sorte_id');
    //    sql_query.Sql.Add('and   d_sorte.d_sorte_bolas.d_sorte_id = d_sorte.d_sorte_combinacoes_em_grupos.d_sorte_id');
    //    sql_query.Sql.Add('and   d_sorte.d_sorte_bolas.d_sorte_id = d_sorte.d_sorte_novos_repetidos.d_sorte_id');
    //    sql_query.Sql.Add('and   d_sorte.d_sorte_id.d_sorte_id = d_sorte.d_sorte_combinacoes_em_grupos.d_sorte_id');
    //    sql_query.Sql.Add('and   d_sorte.d_sorte_id.d_sorte_id = d_sorte.d_sorte_novos_repetidos.d_sorte_id');
    //    sql_query.Sql.Add(
    //        'and   d_sorte.d_sorte_combinacoes_em_grupos.d_sorte_id = d_sorte.d_sorte_novos_repetidos.d_sorte_id');
    //    sql_query.Sql.Add('and ' + id_obtidos);
    //    //sql_query.Sql.Add('order by id_seq_exc_novos_repetidos_id asc');
    //    sql_query.Sql.Add('order by id_seq_cmb_em_grupos asc');
    //    sql_query.Sql.Add('limit 1000');
    //
    //    Writeln(sql_query.Sql.Text);
    //
    //    sql_query.ExecSQL;
    //    sql_query.Close;
    //    FreeAndNil(sql_query);
    //except
    //    On exc: Exception do
    //    begin
    //        MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
    //        sql_query.Close;
    //        Exit(False);
    //    end;
    //end;
    //Exit(True);
end;

procedure atualizar_controle_sgr_filtros(sgr_filtros: TStringGrid; str_filtro_data_hora: string;
    sql_conexao: TZConnection);
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
procedure atualizar_sgr_filtros(sgr_filtros: TStringGrid; str_filtro_data_hora: string; sql_conexao: TZConnection);
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





function obter_id_da_frequencia(sgr_controle: TStringGrid; cmb_minimo_maximo: R_Frequencia_Minimo_Maximo): string;
var
    sql_bolas_sair:     ansistring;
    sql_bolas_nao_sair: ansistring;
    ultima_coluna_controle_sair, ultima_coluna_controle_nao_sair, uA, indice_minimo, indice_maximo: integer;
    minimo_sair, maximo_sair, minimo_nao_sair, maximo_nao_sair, bola_numero, sql_bolas_ainda_nao_saiu,
    sql_bolas_deixou_de_sair, sql_bolas_novo, sql_bolas_repetindo, frequencia_status,
    minimo_ainda_nao_saiu, maximo_ainda_nao_saiu, minimo_novo, maximo_novo, minimo_deixou_de_sair,
    maximo_deixou_de_sair, minimo_repetindo, maximo_repetindo: string;
    lista_bola_sair, lista_bola_nao_sair, lista_ainda_nao_saiu, lista_deixou_de_sair,
    lista_novo, lista_repetindo, lista_sql: TStringList;
    cmbAinda_Nao_Saiu_Minimo, cmbAinda_Nao_Saiu_Maximo,
      cmbNovo_Minimo, cmbNovo_Maximo, cmbRepetindo_Minimo,
      cmbRepetindo_Maximo, cmbDeixou_de_Sair_minimo,
      cmbDeixou_de_Sair_Maximo: TComboBox;
begin
    cmbAinda_Nao_Saiu_Minimo := cmb_minimo_maximo.cmb_ainda_nao_saiu_minimo;
    cmbAinda_Nao_Saiu_Maximo := cmb_minimo_maximo.cmb_ainda_nao_saiu_maximo;

    cmbNovo_Minimo := cmb_minimo_maximo.cmb_novo_minimo;
    cmbNovo_Maximo := cmb_minimo_maximo.cmb_novo_maximo;

    cmbRepetindo_Minimo := cmb_minimo_maximo.cmb_repetindo_minimo;
    cmbRepetindo_Maximo := cmb_minimo_maximo.cmb_repetindo_maximo;

    cmbDeixou_de_Sair_minimo := cmb_minimo_maximo.cmb_deixou_de_sair_minimo;
    cmbDeixou_de_Sair_Maximo := cmb_minimo_maximo.cmb_deixou_de_sair_maximo;



    sql_bolas_sair := '';
    sql_bolas_nao_sair := '';

    sql_bolas_ainda_nao_saiu := '';
    sql_bolas_deixou_de_sair := '';
    sql_bolas_novo := '';
    sql_bolas_repetindo := '';

    // No controle sgrFrequencia_Bolas_Sair_Nao_Sair há duas colunas: sim, nao
    // Última coluna: sim
    ultima_coluna_controle_sair := Pred(sgr_controle.Columns.Count);
    // Penúltima coluna: não.
    ultima_coluna_controle_nao_sair := ultima_coluna_controle_sair - 1;

    // Iremos percorrer todas as linhas do controle: sgr_frequencia e
    // sgrFrequenciaBolasNaoSair, e verificar se o usuário marcou a bola pra sair
    // e a bola pra não sair.
    // E também iremos gerar o sql por categoria, iremos identificar de qual
    // categoria a bola se encontra no momento, por exemplo: ainda_nao_saiu,
    // deixou_de_sair, novo e repetindo.

    lista_bola_sair := TStringList.Create;
    lista_bola_nao_sair := TStringList.Create;

    lista_ainda_nao_saiu := TStringList.Create;
    lista_deixou_de_sair := TStringList.Create;
    lista_novo := TStringList.Create;
    lista_repetindo := TStringList.Create;

    lista_bola_sair.Clear;
    lista_bola_nao_sair.Clear;
    lista_ainda_nao_saiu.Clear;
    lista_deixou_de_sair.Clear;
    lista_novo.Clear;
    lista_repetindo.Clear;

    for uA := 1 to 25 do
    begin
        // Vamos pegar somente bolas que usuário marcou que devem sair na combinação.
        if sgr_controle.Cells[ultima_coluna_controle_sair, uA] = '1' then
        begin
            bola_numero := sgr_controle.Cells[0, uA];
            lista_bola_sair.Add('num_' + bola_numero);

            // Na coluna 1, temos o tipo da categoria de frequência.
            frequencia_status := sgr_controle.Cells[1, uA];
            frequencia_status := LowerCase(frequencia_status);
            if frequencia_status = 'ainda_nao_saiu' then
            begin
                lista_ainda_nao_saiu.Add('num_' + bola_numero);
            end
            else
            if frequencia_status = 'deixou_de_sair' then
            begin
                lista_deixou_de_sair.Add('num_' + bola_numero);
            end
            else
            if frequencia_status = 'novo' then
            begin
                lista_novo.Add('num_' + bola_numero);
            end
            else
            if frequencia_status = 'repetindo' then
            begin
                lista_repetindo.Add('num_' + bola_numero);
            end;

        end;
        // Pega as bolas que não devem sair.
        if sgr_controle.Cells[ultima_coluna_controle_nao_sair, uA] = '1' then
        begin
            bola_numero := sgr_controle.Cells[0, uA];
            lista_bola_nao_sair.Add('num_' + bola_numero);
        end;
    end;

    // ==================== BOLAS NAO SAIR =========================

    sql_bolas_nao_sair := '';
    if lista_bola_nao_sair.Count <> 0 then
    begin
        for uA := 0 to Pred(lista_bola_nao_sair.Count) do
        begin
            if uA <> 0 then
            begin
                sql_bolas_nao_sair := sql_bolas_nao_sair + ' + ';
            end;
            sql_bolas_nao_sair := sql_bolas_nao_sair + lista_bola_nao_sair.Strings[uA];
        end;
        //indice_minimo := cmbFrequencia_Minimo_Nao_sair.ItemIndex;
        //indice_maximo := cmbFrequencia_Maximo_Nao_sair.ItemIndex;

        //if (indice_minimo = -1) or (indice_maximo = -1) then
        //begin
          //  strErro := strErro + 'Vc deve escolher mínimo e máximo da frequência';
           // Exit('');
        //end;
        //minimo_nao_sair := cmbFrequencia_Minimo_Nao_sair.Items[indice_minimo];
        //maximo_nao_sair := cmbFrequencia_Maximo_Nao_sair.Items[indice_maximo];

        // No caso, das bolas que não devem sair, a soma dos campos corresponentes deve
        // ser igual a zero.
        //sql_bolas_nao_sair := '(' + sql_bolas_nao_sair + ' between ' + minimo_nao_sair + ' and ' + maximo_nao_sair + ')';
        sql_bolas_nao_sair := '(' + sql_bolas_nao_sair + ' = 0)';
    end;


    // ==================== BOLAS AINDA NAO SAIU =========================
    sql_bolas_ainda_nao_saiu := '';
    if lista_ainda_nao_saiu.Count <> 0 then
    begin
        for uA := 0 to Pred(lista_ainda_nao_saiu.Count) do
        begin
            if uA <> 0 then
            begin
                sql_bolas_ainda_nao_saiu := sql_bolas_ainda_nao_saiu + ' + ';
            end;
            sql_bolas_ainda_nao_saiu :=
                sql_bolas_ainda_nao_saiu + lista_ainda_nao_saiu.Strings[uA];
        end;
        indice_minimo := cmbAinda_nao_saiu_minimo.ItemIndex;
        indice_maximo := cmbAinda_nao_saiu_maximo.ItemIndex;

        if (indice_minimo = -1) or (indice_maximo = -1) then
        begin
            // TODO: Verificar.
            //strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
            Exit('');
        end;
        minimo_ainda_nao_saiu := cmbAinda_nao_saiu_minimo.Items[indice_minimo];
        maximo_ainda_nao_saiu := cmbAinda_nao_saiu_maximo.Items[indice_maximo];

        sql_bolas_ainda_nao_saiu :=
            '(' + sql_bolas_ainda_nao_saiu + ' between ' + minimo_ainda_nao_saiu +
            ' and ' + maximo_ainda_nao_saiu + ')';
    end;


    // ==================== BOLAS DEIXOU DE SAIR =========================
    sql_bolas_deixou_de_sair := '';
    if lista_deixou_de_sair.Count <> 0 then
    begin
        for uA := 0 to Pred(lista_deixou_de_sair.Count) do
        begin
            if uA <> 0 then
            begin
                sql_bolas_deixou_de_sair := sql_bolas_deixou_de_sair + ' + ';
            end;
            sql_bolas_deixou_de_sair :=
                sql_bolas_deixou_de_sair + lista_deixou_de_sair.Strings[uA];
        end;
        indice_minimo := cmbdeixou_de_sair_minimo.ItemIndex;
        indice_maximo := cmbdeixou_de_sair_maximo.ItemIndex;

        if (indice_minimo = -1) or (indice_maximo = -1) then
        begin
            //strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
            Exit('');
        end;
        minimo_deixou_de_sair := cmbdeixou_de_sair_minimo.Items[indice_minimo];
        maximo_deixou_de_sair := cmbdeixou_de_sair_maximo.Items[indice_maximo];

        sql_bolas_deixou_de_sair :=
            '(' + sql_bolas_deixou_de_sair + ' between ' + minimo_deixou_de_sair +
            ' and ' + maximo_deixou_de_sair + ')';
    end;

    // ==================== BOLAS AINDA NAO SAIU =========================
    sql_bolas_novo := '';
    if lista_novo.Count <> 0 then
    begin
        for uA := 0 to Pred(lista_novo.Count) do
        begin
            if uA <> 0 then
            begin
                sql_bolas_novo := sql_bolas_novo + ' + ';
            end;
            sql_bolas_novo := sql_bolas_novo + lista_novo.Strings[uA];
        end;
        indice_minimo := cmbnovo_minimo.ItemIndex;
        indice_maximo := cmbnovo_maximo.ItemIndex;

        if (indice_minimo = -1) or (indice_maximo = -1) then
        begin
            //strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
            Exit('');
        end;
        minimo_novo := cmbnovo_minimo.Items[indice_minimo];
        maximo_novo := cmbnovo_maximo.Items[indice_maximo];

        sql_bolas_novo := '(' + sql_bolas_novo + ' between ' + minimo_novo + ' and ' + maximo_novo + ')';
    end;

    // ==================== BOLAS REPETINDO =========================
    sql_bolas_repetindo := '';
    if lista_repetindo.Count <> 0 then
    begin
        for uA := 0 to Pred(lista_repetindo.Count) do
        begin
            if uA <> 0 then
            begin
                sql_bolas_repetindo := sql_bolas_repetindo + ' + ';
            end;
            sql_bolas_repetindo := sql_bolas_repetindo + lista_repetindo.Strings[uA];
        end;
        indice_minimo := cmbrepetindo_minimo.ItemIndex;
        indice_maximo := cmbrepetindo_maximo.ItemIndex;

        if (indice_minimo = -1) or (indice_maximo = -1) then
        begin
            //strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
            Exit('');
        end;
        minimo_repetindo := cmbrepetindo_minimo.Items[indice_minimo];
        maximo_repetindo := cmbrepetindo_maximo.Items[indice_maximo];

        sql_bolas_repetindo :=
            '(' + sql_bolas_repetindo + ' between ' + minimo_repetindo + ' and ' + maximo_repetindo + ')';
    end;

    // Cada bola em uma frequência pode estar nestes status:
    // Ainda não saiu
    // Deixou de sair
    // Novo
    // Repetindo

    // Antes, eu pegava todas as bolas e gerava o sql dinamicamente.
    // Nesta abordagem, a quantidade mínima e máxima era baseada em todas as bolas
    // e não no status da frequência, agora, posso definir a quantidade mínima
    // e máxima conforme o status da frequência que a bola pertence, assim,
    // provavelmente, conseguirei realizar uma melhor filtragem das combinações
    // e ser mais preciso.
    lista_sql := TStringList.Create;
    lista_sql.Clear;

    if sql_bolas_nao_sair <> '' then
    begin
        lista_sql.Add(sql_bolas_nao_sair);
    end;

    // ======== AINDA NAO SAIU ===========
    if sql_bolas_ainda_nao_saiu <> '' then
    begin

        // Coloca o operador 'and' entre os sql.
        if lista_sql.Count > 0 then
        begin
            lista_sql.Add('And');
        end;

        lista_sql.Add(sql_bolas_ainda_nao_saiu);
    end;

    // ======== DEIXOU DE SAIR ===========
    if sql_bolas_deixou_de_sair <> '' then
    begin

        // Coloca o operador 'and' entre os sql.
        if lista_sql.Count > 0 then
        begin
            lista_sql.Add('And');
        end;

        lista_sql.Add(sql_bolas_deixou_de_sair);
    end;

    // ======== NOVO ===========
    if sql_bolas_novo <> '' then
    begin

        // Coloca o operador 'and' entre os sql.
        if lista_sql.Count > 0 then
        begin
            lista_sql.Add('And');
        end;

        lista_sql.Add(sql_bolas_novo);
    end;

    if sql_bolas_repetindo <> '' then
    begin

        // Coloca o operador 'and' entre os sql.
        if lista_sql.Count > 0 then
        begin
            lista_sql.Add('And');
        end;

        lista_sql.Add(sql_bolas_repetindo);
    end;

    // Em seguida, se a lista não está vazia, devemos
    // circundar tudo com o '(' + ')'.
    if lista_sql.Count > 0 then
    begin
        lista_sql.Insert(0, '(');
        lista_sql.Append(')');
    end;

    Writeln(lista_sql.Text);
    Exit(lista_sql.Text);

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
//function obter_id_dos_filtros(lista_sgr_controle: TList_StringGrid): string;
function obter_id_dos_filtros(lista_sgr_controle: array of R_Filtro_Controle): string;
var
    id_atual, titulo_coluna, titulo_ultima_coluna, titulo_penultima_coluna, id_atual_sim,
    id_atual_nao, lista_de_id_pra_retornar, id_atual_sim_nao: string;
    sgr_controle: TStringGrid;
    indice_ultima_coluna, indice_penultima_coluna, uA, indice_ultima_linha, uB: integer;
    indice_tag:   PtrInt;
begin
    lista_de_id_pra_retornar := '';


    for uA := 0 to High(lista_sgr_controle) do
    begin
        sgr_controle := lista_sgr_controle[uA].sgr_controle;

        // Alguns controle terão uma procedure pra obter os ids, por exemplo,
        // o controle que armazena frequencia.
        if sgr_controle = lista_sgr_controle[ID_FREQUENCIA].sgr_controle then begin
            continue;
        end;


        // A lista de controle pode ter controles que não foram inseridos ainda.
        if not Assigned(sgr_controle) then
        begin
            Continue;
        end;

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
        //if AnsiLowerCase(sgr_controle.Columns[0].Title.Caption) <> sgr_filtro_sql[indice_tag, 2] then

        Writeln('Nome:', sgr_controle.Columns[0].Title.Caption, '=campo=>', lista_sgr_controle[uA].sql_campo_id);



        //if AnsiLowerCase(sgr_controle.Columns[0].Title.Caption) <> lista_sgr_controle[uA].sql_campo_id then
        //begin
        //    Continue;
        //end;

        // Agora, vamos pegar os ids.
        id_atual_sim := '';
        id_atual_nao := '';

        // Percorre todas as linhas do controle, a partir da linha 1
        // e pega os ids selecionados pelo usuário.
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

            // Pega cada id, se o usuário marcou 'sim'.
            if sgr_controle.Cells[indice_ultima_coluna, uB] = '1' then
            begin
                if id_atual_sim <> '' then
                begin
                    id_atual_sim := id_atual_sim + ',';
                end;
                id_atual_sim := id_atual_sim + sgr_controle.Cells[0, uB];
            end;

            // Pega cada id, se o usuário marcou 'nao'.
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
            // id_atual_sim := '(' + sgr_filtro_sql[indice_tag, 2] + ' in (' + id_atual_sim + '))';
            id_atual_sim := '(' + lista_sgr_controle[uA].sql_campo_id + ' in (' + id_atual_sim + '))';
        end;

        if id_atual_nao <> '' then
        begin
            // id_atual_nao := '(' + sgr_filtro_sql[indice_tag, 2] + ' not in (' + id_atual_nao + '))';
            id_atual_nao := '(' + lista_sgr_controle[uA].sql_campo_id + ' not in (' + id_atual_nao + '))';
        end;

        // Esta lista, armazena pra cada controle, a condição where que será utilizada no sql
        // se já há algo na lista, interseparamos o anterior com o próximo com a cláusula 'and'.
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

    // Aqui, verificamos se realmente, houve algo na lista, se sim, colocamos entre parênteses
    // novamente, pra não atrapalhar outras condições.
    if lista_de_id_pra_retornar <> '' then
    begin
        lista_de_id_pra_retornar := '(' + lista_de_id_pra_retornar + ')';
    end;
    Writeln(lista_de_id_pra_retornar);
    Exit(lista_de_id_pra_retornar);
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
function filtro_binario_obter_ids: string;
var
    id_atual, titulo_coluna, titulo_ultima_coluna, titulo_penultima_coluna, id_atual_sim,
    id_atual_nao, lista_de_id_pra_retornar, id_atual_sim_nao: string;
    sgr_controle: TStringGrid;
    indice_ultima_coluna, indice_penultima_coluna, uA, indice_ultima_linha, uB: integer;
    indice_tag:   PtrInt;
    chave: LongInt;
    filtro_info: R_Filtro_Binario_Controle;
begin
    lista_de_id_pra_retornar := '';

    //for uA := 0 to High(lista_sgr_controle) do
    for uA := 0 to Pred(mapa_filtro_binario_info.Count) do
    begin
        chave := mapa_filtro_binario_info.Keys[uA];
        filtro_info := mapa_filtro_binario_info.KeyData[chave];

        sgr_controle := filtro_info.sgr_controle;

        // Alguns controle terão uma procedure pra obter os ids, por exemplo,
        // o controle que armazena frequencia.
        //if sgr_controle = lista_sgr_controle[ID_FREQUENCIA].sgr_controle then begin
        //    continue;
        //end;


        // A lista de controle pode ter controles que não foram inseridos ainda.
        //if not Assigned(sgr_controle) then
        //begin
        //    Continue;
        //end;

        // Obtém o índice da última linha, da última coluna e penúltima coluna.
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

        //// Verifica se a primeira coluna tem um título.
        //if not Assigned(sgr_controle.Columns[0].Title) then
        //begin
        //    continue;
        //end;

        // Verifica se o nome do campo na primeira coluna coincide
        // com o nome do campo.
        //indice_tag := sgr_controle.tag;
        //if AnsiLowerCase(sgr_controle.Columns[0].Title.Caption) <> sgr_filtro_sql[indice_tag, 2] then

        //Writeln('Nome:', sgr_controle.Columns[0].Title.Caption, '=campo=>', lista_sgr_controle[uA].sql_campo_id);



        //if AnsiLowerCase(sgr_controle.Columns[0].Title.Caption) <> lista_sgr_controle[uA].sql_campo_id then
        //begin
        //    Continue;
        //end;

        // Agora, vamos pegar os ids.
        id_atual_sim := '';
        id_atual_nao := '';

        // Percorre todas as linhas do controle, a partir da linha 1
        // e pega os ids selecionados pelo usuário.
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

            // Pega cada id, se o usuário marcou 'sim'.
            if sgr_controle.Cells[indice_ultima_coluna, uB] = '1' then
            begin
                if id_atual_sim <> '' then
                begin
                    id_atual_sim := id_atual_sim + ',';
                end;
                id_atual_sim := id_atual_sim + sgr_controle.Cells[0, uB];
            end;

            // Pega cada id, se o usuário marcou 'nao'.
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
            // id_atual_sim := '(' + sgr_filtro_sql[indice_tag, 2] + ' in (' + id_atual_sim + '))';
            id_atual_sim := '(' + filtro_info.sql_campo_id + ' in (' + id_atual_sim + '))';
        end;

        if id_atual_nao <> '' then
        begin
            // id_atual_nao := '(' + sgr_filtro_sql[indice_tag, 2] + ' not in (' + id_atual_nao + '))';
            id_atual_nao := '(' + filtro_info.sql_campo_id + ' not in (' + id_atual_nao + '))';
        end;

        // Esta lista, armazena pra cada controle, a condição where que será utilizada no sql
        // se já há algo na lista, interseparamos o anterior com o próximo com a cláusula 'and'.
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

    // Aqui, verificamos se realmente, houve algo na lista, se sim, colocamos entre parênteses
    // novamente, pra não atrapalhar outras condições.
    if lista_de_id_pra_retornar <> '' then
    begin
        lista_de_id_pra_retornar := '(' + lista_de_id_pra_retornar + ')';
    end;
    Writeln(lista_de_id_pra_retornar);
    Exit(lista_de_id_pra_retornar);
end;



end.
