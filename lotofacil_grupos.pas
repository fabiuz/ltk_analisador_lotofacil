unit lotofacil_grupos;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, fgl, ZConnection, ZDataset, lotofacil_var_global, Dialogs, Clipbrd, Grids;

type
    TLotofacil_Bolas_Repetidas = record
        concurso: integer;
        qt_de_bolas_repetidas: integer;
        bolas_repetidas: array[0..15] of byte;
        num_1_a_num_15: array[0..25] of byte;
    end;

{
 Pra cada conjunto com mais de 5 bolas, podemos gerar subconjuntos com 5 bolas.
 Então, iremos mapear a quantidade de registros necessários.
}
procedure gerar_grupos_status_repetindo(sql_conexao: TZConnection; concursos: TLotofacil_Concurso_Array);
procedure grupos_exibir_qt_entre_concursos(sql_conexao: TZConnection; sgr_controle: TStringGrid;
    concurso_inicial: integer; concurso_final: integer);

procedure gerar_grupos_de_concursos(sql_conexao: TZConnection; concursos: TLotofacil_Concurso_Array;
    grupos_selecionados: array of boolean);



implementation

procedure gerar_grupos_status_repetindo(sql_conexao: TZConnection; concursos: TLotofacil_Concurso_Array);
var
    uA, uB, indice_arranjo, indice_bolas_repetidas, uC, uD, uE, uF, qt_bolas_repetidas,
    qt_de_bolas_repetidas: integer;
    bolas_repetidas_por_concurso: array of TLotofacil_Bolas_Repetidas;
    lista_sql_insert: TStringList;
    concurso_atual: TLotofacil_Bolas_Repetidas;
    bolas_combinadas, sql_gerado: string;
    sql_query:      TZQuery;
