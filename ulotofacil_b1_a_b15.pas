unit ulotofacil_b1_a_b15;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, Grids, stdCtrls;

procedure Configurar_controle_b1_a_b15(objControle: TStringGrid);
procedure Carregar_controle_b1_a_b15(objControle: TStringGrid);
procedure Carregar_controle_b1_a_b15(objControle: TStringGrid; str_where: string);
procedure Carregar_controle_b1_a_b15_novo(objControle: TStringGrid; str_where: string);
procedure Carregar_controle_b1_a_b15_por_intervalo_concurso(objControle: TStringGrid;  concurso_inicial, concurso_final: integer);

procedure Atualizar_cmb_intervalo_por_concurso_bx_a_by(objControle: TComboBox; lista_de_concursos: TStringList);

function obter_sufixo_do_nome_da_tabela(objControle: TStringGrid;  var nome_da_tabela: string; var coluna_inicial, coluna_final: integer): boolean;
function obter_sufixo_de_controle_por_intervalo_de_concurso(objControle: TStringGrid;
  var nome_da_tabela: string; var coluna_inicial, coluna_final: integer): boolean;

function obter_id_de_combinacoes_selecionadas(objControle: TStringGrid;
  var id_selecionados: string): boolean;

//function gerar_sql_b1_a_b15: string;

implementation

uses
  RegExpr, strUtils, Dialogs,
  uLotofacilModulo,
  fgl;

{
 Ao invés de ter 120 procedures pra cada controle com a quantidade de colunas
 diferente, iremos manipular tudo em uma única procedure.
 Todos os controles que armazenam a análise de b1_a_b15, começa com: sgr_, por
 exemplo:
 sgr_b1_a_b15.
 Na procedure iremos
}
procedure Configurar_controle_b1_a_b15(objControle: TStringGrid);
var
  bola_final, bola_inicial: integer;
  nome_do_controle: TComponentName;
  nome_valido: TRegExpr;
  colunas: TStringArray;
  coluna_inicial, coluna_final, uA: longint;
  coluna_atual: TGridColumn;
begin
  bola_inicial := 0;
  bola_final := 0;

  // Verifica se começa com 'sgr_'
  nome_do_controle := objControle.Name;
  if not AnsiStartsText('sgr_', nome_do_controle) then
  begin
    Exit;
  end;

  // Podemos manipular 2 tipos de controles, que está desta forma:
  // sgr_intervalo_por_concurso_bx_a_by, onde x e y representa números no intervalo
  // de 1 a 15 e onde x >= y.
  // sgr_bx_a_by.
  nome_do_controle := ReplaceText(nome_do_controle, 'sgr_intervalo_por_concurso_', '');
  nome_do_controle := ReplaceText(nome_do_controle, 'sgr_', '');


  // Fica algo assim:
  // b1_a_b15
  // Retira o _a_
  nome_do_controle := ReplaceText(nome_do_controle, '_a_', '');

  // Não irei usar expressão regular aqui, irei separar em um arranjo.
  colunas := nome_do_controle.Split('b', TStringSplitOptions.ExcludeEmpty);

  if Length(colunas) <> 2 then
  begin
    Exit;
  end;

  try
    coluna_inicial := StrToInt(colunas[0]);
    coluna_final := StrToInt(colunas[1]);

    if coluna_inicial > coluna_final then
    begin
      MessageDlg('', 'Controle ' + nome_do_controle + ' está com nome incorreto.',
        mtError, [mbOK], 0);
      Exit;
    end;

  except
    On exc: Exception do
    begin
      Exit;
    end;
  end;

  // Vamos criar as colunas do controle
  // Primeira coluna, grp_id
  objControle.Columns.Clear;
  coluna_atual := objControle.Columns.Add;
  coluna_atual.Alignment := taCenter;
  coluna_atual.Title.Caption := 'grp_id';
  coluna_atual.Title.Alignment := taCenter;
  coluna_atual.Visible:= false;

  // As colunas onde ficarão as bolas.
  for uA := coluna_inicial to coluna_final do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.Alignment := taCenter;
    coluna_atual.Title.Caption := 'b_' + IntToStr(uA);
    coluna_atual.Title.Alignment := taCenter;
  end;

  // A coluna qt_vezes
  coluna_atual := objControle.Columns.Add;
  coluna_atual.Alignment := taCenter;
  coluna_atual.Title.Caption := 'qt_vz';
  coluna_atual.Title.Alignment := taCenter;

  // A coluna 'marcar'.
  coluna_atual := objControle.Columns.Add;
  coluna_atual.Alignment := taCenter;
  coluna_atual.Title.Caption := 'Marcar';
  coluna_atual.Title.Alignment := taCenter;
  coluna_atual.ButtonStyle := cbsCheckboxColumn;

  objControle.FixedRows := 1;
  objControle.AutoSizeColumns;
  objControle.RowCount := 1;
end;

