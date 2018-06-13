unit ulotofacil_bolas_na_mesma_coluna;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, grids;

procedure Configurar_controle_bolas_na_mesma_coluna(objControle: TStringGrid);
procedure Carregar_controle_bolas_na_mesma_coluna(objControle: TStringGrid);
function Gerar_sql_bolas_na_mesma_coluna(objControle: TStringGrid): string;


implementation
uses uLotofacilModulo, db;

function Gerar_sql_bolas_na_mesma_coluna(objControle: TStringGrid): string;
var
  ultima_coluna, ultima_linha, linha_atual: Integer;
  lista_de_id_selecionados: TStringList;
  valor_celula_campo_marcar, valor_celula_campo_id: String;
begin
  ultima_coluna := Pred(objControle.ColCount);
  ultima_linha := Pred(objControle.RowCount);
  lista_de_id_selecionados := TStringList.Create;
  lista_de_id_selecionados.Clear;

  // Percorre todas as linhas da coluna marcar pra verificar se
  // o usuário marcou alguma linha, se sim, obter o identificador que está
  // na coluna 0 da mesma linha que a coluna marcar foi selecionada.
  for linha_atual := 1 to ultima_linha do begin
    valor_celula_campo_marcar := objControle.Cells[ultima_coluna, linha_atual];
    valor_celula_campo_id := objControle.Cells[0, linha_atual];
    if valor_celula_campo_marcar = '1' then begin
      lista_de_id_selecionados.Add(valor_celula_campo_id);
    end;
  end;

  Result := '';
  if lista_de_id_selecionados.Count > 0 then begin
    lista_de_id_selecionados.Delimiter := ',' ;
    Result := 'cmp_b_id in (' + lista_de_id_selecionados.DelimitedText + ')';
  end;
end;

{
 Esta procedure configura o controle pra receber os dados do controle
 'sgrBolas_na_mesma_coluna'.
}
procedure Configurar_controle_bolas_na_mesma_coluna(objControle: TStringGrid);
const
  nome_dos_campos : array[0..5] of string = (
                  'cmp_b_id', 'qt-neg', 'qt-zero', 'qt-pos', 'qt-vz', 'marcar' );
var
  uA, indice_ultima_coluna: Integer;
  coluna_atual: TGridColumn;
begin
  objControle.Columns.Clear;

  indice_ultima_coluna := High(nome_dos_campos);
  for uA := 0 to High(nome_dos_campos) do begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := nome_dos_campos[uA];
    objControle.Cells[uA, 0] := nome_dos_campos[uA];
  end;

  // A coluna 'marcar' será uma coluna de checkBox que serve pra o usuário escolher
  // a combinação desejada.
  objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

  // Oculta a coluna com o id
  objControle.Columns[0].Visible:= false;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.RowCount :=1;
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

procedure Carregar_controle_bolas_na_mesma_coluna(objControle: TStringGrid);
const
  nome_dos_campos_na_tabela : array[0..4] of string = (
                            'cmp_b_id',
                            'qt_bolas_comuns_b1_a_b15',
                            'qt_bolas_subindo_b1_a_b15',
                            'qt_bolas_descendo_b1_a_b15',
                            'qt_vezes'
  );
var
  sql_query: TSQLQuery;
  qt_registros, valor_atual: LongInt;
  linha_atual_do_controle, linha_atual, uA, ultima_coluna,
    ultima_coluna_controle: Integer;
begin

  try
    if not Assigned(dmLotofacil) then begin
      dmLotofacil := TdmLotofacil.Create(objControle.Parent);
    end;

    sql_query := dmLotofacil.sqlLotofacil;
    sql_query.Sql.Clear;
    sql_query.Sql.Add('Select * from lotofacil.v_lotofacil_resultado_comparacao_de_bolas_na_mesma_coluna');
    sql_query.Sql.Add('order by qt_vezes desc');
    sql_query.Unidirectional := false;
    sql_query.Open;

    // Deve-se ir até o último registro pra obter o valor de recordCount corretamente.
    sql_query.First;
    sql_query.Last;

    Configurar_controle_bolas_na_mesma_coluna(objControle);

    qt_registros := sql_query.RecordCount;

    if qt_registros = 0 then begin
      objControle.RowCount := 1;
      objControle.ColCount := 1;
      objControle.FixedRows:= 1;
      objControle.Cells[0,0] := 'Não há registros.';
      Exit;
    end;

    objControle.RowCount := qt_registros + 1;

    // Iremos popular os dados
    // Observe que na condição abaixo da sentença where colocamos também a quantidade
    // de registros pois pode acontecer da quantidade de registros ser maior após
    // consultarmos o banco de dados.
    sql_query.First;
    linha_atual_do_controle := 1;
    ultima_coluna := High(nome_dos_campos_na_tabela);
    while (not sql_query.Eof) and (qt_registros > 0) do
    begin

      for uA := 0 to ultima_coluna do
      begin
        valor_atual := sql_query.FieldByName(nome_dos_campos_na_tabela[uA]).AsInteger;
        objControle.Cells[uA, linha_atual_do_controle] := IntToStr(valor_atual);
      end;

      // Iremos colocar o valor '0' zero em cada linha da coluna marcar
      // pois assim, o checkbox desta coluna estará desmarcado.
      ultima_coluna_controle := Pred(objControle.ColCount);
      objControle.Cells[ultima_coluna_controle, linha_atual_do_controle] := '0';

      sql_query.Next;
      Inc(linha_atual_do_controle);
      Dec(qt_registros);
    end;
    objControle.AutoSizeColumns;

    sql_query.Close;
  except
    On exc: EDataBaseError do begin
      objControle.RowCount := 1;
      objControle.ColCount := 1;
      objControle.FixedRows:= 1;
      objControle.Cells[0,0] := 'Erro: ' + Exc.Message;
      dmLotofacil.pgLTK.Close(true);
      Exit;
    end;
  end;
end;

end.

