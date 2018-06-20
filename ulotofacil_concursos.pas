unit ulotofacil_concursos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb;

function Obter_todos_os_concursos(var lista_de_concursos: TStringList): boolean;

implementation
uses
  uLotofacilModulo;

{
 Retorna true, se obter pelo menos um concurso, falso caso contrário.
}
function Obter_todos_os_concursos(var lista_de_concursos: TStringList): boolean;
var
  sql_query: TSQLQuery;
begin

  if Not Assigned(lista_de_concursos) then begin
    lista_de_concursos := TStringList.Create;
  end;
  lista_de_concursos.Clear;

  if Not Assigned(dmLotofacil) then begin
    dmLotofacil := TdmLotofacil.Create(nil);
  end;

  try
    sql_query := dmLotofacil.sqlLotofacil;
    sql_query.DataBase := dmLotofacil.pgLTK;
    sql_query.UniDirectional:= false;
    sql_query.Sql.Clear;

    sql_query.Sql.Add('Select concurso from lotofacil.v_lotofacil_concursos');
    sql_query.Sql.Add('order by concurso');

    sql_query.Open;
    sql_query.First;
    while not sql_query.Eof do begin
        lista_de_concursos.Add(IntToStr(sql_query.FieldByName('concurso').AsInteger));
        sql_query.Next;
    end;
    sql_query.Close;

  except
    On Exc: Exception do begin
      lista_de_concursos.Clear;
      FreeAndNil(lista_de_concursos);
      Exit(False);
    end;
  end;

  FreeAndNil(dmLotofacil);

  if lista_de_concursos.Count <> 0 then begin
    Exit(True);
  end;
end;

end.

