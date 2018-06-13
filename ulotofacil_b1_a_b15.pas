unit ulotofacil_b1_a_b15;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, grids;

procedure Configurar_controle_b1_a_b15(objControle: TStringGrid);
procedure Carregar_controle_b1_a_b15(objControle: TStringGrid);
function obter_sufixo_do_nome_da_tabela(objControle: TStringGrid;
  var nome_da_tabela: string; var coluna_inicial, coluna_final: Integer): boolean;
//function gerar_sql_b1_a_b15: string;

implementation
uses
  RegExpr, strUtils, dialogs,
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
  bola_final, bola_inicial: Integer;
  nome_do_controle: TComponentName;
  nome_valido: TRegExpr;
  colunas: TStringArray;
  coluna_inicial, coluna_final, uA: LongInt;
  coluna_atual: TGridColumn;
begin
  bola_inicial := 0;
  bola_final := 0;

  // Verifica se começa com 'sgr_'
  nome_do_controle := objControle.Name;
  if not AnsiStartsText('sgr_', nome_do_controle) then begin
    Exit;
  end;
  nome_do_controle := ReplaceText(nome_do_controle, 'sgr_', '');

  // Fica algo assim:
  // b1_a_b15
  // Retira o _a_
  nome_do_controle := ReplaceText(nome_do_controle, '_a_', '');

  // Não irei usar expressão regular aqui, irei separar em um arranjo.
  colunas := nome_do_controle.Split('b', TStringSplitOptions.ExcludeEmpty);

  if Length(colunas) <> 2 then begin
    Exit;
  end;

  try
    coluna_inicial := StrToInt(colunas[0]);
    coluna_final := StrToInt(colunas[1]);

    if coluna_inicial > coluna_final then begin
      MessageDlg('', 'Controle ' + nome_do_controle + ' está com nome incorreto.', mtError, [mbok], 0);
      Exit;
    end;

  except
    On exc: Exception do begin
      Exit;
    end;
  end;

  // Vamos criar as colunas do controle
  // Primeira coluna, grp_id
  objControle.Columns.Clear;
  coluna_atual := objControle.Columns.Add;
  coluna_atual.Alignment:= taCenter;
  coluna_atual.Title.Caption := 'grp_id';
  coluna_atual.Title.Alignment := taCenter;

  // As colunas onde ficarão as bolas.
  for uA := coluna_inicial to coluna_final do begin
      coluna_atual := objControle.Columns.Add;
      coluna_atual.Alignment := taCenter;
      coluna_atual.Title.Caption := 'b_' + IntToStr(uA);
      coluna_atual.Title.Alignment := taCenter;
  end;

  // A coluna qt_vezes
  coluna_atual := objControle.Columns.Add;
  coluna_atual.Alignment:= taCenter;
  coluna_atual.Title.Caption := 'qt_vz';
  coluna_atual.Title.Alignment := taCenter;

  // A coluna 'marcar'.
  coluna_atual := objControle.Columns.Add;
  coluna_atual.Alignment:= taCenter;
  coluna_atual.Title.Caption := 'Marcar';
  coluna_atual.Title.Alignment := taCenter;
  coluna_atual.ButtonStyle:= cbsCheckboxColumn ;

  objControle.FixedRows:=1;
  objControle.AutoSizeColumns;
  objControle.RowCount:=1;
end;

procedure Carregar_controle_b1_a_b15(objControle: TStringGrid);
var
  nome_sufixo: String;
  coluna_inicial, coluna_final, linha_atual, id_coluna, uA: Integer;
  sql_query: TSQLQuery;
  qt_registros, valor_da_coluna_atual: LongInt;