{
 Atualiza os controles abaixo com todos os números do concurso já sorteado:
 cmb_intervalo_por_concurso_inicial_bx_a_by ou
 cmb_intervalo_por_concurso_final_bx_a_by,
 onde x e y representa números do intervalo de 1 a 15, onde x é maior ou igual a y.
 Por exemplo, cmb_intervalo_por_concurso_inicial_b1_b15 é um controle válido.
}
procedure Atualizar_cmb_intervalo_por_concurso_bx_a_by(objControle: TComboBox; lista_de_concursos: TStringList);
begin
  objControle.Items.Clear;
  objControle.Items.AddStrings(lista_de_concursos, True);
end;

procedure Carregar_controle_b1_a_b15(objControle: TStringGrid);
var
  nome_sufixo, nome_dos_campos_b, nome_dos_campos_b_asc, nome_campo_id: string;
  coluna_inicial, coluna_final, linha_atual, id_coluna, uA: integer;
  sql_query: TSQLQuery;
  qt_registros, valor_da_coluna_atual: longint;
begin

  Configurar_controle_b1_a_b15(objControle);

  nome_sufixo := '';
  coluna_inicial := 0;
  coluna_final := 0;

  if not obter_sufixo_do_nome_da_tabela(objControle, nome_sufixo,
    coluna_inicial, coluna_final) then
  begin
    MessageDlg('', 'Nome de controle inválido pra analisar colunas b1 a b15: ' +
      objControle.Name, mtError, [mbOK], 0);
    objControle.Columns.Clear;
    Exit;
  end;

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := tdmLotofacil.Create(objControle.Parent);
  end;

  sql_query := dmLotofacil.sqlLotofacil;
  sql_query.DataBase := dmLotofacil.pgLTK;
  sql_query.sql.Clear;

  sql_query.Sql.Add('Select @nome_campo_id@, @nome_campos_b@, qt_vezes from');
  sql_query.Sql.Add('lotofacil.v_lotofacil_resultado_@tabela_nome_sufixo@');
  sql_query.Sql.Add('order by qt_vezes desc, @nome_campos_b_asc@');

  // Agora, vamos criar os dados que serão populados.
  nome_campo_id := nome_sufixo + '_id';

  nome_dos_campos_b := '';
  nome_dos_campos_b_asc := '';

  for uA := coluna_inicial to coluna_final do
  begin
    if uA <> coluna_inicial then
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format(', b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format(', b%d asc', [uA]);
    end
    else
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format('b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format('b%d asc', [uA]);
    end;
  end;

  // Vamos substituir os dados.
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@nome_campo_id@',
    nome_campo_id);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@nome_campos_b@',
    nome_dos_campos_b);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@nome_campos_b_asc@',
    nome_dos_campos_b_asc);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@tabela_nome_sufixo@',
    nome_sufixo);

  try
    sql_query.UniDirectional := False;
    sql_query.Open;

    qt_registros := 0;
    linha_atual := 1;
    sql_query.First;
    objControle.BeginUpdate;
    while not sql_query.EOF do
    begin
      Inc(qt_registros);
      objControle.RowCount := qt_registros + 1;

      id_coluna := 0;
      objControle.Cells[0, linha_atual] := IntToStr(sql_query.FieldByName(nome_sufixo + '_id').AsInteger);

      // Colunas b: b1, b2, ...
      for uA := coluna_inicial to coluna_final do
      begin
        Inc(id_coluna);
        valor_da_coluna_atual := sql_query.FieldByName('b' + IntToStr(uA)).AsInteger;
        objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);
      end;

      // Coluna qt_vezes
      Inc(id_coluna);
      valor_da_coluna_atual := sql_query.FieldByName('qt_vezes').AsInteger;
      objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);

      // Coluna marcar.
      // A valor da célula na linha e coluna marcar terá o valor 0
      // pois o estilo desta coluna é checkbox, e um valor 0, significa
      // desmarcado o checkbox.
      Inc(id_coluna);
      objControle.Cells[id_coluna, linha_atual] := '0';

      sql_query.Next;
      Inc(linha_atual);
    end;
    objControle.EndUpdate(true);
    sql_query.Close;
    dmLotofacil.pgLTK.Close(True);

    // Se não houve registros
    if qt_registros = 0 then
    begin
      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.RowCount := 1;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Nenhum registro localizado.';
    end;

  except
    on exc: Exception do
    begin
      dmLotofacil.pgLTK.Close(True);

      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Error: ' + exc.Message;
    end;
  end;

end;

procedure Carregar_controle_b1_a_b15(objControle: TStringGrid; str_where: string);
var
  nome_sufixo, nome_dos_campos_b, nome_dos_campos_b_asc, campo_id: string;
  coluna_inicial, coluna_final, linha_atual, id_coluna, uA: integer;
  sql_query: TSQLQuery;
  qt_registros, valor_da_coluna_atual: longint;
