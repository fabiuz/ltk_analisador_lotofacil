program Analisador_Lotofacil;

{$mode objfpc}{$H+}

uses
  {$IFDEF LINUX}
          {$IFDEF UseCThreads}
                  cthreads,
                  cmem,
          {$ENDIF}
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, indylaz, datetimectrls, uLotofacilMain, uLotofacilModulo,
  uLotofacilSeletor, uGeradorAleatorio, uLotofacil_Gerador_id,
  ulotofacil_bolas_arquivo, uLotofacilNovosRepetidos, uLotofacilParImpar,
  ulotofacilExternoInterno, uLotofacilPrimoNaoPrimo, uLotofacil_Colunas_B,
  ulotofacil_diferenca_entre_bolas, ulotofacil_grupos, ulotofacil_funcoes_uteis,
  ulotofacil_algarismo_nas_dezenas, uLotofacilSomaFrequencia,
  ulotofacil_bolas_na_mesma_coluna, ulotofacil_b1_a_b15, ulotofacil_concursos;

{$R *.res}

begin
  Application. Scaled := True;
  RequireDerivedFormResource := True;
  Application.Initialize;
  //Application.CreateForm(TdmLotofacil, dmLotofacil);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

