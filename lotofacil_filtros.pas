unit lotofacil_filtros;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, ZConnection, ZDataset, lotofacil_var_global, controls;

procedure carregar_filtro_sgr_controle(sgr_controle: TStringGrid; sql_conexao: TZConnection);
procedure marcar_sim_nao_pra_coluna(sgr_controle: TStringGrid; sim_ou_nao: string);
procedure obter_filtro(sgr_controle: TStringGrid; sql_conexao: TZConnection);
procedure alterar_marcador_sim_nao(sgr_controle: TStringGrid;
    aCol, aRow: integer);

procedure Filtro_Excluir(filtro_data_hora: ansistring; sql_conexao: TZConnection);

implementation

uses Dialogs;

{
 Deleta o filtro selecionado pelo usuário.
}
procedure Filtro_Excluir(filtro_data_hora: ansistring; sql_conexao: TZConnection);
var
    //sql_registros:   TSQLQuery;

    sql_query : TZQuery;
    data_hora, Data: TStringArray;
    filtro_data_hora_original: string;
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
            + '-', mtError, [mbOK], 0);
        Exit;
    end;

    // Ficará desta forma:
    // data[0] => dia
    // data[1] => mes
    // data[2] => ano

    // Agora, iremos colocar a data no formato americano.
    filtro_data_hora := Data[2] + '-' + Data[1] + '-' + Data[0] + ' ' + data_hora[1];

    try
      sql_query := TZQuery.Create(Nil);
      sql_query.Connection := sql_conexao;

      //sql_registros := TSqlQuery.Create(Self);
      //sql_registros.DataBase := dmLotofacil.pgLTK;

      sql_query.Close;
      sql_query.SQL.Clear;
      sql_query.Sql.Add('Delete from lotofacil.lotofacil_filtros');
      sql_query.Sql.Add('where data = ' + QuotedStr(filtro_data_hora));
      sql_query.ExecSQL;
      sql_query.Close;
      FreeAndNil(sql_query);

      //dmLotofacil.pgLTK.Transaction.Commit;
      //sql_registros.Close;
      //dmLotofacil.pgLtk.Close(True);
    except
        on Exc: Exception do
        begin
            MessageDlg('', 'Erro, ' + exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    // Atualiza o controle com os filtros.
    //obterNovosFiltros(btn_obter_novos_filtros);

    MessageDlg('', 'Filtro ' + filtro_data_hora_original, mtInformation, [mbOK], 0);

end;

function configurar_sgr_controle(sgr_controle: TStringGrid): boolean;
var
  ultima_coluna, uA: integer;
  coluna_atual: TGridColumn;
  cabecalho_do_controle: array of string;
  indice_tag: integer;
begin
  // Verifica se o índice está na faixa válida.
  indice_tag := sgr_controle.Tag;
  if (indice_tag < 0) or (indice_tag > high(sgr_filtro_cabecalho)) then
  begin
    Exit(False);
  end;

  // Obtém o cabeçalho, que está no na dimensão 1, no índice 1,
  // Vamos colocar o string todo em maiúsculas antes de retornar o arranjo.
  cabecalho_do_controle := AnsiLowerCase(sgr_filtro_cabecalho[indice_tag]).Split(',');
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


procedure carregar_filtro_sgr_controle(sgr_controle: TStringGrid;
  sql_conexao: TZConnection);
begin
  obter_filtro(sgr_controle, sql_conexao);
end;

{
 Obtém os filtros da tabela no banco de dados e popula no controle.
}
procedure obter_filtro(sgr_controle: TStringGrid; sql_conexao: TZConnection);
var
  ultima_coluna: integer;
  sql_query: TZQuery;
  sql_campos: array of string;
  qt_registros, linha_sgr_controle, uA: integer;
  valor_do_campo_atual: string;
  indice_tag: integer;
begin
  if configurar_sgr_controle(sgr_controle) = False then
  begin
    Exit;
  end;

  // Obtém o índice.
  indice_tag := sgr_controle.tag;

  // Verifica se o índice está na faixa válida.
  indice_tag := sgr_controle.Tag;
  if (indice_tag < 0) or (indice_tag > high(sgr_filtro_sql)) then
  begin
    Exit;
  end;

  // Obtém o cabeçalho, que está no na dimensão 1, no índice 1;
  sql_campos := sgr_filtro_sql[indice_tag, 0].Split(',');
  ultima_coluna := High(sql_campos);

  try
    sql_query := TZQuery.Create(sgr_controle.parent);
    sql_query.Connection := sql_conexao;

    sql_query.Sql.Clear;
    sql_query.Sql.Add('Select ');
    for uA := 0 to ultima_coluna do
    begin
      if uA <> 0 then
      begin
        sql_query.Sql.Add(', ');
      end;
      sql_query.Sql.Add(sql_campos[uA]);
    end;
    sql_query.Sql.Add(' from ' + sgr_filtro_sql[indice_tag, 1]);

    // As colunas d_sorte_qt e res_qt_desc, são as últimas colunas iremos classificar por elas.
    if ((sql_campos[ultima_coluna] = 'd_sorte_qt') and (sql_campos[ultima_coluna-1] = 'res_qt')) or
        ((sql_campos[ultima_coluna] = 'res_qt') and (sql_campos[ultima_coluna-1] = 'res_qt')) then
    begin
      sql_query.Sql.Add('order by res_qt desc, d_sorte_qt desc');
    end else if sql_campos[ultima_coluna] = 'res_qt' then begin
      sql_query.Sql.Add('order by res_qt desc');
    end;

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
      sgr_controle.cells[0, 0] := 'Erro, não há filtros';
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
        valor_do_campo_atual :=
          sql_query.FieldByName(sql_campos[uA]).AsString;
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

 Então, devemos verificar isto:
 Se o usuário escolhe uma célula da coluna 'sim' devemos desmarcar automaticamente a célula
 correspondente na coluna 'não'.
 O mesmo ocorre pra o 'não', se o usuário escolhe 'não' devemos desmarcar automaticamente a célula
 corresponde na coluna 'sim'.
 Se o usuário desmarca o 'sim', não precisa desmarcar a outra célula da mesma linha da coluna 'nao'.
}
procedure alterar_marcador_sim_nao(sgr_controle: TStringGrid;
    aCol, aRow: integer);
var
    ultima_coluna, penultima_coluna: integer;
    celula_ultima_coluna: string;
    celula_penultima_coluna: string;
    titulo_da_coluna: string;
begin
    // Se não há colunas retornar.
    if sgr_controle.Columns.Count <= 0 then
        Exit;

    // Se não tem título, retornar.
    if not Assigned(sgr_controle.Columns[aCol].Title) then
    begin
        Exit;
    end;

    // Verifica se estamos nas colunas corretas, as únicas colunas
    // que iremos verificar é as colunas com o nome 'SIM' e 'NAO'.
    titulo_da_coluna := LowerCase(sgr_controle.Columns[aCol].Title.Caption);
    if (titulo_da_coluna <> 'sim') and (titulo_da_coluna <> 'nao') then
    begin
        Exit;
    end;

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

  titulo_ultima_coluna := AnsiUpperCase(
    sgr_controle.Columns[indice_ultima_coluna].Title.Caption);
  titulo_penultima_coluna :=
    AnsiUpperCase(sgr_controle.Columns[indice_penultima_coluna].Title.Caption);

  if (titulo_ultima_coluna <> 'SIM') and (titulo_penultima_coluna <> 'NAO') then
  begin
    Exit;
  end;

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

end.