begin

  Configurar_controle_b1_a_b15(objControle);

  nome_sufixo := '';
  coluna_inicial := 0;
  coluna_final := 0;

  if not obter_sufixo_do_nome_da_tabela(objControle, nome_sufixo,
    coluna_inicial, coluna_final) then
  begin
    MessageDlg('', 'Nome de controle inválido pra analisar colunas b1 a b15: ' +
      objControle.Name, mtError, [mbOK], 0);
    objControle.Columns.Clear;
    Exit;
  end;

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := tdmLotofacil.Create(objControle.Parent);
  end;

  sql_query := dmLotofacil.sqlLotofacil;
  sql_query.DataBase := dmLotofacil.pgLTK;
  sql_query.sql.Clear;

  {
   No código abaixo, iremos criar um sql dinâmico, semelhante a este:
   Select ltf_a.b2_a_b3_id, b2, b3, count(ltf_c.b2_a_b3_id) as qt_vezes
from (
     Select b2_a_b3_id from lotofacil.lotofacil_coluna_b
where b2_a_b2_id = 2
     group by b2_a_b3_id) ltf_a
     inner join lotofacil.lotofacil_id_b2_a_b3 ltf_b
          on ltf_a.b2_a_b3_id = ltf_b.b2_a_b3_id
     left join lotofacil.lotofacil_resultado_coluna_b ltf_c
     on ltf_b.b2_a_b3_id = ltf_c.b2_a_b3_id
group by ltf_a.b2_a_b3_id, b2, b3
order by qt_vezes desc;
  }

  {
   No sql abaixo, iremos colocar substituídores, começa por '@', depois
   iremos substituir com valores, então assim, fica mais fácil ver como o sql
   está montado.
  }
  sql_query.Sql.Add('Select ltf_a.@id_1, @campos_b, count(ltf_c.@id_1) as qt_vezes');
  sql_query.Sql.Add('from (');
  sql_query.Sql.Add('Select @id_1 from lotofacil.lotofacil_coluna_b');
  sql_query.Sql.Add(Format('where %s', [str_where]));
  sql_query.Sql.Add('and ltf_qt = 15');
  sql_query.Sql.Add('group by @id_1) ltf_a');
  sql_query.Sql.Add('inner join lotofacil.lotofacil_id_@tabela_sufixo ltf_b');
  sql_query.Sql.Add('on ltf_a.@id_1 = ltf_b.@id_1');
  sql_query.Sql.Add('left join lotofacil.lotofacil_resultado_coluna_b ltf_c');
  sql_query.SQL.Add('on ltf_b.@id_1 = ltf_c.@id_1');
  sql_query.Sql.Add('group by ltf_a.@id_1, @campos_b');
  sql_query.Sql.Add('order by qt_vezes desc, @campos_asc');

  writeln(sql_query.sql.Text);

  // Agora, iremos substituir as tags começando por @.
  nome_dos_campos_b := '';
  nome_dos_campos_b_asc := '';

  for uA := coluna_inicial to coluna_final do
  begin
    if uA <> coluna_inicial then
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format(', b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format(', b%d asc', [uA]);
    end
    else
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format('b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format('b%d asc', [uA]);
    end;
  end;

  campo_id := nome_sufixo + '_id';

  // Agora, é só substituir, as tags @id_1, @tabela_sufixo, @campos_b, @campos_asc.
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@id_1', campo_id);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@campos_b', nome_dos_campos_b);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@campos_asc',
    nome_dos_campos_b_asc);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@tabela_sufixo', nome_sufixo);

  writeln(sql_query.sql.Text);

  try
    sql_query.UniDirectional := True;
    sql_query.Open;
    sql_query.First;
    linha_atual := 1;
    objControle.Columns[0].Visible := False;

    objControle.BeginUpdate;
    qt_registros := 0;
    while not sql_query.EOF do
    begin
      Inc(qt_registros);
      objControle.RowCount := qt_registros + 1;
      id_coluna := 0;
      objControle.Cells[0, linha_atual] :=
        IntToStr(sql_query.FieldByName(nome_sufixo + '_id').AsInteger);

      // Colunas b: b1, b2, e assim por diante.
      for uA := coluna_inicial to coluna_final do
      begin
        Inc(id_coluna);
        valor_da_coluna_atual := sql_query.FieldByName('b' + IntToStr(uA)).AsInteger;
        objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);
      end;

      // Coluna qt_vezes
      Inc(id_coluna);
      valor_da_coluna_atual := sql_query.FieldByName('qt_vezes').AsInteger;
      objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);

      // Coluna marcar.
      // A valor da célula na linha e coluna marcar terá o valor 0
      // pois o estilo desta coluna é checkbox, e um valor 0, significa
      // desmarcado o checkbox.
      Inc(id_coluna);
      objControle.Cells[id_coluna, linha_atual] := '0';

      sql_query.Next;
      Inc(linha_atual);
    end;
    objControle.EndUpdate(True);

    sql_query.Close;
    dmLotofacil.pgLTK.Close(True);
  except
    on exc: Exception do
    begin
      dmLotofacil.pgLTK.Close(True);
      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Error: ' + exc.Message;
      objControle.EndUpdate(True);
    end;
  end;

  // Verifica se realmente, houve registros.
  if qt_registros = 0 then
  begin
    sql_query.Close;
    dmlotofacil.pgLTK.Close(True);

    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 1;
    objControle.Cells[0, 0] := 'Erro, não há registros...';
    Exit;
  end;

end;

