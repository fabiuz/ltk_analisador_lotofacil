unit lotofacil_comparacao_de_bolas_na_mesma_coluna;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, ZConnection, ZDataset, Grids, Dialogs;

procedure exibir_status_da_comparacao_de_bolas_na_mesma_coluna(sql_conexao: TZConnection; sgr_controle: TStringGrid);
procedure atualizar_status_da_comparacao_de_bolas_na_mesma_coluna(sql_conexao: TZConnection);

implementation

procedure exibir_status_da_comparacao_de_bolas_na_mesma_coluna(sql_conexao: TZConnection; sgr_controle: TStringGrid);
var
    sql_query: TZQuery;
    coluna_atual: TGridColumn;
    uA: integer;
    qt_registros: longint;
begin
    sgr_controle.Columns.Clear;

    sql_query := TZQuery.Create(nil);
    sql_query.Connection := sql_conexao;
    sql_query.Sql.Clear;
    sql_query.Sql.Add('Select concurso, status from lotofacil.v_ltf_res_comparacao_de_bolas_na_mesma_coluna_status');
    sql_query.Sql.Add('order by concurso desc');
    sql_query.Open;

    sql_query.First;
    sql_query.Last;
    qt_registros := sql_query.RecordCount;

    if qt_registros = 0 then
    begin
        MessageDlg('', 'Nenhum registro localizado.', mtError, [mbOK], 0);
        Exit;
    end;

    sgr_controle.Columns.Clear;
    coluna_atual := sgr_controle.Columns.Add;
    coluna_atual.Alignment := taCenter;
    coluna_atual.Title.Caption := 'Concurso';
    coluna_atual.Title.Alignment := taCenter;

    coluna_atual := sgr_controle.Columns.Add;
    coluna_atual.Alignment := taCenter;
    coluna_atual.Title.Caption := 'Status';
    coluna_atual.Title.Alignment := taCenter;

    sgr_controle.FixedRows := 1;
    sgr_controle.FixedCols := 0;
    sgr_controle.RowCount := qt_registros + 1;

    sql_query.First;

    for uA := 1 to qt_registros do
    begin
        sgr_controle.Cells[0, uA] := sql_query.FieldByName('concurso').AsString;
        sgr_controle.Cells[1, uA] := sql_query.FieldByName('status').AsString;
        sql_query.Next;
    end;
    sgr_controle.AutoSizeColumns;

    sql_query.Close;
    sql_query.Connection.Connected := False;
    FreeAndNil(sql_query);
end;

procedure atualizar_status_da_comparacao_de_bolas_na_mesma_coluna(sql_conexao: TZConnection);
var
    sql_query: TZQuery;
begin
    try
        sql_query := TZQuery.Create(nil);
        sql_query.connection := sql_conexao;
        sql_query.Connection.AutoCommit := False;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select from lotofacil.fn_lotofacil_resultado_comparacao_de_bolas_na_mesma_coluna()');
        sql_query.ExecSql;
        sql_query.Connection.Commit;
        sql_query.Close;
        sql_query.Connection.Connected := False;
        FreeAndNil(sql_query);

    except
        On exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
            FreeAndNil(sql_query);
            Exit;
        end;
    end;
end;

end.
