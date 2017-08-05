unit uLotofacilMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DBGrids, uLotofacilModulo, DB,
  BufDataset, sqlDb, Grids, strings, strUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnGrupo2BolasDesmarcarTodos1 : TButton;
    btnGrupo2BolasDesmarcarTodos10 : TButton;
    btnGrupo2BolasDesmarcarTodos11 : TButton;
    btnGrupo2BolasDesmarcarTodos12 : TButton;
    btnGrupo2BolasDesmarcarTodos13 : TButton;
    btnGrupo2BolasDesmarcarTodos14 : TButton;
    btnGrupo2BolasDesmarcarTodos15 : TButton;
    btnGrupo2BolasDesmarcarTodos16 : TButton;
    btnGrupo2BolasDesmarcarTodos17 : TButton;
    btnGrupo2BolasDesmarcarTodos18 : TButton;
    btnGrupo2BolasDesmarcarTodos19 : TButton;
    btnGrupo2BolasDesmarcarTodos2 : TButton;
    btnGrupo2BolasDesmarcarTodos20 : TButton;
    btnGrupo2BolasDesmarcarTodos21 : TButton;
    btnGrupo2BolasDesmarcarTodos22 : TButton;
    btnGrupo2BolasDesmarcarTodos23 : TButton;
    btnGrupo2BolasDesmarcarTodos24 : TButton;
    btnGrupo2BolasDesmarcarTodos25 : TButton;
    btnGrupo2BolasDesmarcarTodos26 : TButton;
    btnGrupo2BolasDesmarcarTodos27 : TButton;
    btnGrupo2BolasDesmarcarTodos28 : TButton;
    btnGrupo2BolasDesmarcarTodos29 : TButton;
    btnGrupo2BolasDesmarcarTodos3 : TButton;
    btnGrupo2BolasDesmarcarTodos30 : TButton;
    btnGrupo2BolasDesmarcarTodos31 : TButton;
    btnGrupo2BolasDesmarcarTodos32 : TButton;
    btnGrupo2BolasDesmarcarTodos33 : TButton;
    btnGrupo2BolasDesmarcarTodos34 : TButton;
    btnGrupo2BolasDesmarcarTodos35 : TButton;
    btnGrupo2BolasDesmarcarTodos4 : TButton;
    btnGrupo2BolasDesmarcarTodos5 : TButton;
    btnGrupo2BolasDesmarcarTodos6 : TButton;
    btnGrupo2BolasDesmarcarTodos7 : TButton;
    btnGrupo2BolasDesmarcarTodos8 : TButton;
    btnGrupo2BolasDesmarcarTodos9 : TButton;
    btnGrupo2BolasMarcarTodos1 : TButton;
    btnGrupo2BolasMarcarTodos10 : TButton;
    btnGrupo2BolasMarcarTodos11 : TButton;
    btnGrupo2BolasMarcarTodos12 : TButton;
    btnGrupo2BolasMarcarTodos13 : TButton;
    btnGrupo2BolasMarcarTodos14 : TButton;
    btnGrupo2BolasMarcarTodos15 : TButton;
    btnGrupo2BolasMarcarTodos16 : TButton;
    btnGrupo2BolasMarcarTodos17 : TButton;
    btnGrupo2BolasMarcarTodos18 : TButton;
    btnGrupo2BolasMarcarTodos19 : TButton;
    btnGrupo2BolasMarcarTodos2 : TButton;
    btnGrupo2BolasMarcarTodos20 : TButton;
    btnGrupo2BolasMarcarTodos21 : TButton;
    btnGrupo2BolasMarcarTodos22 : TButton;
    btnGrupo2BolasMarcarTodos23 : TButton;
    btnGrupo2BolasMarcarTodos24 : TButton;
    btnGrupo2BolasMarcarTodos25 : TButton;
    btnGrupo2BolasMarcarTodos26 : TButton;
    btnGrupo2BolasMarcarTodos27 : TButton;
    btnGrupo2BolasMarcarTodos28 : TButton;
    btnGrupo2BolasMarcarTodos29 : TButton;
    btnGrupo2BolasMarcarTodos3 : TButton;
    btnGrupo2BolasMarcarTodos30 : TButton;
    btnGrupo2BolasMarcarTodos31 : TButton;
    btnGrupo2BolasMarcarTodos32 : TButton;
    btnGrupo2BolasMarcarTodos33 : TButton;
    btnGrupo2BolasMarcarTodos34 : TButton;
    btnGrupo2BolasMarcarTodos35 : TButton;
    btnGrupo2BolasMarcarTodos4 : TButton;
    btnGrupo2BolasMarcarTodos5 : TButton;
    btnGrupo2BolasMarcarTodos6 : TButton;
    btnGrupo2BolasMarcarTodos7 : TButton;
    btnGrupo2BolasMarcarTodos8 : TButton;
    btnGrupo2BolasMarcarTodos9 : TButton;
    btnLotofacilResultadoExcluir : TButton;
    btnLotofacilResultadoInserir : TButton;
    btnLotofacilResultadoAtualizar : TButton;
    btnFiltroGerar : TButton;
    btnGrupo2BolasDesmarcarTodos : TButton;
    btnGrupo2BolasMarcarTodos : TButton;
    cmbConcursoNovosRepetidos : TComboBox;
    cmbFrequenciaInicio : TComboBox;
    cmbFrequenciaFim : TComboBox;
    cmbConcursoDeletar : TComboBox;
    dtpConcursoData : TDateTimePicker;
    grGrupo3Bolas : TGroupBox;
    grGrupo2Bolas1 : TGroupBox;
    grGrupo4Bolas : TGroupBox;
    grGrupo5Bolas : TGroupBox;
    grConcursoData : TGroupBox;
    GroupBox2 : TGroupBox;
    GroupBox3 : TGroupBox;
    GroupBox4 : TGroupBox;
    grpDiagonal15Bolas : TGroupBox;
    grpDiagonal16Bolas : TGroupBox;
    grpDiagonal17Bolas : TGroupBox;
    grpDiagonal18Bolas : TGroupBox;
    grpFrequenciaInicio : TGroupBox;
    grpBolasB1_16Bolas : TGroupBox;
    grpBolasB1_17Bolas : TGroupBox;
    grpBolasB1_15Bolas3 : TGroupBox;
    grpBolasFixas15Bolas : TGroupBox;
    grpBolasB1_15Bolas : TGroupBox;
    grpColunaB1_B15_15Bolas : TGroupBox;
    grpColunaB1_B15_16Bolas : TGroupBox;
    grpColunaB1_B15_17Bolas : TGroupBox;
    grpColunaB1_B15_15Bolas3 : TGroupBox;
    grpColunaB1_B4_B8_B12_B15_16Bolas : TGroupBox;
    grpColunaB1_B4_B8_B12_B15_17Bolas : TGroupBox;
    grpColunaB1_B4_B8_B12_B15_15Bolas3 : TGroupBox;
    grpColunaB1_B8_B15_15Bolas : TGroupBox;
    grpBolasFixas18Bolas : TGroupBox;
    grpBolasFixas17Bolas : TGroupBox;
    grpBolasFixas16Bolas : TGroupBox;
    grpColunaB1_B4_B8_B12_B15_15Bolas : TGroupBox;
    grpColunaB1_B8_B15_16Bolas : TGroupBox;
    grpColunaB1_B8_B15_17Bolas : TGroupBox;
    grpColunaB1_B8_B15_15Bolas3 : TGroupBox;
    grpExternoInterno15Bolas2 : TGroupBox;
    grpExternoInterno15Bolas3 : TGroupBox;
    grpExternoInterno16Bolas2 : TGroupBox;
    grpExternoInterno16Bolas3 : TGroupBox;
    grpExternoInterno17Bolas2 : TGroupBox;
    grpExternoInterno17Bolas3 : TGroupBox;
    grpExternoInterno18Bolas2 : TGroupBox;
    grpExternoInterno18Bolas3 : TGroupBox;
    grpFrequenciaFim : TGroupBox;
    grpFrequenciaInicio1 : TGroupBox;
    grpNovosRepetidos16Bolas1 : TGroupBox;
    grpExternoInterno16Bolas : TGroupBox;
    grpNovosRepetidos17Bolas1 : TGroupBox;
    grpExternoInterno17Bolas : TGroupBox;
    grpNovosRepetidos18Bolas : TGroupBox;
    grpNovosRepetidos17Bolas : TGroupBox;
    grpNovosRepetidos18Bolas1 : TGroupBox;
    GroupBox1: TGroupBox;
    grpNovosRepetidos15Bolas: TGroupBox;
    grpNovosRepetidos16Bolas: TGroupBox;
    grpExternoInterno18Bolas : TGroupBox;
    grpParImpar15Bolas : TGroupBox;
    grpExternoInterno15Bolas : TGroupBox;
    edConcurso : TLabeledEdit;
    edFiltroConcursoDestino : TLabeledEdit;
    mmFiltroSql : TMemo;
    PageControl1: TPageControl;
    pageFiltros: TPageControl;
    PageControl3 : TPageControl;
    Panel1 : TPanel;
    Panel2 : TPanel;
    pnGrupo2Bolas : TPanel;
    pn1a5 : TPanel;
    pn1a6 : TPanel;
    pn1a7 : TPanel;
    pn1a8 : TPanel;
    pn1a9 : TPanel;
    pnDiagonal : TPanel;
    pnGrupo2Bolas1 : TPanel;
    pnGrupo2Bolas10 : TPanel;
    pnGrupo2Bolas11 : TPanel;
    pnGrupo2Bolas12 : TPanel;
    pnGrupo2Bolas13 : TPanel;
    pnGrupo2Bolas14 : TPanel;
    pnGrupo2Bolas15 : TPanel;
    pnGrupo2Bolas16 : TPanel;
    pnGrupo2Bolas17 : TPanel;
    pnGrupo2Bolas18 : TPanel;
    pnGrupo2Bolas19 : TPanel;
    pnGrupo2Bolas2 : TPanel;
    pnGrupo2Bolas20 : TPanel;
    pnGrupo2Bolas21 : TPanel;
    pnGrupo2Bolas22 : TPanel;
    pnGrupo2Bolas23 : TPanel;
    pnGrupo2Bolas24 : TPanel;
    pnGrupo2Bolas25 : TPanel;
    pnGrupo2Bolas26 : TPanel;
    pnGrupo2Bolas27 : TPanel;
    pnGrupo2Bolas28 : TPanel;
    pnGrupo2Bolas29 : TPanel;
    pnGrupo2Bolas3 : TPanel;
    pnGrupo2Bolas30 : TPanel;
    pnGrupo2Bolas31 : TPanel;
    pnGrupo2Bolas32 : TPanel;
    pnGrupo2Bolas33 : TPanel;
    pnGrupo2Bolas34 : TPanel;
    pnGrupo2Bolas35 : TPanel;
    pnGrupo2Bolas4 : TPanel;
    pnGrupo2Bolas5 : TPanel;
    pnGrupo2Bolas6 : TPanel;
    pnGrupo2Bolas7 : TPanel;
    pnGrupo2Bolas8 : TPanel;
    pnGrupo2Bolas9 : TPanel;
    sgrBolasDevemSair : TStringGrid;
    sgrGrupo3Bolas : TStringGrid;
    sgrColunaB1_15Bolas : TStringGrid;
    sgrColunaB1_16Bolas : TStringGrid;
    sgrColunaB1_17Bolas : TStringGrid;
    sgrColunaB1_18Bolas : TStringGrid;
    sgrColunaB1_B15_15Bolas : TStringGrid;
    sgrColunaB1_B15_16Bolas : TStringGrid;
    sgrColunaB1_B15_17Bolas : TStringGrid;
    sgrColunaB1_B15_18Bolas : TStringGrid;
    sgrColunaB1_B4_B8_B12_B15_16Bolas : TStringGrid;
    sgrColunaB1_B4_B8_B12_B15_17Bolas : TStringGrid;
    sgrColunaB1_B4_B8_B12_B15_18Bolas : TStringGrid;
    sgrColunaB1_B8_B15_15Bolas : TStringGrid;
    sgrBolasFixas18Bolas : TStringGrid;
    sgrBolasFixas17Bolas : TStringGrid;
    sgrBolasNaoDevemSair : TStringGrid;
    sgrColunaB1_B4_B8_B12_B15_15Bolas : TStringGrid;
    sgrColunaB1_B8_B15_16Bolas : TStringGrid;
    sgrColunaB1_B8_B15_17Bolas : TStringGrid;
    sgrColunaB1_B8_B15_18Bolas : TStringGrid;
    sgrDiagonal15Bolas : TStringGrid;
    sgrDiagonal16Bolas : TStringGrid;
    sgrDiagonal17Bolas : TStringGrid;
    sgrDiagonal18Bolas : TStringGrid;
    sgrExternoInterno15Bolas2 : TStringGrid;
    sgrExternoInterno15Bolas3 : TStringGrid;
    sgrExternoInterno16Bolas2 : TStringGrid;
    sgrExternoInterno16Bolas3 : TStringGrid;
    sgrExternoInterno17Bolas2 : TStringGrid;
    sgrExternoInterno17Bolas3 : TStringGrid;
    sgrExternoInterno18Bolas2 : TStringGrid;
    sgrExternoInterno18Bolas3 : TStringGrid;
    sgrGrupo2Bolas : TStringGrid;
    sgrGrupo4Bolas : TStringGrid;
    sgrGrupo5Bolas : TStringGrid;
    sgrNovosRepetidos15Bolas: TStringGrid;
    sgrParImpar15Bolas : TStringGrid;
    sgrNovosRepetidos16Bolas: TStringGrid;
    sgrExternoInterno15Bolas : TStringGrid;
    sgrParImpar16Bolas : TStringGrid;
    sgrExternoInterno16Bolas : TStringGrid;
    sgrParImpar17Bolas : TStringGrid;
    sgrNovosRepetidos18Bolas : TStringGrid;
    sgrNovosRepetidos17Bolas : TStringGrid;
    sgrExternoInterno17Bolas : TStringGrid;
    sgrParImpar18Bolas : TStringGrid;
    sgrExternoInterno18Bolas : TStringGrid;
    sgrFrequencia : TStringGrid;
    sheetFiltro: TTabSheet;
    tabBolasNasColunas: TTabSheet;
    tabHorizontal: TTabSheet;
    tabBolasNasColunas18Bolas : TTabSheet;
    tabFrequencia: TTabSheet;
    tabConcurso: TTabSheet;
    tabGrupos : TTabSheet;
    TabSheet1 : TTabSheet;
    tabGerarFiltros : TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    tabParImpar: TTabSheet;
    tabExternoInterno: TTabSheet;
    tabBolas: TTabSheet;
    tabBolasNasColunas15Bolas : TTabSheet;
    tabBolasNasColunas16Bolas : TTabSheet;
    tabBolasNasColunas17Bolas : TTabSheet;
    tabDiagonal : TTabSheet;
    tabVertical : TTabSheet;
    tg1 : TToggleBox;
    tg10 : TToggleBox;
    tg11 : TToggleBox;
    tg12 : TToggleBox;
    tg13 : TToggleBox;
    tg14 : TToggleBox;
    tg15 : TToggleBox;
    tg16 : TToggleBox;
    tg17 : TToggleBox;
    tg18 : TToggleBox;
    tg19 : TToggleBox;
    tg2 : TToggleBox;
    tg20 : TToggleBox;
    tg21 : TToggleBox;
    tg22 : TToggleBox;
    tg23 : TToggleBox;
    tg24 : TToggleBox;
    tg25 : TToggleBox;
    tg3 : TToggleBox;
    tg4 : TToggleBox;
    tg5 : TToggleBox;
    tg6 : TToggleBox;
    tg7 : TToggleBox;
    tg8 : TToggleBox;
    tg9 : TToggleBox;
    procedure btnFiltroGerarClick(Sender : TObject);
    procedure btnGrupo2BolasMarcarTodosClick(Sender : TObject);
    procedure btnLotofacilResultadoExcluirClick(Sender : TObject);
    procedure btnLotofacilResultadoInserirClick(Sender : TObject);
    procedure btnGrupo2BolasDesmarcarTodosClick(Sender : TObject);
    procedure cmbFrequenciaFimChange(Sender : TObject);
    procedure cmbFrequenciaInicioChange(Sender : TObject);
    procedure edConcursoKeyDown(Sender : TObject; var Key : Word;
      Shift : TShiftState);
    procedure edConcursoKeyPress(Sender : TObject; var Key : char);
    procedure FormCreate(Sender: TObject);
    procedure grpDiagonal15BolasResize(Sender : TObject);
    procedure pageFiltrosChange(Sender : TObject);
    procedure pageFiltrosResize(Sender : TObject);
    procedure pnDiagonalResize(Sender : TObject);
    procedure sgrColunaB1_15BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_16BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_17BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_18BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B15_15BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B15_16BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B15_17BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B15_18BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_15BolasSelectCell(Sender : TObject;
      aCol, aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_16BolasSelectCell(Sender : TObject;
      aCol, aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_17BolasSelectCell(Sender : TObject;
      aCol, aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_18BolasSelectCell(Sender : TObject;
      aCol, aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B8_B15_15BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B8_B15_16BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B8_B15_17BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B8_B15_18BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrExternoInterno15BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrExternoInterno16BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrExternoInterno17BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrExternoInterno18BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrFrequenciaDrawCell(Sender : TObject; aCol, aRow : Integer;
      aRect : TRect; aState : TGridDrawState);
    procedure sgrGrupo2BolasSelectCell(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure sgrGrupo3BolasSelectCell(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure sgrGrupo4BolasSelectCell(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure sgrGrupo5BolasSelectCell(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure sgrNovosRepetidos15BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrNovosRepetidos16BolasButtonClick(Sender : TObject; aCol,
      aRow : Integer);

    procedure sgrNovosRepetidos16BolasClick(Sender : TObject);
    procedure sgrNovosRepetidos16BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrNovosRepetidos17BolasClick(Sender : TObject);
    procedure sgrParImpar15BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrParImpar16BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrParImpar17BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure sgrParImpar18BolasSelectCell(Sender : TObject; aCol,
      aRow : Integer; var CanSelect : Boolean);
    procedure tabDiagonalResize(Sender : TObject);
    procedure sheetFiltroResize(Sender : TObject);
    procedure tgBolaChange(Sender : TObject);
  private
    procedure AlterarMarcador(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure AtualizarColuna_B(objControle : TStringGrid);
    procedure AtualizarControleGrupo(objControle : TStringGrid);
    procedure AtualizarFrequencia;
    procedure CarregarColuna_B(objControle : TStringGrid; strSql : string);
    procedure CarregarColuna_B;
    procedure CarregarControlesTG;
    procedure CarregarDiagonal;
    procedure CarregarDiagonal(objControle : TStringGrid);
    procedure CarregarFrequencia;
    procedure CarregarFrequencia(strSqlWhere : string);
    procedure CarregarGrupo2Bolas;
    procedure CarregarGrupo3Bolas(strSqlWhere : string);
    procedure CarregarGrupo4Bolas(strSqlWhere : string);
    procedure CarregarGrupo5Bolas(strSqlWhere : string);
    procedure CarregarTodosControles;
    procedure ConfigurarControleGrupo2Bolas;
    procedure ConfigurarControleDiagonal(objControle : TStringGrid);
    procedure ConfigurarControleFrequencia;
    procedure ConfigurarControleFrequenciaCombinacao;
    procedure ConfigurarControleGrupo3Bolas;
    procedure ConfigurarControleGrupo4Bolas;
    procedure ConfigurarControleGrupo5Bolas;
    procedure ConfigurarControlesBolas_B;
    procedure CarregarExternoInterno;
    procedure CarregarExternoInterno(objControle : TStringGrid);
    procedure CarregarNovosRepetidos;
    procedure CarregarNovosRepetidos(objControle : TStringGrid);
    procedure CarregarNovosRepetidosConcurso;
    procedure CarregarParImpar;
    procedure CarregarParImpar(objControle : TStringGrid);
    procedure ConfigurarControlesBolas_B(objControle : TStringGrid);
    procedure ConfigurarControlesParImpar(objControle : TStringGrid);
    procedure ConfigurarControlesNovosRepetidos(objControle : TStringGrid);
    procedure ConfigurarControlesExternoInterno(objControle : TStringGrid);
    procedure GerarSqlColuna_B(objControle : TStringGrid);
    procedure GerarSqlGrupo(sqlGrupo : TStringList);
    procedure MarcarGrupo2Bolas;
    procedure RedimensionarControleDiagonal;
    //procedure tgBolaChange(Sender : TObject);
    { private declarations }
  public
    { public declarations }

  private
    { private declarations }
    { Este arranjo é utiliza na guia Concurso para poder utilizar nos controles
      que começa com tg1 a tg25
    }
    lotofacil_numeros_escolhidos: array[1..25] of Integer;
    lotofacil_resultado_botoes: array[1..25] of TToggleBox;
    lotofacil_qt_bolas_escolhidas : integer;
  end;

var
  Form1: TForm1;

implementation

var
  dmLotofacil: TdmLotofacil;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     CarregarTodosControles;
end;

procedure TForm1.CarregarTodosControles;
begin
  CarregarNovosRepetidos;
  CarregarParImpar;
  CarregarExternoInterno;
  CarregarColuna_B;
  CarregarFrequencia;
  CarregarDiagonal;
  CarregarGrupo2Bolas;
  CarregarControlesTG;
end;

{
 Carrega os controles tg1 até tg25
 }
procedure TForm1.CarregarControlesTG;
begin
  lotofacil_resultado_botoes[1] := tg1;
  lotofacil_resultado_botoes[2] := tg2;
  lotofacil_resultado_botoes[3] := tg3;
  lotofacil_resultado_botoes[4] := tg4;
  lotofacil_resultado_botoes[5] := tg5;
  lotofacil_resultado_botoes[6] := tg6;
  lotofacil_resultado_botoes[7] := tg7;
  lotofacil_resultado_botoes[8] := tg8;
  lotofacil_resultado_botoes[9] := tg9;
  lotofacil_resultado_botoes[10] := tg10;
  lotofacil_resultado_botoes[11] := tg11;
  lotofacil_resultado_botoes[12] := tg12;
  lotofacil_resultado_botoes[13] := tg13;
  lotofacil_resultado_botoes[14] := tg14;
  lotofacil_resultado_botoes[15] := tg15;
  lotofacil_resultado_botoes[16] := tg16;
  lotofacil_resultado_botoes[17] := tg17;
  lotofacil_resultado_botoes[18] := tg18;
  lotofacil_resultado_botoes[19] := tg19;
  lotofacil_resultado_botoes[20] := tg20;
  lotofacil_resultado_botoes[21] := tg21;
  lotofacil_resultado_botoes[22] := tg22;
  lotofacil_resultado_botoes[23] := tg23;
  lotofacil_resultado_botoes[24] := tg24;
  lotofacil_resultado_botoes[25] := tg25;

  // Desativa os controles para evitar inserção de dados no banco
  // de forma indevida, será ativado quando atingir 15 números selecionados
  // ou será desativado se houver menos de 15 números.
  edConcurso.Enabled := false;
  grConcursoData.Enabled := false;
  btnLotofacilResultadoInserir.Enabled := false;
  btnLotofacilResultadoAtualizar.Enabled := false;
  dtpConcursoData.Enabled := false;
end;

{
 Quando um dos controles tg1 a tg25, for clicado, o procedimento abaixo é chamado.
 Este procedimento verificará se a quantidade de controles ativados é igual a
 15, pois podemos selecionar somente 15 bolas, em um concurso.
 Se há menos de 15 bolas selecionadas, todos os controles são ativados.
 Então, ao ativar 15 bolas selecionadas, todos os controles não selecionados
 serão desativados, se vc quiser acessar algum controle desativado, vc precisa
 desselecionar algum controle já selecionado para que os demais controles tornem-se
 ativados.
 }


procedure TForm1.tgBolaChange(Sender : TObject);
var
  botaoAtual: TToggleBox;
  nomeControle: string;
  idControle , uA: Integer;
  strStatusLotofacil: string;
begin
  botaoAtual := TToggleBox(Sender);
  if not (botaoAtual is TToggleBox) then
     exit;

  // Verifica se começa com 'tg'
  nomeControle := UpCase(botaoAtual.Name);
  if ansiLeftStr(nomeControle, 2) <> 'TG' then
     exit;

  nomeControle := StrUtils.AnsiMidStr(nomeControle, 3, Length(nomeControle));
  try
    idControle := StrToInt(nomeControle);
  except
    exit;
  end;

  // Verifica a faixa
  if (idControle < 1) or (idControle > 25) then
     exit;

  if botaoAtual.Checked = true then begin
     // Altera o fundo do botão.
     botaoAtual.Color := clGreen;
     botaoAtual.Font.Color := clWhite;

     inc(lotofacil_qt_bolas_escolhidas);

     // Verifica se atingiu 15 bolas, se sim, desativar as não escolhidas
     if lotofacil_qt_bolas_escolhidas = 15 then begin
        for uA := 1 to 25 do begin
              lotofacil_resultado_botoes[uA].Enabled :=
                                                     lotofacil_resultado_botoes[uA].Checked;
        end;
     end;

  end else begin
      botaoAtual.Color := clDefault;

        // Aqui, iremos ativar as bolas que foram desativadas.
        for uA := 1 to 25 do begin
              if lotofacil_resultado_botoes[uA].Enabled = false then begin
                 lotofacil_resultado_botoes[uA].Enabled := true;
              end;
        end;

      botaoAtual.Font.Color := clDefault;
      dec(lotofacil_qt_bolas_escolhidas);
  end;

  strStatusLotofacil := '';
  for uA:= 1 to 25 do begin
      if lotofacil_resultado_botoes[uA].Checked then begin
         lotofacil_numeros_escolhidos[uA] := 1;
         if strStatusLotofacil <> '' then begin
            strStatusLotofacil := strStatusLotofacil + ' - ' + IntToStr(uA);
         end else begin
             strStatusLotofacil := IntToStr(ua);
         end;

      end
      else begin
          lotofacil_numeros_escolhidos[uA] := 0;
      end;
  end;
  strStatusLotofacil := 'Bolas escolhidas ' + #13#10 + strStatusLotofacil;

  //txtLotofacilBolas.Caption := strStatusLotofacil;

  // Se o total de bolas escolhidas for 15, desativar ativar o botão de envio.
  if lotofacil_qt_bolas_escolhidas = 15 then begin
     btnLotofacilResultadoInserir.Enabled := true;
     edConcurso.Enabled := true;
     grConcursoData.Enabled := true;
     dtpConcursoData.Enabled := true;
  end else begin
    btnLotofacilResultadoInserir.Enabled := false;
    edConcurso.Enabled := false;
    grConcursoData.Enabled := false;
    dtpConcursoData.Enabled := false;
  end;

end;

procedure TForm1.grpDiagonal15BolasResize(Sender : TObject);
begin

end;

procedure TForm1.pageFiltrosChange(Sender : TObject);
begin

end;

procedure TForm1.pageFiltrosResize(Sender : TObject);
begin
     RedimensionarControleDiagonal;
end;

procedure TForm1.pnDiagonalResize(Sender : TObject);
begin
  RedimensionarControleDiagonal;
end;

// Indica que o valor do concurso de ínicio alterou.
procedure TForm1.cmbFrequenciaInicioChange(Sender : TObject);
begin
  AtualizarFrequencia;
end;

procedure TForm1.edConcursoKeyDown(Sender : TObject; var Key : Word;
  Shift : TShiftState);
begin

end;

procedure TForm1.edConcursoKeyPress(Sender : TObject; var Key : char);
begin
  if not (Key in ['0'..'9', #8]) then begin
     Key := #0;
  end;
end;

procedure TForm1.cmbFrequenciaFimChange(Sender : TObject);
begin
  AtualizarFrequencia;
end;

procedure TForm1.btnLotofacilResultadoInserirClick(Sender : TObject);
var
  strData: string;
  uA , bolasEscolhidas: Integer;
  qtRegistros : LongInt;
  strSql : TStringList;
  sqlRegistro: TSqlQuery;
  uConcurso : Integer;

begin
  // Garante que o controle está preenchido.
  if edConcurso.Text = '' then begin
     MessageDlg('', 'Você deve fornecer o número do concurso', TMsgDlgType.mtError, [mbOk], 0);
     exit;
  end;
  // Pega o número do concurso, pra ser usado posteriormente.
  uConcurso := StrToInt(edConcurso.Text);

  // Cria o objeto se não existe.
  if dmLotofacil = nil then begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;
  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.UniDirectional := false;
  sqlRegistro.Active := false;


  sqlRegistro.SQL.Clear;
  sqlRegistro.Sql.Add('Select concurso from lotofacil_resultado');
  sqlRegistro.Sql.Add('where concurso = :concurso');
  sqlRegistro.Prepare;

  // Vamos passar o parâmetro, iremos pegar o número do concurso do botão
  // edConcurso.
  sqlRegistro.Params.ParamByName('concurso').AsInteger := uConcurso;
  sqlRegistro.Open;

  sqlRegistro.First;
  qtRegistros := 0;
  while not sqlRegistro.Eof do begin
        Inc(qtRegistros);
        sqlRegistro.Next;
  end;

  // Não podemos inserir um concurso que já existe, indicar como um erro e sair.
  if qtRegistros <> 0 then begin
     MessageDlg('Erro', 'Registro já existente.', TMsgDlgType.mtError, [mbOk], 0);
     exit;
  end;

  // Se não há erros, podemos inserir o novo concurso.
  sqlRegistro.close;

  // Vamos inserir o novo registros, primeiro iremos verificar se há 15 registros.
  strSql := TStringList.Create;
  strSql.Clear;
  strSql.Add('Insert Into ltk.lotofacil_resultado (');
  strSql.Add(' concurso, data');

  bolasEscolhidas := 0;
  for uA := 1 to 25 do begin
        if lotofacil_numeros_escolhidos[uA] = 1 then begin
           Inc(bolasEscolhidas);
           // Se a quantidade é maior que 15, devemos sair do loop e retornar da função.
           if bolasEscolhidas > 15 then begin
              MessageDlg('Erro', 'Foram escolhidos mais de 15 bolas.', TMsgDlgType.mtError, [mbOk], 0);
              exit;
           end;
           strSql.Add(', num_' + IntToStr(uA));
        end;
  end;
  // Verifica se realmente, houve 15 números escolhidos.
  if bolasEscolhidas <> 15 then begin
     MessageDlg('Erro', 'Deve ser escolhidos 15 números.', TMsgDlgType.mtError, [mbOk], 0);
     exit;
  end;

  // Pega a data do concurso.
  strData := FormatDateTime('yyyy-mm-dd', dtpConcursoData.Date);

  strSql.Add(') values (');
  strSql.Add(IntToStr(uConcurso));
  strSql.Add(', ' + QuotedStr(strData));
  strSql.Add(strUtils.DupeString(',1', 15));
  strSql.Add(');');

  sqlRegistro.SQL.Text := strSql.Text;

  // Executa a consulta.
  try
    sqlRegistro.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sqlRegistro.Close;

  except
    on Exc: EDataBaseError do begin
          MessageDlg('Erro', 'Erro: ' + Exc.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;

  // Só iremos desmarcar os botões se não tiver dado erro.
  for uA := 1 to 25 do begin
      lotofacil_resultado_botoes[uA].Checked :=  false;
  end;
  lotofacil_qt_bolas_escolhidas := 0;

  // Atualiza todos os controles que recupera informações do banco de dados.
  CarregarTodosControles;
end;

procedure TForm1.btnGrupo2BolasDesmarcarTodosClick(Sender : TObject);
begin

end;

procedure TForm1.btnGrupo2BolasMarcarTodosClick(Sender : TObject);
begin
  MarcarGrupo2Bolas;
end;


procedure TForm1.MarcarGrupo2Bolas;
var
  uLinha , indiceMarcar: Integer;
begin
  CarregarGrupo2Bolas;

  indiceMarcar := sgrGrupo2Bolas.Columns.Count - 1;
  for uLinha := 1 to sgrGrupo2Bolas.RowCount - 1 do begin
      sgrGrupo2Bolas.Cells[indiceMarcar, uLinha] := '1';
  end;
end;

{
 Este procedimento é chamando quando o usuário deseja excluir um concurso na
 tabela lotofacil_resultado
 }
procedure TForm1.btnLotofacilResultadoExcluirClick(Sender : TObject);
var
  strData: string;
  uA , bolasEscolhidas: Integer;
  qtRegistros : LongInt;
  strSql : TStringList;
  sqlRegistro: TSqlQuery;
  uConcurso : Integer;

begin
  // Garante que haja concurso pra deletar.
  if cmbConcursoDeletar.Items.Count = 0 then begin
     MessageDlg('', 'Não há nenhum concurso pra excluir', tMsgDlgType.mtError, [mbOk], 0);
     exit;
  end;

  // Pega o concurso selecionado.
  uConcurso := StrToInt(cmbConcursoDeletar.Items[cmbConcursoDeletar.ItemIndex]);

  // Aparece uma mensagem indicando se realmente o usuário deseja deletar o concurso.
  if MessageDlg('', 'Deseja realmente excluir o concurso ' + IntToStr(uConcurso) + '???',
     TMsgDlgType.mtConfirmation, [mbYes, mbNo], 0) = mrNo then begin
        // Se a resposta é não, iremos retornar, não precisamos implementar o sim
        // pois senão deveriamos ter uma condição if enorme.
        exit;
  end;

  // Se chegarmos aqui, quer dizer, que devemos excluir o concurso.

  // Cria o objeto se não existe.
  if dmLotofacil = nil then begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;
  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.UniDirectional := false;
  sqlRegistro.Active := false;


  sqlRegistro.SQL.Clear;
  sqlRegistro.Sql.Add('Delete from lotofacil_resultado');
  sqlRegistro.Sql.Add('where concurso = :concurso');
  sqlRegistro.Prepare;

  // Vamos passar o parâmetro, iremos pegar o número do concurso do botão
  // edConcurso.
  sqlRegistro.Params.ParamByName('concurso').AsInteger := uConcurso;

  // Executa a consulta.
  try
    sqlRegistro.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sqlRegistro.Close;
  except
    on Exc: EDataBaseError do begin
          MessageDlg('Erro', 'Erro: ' + Exc.Message, TMsgDlgType.mtError, [mbOk], 0);
    end;
  end;

  // Atualiza todos os controles que recupera informações do banco de dados.
  CarregarTodosControles;
end;

{
 Este procedimento gera o sql das opções escolhidas pelo usuário.
 Praticamente, é o mais importante do sistema.
 }
procedure TForm1.btnFiltroGerarClick(Sender : TObject);
var
  sqlGrupo5Bolas: TStringList;
  sqlGrupo4Bolas: TStringList;
  sqlGrupo3Bolas: TStringList;
  sqlGrupo2Bolas: TStringList;
  sqlGrupo: TStringList;
begin
  sqlGrupo :=  TStringList.Create;
  GerarSqlGrupo(sqlGrupo);
end;


procedure TForm1.GerarSqlGrupo(sqlGrupo: TStringList);
var
  uLinha , uA, indiceMarcar, indiceSql, ultimoIndiceGrupo, uB, uC, uD,
    ultima_Linha: Integer;
  controlesGrupo: array[0..3] of TStringGrid;
  colunaMarcar: array[0..3] of Integer;
  colunaSql : array[0..3] of Integer;
  bControleSelecionado : Boolean;
  objControle : TStringGrid;
  sqlTemp : String;
begin
  // Iremos verificar se o controles:
  // sgrGrupo2Bolas, sgrGrupo3Bolas, sgrGrupo4Bolas, sgrGrupo5Bolas, foram
  // marcados, somente um dos controles terá o sql retornado, pois,
  // por exemplos, o controle sgrGrupo5Bolas, tem todos os grupos de 4 números
  // selecionados.
  // Pois, funciona desta maneira, se o usuário selecionar o controle de 2 bolas
  // automaticamente, o controle de 3 bolas, exibirá todos os trios que tem
  // os pares selecionados e assim por diante.
  // Para isso, irei implementar um loop for e uma condição se qualquer grupo
  // for selecionado, após ir para o próximo controle, iremos verificar
  // se algum controle já foi selecionado pelo usuário por isto iremos utilizar
  // um arranjo.
  // Observe os controles está do maior quantidade de bolas para a menor.
  controlesGrupo[0] := sgrGrupo5Bolas;
  controlesGrupo[1] := sgrGrupo4Bolas;
  controlesGrupo[2] := sgrGrupo3Bolas;
  controlesGrupo[3] := sgrGrupo2Bolas;

  colunaMarcar[0] := controlesGrupo[0].Columns.Count - 1;
  colunaMarcar[1] := controlesGrupo[1].Columns.Count - 1;
  colunaMarcar[2] := controlesGrupo[2].Columns.Count - 1;
  colunaMarcar[3] := controlesGrupo[3].Columns.Count - 1;

  colunaSql[0] := 5;
  colunaSql[1] := 4;
  colunaSql[2] := 3;
  colunaSql[3] := 2;

  // Indica a lista de string que armazenará o sql.
  sqlGrupo := TStringList.Create;

  // Indica se algum controle foi selecionado se, sim, sairemos do loop.
  bControleSelecionado := false;
  for uA := 0 to 3 do begin
        // Vamos criar uma variável para armazenar o arranjo pra ficar economizar no digitar.
        objControle := controlesGrupo[uA];
        indiceMarcar := colunaMarcar[uA];
        indiceSql := colunaSql[uA];

        // Se o controle está zerado, passar para o próximo controle.
        if objControle.RowCount = 0 then begin
          continue;
        end;

        // Vamos percorrer todas as linhas do controle e verificar se algo foi
        // marcado.
        // Linha sempre começa em 1, pois, a linha 0 é o título.
        // Quantidade de linhas:
        ultima_Linha := objControle.RowCount - 1;

        for uLinha := 1 to ultima_Linha do begin
              if objControle.Cells[indiceMarcar, uLinha] = '1' then begin
                bControleSelecionado := true;
                sqlGrupo.Add(objControle.Cells[indiceSql, uLinha]);
              end;
        end;

        // Se algum controle teve algo marcado devemos sair do loop.
        if bControleSelecionado = true then begin
          break;
        end;
  end;

  // Se nenhum controle foi marcado, devemos retornar.
  if bControleSelecionado = false then begin
    sqlGrupo.Free;
    sqlGrupo := nil;
    exit;
  end;



  // Cada linha marcada tem um claúsula and com no mínimo duas bolas e no máximo
  // 5 bolas.
  // O que o loop for abaixo fará é pegar cada claúsula e junta com outra pra formar
  // uma nova claúsula onde todas as condições devem ser satisfeitas, então,
  // nosso sql, começará com a maior quantidade de ítens, no nosso caso, haverá
  // primeiramente, uma claúsula com 4 grupos, estes grupos podem ter 2, 3, 4 ou 5
  // grupo dentro dele.

  // Devemos pegar o último índice gerado, pois, iremos inserir os novos sql
  // na mesma lista de string, então a cada iteração do loop, provavelmente,
  // a quantidade de ítens excederá, senão, ficará no loop sem fim.
  ultimoIndiceGrupo := sqlGrupo.Count - 1;
  // Limite as combinações, aos 20 primeiros números totalizando
  // 1140 grupos.
  if ultimoIndiceGrupo > 39 then begin
    ultimoIndiceGrupo := 39;
  end;

  sqlTemp := '';
  for uA := 0 to ultimoIndiceGrupo do begin
        for uB := uA + 1 to ultimoIndiceGrupo do begin
              for uC := uB + 1 to ultimoIndiceGrupo do begin
                        sqlTemp := '(' + sqlGrupo[uA] + ' and ';
                        sqlTemp := sqlTemp + sqlGrupo[uB] + ' and ';
                        sqlTemp := sqlTemp + sqlGrupo[uC] + ')';

                        if (uC - uB <> 0) or (uC <> ultimoIndiceGrupo) then begin
                          sqlTemp := sqlTemp + ' or ';
                        end;

                        sqlGrupo.Add(sqlTemp);
              end;
        end;
  end;
  //exit;

  mmFiltroSql.Lines.Clear;
  // Aqui, iremos pegar do último, para o primeiro.
  for uA := sqlGrupo.Count - 1 downto 0 do begin
      mmFiltroSql.Lines.Add(sqlGrupo.Strings[uA]);
  end;
end;

procedure TForm1.sgrColunaB1_15BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_16BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_17BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_18BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_15BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
     AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_16BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_17BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_18BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_15BolasSelectCell(Sender : TObject;
  aCol, aRow : Integer; var CanSelect : Boolean);
begin
     AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_16BolasSelectCell(Sender : TObject;
  aCol, aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_17BolasSelectCell(Sender : TObject;
  aCol, aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_18BolasSelectCell(Sender : TObject;
  aCol, aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_15BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_16BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_17BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_18BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrExternoInterno15BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrExternoInterno16BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrExternoInterno17BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrExternoInterno18BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrFrequenciaDrawCell(Sender : TObject; aCol, aRow : Integer;
  aRect : TRect; aState : TGridDrawState);
var
  grdFrequencia: TDBGrid;
  valorFrequencia: Integer;
  gradeCanvas : TCanvas;

  larguraTexto : Integer;
  alturaTexto : Integer;

  textoAtual : string;

  textoX : Integer;
  textoY : Integer;

  corColuna : TColor;
  corTexto: TColor;

begin
  grdFrequencia := TDBGrid(Sender);
  gradeCanvas := grdFrequencia.Canvas;
  textoAtual := sgrFrequencia.Cells[aCol, aRow];

  corColuna := clWhite;
  corTexto := clBlack;

  // Só iremos pegar as células das colunas que tem as bolas
  // e ela começa na linha 1.
  if (aCol >= 1) and (aCol <= 25) and (aRow > 0)  then begin
     valorFrequencia := StrToInt(textoAtual);

     if valorFrequencia = 1 then begin
        corColuna := clGreen;
     end else
     if valorFrequencia = - 1 then begin
        corColuna := clRed;
        corTexto := clWhite;
     end else
     if valorFrequencia > 1 then begin
        corColuna := clYellow;
        corTexto := clRed;
     end else
     if valorFrequencia < -1 then begin
        corColuna := clPurple;
        corTexto := clWhite;
     end;
  end;

  gradeCanvas.Brush.Color := corColuna;
  gradeCanvas.FillRect(ARect);
  //gradeCanvas.Pen.Color := corTexto;
  gradeCanvas.Font.Color := corTexto;

  // Pega a largura do texto e centraliza o mesmo.
  larguraTexto := gradeCanvas.TextWidth(textoAtual);
  alturaTexto := gradeCanvas.TextHeight(textoAtual);
  textoX := (ARect.Width - larguraTexto) div 2;
  textoY := (ARect.Height - alturaTexto) div 2;
  gradeCanvas.TextOut(ARect.Left + textoX,
                                         ARect.Top + textoY, textoAtual);

end;

procedure TForm1.sgrGrupo2BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrGrupo3BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);

end;

procedure TForm1.sgrGrupo4BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
     AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrGrupo5BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrNovosRepetidos16BolasButtonClick(Sender : TObject; aCol,
  aRow : Integer);
begin
end;


procedure TForm1.sgrNovosRepetidos16BolasClick(Sender : TObject);
begin

end;


procedure TForm1.sgrNovosRepetidos15BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;


procedure TForm1.sgrNovosRepetidos16BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
     AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrNovosRepetidos17BolasClick(Sender : TObject);
begin

end;

procedure TForm1.sgrParImpar15BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
     AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrParImpar16BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrParImpar17BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrParImpar18BolasSelectCell(Sender : TObject; aCol,
  aRow : Integer; var CanSelect : Boolean);
begin
  AlterarMarcador(sender, aCol, aRow, CanSelect);
end;

{
 Ao redimensionar devemos atualizar a largura dos controles
 sgrDiagonal15Bolas,
 sgrDiagonal16Bolas,
 sgrDiagonal17Bolas,
 sgrDiagonal18Bolas
 }
procedure TForm1.tabDiagonalResize(Sender : TObject);
begin
end;

procedure TForm1.sheetFiltroResize(Sender : TObject);
begin
end;





procedure TForm1.AlterarMarcador(Sender : TObject; aCol,  aRow : Integer; var CanSelect : Boolean);
var
  gradeTemp : TStringGrid;
begin
  Write('ARow: ', aRow);
  // Se está na coluna marcar, então, altera o valor da célula.
  gradeTemp := TStringGrid(Sender);
  // Se a coluna é maior que gradeTemp.Columns, então retorna.

  if (aCol <= -1) or (ARow <= -1) then begin
    exit;
  end;

  if aCol > gradeTemp.Columns.Count then begin
    exit;
  end;

    if (gradeTemp.Columns[ACol].Title <> nil) and  //(UpCase(gradeTemp.Cells[Acol, 0]) = 'MARCAR') or
       (UpCase(gradeTemp.Columns[Acol].Title.Caption) = 'MARCAR')
      then begin
      if  aRow <> 0 then begin
        if gradeTemp.Cells[aCol, aRow] = '0' then begin
           gradeTemp.Cells[aCol, aRow] := '1';
        end else begin
          gradeTemp.Cells[aCol, aRow] := '0';
        end;
      end;

      // Se os controles são um dos controles referentes as colunas, então, atualizar
      // o próximo controle.
      if (gradeTemp = sgrColunaB1_15Bolas) or
         (gradeTemp = sgrColunaB1_16Bolas) or
         (gradeTemp = sgrColunaB1_17Bolas) or
         (gradeTemp = sgrColunaB1_18Bolas) or
         (gradeTemp = sgrColunaB1_B15_15Bolas) or
         (gradeTemp = sgrColunaB1_B15_16Bolas) or
         (gradeTemp = sgrColunaB1_B15_17Bolas) or
         (gradeTemp = sgrColunaB1_B15_18Bolas) or
         (gradeTemp = sgrColunaB1_B8_B15_15Bolas) or
         (gradeTemp = sgrColunaB1_B8_B15_16Bolas) or
         (gradeTemp = sgrColunaB1_B8_B15_17Bolas) or
         (gradeTemp = sgrColunaB1_B8_B15_18Bolas) or
         (gradeTemp = sgrColunaB1_B4_B8_B12_B15_15Bolas) or
         (gradeTemp = sgrColunaB1_B4_B8_B12_B15_16Bolas) or
         (gradeTemp = sgrColunaB1_B4_B8_B12_B15_17Bolas) or
         (gradeTemp = sgrColunaB1_B4_B8_B12_B15_18Bolas) then
      begin
          //AtualizarColuna_B(gradeTemp);
          GerarSqlColuna_B(gradeTemp);
      end;

      // Toda vez que o usuário clicar nos controles sgrGrupo2Bolas, sgrGrupo3Bolas,
      // sgrGrupo4Bolas ou sgrGrupo5Bolas,
      // o próximo controle será atualizado.
      if (gradeTemp = sgrGrupo2Bolas) or
         (gradeTemp = sgrGrupo3Bolas) or
         (gradeTemp = sgrGrupo4Bolas) or
         (gradeTemp = sgrGrupo5Bolas) then begin
                    AtualizarControleGrupo(gradeTemp);
      end;
    end;
end;

procedure TForm1.AtualizarColuna_B(objControle : TStringGrid);
begin


end;



procedure TForm1.AtualizarControleGrupo(objControle: TStringGrid);
var
  strWhereSql : TStringList;
  uA : Integer;
begin
    strWhereSql := TStringList.Create;
    if objControle = sgrGrupo2Bolas then begin
       // Apaga os dados dos outros controles.
       sgrGrupo3Bolas.Columns.Clear;
       sgrGrupo4Bolas.Columns.Clear;
       sgrGrupo5Bolas.Columns.Clear;

       strWhereSql.Clear;
       // Vamos percorrer o controle e verificar se alguma célula foi marcada.
       for uA := 1 to sgrGrupo2Bolas.RowCount - 1 do begin
           // Neste controle há 6 colunas:
           // b_1, b_2, sql_bolas, ltf_bolas, res_qt e marcar.
           // Iremos selecionar a última coluna, a coluna marcar, que indica
           // se o usuário selecionou aquela combinação, se o usuário selecionou
           // aquele combinações, iremos pegar o valor da coluna sql_bolas
           // pois, estes dados serão usados para gerar a claúsula where que
           // será passada para o próximo controle.
           if sgrGrupo2Bolas.Cells[5, uA] = '1' then begin
              if strWhereSql.Text <> '' then begin
                 strWhereSql.Add('or');
              end;
              strWhereSql.Add(sgrGrupo2Bolas.Cells[2, uA]);
           end;
       end;
       // Só iremos inserir a claúsula where se houver algo selecionado.
       if strWhereSql.Count  <> 0 then begin
         // Insere a claúsula where antes das condições e em seguida
         strWhereSql.Insert(0, 'where');
         // Atualiza o próximo controle.
         CarregarGrupo3Bolas(strWhereSql.Text);
       end;
    end else
    if objControle = sgrGrupo3Bolas then begin
       // Apaga os dados dos outros controles.
       sgrGrupo4Bolas.Columns.Clear;
       sgrGrupo5Bolas.Columns.Clear;

       strWhereSql.Clear;
       // Vamos percorrer o controle e verificar se alguma célula foi marcada.
       for uA := 1 to objControle.RowCount - 1 do begin
           // Neste controle há 6 colunas:
           // b_1, b_2, sql_bolas, ltf_bolas, res_qt e marcar.
           // Iremos selecionar a última coluna, a coluna marcar, que indica
           // se o usuário selecionou aquela combinação, se o usuário selecionou
           // aquele combinações, iremos pegar o valor da coluna sql_bolas
           // pois, estes dados serão usados para gerar a claúsula where que
           // será passada para o próximo controle.
           if objControle.Cells[6, uA] = '1' then begin
              if strWhereSql.Text <> '' then begin
                 strWhereSql.Add('or');
              end;
              strWhereSql.Add(objControle.Cells[3, uA]);
           end;
       end;
       // Só iremos inserir a claúsula where se houver algo selecionado.
       if strWhereSql.Count  <> 0 then begin
         // Insere a claúsula where antes das condições e em seguida
         strWhereSql.Insert(0, 'where');
         // Atualiza o próximo controle.
         CarregarGrupo4Bolas(strWhereSql.Text);
       end;
    end else
        if objControle = sgrGrupo4Bolas then begin
       // Apaga os dados dos outros controles.
       sgrGrupo5Bolas.Columns.Clear;

       strWhereSql.Clear;
       // Vamos percorrer o controle e verificar se alguma célula foi marcada.
       for uA := 1 to objControle.RowCount - 1 do begin
           // Neste controle há 6 colunas:
           // b_1, b_2, sql_bolas, ltf_bolas, res_qt e marcar.
           // Iremos selecionar a última coluna, a coluna marcar, que indica
           // se o usuário selecionou aquela combinação, se o usuário selecionou
           // aquele combinações, iremos pegar o valor da coluna sql_bolas
           // pois, estes dados serão usados para gerar a claúsula where que
           // será passada para o próximo controle.
           if objControle.Cells[7, uA] = '1' then begin
              if strWhereSql.Text <> '' then begin
                 strWhereSql.Add('or');
              end;
              strWhereSql.Add(objControle.Cells[4, uA]);
           end;
       end;
       // Só iremos inserir a claúsula where se houver algo selecionado.
       if strWhereSql.Count  <> 0 then begin
         // Insere a claúsula where antes das condições e em seguida
         strWhereSql.Insert(0, 'where');
         // Atualiza o próximo controle.
         CarregarGrupo5Bolas(strWhereSql.Text);
       end;
    end;

end;

procedure TForm1.ConfigurarControleGrupo5Bolas;
  var
    uColunas, uA: Integer;
    strTitulo: array[0..8] of string = ('b_1', 'b_2', 'b_3', 'b_4', 'b_5', 'sql_bolas', 'ltf_qt', 'res_qt',
               'Marcar');
  begin
      // São 9 colunas, uma das colunas não usaremos, cmb_bolas.
      // A coluna sql_bolas, estará oculta, pois ela servirá somente para
      // podermos atualizar o controle de 3 bolas.
      // b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt, marcar
      uColunas := 9;
      sgrGrupo5Bolas.Columns.Clear;
      while uColunas > 0 do begin
          sgrGrupo5Bolas.Columns.Add;
          dec(uColunas);
      end;

      sgrGrupo5Bolas.FixedCols := 0;
      sgrGrupo5Bolas.FixedRows := 1;
      sgrGrupo5Bolas.RowCount := 1;

      for uA := 0 to 8 do begin
          sgrGrupo5Bolas.Columns[uA].Alignment := TAlignment.taCenter;
          sgrGrupo5Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
          sgrGrupo5Bolas.Columns[uA].Title.Caption := strTitulo[uA];
          sgrGrupo5Bolas.Cells[uA, 0] := strTitulo[uA];
      end;

      // Oculta a coluna 'sql_bolas'
      sgrGrupo5Bolas.Columns[5].Visible := false;

      // Indica o tipo da coluna 6, a coluna marcar
      sgrGrupo5Bolas.Columns[8].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

end;

{
 Os grupos de 3 bolas, 4 bolas e 5 bolas, serão carregados, conforme o controle
 da esquerda for preenchido, por exemplo,
 se o controle sgrGrupo2Bolas, for clicado, então o controle sgrGrupo3Bolas
 será atualizado, para ser populado somente com valores baseados no controle
 sgrGrupo2Bolas.
 Observação: o parâmetro strSqlWhere, terá como conteúdo uma condição, onde
 a primeira palavra é a clausula where.
}
procedure TForm1.CarregarGrupo5Bolas(strSqlWhere: string);
var
 strSql: TStringList;
 sqlRegistro: TSqlQuery;
 qtRegistros, uLinha, uA: Integer;
begin
    strSql := TStringList.Create;

    ConfigurarControleGrupo5Bolas;

    strSql.Add('Select b_1, b_2, b_3, b_4, b_5, sql_bolas, ltf_qt, res_qt');
    strSql.Add('from lotofacil_resultado_agregado_grupo_5bolas');
    if strSqlWhere <> '' then begin
       strSql.Add(strSqlWhere);
    end;
    strSql.Add('order by res_qt desc, ltf_qt desc');
    WriteLn(strSql.Text);

    if dmLotofacil = nil then begin
      dmLotofacil := TdmLotofacil.Create(Self);
    end;

    sqlRegistro := dmLotofacil.sqlLotofacil;
    sqlRegistro.Active := false;
    sqlRegistro.DataBase := dmLotofacil.pgLtk;
    sqlRegistro.SQL.Text := strSql.Text;
    sqlRegistro.UniDirectional := false;
    sqlRegistro.Open;

    // Vamos verificar quantos registros houve.
    qtRegistros := 0;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
       Inc(qtRegistros);
       sqlRegistro.Next;
    end;

    if qtRegistros = 0 then begin
      exit;
    end;

    // Define a quantidade de linhas igual a quantidade de registro + 1
    // pois, a primeira linha é o nome do título.
    sgrGrupo5Bolas.RowCount := qtRegistros + 1;;

    // Se encontrarmos registros, inserir.
    // Vamos desativar a atualizar no controle, pra ficar mais rápido.
    sgrGrupo5Bolas.BeginUpdate;
    uLinha := 1;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
        // Campos b_1, b_2, ltf_qt, res_qt
        sgrGrupo5Bolas.Cells[0, uLinha] := sqlRegistro.FieldByName('b_1').AsString;
        sgrGrupo5Bolas.Cells[1, uLinha] := sqlRegistro.FieldByName('b_2').AsString;
        sgrGrupo5Bolas.Cells[2, uLinha] := sqlRegistro.FieldByName('b_3').AsString;
        sgrGrupo5Bolas.Cells[3, uLinha] := sqlRegistro.FieldByName('b_4').AsString;
        sgrGrupo5Bolas.Cells[4, uLinha] := sqlRegistro.FieldByName('b_5').AsString;
        sgrGrupo5Bolas.Cells[5, uLinha] := sqlRegistro.FieldByName('sql_bolas').AsString;
        sgrGrupo5Bolas.Cells[6, uLinha] := sqlRegistro.FieldByName('ltf_qt').AsString;
        sgrGrupo5Bolas.Cells[7, uLinha] := sqlRegistro.FieldByName('res_qt').AsString;
        sgrGrupo5Bolas.Cells[8, uLinha] := '0';

        Inc(uLinha);
        sqlRegistro.Next;
    end;
    sgrGrupo5Bolas.EndUpdate(true);
    sqlRegistro.Close;

    // Ajusta as colunas.
    sgrGrupo5Bolas.AutoSizeColumns;
end;



procedure TForm1.ConfigurarControleGrupo4Bolas;
  var
    uColunas, uA: Integer;
    strTitulo: array[0..7] of string = ('b_1', 'b_2', 'b_3', 'b_4', 'sql_bolas', 'ltf_qt', 'res_qt',
               'Marcar');
  begin
      // São 7 colunas, uma das colunas não usaremos, cmb_bolas.
      // A coluna sql_bolas, estará oculta, pois ela servirá somente para
      // podermos atualizar o controle de 3 bolas.
      // b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt, marcar
      uColunas := 8;
      sgrGrupo4Bolas.Columns.Clear;
      while uColunas > 0 do begin
          sgrGrupo4Bolas.Columns.Add;
          dec(uColunas);
      end;

      sgrGrupo4Bolas.FixedCols := 0;
      sgrGrupo4Bolas.FixedRows := 1;
      sgrGrupo4Bolas.RowCount := 1;

      for uA := 0 to 7 do begin
          sgrGrupo4Bolas.Columns[uA].Alignment := TAlignment.taCenter;
          sgrGrupo4Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
          sgrGrupo4Bolas.Columns[uA].Title.Caption := strTitulo[uA];
          sgrGrupo4Bolas.Cells[uA, 0] := strTitulo[uA];
      end;

      // Oculta a coluna 'sql_bolas'
      sgrGrupo4Bolas.Columns[4].Visible := false;

      // Indica o tipo da coluna 6, a coluna marcar
      sgrGrupo4Bolas.Columns[7].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

end;

{
 Os grupos de 3 bolas, 4 bolas e 5 bolas, serão carregados, conforme o controle
 da esquerda for preenchido, por exemplo,
 se o controle sgrGrupo2Bolas, for clicado, então o controle sgrGrupo3Bolas
 será atualizado, para ser populado somente com valores baseados no controle
 sgrGrupo2Bolas.
 Observação: o parâmetro strSqlWhere, terá como conteúdo uma condição, onde
 a primeira palavra é a clausula where.
}
procedure TForm1.CarregarGrupo4Bolas(strSqlWhere: string);
var
 strSql: TStringList;
 sqlRegistro: TSqlQuery;
 qtRegistros, uLinha, uA: Integer;
begin
    strSql := TStringList.Create;

    ConfigurarControleGrupo4Bolas;

    strSql.Add('Select b_1, b_2, b_3, b_4, sql_bolas, ltf_qt, res_qt');
    strSql.Add('from lotofacil_resultado_agregado_grupo_4bolas');
    if strSqlWhere <> '' then begin
       strSql.Add(strSqlWhere);
    end;
    strSql.Add('order by res_qt desc, ltf_qt desc');
    WriteLn(strSql.Text);

    if dmLotofacil = nil then begin
      dmLotofacil := TdmLotofacil.Create(Self);
    end;

    sqlRegistro := dmLotofacil.sqlLotofacil;
    sqlRegistro.Active := false;
    sqlRegistro.DataBase := dmLotofacil.pgLtk;
    sqlRegistro.SQL.Text := strSql.Text;
    sqlRegistro.UniDirectional := false;
    sqlRegistro.Open;

    // Vamos verificar quantos registros houve.
    qtRegistros := 0;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
       Inc(qtRegistros);
       sqlRegistro.Next;
    end;

    if qtRegistros = 0 then begin
      exit;
    end;

    // Define a quantidade de linhas igual a quantidade de registro + 1
    // pois, a primeira linha é o nome do título.
    sgrGrupo4Bolas.RowCount := qtRegistros + 1;;

    // Se encontrarmos registros, inserir.
    // Vamos desativar a atualizar no controle, pra ficar mais rápido.
    sgrGrupo4Bolas.BeginUpdate;
    uLinha := 1;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
        // Campos b_1, b_2, ltf_qt, res_qt
        sgrGrupo4Bolas.Cells[0, uLinha] := sqlRegistro.FieldByName('b_1').AsString;
        sgrGrupo4Bolas.Cells[1, uLinha] := sqlRegistro.FieldByName('b_2').AsString;
        sgrGrupo4Bolas.Cells[2, uLinha] := sqlRegistro.FieldByName('b_3').AsString;
        sgrGrupo4Bolas.Cells[3, uLinha] := sqlRegistro.FieldByName('b_4').AsString;
        sgrGrupo4Bolas.Cells[4, uLinha] := sqlRegistro.FieldByName('sql_bolas').AsString;
        sgrGrupo4Bolas.Cells[5, uLinha] := sqlRegistro.FieldByName('ltf_qt').AsString;
        sgrGrupo4Bolas.Cells[6, uLinha] := sqlRegistro.FieldByName('res_qt').AsString;
        sgrGrupo4Bolas.Cells[7, uLinha] := '0';

        Inc(uLinha);
        sqlRegistro.Next;
    end;
    sgrGrupo4Bolas.EndUpdate(true);
    sqlRegistro.Close;

    // Ajusta as colunas.
    sgrGrupo4Bolas.AutoSizeColumns;
end;





procedure TForm1.ConfigurarControleGrupo3Bolas;
  var
    uColunas, uA: Integer;
    strTitulo: array[0..6] of string = ('b_1', 'b_2', 'b_3', 'sql_bolas', 'ltf_qt', 'res_qt',
               'Marcar');
  begin
      // São 7 colunas, uma das colunas não usaremos, cmb_bolas.
      // A coluna sql_bolas, estará oculta, pois ela servirá somente para
      // podermos atualizar o controle de 3 bolas.
      // b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt, marcar
      uColunas := 7;
      sgrGrupo3Bolas.Columns.Clear;
      while uColunas > 0 do begin
          sgrGrupo3Bolas.Columns.Add;
          dec(uColunas);
      end;

      sgrGrupo3Bolas.FixedCols := 0;
      sgrGrupo3Bolas.FixedRows := 1;
      sgrGrupo3Bolas.RowCount := 1;

      for uA := 0 to 6 do begin
          sgrGrupo3Bolas.Columns[uA].Alignment := TAlignment.taCenter;
          sgrGrupo3Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
          sgrGrupo3Bolas.Columns[uA].Title.Caption := strTitulo[uA];
          sgrGrupo3Bolas.Cells[uA, 0] := strTitulo[uA];
      end;

      // Oculta a coluna 'sql_bolas'
      sgrGrupo3Bolas.Columns[3].Visible := false;

      // Indica o tipo da coluna 6, a coluna marcar
      sgrGrupo3Bolas.Columns[6].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

end;

{
 Os grupos de 3 bolas, 4 bolas e 5 bolas, serão carregados, conforme o controle
 da esquerda for preenchido, por exemplo,
 se o controle sgrGrupo2Bolas, for clicado, então o controle sgrGrupo3Bolas
 será atualizado, para ser populado somente com valores baseados no controle
 sgrGrupo2Bolas.
 Observação: o parâmetro strSqlWhere, terá como conteúdo uma condição, onde
 a primeira palavra é a clausula where.
}
procedure TForm1.CarregarGrupo3Bolas(strSqlWhere: string);
var
 strSql: TStringList;
 sqlRegistro: TSqlQuery;
 qtRegistros, uLinha, uA: Integer;
begin
    strSql := TStringList.Create;

    ConfigurarControleGrupo3Bolas;

    strSql.Add('Select b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt');
    strSql.Add('from lotofacil_resultado_agregado_grupo_3bolas');
    if strSqlWhere <> '' then begin
       strSql.Add(strSqlWhere);
    end;
    strSql.Add('order by res_qt desc, ltf_qt desc');
    WriteLn(strSql.Text);

    if dmLotofacil = nil then begin
      dmLotofacil := TdmLotofacil.Create(Self);
    end;

    sqlRegistro := dmLotofacil.sqlLotofacil;
    sqlRegistro.Active := false;
    sqlRegistro.DataBase := dmLotofacil.pgLtk;
    sqlRegistro.SQL.Text := strSql.Text;
    sqlRegistro.UniDirectional := false;
    sqlRegistro.Open;

    // Vamos verificar quantos registros houve.
    qtRegistros := 0;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
       Inc(qtRegistros);
       sqlRegistro.Next;
    end;

    if qtRegistros = 0 then begin
      exit;
    end;

    // Define a quantidade de linhas igual a quantidade de registro + 1
    // pois, a primeira linha é o nome do título.
    sgrGrupo3Bolas.RowCount := qtRegistros + 1;;

    // Se encontrarmos registros, inserir.
    // Vamos desativar a atualizar no controle, pra ficar mais rápido.
    sgrGrupo3Bolas.BeginUpdate;
    uLinha := 1;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
        // Campos b_1, b_2, ltf_qt, res_qt
        sgrGrupo3Bolas.Cells[0, uLinha] := sqlRegistro.FieldByName('b_1').AsString;
        sgrGrupo3Bolas.Cells[1, uLinha] := sqlRegistro.FieldByName('b_2').AsString;
        sgrGrupo3Bolas.Cells[2, uLinha] := sqlRegistro.FieldByName('b_3').AsString;
        sgrGrupo3Bolas.Cells[3, uLinha] := sqlRegistro.FieldByName('sql_bolas').AsString;
        sgrGrupo3Bolas.Cells[4, uLinha] := sqlRegistro.FieldByName('ltf_qt').AsString;
        sgrGrupo3Bolas.Cells[5, uLinha] := sqlRegistro.FieldByName('res_qt').AsString;
        sgrGrupo3Bolas.Cells[6, uLinha] := '0';

        Inc(uLinha);
        sqlRegistro.Next;
    end;
    sgrGrupo3Bolas.EndUpdate(true);
    sqlRegistro.Close;

    // Ajusta as colunas.
    sgrGrupo3Bolas.AutoSizeColumns;
end;


procedure TForm1.CarregarGrupo2Bolas;
var
 strSql: TStringList;
 sqlRegistro: TSqlQuery;
 qtRegistros, uLinha, uA: Integer;
begin
    strSql := TStringList.Create;

    ConfigurarControleGrupo2Bolas;

    strSql.Add('Select b_1, b_2, sql_bolas, ltf_qt, res_qt');
//    strSql.Add('from v_lotofacil_resultado_grupo_2bolas');
    strSql.Add('from lotofacil_resultado_agregado_grupo_2bolas');
    strSql.Add('order by res_qt desc, ltf_qt desc');

    if dmLotofacil = nil then begin
      dmLotofacil := TdmLotofacil.Create(Self);
    end;

    sqlRegistro := dmLotofacil.sqlLotofacil;
    sqlRegistro.Active := false;
    sqlRegistro.DataBase := dmLotofacil.pgLtk;
    sqlRegistro.SQL.Text := strSql.Text;
    sqlRegistro.UniDirectional := false;
    sqlRegistro.Open;

    // Vamos verificar quantos registros houve.
    qtRegistros := 0;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
       Inc(qtRegistros);
       sqlRegistro.Next;
    end;

    if qtRegistros = 0 then begin
      exit;
    end;

    // Define a quantidade de linhas igual a quantidade de registro + 1
    // pois, a primeira linha é o nome do título.
    sgrGrupo2Bolas.RowCount := qtRegistros + 1;;

    // Se encontrarmos registros, inserir.
    uLinha := 1;
    sqlRegistro.First;
    while not sqlRegistro.Eof do begin
        // Campos b_1, b_2, ltf_qt, res_qt
        sgrGrupo2Bolas.Cells[0, uLinha] := sqlRegistro.FieldByName('b_1').AsString;
        sgrGrupo2Bolas.Cells[1, uLinha] := sqlRegistro.FieldByName('b_2').AsString;
        sgrGrupo2Bolas.Cells[2, uLinha] := sqlRegistro.FieldByName('sql_bolas').AsString;
        sgrGrupo2Bolas.Cells[3, uLinha] := sqlRegistro.FieldByName('ltf_qt').AsString;
        sgrGrupo2Bolas.Cells[4, uLinha] := sqlRegistro.FieldByName('res_qt').AsString;
        sgrGrupo2Bolas.Cells[5, uLinha] := '0';

        Inc(uLinha);
        sqlRegistro.Next;
    end;

    // Ajusta as colunas.
    sgrGrupo2Bolas.AutoSizeColumns;
end;

procedure TForm1.ConfigurarControleGrupo2Bolas;
var
  uColunas, uA: Integer;
  strTitulo: array[0..5] of string = ('b_1', 'b_2', 'sql_bolas', 'ltf_qt', 'res_qt',
             'Marcar');
begin
    // São 6 colunas, uma das colunas não usaremos, cmb_bolas.
    // A coluna sql_bolas, estará oculta, pois ela servirá somente para
    // podermos atualizar o controle de 3 bolas.
    // b_1, b_2, sql_bolas, ltf_qt, res_qt, marcar
    uColunas := 6;
    sgrGrupo2Bolas.Columns.Clear;
    while uColunas > 0 do begin
        sgrGrupo2Bolas.Columns.Add;
        dec(uColunas);
    end;

    sgrGrupo2Bolas.FixedCols := 0;
    sgrGrupo2Bolas.FixedRows := 1;
    sgrGrupo2Bolas.RowCount := 1;

    for uA := 0 to 5 do begin
        sgrGrupo2Bolas.Columns[uA].Alignment := TAlignment.taCenter;
        sgrGrupo2Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
        sgrGrupo2Bolas.Columns[uA].Title.Caption := strTitulo[uA];
        sgrGrupo2Bolas.Cells[uA, 0] := strTitulo[uA];
    end;

    // Oculta a coluna 'sql_bolas'
    sgrGrupo2Bolas.Columns[2].Visible := false;

    // Indica o tipo da coluna 5, a coluna marcar
    sgrGrupo2Bolas.Columns[5].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

end;

procedure TForm1.CarregarDiagonal;
begin
     CarregarDiagonal(sgrDiagonal15Bolas);
     CarregarDiagonal(sgrDiagonal16Bolas);
     CarregarDiagonal(sgrDiagonal17Bolas);
     CarregarDiagonal(sgrDiagonal18Bolas);

end;

procedure TForm1.RedimensionarControleDiagonal;
var
  larguraTab: LongInt;
begin
  // Há 4 controles, então, a largura será dividida por 4.
  larguraTab := pnDiagonal.Width div 4;
  self.Caption := IntToSTr(larguraTab);

  sgrDiagonal15Bolas.Width := larguraTab;
  sgrDiagonal16Bolas.Width := larguraTab;
  sgrDiagonal17Bolas.Width := larguraTab;
  sgrDiagonal18Bolas.Width := larguraTab;

  sgrDiagonal15Bolas.ReAlign;
  sgrDiagonal16Bolas.ReAlign;
  sgrDiagonal17Bolas.ReAlign;
  sgrDiagonal18Bolas.ReAlign;

end;

procedure TForm1.CarregarDiagonal(objControle: TStringGrid);
var
  strSql: TStringList;
  sqlConcurso: TSqlQuery;
  qtRegistros, uLinha, uA: Integer;
begin
     strSql := TStringList.Create;

     ConfigurarControleDiagonal(objControle);

  // Base o sql conforme o controle sendo solicitado.
  if objControle = sgrDiagonal15Bolas then begin
    strSql.Add('Select * from v_lotofacil_resultado_diagonal_15Bolas');
    strSql.Add('order by res_qt desc');
  end else if objControle = sgrDiagonal16Bolas then begin
      strSql.Add('Select diag_1, diag_2, diag_3, diag_4, diag_5, qt_vezes');
      strSql.Add('from lotofacil_agregado_diagonal');
      strSql.Add('where qt_bolas = 16');
      strSql.Add('order by qt_vezes desc');
  end else if objControle = sgrDiagonal17Bolas then begin
    strSql.Add('Select diag_1, diag_2, diag_3, diag_4, diag_5, qt_vezes');
    strSql.Add('from lotofacil_agregado_diagonal');
    strSql.Add('where qt_bolas = 17');
    strSql.Add('order by qt_vezes desc');
  end else if objControle = sgrDiagonal18Bolas then begin;
    strSql.Add('Select diag_1, diag_2, diag_3, diag_4, diag_5, qt_vezes');
    strSql.Add('from lotofacil_agregado_diagonal');
    strSql.Add('where qt_bolas = 18');
    strSql.Add('order by qt_vezes desc');
  end;

  if dmLotofacil = nil then begin
     dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlConcurso := dmLotofacil.sqlLotofacil;
  sqlConcurso.Active := false;
  sqlConcurso.DataBase := dmLotofacil.pgLtk;
  sqlConcurso.SQL.Text := strSql.Text;
  sqlConcurso.UniDirectional := false;
  sqlConcurso.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlConcurso.First;
  while not sqlConcurso.Eof do begin
      Inc(qtRegistros);
      sqlConcurso.Next;
  end;

  if qtRegistros = 0 then begin
     exit;
  end;

  // Define a quantidade de linhas igual a quantidade de registro + 1
  // pois, a primeira linha é o nome do título.
  objControle.RowCount := qtRegistros + 1;;

  // Se encontrarmos registros, inserir.
  uLinha := 1;
  sqlConcurso.First;
  while not sqlConcurso.Eof do begin
      for uA := 1 to 5 do begin
          objControle.Cells[uA-1, uLinha] :=
                                  sqlConcurso.FieldByName('diag_' + IntToStr(uA)).AsString;
      end;

      // Se o controle é de 15 bolas, devemos inserir após as colunas:
      if objControle = sgrDiagonal15Bolas then begin
         objControle.Cells[5, uLinha] := sqlConcurso.FieldByName('ltf_qt').AsString;
         objControle.Cells[6, uLinha] := sqlConcurso.FieldByName('res_qt').AsString;
         objControle.Cells[7, uLinha] := '0';
      end else if (objControle = sgrDiagonal16Bolas) or
        (objControle = sgrDiagonal17Bolas) or
        (objControle = sgrDiagonal18Bolas) then begin
          objControle.Cells[5, uLinha] := sqlConcurso.FieldByName('qt_vezes').AsString;
          objControle.Cells[6, uLinha] := '0';
      end else begin
          exit;
      end;

      Inc(uLinha);
      sqlConcurso.Next;
  end;

  // Ajusta as colunas.
  objControle.AutoSizeColumns;


end;

procedure TForm1.ConfigurarControleDiagonal(objControle: TStringGrid);
var
  uA, uColunas: Integer;
begin
     // Para a quantidade de 15 bolas, haverá 5 colunas, pois, estamos
     // relacionando, as colunas de 15 da tabela agregada, com os dados
     // do concurso relacionados.
     // As bolas acima da quantidade de 15 bolas, não é possível fazer o relacionamento
     // por este motivo, haverá 4 colunas:
     // Para o controle de 15 bolas, haverá 8 colunas:
     // diag_1, diag_2, diag_3, diag_4, diag_5, ltf_qt, res_qt, marcar.
     // e para o controle de 16, 17 ou 18 bolas, haverá 7 colunas:
     // diag_1, diag_2, diag_3, diag_4, diag_5, ltf_qt, marcar.

    uColunas := 7;
    objControle.Columns.Clear;
    while uColunas > 0 do begin
        objControle.Columns.Add;
        Dec(uColunas);
    end;

    // Se o controle é de 15 bolas, devemos acrescentar mais uma coluna.
    if objControle = sgrDiagonal15Bolas then begin
       objControle.Columns.Add;
    end;

    // Define as colunas diag_1, diag_2, diag_3, diag_4, diag_5
    for uA := 1 to 5 do begin
      objControle.Columns[uA - 1].Title.Alignment := TAlignment.taCenter;
      objControle.Columns[uA - 1].Title.Caption := 'dg_' + IntToStr(uA);
      objControle.Columns[uA - 1].Alignment := TAlignment.taCenter;
    end;

    // Define a coluna ltf_qt
    objControle.Columns[5].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[5].Title.Caption := 'ltf_qt';
    objControle.Columns[5].Alignment := TAlignment.taCenter;

    // Se o controle é sgrDiagonal15Bolas, então, haverá 2 colunas.
    if objControle = sgrDiagonal15Bolas then begin
      objControle.Columns[6].Title.Alignment := TAlignment.taCenter;
      objControle.Columns[6].Title.Caption := 'res_qt';
      objControle.Columns[6].Alignment := TAlignment.taCenter;

      objControle.Columns[7].Title.Alignment := TAlignment.taCenter;
      objControle.Columns[7].Title.Caption := 'Marcar';
      objControle.Columns[7].Alignment := TAlignment.taCenter;
    end else begin
      objControle.Columns[6].Title.Alignment := TAlignment.taCenter;
      objControle.Columns[6].Title.Caption := 'Marcar';
      objControle.Columns[6].Alignment := TAlignment.taCenter;
    end;

    objControle.RowCount := 1;
    objControle.FixedRows := 1;
end;

procedure TForm1.CarregarFrequencia;
begin
  ConfigurarControleFrequencia;
  ConfigurarControleFrequenciaCombinacao;
  CarregarFrequencia('');
  AtualizarFrequencia;
end;

{
 Toda vez que o usuário alterar o valor das caixas de combinação:
 cmbFrequenciaInicio e/ou cmbFrequenciaFim, devemos atualizar o controle
 sgrFrequencia
 }
procedure TForm1.AtualizarFrequencia;
var
  concursoInicio: string;
  concursoFim , strSql: string;
begin
  concursoInicio := cmbFrequenciaInicio.Items[cmbFrequenciaInicio.ItemIndex];
  concursoFim := cmbFrequenciaFim.Items[cmbFrequenciaFim.ItemIndex];

  if StrToInt(concursoInicio)  > StrToInt(concursoFim) then begin
     MessageDlg('', 'Concurso de início deve ser menor que concurso fim',
                    TMsgDlgType.mtError, [mbOk], 0);
     exit;
  end;

  strSql := 'where concurso >= ' + concursoInicio + ' and ';
  strSql := strSQl + 'concurso <= ' + concursoFim;
  CarregarFrequencia(strSql);
end;

procedure TForm1.CarregarFrequencia(strSqlWhere : string);
var
   strSql : TStringList;
   qtRegistros , uLinha, uA: Integer;
   sqlConcurso : TSqlQuery;
begin
  strSql := TStringList.Create;
  strSql.Add('Select * from lotofacil_resultado_frequencia');
  // Não iremos validar o sqlSqlWhere.
  strSql.Add(strSqlWhere);
  strSql.Add('order by concurso');

  if dmLotofacil = nil then begin
     dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlConcurso := dmLotofacil.sqlLotofacil;
  sqlConcurso.Active := false;
  sqlConcurso.DataBase := dmLotofacil.pgLtk;
  sqlConcurso.SQL.Text := strSql.Text;
  sqlConcurso.UniDirectional := false;
  sqlConcurso.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlConcurso.First;
  while not sqlConcurso.Eof do begin
      Inc(qtRegistros);
      sqlConcurso.Next;
  end;

  if qtRegistros = 0 then begin
     exit;
  end;

  // Vamos alterar a quantidade de linhas do stringGrid.
  // Haverá 1 linha a mais.
  sgrFrequencia.RowCount := qtRegistros + 1;

  // Vamos inserir os registros.
  sqlConcurso.First;

  // Definir os rótulos da linha 0.
  sgrFrequencia.Cells[0, 0] := 'Concurso';
  for uA := 1 to 25 do begin
      sgrFrequencia.Cells[uA, 0] := IntToStr(uA);
  end;

  // A linha 0, é o título da stringGrid.
  uLinha := 1;
  while not sqlConcurso.Eof do begin
      // Insere o concurso na coluna 1.
      sgrFrequencia.Cells[0, uLinha] := sqlConcurso.FieldByName('concurso').AsString;

      // Aqui, como as colunas 'num_' terminar em número, iremos concatenar pra
      // pegar os nomes dos campos.
      for uA := 1 to 25 do begin
          sgrFrequencia.Cells[uA, uLinha] := sqlConcurso.FieldByName('num_' + IntToStr(uA)).AsString;
      end;

      // Move para o próximo registro e incrementa a linha.
      sqlConcurso.Next;
      Inc(uLinha);
  end;

  // Vamos ajustar as colunas ao contéudo.
  sgrFrequencia.AutoSizeColumns;
end;

{
 Este procedure gera os concursos que estarão inseridos na caixa de combinação:
 cmbFrequenciaInicio e cmbFrequenciaFim
 }
procedure TForm1.ConfigurarControleFrequenciaCombinacao;
var
  strSql: string;
  sqlConcurso: TSqlQuery;
  qtRegistros: Integer;
begin
  strSql := 'Select * from v_lotofacil_concurso_todos order by concurso';

  if dmLotofacil = nil then begin
     dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlConcurso := dmLotofacil.sqlLotofacil;
  sqlConcurso.Active := false;
  sqlConcurso.DataBase := dmLotofacil.pgLtk;
  sqlConcurso.SQL.Text := strSql;
  sqlConcurso.UniDirectional := false;
  sqlConcurso.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlConcurso.First;
  while not sqlConcurso.Eof do begin
      Inc(qtRegistros);
      sqlConcurso.Next;
  end;

  if qtRegistros = 0 then begin
     exit;
  end;

  // Apaga os ítens do combobox.
  cmbFrequenciaInicio.Items.Clear;
  cmbFrequenciaFim.Items.Clear;


  // Se encontrarmos registros, inserir.
  sqlConcurso.First;
  while not sqlConcurso.Eof do begin
      // Aqui, o controle 'cmbFrequenciaInicio' terá as bolas começando em ordem crescente.
      cmbFrequenciaInicio.Items.Add(sqlConcurso.FieldByName('concurso').AsString);
      // Aqui, iremos inserir os concursos em ordem descrescente.
      cmbFrequenciaFim.Items.Insert(0, sqlConcurso.FieldByName('concurso').AsString);
      // Ir para o próximo registro.
      sqlConcurso.Next;
  end;

  cmbFrequenciaInicio.ItemIndex := qtRegistros - 10;
  cmbFrequenciaFim.ItemIndex := 0;
end;

{
 Este procedimento serve para configurar o controle 'sgrFrequencia' da guia 'Frequencia'
 }
procedure TForm1.ConfigurarControleFrequencia;
var
  uColunas, uA: Integer;
begin
  // Haverá 26 colunas.
  // Vamos apagar todas as colunas.
  sgrFrequencia.Columns.Clear;
  uColunas := 26;
  while uColunas > 0 do begin
      sgrFrequencia.Columns.Add;
      Dec(uColunas);
  end;

  sgrFrequencia.Columns[0].Alignment := TAlignment.taCenter;
  sgrFrequencia.Columns[0].Title.Caption := 'Concurso';
  sgrFrequencia.Columns[0].Title.Alignment := TAlignment.taCenter;

  for uA := 1 to 25 do begin
      sgrFrequencia.Columns[uA].Alignment := TAlignment.taCenter;
      sgrFrequencia.Columns[uA].Title.Caption := 'B_' + IntToStr(uA);
      sgrFrequencia.Columns[uA].Title.Alignment := TAlignment.taCenter;
  end;
  sgrFrequencia.FixedCols := 0;
  sgrFrequencia.FixedRows := 1;
end;

{
    Esta função gera a clausula where, conforme o controle é clicado.
    Ou seja, o controle se atualizará baseado nos valores clicados.
    }
procedure TForm1.GerarSqlColuna_B(objControle : TStringGrid);
var
  strSql: String;
  ultimaColuna : LongInt;
  uA : Integer;
begin
  strSql := '';

  if objControle = sgrColunaB1_15Bolas then begin
     // Apaga os outros controles.
     sgrColunaB1_B15_15Bolas.Columns.Clear;
     sgrColunaB1_B8_B15_15Bolas.Columns.Clear;
     sgrColunaB1_B4_B8_B12_B15_15Bolas.Columns.Clear;

     // Colunas: b_1, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_15Bolas.RowCount -1 do begin
         if sgrColunaB1_15Bolas.Cells[3, uA] = '1' then begin
            if strSql <> '' then begin
              strSql := strSql + ','
            end;
            strSql := strSql + sgrColunaB1_15Bolas.Cells[0, uA];
         end;
     end;

     if strSql <> '' then begin
        // Insere a clausula where
        strSql := 'where b_1 in (' + strSql + ')';
        CarregarColuna_B(sgrColunaB1_B15_15Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_B15_15Bolas then begin
      // Apaga os outros controles.
    sgrColunaB1_B8_B15_15Bolas.Columns.Clear;
    sgrColunaB1_B4_B8_B12_B15_15Bolas.Columns.Clear;

    // Colunas: b_1, b_15, cmb_b1_b15, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_B15_15Bolas.RowCount -1  do begin
        // Se é 1, quer dizer que o usuário selecionou a opção.
        if sgrColunaB1_B15_15Bolas.Cells[5, uA] = '1' then begin
           // Se há mais de um argumento, então devemos interseparar com vírgula.
           if strSql <> '' then begin
              strSql := strSql + ',';
           end;
           // Iremos pegar a coluna cmb_b1_b15, devemos colocar entre aspas simples
           // pois é um string, é a terceira coluna
           strSql := strSql + QuotedStr(sgrColunaB1_B15_15Bolas.Cells[2, uA]);
        end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo.
    if strSql <> '' then begin
       // Insere a claúsula where.
       // Neste caso, iremos concatenar os campos b_1 e b_15, e interseparar com
       // sublinhado,
       strSql := 'where b_1 || ''_'' || b_15 in (' + strSql + ')';
       WriteLn(strSql);
       CarregarColuna_B(sgrColunaB1_B8_B15_15Bolas, strSql);
    end;
  end else if objControle = sgrColunaB1_B8_B15_15Bolas then begin
     // Apaga outros controles.
     sgrColunaB1_B4_B8_B12_B15_15Bolas.Columns.Clear;

     // Coluns: b1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_B8_B15_15Bolas.RowCount - 1 do begin
         // Se é 1, quer dizer, que o usuário selecionou a opção.
         if sgrColunaB1_B8_B15_15Bolas.Cells[6, uA] = '1' then begin
             // Se há mais de um argumento, devemos interseparar com vírgula.
             if strSql <> '' then begin
                 strSql := strSql + ',';
             end;
             // Iremos pegar a coluna cmb_b1_b8_b15, devemos colocar entre aspas simples
             // pois é um string, é a quarta coluna.
             strSql := strSql + QuotedStr(sgrColunaB1_B8_B15_15Bolas.Cells[3, uA]);
         end;
     end;

     // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
     // pelo usuário.
     if strSql <> '' then begin
         // Insere a claúsula where.
         // Neste caso, iremos concatenar os campos b_1, b_8 e b_15 e interseparar
         // com sublinhado:
         strSql := 'where b_1 || ''_'' || b_8 || ''_'' || b_15 in (' + strSql + ')';
         WriteLn(strSql);
         CarregarColuna_B(sgrColunaB1_B4_B8_B12_B15_15Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_16Bolas then begin
     // Apaga os outros controles.
     sgrColunaB1_B15_16Bolas.Columns.Clear;
     sgrColunaB1_B8_B15_16Bolas.Columns.Clear;
     sgrColunaB1_B4_B8_B12_B15_16Bolas.Columns.Clear;

     // Colunas: b_1, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_16Bolas.RowCount -1 do begin
         if sgrColunaB1_16Bolas.Cells[3, uA] = '1' then begin
            if strSql <> '' then begin
              strSql := strSql + ','
            end;
            strSql := strSql + sgrColunaB1_16Bolas.Cells[0, uA];
         end;
     end;

     if strSql <> '' then begin
        // Insere a clausula where
        strSql := 'where b_1 in (' + strSql + ')';
        CarregarColuna_B(sgrColunaB1_B15_16Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_B15_16Bolas then begin
      // Apaga os outros controles.
    sgrColunaB1_B8_B15_16Bolas.Columns.Clear;
    sgrColunaB1_B4_B8_B12_B15_16Bolas.Columns.Clear;

    // Colunas: b_1, b_15, cmb_b1_b15, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_B15_16Bolas.RowCount -1  do begin
        // Se é 1, quer dizer que o usuário selecionou a opção.
        if sgrColunaB1_B15_16Bolas.Cells[5, uA] = '1' then begin
           // Se há mais de um argumento, então devemos interseparar com vírgula.
           if strSql <> '' then begin
              strSql := strSql + ',';
           end;
           // Iremos pegar a coluna cmb_b1_b15, devemos colocar entre aspas simples
           // pois é um string, é a terceira coluna
           strSql := strSql + QuotedStr(sgrColunaB1_B15_16Bolas.Cells[2, uA]);
        end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo.
    if strSql <> '' then begin
       // Insere a claúsula where.
       // Neste caso, iremos concatenar os campos b_1 e b_15, e interseparar com
       // sublinhado,
       strSql := 'where b_1 || ''_'' || b_15 in (' + strSql + ')';
       WriteLn(strSql);
       CarregarColuna_B(sgrColunaB1_B8_B15_16Bolas, strSql);
    end;
  end else if objControle = sgrColunaB1_B8_B15_16Bolas then begin
     // Apaga outros controles.
     sgrColunaB1_B4_B8_B12_B15_16Bolas.Columns.Clear;

     // Coluns: b1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_B8_B15_16Bolas.RowCount - 1 do begin
         // Se é 1, quer dizer, que o usuário selecionou a opção.
         if sgrColunaB1_B8_B15_16Bolas.Cells[6, uA] = '1' then begin
             // Se há mais de um argumento, devemos interseparar com vírgula.
             if strSql <> '' then begin
                 strSql := strSql + ',';
             end;
             // Iremos pegar a coluna cmb_b1_b8_b15, devemos colocar entre aspas simples
             // pois é um string, é a quarta coluna.
             strSql := strSql + QuotedStr(sgrColunaB1_B8_B15_16Bolas.Cells[3, uA]);
         end;
     end;

     // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
     // pelo usuário.
     if strSql <> '' then begin
         // Insere a claúsula where.
         // Neste caso, iremos concatenar os campos b_1, b_8 e b_15 e interseparar
         // com sublinhado:
         strSql := 'where b_1 || ''_'' || b_8 || ''_'' || b_15 in (' + strSql + ')';
         WriteLn(strSql);
         CarregarColuna_B(sgrColunaB1_B4_B8_B12_B15_16Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_17Bolas then begin
     // Apaga os outros controles.
     sgrColunaB1_B15_17Bolas.Columns.Clear;
     sgrColunaB1_B8_B15_17Bolas.Columns.Clear;
     sgrColunaB1_B4_B8_B12_B15_17Bolas.Columns.Clear;

     // Colunas: b_1, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_17Bolas.RowCount -1 do begin
         if sgrColunaB1_17Bolas.Cells[3, uA] = '1' then begin
            if strSql <> '' then begin
              strSql := strSql + ','
            end;
            strSql := strSql + sgrColunaB1_17Bolas.Cells[0, uA];
         end;
     end;

     if strSql <> '' then begin
        // Insere a clausula where
        strSql := 'where b_1 in (' + strSql + ')';
        CarregarColuna_B(sgrColunaB1_B15_17Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_B15_17Bolas then begin
      // Apaga os outros controles.
    sgrColunaB1_B8_B15_17Bolas.Columns.Clear;
    sgrColunaB1_B4_B8_B12_B15_17Bolas.Columns.Clear;

    // Colunas: b_1, b_15, cmb_b1_b15, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_B15_17Bolas.RowCount -1  do begin
        // Se é 1, quer dizer que o usuário selecionou a opção.
        if sgrColunaB1_B15_17Bolas.Cells[5, uA] = '1' then begin
           // Se há mais de um argumento, então devemos interseparar com vírgula.
           if strSql <> '' then begin
              strSql := strSql + ',';
           end;
           // Iremos pegar a coluna cmb_b1_b15, devemos colocar entre aspas simples
           // pois é um string, é a terceira coluna
           strSql := strSql + QuotedStr(sgrColunaB1_B15_17Bolas.Cells[2, uA]);
        end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo.
    if strSql <> '' then begin
       // Insere a claúsula where.
       // Neste caso, iremos concatenar os campos b_1 e b_15, e interseparar com
       // sublinhado,
       strSql := 'where b_1 || ''_'' || b_15 in (' + strSql + ')';
       WriteLn(strSql);
       CarregarColuna_B(sgrColunaB1_B8_B15_17Bolas, strSql);
    end;
  end else if objControle = sgrColunaB1_B8_B15_17Bolas then begin
     // Apaga outros controles.
     sgrColunaB1_B4_B8_B12_B15_17Bolas.Columns.Clear;

     // Coluns: b1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_B8_B15_17Bolas.RowCount - 1 do begin
         // Se é 1, quer dizer, que o usuário selecionou a opção.
         if sgrColunaB1_B8_B15_17Bolas.Cells[6, uA] = '1' then begin
             // Se há mais de um argumento, devemos interseparar com vírgula.
             if strSql <> '' then begin
                 strSql := strSql + ',';
             end;
             // Iremos pegar a coluna cmb_b1_b8_b15, devemos colocar entre aspas simples
             // pois é um string, é a quarta coluna.
             strSql := strSql + QuotedStr(sgrColunaB1_B8_B15_17Bolas.Cells[3, uA]);
         end;
     end;

     // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
     // pelo usuário.
     if strSql <> '' then begin
         // Insere a claúsula where.
         // Neste caso, iremos concatenar os campos b_1, b_8 e b_15 e interseparar
         // com sublinhado:
         strSql := 'where b_1 || ''_'' || b_8 || ''_'' || b_15 in (' + strSql + ')';
         WriteLn(strSql);
         CarregarColuna_B(sgrColunaB1_B4_B8_B12_B15_17Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_18Bolas then begin
     // Apaga os outros controles.
     sgrColunaB1_B15_18Bolas.Columns.Clear;
     sgrColunaB1_B8_B15_18Bolas.Columns.Clear;
     sgrColunaB1_B4_B8_B12_B15_18Bolas.Columns.Clear;

     // Colunas: b_1, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_18Bolas.RowCount -1 do begin
         if sgrColunaB1_18Bolas.Cells[3, uA] = '1' then begin
            if strSql <> '' then begin
              strSql := strSql + ','
            end;
            strSql := strSql + sgrColunaB1_18Bolas.Cells[0, uA];
         end;
     end;

     if strSql <> '' then begin
        // Insere a clausula where
        strSql := 'where b_1 in (' + strSql + ')';
        CarregarColuna_B(sgrColunaB1_B15_18Bolas, strSql);
     end;
  end else if objControle = sgrColunaB1_B15_18Bolas then begin
      // Apaga os outros controles.
    sgrColunaB1_B8_B15_18Bolas.Columns.Clear;
    sgrColunaB1_B4_B8_B12_B15_18Bolas.Columns.Clear;

    // Colunas: b_1, b_15, cmb_b1_b15, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_B15_18Bolas.RowCount -1  do begin
        // Se é 1, quer dizer que o usuário selecionou a opção.
        if sgrColunaB1_B15_18Bolas.Cells[5, uA] = '1' then begin
           // Se há mais de um argumento, então devemos interseparar com vírgula.
           if strSql <> '' then begin
              strSql := strSql + ',';
           end;
           // Iremos pegar a coluna cmb_b1_b15, devemos colocar entre aspas simples
           // pois é um string, é a terceira coluna
           strSql := strSql + QuotedStr(sgrColunaB1_B15_18Bolas.Cells[2, uA]);
        end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo.
    if strSql <> '' then begin
       // Insere a claúsula where.
       // Neste caso, iremos concatenar os campos b_1 e b_15, e interseparar com
       // sublinhado,
       strSql := 'where b_1 || ''_'' || b_15 in (' + strSql + ')';
       WriteLn(strSql);
       CarregarColuna_B(sgrColunaB1_B8_B15_18Bolas, strSql);
    end;
  end else if objControle = sgrColunaB1_B8_B15_18Bolas then begin
     // Apaga outros controles.
     sgrColunaB1_B4_B8_B12_B15_18Bolas.Columns.Clear;

     // Coluns: b1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt, marcar.
     for uA := 1 to sgrColunaB1_B8_B15_18Bolas.RowCount - 1 do begin
         // Se é 1, quer dizer, que o usuário selecionou a opção.
         if sgrColunaB1_B8_B15_18Bolas.Cells[6, uA] = '1' then begin
             // Se há mais de um argumento, devemos interseparar com vírgula.
             if strSql <> '' then begin
                 strSql := strSql + ',';
             end;
             // Iremos pegar a coluna cmb_b1_b8_b15, devemos colocar entre aspas simples
             // pois é um string, é a quarta coluna.
             strSql := strSql + QuotedStr(sgrColunaB1_B8_B15_18Bolas.Cells[3, uA]);
         end;
     end;

     // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
     // pelo usuário.
     if strSql <> '' then begin
         // Insere a claúsula where.
         // Neste caso, iremos concatenar os campos b_1, b_8 e b_15 e interseparar
         // com sublinhado:
         strSql := 'where b_1 || ''_'' || b_8 || ''_'' || b_15 in (' + strSql + ')';
         WriteLn(strSql);
         CarregarColuna_B(sgrColunaB1_B4_B8_B12_B15_18Bolas, strSql);
     end;
  end;


end;

procedure TForm1.CarregarColuna_B;
begin
  CarregarColuna_B(sgrColunaB1_15Bolas, '');
  CarregarColuna_B(sgrColunaB1_16Bolas, '');
  CarregarColuna_B(sgrColunaB1_17Bolas, '');
  CarregarColuna_B(sgrColunaB1_18Bolas, '');
end;

procedure TForm1.ConfigurarControlesBolas_B;
begin
  ConfigurarControlesBolas_B(sgrColunaB1_15Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B15_15Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B8_B15_15Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B4_B8_B12_B15_15Bolas);

  ConfigurarControlesBolas_B(sgrColunaB1_16Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B15_16Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B8_B15_16Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B4_B8_B12_B15_16Bolas);

  ConfigurarControlesBolas_B(sgrColunaB1_17Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B15_17Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B8_B15_17Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B4_B8_B12_B15_17Bolas);

  ConfigurarControlesBolas_B(sgrColunaB1_18Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B15_18Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B8_B15_18Bolas);
  ConfigurarControlesBolas_B(sgrColunaB1_B4_B8_B12_B15_18Bolas);

end;

{
 Este procedimento configura todos os controles stringGrid da guia 'Bolas nas Colunas'
 Um único procedimento configura todos os controles.
 }
procedure TForm1.ConfigurarControlesBolas_B(objControle: TStringGrid);
var
  qtColunas : Integer;
  uA : Integer;
begin
  qtColunas := 0;

  // Os controles de 15 bolas, tem uma coluna a mais devemos fazer separados.
  // Colunas: B_1, LTF_QT, RES_QT, MARCAR.
  if (objControle = sgrColunaB1_15Bolas) or
     (objControle = sgrColunaB1_16Bolas) or
     (objControle = sgrColunaB1_17Bolas) or
     (objControle = sgrColunaB1_18Bolas)
  then begin
    qtColunas := 4;

  // Colunas: B_1, B_15, CMB_B1_B15 LTF_QT, RES_QT, MARCAR.
  end else if (objControle = sgrColunaB1_B15_15Bolas) or
      (objControle = sgrColunaB1_B15_16Bolas) or
      (objControle = sgrColunaB1_B15_17Bolas) or
      (objControle = sgrColunaB1_B15_18Bolas)
  then begin
    qtColunas := 6;

  // Colunas: B_1, B_8, B_15, cmb_b1_b8_b15, LTF_QT, RES_QT, MARCAR.
  end else if (objControle = sgrColunaB1_B8_B15_15Bolas) or
      (objControle = sgrColunaB1_B8_B15_16Bolas) or
      (objControle = sgrColunaB1_B8_B15_17Bolas) or
      (objControle = sgrColunaB1_B8_B15_18Bolas)
  then begin
    qtColunas := 7;

  // Colunas: B_1, B_4, B_8, B_12, B_15, cmb_b1_b4_b8_b12_b15, LTF_QT, RES_QT, MARCAR.
  end else if (objControle = sgrColunaB1_B4_B8_B12_B15_15Bolas) or
      (objControle = sgrColunaB1_B4_B8_B12_B15_16Bolas) or
      (objControle = sgrColunaB1_B4_B8_B12_B15_17Bolas) or
      (objControle = sgrColunaB1_B4_B8_B12_B15_18Bolas)
  then begin
    qtColunas := 9;
  end;


  // Adiciona colunas para podermos criar títulos.
  objControle.Columns.Clear;
  for uA := 1 to qtColunas do begin
      objControle.Columns.Add;
  end;

  // Centraliza título e coluna das células
  // Devemos começar do 0, pois, o índice das colunas é baseado em zero.
  for uA := 0 to qtColunas - 1 do begin
    objControle.Columns[uA].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
  end;

   case qtColunas of
        4:
          begin
            objControle.Columns[0].Title.Caption := 'B_1';
            objControle.Columns[1].Title.Caption := 'Ltf_qt';
            objControle.Columns[2].Title.Caption := 'res_qt';
            objControle.Columns[3].Title.Caption := 'Marcar';
            objControle.Columns[3].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;
          end;
        6:
          begin
            objControle.Columns[0].Title.Caption := 'B_1';
            objControle.Columns[1].Title.Caption := 'B_15';

            objControle.Columns[2].Title.Caption := 'CMB_B1_B15';
            objControle.Columns[2].Visible := false;

            objControle.Columns[3].Title.Caption := 'Ltf_qt';
            objControle.Columns[4].Title.Caption := 'res_qt';

            objControle.Columns[5].Title.Caption := 'Marcar';
            objControle.Columns[5].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;
          end;
          7:
            begin
              objControle.Columns[0].Title.Caption := 'B_1';
              objControle.Columns[1].Title.Caption := 'B_8';
              objControle.Columns[2].Title.Caption := 'B_15';

              objControle.Columns[3].Title.Caption := 'CMB_B1_B8_B15';
              objControle.Columns[3].Visible := false;

              objControle.Columns[4].Title.Caption := 'Ltf_qt';
              objControle.Columns[5].Title.Caption := 'res_qt';

              objControle.Columns[6].Title.Caption := 'Marcar';
              objControle.Columns[6].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;
            end;
            9:
            begin
              objControle.Columns[0].Title.Caption := 'B_1';
              objControle.Columns[1].Title.Caption := 'B_4';
              objControle.Columns[2].Title.Caption := 'B_8';
              objControle.Columns[3].Title.Caption := 'B_12';
              objControle.Columns[4].Title.Caption := 'B_15';

              objControle.Columns[5].Title.Caption := 'CMB_B1_B8_B15';
              objControle.Columns[5].Visible := false;

              objControle.Columns[6].Title.Caption := 'Ltf_qt';
              objControle.Columns[7].Title.Caption := 'res_qt';

              objControle.Columns[8].Title.Caption := 'Marcar';
              objControle.Columns[8].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;
            end;
   end;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;

  // Deixa somente uma linha, a do título.
  objControle.RowCount := 1;
  objControle.AutoSizeColumns;
end;

{
 Iremos fazer, dois procedimentos para carregar as colunas_b
 Um será para os controles da coluna B_1, pois inicialmente estes controles
 exibirão os dados da tabela, então, se o usuário clicar em uma das células,
 o próximo controle será carregado, baseado, no valor selecionado.
 Então, o controle b1, for clicado, preenche-se o controle b1_b15.
 Se o controle b1_b15, é clicado, preenche o controle b1_b8_b15.
 Se o controle b1_b8_b15, for clicado, preenche-se o controle b1_b4_b8_b12_b15.
 Então, ao analisar os controles, pra gerar o sql, será baseado o controle que
 tem a mais colunas selecionados, então será nesta ordem:
 b1_b4_b8_b12_b15;
 b1_b8_b15;
 b1_b15;
 b1
 Se o usuário desmarcar todos as opções do controle b1, nenhum sql, será baseado
 nestes campos.
 }
procedure TForm1.CarregarColuna_B(objControle: TStringGrid; strSql: string);
var
  sqlTemp : TStringList;
  qtRegistros : LongInt;
  dsLotofacil : TSqlQuery;
  uLinha , uA: Integer;
begin
  sqlTemp := TStringList.Create;

  ConfigurarControlesBolas_B(objControle);

  // Para os controles de 'Bolas nas Colunas', os controles de 15 Bolas:
  // sgrColunaB1_15Bolas, sgrColunaB1_B15_15Bolas, sgrColunaB1_B8_B15_15Bolas
  // e sgrColunaB1_B4_B8_B12_B15_15Bolas, devemos implementar o sql separadamente.
  // Pois, eles tem 1 campos a mais, indicando a quantidade de combinações que
  // já saíram na lotofacil de 15 números.
  if objControle = sgrColunaB1_15Bolas then begin
    sqlTemp.Add('Select b_1, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_15Bolas');
  end else if objControle = sgrColunaB1_B15_15Bolas then begin
    sqlTemp.Add('Select b_1, b_15, cmb_b1_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b15_15Bolas');
  end else if objControle = sgrColunaB1_B8_B15_15Bolas then begin
    sqlTemp.Add('Select b_1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b8_b15_15Bolas');
  end else if objControle = sgrColunaB1_B4_B8_B12_B15_15Bolas then begin
    sqlTemp.Add('Select b_1, b_4, b_8, b_12, b_15, cmb_b1_b4_b8_b12_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b4_b8_b12_b15_15Bolas');
    // 16 bolas
  end else if objControle = sgrColunaB1_16Bolas then begin
    sqlTemp.Add('Select b_1, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_16Bolas');
  end else if objControle = sgrColunaB1_B15_16Bolas then begin
    sqlTemp.Add('Select b_1, b_15, cmb_b1_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b15_16Bolas');
  end else if objControle = sgrColunaB1_B8_B15_16Bolas then begin
    sqlTemp.Add('Select b_1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b8_b15_16Bolas');
  end else if objControle = sgrColunaB1_B4_B8_B12_B15_16Bolas then begin
    sqlTemp.Add('Select b_1, b_4, b_8, b_12, b_15, cmb_b1_b4_b8_b12_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b4_b8_b12_b15_16Bolas');
    // 17 bolas.
  end else if objControle = sgrColunaB1_17Bolas then begin
    sqlTemp.Add('Select b_1, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_17Bolas');
  end else if objControle = sgrColunaB1_B15_17Bolas then begin
    sqlTemp.Add('Select b_1, b_15, cmb_b1_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b15_17Bolas');
  end else if objControle = sgrColunaB1_B8_B15_17Bolas then begin
    sqlTemp.Add('Select b_1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b8_b15_17Bolas');
  end else if objControle = sgrColunaB1_B4_B8_B12_B15_17Bolas then begin
    sqlTemp.Add('Select b_1, b_4, b_8, b_12, b_15, cmb_b1_b4_b8_b12_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b4_b8_b12_b15_17Bolas');
    // 18 bolas.
  end else  if objControle = sgrColunaB1_18Bolas then begin
    sqlTemp.Add('Select b_1, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_18Bolas');
  end else if objControle = sgrColunaB1_B15_18Bolas then begin
    sqlTemp.Add('Select b_1, b_15, cmb_b1_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b15_18Bolas');
  end else if objControle = sgrColunaB1_B8_B15_18Bolas then begin
    sqlTemp.Add('Select b_1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b8_b15_18Bolas');
  end else if objControle = sgrColunaB1_B4_B8_B12_B15_18Bolas then begin
    sqlTemp.Add('Select b_1, b_4, b_8, b_12, b_15, cmb_b1_b4_b8_b12_b15, ltf_qt, res_qt');
    sqlTemp.Add('from ltk.v_lotofacil_resultado_b1_b4_b8_b12_b15_18Bolas');
  end;

  // Se houver algum string sql passado, devemos adicionar
  if strSql <> '' then begin
    sqlTemp.Add(strSql);
  end;

  // Ordenar pela coluna de resultado.
  sqlTemp.Add('order by res_qt desc, ltf_qt desc');

  // Verifica se o módulo está instanciado.
  if dmLotofacil = nil then begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // Agora, verificar se tem um módulo
  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := sqlTemp.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := false;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  qtRegistros := 0;
  dsLotofacil.First;
  while not dsLotofacil.Eof do begin
      Inc(qtRegistros);
      dsLotofacil.Next;
  end;

  if qtRegistros = 0 then
  begin
    objControle.ColCount := 1;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  // Dimensiona o número de linhas
  objControle.RowCount := qtRegistros + 1;

  // Agora, vamos gravar no controle.
  uLinha := 1;
  dsLotofacil.First;
  while not dsLotofacil.Eof do begin
      uA := 0;
      for uA := 0 to dsLotofacil.FieldCount - 1 do begin
          objControle.Cells[uA, uLinha] := dsLotofacil.Fields[uA].AsString;
      end;
      objControle.Cells[dsLotofacil.FieldCount, uLinha] := '0';
      Inc(uLinha);
      dsLotofacil.Next;
  end;

  // Insere o nome dos campos na fileira 0.
  for uA := 0 to dsLotofacil.FieldCount-1 do begin
      objControle.Cells[uA, 0] := dsLotofacil.Fields[uA].Name;
  end;
  objControle.Cells[uA, 0] := 'Marcar';


  objControle.AutoSizeColumns;
end;




procedure TForm1.CarregarExternoInterno;
begin
  CarregarExternoInterno(sgrExternoInterno15Bolas);
  CarregarExternoInterno(sgrExternoInterno16Bolas);
  CarregarExternoInterno(sgrExternoInterno17Bolas);
  CarregarExternoInterno(sgrExternoInterno18Bolas);
end;

procedure TForm1.ConfigurarControlesExternoInterno(objControle: TStringGrid);
var
  qtColunas : Integer;
begin
  // Nos controles novos e repetidos, o controle strNovosRepetidos15Bolas terá
  // uma coluna a mais pois ele compara a combinação de 15 bolas, com todos os
  // resultados dos concursos que saíram.
  if objControle = sgrExternoInterno15Bolas then begin
     qtColunas := 5;
  end else begin
     qtColunas := 4;
  end;

  // Nos controles stringGrid, devemos criar títulos, se queremos configurar
  // as colunas, como por exemplo, centralizá-la.
  while qtColunas > 0 do begin
    objControle.Columns.Add;
    dec(qtColunas);
  end;

  // Vamos configurar as 3 colunas, que são comuns, nos 4 controles.
  objControle.Columns[0].Title.Alignment := TAlignment.taCenter;
  objControle.Columns[1].Title.Alignment := TAlignment.taCenter;
  objControle.Columns[2].Title.Alignment := TAlignment.taCenter;

  objControle.Columns[0].Alignment := TAlignment.taCenter;
  objControle.Columns[1].Alignment := TAlignment.taCenter;
  objControle.Columns[2].Alignment := TAlignment.taCenter;

  objControle.Columns[0].Title.Caption := 'Ext.';
  objControle.Columns[1].Title.Caption := 'Int.';
  objControle.Columns[2].Title.Caption := 'Ltf_qt';

  // Irei colocar na linha 0 o nome da coluna, embora, já foi feito isto nas colunas
  // indicada acima, isto servirá pra identificar a coluna, dentro do método:
  // AlterarMarcador.
  objControle.Cells[0,0] := 'Externo';
  objControle.Cells[1,0] := 'Interno';
  objControle.Cells[2,0] := 'Ltf_qt';

  // Agora, vamos configurar as outras colunas baseado em qual controle é.
  if objControle = sgrExternoInterno15Bolas then begin
    objControle.Columns[3].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[3].Title.Caption := 'Res_qt';
    objControle.Columns[3].Alignment := TAlignment.taCenter;

    objControle.Columns[4].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[4].Title.Caption := 'Marcar';
    objControle.Columns[4].Alignment := TAlignment.taCenter;

    // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
    // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
    objControle.Columns[4].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Embora, as colunas tem nomes de títulos, devemos definir os nomes
    // de todas as células da linha 0, pois, iremos utilizar pra identificar se
    // a coluna selecionar, é a coluna marcar.
    objControle.Cells[3, 0] := 'Res_qt';
    objControle.Cells[4, 0] := 'Marcar';
  end else begin
    objControle.Columns[3].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[3].Title.Caption := 'Marcar';
    objControle.Columns[3].Alignment := TAlignment.taCenter;

    // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
    // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
    objControle.Columns[3].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Embora, as colunas tem nomes de títulos, devemos definir os nomes
    // de todas as células da linha 0, pois, iremos utilizar pra identificar se
    // a coluna selecionar, é a coluna marcar.
    objControle.Cells[3, 0] := 'Marcar';
  end;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

{
 Este procedimento carregar as informações que estão no banco de dados
 e armazena nos controles:
 sgrNovosRepetidos15Bolas,
 sgrNovosRepetidos16Bolas,
 sgrNovosRepetidos17Bolas,
 sgrNovosRepetidos18Bolas.
 Entretanto, cada controle, tem um sql diferente, nos controles de 16, 17 e 18
 bolas, praticamente, o sql altera indicando qual a quantidade de bolas.
 Então, o sql será criado dinamicamente conforme o controle selecionado.
 }
procedure TForm1.CarregarExternoInterno(objControle: TStringGrid);
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha: integer;
  qtRegistros : LongInt;
begin
  // Inicia o módulo de dados.
  dmLotofacil := TdmLotofacil.Create(Self);

  strSql := TStringList.Create;

  if objControle = sgrExternoInterno15Bolas then begin
    strSql.add('Select externo, interno, ltf_qt, res_qt from');
    strSql.add('ltk.v_lotofacil_resultado_externo_interno');
    strSql.add('order by res_qt desc, ltf_qt desc');
  end else if objControle = sgrExternoInterno16Bolas then begin
    strSql.add('Select externo, interno, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_externo_interno');
    strSql.add(' where qt_bolas = 16');
    strSql.add(' order by qt_vezes desc');
  end else if objControle = sgrExternoInterno17Bolas then begin
    strSql.add('Select externo, interno, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_externo_interno');
    strSql.add(' where qt_bolas = 17');
    strSql.add(' order by qt_vezes desc');
  end else if objControle = sgrExternoInterno18Bolas then begin
    strSql.add('Select externo, interno, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_externo_interno');
    strSql.add(' where qt_bolas = 18');
    strSql.add(' order by qt_vezes desc');
  end;

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := false;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  qtRegistros := 0;
  dsLotofacil.First;
  while not dsLotofacil.Eof do begin
      Inc(qtRegistros);
      dsLotofacil.Next;
  end;

  if qtRegistros = 0 then
  begin
    objControle.ColCount := 1;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;


  // Devemos, 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qtRegistros + 1;

  ConfigurarControlesExternoInterno(objControle);

  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    objControle.Cells[0, uLinha] := dsLotofacil.FieldByName('externo').AsString;
    objControle.Cells[1, uLinha] := IntToStr(dsLotofacil.FieldByName('interno').AsInteger);

    if objControle = sgrExternoInterno15Bolas then begin
      objControle.Cells[2, uLinha] := dsLotofacil.FieldByName('ltf_qt').AsString;
      objControle.Cells[3, uLinha] := dsLotofacil.FieldByName('res_qt').AsString;
      objControle.Cells[4, uLinha] := '0';
    end else begin
      objControle.Cells[2, uLinha] := dsLotofacil.FieldByName('qt_vezes').AsString;
      objControle.Cells[3, uLinha] := '0';
    end;

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;
end;


procedure TForm1.CarregarParImpar;
begin
  CarregarParImpar(sgrParImpar15Bolas);
  CarregarParImpar(sgrParImpar16Bolas);
  CarregarParImpar(sgrParImpar17Bolas);
  CarregarParImpar(sgrParImpar18Bolas);
end;

procedure TForm1.ConfigurarControlesParImpar(objControle: TStringGrid);
var
  qtColunas : Integer;
begin
  // Nos controles novos e repetidos, o controle strNovosRepetidos15Bolas terá
  // uma coluna a mais pois ele compara a combinação de 15 bolas, com todos os
  // resultados dos concursos que saíram.
  if objControle = sgrParImpar15Bolas then begin
     qtColunas := 5;
  end else begin
     qtColunas := 4;
  end;

  // Nos controles stringGrid, devemos criar títulos, se queremos configurar
  // as colunas, como por exemplo, centralizá-la.
  while qtColunas > 0 do begin
    objControle.Columns.Add;
    dec(qtColunas);
  end;

  objControle.ColumnClickSorts := true;

  // Vamos configurar as 3 colunas, que são comuns, nos 4 controles.
  objControle.Columns[0].Title.Alignment := TAlignment.taCenter;
  objControle.Columns[1].Title.Alignment := TAlignment.taCenter;
  objControle.Columns[2].Title.Alignment := TAlignment.taCenter;

  objControle.Columns[0].Alignment := TAlignment.taCenter;
  objControle.Columns[1].Alignment := TAlignment.taCenter;
  objControle.Columns[2].Alignment := TAlignment.taCenter;

  objControle.Columns[0].Title.Caption := 'Par';
  objControle.Columns[1].Title.Caption := 'Impar';
  objControle.Columns[2].Title.Caption := 'Ltf_qt';

  // Irei colocar na linha 0 o nome da coluna, embora, já foi feito isto nas colunas
  // indicada acima, isto servirá pra identificar a coluna, dentro do método:
  // AlterarMarcador.
  objControle.Cells[0,0] := 'Par';
  objControle.Cells[1,0] := 'Impar';
  objControle.Cells[2,0] := 'Ltf_qt';

  // Agora, vamos configurar as outras colunas baseado em qual controle é.
  if objControle = sgrParImpar15Bolas then begin
    objControle.Columns[3].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[3].Title.Caption := 'Res_qt';
    objControle.Columns[3].Alignment := TAlignment.taCenter;

    objControle.Columns[4].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[4].Title.Caption := 'Marcar';
    objControle.Columns[4].Alignment := TAlignment.taCenter;

    // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
    // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
    objControle.Columns[4].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Embora, as colunas tem nomes de títulos, devemos definir os nomes
    // de todas as células da linha 0, pois, iremos utilizar pra identificar se
    // a coluna selecionar, é a coluna marcar.
    objControle.Cells[3, 0] := 'Res_qt';
    objControle.Cells[4, 0] := 'Marcar';
  end else begin
    objControle.Columns[3].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[3].Title.Caption := 'Marcar';
    objControle.Columns[3].Alignment := TAlignment.taCenter;

    // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
    // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
    objControle.Columns[3].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Embora, as colunas tem nomes de títulos, devemos definir os nomes
    // de todas as células da linha 0, pois, iremos utilizar pra identificar se
    // a coluna selecionar, é a coluna marcar.
    objControle.Cells[3, 0] := 'Marcar';
  end;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

{
 Este procedimento carregar as informações que estão no banco de dados
 e armazena nos controles:
 sgrNovosRepetidos15Bolas,
 sgrNovosRepetidos16Bolas,
 sgrNovosRepetidos17Bolas,
 sgrNovosRepetidos18Bolas.
 Entretanto, cada controle, tem um sql diferente, nos controles de 16, 17 e 18
 bolas, praticamente, o sql altera indicando qual a quantidade de bolas.
 Então, o sql será criado dinamicamente conforme o controle selecionado.
 }
procedure TForm1.CarregarParImpar(objControle: TStringGrid);
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha: integer;
  qtRegistros : LongInt;
begin
  // Inicia o módulo de dados.
  dmLotofacil := TdmLotofacil.Create(Self);

  strSql := TStringList.Create;

  if objControle = sgrParImpar15Bolas then begin
    strSql.add('Select par, impar, ltf_qt, res_qt from');
    strSql.add('ltk.v_lotofacil_resultado_par_impar');
    strSql.add('order by res_qt desc, ltf_qt desc');
  end else if objControle = sgrParImpar16Bolas then begin
    strSql.add('Select par, impar, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_par_impar');
    strSql.add(' where qt_bolas = 16');
    strSql.add(' order by qt_vezes desc');
  end else if objControle = sgrParImpar17Bolas then begin
    strSql.add('Select par, impar, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_par_impar');
    strSql.add(' where qt_bolas = 17');
    strSql.add(' order by qt_vezes desc');
  end else if objControle = sgrParImpar18Bolas then begin
    strSql.add('Select par, impar, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_par_impar');
    strSql.add(' where qt_bolas = 18');
    strSql.add(' order by qt_vezes desc');
  end;

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := false;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  qtRegistros := 0;
  dsLotofacil.First;
  while not dsLotofacil.Eof do begin
      Inc(qtRegistros);
      dsLotofacil.Next;
  end;

  if qtRegistros = 0 then
  begin
    objControle.ColCount := 1;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;


  // Devemos, 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qtRegistros + 1;

  ConfigurarControlesParImpar(objControle);

  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    objControle.Cells[0, uLinha] := dsLotofacil.FieldByName('par').AsString;
    objControle.Cells[1, uLinha] := dsLotofacil.FieldByName('impar').AsString;

    if objControle = sgrParImpar15Bolas then begin
      objControle.Cells[2, uLinha] := dsLotofacil.FieldByName('ltf_qt').AsString;
      objControle.Cells[3, uLinha] := dsLotofacil.FieldByName('res_qt').AsString;
      objControle.Cells[4, uLinha] := '0';
    end else begin
      objControle.Cells[2, uLinha] := dsLotofacil.FieldByName('qt_vezes').AsString;
      objControle.Cells[3, uLinha] := '0';
    end;

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;
end;



procedure TForm1.CarregarNovosRepetidos;
begin
  CarregarNovosRepetidosConcurso;
  CarregarNovosRepetidos(sgrNovosRepetidos15Bolas);
  CarregarNovosRepetidos(sgrNovosRepetidos16Bolas);
  CarregarNovosRepetidos(sgrNovosRepetidos17Bolas);
  CarregarNovosRepetidos(sgrNovosRepetidos18Bolas);

end;

procedure TForm1.CarregarNovosRepetidosConcurso;
var
  strSql : TStringList;
  sqlLotofacil : TSqlquery;
begin
  // Carrega o módulo, se não está carregado.
  if dmLotofacil = nil then begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  strSql := TStringList.Create;
  strSql.Add('Select concurso from v_lotofacil_concurso_todos');
  strSql.Add('order by concurso desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;

  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  sqlLotofacil.UniDirectional := false;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  // Verifica se há registros
  if sqlLotofacil.RecordCount = 0 then begin
    cmbConcursoNovosRepetidos.Clear;
    exit;
  end;

  // Limpa os combobox.
  cmbConcursoNovosRepetidos.Clear;
  cmbConcursoDeletar.Clear;


  // Achamos registros, inserir então.
  sqlLotofacil.First;
  while sqlLotofacil.EOF = false do begin
      cmbConcursoNovosRepetidos.Items.Add(sqlLotofacil.FieldByName('concurso').AsString);

      // Aqui, vamos aproveitar o código e carregar o controle 'cmbConcursoDeletar';
      cmbConcursoDeletar.Items.Add(sqlLotofacil.FieldByName('concurso').AsString);

      sqlLotofacil.Next;
  end;

  // Define o primeiro ítem da lista.
  cmbConcursoNovosRepetidos.ItemIndex := 0;
  cmbConcursoDeletar.ItemIndex := 0;
end;

{
 Este procedimento carregar as informações que estão no banco de dados
 e armazena nos controles:
 sgrNovosRepetidos15Bolas,
 sgrNovosRepetidos16Bolas,
 sgrNovosRepetidos17Bolas,
 sgrNovosRepetidos18Bolas.
 Entretanto, cada controle, tem um sql diferente, nos controles de 16, 17 e 18
 bolas, praticamente, o sql altera indicando qual a quantidade de bolas.
 Então, o sql será criado dinamicamente conforme o controle selecionado.
 }
procedure TForm1.CarregarNovosRepetidos(objControle: TStringGrid);
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha, qtRegistros: integer;
  qtColunas: longint;
  nomeControle : string;
begin
  ConfigurarControlesNovosRepetidos(objControle);


  // Inicia o módulo de dados.
  dmLotofacil := TdmLotofacil.Create(Self);

  strSql := TStringList.Create;

  if objControle = sgrNovosRepetidos15Bolas then begin
    strSql.add('Select novos, repetidos, ltf_qt, res_qt from');
    strSql.add('v_lotofacil_novo_repetiu_ainda_nao_saiu');
    strSql.add('order by res_qt desc, ltf_qt desc');
  end else if objControle = sgrNovosRepetidos16Bolas then begin
    strSql.add('Select novos, repetidos, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_novos_repetidos');
    strSql.add(' where qt_bolas = 16');
    strSql.add(' order by qt_vezes desc, novos, repetidos');
  end else if objControle = sgrNovosRepetidos17Bolas then begin
    strSql.add('Select novos, repetidos, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_novos_repetidos');
    strSql.add(' where qt_bolas = 17');
    strSql.add(' order by qt_vezes desc, novos, repetidos');
  end else if objControle = sgrNovosRepetidos18Bolas then begin
    strSql.add('Select novos, repetidos, qt_vezes from');
    strSql.add(' ltk.lotofacil_agregado_novos_repetidos');
    strSql.add(' where qt_bolas = 18');
    strSql.add(' order by qt_vezes desc, novos, repetidos');
  end;

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := false;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  qtRegistros := 0;
  dsLotofacil.First;
  while not dsLotofacil.Eof do begin
      Inc(qtRegistros);
      dsLotofacil.Next;
  end;

  if qtRegistros = 0 then
  begin
    objControle.ColCount := 1;
    objControle.RowCount := 1;
    objControle.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    objControle.AutoSizeColumns;
    exit;
  end;

  // Devemos, 1 registro a mais por causa do cabeçalho.
  objControle.RowCount := qtRegistros + 1;

  //ConfigurarControlesNovosRepetidos(objControle);


  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    objControle.Cells[0, uLinha] := dsLotofacil.FieldByName('novos').AsString;
    objControle.Cells[1, uLinha] := dsLotofacil.FieldByName('repetidos').AsString;

    if objControle = sgrNovosRepetidos15Bolas then begin
      objControle.Cells[2, uLinha] := dsLotofacil.FieldByName('ltf_qt').AsString;
      objControle.Cells[3, uLinha] := dsLotofacil.FieldByName('res_qt').AsString;
      objControle.Cells[4, uLinha] := '0';
    end else begin
      objControle.Cells[2, uLinha] := dsLotofacil.FieldByName('qt_vezes').AsString;
      objControle.Cells[3, uLinha] := '0';
    end;

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  objControle.AutoSizeColumns;
end;


{
 Este procedimento configurar os os 4 controles:
 sgrNovosRepetidos15Bolas,
 sgrNovosRepetidos16Bolas,
 sgrNovosRepetidos17Bolas,
 sgrNovosRepetidos18Bolas.
 Dos controles acima, o controle sgrNovosRepetidos15Bolas tem 5 colunas, os
 outros tem 4 colunas.
 Então pra evitar codificar 4 procedimentos diferentes, onde 3 deles faz a mesma
 coisa, iremos definir uma condição que quando for o controle de 15 bolas, iremos
 acrescentar uma nova coluna.
 }

procedure TForm1.ConfigurarControlesNovosRepetidos(objControle : TStringGrid);
var
  qtColunas : Integer;
begin
  // Nos controles novos e repetidos, o controle strNovosRepetidos15Bolas terá
  // uma coluna a mais pois ele compara a combinação de 15 bolas, com todos os
  // resultados dos concursos que saíram.
  if objControle = sgrNovosRepetidos15Bolas then begin
     qtColunas := 5;
  end else begin
     qtColunas := 4;
  end;

  // Nos controles stringGrid, devemos criar títulos, se queremos configurar
  // as colunas, como por exemplo, centralizá-la.
  objControle.Columns.Clear;
  while qtColunas > 0 do begin
    objControle.Columns.Add;
    dec(qtColunas);
  end;

  // Vamos configurar as 3 colunas, que são comuns, nos 4 controles.
  objControle.Columns[0].Title.Alignment := TAlignment.taCenter;
  objControle.Columns[1].Title.Alignment := TAlignment.taCenter;
  objControle.Columns[2].Title.Alignment := TAlignment.taCenter;

  objControle.Columns[0].Alignment := TAlignment.taCenter;
  objControle.Columns[1].Alignment := TAlignment.taCenter;
  objControle.Columns[2].Alignment := TAlignment.taCenter;

  objControle.Columns[0].Title.Caption := 'Novos';
  objControle.Columns[1].Title.Caption := 'Rept.';
  objControle.Columns[2].Title.Caption := 'Ltf_qt';

  // Irei colocar na linha 0 o nome da coluna, embora, já foi feito isto nas colunas
  // indicada acima, isto servirá pra identificar a coluna, dentro do método:
  // AlterarMarcador.
  objControle.Cells[0,0] := 'Novos';
  objControle.Cells[1,0] := 'Rept.';
  objControle.Cells[2,0] := 'Ltf_qt';

  // Agora, vamos configurar as outras colunas baseado em qual controle é.
  if objControle = sgrNovosRepetidos15Bolas then begin
    objControle.Columns[3].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[3].Title.Caption := 'Res_qt';
    objControle.Columns[3].Alignment := TAlignment.taCenter;

    objControle.Columns[4].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[4].Title.Caption := 'Marcar';
    objControle.Columns[4].Alignment := TAlignment.taCenter;

    // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
    // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
    objControle.Columns[4].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Embora, as colunas tem nomes de títulos, devemos definir os nomes
    // de todas as células da linha 0, pois, iremos utilizar pra identificar se
    // a coluna selecionar, é a coluna marcar.
    objControle.Cells[3, 0] := 'Res_qt';
    objControle.Cells[4, 0] := 'Marcar';
  end else begin
    objControle.Columns[3].Title.Alignment := TAlignment.taCenter;
    objControle.Columns[3].Title.Caption := 'Marcar';
    objControle.Columns[3].Alignment := TAlignment.taCenter;

    // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
    // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
    objControle.Columns[3].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

    // Embora, as colunas tem nomes de títulos, devemos definir os nomes
    // de todas as células da linha 0, pois, iremos utilizar pra identificar se
    // a coluna selecionar, é a coluna marcar.
    objControle.Cells[3, 0] := 'Marcar';
  end;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;


end.