{
 Esta procedure atualizar um controle baseada em marcações de outro controle.
 Por exemplo, se o usuário selecionou combinações no controle sgr_b1_a_b1,
 automaticamente, o controle sgr_b1_a_b2 será atualizado.
 Pra entender como funciona, iremos explicar abaixo:
 A tabela lotofacil_coluna_b, armazena campos b, da forma bx_a_by_id, onde x e y,
 representa números de 1 a 15, onde x <= y, por exemplo, b1_a_b3_id, armazena o id
 que representa a combinação de 3 bolas que estão na campos b1, b2, b3. Pra cada
 combinação de bolas, há um id exclusivo. Então, nesta tabela, pra cada combinação da
 lotofacil, há 120 colunas, cada 1, armazenando a combinação de 1 até 15 bolas,
 em posições especificas nas colunas.
 Então, a procedure abaixo, atualiza o controle com id de outro campo.
 No nosso programa, sempre iremos atualizar o próximo campo, pra isto, dado
 um controle qualquer da forma 'sgr_bx_a_by', este controle representa um campo
 específico da tabela. Então, quando se passa um controle pra atualizar,
 as combinações são filtradas baseada em outro campo, no nosso campo, é o campo anterior.
 Por exemplo:
 Se o controle é sgr_b1_a_b2, então, o controle anterior é sgr_b1_a_b1, então, iremos
 pegar as marcações, ou ids das combinações e filtrar neste controle.
 Pra cada campo, há uma tabela que armazena o agregado do campo anterior com o próximo.
}
procedure Carregar_controle_b1_a_b15_novo(objControle: TStringGrid; str_where: string);
var
  nome_sufixo, nome_dos_campos_b, nome_dos_campos_b_asc, campo_id,
    campo_id_1, campo_id_2: string;
  coluna_inicial, coluna_final, linha_atual, id_coluna, uA,
    indice_virgula: integer;
  sql_query: TSQLQuery;
  qt_registros, valor_da_coluna_atual: longint;