begin

    if High(concursos) = -1 then
    begin
        Exit;
    end;

    // Há no mínimo 5 e no máximo 15 bolas repetidas.
    SetLength(bolas_repetidas_por_concurso, Length(concursos));

    // Serve pra percorrer o arranjo 'bolas_repetidas_por_concurso'.
    indice_arranjo := 0;
    indice_bolas_repetidas := 0;

    // Vamos agora comparar cada concurso com o anterior e
    // identificar quais bolas se repete de um concurso
    // em relação ao anterior.


    qt_bolas_repetidas := 0;
    for uA := 1 to High(concursos) do
    begin

        indice_bolas_repetidas := 0;
        qt_bolas_repetidas := 0;

        for uB := 1 to 25 do
        begin

            if (concursos[uA].num1_a_num_25[uB] = concursos[uA - 1].num1_a_num_25[uB]) and
                (concursos[uA].num1_a_num_25[uB] = 1) then
            begin
                bolas_repetidas_por_concurso[indice_arranjo].concurso := concursos[uA].concurso;
                bolas_repetidas_por_concurso[indice_arranjo].num_1_a_num_15[uB] := 1;
                bolas_repetidas_por_concurso[indice_arranjo].bolas_repetidas[indice_bolas_repetidas] := uB;
                Inc(indice_bolas_repetidas);

                Inc(qt_bolas_repetidas);
                if qt_bolas_repetidas = 15 then
                begin
                    break;
                end;
            end;
        end;
        // Só iremos incrementar, se houve bolas repetidas, pois, pode acontecer, de haver
        // menos concursos com bolas repetidas, em relação a uma posição pra todos os concursos.
        if qt_bolas_repetidas <> 0 then
        begin
            bolas_repetidas_por_concurso[indice_arranjo].qt_de_bolas_repetidas := qt_bolas_repetidas;
            Inc(indice_arranjo);
        end;

    end;

    // Agora, iremos gerar uma lista que servirá pra inserirmos o sql dinamicamente.
    // Observe que a variável 'indice_arranjo' contém a posição uma após o último concurso
    // que tem bolas repetidas.
    lista_sql_insert := TStringList.Create;
    lista_sql_insert.Clear;

    for uA := 0 to Pred(indice_arranjo) do
    begin
        concurso_atual := bolas_repetidas_por_concurso[uA];
        qt_de_bolas_repetidas := concurso_atual.qt_de_bolas_repetidas;

        sql_gerado := '';
        // Vamos gerar a lista desta forma: (concurso, 'a_b_c_d_e_f');
        for uB := 0 to Pred(qt_de_bolas_repetidas) do
            for uC := uB + 1 to Pred(qt_de_bolas_repetidas) do
                for uD := uC + 1 to Pred(qt_de_bolas_repetidas) do
                    for uE := uD + 1 to Pred(qt_de_bolas_repetidas) do
                        for uF := uE + 1 to Pred(qt_de_bolas_repetidas) do
                        begin
                            bolas_combinadas :=
                                IntToStr(concurso_atual.bolas_repetidas[uB]) + '_' +
                                IntToStr(concurso_atual.bolas_repetidas[uC]) + '_' +
                                IntToStr(concurso_atual.bolas_repetidas[uD]) + '_' +
                                IntToStr(concurso_atual.bolas_repetidas[uE]) + '_' +
                                IntToStr(concurso_atual.bolas_repetidas[uF]);
                            bolas_combinadas := QuotedStr(bolas_combinadas);

                            sql_gerado := '(' + IntToStr(concurso_atual.concurso) + ',' + bolas_combinadas + ')';
                            if lista_sql_insert.Count > 0 then
                            begin
                                lista_sql_insert.Add(',');
                            end;
                            lista_sql_insert.Add(sql_gerado);
                        end;

    end;
    // Desalocar memória.
    SetLength(bolas_repetidas_por_concurso, 0);

    lista_sql_insert.SaveToFile('/tmp/lista_sql.sql');

    // Agora, iremos gravar no banco de dados.
    try
        sql_query := TZquery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.SQL.Clear;
        sql_query.SQL.Add('Delete from lotofacil.lotofacil_resultado_grupo_com_5_bolas_repetindo');
        sql_query.ExecSql;
        sql_query.SQL.Clear;
        sql_query.SQL.Add('Insert into lotofacil.lotofacil_resultado_grupo_com_5_bolas_repetindo(concurso, grp_cmb)values');
        sql_query.Sql.Add(lista_sql_insert.Text);
        sql_query.ExecSQL;

    except
        On Exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    FreeAndNil(sql_query);

    MessageDlg('', 'Atualização da frequência de grupos executada com sucesso!!!',
        mtInformation, [mbOK], 0);

end;

procedure grupos_exibir_qt_entre_concursos(sql_conexao: TZConnection; sgr_controle: TStringGrid;
    concurso_inicial: integer; concurso_final: integer);
const
    sgr_controle_campos: array[1..4] of string = ('grp_cmb', 'qt_vz', 'nao', 'sim');
var
    sql_query:    TZQuery;
    coluna_atual: TGridColumn;
    uA, linha_sgr_controle: integer;
    qt_registros: longint;

