program Analisador_Lotofacil;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, indylaz, datetimectrls, uLotofacilMain, uLotofacilModulo,
  uLotofacilSeletor, uGeradorAleatorio, uLotofacil_Gerador_id;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  //Application.CreateForm(TdmLotofacil, dmLotofacil);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