begin
  // Vamos obter o campo_id do outro controle.
  // str_where, deve vir desta forma: bx_a_by_id in (  onde x e y são números, sem espações, entre

  // Vamos procurar a posição do '('.
  indice_virgula := str_where.IndexOf('(');
  if indice_virgula < 0 then begin
    MessageDlg('', 'Parâmetro: str_where inválido', mtError, [mbOk], 0);
    Exit;
  end;

  // Vamos pegar tudo antes de '('.
  campo_id_1 := AnsiLeftStr(str_where, indice_virgula);

  // Agora, vamos apagar
  // os string 'in', id e espaço.
  campo_id_1 := ReplaceText(campo_id_1, 'in', '');
  campo_id_1 := ReplaceText(campo_id_1, '_id', '');
  campo_id_1 := ReplaceText(campo_id_1, ' ', '');

  Configurar_controle_b1_a_b15(objControle);

  nome_sufixo := '';
  coluna_inicial := 0;
  coluna_final := 0;

  if not obter_sufixo_do_nome_da_tabela(objControle, nome_sufixo,
    coluna_inicial, coluna_final) then
  begin
    MessageDlg('', 'Nome de controle inválido pra analisar colunas b1 a b15: ' +
      objControle.Name, mtError, [mbOK], 0);
    objControle.Columns.Clear;
    Exit;
  end;

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := tdmLotofacil.Create(objControle.Parent);
  end;

  sql_query := dmLotofacil.sqlLotofacil;
  sql_query.DataBase := dmLotofacil.pgLTK;
  sql_query.sql.Clear;

  {
   No sql, abaixo, que criaremos dinamicamente iremos substituir as tags:
   @id_2@, que corresponde ao id da tabela que será populado no controle correspondente,
           por exemplo, se o controle é sgr_b1_a_b2, então, irá ser substituido por
           b1_a_b2.

   @select_campos_b@:
                     Neste caso, será os nomes dos campos da tabela, interseparados
                     pela ',' (vírgula), no exemplo, acima, a tabela a ser usada
                     seria 'lotofacil.lotofacil_id_b1_a_b2', neste caso, os campos
                     seriam: b1, b2

   @str_where@:      Ao chamar a procedure, o parâmetro str_where substituído a tag '@str_where@'.

   @select_campos_b_as:
                       Na cláusula order by, iremos colocar os mesmo campos b que
                       substitui @select_campos_b2@, neste caso, terá após o nome
                       do campo a palavra asc, então, no nosso exemplo, seria substituído
                       por b1 asc, b2 asc.

   Após substituímos as tags, baseando no nosso exemplo dado, o select ficaria desta forma:

   Select ltf_a.b1_a_b2_id, ltf_b.b1, ltf_b.b2, count(ltf_c.b1_a_b2_id) as qt_vezes
  from lotofacil.ltf_bx_a_by_b1_a_b1_agregado_com_b1_a_b2 ltf_a
  inner join lotofacil.lotofacil_id_b1_a_b2 ltf_b
    on ltf_a.b1_a_b2_id = ltf_b.b1_a_b2_id
  left join lotofacil.lotofacil_resultado_coluna_b ltf_c
    on ltf_c.b1_a_b2_id = ltf_b.b1_a_b2_id
  where ltf_a.b1_a_b1_id in (1, 2)
  group by ltf_a.b1_a_b2_id, ltf_b.b1, ltf_b.b2
  order by qt_vezes desc;
  }
  sql_query.Sql.Add('Select ltf_a.@id_2@_id, @select_campos_b@, count(ltf_c.@id_2@_id) as qt_vezes');
  sql_query.Sql.Add('from lotofacil.ltf_bx_a_by_@id_1@_agregado_com_@id_2@ ltf_a');
  sql_query.Sql.Add('inner join lotofacil.lotofacil_id_@id_2@ ltf_b');
  sql_query.Sql.Add('on ltf_a.@id_2@_id = ltf_b.@id_2@_id');
  sql_query.Sql.Add('left join lotofacil.lotofacil_resultado_coluna_b ltf_c');
  sql_query.Sql.Add('on ltf_c.@id_2@_id = ltf_b.@id_2@_id');
  sql_query.Sql.Add('where ltf_a.@str_where@');
  sql_query.Sql.Add('group by ltf_a.@id_2@_id, @select_campos_b@');
  sql_query.Sql.Add('order by qt_vezes desc, @select_campos_b_asc@');

  writeln(sql_query.sql.Text);

  // Agora, iremos substituir as tags começando por @ e terminando por @.
  nome_dos_campos_b := '';
  nome_dos_campos_b_asc := '';

  for uA := coluna_inicial to coluna_final do
  begin
    if uA <> coluna_inicial then
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format(', b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format(', b%d asc', [uA]);
    end
    else
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format('b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format('b%d asc', [uA]);
    end;
  end;

  campo_id_2 := nome_sufixo;

  // Agora, é só substituir, as tags @id_1, @tabela_sufixo, @campos_b, @campos_asc.
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@id_1@', campo_id_1);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@id_2@', campo_id_2);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@select_campos_b@', nome_dos_campos_b);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@select_campos_b_asc@',
    nome_dos_campos_b_asc);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@str_where@', str_where);

  writeln(sql_query.sql.Text);

  try
    sql_query.UniDirectional := True;
    sql_query.Open;
    sql_query.First;
    linha_atual := 1;
    objControle.Columns[0].Visible := False;

    objControle.BeginUpdate;
    qt_registros := 0;
    while not sql_query.EOF do
    begin
      Inc(qt_registros);
      objControle.RowCount := qt_registros + 1;
      id_coluna := 0;
      objControle.Cells[0, linha_atual] :=
        IntToStr(sql_query.FieldByName(nome_sufixo + '_id').AsInteger);

      // Colunas b: b1, b2, e assim por diante.
      for uA := coluna_inicial to coluna_final do
      begin
        Inc(id_coluna);
        valor_da_coluna_atual := sql_query.FieldByName('b' + IntToStr(uA)).AsInteger;
        objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);
      end;

      // Coluna qt_vezes
      Inc(id_coluna);
      valor_da_coluna_atual := sql_query.FieldByName('qt_vezes').AsInteger;
      objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);

      // Coluna marcar.
      // A valor da célula na linha e coluna marcar terá o valor 0
      // pois o estilo desta coluna é checkbox, e um valor 0, significa
      // desmarcado o checkbox.
      Inc(id_coluna);
      objControle.Cells[id_coluna, linha_atual] := '0';

      sql_query.Next;
      Inc(linha_atual);
    end;
    objControle.EndUpdate(True);

    sql_query.Close;
    dmLotofacil.pgLTK.Close(True);
  except
    on exc: Exception do
    begin
      dmLotofacil.pgLTK.Close(True);
      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Error: ' + exc.Message;
      objControle.EndUpdate(True);
    end;
  end;

  // Verifica se realmente, houve registros.
  if qt_registros = 0 then
  begin
    sql_query.Close;
    dmlotofacil.pgLTK.Close(True);

    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 1;
    objControle.Cells[0, 0] := 'Erro, não há registros...';
    Exit;
  end;

end;



{
 Dado dois controles, por exemplo, sgr_b1_a_b1 e sgr_b1_a_b2, queremos que
 toda vez que selecionamos uma combinação do controle sgr_b1_a_b1, queremos que
 o próximo controle seja atualizado.
 Cada controle, sgr_b1_a_b1, recupera todas as combinações da tabela lotofacil_id_b1_a_b1
 e compara quantas vezes saiu na tabela lotofacil_resultado_coluna_b.
 A tabela 'lotofacil_resultado_coluna_b' armazena 120 campos, por exemplo, ele armazena
 os campos 'b1_a_b1_id' e 'b1_a_b2_id', então, quando o usuário seleciona alguma combinação
 do controle 'sgr_b1_a_b1', ele está na realidade selecionando um id do campo
 'b1_a_b1_id', então, pra atualizar o controle 'sgr_b1_a_b2' que
}
procedure Carregar_controle_bx_a_by_sem_qt_zero(objControle: TStringGrid; str_where: string);
var
  nome_sufixo, nome_dos_campos_b, nome_dos_campos_b_asc, campo_id: string;
  coluna_inicial, coluna_final, linha_atual, id_coluna, uA: integer;
  sql_query: TSQLQuery;
  qt_registros, valor_da_coluna_atual: longint;
