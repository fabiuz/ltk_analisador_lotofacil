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
      procedure Execute; override;
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
begin
end;

end.