begin

  Configurar_controle_b1_a_b15(objControle);

  nome_sufixo := '';
  coluna_inicial := 0;
  coluna_final := 0;

  if not obter_sufixo_do_nome_da_tabela(objControle, nome_sufixo, coluna_inicial, coluna_final) then begin
     MessageDlg('', 'Nome de controle inválido pra analisar colunas b1 a b15: ' +
                    objControle.Name, mtError, [mbok], 0);
     objControle.Columns.Clear;
     Exit;
  end;

  if not Assigned(dmLotofacil) then begin
     dmLotofacil := tdmLotofacil.Create(objControle.Parent);
  end;

  sql_query := dmLotofacil.sqlLotofacil;
  sql_query.DataBase := dmLotofacil.pgLTK;
  sql_query.sql.Clear;

  sql_query.sql.Add('Select grp_id');

  for uA := coluna_inicial to coluna_final do begin
      sql_query.sql.Add(', b' + IntToStr(uA));
  end;

  sql_query.SQL.Add(', qt_vezes');
  sql_query.Sql.Add('from lotofacil.v_lotofacil_resultado_' + nome_sufixo);
  sql_query.sql.Add('order by qt_vezes desc');

  // Indica as colunas ordenadas
  for uA := coluna_inicial to coluna_final do begin
      sql_query.sql.Add(', b' + IntToStr(uA) + ' asc');
  end;

  try
    sql_query.UniDirectional:= false;
    sql_query.open;

    sql_query.first;
    sql_query.Last;

    qt_registros := sql_query.recordcount;

    if qt_registros = 0 then begin
       sql_query.Close;
       dmlotofacil.pgLTK.Close(true);

       objControle.Columns.Clear;
       objControle.Columns.Add;
       objControle.FixedRows:= 1;
       objControle.Cells[0,0] := 'Error, não há registros...';
       Exit;
    end;

    objControle.RowCount:= qt_registros + 1;

    // Oculta a primeira coluna.
    objControle.Columns[0].Visible:= false;

    linha_atual := 1;
    sql_query.First;
    while (not sql_query.EOF) or (qt_registros <> 0) do begin
        id_coluna := 0;
        objControle.Cells[0, linha_atual] := IntToStr(sql_query.FieldByName('grp_id').AsInteger);
        // Pega a bola das colunas
        for uA := coluna_inicial to coluna_final do begin
            Inc(id_coluna);
            valor_da_coluna_atual := sql_query.FieldByName('b' + IntToStr(uA)).AsInteger;
            objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);
        end;

        // Coluna qt_vezes
        Inc(id_coluna);
        valor_da_coluna_atual:= sql_query.FieldByName('qt_vezes').AsInteger;
        objControle.Cells[id_coluna, linha_atual] := IntToStr(valor_da_coluna_atual);

        // Coluna marcar.
        // A valor da célula na linha e coluna marcar terá o valor 0
        // pois o estilo desta coluna é checkbox, e um valor 0, significa
        // desmarcado o checkbox.
        Inc(id_coluna);
        objControle.Cells[id_coluna, linha_atual] := '0';

        sql_query.Next;
        dec(qt_registros);
        Inc(linha_atual);
    end;

    sql_query.Close;
    dmLotofacil.pgLTK.Close(true);
  except
    on exc: Exception do begin
        dmLotofacil.pgLTK.Close(true);

        objControle.Columns.Clear;
        objControle.Columns.Add;
        objControle.FixedRows:= 1;
        objControle.Cells[0,0] := 'Error: ' + exc.Message;
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
  var nome_da_tabela: string; var coluna_inicial, coluna_final: Integer): boolean;
var
  nome_do_controle: TComponentName;
  numero_da_coluna_1, numero_da_coluna_2: LongInt;
  colunas: TStringArray;
begin
  nome_do_controle := objControle.Name;
  nome_do_controle:= ReplaceText(nome_do_controle, 'sgr_', '');
  nome_da_tabela:= nome_do_controle;
  nome_do_controle:= ReplaceText(nome_do_controle, '_a_', '');
  colunas := nome_do_controle.Split('b', TStringSplitOptions.ExcludeEmpty);
  if Length(colunas) <> 2 then begin
    nome_da_tabela:='';
    Exit(False);
  end;

  try
    numero_da_coluna_1 := StrToInt(colunas[0]);
    numero_da_coluna_2 := StrToInt(colunas[1]);

    coluna_inicial := numero_da_coluna_1;
    coluna_final := numero_da_coluna_2;

    if (not(numero_da_coluna_1 in [1..15])) or (not(numero_da_coluna_1 in [1..15])) then begin
      nome_da_tabela:='';
      Exit(False);
    end;

    if numero_da_coluna_1 > numero_da_coluna_2 then begin
      nome_da_tabela := '';
      Exit(False);
    end;

  except
    On exc: Exception do begin
        nome_da_tabela:='';
        Exit(False);
    end;
  end;

  Exit(true);

end;




end.