begin

  Configurar_controle_b1_a_b15(objControle);

  nome_sufixo := '';
  coluna_inicial := 0;
  coluna_final := 0;

  if not obter_sufixo_do_nome_da_tabela(objControle, nome_sufixo,
    coluna_inicial, coluna_final) then
  begin
    MessageDlg('', 'Nome de controle inválido pra analisar colunas b1 a b15: ' +
      objControle.Name, mtError, [mbOK], 0);
    objControle.Columns.Clear;
    Exit;
  end;

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := tdmLotofacil.Create(objControle.Parent);
  end;

  sql_query := dmLotofacil.sqlLotofacil;
  sql_query.DataBase := dmLotofacil.pgLTK;
  sql_query.sql.Clear;

  {
   No código abaixo, iremos criar um sql dinâmico, semelhante a este:
   Select ltf_a.b2_a_b3_id, b2, b3, count(ltf_c.b2_a_b3_id) as qt_vezes
from (
     Select b2_a_b3_id from lotofacil.lotofacil_coluna_b
where b2_a_b2_id = 2
     group by b2_a_b3_id) ltf_a
     inner join lotofacil.lotofacil_id_b2_a_b3 ltf_b
          on ltf_a.b2_a_b3_id = ltf_b.b2_a_b3_id
     left join lotofacil.lotofacil_resultado_coluna_b ltf_c
     on ltf_b.b2_a_b3_id = ltf_c.b2_a_b3_id
group by ltf_a.b2_a_b3_id, b2, b3
order by qt_vezes desc;
  }

  {
   No sql abaixo, iremos colocar substituídores, começa por '@', depois
   iremos substituir com valores, então assim, fica mais fácil ver como o sql
   está montado.
  }
  sql_query.Sql.Add('Select ltf_a.@id_1, @campos_b, count(ltf_c.@id_1) as qt_vezes');
  sql_query.Sql.Add('from (');
  sql_query.Sql.Add('Select @id_1 from lotofacil.lotofacil_coluna_b');
  sql_query.Sql.Add(Format('where %s', [str_where]));
  sql_query.Sql.Add('and ltf_qt = 15');
  sql_query.Sql.Add('group by @id_1) ltf_a');
  sql_query.Sql.Add('inner join lotofacil.lotofacil_id_@tabela_sufixo ltf_b');
  sql_query.Sql.Add('on ltf_a.@id_1 = ltf_b.@id_1');
  sql_query.Sql.Add('left join lotofacil.lotofacil_resultado_coluna_b ltf_c');
  sql_query.SQL.Add('on ltf_b.@id_1 = ltf_c.@id_1');
  sql_query.Sql.Add('group by ltf_a.@id_1, @campos_b');
  sql_query.Sql.Add('order by qt_vezes desc, @campos_asc');

  writeln(sql_query.sql.Text);

  // Agora, iremos substituir as tags começando por @.
  nome_dos_campos_b := '';
  nome_dos_campos_b_asc := '';

  for uA := coluna_inicial to coluna_final do
  begin
    if uA <> coluna_inicial then
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format(', b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format(', b%d asc', [uA]);
    end
    else
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format('b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format('b%d asc', [uA]);
    end;
  end;

  campo_id := nome_sufixo + '_id';

  // Agora, é só substituir, as tags @id_1, @tabela_sufixo, @campos_b, @campos_asc.
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@id_1', campo_id);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@campos_b', nome_dos_campos_b);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@campos_asc',
    nome_dos_campos_b_asc);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@tabela_sufixo', nome_sufixo);

  writeln(sql_query.sql.Text);

  try
    sql_query.UniDirectional := True;
    sql_query.Open;
    sql_query.First;
    linha_atual := 1;
    objControle.Columns[0].Visible := False;

    objControle.BeginUpdate;
    qt_registros := 0;
    while not sql_query.EOF do
    begin
      Inc(qt_registros);
      objControle.RowCount := qt_registros + 1;
      id_coluna := 0;
      objControle.Cells[0, linha_atual] :=
        IntToStr(sql_query.FieldByName(nome_sufixo + '_id').AsInteger);

      // Colunas b: b1, b2, e assim por diante.
      for uA := coluna_inicial to coluna_final do
      begin
        Inc(id_coluna);
        valor_da_coluna_atual := sql_query.FieldByName('b' + IntToStr(uA)).AsInteger;
        objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);
      end;

      // Coluna qt_vezes
      Inc(id_coluna);
      valor_da_coluna_atual := sql_query.FieldByName('qt_vezes').AsInteger;
      objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);

      // Coluna marcar.
      // A valor da célula na linha e coluna marcar terá o valor 0
      // pois o estilo desta coluna é checkbox, e um valor 0, significa
      // desmarcado o checkbox.
      Inc(id_coluna);
      objControle.Cells[id_coluna, linha_atual] := '0';

      sql_query.Next;
      Inc(linha_atual);
    end;
    objControle.EndUpdate(True);

    sql_query.Close;
    dmLotofacil.pgLTK.Close(True);
  except
    on exc: Exception do
    begin
      dmLotofacil.pgLTK.Close(True);
      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Error: ' + exc.Message;
      objControle.EndUpdate(True);
    end;
  end;

  // Verifica se realmente, houve registros.
  if qt_registros = 0 then
  begin
    sql_query.Close;
    dmlotofacil.pgLTK.Close(True);

    objControle.Columns.Clear;
    objControle.Columns.Add;
    objControle.FixedRows := 1;
    objControle.Cells[0, 0] := 'Erro, não há registros...';
    Exit;
  end;