begin
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select * from lotofacil.fn_lotofacil_resultado_grupo_5_bolas_repetindo(');
        sql_query.Sql.Add(IntToStr(concurso_inicial) + ',' + IntToStr(concurso_final) + ')');
        sql_query.Sql.Add('order by qt_vz desc, grp_cmb_1 asc');
        sql_query.Open;
        sql_query.First;
        sql_query.Last;

        qt_registros := sql_query.RecordCount;
        if qt_registros = 0 then
        begin
            FreeAndNil(sql_query);
            MessageDlg('', 'Erro, nenhum registro localizado', mtError, [mbOK], 0);
            Exit;
        end;

    except
        On exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    // Configurar controle.
    sgr_controle.Columns.Clear;
    for uA := 1 to 4 do
    begin
        coluna_atual := sgr_controle.Columns.Add;
        coluna_atual.Alignment := taCenter;
        coluna_atual.Title.Alignment := taCenter;
        coluna_atual.Title.Caption := sgr_controle_campos[uA];
    end;
    // Coluna 'nao'.
    coluna_atual := sgr_controle.Columns[2];
    coluna_atual.ButtonStyle := cbsCheckboxColumn;

    // Coluna 'sim'.
    coluna_atual := sgr_controle.Columns[3];
    coluna_atual.ButtonStyle := cbsCheckboxColumn;

    // A quantidade de linhas é mais 1, por causa do cabeçalho.
    sgr_controle.RowCount := qt_registros + 1;
    sgr_controle.FixedRows := 1;

    linha_sgr_controle := 1;
    sql_query.First;
    while (not sql_query.EOF) and (qt_registros <> 0) do
    begin
        sgr_controle.Cells[0, linha_sgr_controle] := sql_query.FieldByName('grp_cmb_1').AsString;
        sgr_controle.Cells[1, linha_sgr_controle] := IntToStr(sql_query.FieldByName('qt_vz').AsInteger);
        sgr_controle.Cells[2, linha_sgr_controle] := '0';
        sgr_controle.Cells[3, linha_sgr_controle] := '0';

        Inc(linha_sgr_controle);
        sql_query.Next;
        Dec(qt_registros);
    end;
    sgr_controle.AutoSizeColumns;

    sql_query.Close;
    FreeAndNil(sql_query);
end;

{
 Gera os grupos de 2 a 14 bolas, conforme opção escolhida pelo usuário.
 Após gerar os grupos já insere os mesmo no banco de dados.
}
procedure gerar_grupos_de_concursos(sql_conexao: TZConnection; concursos: TLotofacil_Concurso_Array;
    grupos_selecionados: array of boolean);
var
    bolas_do_concurso: array[0..15] of byte;
    lista_sql_a_inserir: TStringList;
    uA: integer;
    b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, concurso_atual,
    qt_bolas_no_grupo, indice_arranjo: integer;
    bolas_combinadas, sql_gerado, concursos_escolhidos,
      grupos_escolhidos: string;
    sql_query: TZQuery;
begin

    // Verifica se há um arranjo alocado.
    if High(concursos) = -1 then
    begin
        Exit;
    end;

    lista_sql_a_inserir := TStringList.Create;
    lista_sql_a_inserir.Clear;
    lista_sql_a_inserir.Add('concurso;qt_grp;grp_cmb');

    for uA := 2 to 15 do
    begin
        if grupos_selecionados[uA] then
        begin
            qt_bolas_no_grupo := uA;
        end
        else
        begin
            continue;
        end;

        // Grupo com 2 bolas.
        if qt_bolas_no_grupo = 2 then
        begin
            for indice_arranjo := 0 to High(concursos) do
            begin
                concurso_atual := concursos[indice_arranjo].concurso;

                for b1 := 1 to 15 do
                    for b2 := b1 + 1 to 15 do
                    begin
                        bolas_combinadas :=
                            format('%d_%d', [concursos[indice_arranjo].b1_a_b15[b1],
                            concursos[indice_arranjo].b1_a_b15[b2]]);
                        //bolas_combinadas := QuotedStr(bolas_combinadas);
                        sql_gerado := IntToStr(concurso_atual) + ';2;' +
                            bolas_combinadas;
                        lista_sql_a_inserir.Add(sql_gerado);
                    end;
            end;
        end
        else if qt_bolas_no_grupo = 12 then
        begin
            for indice_arranjo := 0 to High(concursos) do
                        begin
                            concurso_atual := concursos[indice_arranjo].concurso;

                            for b1 := 1 to 15 do
                                for b2 := b1 + 1 to 15 do
                                    for b3 := b2 + 1 to 15 do
                                        for b4 := b3 + 1 to 15 do
                                            for b5 := b4 + 1 to 15 do
                                                for b6 := b5 + 1 to 15 do
                                                    for b7 := b6 + 1 to 15 do
                                                        for b8 := b7 + 1 to 15 do
                                                            for b9 := b8 + 1 to 15 do
                                                                for b10 := b9 + 1 to 15 do
                                                                    for b11 := b10 + 1 to 15 do
                                                                        for b12 := b11 + 1 to 15 do
                                                                begin
                                                                    bolas_combinadas :=
                                                                        format('%d_%d_%d_%d_%d_%d_%d_%d_%d_%d_%d_%d',
                                                                        [
                                                                        concursos[indice_arranjo].b1_a_b15[b1],
                                                                        concursos[indice_arranjo].b1_a_b15[b2],
                                                                        concursos[indice_arranjo].b1_a_b15[b3],
                                                                        concursos[indice_arranjo].b1_a_b15[b4],
                                                                        concursos[indice_arranjo].b1_a_b15[b5],
                                                                        concursos[indice_arranjo].b1_a_b15[b6],
                                                                        concursos[indice_arranjo].b1_a_b15[b7],
                                                                        concursos[indice_arranjo].b1_a_b15[b8],
                                                                        concursos[indice_arranjo].b1_a_b15[b9],
                                                                        concursos[indice_arranjo].b1_a_b15[b10],
                                                                        concursos[indice_arranjo].b1_a_b15[b11],
                                                                        concursos[indice_arranjo].b1_a_b15[b12]
                                                                        ]);
                                                                    //bolas_combinadas := QuotedStr(bolas_combinadas);
                                                                    sql_gerado :=
                                                                        IntToStr(concurso_atual) + ';12;' + bolas_combinadas;
                                                                    lista_sql_a_inserir.Add(sql_gerado);
                                                                end;

                        end;
        end

        // Grupo com 10 bolas.
        else if qt_bolas_no_grupo = 10 then
        begin

            for indice_arranjo := 0 to High(concursos) do
            begin
                concurso_atual := concursos[indice_arranjo].concurso;

                for b1 := 1 to 15 do
                    for b2 := b1 + 1 to 15 do
                        for b3 := b2 + 1 to 15 do
                            for b4 := b3 + 1 to 15 do
                                for b5 := b4 + 1 to 15 do
                                    for b6 := b5 + 1 to 15 do
                                        for b7 := b6 + 1 to 15 do
                                            for b8 := b7 + 1 to 15 do
                                                for b9 := b8 + 1 to 15 do
                                                    for b10 := b9 + 1 to 15 do
                                                    begin
                                                        bolas_combinadas :=
                                                            format('%d_%d_%d_%d_%d_%d_%d_%d_%d_%d',
                                                            [
                                                            concursos[indice_arranjo].b1_a_b15[b1],
                                                            concursos[indice_arranjo].b1_a_b15[b2],
                                                            concursos[indice_arranjo].b1_a_b15[b3],
                                                            concursos[indice_arranjo].b1_a_b15[b4],
                                                            concursos[indice_arranjo].b1_a_b15[b5],
                                                            concursos[indice_arranjo].b1_a_b15[b6],
                                                            concursos[indice_arranjo].b1_a_b15[b7],
                                                            concursos[indice_arranjo].b1_a_b15[b8],
                                                            concursos[indice_arranjo].b1_a_b15[b9],
                                                            concursos[indice_arranjo].b1_a_b15[b10]
                                                            ]);
                                                        //bolas_combinadas := QuotedStr(bolas_combinadas);
                                                        sql_gerado :=
                                                            IntToStr(concurso_atual) + ';10;' + bolas_combinadas;
                                                        lista_sql_a_inserir.Add(sql_gerado);
                                                    end;

            end;
        end else if qt_bolas_no_grupo = 9 then
        begin
            for indice_arranjo := 0 to High(concursos) do
                        begin
                            concurso_atual := concursos[indice_arranjo].concurso;

                            for b1 := 1 to 15 do
                                for b2 := b1 + 1 to 15 do
                                    for b3 := b2 + 1 to 15 do
                                        for b4 := b3 + 1 to 15 do
                                            for b5 := b4 + 1 to 15 do
                                                for b6 := b5 + 1 to 15 do
                                                    for b7 := b6 + 1 to 15 do
                                                        for b8 := b7 + 1 to 15 do
                                                            for b9 := b8 + 1 to 15 do
                                                                begin
                                                                    bolas_combinadas :=
                                                                        format('%d_%d_%d_%d_%d_%d_%d_%d_%d',
                                                                        [
                                                                        concursos[indice_arranjo].b1_a_b15[b1],
                                                                        concursos[indice_arranjo].b1_a_b15[b2],
                                                                        concursos[indice_arranjo].b1_a_b15[b3],
                                                                        concursos[indice_arranjo].b1_a_b15[b4],
                                                                        concursos[indice_arranjo].b1_a_b15[b5],
                                                                        concursos[indice_arranjo].b1_a_b15[b6],
                                                                        concursos[indice_arranjo].b1_a_b15[b7],
                                                                        concursos[indice_arranjo].b1_a_b15[b8],
                                                                        concursos[indice_arranjo].b1_a_b15[b9]
                                                                        ]);
                                                                    //bolas_combinadas := QuotedStr(bolas_combinadas);
                                                                    sql_gerado :=
                                                                        IntToStr(concurso_atual) + ';9;' + bolas_combinadas;
                                                                    lista_sql_a_inserir.Add(sql_gerado);
                                                                end;

                        end;


        end;

    end;

    lista_sql_a_inserir.SaveToFile('/tmp/lotofacil_grupos.csv');

    // Agora, vamos incluir no banco de dados, pra isto, iremos excluir os grupos e os concursos
    // escolhidos pelo usuário.
    concursos_escolhidos := '';
    for uA := 0 to High(concursos) do begin
        if concursos_escolhidos <> '' then begin
            concursos_escolhidos := concursos_escolhidos + ', '
        end;
        concursos_escolhidos := concursos_escolhidos + IntToStr(concursos[uA].concurso);
    end;
    concursos_escolhidos := '(' + concursos_escolhidos + ')';

    // Agora, iremos pegar os grupos escolhidos pois iremos sobrescrever.
    grupos_escolhidos := '';
    for uA := 0 to High(grupos_selecionados) do begin
        if grupos_selecionados[uA] then begin
            if grupos_escolhidos <> '' then begin
                grupos_escolhidos := grupos_escolhidos + ','
            end;
            grupos_escolhidos := grupos_escolhidos + IntToStr(uA);
        end;
    end;
    grupos_escolhidos := '(' + grupos_escolhidos + ')';

    try
        sql_query := TZQuery.Create(Nil);
        sql_query.Connection := sql_conexao;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Delete from lotofacil.lotofacil_resultado_grupo');
        sql_query.Sql.Add('where concurso in ' + concursos_escolhidos);
        sql_query.Sql.Add('and qt_grp in ' + grupos_escolhidos);
        sql_query.ExecSQL;
        sql_query.SQL.Clear;
        //sql_query.Sql.Add('Insert Into lotofacil.lotofacil_resultado_grupo');
        //sql_query.Sql.Add('(concurso,qt_grp,grp_cmb)values');
        //sql_query.SQL.Add(lista_sql_a_inserir.Text);
        sql_query.SQL.Add('Copy lotofacil.lotofacil_resultado_grupo');
        sql_query.Sql.Add('(concurso,qt_grp,grp_cmb)');
        sql_query.SQL.Add('from ''/tmp/lotofacil_grupos.csv''');
        sql_query.Sql.Add('with (delimiter '';'', header true, format csv)');
        sql_query.ExecSQL;

    except
        On exc: Exception do begin
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbok], 0);
            FreeAndNil(lista_sql_a_inserir);
            Exit;
        end;
    end;
    FreeAndNil(sql_query);
    FreeAndNil(lista_sql_a_inserir);
end;

end.
