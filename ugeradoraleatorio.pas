unit uGeradorAleatorio;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, sqlDb;

const
  LOTOFACIL_ULTIMO_INDICE = 6874010;

type
    { TLotofacil_Gerador_Thread }

    TLotofacil_Gerador_Thread = class(TThread)
      procedure Execute;
      private
      lotofacil_num: array of array of Integer;
      procedure Preencher_LTF_ID;
    end;



implementation


{ TLotofacil_Gerador_Thread }

procedure TLotofacil_Gerador_Thread.Execute;
begin
  // Inicia o arranjo bidimensional pra armazenar cada número.
  //
  SetLength(lotofacil_num,  LOTOFACIL_ULTIMO_INDICE + 1, 30);

end;

procedure TLotofacil_Gerador_Thread.Preencher_LTF_ID;
var
  sql_lotofacil_num: TSqlQuery;
begin
  {
  ltf_id := 0;

  for b1 := 1 to 25 do
  for b2 := b1 + 1 to 25 do
  for b3 := b2 + 1 to 25 do
  for b4 := b3 + 1 to 25 do
  for b5 := b4 + 1 to 25 do
  for b6 := b5 + 1 to 25 do
  for b7 := b6 + 1 to 25 do
  for b8 := b
  }
end;

end.