end;

{
 }
procedure Carregar_controle_b1_a_b15_por_intervalo_concurso(objControle: TStringGrid; concurso_inicial, concurso_final: integer);
var
  nome_sufixo, nome_dos_campos_b, nome_dos_campos_b_asc, nome_campo_id: string;
  coluna_inicial, coluna_final, linha_atual, id_coluna, uA: integer;
  sql_query: TSQLQuery;
  qt_registros, valor_da_coluna_atual: longint;
begin

  Configurar_controle_b1_a_b15(objControle);

  nome_sufixo := '';
  coluna_inicial := 0;
  coluna_final := 0;

  if not obter_sufixo_de_controle_por_intervalo_de_concurso(objControle, nome_sufixo,
    coluna_inicial, coluna_final) then
  begin
    MessageDlg('', 'Nome de controle inválido pra analisar colunas b1 a b15: ' +
      objControle.Name, mtError, [mbOK], 0);
    objControle.Columns.Clear;
    Exit;
  end;

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := tdmLotofacil.Create(objControle.Parent);
  end;

  sql_query := dmLotofacil.sqlLotofacil;
  sql_query.DataBase := dmLotofacil.pgLTK;
  sql_query.sql.Clear;

  sql_query.Sql.Add('Select @nome_campo_id@, @nome_campos_b@, qt_vezes from');
  sql_query.Sql.Add('lotofacil.fn_lotofacil_resultado_@tabela_nome_sufixo@');
  sql_query.Sql.Add('(@concurso_inicial@, @concurso_final@)');
  sql_query.Sql.Add('order by qt_vezes desc, @nome_campos_b_asc@');

  // Agora, vamos criar os dados que serão populados.
  nome_campo_id := nome_sufixo + '_id';

  nome_dos_campos_b := '';
  nome_dos_campos_b_asc := '';

  for uA := coluna_inicial to coluna_final do
  begin
    if uA <> coluna_inicial then
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format(', b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format(', b%d asc', [uA]);
    end
    else
    begin
      nome_dos_campos_b := nome_dos_campos_b + Format('b%d', [uA]);
      nome_dos_campos_b_asc := nome_dos_campos_b_asc + Format('b%d asc', [uA]);
    end;
  end;

  // Vamos substituir os dados.
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@nome_campo_id@',
    nome_campo_id);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@nome_campos_b@',
    nome_dos_campos_b);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@nome_campos_b_asc@',
    nome_dos_campos_b_asc);
  sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@tabela_nome_sufixo@',
    nome_sufixo);
    sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@concurso_inicial@', IntToStr(concurso_inicial));
    sql_query.Sql.Text := ReplaceText(sql_query.Sql.Text, '@concurso_final@', IntToStr(concurso_final));

    writeln(sql_query.sql.text);

  try
    sql_query.UniDirectional := False;
    sql_query.Open;

    qt_registros := 0;
    linha_atual := 1;
    sql_query.First;
    objControle.BeginUpdate;
    while not sql_query.EOF do
    begin
      Inc(qt_registros);
      objControle.RowCount := qt_registros + 1;

      id_coluna := 0;
      objControle.Cells[0, linha_atual] := IntToStr(sql_query.FieldByName(nome_sufixo + '_id').AsInteger);

      // Colunas b: b1, b2, ...
      for uA := coluna_inicial to coluna_final do
      begin
        Inc(id_coluna);
        valor_da_coluna_atual := sql_query.FieldByName('b' + IntToStr(uA)).AsInteger;
        objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);
      end;

      // Coluna qt_vezes
      Inc(id_coluna);
      valor_da_coluna_atual := sql_query.FieldByName('qt_vezes').AsInteger;
      objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);

      // Coluna marcar.
      // A valor da célula na linha e coluna marcar terá o valor 0
      // pois o estilo desta coluna é checkbox, e um valor 0, significa
      // desmarcado o checkbox.
      Inc(id_coluna);
      objControle.Cells[id_coluna, linha_atual] := '0';

      sql_query.Next;
      Inc(linha_atual);
    end;
    objControle.EndUpdate(true);
    sql_query.Close;
    dmLotofacil.pgLTK.Close(True);

    // Se não houve registros
    if qt_registros = 0 then
    begin
      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.RowCount := 1;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Nem registro localizado.';
    end;

  except
    on exc: Exception do
    begin
      dmLotofacil.pgLTK.Close(True);

      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.FixedRows := 1;
      objControle.Cells[0, 0] := 'Error: ' + exc.Message;
    end;
  end;

