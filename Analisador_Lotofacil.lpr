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
  Forms, indylaz, zcomponent, datetimectrls, uLotofacilMain, uLotofacilModulo,
  uLotofacilSeletor, uGeradorAleatorio, uLotofacil_Gerador_id,
  uLotofacilNovosRepetidos,
  uLotofacil_Colunas_B,
  ulotofacil_diferenca_entre_bolas,
  uLotofacilSomaFrequencia,
  ulotofacil_bolas_na_mesma_coluna, ulotofacil_b1_a_b15,
  lotofacil_constantes, lotofacil_filtros, lotofacil_var_global,
  lotofacil_gerar_filtros, lotofacil_concursos,
  lotofacil_comparacao_de_bolas_na_mesma_coluna, lotofacil_frequencia;

{$R *.res}

begin
  Application. Scaled := True;
  RequireDerivedFormResource := True;
  Application.Initialize;
  //Application.CreateForm(TdmLotofacil, dmLotofacil);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