end;

{
 Retorna true, se o nome foi obtido corretamente, falso, caso contrário.
 No banco de dados, as tabelas ou views terminam assim:
 b1_a_b1;
 b1_a_b2
 Aqui, os controles, também, terminam com o mesmo sufixo.
 Então, cada sufixo de um controle corresponde a uma tabela/view/função que iremos
 utilizar, pra isto, criamos a função abaixo.
}
function obter_sufixo_do_nome_da_tabela(objControle: TStringGrid;
  var nome_da_tabela: string; var coluna_inicial, coluna_final: integer): boolean;
var
  nome_do_controle: TComponentName;
  numero_da_coluna_1, numero_da_coluna_2: longint;
  colunas: TStringArray;
begin
  nome_do_controle := objControle.Name;
  nome_do_controle := ReplaceText(nome_do_controle, 'sgr_', '');
  nome_da_tabela := nome_do_controle;
  nome_do_controle := ReplaceText(nome_do_controle, '_a_', '');
  colunas := nome_do_controle.Split('b', TStringSplitOptions.ExcludeEmpty);
  if Length(colunas) <> 2 then
  begin
    nome_da_tabela := '';
    Exit(False);
  end;

  try
    numero_da_coluna_1 := StrToInt(colunas[0]);
    numero_da_coluna_2 := StrToInt(colunas[1]);

    coluna_inicial := numero_da_coluna_1;
    coluna_final := numero_da_coluna_2;

    if (not (numero_da_coluna_1 in [1..15])) or (not (numero_da_coluna_1 in [1..15])) then
    begin
      nome_da_tabela := '';
      Exit(False);
    end;

    if numero_da_coluna_1 > numero_da_coluna_2 then
    begin
      nome_da_tabela := '';
      Exit(False);
    end;

  except
    On exc: Exception do
    begin
      nome_da_tabela := '';
      Exit(False);
    end;
  end;

  Exit(True);

end;

{
 Há 120 controles, toda vez que o usuário alterar o intervalo de concurso devemos
 chamar esta função pra identificar qual controle foi chamado, o objetivo desta função
 é retornar a bola inicial e final, e també
}
function obter_sufixo_de_controle_por_intervalo_de_concurso(objControle: TStringGrid;
  var nome_da_tabela: string; var coluna_inicial, coluna_final: integer): boolean;
var
  nome_do_controle: TComponentName;
  numero_da_coluna_1, numero_da_coluna_2: longint;
  colunas: TStringArray;
begin
  nome_do_controle := objControle.Name;
  nome_do_controle := ReplaceText(nome_do_controle, 'sgr_intervalo_por_concurso_', '');
  nome_da_tabela := nome_do_controle;
  nome_do_controle := ReplaceText(nome_do_controle, '_a_', '');
  colunas := nome_do_controle.Split('b', TStringSplitOptions.ExcludeEmpty);
  if Length(colunas) <> 2 then
  begin
    nome_da_tabela := '';
    Exit(False);
  end;

  try
    numero_da_coluna_1 := StrToInt(colunas[0]);
    numero_da_coluna_2 := StrToInt(colunas[1]);

    coluna_inicial := numero_da_coluna_1;
    coluna_final := numero_da_coluna_2;

    if (not (numero_da_coluna_1 in [1..15])) or (not (numero_da_coluna_1 in [1..15])) then
    begin
      nome_da_tabela := '';
      Exit(False);
    end;

    if numero_da_coluna_1 > numero_da_coluna_2 then
    begin
      nome_da_tabela := '';
      Exit(False);
    end;

  except
    On exc: Exception do
    begin
      nome_da_tabela := '';
      Exit(False);
    end;
  end;

  Exit(True);

end;



function obter_id_de_combinacoes_selecionadas(objControle: TStringGrid;
  var id_selecionados: string): boolean;
var
  linha_atual_do_controle, indice_ultima_coluna, indice_ultima_linha: integer;
  valor_da_celula_id: string;
begin
  id_selecionados := '';

  // No controle TStringGrid, a linha e coluna é baseada em zero.
  // No nosso controle, a linha 0 contém o cabeçalho do controle.
  linha_atual_do_controle := 1;
  indice_ultima_coluna := Pred(objControle.ColCount);
  indice_ultima_linha := Pred(objControle.RowCount);

  while linha_atual_do_controle <= indice_ultima_linha do
  begin
    if objControle.Cells[indice_ultima_coluna, linha_atual_do_controle] = '1' then
    begin
      if id_selecionados <> '' then
      begin
        id_selecionados := id_selecionados + ',';
      end;
      valor_da_celula_id := objControle.Cells[0, linha_atual_do_controle];
      id_selecionados := id_selecionados + objControle.Cells[0,
        linha_atual_do_controle];
    end;
    Inc(linha_atual_do_controle);
  end;
  if id_selecionados <> '' then
  begin
    Exit(True);
  end
  else
  begin
    Exit(False);
  end;
end;

end.
