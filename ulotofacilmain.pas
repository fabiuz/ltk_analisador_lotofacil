unit uLotofacilMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, DBGrids, uLotofacilModulo,
  //uLotofacilSeletor,
  DB, BufDataset, sqlDb, Grids, //ButtonPanel,
  ValEdit,
  CheckLst, MaskEdit, Buttons, JSONPropStorage, Spin, EditBtn, Arrow,
  AsyncProcess, IdHTTP,
  strings, strUtils,

  fgl,
  //IdHeaderList,
  IdAuthentication, zipper,
  //uHtml_Tokenizador,
  SAX_HTML, dom_html, dom, XMLConf,
  uLotofacilPrimoNaoPrimo,
  uLotofacilNovosRepetidos, Types;

// Ao gerar o sql, iremos selecionar estes campos.
const
  filtros_campos: array[0..59] of string = (
    'FILTROS_ID',
    'DATA',
    'NV_RPT_ID_ALT',
    'ACERTOS', 'LTF_ID', 'LTF_QT',
    'B_1', 'B_2', 'B_3', 'B_4', 'B_5',
    'B_6', 'B_7', 'B_8', 'B_9', 'B_10',
    'B_11', 'B_12', 'B_13', 'B_14', 'B_15',
    'B_16', 'B_17', 'B_18',
    'PAR', 'IMPAR',
    'EXTERNO', 'INTERNO',
    'PRIMO', 'NAO_PRIMO',
    'NOVOS', 'REPETIDOS',

    'HRZ_1', 'HRZ_2', 'HRZ_3', 'HRZ_4', 'HRZ_5',
    'VRT_1', 'VRT_2', 'VRT_3', 'VRT_4', 'VRT_5',
    'DG_1', 'DG_2', 'DG_3', 'DG_4', 'DG_5',

    'CONC_SOMA_FRQ_BOLAS',

    'QT_ALT', 'QT_DIF_1', 'QT_DIF_2',
    'QT_DIF_3', 'QT_DIF_4', 'QT_DIF_5',
    'QT_DIF_6', 'QT_DIF_7', 'QT_DIF_8',
    'QT_DIF_9', 'QT_DIF_10', 'QT_DIF_11');

const
  lotofacil_filtro_campos: array[0..59] of string = (
    'filtros_id',
    'data',
    'novos_repetidos_id_alternado',
    'acertos',
    'ltf_id',
    'ltf_qt',
    'b_1',
    'b_2',
    'b_3',
    'b_4',
    'b_5',
    'b_6',
    'b_7',
    'b_8',
    'b_9',
    'b_10',
    'b_11',
    'b_12',
    'b_13',
    'b_14',
    'b_15',
    'b_16',
    'b_17',
    'b_18',

    'par',
    'impar',

    'externo',
    'interno',

    'primo',
    'nao_primo',

    'novos',
    'repetidos',

    'hrz_1',
    'hrz_2',
    'hrz_3',
    'hrz_4',
    'hrz_5',

    'vrt_1',
    'vrt_2',
    'vrt_3',
    'vrt_4',
    'vrt_5',

    'dg_1',
    'dg_2',
    'dg_3',
    'dg_4',
    'dg_5',

    'concurso_soma_frequencia_bolas',

    'qt_alt',
    'qt_dif_1',
    'qt_dif_2',
    'qt_dif_3',
    'qt_dif_4',
    'qt_dif_5',
    'qt_dif_6',
    'qt_dif_7',
    'qt_dif_8',
    'qt_dif_9',
    'qt_dif_10',
    'qt_dif_11');

const
  LTF_FILTROS_ID: integer = 0;
  LTF_DATA = 1;
  LTF_NV_RPT_ID_ALT = 2;
  LTF_ACERTOS = 3;
  LTF_ID = 4;
  LTF_QT = 5;
  B_1 = 6;
  B_2 = 7;
  B_3 = 8;
  B_4 = 9;
  B_5 = 10;
  B_6 = 11;
  B_7 = 12;
  B_8 = 13;
  B_9 = 14;
  B_10 = 15;
  B_11 = 16;
  B_12 = 17;
  B_13 = 18;
  B_14 = 19;
  B_15 = 20;
  B_16 = 21;
  B_17 = 22;
  B_18 = 23;
  LTF_PAR = 24;
  LTF_IMPAR = 25;
  LTF_EXTERNO = 26;
  LTF_INTERNO = 27;
  LTF_PRIMO = 28;
  LTF_NAO_PRIMO = 29;
  LTF_NOVOS = 30;
  LTF_REPETIDOS = 31;
  HRZ_1 = 32;
  HRZ_2 = 33;
  HRZ_3 = 34;
  HRZ_4 = 35;
  HRZ_5 = 36;
  VRT_1 = 37;
  VRT_2 = 38;
  VRT_3 = 39;
  VRT_4 = 40;
  VRT_5 = 41;
  DG_1 = 42;
  DG_2 = 43;
  DG_3 = 44;
  DG_4 = 45;
  DG_5 = 46;

  LTF_QT_ALT = 47;
  LTF_QT_DIF_1 = 48;
  LTF_QT_DIF_2 = 49;
  LTF_QT_DIF_3 = 50;
  QT_DIF_4 = 51;
  QT_DIF_5 = 52;
  QT_DIF_6 = 53;
  QT_DIF_7 = 54;
  QT_DIF_8 = 55;
  QT_DIF_9 = 56;
  QT_DIF_10 = 57;
  QT_DIF_11 = 58;

// Registro pra armazena os dados da lotofacil.
type
  TLotofacil_Resultado = record
    concurso: integer;
    data_dia, data_mes, data_ano: integer;
    bolas: array[1..15] of integer;
    arrecadacao_total: single;
    ganhadores: array[11..15] of integer;
    rateio: array[11..15] of single;
    acumulado_15_numeros: single;
    estimativa_premio: single;
    acumulado_especial: single;
  end;

type
  TAleatorio_Resultado = array of array of integer;

type
  {
   Variáveis usadas na guia B1_A_B15 que está dentro da guia Filtros.
  }
  // Armazena todos os controles com o nome da forma: sgr_bx_a_y, onde
  // x e y são números, de tal forma que x >= 1 and x <= 15 and y >= 1 and y <= 15.
  TLista_Controle_B1_a_B15 = specialize TFPGList<TStringGrid>;

  // A chave será o nome do controle e o valor da chave será a instância do controle.
  TMapa_Controle_B1_a_B15 = specialize TFPGMap<AnsiString, TStringGrid>;

  TMap_String_TStringGrid = specialize TFPGMap<AnsiString, TStringGrid>;

  TList_ComboBox = specialize TFPGList<TComboBox>;
  TMap_String_TComboBox = specialize TFPGMap<AnsiString, TComboBox>;

  // Quando um controle é modificado, vários controles, que depende do controle
  // modificado, terão o conteúdo apagado e um destes controles terá o conteúdo
  // atualizado conforme controle que foi modificado.
  Tcontroles_dependentes = specialize TFPGMap<AnsiString, TLista_Controle_B1_a_B15>;

  // Armazena dados referentes ao controle.
  // Por exemplo, podemos armazenar, o sql de cada controle e também
  // as colunas de tais controles.
  TMap_String_StringList = specialize TFPGMap<AnsiString, TStringList>;

  TMap_String_String = specialize TFPGMap<AnsiString, AnsiString>;

type

  { TForm1 }

  TForm1 = class(TForm)
    AsyncProcess1: TAsyncProcess;
    btnAleatorioAplicarFiltro: TButton;
    btnAtualizarNovosRepetidos2: TButton;
    btnAtualizarNovosRepetidosAntigo : TButton;
    btnFiltroExcluirTodos : TButton;
    btnGrupo2BolasDesmarcarTodos10: TButton;
    btnGrupo2BolasDesmarcarTodos100: TButton;
    btnGrupo2BolasDesmarcarTodos101: TButton;
    btnGrupo2BolasDesmarcarTodos102: TButton;
    btnGrupo2BolasDesmarcarTodos103: TButton;
    btnGrupo2BolasDesmarcarTodos104: TButton;
    btnGrupo2BolasDesmarcarTodos105: TButton;
    btnGrupo2BolasDesmarcarTodos106: TButton;
    btnGrupo2BolasDesmarcarTodos107: TButton;
    btnGrupo2BolasDesmarcarTodos108: TButton;
    btnGrupo2BolasDesmarcarTodos109: TButton;
    btnGrupo2BolasDesmarcarTodos11: TButton;
    btnGrupo2BolasDesmarcarTodos110: TButton;
    btnGrupo2BolasDesmarcarTodos111: TButton;
    btnGrupo2BolasDesmarcarTodos112: TButton;
    btnGrupo2BolasDesmarcarTodos113: TButton;
    btnGrupo2BolasDesmarcarTodos114: TButton;
    btnGrupo2BolasDesmarcarTodos115: TButton;
    btnGrupo2BolasDesmarcarTodos116: TButton;
    btnGrupo2BolasDesmarcarTodos117: TButton;
    btnGrupo2BolasDesmarcarTodos118: TButton;
    btnGrupo2BolasDesmarcarTodos119: TButton;
    btnGrupo2BolasDesmarcarTodos12 : TButton;
    btnGrupo2BolasDesmarcarTodos120: TButton;
    btnGrupo2BolasDesmarcarTodos121: TButton;
    btnGrupo2BolasDesmarcarTodos122: TButton;
    btnGrupo2BolasDesmarcarTodos123: TButton;
    btnGrupo2BolasDesmarcarTodos124: TButton;
    btnGrupo2BolasDesmarcarTodos125: TButton;
    btnGrupo2BolasDesmarcarTodos126: TButton;
    btnGrupo2BolasDesmarcarTodos127: TButton;
    btnGrupo2BolasDesmarcarTodos128: TButton;
    btnGrupo2BolasDesmarcarTodos129: TButton;
    btnGrupo2BolasDesmarcarTodos13 : TButton;
    btnGrupo2BolasDesmarcarTodos130: TButton;
    btnGrupo2BolasDesmarcarTodos131: TButton;
    btnGrupo2BolasDesmarcarTodos132: TButton;
    btnGrupo2BolasDesmarcarTodos133: TButton;
    btnGrupo2BolasDesmarcarTodos134: TButton;
    btnGrupo2BolasDesmarcarTodos135: TButton;
    btnGrupo2BolasDesmarcarTodos136: TButton;
    btnGrupo2BolasDesmarcarTodos137: TButton;
    btnGrupo2BolasDesmarcarTodos138: TButton;
    btnGrupo2BolasDesmarcarTodos139: TButton;
    btnGrupo2BolasDesmarcarTodos14 : TButton;
    btnGrupo2BolasDesmarcarTodos140: TButton;
    btnGrupo2BolasDesmarcarTodos141: TButton;
    btnGrupo2BolasDesmarcarTodos142: TButton;
    btnGrupo2BolasDesmarcarTodos143: TButton;
    btnGrupo2BolasDesmarcarTodos144: TButton;
    btnGrupo2BolasDesmarcarTodos145: TButton;
    btnGrupo2BolasDesmarcarTodos146: TButton;
    btnGrupo2BolasDesmarcarTodos147: TButton;
    btnGrupo2BolasDesmarcarTodos148: TButton;
    btnGrupo2BolasDesmarcarTodos149: TButton;
    btnGrupo2BolasDesmarcarTodos15 : TButton;
    btnGrupo2BolasDesmarcarTodos150: TButton;
    btnGrupo2BolasDesmarcarTodos151: TButton;
    btnGrupo2BolasDesmarcarTodos152: TButton;
    btnGrupo2BolasDesmarcarTodos153: TButton;
    btnGrupo2BolasDesmarcarTodos154: TButton;
    btnGrupo2BolasDesmarcarTodos155: TButton;
    btnGrupo2BolasDesmarcarTodos156: TButton;
    btnGrupo2BolasDesmarcarTodos157: TButton;
    btnGrupo2BolasDesmarcarTodos158: TButton;
    btnGrupo2BolasDesmarcarTodos159: TButton;
    btnGrupo2BolasDesmarcarTodos16 : TButton;
    btnGrupo2BolasDesmarcarTodos160: TButton;
    btnGrupo2BolasDesmarcarTodos161: TButton;
    btnGrupo2BolasDesmarcarTodos162: TButton;
    btnGrupo2BolasDesmarcarTodos163: TButton;
    btnGrupo2BolasDesmarcarTodos164: TButton;
    btnGrupo2BolasDesmarcarTodos165: TButton;
    btnGrupo2BolasDesmarcarTodos166: TButton;
    btnGrupo2BolasDesmarcarTodos167: TButton;
    btnGrupo2BolasDesmarcarTodos168: TButton;
    btnGrupo2BolasDesmarcarTodos169: TButton;
    btnGrupo2BolasDesmarcarTodos17 : TButton;
    btnGrupo2BolasDesmarcarTodos170: TButton;
    btnGrupo2BolasDesmarcarTodos171: TButton;
    btnGrupo2BolasDesmarcarTodos172: TButton;
    btnGrupo2BolasDesmarcarTodos173: TButton;
    btnGrupo2BolasDesmarcarTodos174: TButton;
    btnGrupo2BolasDesmarcarTodos175: TButton;
    btnGrupo2BolasDesmarcarTodos176: TButton;
    btnGrupo2BolasDesmarcarTodos177: TButton;
    btnGrupo2BolasDesmarcarTodos178: TButton;
    btnGrupo2BolasDesmarcarTodos179: TButton;
    btnGrupo2BolasDesmarcarTodos18 : TButton;
    btnGrupo2BolasDesmarcarTodos180: TButton;
    btnGrupo2BolasDesmarcarTodos181: TButton;
    btnGrupo2BolasDesmarcarTodos182: TButton;
    btnGrupo2BolasDesmarcarTodos183: TButton;
    btnGrupo2BolasDesmarcarTodos184: TButton;
    btnGrupo2BolasDesmarcarTodos185: TButton;
    btnGrupo2BolasDesmarcarTodos186: TButton;
    btnGrupo2BolasDesmarcarTodos187: TButton;
    btnGrupo2BolasDesmarcarTodos188: TButton;
    btnGrupo2BolasDesmarcarTodos189: TButton;
    btnGrupo2BolasDesmarcarTodos19 : TButton;
    btnGrupo2BolasDesmarcarTodos190: TButton;
    btnGrupo2BolasDesmarcarTodos191: TButton;
    btnGrupo2BolasDesmarcarTodos192: TButton;
    btnGrupo2BolasDesmarcarTodos193: TButton;
    btnGrupo2BolasDesmarcarTodos194: TButton;
    btnGrupo2BolasDesmarcarTodos195: TButton;
    btnGrupo2BolasDesmarcarTodos196: TButton;
    btnGrupo2BolasDesmarcarTodos197: TButton;
    btnGrupo2BolasDesmarcarTodos198: TButton;
    btnGrupo2BolasDesmarcarTodos199: TButton;
    btnGrupo2BolasDesmarcarTodos200: TButton;
    btnGrupo2BolasDesmarcarTodos201: TButton;
    btnGrupo2BolasDesmarcarTodos202: TButton;
    btnGrupo2BolasDesmarcarTodos203: TButton;
    btnGrupo2BolasDesmarcarTodos204: TButton;
    btnGrupo2BolasDesmarcarTodos205: TButton;
    btnGrupo2BolasDesmarcarTodos206: TButton;
    btnGrupo2BolasDesmarcarTodos207: TButton;
    btnGrupo2BolasDesmarcarTodos208: TButton;
    btnGrupo2BolasDesmarcarTodos209: TButton;
    btnGrupo2BolasDesmarcarTodos210: TButton;
    btnGrupo2BolasDesmarcarTodos211: TButton;
    btnGrupo2BolasDesmarcarTodos212: TButton;
    btnGrupo2BolasDesmarcarTodos213: TButton;
    btnGrupo2BolasDesmarcarTodos214: TButton;
    btnGrupo2BolasDesmarcarTodos215: TButton;
    btnGrupo2BolasDesmarcarTodos216: TButton;
    btnGrupo2BolasDesmarcarTodos217: TButton;
    btnGrupo2BolasDesmarcarTodos218: TButton;
    btnGrupo2BolasDesmarcarTodos219: TButton;
    btnGrupo2BolasDesmarcarTodos220: TButton;
    btnGrupo2BolasDesmarcarTodos221: TButton;
    btnGrupo2BolasDesmarcarTodos222: TButton;
    btnGrupo2BolasDesmarcarTodos223: TButton;
    btnGrupo2BolasDesmarcarTodos224: TButton;
    btnGrupo2BolasDesmarcarTodos225: TButton;
    btnGrupo2BolasDesmarcarTodos226: TButton;
    btnGrupo2BolasDesmarcarTodos227: TButton;
    btnGrupo2BolasDesmarcarTodos228: TButton;
    btnGrupo2BolasDesmarcarTodos229: TButton;
    btnGrupo2BolasDesmarcarTodos230: TButton;
    btnGrupo2BolasDesmarcarTodos231: TButton;
    btnGrupo2BolasDesmarcarTodos232: TButton;
    btnGrupo2BolasDesmarcarTodos233: TButton;
    btnGrupo2BolasDesmarcarTodos234: TButton;
    btnGrupo2BolasDesmarcarTodos235: TButton;
    btnGrupo2BolasDesmarcarTodos236: TButton;
    btnGrupo2BolasDesmarcarTodos237: TButton;
    btnGrupo2BolasDesmarcarTodos238: TButton;
    btnGrupo2BolasDesmarcarTodos239: TButton;
    btnGrupo2BolasDesmarcarTodos240: TButton;
    btnGrupo2BolasDesmarcarTodos241: TButton;
    btnGrupo2BolasDesmarcarTodos242: TButton;
    btnGrupo2BolasDesmarcarTodos243: TButton;
    btnGrupo2BolasDesmarcarTodos244: TButton;
    btnGrupo2BolasDesmarcarTodos245: TButton;
    btnGrupo2BolasDesmarcarTodos246: TButton;
    btnGrupo2BolasDesmarcarTodos247: TButton;
    btnGrupo2BolasDesmarcarTodos248: TButton;
    btnGrupo2BolasDesmarcarTodos249: TButton;
    btnGrupo2BolasDesmarcarTodos250: TButton;
    btnGrupo2BolasDesmarcarTodos251: TButton;
    btnGrupo2BolasDesmarcarTodos252: TButton;
    btnGrupo2BolasDesmarcarTodos253: TButton;
    btnGrupo2BolasDesmarcarTodos254: TButton;
    btnGrupo2BolasDesmarcarTodos255: TButton;
    btnGrupo2BolasDesmarcarTodos256: TButton;
    btnGrupo2BolasDesmarcarTodos257: TButton;
    btnGrupo2BolasDesmarcarTodos258: TButton;
    btnGrupo2BolasDesmarcarTodos259: TButton;
    btnGrupo2BolasDesmarcarTodos260: TButton;
    btnGrupo2BolasDesmarcarTodos261: TButton;
    btnGrupo2BolasDesmarcarTodos262: TButton;
    btnGrupo2BolasDesmarcarTodos263: TButton;
    btnGrupo2BolasDesmarcarTodos264: TButton;
    btnGrupo2BolasDesmarcarTodos265: TButton;
    btnGrupo2BolasDesmarcarTodos266: TButton;
    btnGrupo2BolasDesmarcarTodos267: TButton;
    btnGrupo2BolasDesmarcarTodos268: TButton;
    btnGrupo2BolasDesmarcarTodos269: TButton;
    btnGrupo2BolasDesmarcarTodos270: TButton;
    btnGrupo2BolasDesmarcarTodos271: TButton;
    btnGrupo2BolasDesmarcarTodos272: TButton;
    btnGrupo2BolasDesmarcarTodos273: TButton;
    btnGrupo2BolasDesmarcarTodos274: TButton;
    btnGrupo2BolasDesmarcarTodos275: TButton;
    btnGrupo2BolasDesmarcarTodos276: TButton;
    btnGrupo2BolasDesmarcarTodos277: TButton;
    btnGrupo2BolasDesmarcarTodos278: TButton;
    btnGrupo2BolasDesmarcarTodos279: TButton;
    btnGrupo2BolasDesmarcarTodos280: TButton;
    btnGrupo2BolasDesmarcarTodos281: TButton;
    btnGrupo2BolasDesmarcarTodos282: TButton;
    btnGrupo2BolasDesmarcarTodos283: TButton;
    btnGrupo2BolasDesmarcarTodos284: TButton;
    btnGrupo2BolasDesmarcarTodos285: TButton;
    btnGrupo2BolasDesmarcarTodos286: TButton;
    btnGrupo2BolasDesmarcarTodos287: TButton;
    btnGrupo2BolasDesmarcarTodos288: TButton;
    btnGrupo2BolasDesmarcarTodos289: TButton;
    btnGrupo2BolasDesmarcarTodos290: TButton;
    btnGrupo2BolasDesmarcarTodos291: TButton;
    btnGrupo2BolasDesmarcarTodos292: TButton;
    btnGrupo2BolasDesmarcarTodos293: TButton;
    btnGrupo2BolasDesmarcarTodos294: TButton;
    btnGrupo2BolasDesmarcarTodos295: TButton;
    btnGrupo2BolasDesmarcarTodos296: TButton;
    btnGrupo2BolasDesmarcarTodos297: TButton;
    btnGrupo2BolasDesmarcarTodos298: TButton;
    btnGrupo2BolasDesmarcarTodos299: TButton;
    btnGrupo2BolasDesmarcarTodos300: TButton;
    btnGrupo2BolasDesmarcarTodos301: TButton;
    btnGrupo2BolasDesmarcarTodos302: TButton;
    btnGrupo2BolasDesmarcarTodos303: TButton;
    btnGrupo2BolasDesmarcarTodos304: TButton;
    btnGrupo2BolasDesmarcarTodos305: TButton;
    btnGrupo2BolasDesmarcarTodos306: TButton;
    btnGrupo2BolasDesmarcarTodos307: TButton;
    btnGrupo2BolasDesmarcarTodos308: TButton;
    btnGrupo2BolasDesmarcarTodos309: TButton;
    btnGrupo2BolasDesmarcarTodos31 : TButton;
    btnGrupo2BolasDesmarcarTodos310: TButton;
    btnGrupo2BolasDesmarcarTodos311: TButton;
    btnGrupo2BolasDesmarcarTodos312: TButton;
    btnGrupo2BolasDesmarcarTodos313: TButton;
    btnGrupo2BolasDesmarcarTodos314: TButton;
    btnGrupo2BolasDesmarcarTodos315: TButton;
    btnGrupo2BolasDesmarcarTodos316: TButton;
    btnGrupo2BolasDesmarcarTodos317: TButton;
    btnGrupo2BolasDesmarcarTodos318: TButton;
    btnGrupo2BolasDesmarcarTodos319: TButton;
    btnGrupo2BolasDesmarcarTodos32 : TButton;
    btnGrupo2BolasDesmarcarTodos320: TButton;
    btnGrupo2BolasDesmarcarTodos321: TButton;
    btnGrupo2BolasDesmarcarTodos322: TButton;
    btnGrupo2BolasDesmarcarTodos323: TButton;
    btnGrupo2BolasDesmarcarTodos324: TButton;
    btnGrupo2BolasDesmarcarTodos325: TButton;
    btnGrupo2BolasDesmarcarTodos326: TButton;
    btnGrupo2BolasDesmarcarTodos327: TButton;
    btnGrupo2BolasDesmarcarTodos328: TButton;
    btnGrupo2BolasDesmarcarTodos329: TButton;
    btnGrupo2BolasDesmarcarTodos33 : TButton;
    btnGrupo2BolasDesmarcarTodos330: TButton;
    btnGrupo2BolasDesmarcarTodos331: TButton;
    btnGrupo2BolasDesmarcarTodos332: TButton;
    btnGrupo2BolasDesmarcarTodos333: TButton;
    btnGrupo2BolasDesmarcarTodos334: TButton;
    btnGrupo2BolasDesmarcarTodos335: TButton;
    btnGrupo2BolasDesmarcarTodos336: TButton;
    btnGrupo2BolasDesmarcarTodos337: TButton;
    btnGrupo2BolasDesmarcarTodos338: TButton;
    btnGrupo2BolasDesmarcarTodos339: TButton;
    btnGrupo2BolasDesmarcarTodos34 : TButton;
    btnGrupo2BolasDesmarcarTodos340: TButton;
    btnGrupo2BolasDesmarcarTodos341: TButton;
    btnGrupo2BolasDesmarcarTodos342: TButton;
    btnGrupo2BolasDesmarcarTodos343: TButton;
    btnGrupo2BolasDesmarcarTodos344: TButton;
    btnGrupo2BolasDesmarcarTodos345: TButton;
    btnGrupo2BolasDesmarcarTodos346: TButton;
    btnGrupo2BolasDesmarcarTodos347: TButton;
    btnGrupo2BolasDesmarcarTodos348: TButton;
    btnGrupo2BolasDesmarcarTodos349: TButton;
    btnGrupo2BolasDesmarcarTodos35 : TButton;
    btnGrupo2BolasDesmarcarTodos350: TButton;
    btnGrupo2BolasDesmarcarTodos4: TButton;
    btnGrupo2BolasDesmarcarTodos44 : TButton;
    btnGrupo2BolasDesmarcarTodos45 : TButton;
    btnGrupo2BolasDesmarcarTodos46 : TButton;
    btnGrupo2BolasDesmarcarTodos47 : TButton;
    btnGrupo2BolasDesmarcarTodos48 : TButton;
    btnGrupo2BolasDesmarcarTodos49: TButton;
    btnGrupo2BolasDesmarcarTodos50: TButton;
    btnGrupo2BolasDesmarcarTodos51: TButton;
    btnGrupo2BolasDesmarcarTodos52: TButton;
    btnGrupo2BolasDesmarcarTodos53: TButton;
    btnGrupo2BolasDesmarcarTodos54: TButton;
    btnGrupo2BolasDesmarcarTodos55: TButton;
    btnGrupo2BolasDesmarcarTodos56: TButton;
    btnGrupo2BolasDesmarcarTodos57: TButton;
    btnGrupo2BolasDesmarcarTodos58: TButton;
    btnGrupo2BolasDesmarcarTodos59: TButton;
    btnGrupo2BolasDesmarcarTodos60: TButton;
    btnGrupo2BolasDesmarcarTodos61: TButton;
    btnGrupo2BolasDesmarcarTodos62: TButton;
    btnGrupo2BolasDesmarcarTodos63: TButton;
    btnGrupo2BolasDesmarcarTodos64: TButton;
    btnGrupo2BolasDesmarcarTodos65: TButton;
    btnGrupo2BolasDesmarcarTodos66: TButton;
    btnGrupo2BolasDesmarcarTodos67: TButton;
    btnGrupo2BolasDesmarcarTodos68: TButton;
    btnGrupo2BolasDesmarcarTodos69: TButton;
    btnGrupo2BolasDesmarcarTodos70: TButton;
    btnGrupo2BolasDesmarcarTodos71: TButton;
    btnGrupo2BolasDesmarcarTodos72: TButton;
    btnGrupo2BolasDesmarcarTodos73: TButton;
    btnGrupo2BolasDesmarcarTodos74: TButton;
    btnGrupo2BolasDesmarcarTodos75: TButton;
    btnGrupo2BolasDesmarcarTodos76: TButton;
    btnGrupo2BolasDesmarcarTodos77: TButton;
    btnGrupo2BolasDesmarcarTodos78: TButton;
    btnGrupo2BolasDesmarcarTodos79: TButton;
    btnGrupo2BolasDesmarcarTodos8: TButton;
    btnGrupo2BolasDesmarcarTodos80: TButton;
    btnGrupo2BolasDesmarcarTodos81: TButton;
    btnGrupo2BolasDesmarcarTodos82: TButton;
    btnGrupo2BolasDesmarcarTodos83: TButton;
    btnGrupo2BolasDesmarcarTodos84: TButton;
    btnGrupo2BolasDesmarcarTodos85: TButton;
    btnGrupo2BolasDesmarcarTodos86: TButton;
    btnGrupo2BolasDesmarcarTodos87: TButton;
    btnGrupo2BolasDesmarcarTodos88: TButton;
    btnGrupo2BolasDesmarcarTodos89: TButton;
    btnGrupo2BolasDesmarcarTodos9: TButton;
    btnGrupo2BolasDesmarcarTodos90: TButton;
    btnGrupo2BolasDesmarcarTodos91: TButton;
    btnGrupo2BolasDesmarcarTodos92: TButton;
    btnGrupo2BolasDesmarcarTodos93: TButton;
    btnGrupo2BolasDesmarcarTodos94: TButton;
    btnGrupo2BolasDesmarcarTodos95: TButton;
    btnGrupo2BolasDesmarcarTodos96: TButton;
    btnGrupo2BolasDesmarcarTodos97: TButton;
    btnGrupo2BolasDesmarcarTodos98: TButton;
    btnGrupo2BolasDesmarcarTodos99: TButton;
    btnGrupo2BolasMarcarTodos10: TButton;
    btnGrupo2BolasMarcarTodos100: TButton;
    btnGrupo2BolasMarcarTodos101: TButton;
    btnGrupo2BolasMarcarTodos102: TButton;
    btnGrupo2BolasMarcarTodos103: TButton;
    btnGrupo2BolasMarcarTodos104: TButton;
    btnGrupo2BolasMarcarTodos105: TButton;
    btnGrupo2BolasMarcarTodos106: TButton;
    btnGrupo2BolasMarcarTodos107: TButton;
    btnGrupo2BolasMarcarTodos108: TButton;
    btnGrupo2BolasMarcarTodos109: TButton;
    btnGrupo2BolasMarcarTodos11: TButton;
    btnGrupo2BolasMarcarTodos110: TButton;
    btnGrupo2BolasMarcarTodos111: TButton;
    btnGrupo2BolasMarcarTodos112: TButton;
    btnGrupo2BolasMarcarTodos113: TButton;
    btnGrupo2BolasMarcarTodos114: TButton;
    btnGrupo2BolasMarcarTodos115: TButton;
    btnGrupo2BolasMarcarTodos116: TButton;
    btnGrupo2BolasMarcarTodos117: TButton;
    btnGrupo2BolasMarcarTodos118: TButton;
    btnGrupo2BolasMarcarTodos119: TButton;
    btnGrupo2BolasMarcarTodos12 : TButton;
    btnGrupo2BolasMarcarTodos120: TButton;
    btnGrupo2BolasMarcarTodos121: TButton;
    btnGrupo2BolasMarcarTodos122: TButton;
    btnGrupo2BolasMarcarTodos123: TButton;
    btnGrupo2BolasMarcarTodos124: TButton;
    btnGrupo2BolasMarcarTodos125: TButton;
    btnGrupo2BolasMarcarTodos126: TButton;
    btnGrupo2BolasMarcarTodos127: TButton;
    btnGrupo2BolasMarcarTodos128: TButton;
    btnGrupo2BolasMarcarTodos129: TButton;
    btnGrupo2BolasMarcarTodos13 : TButton;
    btnGrupo2BolasMarcarTodos130: TButton;
    btnGrupo2BolasMarcarTodos131: TButton;
    btnGrupo2BolasMarcarTodos132: TButton;
    btnGrupo2BolasMarcarTodos133: TButton;
    btnGrupo2BolasMarcarTodos134: TButton;
    btnGrupo2BolasMarcarTodos135: TButton;
    btnGrupo2BolasMarcarTodos136: TButton;
    btnGrupo2BolasMarcarTodos137: TButton;
    btnGrupo2BolasMarcarTodos138: TButton;
    btnGrupo2BolasMarcarTodos139: TButton;
    btnGrupo2BolasMarcarTodos14 : TButton;
    btnGrupo2BolasMarcarTodos140: TButton;
    btnGrupo2BolasMarcarTodos141: TButton;
    btnGrupo2BolasMarcarTodos142: TButton;
    btnGrupo2BolasMarcarTodos143: TButton;
    btnGrupo2BolasMarcarTodos144: TButton;
    btnGrupo2BolasMarcarTodos145: TButton;
    btnGrupo2BolasMarcarTodos146: TButton;
    btnGrupo2BolasMarcarTodos147: TButton;
    btnGrupo2BolasMarcarTodos148: TButton;
    btnGrupo2BolasMarcarTodos149: TButton;
    btnGrupo2BolasMarcarTodos15 : TButton;
    btnGrupo2BolasMarcarTodos150: TButton;
    btnGrupo2BolasMarcarTodos151: TButton;
    btnGrupo2BolasMarcarTodos152: TButton;
    btnGrupo2BolasMarcarTodos153: TButton;
    btnGrupo2BolasMarcarTodos154: TButton;
    btnGrupo2BolasMarcarTodos155: TButton;
    btnGrupo2BolasMarcarTodos156: TButton;
    btnGrupo2BolasMarcarTodos157: TButton;
    btnGrupo2BolasMarcarTodos158: TButton;
    btnGrupo2BolasMarcarTodos159: TButton;
    btnGrupo2BolasMarcarTodos16 : TButton;
    btnGrupo2BolasMarcarTodos160: TButton;
    btnGrupo2BolasMarcarTodos161: TButton;
    btnGrupo2BolasMarcarTodos162: TButton;
    btnGrupo2BolasMarcarTodos163: TButton;
    btnGrupo2BolasMarcarTodos164: TButton;
    btnGrupo2BolasMarcarTodos165: TButton;
    btnGrupo2BolasMarcarTodos166: TButton;
    btnGrupo2BolasMarcarTodos167: TButton;
    btnGrupo2BolasMarcarTodos168: TButton;
    btnGrupo2BolasMarcarTodos169: TButton;
    btnGrupo2BolasMarcarTodos17 : TButton;
    btnGrupo2BolasMarcarTodos170: TButton;
    btnGrupo2BolasMarcarTodos171: TButton;
    btnGrupo2BolasMarcarTodos172: TButton;
    btnGrupo2BolasMarcarTodos173: TButton;
    btnGrupo2BolasMarcarTodos174: TButton;
    btnGrupo2BolasMarcarTodos175: TButton;
    btnGrupo2BolasMarcarTodos176: TButton;
    btnGrupo2BolasMarcarTodos177: TButton;
    btnGrupo2BolasMarcarTodos178: TButton;
    btnGrupo2BolasMarcarTodos179: TButton;
    btnGrupo2BolasMarcarTodos18 : TButton;
    btnGrupo2BolasMarcarTodos180: TButton;
    btnGrupo2BolasMarcarTodos181: TButton;
    btnGrupo2BolasMarcarTodos182: TButton;
    btnGrupo2BolasMarcarTodos183: TButton;
    btnGrupo2BolasMarcarTodos184: TButton;
    btnGrupo2BolasMarcarTodos185: TButton;
    btnGrupo2BolasMarcarTodos186: TButton;
    btnGrupo2BolasMarcarTodos187: TButton;
    btnGrupo2BolasMarcarTodos188: TButton;
    btnGrupo2BolasMarcarTodos189: TButton;
    btnGrupo2BolasMarcarTodos19 : TButton;
    btnGrupo2BolasMarcarTodos190: TButton;
    btnGrupo2BolasMarcarTodos191: TButton;
    btnGrupo2BolasMarcarTodos192: TButton;
    btnGrupo2BolasMarcarTodos193: TButton;
    btnGrupo2BolasMarcarTodos194: TButton;
    btnGrupo2BolasMarcarTodos195: TButton;
    btnGrupo2BolasMarcarTodos196: TButton;
    btnGrupo2BolasMarcarTodos197: TButton;
    btnGrupo2BolasMarcarTodos198: TButton;
    btnGrupo2BolasMarcarTodos199: TButton;
    btnGrupo2BolasMarcarTodos200: TButton;
    btnGrupo2BolasMarcarTodos201: TButton;
    btnGrupo2BolasMarcarTodos202: TButton;
    btnGrupo2BolasMarcarTodos203: TButton;
    btnGrupo2BolasMarcarTodos204: TButton;
    btnGrupo2BolasMarcarTodos205: TButton;
    btnGrupo2BolasMarcarTodos206: TButton;
    btnGrupo2BolasMarcarTodos207: TButton;
    btnGrupo2BolasMarcarTodos208: TButton;
    btnGrupo2BolasMarcarTodos209: TButton;
    btnGrupo2BolasMarcarTodos210: TButton;
    btnGrupo2BolasMarcarTodos211: TButton;
    btnGrupo2BolasMarcarTodos212: TButton;
    btnGrupo2BolasMarcarTodos213: TButton;
    btnGrupo2BolasMarcarTodos214: TButton;
    btnGrupo2BolasMarcarTodos215: TButton;
    btnGrupo2BolasMarcarTodos216: TButton;
    btnGrupo2BolasMarcarTodos217: TButton;
    btnGrupo2BolasMarcarTodos218: TButton;
    btnGrupo2BolasMarcarTodos219: TButton;
    btnGrupo2BolasMarcarTodos220: TButton;
    btnGrupo2BolasMarcarTodos221: TButton;
    btnGrupo2BolasMarcarTodos222: TButton;
    btnGrupo2BolasMarcarTodos223: TButton;
    btnGrupo2BolasMarcarTodos224: TButton;
    btnGrupo2BolasMarcarTodos225: TButton;
    btnGrupo2BolasMarcarTodos226: TButton;
    btnGrupo2BolasMarcarTodos227: TButton;
    btnGrupo2BolasMarcarTodos228: TButton;
    btnGrupo2BolasMarcarTodos229: TButton;
    btnGrupo2BolasMarcarTodos230: TButton;
    btnGrupo2BolasMarcarTodos231: TButton;
    btnGrupo2BolasMarcarTodos232: TButton;
    btnGrupo2BolasMarcarTodos233: TButton;
    btnGrupo2BolasMarcarTodos234: TButton;
    btnGrupo2BolasMarcarTodos235: TButton;
    btnGrupo2BolasMarcarTodos236: TButton;
    btnGrupo2BolasMarcarTodos237: TButton;
    btnGrupo2BolasMarcarTodos238: TButton;
    btnGrupo2BolasMarcarTodos239: TButton;
    btnGrupo2BolasMarcarTodos240: TButton;
    btnGrupo2BolasMarcarTodos241: TButton;
    btnGrupo2BolasMarcarTodos242: TButton;
    btnGrupo2BolasMarcarTodos243: TButton;
    btnGrupo2BolasMarcarTodos244: TButton;
    btnGrupo2BolasMarcarTodos245: TButton;
    btnGrupo2BolasMarcarTodos246: TButton;
    btnGrupo2BolasMarcarTodos247: TButton;
    btnGrupo2BolasMarcarTodos248: TButton;
    btnGrupo2BolasMarcarTodos249: TButton;
    btnGrupo2BolasMarcarTodos250: TButton;
    btnGrupo2BolasMarcarTodos251: TButton;
    btnGrupo2BolasMarcarTodos252: TButton;
    btnGrupo2BolasMarcarTodos253: TButton;
    btnGrupo2BolasMarcarTodos254: TButton;
    btnGrupo2BolasMarcarTodos255: TButton;
    btnGrupo2BolasMarcarTodos256: TButton;
    btnGrupo2BolasMarcarTodos257: TButton;
    btnGrupo2BolasMarcarTodos258: TButton;
    btnGrupo2BolasMarcarTodos259: TButton;
    btnGrupo2BolasMarcarTodos260: TButton;
    btnGrupo2BolasMarcarTodos261: TButton;
    btnGrupo2BolasMarcarTodos262: TButton;
    btnGrupo2BolasMarcarTodos263: TButton;
    btnGrupo2BolasMarcarTodos264: TButton;
    btnGrupo2BolasMarcarTodos265: TButton;
    btnGrupo2BolasMarcarTodos266: TButton;
    btnGrupo2BolasMarcarTodos267: TButton;
    btnGrupo2BolasMarcarTodos268: TButton;
    btnGrupo2BolasMarcarTodos269: TButton;
    btnGrupo2BolasMarcarTodos270: TButton;
    btnGrupo2BolasMarcarTodos271: TButton;
    btnGrupo2BolasMarcarTodos272: TButton;
    btnGrupo2BolasMarcarTodos273: TButton;
    btnGrupo2BolasMarcarTodos274: TButton;
    btnGrupo2BolasMarcarTodos275: TButton;
    btnGrupo2BolasMarcarTodos276: TButton;
    btnGrupo2BolasMarcarTodos277: TButton;
    btnGrupo2BolasMarcarTodos278: TButton;
    btnGrupo2BolasMarcarTodos279: TButton;
    btnGrupo2BolasMarcarTodos280: TButton;
    btnGrupo2BolasMarcarTodos281: TButton;
    btnGrupo2BolasMarcarTodos282: TButton;
    btnGrupo2BolasMarcarTodos283: TButton;
    btnGrupo2BolasMarcarTodos284: TButton;
    btnGrupo2BolasMarcarTodos285: TButton;
    btnGrupo2BolasMarcarTodos286: TButton;
    btnGrupo2BolasMarcarTodos287: TButton;
    btnGrupo2BolasMarcarTodos288: TButton;
    btnGrupo2BolasMarcarTodos289: TButton;
    btnGrupo2BolasMarcarTodos290: TButton;
    btnGrupo2BolasMarcarTodos291: TButton;
    btnGrupo2BolasMarcarTodos292: TButton;
    btnGrupo2BolasMarcarTodos293: TButton;
    btnGrupo2BolasMarcarTodos294: TButton;
    btnGrupo2BolasMarcarTodos295: TButton;
    btnGrupo2BolasMarcarTodos296: TButton;
    btnGrupo2BolasMarcarTodos297: TButton;
    btnGrupo2BolasMarcarTodos298: TButton;
    btnGrupo2BolasMarcarTodos299: TButton;
    btnGrupo2BolasMarcarTodos300: TButton;
    btnGrupo2BolasMarcarTodos301: TButton;
    btnGrupo2BolasMarcarTodos302: TButton;
    btnGrupo2BolasMarcarTodos303: TButton;
    btnGrupo2BolasMarcarTodos304: TButton;
    btnGrupo2BolasMarcarTodos305: TButton;
    btnGrupo2BolasMarcarTodos306: TButton;
    btnGrupo2BolasMarcarTodos307: TButton;
    btnGrupo2BolasMarcarTodos308: TButton;
    btnGrupo2BolasMarcarTodos309: TButton;
    btnGrupo2BolasMarcarTodos31 : TButton;
    btnGrupo2BolasMarcarTodos310: TButton;
    btnGrupo2BolasMarcarTodos311: TButton;
    btnGrupo2BolasMarcarTodos312: TButton;
    btnGrupo2BolasMarcarTodos313: TButton;
    btnGrupo2BolasMarcarTodos314: TButton;
    btnGrupo2BolasMarcarTodos315: TButton;
    btnGrupo2BolasMarcarTodos316: TButton;
    btnGrupo2BolasMarcarTodos317: TButton;
    btnGrupo2BolasMarcarTodos318: TButton;
    btnGrupo2BolasMarcarTodos319: TButton;
    btnGrupo2BolasMarcarTodos32 : TButton;
    btnGrupo2BolasMarcarTodos320: TButton;
    btnGrupo2BolasMarcarTodos321: TButton;
    btnGrupo2BolasMarcarTodos322: TButton;
    btnGrupo2BolasMarcarTodos323: TButton;
    btnGrupo2BolasMarcarTodos324: TButton;
    btnGrupo2BolasMarcarTodos325: TButton;
    btnGrupo2BolasMarcarTodos326: TButton;
    btnGrupo2BolasMarcarTodos327: TButton;
    btnGrupo2BolasMarcarTodos328: TButton;
    btnGrupo2BolasMarcarTodos329: TButton;
    btnGrupo2BolasMarcarTodos33 : TButton;
    btnGrupo2BolasMarcarTodos330: TButton;
    btnGrupo2BolasMarcarTodos331: TButton;
    btnGrupo2BolasMarcarTodos332: TButton;
    btnGrupo2BolasMarcarTodos333: TButton;
    btnGrupo2BolasMarcarTodos334: TButton;
    btnGrupo2BolasMarcarTodos335: TButton;
    btnGrupo2BolasMarcarTodos336: TButton;
    btnGrupo2BolasMarcarTodos337: TButton;
    btnGrupo2BolasMarcarTodos338: TButton;
    btnGrupo2BolasMarcarTodos339: TButton;
    btnGrupo2BolasMarcarTodos34 : TButton;
    btnGrupo2BolasMarcarTodos340: TButton;
    btnGrupo2BolasMarcarTodos341: TButton;
    btnGrupo2BolasMarcarTodos342: TButton;
    btnGrupo2BolasMarcarTodos343: TButton;
    btnGrupo2BolasMarcarTodos344: TButton;
    btnGrupo2BolasMarcarTodos345: TButton;
    btnGrupo2BolasMarcarTodos346: TButton;
    btnGrupo2BolasMarcarTodos347: TButton;
    btnGrupo2BolasMarcarTodos348: TButton;
    btnGrupo2BolasMarcarTodos349: TButton;
    btnGrupo2BolasMarcarTodos35 : TButton;
    btnGrupo2BolasMarcarTodos350: TButton;
    btnGrupo2BolasMarcarTodos4: TButton;
    btnGrupo2BolasMarcarTodos44 : TButton;
    btnGrupo2BolasMarcarTodos45 : TButton;
    btnGrupo2BolasMarcarTodos46 : TButton;
    btnGrupo2BolasMarcarTodos47 : TButton;
    btnGrupo2BolasMarcarTodos48 : TButton;
    btnGrupo2BolasMarcarTodos49: TButton;
    btnGrupo2BolasMarcarTodos50: TButton;
    btnGrupo2BolasMarcarTodos51: TButton;
    btnGrupo2BolasMarcarTodos52: TButton;
    btnGrupo2BolasMarcarTodos53: TButton;
    btnGrupo2BolasMarcarTodos54: TButton;
    btnGrupo2BolasMarcarTodos55: TButton;
    btnGrupo2BolasMarcarTodos56: TButton;
    btnGrupo2BolasMarcarTodos57: TButton;
    btnGrupo2BolasMarcarTodos58: TButton;
    btnGrupo2BolasMarcarTodos59: TButton;
    btnGrupo2BolasMarcarTodos60: TButton;
    btnGrupo2BolasMarcarTodos61: TButton;
    btnGrupo2BolasMarcarTodos62: TButton;
    btnGrupo2BolasMarcarTodos63: TButton;
    btnGrupo2BolasMarcarTodos64: TButton;
    btnGrupo2BolasMarcarTodos65: TButton;
    btnGrupo2BolasMarcarTodos66: TButton;
    btnGrupo2BolasMarcarTodos67: TButton;
    btnGrupo2BolasMarcarTodos68: TButton;
    btnGrupo2BolasMarcarTodos69: TButton;
    btnGrupo2BolasMarcarTodos70: TButton;
    btnGrupo2BolasMarcarTodos71: TButton;
    btnGrupo2BolasMarcarTodos72: TButton;
    btnGrupo2BolasMarcarTodos73: TButton;
    btnGrupo2BolasMarcarTodos74: TButton;
    btnGrupo2BolasMarcarTodos75: TButton;
    btnGrupo2BolasMarcarTodos76: TButton;
    btnGrupo2BolasMarcarTodos77: TButton;
    btnGrupo2BolasMarcarTodos78: TButton;
    btnGrupo2BolasMarcarTodos79: TButton;
    btnGrupo2BolasMarcarTodos8: TButton;
    btnGrupo2BolasMarcarTodos80: TButton;
    btnGrupo2BolasMarcarTodos81: TButton;
    btnGrupo2BolasMarcarTodos82: TButton;
    btnGrupo2BolasMarcarTodos83: TButton;
    btnGrupo2BolasMarcarTodos84: TButton;
    btnGrupo2BolasMarcarTodos85: TButton;
    btnGrupo2BolasMarcarTodos86: TButton;
    btnGrupo2BolasMarcarTodos87: TButton;
    btnGrupo2BolasMarcarTodos88: TButton;
    btnGrupo2BolasMarcarTodos89: TButton;
    btnGrupo2BolasMarcarTodos9: TButton;
    btnGrupo2BolasMarcarTodos90: TButton;
    btnGrupo2BolasMarcarTodos91: TButton;
    btnGrupo2BolasMarcarTodos92: TButton;
    btnGrupo2BolasMarcarTodos93: TButton;
    btnGrupo2BolasMarcarTodos94: TButton;
    btnGrupo2BolasMarcarTodos95: TButton;
    btnGrupo2BolasMarcarTodos96: TButton;
    btnGrupo2BolasMarcarTodos97: TButton;
    btnGrupo2BolasMarcarTodos98: TButton;
    btnGrupo2BolasMarcarTodos99: TButton;
    btnPararDeAtualizarNovosRepetidos: TButton;
    btnFrequenciaAtualizar: TButton;
    btnGeradorAleatorioSemFiltro: TButton;
    btnGeradorAleatorioComFiltro: TButton;
    btnGrupo2BolasDesmarcarTodos1: TButton;
    btnGrupo2BolasDesmarcarTodos2: TButton;
    btnGrupo2BolasDesmarcarTodos20: TButton;
    btnGrupo2BolasDesmarcarTodos21: TButton;
    btnGrupo2BolasDesmarcarTodos22: TButton;
    btnGrupo2BolasDesmarcarTodos23: TButton;
    btnGrupo2BolasDesmarcarTodos24: TButton;
    btnGrupo2BolasDesmarcarTodos25: TButton;
    btnGrupo2BolasDesmarcarTodos26: TButton;
    btnGrupo2BolasDesmarcarTodos27: TButton;
    btnGrupo2BolasDesmarcarTodos28: TButton;
    btnGrupo2BolasDesmarcarTodos29: TButton;
    btnGrupo2BolasDesmarcarTodos3: TButton;
    btnGrupo2BolasDesmarcarTodos30: TButton;
    btnGrupo2BolasDesmarcarTodos36: TButton;
    btnGrupo2BolasDesmarcarTodos37: TButton;
    btnGrupo2BolasDesmarcarTodos38: TButton;
    btnGrupo2BolasDesmarcarTodos39: TButton;
    btnGrupo2BolasDesmarcarTodos40: TButton;
    btnGrupo2BolasDesmarcarTodos41: TButton;
    btnGrupo2BolasDesmarcarTodos42: TButton;
    btnGrupo2BolasDesmarcarTodos43: TButton;
    btnGrupo2BolasDesmarcarTodos5: TButton;
    btnGrupo2BolasDesmarcarTodos6: TButton;
    btnGrupo2BolasDesmarcarTodos7: TButton;
    btnGrupo2BolasMarcarTodos1: TButton;
    btnGrupo2BolasMarcarTodos2: TButton;
    btnGrupo2BolasMarcarTodos20: TButton;
    btnGrupo2BolasMarcarTodos21: TButton;
    btnGrupo2BolasMarcarTodos22: TButton;
    btnGrupo2BolasMarcarTodos23: TButton;
    btnGrupo2BolasMarcarTodos24: TButton;
    btnGrupo2BolasMarcarTodos25: TButton;
    btnGrupo2BolasMarcarTodos26: TButton;
    btnGrupo2BolasMarcarTodos27: TButton;
    btnGrupo2BolasMarcarTodos28: TButton;
    btnGrupo2BolasMarcarTodos29: TButton;
    btnGrupo2BolasMarcarTodos3: TButton;
    btnGrupo2BolasMarcarTodos30: TButton;
    btnGrupo2BolasMarcarTodos36: TButton;
    btnGrupo2BolasMarcarTodos37: TButton;
    btnGrupo2BolasMarcarTodos38: TButton;
    btnGrupo2BolasMarcarTodos39: TButton;
    btnGrupo2BolasMarcarTodos40: TButton;
    btnGrupo2BolasMarcarTodos41: TButton;
    btnGrupo2BolasMarcarTodos42: TButton;
    btnGrupo2BolasMarcarTodos43: TButton;
    btnGrupo2BolasMarcarTodos5: TButton;
    btnGrupo2BolasMarcarTodos6: TButton;
    btnGrupo2BolasMarcarTodos7: TButton;
    btnLotofacilResultadoExcluir: TButton;
    btnLotofacilResultadoInserir: TButton;
    btnLotofacilResultadoAtualizar: TButton;
    btnFiltroGerar: TButton;
    btnGrupo2BolasDesmarcarTodos: TButton;
    btnGrupo2BolasMarcarTodos: TButton;
    btnAleatorioNovo: TButton;
    btnExibirAleatorio: TButton;
    btnFiltroExcluir : TButton;
    btnVerificarAcerto: TButton;
    btnNovosFiltros: TButton;
    btnSelecionar: TButton;
    btnAleatorio_Verificar_Acerto: TButton;
    btnObterResultados: TButton;
    btnAtualizar_Combinacao_Complementar: TButton;
    btnAtualizarTabelaResultados: TButton;
    btnAtualizarSomaFrequencia : TButton;
    CheckGroup1 : TCheckGroup;
    chkSomaFrequenciaCombinacoes : TCheckGroup;
    chkComplementar_Bolas_por_combinacao: TCheckGroup;
    chkExcluirJogos_LTF_QT: TCheckGroup;
    chkExcluir_Jogos_Ja_Sorteados: TCheckGroup;
    chkExibirCampos: TCheckListBox;
    chkExibirCampos1: TCheckListBox;
    cmbNovosRepetidosConsolidadoConcursoFinal: TComboBox;
    cmb_intervalo_por_concurso_final_b10_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b10_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b10_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b10_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b10_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b11_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b11_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b11_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b11_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b11_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b12_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b12_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b12_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b12_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b13_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b13_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b13_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b14_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b14_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b15_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b1: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b11: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b12: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b13: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b14: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b15: TComboBox;
    cmb_intervalo_por_concurso_final_b10_a_b10: TComboBox;
    cmb_intervalo_por_concurso_final_b9_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b6: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b5: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b4: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b3: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b2: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b2: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b3: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b4: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b5: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b6: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b1_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b3: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b4: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b5: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b6: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b2_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b4: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b5: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b6: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b3_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b5: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b6: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b4_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b6: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b5_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b7: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b6_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b8: TComboBox;
    cmb_intervalo_por_concurso_final_b7_a_b9: TComboBox;
    cmb_intervalo_por_concurso_final_b8_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b10_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b10_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b10_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b10_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b10_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b11_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b11_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b11_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b11_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b11_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b12_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b12_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b12_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b12_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b13_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b13_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b13_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b14_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b14_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b15_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b1: TComboBox;
    cmbSomaFrequenciaConcursoFinal : TComboBox;
    cmbSomaFrequenciaConcursoInicial : TComboBox;
    cmbParImparConsolidadoConcursoFinal: TComboBox;
    cmbExternoInternoConsolidadoConcursoFinal: TComboBox;
    cmbPrimoNaoPrimoConsolidadoConcursoFinal: TComboBox;
    cmbNovosRepetidosConsolidadoConcursoInicial: TComboBox;
    cmbConcursoFrequenciaNaoSair: TComboBox;
    cmbConcursoFrequenciaSair: TComboBox;
    cmbConcursoFrequenciaTotalSair: TComboBox;
    cmbConcursoFrequenciaTotalNaoSair: TComboBox;
    cmbConcursoNovosRepetidos: TComboBox;
    cmbConcurso_Aleatorio_Verificar_Acerto: TComboBox;
    cmbAleatorioFiltroData: TComboBox;
    cmbAleatorioFiltroHora: TComboBox;
    cmbFrequenciaInicio: TComboBox;
    cmbFrequenciaFim: TComboBox;
    cmbConcursoDeletar: TComboBox;
    cmbAinda_Nao_Saiu_Maximo: TComboBox;
    cmbDeixou_de_Sair_Maximo: TComboBox;
    cmbFrequencia_Maximo_Nao_Sair: TComboBox;
    cmbFrequencia_Minimo_Nao_Sair: TComboBox;
    cmbParImparConsolidadoConcursoInicial: TComboBox;
    cmbExternoInternoConsolidadoConcursoInicial: TComboBox;
    cmbAlgarismo_na_dezena_consolidado_concurso_final : TComboBox;
    cmbPrimoNaoPrimoConsolidadoConcursoInicial: TComboBox;
    cmbAlgarismo_na_dezena_consolidado_concurso_inicial : TComboBox;
    cmbRepetindo_Maximo: TComboBox;
    cmbFrequencia_Maximo_Sair: TComboBox;
    cmbFrequenciaMaximoSair1: TComboBox;
    cmbFrequenciaMaximoSair2: TComboBox;
    cmbAinda_Nao_Saiu_Minimo: TComboBox;
    cmbDeixou_de_Sair_Minimo: TComboBox;
    cmbRepetindo_Minimo: TComboBox;
    cmbFrequencia_Minimo_Sair: TComboBox;
    cmbNovo_Maximo: TComboBox;
    cmbNovo_Minimo: TComboBox;
    cmbFrequenciaMinimoSair1: TComboBox;
    cmbFrequenciaMinimoSair2: TComboBox;
    cmbFiltroData: TComboBox;
    cmbFiltroHora: TComboBox;
    cmbConcursoVerificarAcerto: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b11: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b12: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b13: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b14: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b15: TComboBox;
    cmb_intervalo_por_concurso_inicial_b10_a_b10: TComboBox;
    cmb_intervalo_por_concurso_inicial_b9_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b6: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b5: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b4: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b3: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b2: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b2: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b3: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b4: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b5: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b6: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b1_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b3: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b4: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b5: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b6: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b2_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b4: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b5: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b6: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b3_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b5: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b6: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b4_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b6: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b5_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b7: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b6_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b8: TComboBox;
    cmb_intervalo_por_concurso_inicial_b7_a_b9: TComboBox;
    cmb_intervalo_por_concurso_inicial_b8_a_b9: TComboBox;
    dtpConcursoData: TDateTimePicker;
    grGrupo3Bolas: TGroupBox;
    grGrupo2Bolas1: TGroupBox;
    grGrupo4Bolas: TGroupBox;
    grGrupo5Bolas: TGroupBox;
    grConcursoData: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox100: TGroupBox;
    GroupBox101: TGroupBox;
    GroupBox102: TGroupBox;
    GroupBox103: TGroupBox;
    GroupBox104: TGroupBox;
    GroupBox105: TGroupBox;
    GroupBox106: TGroupBox;
    GroupBox107: TGroupBox;
    GroupBox108: TGroupBox;
    GroupBox109: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox110: TGroupBox;
    GroupBox111: TGroupBox;
    GroupBox112: TGroupBox;
    GroupBox113: TGroupBox;
    GroupBox114: TGroupBox;
    GroupBox115: TGroupBox;
    GroupBox116: TGroupBox;
    GroupBox117: TGroupBox;
    GroupBox118: TGroupBox;
    GroupBox119: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox120: TGroupBox;
    GroupBox121: TGroupBox;
    GroupBox122: TGroupBox;
    GroupBox123: TGroupBox;
    GroupBox124: TGroupBox;
    GroupBox125: TGroupBox;
    GroupBox126: TGroupBox;
    GroupBox127: TGroupBox;
    GroupBox128: TGroupBox;
    GroupBox129: TGroupBox;
    GroupBox130: TGroupBox;
    GroupBox131: TGroupBox;
    GroupBox132: TGroupBox;
    GroupBox133: TGroupBox;
    GroupBox134: TGroupBox;
    GroupBox135: TGroupBox;
    GroupBox136: TGroupBox;
    GroupBox137: TGroupBox;
    GroupBox138: TGroupBox;
    GroupBox139: TGroupBox;
    GroupBox140: TGroupBox;
    GroupBox141: TGroupBox;
    GroupBox142: TGroupBox;
    GroupBox143: TGroupBox;
    GroupBox144: TGroupBox;
    GroupBox145: TGroupBox;
    GroupBox146: TGroupBox;
    GroupBox147: TGroupBox;
    GroupBox148: TGroupBox;
    GroupBox149: TGroupBox;
    GroupBox15: TGroupBox;
    GroupBox150: TGroupBox;
    GroupBox151: TGroupBox;
    GroupBox152: TGroupBox;
    GroupBox153: TGroupBox;
    GroupBox154: TGroupBox;
    GroupBox155: TGroupBox;
    GroupBox156: TGroupBox;
    GroupBox157: TGroupBox;
    GroupBox158: TGroupBox;
    GroupBox159: TGroupBox;
    GroupBox16: TGroupBox;
    GroupBox160: TGroupBox;
    GroupBox161: TGroupBox;
    GroupBox162: TGroupBox;
    GroupBox163: TGroupBox;
    GroupBox164: TGroupBox;
    GroupBox165: TGroupBox;
    GroupBox166: TGroupBox;
    GroupBox167: TGroupBox;
    GroupBox168: TGroupBox;
    GroupBox169: TGroupBox;
    GroupBox17: TGroupBox;
    GroupBox170: TGroupBox;
    GroupBox171: TGroupBox;
    GroupBox172: TGroupBox;
    GroupBox173: TGroupBox;
    GroupBox174: TGroupBox;
    GroupBox175: TGroupBox;
    GroupBox176: TGroupBox;
    GroupBox177: TGroupBox;
    GroupBox178: TGroupBox;
    GroupBox179: TGroupBox;
    GroupBox18: TGroupBox;
    GroupBox180: TGroupBox;
    GroupBox181: TGroupBox;
    GroupBox182: TGroupBox;
    GroupBox183: TGroupBox;
    GroupBox184: TGroupBox;
    GroupBox185: TGroupBox;
    GroupBox186: TGroupBox;
    GroupBox187: TGroupBox;
    GroupBox188: TGroupBox;
    GroupBox189: TGroupBox;
    GroupBox19: TGroupBox;
    GroupBox190: TGroupBox;
    GroupBox191: TGroupBox;
    GroupBox192: TGroupBox;
    GroupBox193: TGroupBox;
    GroupBox194: TGroupBox;
    GroupBox195: TGroupBox;
    GroupBox196: TGroupBox;
    GroupBox197: TGroupBox;
    GroupBox198: TGroupBox;
    GroupBox199: TGroupBox;
    GroupBox20: TGroupBox;
    GroupBox200: TGroupBox;
    GroupBox201: TGroupBox;
    GroupBox202: TGroupBox;
    GroupBox203: TGroupBox;
    GroupBox204: TGroupBox;
    GroupBox205: TGroupBox;
    GroupBox206: TGroupBox;
    GroupBox207: TGroupBox;
    GroupBox208: TGroupBox;
    GroupBox209: TGroupBox;
    GroupBox21: TGroupBox;
    GroupBox210: TGroupBox;
    GroupBox211: TGroupBox;
    GroupBox212: TGroupBox;
    GroupBox213: TGroupBox;
    GroupBox214: TGroupBox;
    GroupBox215: TGroupBox;
    GroupBox216: TGroupBox;
    GroupBox217: TGroupBox;
    GroupBox218: TGroupBox;
    GroupBox219: TGroupBox;
    GroupBox22: TGroupBox;
    GroupBox220: TGroupBox;
    GroupBox221: TGroupBox;
    GroupBox222: TGroupBox;
    GroupBox223: TGroupBox;
    GroupBox224: TGroupBox;
    GroupBox225: TGroupBox;
    GroupBox226: TGroupBox;
    GroupBox227: TGroupBox;
    GroupBox228: TGroupBox;
    GroupBox229: TGroupBox;
    GroupBox23: TGroupBox;
    GroupBox230: TGroupBox;
    GroupBox231: TGroupBox;
    GroupBox232: TGroupBox;
    GroupBox233: TGroupBox;
    GroupBox234: TGroupBox;
    GroupBox235: TGroupBox;
    GroupBox236: TGroupBox;
    GroupBox237: TGroupBox;
    GroupBox238: TGroupBox;
    GroupBox239: TGroupBox;
    GroupBox24: TGroupBox;
    GroupBox240: TGroupBox;
    GroupBox241: TGroupBox;
    GroupBox242: TGroupBox;
    GroupBox243: TGroupBox;
    GroupBox244: TGroupBox;
    GroupBox245: TGroupBox;
    GroupBox25: TGroupBox;
    GroupBox26: TGroupBox;
    GroupBox27: TGroupBox;
    GroupBox28: TGroupBox;
    GroupBox29: TGroupBox;
    GroupBox30: TGroupBox;
    GroupBox31: TGroupBox;
    GroupBox32: TGroupBox;
    GroupBox33: TGroupBox;
    GroupBox34: TGroupBox;
    GroupBox35: TGroupBox;
    GroupBox36: TGroupBox;
    GroupBox37: TGroupBox;
    GroupBox38: TGroupBox;
    GroupBox39: TGroupBox;
    GroupBox40: TGroupBox;
    GroupBox41: TGroupBox;
    GroupBox42 : TGroupBox;
    GroupBox43 : TGroupBox;
    GroupBox44 : TGroupBox;
    GroupBox45 : TGroupBox;
    GroupBox46: TGroupBox;
    GroupBox47: TGroupBox;
    GroupBox48: TGroupBox;
    GroupBox49: TGroupBox;
    GroupBox50: TGroupBox;
    GroupBox51: TGroupBox;
    GroupBox52: TGroupBox;
    GroupBox53: TGroupBox;
    GroupBox54: TGroupBox;
    GroupBox55: TGroupBox;
    GroupBox56: TGroupBox;
    GroupBox57: TGroupBox;
    GroupBox58: TGroupBox;
    GroupBox59: TGroupBox;
    GroupBox60: TGroupBox;
    GroupBox61: TGroupBox;
    GroupBox62: TGroupBox;
    GroupBox63: TGroupBox;
    GroupBox64: TGroupBox;
    GroupBox65: TGroupBox;
    GroupBox66: TGroupBox;
    GroupBox67: TGroupBox;
    GroupBox68: TGroupBox;
    GroupBox69: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox70: TGroupBox;
    GroupBox71: TGroupBox;
    GroupBox72: TGroupBox;
    GroupBox73: TGroupBox;
    GroupBox74: TGroupBox;
    GroupBox75: TGroupBox;
    GroupBox76: TGroupBox;
    GroupBox77: TGroupBox;
    GroupBox78: TGroupBox;
    GroupBox79: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox80: TGroupBox;
    GroupBox81: TGroupBox;
    GroupBox82: TGroupBox;
    GroupBox83: TGroupBox;
    GroupBox84: TGroupBox;
    GroupBox85: TGroupBox;
    GroupBox86: TGroupBox;
    GroupBox87: TGroupBox;
    GroupBox88: TGroupBox;
    GroupBox89: TGroupBox;
    GroupBox90: TGroupBox;
    GroupBox91: TGroupBox;
    GroupBox92: TGroupBox;
    GroupBox93: TGroupBox;
    GroupBox94: TGroupBox;
    GroupBox95: TGroupBox;
    GroupBox96: TGroupBox;
    GroupBox97: TGroupBox;
    GroupBox98: TGroupBox;
    GroupBox99: TGroupBox;
    grpBolasB1_15Bolas: TGroupBox;
    grpBolasB1_B2_B3_B4_15Bolas: TGroupBox;
    grpBolasB1_B2_B3_15Bolas: TGroupBox;
    grpBolasB1_B2_15Bolas: TGroupBox;
    grpBolasB1_B2_B3_B4_15Bolas1: TGroupBox;
    grpFrequenciaDeixouDeSair10: TGroupBox;
    grpFrequenciaDeixouDeSair100: TGroupBox;
    grpFrequenciaDeixouDeSair101: TGroupBox;
    grpFrequenciaDeixouDeSair102: TGroupBox;
    grpFrequenciaDeixouDeSair103: TGroupBox;
    grpFrequenciaDeixouDeSair104: TGroupBox;
    grpFrequenciaDeixouDeSair105: TGroupBox;
    grpFrequenciaDeixouDeSair106: TGroupBox;
    grpFrequenciaDeixouDeSair11: TGroupBox;
    grpFrequenciaDeixouDeSair12: TGroupBox;
    grpFrequenciaDeixouDeSair13: TGroupBox;
    grpFrequenciaDeixouDeSair14: TGroupBox;
    grpFrequenciaDeixouDeSair15: TGroupBox;
    grpFrequenciaDeixouDeSair16: TGroupBox;
    grpFrequenciaDeixouDeSair17: TGroupBox;
    grpFrequenciaDeixouDeSair18: TGroupBox;
    grpFrequenciaDeixouDeSair19: TGroupBox;
    grpFrequenciaDeixouDeSair20: TGroupBox;
    grpFrequenciaDeixouDeSair21: TGroupBox;
    grpFrequenciaDeixouDeSair22: TGroupBox;
    grpFrequenciaDeixouDeSair23: TGroupBox;
    grpFrequenciaDeixouDeSair24: TGroupBox;
    grpFrequenciaDeixouDeSair25: TGroupBox;
    grpFrequenciaDeixouDeSair26: TGroupBox;
    grpFrequenciaDeixouDeSair27: TGroupBox;
    grpFrequenciaDeixouDeSair28: TGroupBox;
    grpFrequenciaDeixouDeSair29: TGroupBox;
    grpFrequenciaDeixouDeSair30: TGroupBox;
    grpFrequenciaDeixouDeSair31: TGroupBox;
    grpFrequenciaDeixouDeSair32: TGroupBox;
    grpFrequenciaDeixouDeSair33: TGroupBox;
    grpFrequenciaDeixouDeSair34: TGroupBox;
    grpFrequenciaDeixouDeSair35: TGroupBox;
    grpFrequenciaDeixouDeSair36: TGroupBox;
    grpFrequenciaDeixouDeSair37: TGroupBox;
    grpFrequenciaDeixouDeSair38: TGroupBox;
    grpFrequenciaDeixouDeSair39: TGroupBox;
    grpFrequenciaDeixouDeSair40: TGroupBox;
    grpFrequenciaDeixouDeSair41: TGroupBox;
    grpFrequenciaDeixouDeSair42: TGroupBox;
    grpFrequenciaDeixouDeSair43: TGroupBox;
    grpFrequenciaDeixouDeSair44: TGroupBox;
    grpFrequenciaDeixouDeSair45: TGroupBox;
    grpFrequenciaDeixouDeSair46: TGroupBox;
    grpFrequenciaDeixouDeSair47: TGroupBox;
    grpFrequenciaDeixouDeSair48: TGroupBox;
    grpFrequenciaDeixouDeSair49: TGroupBox;
    grpFrequenciaDeixouDeSair50: TGroupBox;
    grpFrequenciaDeixouDeSair51: TGroupBox;
    grpFrequenciaDeixouDeSair52: TGroupBox;
    grpFrequenciaDeixouDeSair53: TGroupBox;
    grpFrequenciaDeixouDeSair54: TGroupBox;
    grpFrequenciaDeixouDeSair55: TGroupBox;
    grpFrequenciaDeixouDeSair56: TGroupBox;
    grpFrequenciaDeixouDeSair57: TGroupBox;
    grpFrequenciaDeixouDeSair58: TGroupBox;
    grpFrequenciaDeixouDeSair59: TGroupBox;
    grpFrequenciaDeixouDeSair60: TGroupBox;
    grpFrequenciaDeixouDeSair61: TGroupBox;
    grpFrequenciaDeixouDeSair62: TGroupBox;
    grpFrequenciaDeixouDeSair63: TGroupBox;
    grpFrequenciaDeixouDeSair64: TGroupBox;
    grpFrequenciaDeixouDeSair65: TGroupBox;
    grpFrequenciaDeixouDeSair66: TGroupBox;
    grpFrequenciaDeixouDeSair67: TGroupBox;
    grpFrequenciaDeixouDeSair68: TGroupBox;
    grpFrequenciaDeixouDeSair69: TGroupBox;
    grpFrequenciaDeixouDeSair7: TGroupBox;
    grpFrequenciaDeixouDeSair70: TGroupBox;
    grpFrequenciaDeixouDeSair71: TGroupBox;
    grpFrequenciaDeixouDeSair72: TGroupBox;
    grpFrequenciaDeixouDeSair73: TGroupBox;
    grpFrequenciaDeixouDeSair74: TGroupBox;
    grpFrequenciaDeixouDeSair75: TGroupBox;
    grpFrequenciaDeixouDeSair76: TGroupBox;
    grpFrequenciaDeixouDeSair77: TGroupBox;
    grpFrequenciaDeixouDeSair78: TGroupBox;
    grpFrequenciaDeixouDeSair79: TGroupBox;
    grpFrequenciaDeixouDeSair8: TGroupBox;
    grpFrequenciaDeixouDeSair80: TGroupBox;
    grpFrequenciaDeixouDeSair81: TGroupBox;
    grpFrequenciaDeixouDeSair82: TGroupBox;
    grpFrequenciaDeixouDeSair83: TGroupBox;
    grpFrequenciaDeixouDeSair84: TGroupBox;
    grpFrequenciaDeixouDeSair85: TGroupBox;
    grpFrequenciaDeixouDeSair86: TGroupBox;
    grpFrequenciaDeixouDeSair87: TGroupBox;
    grpFrequenciaDeixouDeSair88: TGroupBox;
    grpFrequenciaDeixouDeSair89: TGroupBox;
    grpFrequenciaDeixouDeSair9: TGroupBox;
    grpFrequenciaDeixouDeSair90: TGroupBox;
    grpFrequenciaDeixouDeSair91: TGroupBox;
    grpFrequenciaDeixouDeSair92: TGroupBox;
    grpFrequenciaDeixouDeSair93: TGroupBox;
    grpFrequenciaDeixouDeSair94: TGroupBox;
    grpFrequenciaDeixouDeSair95: TGroupBox;
    grpFrequenciaDeixouDeSair96: TGroupBox;
    grpFrequenciaDeixouDeSair97: TGroupBox;
    grpFrequenciaDeixouDeSair98: TGroupBox;
    grpFrequenciaDeixouDeSair99: TGroupBox;
    grp_b6_a_b11_por_concurso: TGroupBox;
    grp_b6_a_b12_por_concurso: TGroupBox;
    grp_b6_a_b13_por_concurso: TGroupBox;
    grp_b6_a_b14_por_concurso: TGroupBox;
    grp_b6_a_b15_por_concurso: TGroupBox;
    grp_b6_a_b11: TGroupBox;
    grp_b6_a_b12: TGroupBox;
    grp_b6_a_b13: TGroupBox;
    grp_b6_a_b14: TGroupBox;
    grp_b6_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b10_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b10_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b10_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b10_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b10_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b11_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b11_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b11_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b11_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b11_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b12_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b12_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b12_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b12_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b13_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b13_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b13_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b14_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b14_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b15_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b1: TGroupBox;
    grp_b10_a_b11_por_concurso: TGroupBox;
    grp_b10_a_b12_por_concurso: TGroupBox;
    grp_b10_a_b13_por_concurso: TGroupBox;
    grp_b10_a_b14_por_concurso: TGroupBox;
    grp_b10_a_b15_por_concurso: TGroupBox;
    grp_b10_a_b11: TGroupBox;
    grp_b10_a_b12: TGroupBox;
    grp_b10_a_b13: TGroupBox;
    grp_b10_a_b14: TGroupBox;
    grp_b10_a_b15: TGroupBox;
    grp_b11_a_b11: TGroupBox;
    grp_b11_a_b11_por_concurso: TGroupBox;
    grpColunaB1 : TGroupBox;
    grpColunaB10 : TGroupBox;
    grpColunaB11 : TGroupBox;
    grpColunaB12 : TGroupBox;
    grpColunaB13 : TGroupBox;
    grpColunaB14 : TGroupBox;
    grpColunaB15 : TGroupBox;
    grpBolas_na_mesma_coluna: TGroupBox;
    grpBolas_na_mesma_coluna_por_concurso: TGroupBox;
    grpColunaB2 : TGroupBox;
    grpColunaB3 : TGroupBox;
    grpColunaB4 : TGroupBox;
    grpColunaB5 : TGroupBox;
    grpColunaB6 : TGroupBox;
    grpColunaB7 : TGroupBox;
    grpColunaB8 : TGroupBox;
    grpColunaB9 : TGroupBox;
    grpConcursoFrequenciaTotalNaoSair: TGroupBox;
    grpDiferenca_Qt_1: TGroupBox;
    grpDiferenca_Qt_1_Qt_2: TGroupBox;
    grpDiferenca_qt_alt: TGroupBox;
    grpDiferenca_qt_alt1: TGroupBox;
    grpDiferenca_qt_alt2: TGroupBox;
    grpDiferenca_qt_alt3: TGroupBox;
    grpDiferenca_qt_alt4: TGroupBox;
    grpExternoInterno16Bolas1: TGroupBox;
    grpAlgarismo_na_dezena_por_concurso : TGroupBox;
    grpFiltroData: TGroupBox;
    grpFiltroData1: TGroupBox;
    grpFiltroHora: TGroupBox;
    grpFiltroHora1: TGroupBox;
    grpConcursoFrequenciaTotalSair: TGroupBox;
    grpFrequenciaBolaNaoSair: TGroupBox;
    grpFrequenciaDeixouDeSair: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox9: TGroupBox;
    grpFrequenciaDeixouDeSair1: TGroupBox;
    grpFrequenciaDeixouDeSair2: TGroupBox;
    grpFrequenciaDeixouDeSair3: TGroupBox;
    grpFrequenciaDeixouDeSair4: TGroupBox;
    grpFrequenciaDeixouDeSair5: TGroupBox;
    grpFrequenciaDeixouDeSair6: TGroupBox;
    grpAlgarismo_na_dezena : TGroupBox;
    grpAlgarismo_nas_dezenas_consolidado : TGroupBox;
    grpSomaFrequenciaConcurso : TGroupBox;
    grpPrimoNaoPrimoConsolidadoConcurso: TGroupBox;
    grpFrequencialSair: TGroupBox;
    grpFrequenciaTotalNaoSair: TGroupBox;
    grpParImparConsolidado: TGroupBox;
    grpExternoInternoConsolidado: TGroupBox;
    grpPrimoNaoPrimoConsolidado: TGroupBox;
    grpNovosRepetidosPorConcurso: TGroupBox;
    grpNovosRepetidosConsolidado: TGroupBox;
    grpParImparPorConcurso: TGroupBox;
    grpPrimo15Bolas: TGroupBox;
    grpFrequenciaInicio: TGroupBox;
    grpColunaB1_B15_15Bolas: TGroupBox;
    grpColunaB1_B8_B15_15Bolas: TGroupBox;
    grpColunaB1_B4_B8_B12_B15_15Bolas: TGroupBox;
    grpExternoInterno15Bolas2: TGroupBox;
    grpExternoInterno15Bolas3: TGroupBox;
    grpExternoInterno16Bolas2: TGroupBox;
    grpExternoInterno17Bolas2: TGroupBox;
    grpExternoInterno18Bolas2: TGroupBox;
    grpFrequenciaFim: TGroupBox;
    grpFrequenciaInicio1: TGroupBox;
    grpExternoInternoPorConcurso: TGroupBox;
    GroupBox1: TGroupBox;
    grpNovosRepetidos: TGroupBox;
    grpParImpar15Bolas: TGroupBox;
    grpExternoInterno15Bolas: TGroupBox;
    edConcurso: TLabeledEdit;
    grpFrequenciaBolas: TGroupBox;
    grpPrimoNaoPrimoConsolidadoConcurso1 : TGroupBox;
    grpSelecionarCampos: TGroupBox;
    grpSelecionarCampos1: TGroupBox;
    grp_b1_a_b10: TGroupBox;
    grp_b2_a_b10_por_concurso: TGroupBox;
    grp_b5_a_b11_por_concurso: TGroupBox;
    grp_b5_a_b12_por_concurso: TGroupBox;
    grp_b5_a_b13_por_concurso: TGroupBox;
    grp_b5_a_b14_por_concurso: TGroupBox;
    grp_b5_a_b15_por_concurso: TGroupBox;
    grp_b5_a_b12: TGroupBox;
    grp_b5_a_b13: TGroupBox;
    grp_b5_a_b14: TGroupBox;
    grp_b5_a_b15: TGroupBox;
    grp_b5_a_b5: TGroupBox;
    grp_b5_a_b6: TGroupBox;
    grp_b5_a_b7: TGroupBox;
    grp_b5_a_b8: TGroupBox;
    grp_b5_a_b9: TGroupBox;
    grp_b5_a_b10: TGroupBox;
    grp_b5_a_b11: TGroupBox;
    grp_b4_a_b4: TGroupBox;
    grp_b5_a_b5_por_concurso: TGroupBox;
    grp_b4_a_b5: TGroupBox;
    grp_b5_a_b6_por_concurso: TGroupBox;
    grp_b4_a_b6: TGroupBox;
    grp_b5_a_b7_por_concurso: TGroupBox;
    grp_b4_a_b7: TGroupBox;
    grp_b5_a_b8_por_concurso: TGroupBox;
    grp_b4_a_b8: TGroupBox;
    grp_b5_a_b9_por_concurso: TGroupBox;
    grp_b4_a_b9: TGroupBox;
    grp_b4_a_b10: TGroupBox;
    grp_b3_a_b3: TGroupBox;
    grp_b4_a_b4_por_concurso: TGroupBox;
    grp_b3_a_b4: TGroupBox;
    grp_b4_a_b5_por_concurso: TGroupBox;
    grp_b3_a_b5: TGroupBox;
    grp_b4_a_b6_por_concurso: TGroupBox;
    grp_b3_a_b6: TGroupBox;
    grp_b4_a_b7_por_concurso: TGroupBox;
    grp_b3_a_b7: TGroupBox;
    grp_b4_a_b8_por_concurso: TGroupBox;
    grp_b3_a_b8: TGroupBox;
    grp_b4_a_b9_por_concurso: TGroupBox;
    grp_b3_a_b9: TGroupBox;
    grp_b3_a_b10: TGroupBox;
    grp_b2_a_b2: TGroupBox;
    grp_b3_a_b3_por_concurso: TGroupBox;
    grp_b2_a_b3: TGroupBox;
    grp_b3_a_b4_por_concurso: TGroupBox;
    grp_b2_a_b4: TGroupBox;
    grp_b3_a_b5_por_concurso: TGroupBox;
    grp_b2_a_b5: TGroupBox;
    grp_b3_a_b6_por_concurso: TGroupBox;
    grp_b2_a_b6: TGroupBox;
    grp_b3_a_b7_por_concurso: TGroupBox;
    grp_b2_a_b7: TGroupBox;
    grp_b3_a_b8_por_concurso: TGroupBox;
    grp_b2_a_b8: TGroupBox;
    grp_b3_a_b9_por_concurso: TGroupBox;
    grp_b2_a_b9: TGroupBox;
    grp_b1_a_b1_por_concurso: TGroupBox;
    grp_b1_a_b1: TGroupBox;
    grp_b2_a_b10: TGroupBox;
    grp_b1_a_b2_por_concurso: TGroupBox;
    grp_b2_a_b2_por_concurso: TGroupBox;
    grp_b1_a_b3_por_concurso: TGroupBox;
    grp_b2_a_b3_por_concurso: TGroupBox;
    grp_b1_a_b4_por_concurso: TGroupBox;
    grp_b2_a_b4_por_concurso: TGroupBox;
    grp_b1_a_b5_por_concurso: TGroupBox;
    grp_b2_a_b5_por_concurso: TGroupBox;
    grp_b1_a_b6_por_concurso: TGroupBox;
    grp_b2_a_b6_por_concurso: TGroupBox;
    grp_b1_a_b7_por_concurso: TGroupBox;
    grp_b2_a_b7_por_concurso: TGroupBox;
    grp_b1_a_b8_por_concurso: TGroupBox;
    grp_b2_a_b8_por_concurso: TGroupBox;
    grp_b1_a_b9_por_concurso: TGroupBox;
    grp_b1_a_b10_por_concurso: TGroupBox;
    grp_b1_a_b2: TGroupBox;
    grp_b1_a_b3: TGroupBox;
    grp_b1_a_b4: TGroupBox;
    grp_b1_a_b5: TGroupBox;
    grp_b1_a_b6: TGroupBox;
    grp_b1_a_b7: TGroupBox;
    grp_b1_a_b8: TGroupBox;
    grp_b1_a_b9: TGroupBox;
    grp_b2_a_b9_por_concurso: TGroupBox;
    grp_b3_a_b10_por_concurso: TGroupBox;
    grp_b4_a_b10_por_concurso: TGroupBox;
    grp_b5_a_b10_por_concurso: TGroupBox;
    grp_b6_a_b10: TGroupBox;
    grp_b6_a_b10_por_concurso: TGroupBox;
    grp_b6_a_b6_por_concurso: TGroupBox;
    grp_b11_a_b12_por_concurso: TGroupBox;
    grp_b6_a_b7_por_concurso: TGroupBox;
    grp_b6_a_b8_por_concurso: TGroupBox;
    grp_b6_a_b6: TGroupBox;
    grp_b6_a_b7: TGroupBox;
    grp_b6_a_b8: TGroupBox;
    grp_b12_a_b12_por_concurso: TGroupBox;
    grp_b11_a_b13_por_concurso: TGroupBox;
    grp_b7_a_b11_por_concurso: TGroupBox;
    grp_b7_a_b12_por_concurso: TGroupBox;
    grp_b7_a_b13_por_concurso: TGroupBox;
    grp_b7_a_b14_por_concurso: TGroupBox;
    grp_b7_a_b15_por_concurso: TGroupBox;
    grp_b7_a_b11: TGroupBox;
    grp_b7_a_b12: TGroupBox;
    grp_b7_a_b13: TGroupBox;
    grp_b7_a_b14: TGroupBox;
    grp_b7_a_b15: TGroupBox;
    grp_b7_a_b7_por_concurso: TGroupBox;
    grp_b12_a_b13_por_concurso2: TGroupBox;
    grp_b7_a_b8_por_concurso: TGroupBox;
    grp_b7_a_b9_por_concurso: TGroupBox;
    grp_b7_a_b10_por_concurso: TGroupBox;
    grp_b7_a_b7: TGroupBox;
    grp_b7_a_b8: TGroupBox;
    grp_b7_a_b9: TGroupBox;
    grp_b7_a_b10: TGroupBox;
    grp_b8_a_b10: TGroupBox;
    grp_b8_a_b11: TGroupBox;
    grp_b8_a_b12: TGroupBox;
    grp_b8_a_b13: TGroupBox;
    grp_b8_a_b14: TGroupBox;
    grp_b8_a_b15: TGroupBox;
    grp_b8_a_b8_por_concurso: TGroupBox;
    grp_b8_a_b8: TGroupBox;
    grp_b9_a_b10: TGroupBox;
    grp_b9_a_b11: TGroupBox;
    grp_b9_a_b12: TGroupBox;
    grp_b9_a_b13: TGroupBox;
    grp_b9_a_b14: TGroupBox;
    grp_b9_a_b15: TGroupBox;
    grp_b9_a_b9_por_concurso: TGroupBox;
    grp_b14_a_b15: TGroupBox;
    grp_b13_a_b13_por_concurso: TGroupBox;
    grp_b12_a_b13_por_concurso: TGroupBox;
    grp_b11_a_b14_por_concurso: TGroupBox;
    grp_b12_a_b13_por_concurso1: TGroupBox;
    grp_b12_a_b14_por_concurso: TGroupBox;
    grp_b11_a_b15_por_concurso: TGroupBox;
    grp_b11_a_b12: TGroupBox;
    grp_b11_a_b13: TGroupBox;
    grp_b11_a_b14: TGroupBox;
    grp_b11_a_b15: TGroupBox;
    grp_b14_a_b14_por_concurso: TGroupBox;
    grp_b14_a_b14: TGroupBox;
    grp_b13_a_b15_por_concurso: TGroupBox;
    grp_b12_a_b15_por_concurso: TGroupBox;
    grp_b12_a_b12: TGroupBox;
    grp_b12_a_b13: TGroupBox;
    grp_b12_a_b14: TGroupBox;
    grp_b12_a_b15: TGroupBox;
    grp_b13_a_b13: TGroupBox;
    grp_b13_a_b14: TGroupBox;
    grp_b13_a_b15: TGroupBox;
    grp_b9_a_b9: TGroupBox;
    grp_b15_a_b15_por_concurso: TGroupBox;
    grp_b15_a_b15: TGroupBox;
    grp_b10_a_b10_por_concurso: TGroupBox;
    grp_b10_a_b10: TGroupBox;
    grp_b6_a_b9: TGroupBox;
    grp_b6_a_b9_por_concurso: TGroupBox;
    grp_b8_a_b9_por_concurso: TGroupBox;
    grp_b8_a_b8_por_concurso2: TGroupBox;
    grp_b8_a_b11_por_concurso: TGroupBox;
    grp_b8_a_b12_por_concurso: TGroupBox;
    grp_b8_a_b13_por_concurso: TGroupBox;
    grp_b8_a_b14_por_concurso: TGroupBox;
    grp_b8_a_b15_por_concurso: TGroupBox;
    grp_b8_a_b9: TGroupBox;
    grp_b9_a_b10_por_concurso: TGroupBox;
    grp_b9_a_b11_por_concurso: TGroupBox;
    grp_b9_a_b12_por_concurso: TGroupBox;
    grp_b9_a_b13_por_concurso: TGroupBox;
    grp_b9_a_b14_por_concurso: TGroupBox;
    grp_b9_a_b15_por_concurso: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b11: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b12: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b13: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b14: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b15: TGroupBox;
    grp_intervalo_por_concurso_b10_a_b10: TGroupBox;
    grp_intervalo_por_concurso_b9_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b6: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b5: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b4: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b3: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b2: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b2: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b3: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b4: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b5: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b6: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b1_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b3: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b4: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b5: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b6: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b2_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b4: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b5: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b6: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b3_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b5: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b6: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b4_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b6: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b5_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b7: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b6_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b8: TGroupBox;
    grp_intervalo_por_concurso_b7_a_b9: TGroupBox;
    grp_intervalo_por_concurso_b8_a_b9: TGroupBox;
    Label4: TLabel;
    mskDeslocamento: TMaskEdit;
    objHttp: TIdHTTP;
    JSONPropStorage1: TJSONPropStorage;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblNovosRepetidosUltimaAtualizacao: TLabel;
    mskTotalRegistros: TMaskEdit;
    Memo1: TMemo;
    mmFiltroSql: TMemo;
    PageControl19: TPageControl;
    PageControl20: TPageControl;
    PageControl21: TPageControl;
    PageControl22: TPageControl;
    pnGrupo2Bolas107: TPanel;
    pnGrupo2Bolas108: TPanel;
    pnGrupo2Bolas109: TPanel;
    pnGrupo2Bolas110: TPanel;
    pnGrupo2Bolas113: TPanel;
    pnGrupo2Bolas114: TPanel;
    pnGrupo2Bolas117: TPanel;
    pnGrupo2Bolas118: TPanel;
    pnGrupo2Bolas119: TPanel;
    pnGrupo2Bolas120: TPanel;
    pnGrupo2Bolas121: TPanel;
    pnGrupo2Bolas122: TPanel;
    pnGrupo2Bolas123: TPanel;
    pnGrupo2Bolas124: TPanel;
    pnGrupo2Bolas125: TPanel;
    pnGrupo2Bolas126: TPanel;
    pnGrupo2Bolas127: TPanel;
    pnGrupo2Bolas128: TPanel;
    pnGrupo2Bolas129: TPanel;
    pnGrupo2Bolas130: TPanel;
    pnGrupo2Bolas131: TPanel;
    pnGrupo2Bolas132: TPanel;
    pnGrupo2Bolas133: TPanel;
    pnGrupo2Bolas134: TPanel;
    pnGrupo2Bolas135: TPanel;
    pnGrupo2Bolas136: TPanel;
    pnGrupo2Bolas137: TPanel;
    pnGrupo2Bolas138: TPanel;
    pnGrupo2Bolas139: TPanel;
    pnGrupo2Bolas140: TPanel;
    pnGrupo2Bolas141: TPanel;
    pnGrupo2Bolas142: TPanel;
    pnGrupo2Bolas143: TPanel;
    pnGrupo2Bolas144: TPanel;
    pnGrupo2Bolas145: TPanel;
    pnGrupo2Bolas146: TPanel;
    pnGrupo2Bolas147: TPanel;
    pnGrupo2Bolas148: TPanel;
    pnGrupo2Bolas149: TPanel;
    pnGrupo2Bolas150: TPanel;
    pnGrupo2Bolas151: TPanel;
    pnGrupo2Bolas152: TPanel;
    pnGrupo2Bolas153: TPanel;
    pnGrupo2Bolas154: TPanel;
    pnGrupo2Bolas155: TPanel;
    pnGrupo2Bolas156: TPanel;
    pnGrupo2Bolas157: TPanel;
    pnGrupo2Bolas158: TPanel;
    pnGrupo2Bolas159: TPanel;
    pnGrupo2Bolas160: TPanel;
    pnGrupo2Bolas161: TPanel;
    pnGrupo2Bolas162: TPanel;
    pnGrupo2Bolas163: TPanel;
    pnGrupo2Bolas164: TPanel;
    pnGrupo2Bolas165: TPanel;
    pnGrupo2Bolas166: TPanel;
    pnGrupo2Bolas167: TPanel;
    pnGrupo2Bolas168: TPanel;
    pnGrupo2Bolas169: TPanel;
    pnGrupo2Bolas170: TPanel;
    pnGrupo2Bolas171: TPanel;
    pnGrupo2Bolas172: TPanel;
    pnGrupo2Bolas173: TPanel;
    pnGrupo2Bolas174: TPanel;
    pnGrupo2Bolas175: TPanel;
    pnGrupo2Bolas176: TPanel;
    pnGrupo2Bolas177: TPanel;
    pnGrupo2Bolas178: TPanel;
    pnGrupo2Bolas179: TPanel;
    pnGrupo2Bolas180: TPanel;
    pnGrupo2Bolas181: TPanel;
    pnGrupo2Bolas182: TPanel;
    pnGrupo2Bolas183: TPanel;
    pnGrupo2Bolas184: TPanel;
    pnGrupo2Bolas185: TPanel;
    pnGrupo2Bolas186: TPanel;
    pnGrupo2Bolas187: TPanel;
    pnGrupo2Bolas188: TPanel;
    pnGrupo2Bolas189: TPanel;
    pnGrupo2Bolas190: TPanel;
    pnGrupo2Bolas191: TPanel;
    pnGrupo2Bolas192: TPanel;
    pnGrupo2Bolas193: TPanel;
    pnGrupo2Bolas194: TPanel;
    pnGrupo2Bolas195: TPanel;
    pnGrupo2Bolas196: TPanel;
    pnGrupo2Bolas197: TPanel;
    pnGrupo2Bolas198: TPanel;
    pnGrupo2Bolas199: TPanel;
    pnGrupo2Bolas200: TPanel;
    pnGrupo2Bolas201: TPanel;
    pnGrupo2Bolas202: TPanel;
    pnGrupo2Bolas203: TPanel;
    pnGrupo2Bolas204: TPanel;
    pnGrupo2Bolas205: TPanel;
    pnGrupo2Bolas206: TPanel;
    pnGrupo2Bolas207: TPanel;
    pnGrupo2Bolas208: TPanel;
    pnGrupo2Bolas209: TPanel;
    pnGrupo2Bolas210: TPanel;
    pnGrupo2Bolas211: TPanel;
    pnGrupo2Bolas212: TPanel;
    pnGrupo2Bolas213: TPanel;
    pnGrupo2Bolas214: TPanel;
    pnGrupo2Bolas215: TPanel;
    pnGrupo2Bolas216: TPanel;
    pnGrupo2Bolas217: TPanel;
    pnGrupo2Bolas218: TPanel;
    pnGrupo2Bolas219: TPanel;
    pnGrupo2Bolas220: TPanel;
    pnGrupo2Bolas221: TPanel;
    pnGrupo2Bolas222: TPanel;
    pnGrupo2Bolas223: TPanel;
    pnGrupo2Bolas224: TPanel;
    pnGrupo2Bolas225: TPanel;
    pnGrupo2Bolas226: TPanel;
    pnGrupo2Bolas227: TPanel;
    pnGrupo2Bolas228: TPanel;
    pnGrupo2Bolas229: TPanel;
    pnGrupo2Bolas230: TPanel;
    pnGrupo2Bolas231: TPanel;
    pnGrupo2Bolas232: TPanel;
    pnGrupo2Bolas233: TPanel;
    pnGrupo2Bolas234: TPanel;
    pnGrupo2Bolas235: TPanel;
    pnGrupo2Bolas236: TPanel;
    pnGrupo2Bolas237: TPanel;
    pnGrupo2Bolas238: TPanel;
    pnGrupo2Bolas239: TPanel;
    pnGrupo2Bolas240: TPanel;
    pnGrupo2Bolas241: TPanel;
    pnGrupo2Bolas242: TPanel;
    pnGrupo2Bolas243: TPanel;
    pnGrupo2Bolas244: TPanel;
    pnGrupo2Bolas245: TPanel;
    pnGrupo2Bolas246: TPanel;
    pnGrupo2Bolas247: TPanel;
    pnGrupo2Bolas248: TPanel;
    pnGrupo2Bolas249: TPanel;
    pnGrupo2Bolas250: TPanel;
    pnGrupo2Bolas251: TPanel;
    pnGrupo2Bolas252: TPanel;
    pnGrupo2Bolas253: TPanel;
    pnGrupo2Bolas254: TPanel;
    pnGrupo2Bolas255: TPanel;
    pnGrupo2Bolas256: TPanel;
    pnGrupo2Bolas257: TPanel;
    pnGrupo2Bolas258: TPanel;
    pnGrupo2Bolas259: TPanel;
    pnGrupo2Bolas260: TPanel;
    pnGrupo2Bolas261: TPanel;
    pnGrupo2Bolas262: TPanel;
    pnGrupo2Bolas263: TPanel;
    pnGrupo2Bolas264: TPanel;
    pnGrupo2Bolas265: TPanel;
    pnGrupo2Bolas266: TPanel;
    pnGrupo2Bolas267: TPanel;
    pnGrupo2Bolas268: TPanel;
    pnGrupo2Bolas269: TPanel;
    pnGrupo2Bolas270: TPanel;
    pnGrupo2Bolas271: TPanel;
    pnGrupo2Bolas272: TPanel;
    pnGrupo2Bolas273: TPanel;
    pnGrupo2Bolas274: TPanel;
    pnGrupo2Bolas275: TPanel;
    pnGrupo2Bolas276: TPanel;
    pnGrupo2Bolas277: TPanel;
    pnGrupo2Bolas278: TPanel;
    pnGrupo2Bolas279: TPanel;
    pnGrupo2Bolas280: TPanel;
    pnGrupo2Bolas281: TPanel;
    pnGrupo2Bolas282: TPanel;
    pnGrupo2Bolas283: TPanel;
    pnGrupo2Bolas284: TPanel;
    pnGrupo2Bolas285: TPanel;
    pnGrupo2Bolas286: TPanel;
    pnGrupo2Bolas287: TPanel;
    pnGrupo2Bolas288: TPanel;
    pnGrupo2Bolas289: TPanel;
    pnGrupo2Bolas290: TPanel;
    pnGrupo2Bolas291: TPanel;
    pnGrupo2Bolas292: TPanel;
    pnGrupo2Bolas293: TPanel;
    pnGrupo2Bolas294: TPanel;
    pnGrupo2Bolas295: TPanel;
    pnGrupo2Bolas296: TPanel;
    pnGrupo2Bolas297: TPanel;
    pnGrupo2Bolas298: TPanel;
    pnGrupo2Bolas299: TPanel;
    pnGrupo2Bolas300: TPanel;
    pnGrupo2Bolas301: TPanel;
    pnGrupo2Bolas302: TPanel;
    pnGrupo2Bolas303: TPanel;
    pnGrupo2Bolas304: TPanel;
    pnGrupo2Bolas305: TPanel;
    pnGrupo2Bolas306: TPanel;
    pnGrupo2Bolas307: TPanel;
    pnGrupo2Bolas308: TPanel;
    pnGrupo2Bolas309: TPanel;
    pnGrupo2Bolas310: TPanel;
    pnGrupo2Bolas311: TPanel;
    pnGrupo2Bolas312: TPanel;
    pnGrupo2Bolas313: TPanel;
    pnGrupo2Bolas314: TPanel;
    pnGrupo2Bolas315: TPanel;
    pnGrupo2Bolas316: TPanel;
    pnGrupo2Bolas317: TPanel;
    pnGrupo2Bolas318: TPanel;
    pnGrupo2Bolas319: TPanel;
    pnGrupo2Bolas320: TPanel;
    pnGrupo2Bolas321: TPanel;
    pnGrupo2Bolas322: TPanel;
    pnGrupo2Bolas323: TPanel;
    pnGrupo2Bolas324: TPanel;
    pnGrupo2Bolas325: TPanel;
    pnGrupo2Bolas326: TPanel;
    pnGrupo2Bolas327: TPanel;
    pnGrupo2Bolas328: TPanel;
    pnGrupo2Bolas329: TPanel;
    pnGrupo2Bolas330: TPanel;
    pnGrupo2Bolas331: TPanel;
    pnGrupo2Bolas332: TPanel;
    pnGrupo2Bolas333: TPanel;
    pnGrupo2Bolas334: TPanel;
    pnGrupo2Bolas335: TPanel;
    pnGrupo2Bolas336: TPanel;
    pnGrupo2Bolas337: TPanel;
    pnGrupo2Bolas338: TPanel;
    pnGrupo2Bolas339: TPanel;
    pnGrupo2Bolas340: TPanel;
    pnGrupo2Bolas341: TPanel;
    pnGrupo2Bolas342: TPanel;
    pnGrupo2Bolas343: TPanel;
    pnGrupo2Bolas344: TPanel;
    pnGrupo2Bolas345: TPanel;
    pnGrupo2Bolas346: TPanel;
    pnGrupo2Bolas347: TPanel;
    pnGrupo2Bolas348: TPanel;
    pnGrupo2Bolas349: TPanel;
    pnGrupo2Bolas350: TPanel;
    pnGrupo2Bolas351: TPanel;
    pnGrupo2Bolas352: TPanel;
    pnGrupo2Bolas353: TPanel;
    pnGrupo2Bolas354: TPanel;
    pnGrupo2Bolas355: TPanel;
    pnGrupo2Bolas356: TPanel;
    pnGrupo2Bolas93: TPanel;
    pnGrupo2Bolas94: TPanel;
    pnGrupo2Bolas95: TPanel;
    pnGrupo2Bolas96: TPanel;
    sgr_b6_a_b11_por_concurso: TStringGrid;
    sgr_b6_a_b12_por_concurso: TStringGrid;
    sgr_b6_a_b13_por_concurso: TStringGrid;
    sgr_b6_a_b14_por_concurso: TStringGrid;
    sgr_b6_a_b15_por_concurso: TStringGrid;
    sgr_b6_a_b11: TStringGrid;
    sgr_b6_a_b12: TStringGrid;
    sgr_b6_a_b13: TStringGrid;
    sgr_b6_a_b14: TStringGrid;
    sgr_b6_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b10_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b10_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b10_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b10_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b10_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b11_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b11_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b11_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b11_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b11_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b12_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b12_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b12_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b12_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b13_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b13_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b13_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b14_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b14_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b15_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b1: TStringGrid;
    sgr_b10_a_b11_por_concurso: TStringGrid;
    sgr_b10_a_b12_por_concurso: TStringGrid;
    sgr_b10_a_b13_por_concurso: TStringGrid;
    sgr_b10_a_b14_por_concurso: TStringGrid;
    sgr_b10_a_b15_por_concurso: TStringGrid;
    sgr_b10_a_b11: TStringGrid;
    sgr_b10_a_b12: TStringGrid;
    sgr_b10_a_b13: TStringGrid;
    sgr_b10_a_b14: TStringGrid;
    sgr_b10_a_b15: TStringGrid;
    sgr_b2_a_b10_por_concurso: TStringGrid;
    sgr_b5_a_b11_por_concurso: TStringGrid;
    sgr_b5_a_b12_por_concurso: TStringGrid;
    sgr_b5_a_b13_por_concurso: TStringGrid;
    sgr_b5_a_b14_por_concurso: TStringGrid;
    sgr_b5_a_b15_por_concurso: TStringGrid;
    sgr_b5_a_b12: TStringGrid;
    sgr_b5_a_b13: TStringGrid;
    sgr_b5_a_b14: TStringGrid;
    sgr_b5_a_b15: TStringGrid;
    sgr_b5_a_b5: TStringGrid;
    sgr_b5_a_b6: TStringGrid;
    sgr_b5_a_b7: TStringGrid;
    sgr_b5_a_b8: TStringGrid;
    sgr_b5_a_b9: TStringGrid;
    sgr_b5_a_b10: TStringGrid;
    sgr_b5_a_b11: TStringGrid;
    sgr_b4_a_b4: TStringGrid;
    sgr_b5_a_b5_por_concurso: TStringGrid;
    sgr_b4_a_b5: TStringGrid;
    sgr_b5_a_b6_por_concurso: TStringGrid;
    sgr_b4_a_b6: TStringGrid;
    sgr_b5_a_b7_por_concurso: TStringGrid;
    sgr_b4_a_b7: TStringGrid;
    sgr_b5_a_b8_por_concurso: TStringGrid;
    sgr_b4_a_b8: TStringGrid;
    sgr_b5_a_b9_por_concurso: TStringGrid;
    sgr_b4_a_b9: TStringGrid;
    sgr_b4_a_b10: TStringGrid;
    sgr_b3_a_b3: TStringGrid;
    sgr_b4_a_b4_por_concurso: TStringGrid;
    sgr_b3_a_b4: TStringGrid;
    sgr_b4_a_b5_por_concurso: TStringGrid;
    sgr_b3_a_b5: TStringGrid;
    sgr_b4_a_b6_por_concurso: TStringGrid;
    sgr_b3_a_b6: TStringGrid;
    sgr_b4_a_b7_por_concurso: TStringGrid;
    sgr_b3_a_b7: TStringGrid;
    sgr_b4_a_b8_por_concurso: TStringGrid;
    sgr_b3_a_b8: TStringGrid;
    sgr_b4_a_b9_por_concurso: TStringGrid;
    sgr_b3_a_b9: TStringGrid;
    sgr_b3_a_b10: TStringGrid;
    sgr_b2_a_b2: TStringGrid;
    sgr_b3_a_b3_por_concurso: TStringGrid;
    sgr_b2_a_b3: TStringGrid;
    sgr_b3_a_b4_por_concurso: TStringGrid;
    sgr_b2_a_b4: TStringGrid;
    sgr_b3_a_b5_por_concurso: TStringGrid;
    sgr_b2_a_b5: TStringGrid;
    sgr_b3_a_b6_por_concurso: TStringGrid;
    sgr_b2_a_b6: TStringGrid;
    sgr_b3_a_b7_por_concurso: TStringGrid;
    sgr_b2_a_b7: TStringGrid;
    sgr_b3_a_b8_por_concurso: TStringGrid;
    sgr_b2_a_b8: TStringGrid;
    sgr_b3_a_b9_por_concurso: TStringGrid;
    sgr_b2_a_b9: TStringGrid;
    sgr_b2_a_b10: TStringGrid;
    sgr_b2_a_b2_por_concurso: TStringGrid;
    sgr_b2_a_b3_por_concurso: TStringGrid;
    sgr_b2_a_b4_por_concurso: TStringGrid;
    sgr_b2_a_b5_por_concurso: TStringGrid;
    sgr_b2_a_b6_por_concurso: TStringGrid;
    sgr_b2_a_b7_por_concurso: TStringGrid;
    sgr_b2_a_b8_por_concurso: TStringGrid;
    sgr_b1_a_b9: TStringGrid;
    sgr_b1_a_b10: TStringGrid;
    sgr_b1_a_b1_por_concurso: TStringGrid;
    sgr_b1_a_b1: TStringGrid;
    sgr_b1_a_b2_por_concurso: TStringGrid;
    sgr_b1_a_b3_por_concurso: TStringGrid;
    sgr_b1_a_b4_por_concurso: TStringGrid;
    sgr_b1_a_b5_por_concurso: TStringGrid;
    sgr_b1_a_b6_por_concurso: TStringGrid;
    sgr_b1_a_b7_por_concurso: TStringGrid;
    sgr_b1_a_b8_por_concurso: TStringGrid;
    sgr_b1_a_b9_por_concurso: TStringGrid;
    sgr_b1_a_b10_por_concurso: TStringGrid;
    sgr_b1_a_b2: TStringGrid;
    sgr_b1_a_b3: TStringGrid;
    sgr_b1_a_b4: TStringGrid;
    sgr_b1_a_b5: TStringGrid;
    sgr_b1_a_b6: TStringGrid;
    sgr_b1_a_b7: TStringGrid;
    sgr_b1_a_b8: TStringGrid;
    sgr_b2_a_b9_por_concurso: TStringGrid;
    sgr_b3_a_b10_por_concurso: TStringGrid;
    sgr_b4_a_b10_por_concurso: TStringGrid;
    sgr_b5_a_b10_por_concurso: TStringGrid;
    sgr_b6_a_b10: TStringGrid;
    sgr_b6_a_b10_por_concurso: TStringGrid;
    sgr_b6_a_b9: TStringGrid;
    sgr_b6_a_b9_por_concurso: TStringGrid;
    sgr_b7_a_b11_por_concurso: TStringGrid;
    sgr_b7_a_b12_por_concurso: TStringGrid;
    sgr_b7_a_b13_por_concurso: TStringGrid;
    sgr_b7_a_b14_por_concurso: TStringGrid;
    sgr_b7_a_b15_por_concurso: TStringGrid;
    sgr_b7_a_b11: TStringGrid;
    sgr_b7_a_b12: TStringGrid;
    sgr_b7_a_b13: TStringGrid;
    sgr_b7_a_b14: TStringGrid;
    sgr_b7_a_b15: TStringGrid;
    sgr_b8_a_b10: TStringGrid;
    sgr_b8_a_b11: TStringGrid;
    sgr_b8_a_b12: TStringGrid;
    sgr_b8_a_b13: TStringGrid;
    sgr_b8_a_b14: TStringGrid;
    sgr_b8_a_b15: TStringGrid;
    sgr_b8_a_b9_por_concurso: TStringGrid;
    sgr_b8_a_b8_por_concurso2: TStringGrid;
    sgr_b8_a_b11_por_concurso: TStringGrid;
    sgr_b8_a_b12_por_concurso: TStringGrid;
    sgr_b8_a_b13_por_concurso: TStringGrid;
    sgr_b8_a_b14_por_concurso: TStringGrid;
    sgr_b8_a_b15_por_concurso: TStringGrid;
    sgr_b8_a_b9: TStringGrid;
    sgr_b9_a_b10: TStringGrid;
    sgr_b9_a_b11: TStringGrid;
    sgr_b9_a_b12: TStringGrid;
    sgr_b9_a_b13: TStringGrid;
    sgr_b9_a_b14: TStringGrid;
    sgr_b9_a_b15: TStringGrid;
    sgr_b9_a_b10_por_concurso: TStringGrid;
    sgr_b9_a_b11_por_concurso: TStringGrid;
    sgr_b9_a_b12_por_concurso: TStringGrid;
    sgr_b9_a_b13_por_concurso: TStringGrid;
    sgr_b9_a_b14_por_concurso: TStringGrid;
    sgr_b9_a_b15_por_concurso: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b11: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b12: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b13: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b14: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b15: TStringGrid;
    sgr_intervalo_por_concurso_b10_a_b10: TStringGrid;
    sgr_intervalo_por_concurso_b9_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b6: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b5: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b4: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b3: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b2: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b2: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b3: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b4: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b5: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b6: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b1_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b3: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b4: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b5: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b6: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b2_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b4: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b5: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b6: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b3_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b5: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b6: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b4_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b6: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b5_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b7: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b6_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b8: TStringGrid;
    sgr_intervalo_por_concurso_b7_a_b9: TStringGrid;
    sgr_intervalo_por_concurso_b8_a_b9: TStringGrid;
    TabSheet16: TTabSheet;
    TabSheet17: TTabSheet;
    TabSheet18: TTabSheet;
    TabSheet19: TTabSheet;
    TabSheet20: TTabSheet;
    TabSheet21: TTabSheet;
    TabSheet22: TTabSheet;
    TabSheet23: TTabSheet;
    TabSheet24: TTabSheet;
    TabSheet25: TTabSheet;
    TabSheet26: TTabSheet;
    TabSheet27: TTabSheet;
    TabSheet28: TTabSheet;
    TabSheet29: TTabSheet;
    TabSheet30: TTabSheet;
    TabSheet31: TTabSheet;
    TabSheet32: TTabSheet;
    TabSheet33: TTabSheet;
    TabSheet34: TTabSheet;
    TabSheet35: TTabSheet;
    TabSheet36: TTabSheet;
    TabSheet37: TTabSheet;
    TabSheet38: TTabSheet;
    TabSheet39: TTabSheet;
    TabSheet40: TTabSheet;
    TabSheet41: TTabSheet;
    TabSheet42: TTabSheet;
    TabSheet43: TTabSheet;
    TabSheet44: TTabSheet;
    TabSheet45: TTabSheet;
    TabSheet46: TTabSheet;
    TabSheet47: TTabSheet;
    TabSheet48: TTabSheet;
    tab_b1_a_b20: TTabSheet;
    tab_b1_a_b21: TTabSheet;
    tab_b1_a_b22: TTabSheet;
    tab_b1_a_b27: TTabSheet;
    tab_b1_a_b28: TTabSheet;
    tab_b1_a_b29: TTabSheet;
    tab_b1_a_b30: TTabSheet;
    tab_b3_a_b10: TTabSheet;
    tab_b3_a_b11: TTabSheet;
    tab_b5_a_b7: TTabSheet;
    tab_b3_a_b13: TTabSheet;
    tab_b3_a_b14: TTabSheet;
    tab_b3_a_b4: TTabSheet;
    tab_b3_a_b5: TTabSheet;
    tab_b3_a_b6: TTabSheet;
    tab_b3_a_b7: TTabSheet;
    tab_b1_a_b24: TTabSheet;
    tab_b1_a_b25: TTabSheet;
    tab_b1_a_b26: TTabSheet;
    tab_b2_a_b2: TTabSheet;
    tab_b1_a_b12: TTabSheet;
    tab_b1_a_b13: TTabSheet;
    tab_b1_a_b14: TTabSheet;
    tab_b1_a_b16: TTabSheet;
    tab_b1_a_b17: TTabSheet;
    tab_b1_a_b18: TTabSheet;
    tab_b1_a_b19: TTabSheet;
    tab_b3_a_b3: TTabSheet;
    tab_b3_a_b8: TTabSheet;
    tab_b3_a_b9: TTabSheet;
    tab_principal: TPageControl;
    PageControl10: TPageControl;
    PageControl11: TPageControl;
    PageControl12: TPageControl;
    PageControl13: TPageControl;
    PageControl14: TPageControl;
    PageControl15: TPageControl;
    PageControl16: TPageControl;
    PageControl17: TPageControl;
    PageControl18: TPageControl;
    PageControl2: TPageControl;
    PageControl4: TPageControl;
    PageControl5: TPageControl;
    PageControl6 : TPageControl;
    PageControl7: TPageControl;
    PageControl8: TPageControl;
    PageControl9: TPageControl;
    pageFiltros: TPageControl;
    PageControl3: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    pnFrequenciaNaoSair: TPanel;
    pnGerador_Opcoes: TPanel;
    pnExibirCampos1: TPanel;
    pnGrupo2Bolas10: TPanel;
    pnGrupo2Bolas100: TPanel;
    pnGrupo2Bolas101: TPanel;
    pnGrupo2Bolas102: TPanel;
    pnGrupo2Bolas103: TPanel;
    pnGrupo2Bolas104: TPanel;
    pnGrupo2Bolas105: TPanel;
    pnGrupo2Bolas106: TPanel;
    pnGrupo2Bolas11: TPanel;
    pnGrupo2Bolas111: TPanel;
    pnGrupo2Bolas112: TPanel;
    pnGrupo2Bolas115: TPanel;
    pnGrupo2Bolas116: TPanel;
    pnGrupo2Bolas12 : TPanel;
    pnGrupo2Bolas13 : TPanel;
    pnGrupo2Bolas14 : TPanel;
    pnGrupo2Bolas15 : TPanel;
    pnGrupo2Bolas16 : TPanel;
    pnGrupo2Bolas17 : TPanel;
    pnGrupo2Bolas18 : TPanel;
    pnGrupo2Bolas19 : TPanel;
    pnGrupo2Bolas21: TPanel;
    pnGrupo2Bolas22: TPanel;
    pnGrupo2Bolas23: TPanel;
    pnGrupo2Bolas25: TPanel;
    pnGrupo2Bolas26: TPanel;
    pnGrupo2Bolas27: TPanel;
    pnGrupo2Bolas30: TPanel;
    pnGrupo2Bolas31 : TPanel;
    pnGrupo2Bolas32 : TPanel;
    pnGrupo2Bolas33 : TPanel;
    pnGrupo2Bolas34 : TPanel;
    pnGrupo2Bolas35 : TPanel;
    pnGrupo2Bolas38: TPanel;
    pnGrupo2Bolas39: TPanel;
    pnGrupo2Bolas4: TPanel;
    pnGrupo2Bolas48: TPanel;
    pnGrupo2Bolas49: TPanel;
    pnGrupo2Bolas50 : TPanel;
    pnGrupo2Bolas51 : TPanel;
    pnGrupo2Bolas52 : TPanel;
    pnGrupo2Bolas53 : TPanel;
    pnGrupo2Bolas54 : TPanel;
    pnGrupo2Bolas55: TPanel;
    pnGrupo2Bolas56: TPanel;
    pnGrupo2Bolas57: TPanel;
    pnGrupo2Bolas58: TPanel;
    pnGrupo2Bolas59: TPanel;
    pnGrupo2Bolas60: TPanel;
    pnGrupo2Bolas61: TPanel;
    pnGrupo2Bolas62: TPanel;
    pnGrupo2Bolas63: TPanel;
    pnGrupo2Bolas64: TPanel;
    pnGrupo2Bolas65: TPanel;
    pnGrupo2Bolas66: TPanel;
    pnGrupo2Bolas67: TPanel;
    pnGrupo2Bolas68: TPanel;
    pnGrupo2Bolas69: TPanel;
    pnGrupo2Bolas70: TPanel;
    pnGrupo2Bolas71: TPanel;
    pnGrupo2Bolas72: TPanel;
    pnGrupo2Bolas73: TPanel;
    pnGrupo2Bolas74: TPanel;
    pnGrupo2Bolas75: TPanel;
    pnGrupo2Bolas76: TPanel;
    pnGrupo2Bolas77: TPanel;
    pnGrupo2Bolas78: TPanel;
    pnGrupo2Bolas79: TPanel;
    pnGrupo2Bolas8: TPanel;
    pnGrupo2Bolas80: TPanel;
    pnGrupo2Bolas81: TPanel;
    pnGrupo2Bolas82: TPanel;
    pnGrupo2Bolas83: TPanel;
    pnGrupo2Bolas84: TPanel;
    pnGrupo2Bolas85: TPanel;
    pnGrupo2Bolas86: TPanel;
    pnGrupo2Bolas87: TPanel;
    pnGrupo2Bolas88: TPanel;
    pnGrupo2Bolas89: TPanel;
    pnGrupo2Bolas9: TPanel;
    pnGrupo2Bolas90: TPanel;
    pnGrupo2Bolas91: TPanel;
    pnGrupo2Bolas92: TPanel;
    pnGrupo2Bolas97: TPanel;
    pnGrupo2Bolas98: TPanel;
    pnGrupo2Bolas99: TPanel;
    pnVerificarAcertos: TPanel;
    pnExibirCampos: TPanel;
    pnFrequenciaNaoSair1: TPanel;
    pnFrequenciaNaoSair2: TPanel;
    pnFrequenciaNaoSair3: TPanel;
    pnGrupo2Bolas: TPanel;
    pn1a5: TPanel;
    pn1a6: TPanel;
    pn1a7: TPanel;
    pn1a8: TPanel;
    pn1a9: TPanel;
    pnGrupo2Bolas1: TPanel;
    pnGrupo2Bolas2: TPanel;
    pnGrupo2Bolas20: TPanel;
    pnGrupo2Bolas24: TPanel;
    pnGrupo2Bolas28: TPanel;
    pnGrupo2Bolas29: TPanel;
    pnGrupo2Bolas3: TPanel;
    pnGrupo2Bolas36: TPanel;
    pnGrupo2Bolas37: TPanel;
    pnGrupo2Bolas40: TPanel;
    pnGrupo2Bolas41: TPanel;
    pnGrupo2Bolas42: TPanel;
    pnGrupo2Bolas43: TPanel;
    pnGrupo2Bolas44: TPanel;
    pnGrupo2Bolas45: TPanel;
    pnGrupo2Bolas46: TPanel;
    pnGrupo2Bolas47: TPanel;
    pnGrupo2Bolas5: TPanel;
    pnGrupo2Bolas6: TPanel;
    pnGrupo2Bolas7: TPanel;
    pnVerificarAcertos1: TPanel;
    rdSomaFrequenciaPrecisaoBolas : TRadioGroup;
    rdDeslocamento: TRadioGroup;
    rdGerador_Quantidade_de_Bolas: TRadioGroup;
    sgr_b11_a_b11: TStringGrid;
    sgr_b11_a_b11_por_concurso: TStringGrid;
    sgrColunaB1 : TStringGrid;
    sgrColunaB10 : TStringGrid;
    sgrColunaB11 : TStringGrid;
    sgrColunaB12 : TStringGrid;
    sgrColunaB13 : TStringGrid;
    sgrColunaB14 : TStringGrid;
    sgrColunaB15 : TStringGrid;
    sgrColunaB1_15Bolas: TStringGrid;
    sgrBolas_na_mesma_coluna: TStringGrid;
    sgrBolas_na_mesma_coluna_por_concurso: TStringGrid;
    sgrColunaB2 : TStringGrid;
    sgrColunaB3 : TStringGrid;
    sgrColunaB1_B2_B3_B4_B5_15Bolas: TStringGrid;
    sgrColunaB1_B2_B3_15Bolas: TStringGrid;
    sgrColunaB1_B2_15Bolas: TStringGrid;
    sgrColunaB1_B2_B3_B4_15Bolas: TStringGrid;
    sgrColunaB4 : TStringGrid;
    sgrColunaB5 : TStringGrid;
    sgrColunaB6 : TStringGrid;
    sgrColunaB7 : TStringGrid;
    sgrColunaB8 : TStringGrid;
    sgrColunaB9 : TStringGrid;
    sgrDiferenca_Qt_1: TStringGrid;
    sgrDiferenca_Qt_1_Qt_2: TStringGrid;
    sgrDiferenca_qt_alt1: TStringGrid;
    sgrAlgarismo_na_dezena : TStringGrid;
    sgrAlgarismo_na_dezena_consolidado : TStringGrid;
    sgrPrimoNaoPrimoPorConcurso: TStringGrid;
    sgrFrequenciaBolasNaoSair: TStringGrid;
    sgrFrequenciaSair: TStringGrid;
    sgrGeradorAleatorio: TStringGrid;
    sgrGeradorEspelho: TStringGrid;
    sgrLotofacilSoma: TStringGrid;
    sgrDiferenca_qt_alt_1: TStringGrid;
    sgrDiferenca_qt_alt: TStringGrid;
    sgrDiferenca_qt_alt_2: TStringGrid;
    sgrFrequenciaTotalSair: TStringGrid;
    sgrFrequenciaTotalNaoSair: TStringGrid;
    sgrFrequenciaNaoSair: TStringGrid;
    sgrParImparConsolidado: TStringGrid;
    sgrExternoInternoConsolidado: TStringGrid;
    sgrPrimoNaoPrimoConsolidado: TStringGrid;
    sgrNovosRepetidosPorConcurso: TStringGrid;
    sgrNovosRepetidosConsolidado: TStringGrid;
    sgrParImparPorConcurso: TStringGrid;
    sgrPrimo15Bolas: TStringGrid;
    sgrGrupo3Bolas: TStringGrid;
    sgrColunaB1_B15_15Bolas: TStringGrid;
    sgrColunaB1_B8_B15_15Bolas: TStringGrid;
    sgrColunaB1_B4_B8_B12_B15_15Bolas: TStringGrid;
    sgrExternoInterno15Bolas2: TStringGrid;
    sgrExternoInterno15Bolas3: TStringGrid;
    sgrExternoInterno16Bolas2: TStringGrid;
    sgrExternoInterno17Bolas2: TStringGrid;
    sgrExternoInterno18Bolas2: TStringGrid;
    sgrGrupo2Bolas: TStringGrid;
    sgrGrupo4Bolas: TStringGrid;
    sgrGrupo5Bolas: TStringGrid;
    sgrNovosRepetidos: TStringGrid;
    sgrParImpar15Bolas: TStringGrid;
    sgrExternoInterno15Bolas: TStringGrid;
    sgrExternoInternoPorConcurso: TStringGrid;
    sgrFrequencia: TStringGrid;
    sgrFrequencia_Bolas_Sair_Nao_Sair: TStringGrid;
    sgrAleatorioVerificarAcertos: TStringGrid;
    sgrAlgarismo_na_dezena_por_concurso : TStringGrid;
    sgr_b6_a_b6_por_concurso: TStringGrid;
    sgr_b11_a_b12_por_concurso: TStringGrid;
    sgr_b6_a_b7_por_concurso: TStringGrid;
    sgr_b11_a_b13_por_concurso1: TStringGrid;
    sgr_b6_a_b6: TStringGrid;
    sgr_b6_a_b7: TStringGrid;
    sgr_b6_a_b8: TStringGrid;
    sgr_b12_a_b12_por_concurso: TStringGrid;
    sgr_b11_a_b13_por_concurso: TStringGrid;
    sgr_b7_a_b7_por_concurso: TStringGrid;
    sgr_b7_a_b8_por_concurso: TStringGrid;
    sgr_b7_a_b9_por_concurso: TStringGrid;
    sgr_b7_a_b10_por_concurso: TStringGrid;
    sgr_b7_a_b7: TStringGrid;
    sgr_b7_a_b8: TStringGrid;
    sgr_b7_a_b9: TStringGrid;
    sgr_b7_a_b10: TStringGrid;
    sgr_b8_a_b8_por_concurso: TStringGrid;
    sgr_b8_a_b8: TStringGrid;
    sgr_b9_a_b9_por_concurso: TStringGrid;
    sgr_b14_a_b15_por_concurso: TStringGrid;
    sgr_b14_a_b15: TStringGrid;
    sgr_b13_a_b13_por_concurso: TStringGrid;
    sgr_b12_a_b13_por_concurso: TStringGrid;
    sgr_b11_a_b14_por_concurso: TStringGrid;
    sgr_b12_a_b13_por_concurso1: TStringGrid;
    sgr_b12_a_b14_por_concurso: TStringGrid;
    sgr_b11_a_b15_por_concurso: TStringGrid;
    sgr_b11_a_b12: TStringGrid;
    sgr_b11_a_b13: TStringGrid;
    sgr_b11_a_b14: TStringGrid;
    sgr_b11_a_b15: TStringGrid;
    sgr_b14_a_b14_por_concurso: TStringGrid;
    sgr_b14_a_b14: TStringGrid;
    sgr_b13_a_b15_por_concurso: TStringGrid;
    sgr_b12_a_b15_por_concurso: TStringGrid;
    sgr_b12_a_b12: TStringGrid;
    sgr_b12_a_b13: TStringGrid;
    sgr_b12_a_b14: TStringGrid;
    sgr_b12_a_b15: TStringGrid;
    sgr_b13_a_b13: TStringGrid;
    sgr_b13_a_b14: TStringGrid;
    sgr_b13_a_b15: TStringGrid;
    sgr_b9_a_b9: TStringGrid;
    sgr_b15_a_b15_por_concurso: TStringGrid;
    sgr_b15_a_b15: TStringGrid;
    sgr_b10_a_b10_por_concurso: TStringGrid;
    sgr_b10_a_b10: TStringGrid;
    sheetFiltro: TTabSheet;
    sgrFiltros: TStringGrid;
    sgrVerificarAcertos: TStringGrid;
    spinGerador_Combinacoes: TSpinEdit;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    sgrResultado_Importacao: TStringGrid;
    lblStatus : TStaticText;
    stxtNovosRepetidos: TStaticText;
    tabBolasNasColunas: TTabSheet;
    tabHorizontal: TTabSheet;
    tabFrequencia: TTabSheet;
    tabConcurso: TTabSheet;
    tabGrupos: TTabSheet;
    TabSheet1: TTabSheet;
    tabGerarFiltros: TTabSheet;
    tabLotofacilSoma: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11 : TTabSheet;
    TabSheet12 : TTabSheet;
    TabSheet13 : TTabSheet;
    TabSheet14 : TTabSheet;
    tabFrequenciaSoma : TTabSheet;
    tab_b1_a_b1: TTabSheet;
    tab_b1_a_b2: TTabSheet;
    tab_b1_a_b3: TTabSheet;
    tab_b1_a_b4: TTabSheet;
    tab_b1_a_b5: TTabSheet;
    tab_b1_a_b6: TTabSheet;
    tab_b1_a_b7: TTabSheet;
    tab_b1_a_b8: TTabSheet;
    tab_b1_a_b9: TTabSheet;
    tab_b11_a_b11: TTabSheet;
    tab_b11_a_b12: TTabSheet;
    tab_b11_a_b13: TTabSheet;
    tab_b11_a_b14: TTabSheet;
    tab_b11_a_b15: TTabSheet;
    tab_b1: TTabSheet;
    tab_b11_a_b16: TTabSheet;
    tab_b11_a_b17: TTabSheet;
    tab_b11_a_b18: TTabSheet;
    tab_b11_a_b21: TTabSheet;
    tab_b11_a_b22: TTabSheet;
    tab_b11_a_b23: TTabSheet;
    tab_b11_a_b24: TTabSheet;
    tab_b11_a_b25: TTabSheet;
    tab_b11_a_b26: TTabSheet;
    tab_b11_a_b27: TTabSheet;
    tab_b11_a_b28: TTabSheet;
    tab_b11_a_b29: TTabSheet;
    tab_b11_a_b30: TTabSheet;
    tab_b11_a_b31: TTabSheet;
    tab_b11_a_b32: TTabSheet;
    tab_b11_a_b33: TTabSheet;
    tab_b11_a_b34: TTabSheet;
    tab_b12_a_b13: TTabSheet;
    tab_b11_a_b19: TTabSheet;
    tab_b11_a_b20: TTabSheet;
    tab_b12_a_b14: TTabSheet;
    tab_b13_a_b14: TTabSheet;
    tab_b13_a_b15: TTabSheet;
    tab_b13_a_b16: TTabSheet;
    tab_b13_a_b17: TTabSheet;
    tab_b2: TTabSheet;
    tab_b3: TTabSheet;
    tab_b4: TTabSheet;
    tab_b5: TTabSheet;
    tab_b6: TTabSheet;
    tab_b7: TTabSheet;
    tab_b8: TTabSheet;
    tab_b9: TTabSheet;
    tab_b10: TTabSheet;
    tab_b11: TTabSheet;
    tab_b12: TTabSheet;
    tab_b13: TTabSheet;
    tab_b14: TTabSheet;
    tab_b15: TTabSheet;
    tab_b1_a_b15: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    tabBanco_de_dados: TTabSheet;
    tabFrequenciaConcurso: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    tabParImpar: TTabSheet;
    tabExternoInterno: TTabSheet;
    tabDiferencaEntreBolas: TTabSheet;
    tabBolasNasColunas15Bolas: TTabSheet;
    tabPrimo: TTabSheet;
    TabSheet7: TTabSheet;
    tabDiferenca_QT: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    tabVertical: TTabSheet;
    tg1: TToggleBox;
    tg10: TToggleBox;
    tg11: TToggleBox;
    tg12: TToggleBox;
    tg13: TToggleBox;
    tg14: TToggleBox;
    tg15: TToggleBox;
    tg16: TToggleBox;
    tg17: TToggleBox;
    tg18: TToggleBox;
    tg19: TToggleBox;
    tg2: TToggleBox;
    tg20: TToggleBox;
    tg21: TToggleBox;
    tg22: TToggleBox;
    tg23: TToggleBox;
    tg24: TToggleBox;
    tg25: TToggleBox;
    tg3: TToggleBox;
    tg4: TToggleBox;
    tg5: TToggleBox;
    tg6: TToggleBox;
    tg7: TToggleBox;
    tg8: TToggleBox;
    tg9: TToggleBox;
    tgExibirCampos: TToggleBox;
    tgAleatorioExibirCampos: TToggleBox;
    tgGeradorOpcoes: TToggleBox;
    tgVerificarAcertos: TToggleBox;
    tgAleatorioVerificarAcertos: TToggleBox;
    UpDown1: TUpDown;
    upDeslocamento: TUpDown;
    ValueListEditor1: TValueListEditor;
    XMLConfig1: TXMLConfig;
    procedure btnAleatorioNovoClick(Sender: TObject);
    procedure btnAtualizarNovosRepetidosAntigoClick(Sender: TObject);
    procedure btnAtualizarSomaFrequenciaClick(Sender : TObject);
    procedure btnAtualizarTabelaResultadosClick(Sender: TObject);
    procedure btnAtualizar_Combinacao_ComplementarClick(Sender: TObject);
    procedure btnFiltroExcluirTodosClick(Sender : TObject);
    procedure btnFiltroGerarClick(Sender: TObject);
    procedure btnFrequenciaAtualizarClick(Sender: TObject);
    procedure btnGeradorAleatorioComFiltroClick(Sender: TObject);
    procedure btnGeradorAleatorioSemFiltroClick(Sender: TObject);
    procedure btnGrupo2BolasMarcarTodosClick(Sender: TObject);
    procedure btnLotofacilResultadoExcluirClick(Sender: TObject);
    procedure btnLotofacilResultadoInserirClick(Sender: TObject);
    //procedure btnGrupo2BolasDesmarcarTodosClick(Sender: TObject);
    procedure btnNovosFiltrosClick(Sender: TObject);
    procedure btnObterResultadosClick(Sender: TObject);
    procedure btnPararDeAtualizarNovosRepetidosClick(Sender: TObject);
    procedure btnFiltroExcluirClick(Sender : TObject);
    procedure btnSelecionarClick(Sender: TObject);
    procedure btnVerificarAcertoClick(Sender: TObject);
    procedure btnAtualizarNovosRepetidos2Click(Sender: TObject);
    //procedure CheckBox1Change(Sender : TObject);
    procedure chkExibirCamposClickCheck(Sender: TObject);
    procedure cmbAinda_Nao_Saiu_MaximoChange(Sender: TObject);
    procedure cmbAinda_Nao_Saiu_MinimoChange(Sender: TObject);
    procedure cmbAleatorioFiltroDataChange(Sender: TObject);
    procedure cmbAlgarismo_na_dezena_consolidado_concurso_finalChange(Sender : TObject);
    procedure cmbAlgarismo_na_dezena_consolidado_concurso_inicialChange(Sender : TObject);
    //procedure cmbConcursoFrequenciaNaoSairChange(Sender : TObject);
    procedure cmbConcursoFrequenciaSairChange(Sender: TObject);
    procedure cmbConcursoFrequenciaTotalSairChange(Sender: TObject);
    procedure cmbDeixou_de_Sair_MaximoChange(Sender: TObject);
    procedure cmbDeixou_de_Sair_MinimoChange(Sender: TObject);
    procedure cmbExternoInternoConsolidadoConcursoFinalChange(Sender: TObject);
    procedure cmbExternoInternoConsolidadoConcursoInicialChange(Sender: TObject);
    procedure cmbFiltroDataChange(Sender: TObject);
    procedure cmbFrequenciaFimChange(Sender: TObject);
    procedure cmbFrequenciaInicioChange(Sender: TObject);
    procedure cmbNovosRepetidosConsolidadoConcursoFinalChange(Sender: TObject);
    procedure cmbNovosRepetidosConsolidadoConcursoInicialChange(Sender: TObject);
    procedure cmbNovo_MaximoChange(Sender: TObject);
    procedure cmbNovo_MinimoChange(Sender: TObject);
    procedure cmbParImparConsolidadoConcursoFinalChange(Sender: TObject);
    procedure controle_cmb_intervalo_por_concurso_alterou(Sender: TObject);
    procedure cmbPrimoNaoPrimoConsolidadoConcursoFinalChange(Sender: TObject);
    procedure cmbPrimoNaoPrimoConsolidadoConcursoInicialChange(Sender: TObject);
    procedure cmbRepetindo_MaximoChange(Sender: TObject);
    procedure cmbRepetindo_MinimoChange(Sender: TObject);
    //procedure edConcursoKeyDown(Sender: TObject; var Key: word;  Shift: TShiftState);
    procedure edConcursoKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure pageFiltrosChange(Sender : TObject);
    //procedure grpDiagonal15BolasResize(Sender : TObject);
    //procedure pageFiltrosChange(Sender : TObject);
    //procedure pageFiltrosResize(Sender : TObject);
    //procedure pnDiagonalResize(Sender : TObject);
    //procedure rdDeslocamentoSelectionChanged(Sender: TObject);
    procedure rdGerador_Quantidade_de_BolasSelectionChanged(Sender: TObject);
    procedure sgrAlgarismo_na_dezena_consolidadoSelectCell(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure sgrAlgarismo_na_dezena_por_concursoSelectCell(Sender : TObject; aCol, aRow : Integer;
      var CanSelect : Boolean);
    procedure sgrBolas_na_mesma_colunaSelectCell(Sender: TObject; aCol,
      aRow: Integer; var CanSelect: Boolean);

    procedure sgrColunaB1_15BolasSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    //procedure sgrColunaB1_16BolasSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
    //procedure sgrColunaB1_17BolasSelectCell(Sender : TObject; aCol,
    //  aRow : Integer; var CanSelect : Boolean);
    //procedure sgrColunaB1_18BolasSelectCell(Sender : TObject; aCol,
    //  aRow : Integer; var CanSelect : Boolean);
    procedure sgrColunaB1_B15_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B15_16BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B15_17BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B15_18BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B2_15BolasDrawCell(Sender: TObject;
      aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
    procedure sgrColunaB1_B2_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B2_B3_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B2_B3_B4_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B2_B3_B4_B5_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_16BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_17BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B4_B8_B12_B15_18BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B8_B15_15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B8_B15_16BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B8_B15_17BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrColunaB1_B8_B15_18BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrExternoInterno15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrExternoInternoPorConcursoSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    procedure sgrFrequenciaDrawCell(Sender: TObject; aCol, aRow: integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgrGrupo2BolasSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure sgrGrupo3BolasSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure sgrGrupo4BolasSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure sgrGrupo5BolasSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure sgrNovosRepetidosSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);
    //procedure sgrNovosRepetidos16BolasButtonClick(Sender : TObject; aCol, aRow : Integer);

    //procedure sgrNovosRepetidos16BolasClick(Sender : TObject);
    //procedure sgrNovosRepetidos16BolasSelectCell(Sender : TObject; aCol,
    //  aRow : Integer; var CanSelect : Boolean);
    //procedure sgrNovosRepetidos17BolasClick(Sender : TObject);
    procedure sgrParImpar15BolasSelectCell(Sender: TObject;
      aCol, aRow: integer; var CanSelect: boolean);

    //procedure tabDiagonalResize(Sender : TObject);
    //procedure sheetFiltroResize(Sender : TObject);
    procedure tgBolaChange(Sender: TObject);
    procedure tgExibirCamposChange(Sender: TObject);
    procedure tgGeradorOpcoesChange(Sender: TObject);
    procedure tgVerificarAcertosChange(Sender: TObject);

  private
    procedure Algarismo_na_dezena_consolidado_concurso_inicial_final_alterou;
    procedure AlterarMarcador(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure AtivarDesativarControles;
    //procedure AtualizarColuna_B(objControle : TStringGrid);
    procedure AtualizarControleFrequencia(objControle: TStringGrid);
    procedure AtualizarControleFrequenciaMinimoMaximo;
    procedure AtualizarControleGrupo(objControle: TStringGrid);
    procedure AtualizarFiltroData(Sender: TObject; strWhere: string);
    procedure AtualizarFrequencia;
    procedure AtualizarFrequenciaBolas;
    //procedure AtualizarNovosRepetidos(concurso : Integer);
    procedure Atualizar_Combinacao_Complementar(bolas_por_combinacao: integer);
    function Atualizar_Controle_Lotofacil_Resultado: boolean;
    procedure Atualizar_Controle_sgrFiltro(strWhere_Data_Hora: string);
    procedure CarregarColuna_B(objControle: TStringGrid; strSql: string);
    procedure CarregarColuna_B;
    procedure CarregarConcursoFrequenciaTotalSair;
    procedure CarregarConcursos;
    //procedure CarregarControleDiferencaEntreBolas_qt_1;
    //procedure CarregarControleDiferencaEntreBolas_Qt_1_Qt_2(strWhere: string);
    //procedure CarregarControleDiferenca_qt_alt_1(strWhere: string);
    //procedure CarregarControleDiferenca_qt_alt_2(strWhere: string);
    procedure CarregarControlesTG;
    procedure CarregarDiagonal;
    procedure CarregarDiagonal(objControle: TStringGrid);
    //procedure CarregarControleDiferenca_qt_alt;
    procedure CarregarDiferencaEntreBolas;
    //procedure CarregarExterno_Interno;
    procedure CarregarFrequencia;
    procedure CarregarFrequencia(strSqlWhere: string);
    procedure CarregarFrequenciaBolas;
    procedure CarregarFrequenciaPorConcurso(objControle: TStringGrid);
    procedure CarregarGrupo2Bolas;
    procedure CarregarGrupo3Bolas(strSqlWhere: string);
    procedure CarregarGrupo4Bolas(strSqlWhere: string);
    procedure CarregarGrupo5Bolas(strSqlWhere: string);
    procedure CarregarControleLotofacilSoma;
    procedure CarregarNovosRepetidosUltimaAtualizacao;
    procedure CarregarPrimo;

    procedure CarregarTodosControles;
    procedure Carregar_cmb_intervalo_por_concurso_bx_a_by;
    procedure Carregar_Controles_Algarismo_na_dezena;
    procedure Carregar_controle_bx_a_by;
    procedure Carregar_controle_bolas_na_mesma_coluna;
    procedure Carregar_Controle_sgrFiltro(strWhere_Data_Hora: string);
    procedure sgr_bx_a_by_atualizar_dependentes(objControle: TStringGrid);
    //procedure controle_cmb_intervalo_por_concurso_alterou(Sender: TObject);
    procedure Mapear_cmb_bx_a_by_concurso_inicial_final;
    procedure mapear_sgr_bx_a_by;
    procedure ConfigurarControleConcursoFrequenciaTotalSair(objControle: TStringGrid);
    //procedure ConfigurarControleDiferencaEntreBolas_qt_1;
    //procedure ConfigurarControleDiferencaEntreBolas_qt_1_qt_2;
    //procedure ConfigurarControleDiferenca_qt_alt;
    //procedure ConfigurarControleDiferenca_qt_alt_1;
    //procedure ConfigurarControleDiferenca_qt_alt_2;
    procedure ConfigurarControleFrequenciaBolas(objControle: TStringGrid);
    procedure ConfigurarControleGrupo2Bolas;
    procedure ConfigurarControleDiagonal(objControle: TStringGrid);
    procedure ConfigurarControleFrequencia;
    procedure ConfigurarControleFrequenciaCombinacao;
    procedure ConfigurarControleGrupo3Bolas;
    procedure ConfigurarControleGrupo4Bolas;
    procedure ConfigurarControleGrupo5Bolas;
    procedure ConfigurarControleLotofacilSoma;
    procedure ConfigurarControlesBolas_B(objControle: TStringGrid);
    procedure CarregarExternoInterno;
    { TODO: 0: Esta procedure será deletada, pois, ela foi movida pra outra
    classe}
    //procedure CarregarExternoInterno(objControle : TStringGrid);
    procedure CarregarNovosRepetidos;
    //procedure CarregarNovosRepetidos(objControle : TStringGrid);
    //procedure CarregarNovosRepetidosConcurso;
    procedure CarregarParImpar;
    {
     TODO: Deleta a procedure CarregarParImpar(objControle : TStringGrid),
     quando os testes forem realizados,
     pois, esta procedure foi movido pra uma classe TLotofacil
    }
    //procedure CarregarParImpar(objControle : TStringGrid);
    // procedure ConfigurarControlesBolas_B(objControle : TStringGrid);

    // TODO: Deletar procedure após mover procedure pra o arquivo uLotofacil_colunas_b.
    //procedure ConfigurarControlesBolas_B1(objControle : TStringGrid);


    //TODO: Deletar procedure.
    //procedure ConfigurarControlesBolas_b1_b15(objControle: TStringGrid);

    {
     TODO: Deletar estas procedure e a implementação após mover procedures
     pra o arquivo uLotofacil_Colunas_B.
    procedure ConfigurarControlesBolas_b1_b2(objControle : TStringGrid);
    procedure ConfigurarControlesBolas_b1_b2_b3(objControle : TStringGrid);
    procedure ConfigurarControlesBolas_b1_b2_b3_b4(objControle : TStringGrid);
    procedure ConfigurarControlesBolas_b1_b2_b3_b4_b5(objControle : TStringGrid);


    procedure ConfigurarControlesBolas_b1_b4_b8_b12_b15(objControle: TStringGrid);
    procedure ConfigurarControlesBolas_b1_b8_b15(objControle: TStringGrid);
    }

    {
     TODO: Deleta a procedure ConfigurarControlesParImpar(objControle : TStringGrid),
     quando os testes forem realizados,
     pois, esta procedure foi movido pra uma classe TLotofacil
    }
    // procedure ConfigurarControlesParImpar(objControle : TStringGrid);
    //procedure ConfigurarControlesNovosRepetidos(objControle : TStringGrid);

    {TODO: Item abaixo será excluido }
    //procedure ConfigurarControlesExternoInterno(objControle : TStringGrid);

    {TODO: Item abaixo será excluido }
    //procedure ConfigurarControlesPrimo(objControle : TStringGrid);
    procedure ConfigurarFrequenciaPorConcurso(objControle: TStringGrid);
    procedure ConfigurarGeradorOpcoes;
    procedure Configurar_Controle_sgrFiltro;
    procedure Controle_Diferenca_entre_Bolas_alterou(objControle: TStringGrid);
    procedure Exibir_Ocultar_Filtro_Campos;
    procedure ExternoInternoConsolidadoConcursoInicialFinalAlterou;
    procedure Filtro_Excluir(filtro_data_hora : AnsiString);


    function GerarSqlBolas_Por_Posicao : string;
    function GerarSqlColunaB: string;
    procedure GerarSqlColuna_B(objControle: TStringGrid);
    function GerarSqlDiferenca_qt_alt: string;
    function GerarSqlDiferenca_qt_dif: string;
    function GerarSqlExternoInterno: string;
    function GerarSqlFrequencia: string;
    procedure GerarSqlGrupo(sqlGrupo: TStringList);
    function GerarSqlLotofacilSoma: string;
    function GerarSqlNovosRepetidos: string;
    function GerarSqlParImpar: string;
    function GerarSqlPrimo: string;
    function Gerar_Combinacao_Complementar(lotofacil_bolas: array of integer;
      bolas_por_combinacao: integer;
      out lotofacil_aleatorio: TAleatorio_Resultado): boolean;
    function Gerar_Complementar_15_Numeros: boolean;
    function Gerar_Lotofacil_Aleatorio(
      var lotofacil_aleatorio: TAleatorio_Resultado; bolas_por_combinacao: integer;
      qt_de_combinacoes: integer): boolean;
    function Gerar_Lotofacil_Aleatorio_Novo(var lotofacil_aleatorio : TAleatorio_Resultado;
      bolas_por_combinacao : integer; qt_de_combinacoes : integer) : boolean;
    function Gerar_sql_algarismo_na_dezena : string;
    function gerar_sql_b1_a_b15: string;
    //procedure Iniciar_Banco_de_Dados;
    procedure InserirNovoFiltro(sqlFiltro: TStringList);
    function Inserir_Aleatorio_Temporario(ltf_aleatorio: TAleatorio_Resultado;
      bolas_por_combinacao: integer): boolean;
    function Inserir_Lotofacil_Resultado_Importacao(lista_concurso: TStringList)
      : boolean;
    procedure lotofacil_novos_repetidos_status(ltf_msg: string);
    procedure lotofacil_novos_repetidos_status_atualizacao(ltf_id: longword;
      ltf_qt: byte);
    procedure lotofacil_novos_repetidos_status_concluido(ltf_status: string);
    procedure lotofacil_novos_repetidos_status_erro(ltf_erro: string);
    procedure Mapear_sgr_bx_a_by_dependentes;
    procedure Mapear_sgr_intervalo_por_concurso_bx_a_by;
    procedure MarcarGrupo2Bolas;
    procedure NovosRepetidosConsolidadoConcursoInicialFinalAlterou;
    procedure obterNovosFiltros(Sender: TObject);
    function Obter_Lotofacil_Resultado(arquivo_html: ansistring): boolean;
    function Obter_Lotofacil_Resultado: boolean;
    procedure parImparConsolidadoConcursoInicialFinalAlterou;
    procedure PrimoNaoPrimoConsolidadoConcursoInicialFinalAlterou;
    function Selecionar_sgr_bx_a_by: boolean;
    procedure Soma_Frequencia_Status(status : string);
    procedure Soma_Frequencia_Status_Concluido(status : string);
    procedure Soma_Frequencia_Status_Erro(status_erro : string);
    //procedure RedimensionarControleDiagonal;
    procedure Verificar_Acertos(Sender: TObject);
    procedure Verificar_Controle_Frequencia_Minimo_Maximo(Sender: TObject);
    //procedure tgBolaChange(Sender : TObject);
    { private declarations }
  public
    { public declarations }

  private
    // Esta variável armazenará todos os controles que serão
    // populados com dados referente a análise das colunas b1 a b15.
    f_sgr_bx_a_by_lista : TLista_Controle_B1_a_B15;

    //f_lista_de_controles_b1_a_b15 : TStringList;

    // Armazena pra cada controle, uma lista de controles do qual depende.
    f_controles_dependentes : Tcontroles_dependentes;
    //f_lista_controles_dependentes: array [1..15] of TLista_Controle_B1_a_B15;

    // Mapear o nome do controle pra a instância do controle.
    f_sgr_bx_a_by_mapa: TMap_String_TStringGrid;

    // f_cmb_bx_a_by_lista: TMap_String_TComboBox;
    f_cmb_bx_a_by_lista : TList_ComboBox;

    // Mapea o nome do controle com a instância do controle do tipo 'TComboBox':
    // Os controles utilizados estão desta forma:
    // cmb_intervalo_por_concurso_inicial_bx_a_by ou
    // cmb_intervalo_por_concurso_final_bx_a_by, onde x e y representa números
    // no intervalo de 1 a 15, onde x >= y.
    f_cmb_intervalo_por_concurso_bx_a_by: TMap_String_TComboBox;
    f_sgr_intervalo_por_concurso_bx_a_by: TMap_String_TStringGrid;

    // Mapea o nome do controle inicial do tipo 'TComboBox' com o controle final
    // do tipo 'TComboBox'.
    f_cmb_bx_a_by_mapear_inicial_final: TMap_String_String;


    // Indica o controle que deve ser atualizado baseado no controle que modificou.
    // Ou seja, a selecionar um controle e alterar a seleção de alguma combinação
    // automaticamente outro controle será atualizado.
    f_controles_b1_a_b15_pra_ser_atualizado: TMap_String_StringList;


    { private declarations }
    { Este arranjo é utiliza na guia Concurso para poder utilizar nos controles
      que começa com tg1 a tg25
    }
    lotofacil_numeros_escolhidos: array[1..25] of integer;
    lotofacil_resultado_botoes: array[1..25] of TToggleBox;
    lotofacil_qt_bolas_escolhidas: integer;

    {
     Os arranjos
    }
    concurso_frequencia_sair: array[1..25] of integer;
    concurso_frequencia_nao_sair: array[1..25] of integer;

    filtro_campos_selecionados: array[0..59] of boolean;

    //lotofacil_num : array of array of array of Integer;

    strErro: ansistring;

    ltf_novos_repetidos: TLotofacilNovosRepetidos;

    //ltf_soma_frequencia: array of array of Integer;

  end;

const
  LOTOFACIL_ULTIMO_INDICE = 6874010;


var
  Form1: TForm1;

implementation

uses
  uLotofacil_Gerador_id,
  uLotofacilParImpar,
  ulotofacilexternointerno,
  uLotofacil_Colunas_B,
  ulotofacil_diferenca_entre_bolas,
  ulotofacil_algarismo_nas_dezenas,
  uLotofacilSomaFrequencia,
  ulotofacil_bolas_na_mesma_coluna,
  ulotofacil_b1_a_b15,
  //Regex,
  ulotofacil_concursos
  ;

var
  dmLotofacil: TdmLotofacil;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  CarregarTodosControles;
  AtivarDesativarControles;
  ConfigurarGeradorOpcoes;
end;

procedure TForm1.pageFiltrosChange(Sender : TObject);
begin

end;

procedure TForm1.ConfigurarGeradorOpcoes;
begin
  // Padrão 15 bolas.
  rdGerador_Quantidade_de_Bolas.ItemIndex := 0;
end;

procedure TForm1.AtivarDesativarControles;
begin
  pnExibirCampos.Visible := False;
  tgExibirCampos.Checked := False;

  pnVerificarAcertos.Visible := False;
  tgVerificarAcertos.Checked := False;

  Exibir_Ocultar_Filtro_Campos;

  tabFrequencia.Visible := False;

end;

procedure TForm1.Exibir_Ocultar_Filtro_Campos;
var
  uA: integer;
begin
  // Marcar quais campos devem aparecer exibidos.
  filtro_campos_selecionados[LTF_ID] := True;
  filtro_campos_selecionados[LTF_QT] := True;
  filtro_campos_selecionados[LTF_ACERTOS] := True;

  for uA := B_1 to B_18 do
  begin
    filtro_campos_selecionados[uA] := True;
  end;

  filtro_campos_selecionados[LTF_QT_ALT] := True;
  filtro_campos_selecionados[LTF_QT_DIF_1] := True;
  filtro_campos_selecionados[LTF_QT_DIF_2] := True;
  filtro_campos_selecionados[LTF_QT_DIF_3] := True;

  // Iniciar controle 'chkExibirCampos'
  chkExibirCampos.Items.Clear;
  for uA := 0 to High(filtro_campos_selecionados) do
  begin
    chkExibirCampos.Items.Add(filtros_campos[uA]);
  end;

  for uA := 0 to High(filtro_campos_selecionados) do
  begin
    chkExibirCampos.Checked[uA] := filtro_campos_selecionados[uA];
  end;
end;

//procedure TForm1.Iniciar_Banco_de_Dados;
//begin
//     //dmLotofacil.dbLotofacil.;
//end;

{
 Este procedure atualiza todos os controles, ao iniciar, esta procedure é chamada.
}
procedure TForm1.CarregarTodosControles;
begin
  dmLotofacil := nil;

  CarregarNovosRepetidos;
  CarregarParImpar;
  CarregarExternoInterno;
  CarregarPrimo;
  CarregarColuna_B;
  //CarregarFrequencia;
  //CarregarDiagonal;
  //CarregarGrupo2Bolas;
  CarregarControlesTG;

  CarregarConcursos;

  // Não carregar a frequencia por enquanto.
  // CarregarFrequenciaBolas;

  CarregarFrequenciaPorConcurso(sgrFrequencia_Bolas_Sair_Nao_Sair);
  //CarregarFrequenciaPorConcurso(sgrFrequenciaBolasNaoSair);

  CarregarConcursoFrequenciaTotalSair;

  CarregarDiferencaEntreBolas;
  CarregarControleDiferenca_qt_alt(sgrDiferenca_qt_alt);

  CarregarControleLotofacilSoma;

  Carregar_controles_algarismo_na_dezena;

  Carregar_controle_bolas_na_mesma_coluna;

  if Assigned(dmLotofacil) then begin
    dmLotofacil.pgLtk.Close(true);
  end;

  Carregar_controle_bx_a_by;
end;

{
 Dentro da guia 'B1_A_B15' há 15 controles: B1, B2, B3, B4, B5, B6, B7, B8, B9,
 B10, B11, B12, B13, B14 e b15:
 Dentro de cada guia, há guia que começa do nome da coluna até a coluna de número 15.
 Por exemplo, na guia, B12, há quatro guias dentro dela desta forma:
 B12_A_B12, B12_A_B13, B12_A_B14, B12_A_B15.
 Dentro de cada guia, há um controle TStringGrid que armazena a estatística de
 quantas vezes a combinação de bolas naquela posição já saiu no concurso.
 Por exemplo, na guia B12_A_B13, iremos contabilizar e agrupar por bolas nesta
 posição, quantas vezes saíram, segue-se exemplo, vamos supor as bolas:
 12, 14;
 12, 17;
 12, 14;
 12, 19;
 12, 14;
 Tais bolas saíram na posição b12 e b13, então, por isto que se dize B12_A_B13.
 Se formos contabilizar: 12 e 14, saíram 3 vezes, e as outras combinações saíram
 uma única vez.
 Como irá funcionar, cada vez que um combinação for escolhida pelo usuário,
 um outro controle será atualizado automaticamente.
 No exemplo acima, vamos supor que o usuário selecionar a combinação 12 e 14, pois
 está saindo mais, tal informação está no controle 'sgr_b12_a_b13', quando ele fizer
 isto, o controle 'sgr_b12_a_b14' será atualizado pra refletir a nova escolha.
 O motivo do controle 'sgr_b12_a_b14' ser atualizado é por que as colunas b12 e b13
 fazem parte desta combinação. Entretanto, só iremos atualizar um controle por vez
 e também, somente será atualizado controles da mesma guia. Por exemplo, se eu seleciono
 alguma combinação que está em uma das guias dentro da guia B2, só irá atualizar
 tais controles, por exemplo, se o usuário marca o controle sgr_b2_a_b5, o
 controle sgr_b2_a_b6 atualizado automaticamente.

}
procedure TForm1.mapear_sgr_bx_a_by;
begin
  Mapear_sgr_bx_a_by_dependentes;

  if not Assigned(f_sgr_bx_a_by_mapa) then begin
     f_sgr_bx_a_by_mapa := TMapa_Controle_B1_a_B15.Create;
  end;

  f_sgr_bx_a_by_mapa.Clear;

  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b1', sgr_b1_a_b1);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b2', sgr_b1_a_b2);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b3', sgr_b1_a_b3);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b4', sgr_b1_a_b4);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b5', sgr_b1_a_b5);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b6', sgr_b1_a_b6);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b7', sgr_b1_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b8', sgr_b1_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b9', sgr_b1_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b1_a_b10', sgr_b1_a_b10);

  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b2', sgr_b2_a_b2);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b3', sgr_b2_a_b3);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b4', sgr_b2_a_b4);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b5', sgr_b2_a_b5);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b6', sgr_b2_a_b6);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b7', sgr_b2_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b8', sgr_b2_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b9', sgr_b2_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b2_a_b10', sgr_b2_a_b10);

  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b3', sgr_b3_a_b3);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b4', sgr_b3_a_b4);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b5', sgr_b3_a_b5);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b6', sgr_b3_a_b6);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b7', sgr_b3_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b8', sgr_b3_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b9', sgr_b3_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b3_a_b10', sgr_b3_a_b10);

  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b4', sgr_b4_a_b4);
  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b5', sgr_b4_a_b5);
  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b6', sgr_b4_a_b6);
  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b7', sgr_b4_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b8', sgr_b4_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b9', sgr_b4_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b4_a_b10', sgr_b4_a_b10);

  f_sgr_bx_a_by_mapa.Add('sgr_b5_a_b5', sgr_b5_a_b5);
  f_sgr_bx_a_by_mapa.Add('sgr_b5_a_b6', sgr_b5_a_b6);
  f_sgr_bx_a_by_mapa.Add('sgr_b5_a_b7', sgr_b5_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b5_a_b8', sgr_b5_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b5_a_b9', sgr_b5_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b5_a_b10', sgr_b5_a_b10);

  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b6', sgr_b6_a_b6);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b7', sgr_b6_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b8', sgr_b6_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b9', sgr_b6_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b10', sgr_b6_a_b10);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b11', sgr_b6_a_b11);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b12', sgr_b6_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b13', sgr_b6_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b14', sgr_b6_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b6_a_b15', sgr_b6_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b7', sgr_b7_a_b7);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b8', sgr_b7_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b9', sgr_b7_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b10', sgr_b7_a_b10);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b11', sgr_b7_a_b11);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b12', sgr_b7_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b13', sgr_b7_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b14', sgr_b7_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b7_a_b15', sgr_b7_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b8', sgr_b8_a_b8);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b9', sgr_b8_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b10', sgr_b8_a_b10);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b11', sgr_b8_a_b11);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b12', sgr_b8_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b13', sgr_b8_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b14', sgr_b8_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b8_a_b15', sgr_b8_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b9', sgr_b9_a_b9);
  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b10', sgr_b9_a_b10);
  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b11', sgr_b9_a_b11);
  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b12', sgr_b9_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b13', sgr_b9_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b14', sgr_b9_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b9_a_b15', sgr_b9_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b10_a_b10', sgr_b10_a_b10);
  f_sgr_bx_a_by_mapa.Add('sgr_b10_a_b11', sgr_b10_a_b11);
  f_sgr_bx_a_by_mapa.Add('sgr_b10_a_b12', sgr_b10_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b10_a_b13', sgr_b10_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b10_a_b14', sgr_b10_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b10_a_b15', sgr_b10_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b11_a_b11', sgr_b11_a_b11);
  f_sgr_bx_a_by_mapa.Add('sgr_b11_a_b12', sgr_b11_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b11_a_b13', sgr_b11_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b11_a_b14', sgr_b11_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b11_a_b15', sgr_b11_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b12_a_b12', sgr_b12_a_b12);
  f_sgr_bx_a_by_mapa.Add('sgr_b12_a_b13', sgr_b12_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b12_a_b14', sgr_b12_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b12_a_b15', sgr_b12_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b13_a_b13', sgr_b13_a_b13);
  f_sgr_bx_a_by_mapa.Add('sgr_b13_a_b14', sgr_b13_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b13_a_b15', sgr_b13_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b14_a_b14', sgr_b14_a_b14);
  f_sgr_bx_a_by_mapa.Add('sgr_b14_a_b15', sgr_b14_a_b15);

  f_sgr_bx_a_by_mapa.Add('sgr_b15_a_b15', sgr_b15_a_b15);


end;

{
 Seja, os controles 'cmb_intervalo_por_concurso_inicial_bx_a_by' e
 'cmb_intervalo_por_concurso_inicial_bx_a_by', do tipo 'TComboBox',
 tal que o 'x' e 'y' são números de 1 a 15, onde, o número em 'x' é menor que ou
 igual ao número em 'y'.
 Toda vez que um dos controles tem o conteúdo alterado, devemos, atualizar o
 controle do tipo TStringGrid correspondente. Este controle do tipo TStringGrid
 terá o nome da forma 'sgr_intervalo_por_concurso_bx_a_by', onde x e y, terá o mesmo
 valor do número que corresponde ao controle do tipo 'TComboBox' que teve o conteúdo
 alterado.
 Toda vez que um dos controles do tipo 'TComboBox' tiver o conteúdo alterado, deve
 obter informação do outro controle 'TComboBox' correspondente, pois um dos controles
 armazena o concurso inicial e o outro armazena o concurso final.
 De posse do número inicial e final do concurso, deve-se passar esta informação
 pra a  procedure 'Carregar_sgr_bx_a_by_intervalo_concurso' que está
 no arquivo 'ulotofacil_b1_a_b15', além desta informação precisamos saber qual
 controle 'TStringGrid' devemos atualizar.
 Pra isto, iremos ter uma procedure que mapea cada controle 'TComboBox' inicial
 com o controle 'TComboBox' final correspondente.
}
procedure TForm1.Mapear_cmb_bx_a_by_concurso_inicial_final;
var
  uA, uB: Integer;
  nome_inicial, nome_final: String;
begin
  if not Assigned(f_cmb_bx_a_by_mapear_inicial_final) then begin
     f_cmb_bx_a_by_mapear_inicial_final:=TMap_String_String.Create;
  end;
  f_cmb_bx_a_by_mapear_inicial_final.Clear;

  // Aqui, estamos mapeando o nome do controle inicial do tipo 'TComboBox'
  // com o nome do controle final do tipo 'TComboBox'.
  for uA := 1 to 15 do begin
    for uB := uA to 15 do begin
      nome_inicial := 'cmb_intervalo_por_concurso_inicial_' + Format('b%d_a_b%d', [uA, uB]);
      nome_final :=   'cmb_intervalo_por_concurso_final_' + Format('b%d_a_b%d', [uA, uB]);
      f_cmb_bx_a_by_mapear_inicial_final.Add(nome_inicial, nome_final);
      f_cmb_bx_a_by_mapear_inicial_final.Add(nome_final, nome_inicial);
    end;
  end;

  // Agora, iremos mapear o nome do controle do tipo 'TComboBox' com a instância
  // do mesmo controle.
  // Isto facilitará na hora de
  if not Assigned(f_cmb_intervalo_por_concurso_bx_a_by) then begin
     f_cmb_intervalo_por_concurso_bx_a_by := TMap_String_TComboBox.Create;
  end;
  f_cmb_intervalo_por_concurso_bx_a_by.Clear;

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b1', cmb_intervalo_por_concurso_inicial_b1_a_b1);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b2', cmb_intervalo_por_concurso_inicial_b1_a_b2);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b3', cmb_intervalo_por_concurso_inicial_b1_a_b3);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b4', cmb_intervalo_por_concurso_inicial_b1_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b5', cmb_intervalo_por_concurso_inicial_b1_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b6', cmb_intervalo_por_concurso_inicial_b1_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b7', cmb_intervalo_por_concurso_inicial_b1_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b8', cmb_intervalo_por_concurso_inicial_b1_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b9', cmb_intervalo_por_concurso_inicial_b1_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b1_a_b10', cmb_intervalo_por_concurso_inicial_b1_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b2', cmb_intervalo_por_concurso_inicial_b2_a_b2);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b3', cmb_intervalo_por_concurso_inicial_b2_a_b3);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b4', cmb_intervalo_por_concurso_inicial_b2_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b5', cmb_intervalo_por_concurso_inicial_b2_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b6', cmb_intervalo_por_concurso_inicial_b2_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b7', cmb_intervalo_por_concurso_inicial_b2_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b8', cmb_intervalo_por_concurso_inicial_b2_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b9', cmb_intervalo_por_concurso_inicial_b2_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b2_a_b10', cmb_intervalo_por_concurso_inicial_b2_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b3', cmb_intervalo_por_concurso_inicial_b3_a_b3);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b4', cmb_intervalo_por_concurso_inicial_b3_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b5', cmb_intervalo_por_concurso_inicial_b3_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b6', cmb_intervalo_por_concurso_inicial_b3_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b7', cmb_intervalo_por_concurso_inicial_b3_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b8', cmb_intervalo_por_concurso_inicial_b3_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b9', cmb_intervalo_por_concurso_inicial_b3_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b3_a_b10', cmb_intervalo_por_concurso_inicial_b3_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b4', cmb_intervalo_por_concurso_inicial_b4_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b5', cmb_intervalo_por_concurso_inicial_b4_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b6', cmb_intervalo_por_concurso_inicial_b4_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b7', cmb_intervalo_por_concurso_inicial_b4_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b8', cmb_intervalo_por_concurso_inicial_b4_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b9', cmb_intervalo_por_concurso_inicial_b4_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b4_a_b10', cmb_intervalo_por_concurso_inicial_b4_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b5_a_b5', cmb_intervalo_por_concurso_inicial_b5_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b5_a_b6', cmb_intervalo_por_concurso_inicial_b5_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b5_a_b7', cmb_intervalo_por_concurso_inicial_b5_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b5_a_b8', cmb_intervalo_por_concurso_inicial_b5_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b5_a_b9', cmb_intervalo_por_concurso_inicial_b5_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b5_a_b10', cmb_intervalo_por_concurso_inicial_b5_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b6', cmb_intervalo_por_concurso_inicial_b6_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b7', cmb_intervalo_por_concurso_inicial_b6_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b8', cmb_intervalo_por_concurso_inicial_b6_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b9', cmb_intervalo_por_concurso_inicial_b6_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b10', cmb_intervalo_por_concurso_inicial_b6_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b11', cmb_intervalo_por_concurso_inicial_b6_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b12', cmb_intervalo_por_concurso_inicial_b6_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b13', cmb_intervalo_por_concurso_inicial_b6_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b14', cmb_intervalo_por_concurso_inicial_b6_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b6_a_b15', cmb_intervalo_por_concurso_inicial_b6_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b7', cmb_intervalo_por_concurso_inicial_b7_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b8', cmb_intervalo_por_concurso_inicial_b7_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b9', cmb_intervalo_por_concurso_inicial_b7_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b10', cmb_intervalo_por_concurso_inicial_b7_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b11', cmb_intervalo_por_concurso_inicial_b7_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b12', cmb_intervalo_por_concurso_inicial_b7_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b13', cmb_intervalo_por_concurso_inicial_b7_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b14', cmb_intervalo_por_concurso_inicial_b7_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b7_a_b15', cmb_intervalo_por_concurso_inicial_b7_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b8', cmb_intervalo_por_concurso_inicial_b8_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b9', cmb_intervalo_por_concurso_inicial_b8_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b10', cmb_intervalo_por_concurso_inicial_b8_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b11', cmb_intervalo_por_concurso_inicial_b8_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b12', cmb_intervalo_por_concurso_inicial_b8_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b13', cmb_intervalo_por_concurso_inicial_b8_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b14', cmb_intervalo_por_concurso_inicial_b8_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b8_a_b15', cmb_intervalo_por_concurso_inicial_b8_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b9', cmb_intervalo_por_concurso_inicial_b9_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b10', cmb_intervalo_por_concurso_inicial_b9_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b11', cmb_intervalo_por_concurso_inicial_b9_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b12', cmb_intervalo_por_concurso_inicial_b9_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b13', cmb_intervalo_por_concurso_inicial_b9_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b14', cmb_intervalo_por_concurso_inicial_b9_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b9_a_b15', cmb_intervalo_por_concurso_inicial_b9_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b10_a_b10', cmb_intervalo_por_concurso_inicial_b10_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b10_a_b11', cmb_intervalo_por_concurso_inicial_b10_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b10_a_b12', cmb_intervalo_por_concurso_inicial_b10_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b10_a_b13', cmb_intervalo_por_concurso_inicial_b10_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b10_a_b14', cmb_intervalo_por_concurso_inicial_b10_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b10_a_b15', cmb_intervalo_por_concurso_inicial_b10_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b11_a_b11', cmb_intervalo_por_concurso_inicial_b11_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b11_a_b12', cmb_intervalo_por_concurso_inicial_b11_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b11_a_b13', cmb_intervalo_por_concurso_inicial_b11_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b11_a_b14', cmb_intervalo_por_concurso_inicial_b11_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b11_a_b15', cmb_intervalo_por_concurso_inicial_b11_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b12_a_b12', cmb_intervalo_por_concurso_inicial_b12_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b12_a_b13', cmb_intervalo_por_concurso_inicial_b12_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b12_a_b14', cmb_intervalo_por_concurso_inicial_b12_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b12_a_b15', cmb_intervalo_por_concurso_inicial_b12_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b13_a_b13', cmb_intervalo_por_concurso_inicial_b13_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b13_a_b14', cmb_intervalo_por_concurso_inicial_b13_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b13_a_b15', cmb_intervalo_por_concurso_inicial_b13_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b14_a_b14', cmb_intervalo_por_concurso_inicial_b14_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b14_a_b14', cmb_intervalo_por_concurso_inicial_b14_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b14_a_b15', cmb_intervalo_por_concurso_inicial_b14_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_inicial_b15_a_b15', cmb_intervalo_por_concurso_inicial_b15_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b1', cmb_intervalo_por_concurso_final_b1_a_b1);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b2', cmb_intervalo_por_concurso_final_b1_a_b2);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b3', cmb_intervalo_por_concurso_final_b1_a_b3);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b4', cmb_intervalo_por_concurso_final_b1_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b5', cmb_intervalo_por_concurso_final_b1_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b6', cmb_intervalo_por_concurso_final_b1_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b7', cmb_intervalo_por_concurso_final_b1_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b8', cmb_intervalo_por_concurso_final_b1_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b9', cmb_intervalo_por_concurso_final_b1_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b1_a_b10', cmb_intervalo_por_concurso_final_b1_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b2', cmb_intervalo_por_concurso_final_b2_a_b2);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b3', cmb_intervalo_por_concurso_final_b2_a_b3);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b4', cmb_intervalo_por_concurso_final_b2_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b5', cmb_intervalo_por_concurso_final_b2_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b6', cmb_intervalo_por_concurso_final_b2_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b7', cmb_intervalo_por_concurso_final_b2_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b8', cmb_intervalo_por_concurso_final_b2_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b9', cmb_intervalo_por_concurso_final_b2_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b2_a_b10', cmb_intervalo_por_concurso_final_b2_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b3', cmb_intervalo_por_concurso_final_b3_a_b3);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b4', cmb_intervalo_por_concurso_final_b3_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b5', cmb_intervalo_por_concurso_final_b3_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b6', cmb_intervalo_por_concurso_final_b3_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b7', cmb_intervalo_por_concurso_final_b3_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b8', cmb_intervalo_por_concurso_final_b3_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b9', cmb_intervalo_por_concurso_final_b3_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b3_a_b10', cmb_intervalo_por_concurso_final_b3_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b4', cmb_intervalo_por_concurso_final_b4_a_b4);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b5', cmb_intervalo_por_concurso_final_b4_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b6', cmb_intervalo_por_concurso_final_b4_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b7', cmb_intervalo_por_concurso_final_b4_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b8', cmb_intervalo_por_concurso_final_b4_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b9', cmb_intervalo_por_concurso_final_b4_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b4_a_b10', cmb_intervalo_por_concurso_final_b4_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b5_a_b5', cmb_intervalo_por_concurso_final_b5_a_b5);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b5_a_b6', cmb_intervalo_por_concurso_final_b5_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b5_a_b7', cmb_intervalo_por_concurso_final_b5_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b5_a_b8', cmb_intervalo_por_concurso_final_b5_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b5_a_b9', cmb_intervalo_por_concurso_final_b5_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b5_a_b10', cmb_intervalo_por_concurso_final_b5_a_b10);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b6', cmb_intervalo_por_concurso_final_b6_a_b6);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b7', cmb_intervalo_por_concurso_final_b6_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b8', cmb_intervalo_por_concurso_final_b6_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b9', cmb_intervalo_por_concurso_final_b6_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b10', cmb_intervalo_por_concurso_final_b6_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b11', cmb_intervalo_por_concurso_final_b6_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b12', cmb_intervalo_por_concurso_final_b6_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b13', cmb_intervalo_por_concurso_final_b6_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b14', cmb_intervalo_por_concurso_final_b6_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b6_a_b15', cmb_intervalo_por_concurso_final_b6_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b7', cmb_intervalo_por_concurso_final_b7_a_b7);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b8', cmb_intervalo_por_concurso_final_b7_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b9', cmb_intervalo_por_concurso_final_b7_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b10', cmb_intervalo_por_concurso_final_b7_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b11', cmb_intervalo_por_concurso_final_b7_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b12', cmb_intervalo_por_concurso_final_b7_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b13', cmb_intervalo_por_concurso_final_b7_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b14', cmb_intervalo_por_concurso_final_b7_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b7_a_b15', cmb_intervalo_por_concurso_final_b7_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b8', cmb_intervalo_por_concurso_final_b8_a_b8);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b9', cmb_intervalo_por_concurso_final_b8_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b10', cmb_intervalo_por_concurso_final_b8_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b11', cmb_intervalo_por_concurso_final_b8_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b12', cmb_intervalo_por_concurso_final_b8_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b13', cmb_intervalo_por_concurso_final_b8_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b14', cmb_intervalo_por_concurso_final_b8_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b8_a_b15', cmb_intervalo_por_concurso_final_b8_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b9', cmb_intervalo_por_concurso_final_b9_a_b9);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b10', cmb_intervalo_por_concurso_final_b9_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b11', cmb_intervalo_por_concurso_final_b9_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b12', cmb_intervalo_por_concurso_final_b9_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b13', cmb_intervalo_por_concurso_final_b9_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b14', cmb_intervalo_por_concurso_final_b9_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b9_a_b15', cmb_intervalo_por_concurso_final_b9_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b10_a_b10', cmb_intervalo_por_concurso_final_b10_a_b10);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b10_a_b11', cmb_intervalo_por_concurso_final_b10_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b10_a_b12', cmb_intervalo_por_concurso_final_b10_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b10_a_b13', cmb_intervalo_por_concurso_final_b10_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b10_a_b14', cmb_intervalo_por_concurso_final_b10_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b10_a_b15', cmb_intervalo_por_concurso_final_b10_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b11_a_b11', cmb_intervalo_por_concurso_final_b11_a_b11);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b11_a_b12', cmb_intervalo_por_concurso_final_b11_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b11_a_b13', cmb_intervalo_por_concurso_final_b11_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b11_a_b14', cmb_intervalo_por_concurso_final_b11_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b11_a_b15', cmb_intervalo_por_concurso_final_b11_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b12_a_b12', cmb_intervalo_por_concurso_final_b12_a_b12);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b12_a_b13', cmb_intervalo_por_concurso_final_b12_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b12_a_b14', cmb_intervalo_por_concurso_final_b12_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b12_a_b15', cmb_intervalo_por_concurso_final_b12_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b13_a_b13', cmb_intervalo_por_concurso_final_b13_a_b13);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b13_a_b14', cmb_intervalo_por_concurso_final_b13_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b13_a_b15', cmb_intervalo_por_concurso_final_b13_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b14_a_b14', cmb_intervalo_por_concurso_final_b14_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b14_a_b14', cmb_intervalo_por_concurso_final_b14_a_b14);
  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b14_a_b15', cmb_intervalo_por_concurso_final_b14_a_b15);

  f_cmb_intervalo_por_concurso_bx_a_by.Add('cmb_intervalo_por_concurso_final_b15_a_b15', cmb_intervalo_por_concurso_final_b15_a_b15);


  if Not Assigned(f_cmb_bx_a_by_lista) then begin
     f_cmb_bx_a_by_lista := TList_ComboBox.Create;
  end;

  f_cmb_bx_a_by_lista.Clear;

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b1);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b2);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b3);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b1_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b2);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b3);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b2_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b3);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b3_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b4_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b5_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b5_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b5_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b5_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b5_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b5_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b6_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b7_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b8_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b9_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b10_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b10_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b10_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b10_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b10_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b10_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b11_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b11_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b11_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b11_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b11_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b12_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b12_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b12_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b12_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b13_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b13_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b13_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b14_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b14_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b14_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_inicial_b15_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b1);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b2);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b3);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b1_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b2);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b3);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b2_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b3);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b3_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b4);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b4_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b5_a_b5);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b5_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b5_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b5_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b5_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b5_a_b10);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b6);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b6_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b7);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b7_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b8);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b8_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b9);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b9_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b10_a_b10);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b10_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b10_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b10_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b10_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b10_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b11_a_b11);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b11_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b11_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b11_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b11_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b12_a_b12);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b12_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b12_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b12_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b13_a_b13);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b13_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b13_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b14_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b14_a_b14);
  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b14_a_b15);

  f_cmb_bx_a_by_lista.Add(cmb_intervalo_por_concurso_final_b15_a_b15);


end;

procedure TForm1.Mapear_sgr_intervalo_por_concurso_bx_a_by;
begin
  if not Assigned(f_sgr_intervalo_por_concurso_bx_a_by) then begin
     f_sgr_intervalo_por_concurso_bx_a_by := TMap_String_TStringGrid.Create;
  end;
  f_sgr_intervalo_por_concurso_bx_a_by.Clear;

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b1', sgr_intervalo_por_concurso_b1_a_b1);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b2', sgr_intervalo_por_concurso_b1_a_b2);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b3', sgr_intervalo_por_concurso_b1_a_b3);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b4', sgr_intervalo_por_concurso_b1_a_b4);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b5', sgr_intervalo_por_concurso_b1_a_b5);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b6', sgr_intervalo_por_concurso_b1_a_b6);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b7', sgr_intervalo_por_concurso_b1_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b8', sgr_intervalo_por_concurso_b1_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b9', sgr_intervalo_por_concurso_b1_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b1_a_b10', sgr_intervalo_por_concurso_b1_a_b10);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b2', sgr_intervalo_por_concurso_b2_a_b2);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b3', sgr_intervalo_por_concurso_b2_a_b3);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b4', sgr_intervalo_por_concurso_b2_a_b4);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b5', sgr_intervalo_por_concurso_b2_a_b5);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b6', sgr_intervalo_por_concurso_b2_a_b6);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b7', sgr_intervalo_por_concurso_b2_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b8', sgr_intervalo_por_concurso_b2_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b9', sgr_intervalo_por_concurso_b2_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b2_a_b10', sgr_intervalo_por_concurso_b2_a_b10);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b3', sgr_intervalo_por_concurso_b3_a_b3);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b4', sgr_intervalo_por_concurso_b3_a_b4);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b5', sgr_intervalo_por_concurso_b3_a_b5);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b6', sgr_intervalo_por_concurso_b3_a_b6);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b7', sgr_intervalo_por_concurso_b3_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b8', sgr_intervalo_por_concurso_b3_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b9', sgr_intervalo_por_concurso_b3_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b3_a_b10', sgr_intervalo_por_concurso_b3_a_b10);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b4', sgr_intervalo_por_concurso_b4_a_b4);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b5', sgr_intervalo_por_concurso_b4_a_b5);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b6', sgr_intervalo_por_concurso_b4_a_b6);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b7', sgr_intervalo_por_concurso_b4_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b8', sgr_intervalo_por_concurso_b4_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b9', sgr_intervalo_por_concurso_b4_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b4_a_b10', sgr_intervalo_por_concurso_b4_a_b10);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b5_a_b5', sgr_intervalo_por_concurso_b5_a_b5);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b5_a_b6', sgr_intervalo_por_concurso_b5_a_b6);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b5_a_b7', sgr_intervalo_por_concurso_b5_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b5_a_b8', sgr_intervalo_por_concurso_b5_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b5_a_b9', sgr_intervalo_por_concurso_b5_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b5_a_b10', sgr_intervalo_por_concurso_b5_a_b10);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b6', sgr_intervalo_por_concurso_b6_a_b6);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b7', sgr_intervalo_por_concurso_b6_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b8', sgr_intervalo_por_concurso_b6_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b9', sgr_intervalo_por_concurso_b6_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b10', sgr_intervalo_por_concurso_b6_a_b10);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b11', sgr_intervalo_por_concurso_b6_a_b11);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b12', sgr_intervalo_por_concurso_b6_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b13', sgr_intervalo_por_concurso_b6_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b14', sgr_intervalo_por_concurso_b6_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b6_a_b15', sgr_intervalo_por_concurso_b6_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b7', sgr_intervalo_por_concurso_b7_a_b7);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b8', sgr_intervalo_por_concurso_b7_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b9', sgr_intervalo_por_concurso_b7_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b10', sgr_intervalo_por_concurso_b7_a_b10);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b11', sgr_intervalo_por_concurso_b7_a_b11);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b12', sgr_intervalo_por_concurso_b7_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b13', sgr_intervalo_por_concurso_b7_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b14', sgr_intervalo_por_concurso_b7_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b7_a_b15', sgr_intervalo_por_concurso_b7_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b8', sgr_intervalo_por_concurso_b8_a_b8);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b9', sgr_intervalo_por_concurso_b8_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b10', sgr_intervalo_por_concurso_b8_a_b10);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b11', sgr_intervalo_por_concurso_b8_a_b11);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b12', sgr_intervalo_por_concurso_b8_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b13', sgr_intervalo_por_concurso_b8_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b14', sgr_intervalo_por_concurso_b8_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b8_a_b15', sgr_intervalo_por_concurso_b8_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b9', sgr_intervalo_por_concurso_b9_a_b9);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b10', sgr_intervalo_por_concurso_b9_a_b10);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b11', sgr_intervalo_por_concurso_b9_a_b11);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b12', sgr_intervalo_por_concurso_b9_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b13', sgr_intervalo_por_concurso_b9_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b14', sgr_intervalo_por_concurso_b9_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b9_a_b15', sgr_intervalo_por_concurso_b9_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b10_a_b10', sgr_intervalo_por_concurso_b10_a_b10);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b10_a_b11', sgr_intervalo_por_concurso_b10_a_b11);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b10_a_b12', sgr_intervalo_por_concurso_b10_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b10_a_b13', sgr_intervalo_por_concurso_b10_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b10_a_b14', sgr_intervalo_por_concurso_b10_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b10_a_b15', sgr_intervalo_por_concurso_b10_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b11_a_b11', sgr_intervalo_por_concurso_b11_a_b11);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b11_a_b12', sgr_intervalo_por_concurso_b11_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b11_a_b13', sgr_intervalo_por_concurso_b11_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b11_a_b14', sgr_intervalo_por_concurso_b11_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b11_a_b15', sgr_intervalo_por_concurso_b11_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b12_a_b12', sgr_intervalo_por_concurso_b12_a_b12);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b12_a_b13', sgr_intervalo_por_concurso_b12_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b12_a_b14', sgr_intervalo_por_concurso_b12_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b12_a_b15', sgr_intervalo_por_concurso_b12_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b13_a_b13', sgr_intervalo_por_concurso_b13_a_b13);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b13_a_b14', sgr_intervalo_por_concurso_b13_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b13_a_b15', sgr_intervalo_por_concurso_b13_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b14_a_b14', sgr_intervalo_por_concurso_b14_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b14_a_b14', sgr_intervalo_por_concurso_b14_a_b14);
  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b14_a_b15', sgr_intervalo_por_concurso_b14_a_b15);

  f_sgr_intervalo_por_concurso_bx_a_by.Add('sgr_intervalo_por_concurso_b15_a_b15', sgr_intervalo_por_concurso_b15_a_b15);

end;

{
 Atualiza todos os componentes filhos do component que foi passado no parâmetro: objControle.
 A atualização acontece desta forma:
 * Todos os controles filhos tem o contéudo do controle apagado;
 * Em seguida, o primeiro controle filho é atualizado com dados conforme o id
 do controle pai que foi atualizado.
}
procedure TForm1.sgr_bx_a_by_atualizar_dependentes(objControle: TStringGrid);
var
  nome_do_controle, nome_controle_filho, ids_selecionados_pai: string;
  indice, uA: Integer;
  lista_de_dependente, lista_de_dependentes: TStringList;
  objControle_Temp, obj_controle_filho: TStringGrid;
  nome_do_controle_pai, nome_do_campo, nome_do_campo_pai: string;
begin
  // Pega os controles secundário baseado no nome do controle.
  nome_do_controle_pai := objControle.Name;

  // Verifica se há algum controle dependente confome o parâmetro da função passado.
  lista_de_dependentes := f_controles_b1_a_b15_pra_ser_atualizado.KeyData[nome_do_controle_pai];
  if not Assigned(lista_de_dependente) then begin
     Exit;
  end;

  // Apaga o conteúdo de todos os controles que dependem deste controle.
  for uA := 0 to Pred(lista_de_dependentes.Count) do begin

    // Vamos pegar a instância do controle baseada no mapeamento do nome do controle.
    nome_controle_filho := lista_de_dependentes.Strings[uA];

    objControle_Temp := f_sgr_bx_a_by_mapa.KeyData[nome_controle_filho];
    if Assigned(objControle_Temp) then begin
       objControle_Temp.Columns.Clear;
    end;
  end;

  // Atualizar o controle filho, somente será atualizado o primeiro controle.

  // Obter as marcações do controle pai.
  ids_selecionados_pai := '';
  if obter_id_de_combinacoes_selecionadas(objControle, ids_selecionados_pai) = false then begin
     Exit;
  end;

  if lista_de_dependentes.Count = 0 then begin
     Exit;
  end;

  // Obter a instância do primeiro controle filho.
  nome_controle_filho := lista_de_dependentes.Strings[0];
  obj_controle_filho := f_sgr_bx_a_by_mapa.KeyData[nome_controle_filho];

  // Atualizar controle filho baseado no id selecionado do controle pai.
  // Por exemplo, se o controle pai é sgr_b1_a_b1, o controle que será atualizado
  // será 'sgr_b1_a_b2'. No controle sgr_b1_a_b2, os campos que será retornados
  // serão: b1_a_b2_id, b1, b2, entretanto, os registros, que somente será retornados
  // deve-se os ids do campo b1_a_b1_id que foram selecionados no controle 'sgr_b1_a_b1'.
  // Na variável abaixo, baseado no exemplo acima ficará assim:
  // nome_do_controle_pai := 'sgr_b1_a_b1', ficará assim:
  // nome_do_campo_pai := 'b1_a_b1_id';
  nome_do_campo_pai := ReplaceText(nome_do_controle_pai, 'sgr_', '') + '_id';
  ids_selecionados_pai := Format('%s in (%s)', [nome_do_campo_pai, ids_selecionados_pai]);

  // Agora, atualizar o controle filho.
  //ulotofacil_b1_a_b15.Carregar_controle_b1_a_b15_novo(obj_controle_filho, ids_selecionados_pai);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by_sem_ter_qt_zero(obj_controle_filho, ids_selecionados_pai);

end;

{
 Cada controle tem zero ou mais controles.
 Quando um controle é atualizado, os controles dependentes são atualizados de acordo.
 A procedure abaixo, amazenará em um map, fazendo um mapeamento de cada controle
 com uma lista de controles que dependem deste.
}
procedure TForm1.Mapear_sgr_bx_a_by_dependentes;
var
  uA, uB, uC: Integer;
  controle_pai, controle_filho: String;
   lista_de_dependentes: TStringList;
begin
  if not Assigned(f_controles_b1_a_b15_pra_ser_atualizado) then begin
     f_controles_b1_a_b15_pra_ser_atualizado := TMap_String_StringList.Create;
  end;

  for uA := 1 to 15 do begin

    for uB := uA to 15 do begin
      controle_pai := Format('sgr_b%d_a_b%d', [uA, uB]);

      // Não iremos apagar a lista.
      lista_de_dependentes := TStringList.Create;
      lista_de_dependentes.Clear;

      // No for abaixo, geramos os controles filhos, ou controles derivados
      // Então, devemos evitar que na lista tem o próprio controle pai.
      for uC := uB + 1 to 15 do begin
        // Pra os controles sgr_b1_a_b1 a sgr_b5_a_b5, limitaremos até a coluna b_10.
        if (uA in [1..5]) and (uC > 10) then begin
           break;
        end;

        controle_filho := Format('sgr_b%d_a_b%d', [uA, uC]);
        lista_de_dependentes.Add(controle_filho);
      end;

      // Mapear o controle pai, pra os controles filhos.
      f_controles_b1_a_b15_pra_ser_atualizado.Add(controle_pai, lista_de_dependentes);

      end;
    end;
end;

procedure TForm1.Carregar_controle_bx_a_by;
begin

  if Selecionar_sgr_bx_a_by = false then begin
    Exit;
  end;

  // No código abaixo, iremos carregar somente os controles que tem 1 bola.
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b1_a_b1);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b2_a_b2);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b3_a_b3);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b4_a_b4);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b5_a_b5);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b6_a_b6);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b7_a_b7);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b8_a_b8);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b9_a_b9);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b10_a_b10);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b11_a_b11);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b12_a_b12);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b13_a_b13);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b14_a_b14);
  ulotofacil_b1_a_b15.Atualizar_sgr_bx_a_by(sgr_b15_a_b15);

  Mapear_sgr_bx_a_by;
  Mapear_cmb_bx_a_by_concurso_inicial_final;
  Mapear_sgr_intervalo_por_concurso_bx_a_by;

  Carregar_cmb_intervalo_por_concurso_bx_a_by;
end;

procedure TForm1.controle_cmb_intervalo_por_concurso_alterou(Sender: TObject);
var
  concurso_inicial, concurso_final , controle_1_indice_selecionado,
    controle_2_indice_selecionado: Integer;
  cmb_controle_1, cmb_controle_2: TComboBox;
  nome_do_controle_2: AnsiString;
  nome_do_controle_1: AnsiString;
  nome_do_controle_3: AnsiString;
  obj_controle_3: TStringGrid;
begin
  cmb_controle_1 := TComboBox(Sender);
  nome_do_controle_1 := cmb_controle_1.Name;
  nome_do_controle_2 := f_cmb_bx_a_by_mapear_inicial_final.KeyData[cmb_controle_1.name];
  cmb_controle_2 := f_cmb_intervalo_por_concurso_bx_a_by.KeyData[nome_do_controle_2];

  controle_1_indice_selecionado := cmb_controle_1.ItemIndex;
  controle_2_indice_selecionado := cmb_controle_2.ItemIndex;

  if (controle_1_indice_selecionado <= -1) or (controle_2_indice_selecionado <= -1) then
  begin
    Exit;
  end;

  // Vamos pegar o concurso inicial e final
  if AnsiContainsText(nome_do_controle_1, 'inicial') then begin
    concurso_inicial := StrToInt(cmb_controle_1.Items[controle_1_indice_selecionado]);
    concurso_final := StrToInt(cmb_controle_2.Items[controle_2_indice_selecionado]);
  end else begin
    concurso_final := StrToInt(cmb_controle_2.Items[controle_2_indice_selecionado]);
    concurso_inicial := StrToInt(cmb_controle_1.Items[controle_1_indice_selecionado]);
  end;

  // Obtém o nome do controle baseado no controle que alterou.
  nome_do_controle_3 := ReplaceText(nome_do_controle_1, 'cmb_intervalo_por_concurso_inicial_', 'sgr_intervalo_por_concurso_');
  nome_do_controle_3 := ReplaceText(nome_do_controle_3, 'cmb_intervalo_por_concurso_final_', 'sgr_intervalo_por_concurso_');

  // Obtém a instãncia do controle baseado no nome do controle.
  //obj_controle_3 := f_sgr_bx_a_by_mapa.KeyData[nome_do_controle_3];
  obj_controle_3 := f_sgr_intervalo_por_concurso_bx_a_by.KeyData[nome_do_controle_3];

  //Carregar_controle_b1_a_b15_por_intervalo_concurso(obj_controle_3, concurso_inicial, concurso_final);
  atualizar_sgr_bx_a_by_por_intervalo_de_concurso(obj_controle_3, concurso_inicial, concurso_final);
end;

{
 Carrega todos os controles:
 cmb_intervalo_por_concurso_inicial_bx_a_by e
 cmb_intervalo_por_concurso_final_bx_a_by,
 onde x e y representa números, e x >= y.
}
procedure TForm1.Carregar_cmb_intervalo_por_concurso_bx_a_by;
var
  lista_de_concursos: TStringList;
  controle_atual: TComboBox;
  uA: Integer;
begin
  lista_de_concursos := TStringList.Create;

  if not Obter_todos_os_concursos(lista_de_concursos) then begin
    Exit;
  end;

  // Agora, atualiza todos os controles.
  for uA := 0 to Pred(f_cmb_bx_a_by_lista.Count) do begin
    controle_atual := f_cmb_bx_a_by_lista.Items[uA];
    Atualizar_cmb_intervalo_por_concurso_bx_a_by(controle_atual, lista_de_concursos);

    if AnsiContainsText(controle_atual.name, 'inicial') then begin
      if controle_atual.Items.Count > 0 then begin;
         controle_atual.ItemIndex := 1
      end;
    end else begin
      controle_atual.ItemIndex := Pred(controle_atual.Items.Count);
    end;
  end;



end;

procedure TForm1.Carregar_controle_bolas_na_mesma_coluna;
begin
  ulotofacil_bolas_na_mesma_coluna.Carregar_controle_bolas_na_mesma_coluna(sgrBolas_na_mesma_coluna);
end;

procedure TForm1.CarregarControleLotofacilSoma;
var
  sqlRegistros: TSqlQuery;
  uLinha, qt_registros: integer;
begin
  if dmLotofacil = nil then
    dmLotofacil := tDmLotofacil.Create(Self);

  sqlRegistros := TSqlQuery.Create(Self);
  sqlRegistros.UniDirectional := False;
  sqlRegistros.Close;
  sqlRegistros.DataBase := dmLotofacil.pgLTK;
  sqlRegistros.SQL.Clear;
  sqlRegistros.Sql.Add('Select bola_soma, ltf_qt_vezes, res_qt_vezes');
  sqlRegistros.Sql.Add('from lotofacil.v_lotofacil_resultado_soma');
  sqlRegistros.Sql.Add('where ltf_qt = 15');
  sqlRegistros.Sql.Add('order by res_qt_vezes desc, ltf_qt_vezes desc');
  sqlRegistros.Open;

  if sqlRegistros.EOF then
  begin
    sgrLotofacilSoma.Columns.Clear;
    sgrLotofacilSoma.Columns.Add;
    sgrLotofacilSoma.RowCount := 1;
    sgrLotofacilSoma.Cells[0, 0] := 'Nenhum registro localizado';
    sgrLotofacilSoma.AutoSizeColumns;
    exit;
  end;

  // Pega a quantidade de registros.
  sqlRegistros.First;
  sqlRegistros.Last;
  qt_registros := sqlRegistros.RecordCount;

  ConfigurarControleLotofacilSoma;
  sgrLotofacilSoma.RowCount := qt_registros + 1;

  uLinha := 1;
  sqlRegistros.First;
  while (not sqlRegistros.EOF) and (qt_registros > 0) do
  begin
    sgrLotofacilSoma.Cells[0, uLinha] := sqlRegistros.FieldByName('bola_soma').AsString;
    sgrLotofacilSoma.Cells[1, uLinha] :=
      sqlRegistros.FieldByName('ltf_qt_vezes').AsString;
    sgrLotofacilSoma.Cells[2, uLinha] :=
      sqlRegistros.FieldByName('res_qt_vezes').AsString;
    sgrLotofacilSoma.Cells[3, uLinha] := '0';

    Dec(qt_registros);
    sqlRegistros.Next;
    Inc(uLinha);
  end;

  sqlRegistros.Close;

  sgrLotofacilSoma.AutoSizeColumns;

  dmLotofacil.Free;
  dmLotofacil := nil;

end;

procedure TForm1.ConfigurarControleLotofacilSoma;
const
  campos: array[0..3] of string = ('bola_soma', 'ltf_qt_vezes', 'res_qt', 'Marcar');
var
  coluna_atual: TGridColumn;
  ultimo_indice, uA: integer;
begin
  ultimo_indice := High(campos);

  sgrLotofacilSoma.Columns.Clear;
  for uA := 0 to ultimo_indice do
  begin
    coluna_atual := sgrLotofacilSoma.Columns.Add;
    coluna_atual.Title.Caption := campos[uA];
    coluna_atual.Title.Alignment := TAlignment.taCenter;
  end;
  // A última coluna, será um checkbox, pois iremos marcar.
  sgrLotofacilSoma.Columns[ultimo_indice].ButtonStyle := cbsCheckboxColumn;

  // A primeira linha terá o título.
  sgrLotofacilSoma.FixedRows := 1;

end;

//procedure TForm1.CarregarControleDiferenca_qt_alt_2(strWhere: string);
//var
//  strSql: TStringList;
//  sqlLotofacil: TSqlQuery;
//  uLinha, qt_registros: integer;
//begin
//  if strWhere = '' then
//  begin
//    sgrDiferenca_qt_alt_2.Columns.Clear;
//    exit;
//  end;
//
//  if dmLotofacil = nil then
//    dmLotofacil := TdmLotofacil.Create(Self);
//
//  strSql := TStringList.Create;
//  strSql.Add('Select qt_alt, qt_dif_1, qt_dif_2, qt_cmb, ltf_qt, res_qt');
//  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_alt_2');
//  strSql.Add('where ' + strWhere);
//  strSql.Add('order by res_qt desc, ltf_qt desc');
//
//  sqlLotofacil := dmLotofacil.sqlLotofacil;
//  sqlLotofacil.Close;
//  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
//  sqlLotofacil.SQL.Text := strSql.Text;
//  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
//  // a propriedade RecordCount o valor 1.
//  sqlLotofacil.UniDirectional := False;
//  sqlLotofacil.Prepare;
//  sqlLotofacil.Open;
//
//  // TODO: Alterei o código abaixo, pra aparecer o nome do controle.
//  //ConfigurarControleDiferenca_qt_alt_2;
//  ConfigurarControleDiferenca_qt_alt_2(sgrDiferenca_qt_alt_2);
//
//  qt_registros := 0;
//  sqlLotofacil.First;
//  while not sqlLotofacil.EOF do
//  begin
//    Inc(qt_Registros);
//    sqlLotofacil.Next;
//  end;
//
//  if qt_Registros = 0 then
//  begin
//    sgrDiferenca_qt_alt_2.Columns.Clear;
//    sgrDiferenca_qt_alt_2.Columns.Add;
//    sgrDiferenca_qt_alt_2.FixedRows := 0;
//    sgrDiferenca_qt_alt_2.RowCount := 1;
//    sgrDiferenca_qt_alt_2.Cells[0, 0] := 'Erro, Nao há registros';
//    sgrDiferenca_qt_alt_2.AutoSizeColumns;
//    Exit;
//  end;
//
//  // Define o número de linhas, conforme a quantidade de registro
//  // Haverá uma linha mais por causa do título.
//  sgrDiferenca_qt_alt_2.RowCount := qt_Registros + 1;
//
//  // Percorrer registro
//  uLinha := 1;
//  sqlLotofacil.First;
//  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
//  begin
//    sgrDiferenca_qt_alt_2.Cells[0, uLinha] :=
//      IntToStr(sqlLotofacil.FieldByName('qt_alt').AsInteger);
//    sgrDiferenca_qt_alt_2.Cells[1, uLinha] :=
//      IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
//    sgrDiferenca_qt_alt_2.Cells[2, uLinha] :=
//      sqlLotofacil.FieldByName('qt_dif_2').AsString;
//    sgrDiferenca_qt_alt_2.Cells[3, uLinha] :=
//      sqlLotofacil.FieldByName('qt_cmb').AsString;
//    sgrDiferenca_qt_alt_2.Cells[4, uLinha] :=
//      sqlLotofacil.FieldByName('ltf_qt').AsString;
//    sgrDiferenca_qt_alt_2.Cells[5, uLinha] :=
//      IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
//    sgrDiferenca_qt_alt_2.Cells[6, uLinha] := '0';
//
//    Inc(uLinha);
//    Dec(qt_Registros);
//
//    sqlLotofacil.Next;
//  end;
//  sqlLotofacil.Close;
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//
//  sgrDiferenca_qt_alt_2.AutoSizeColumns;
//end;

// TODO: Verificar se procedure irá funcionar corretamente.
//procedure TForm1.ConfigurarControleDiferenca_qt_alt_2;
//var
//  qtColunas, indice_ultima_coluna, uA: integer;
//  campos_do_controle: array[0..6] of
//  string = ('qt_alt', 'qt_dif_1',
//    'qt_dif_2', 'qt_cmb',
//    'ltf_qt', 'res_qt',
//    'Marcar');
//  coluna_atual: TGridColumn;
//begin
//  qtColunas := Length(campos_do_controle);
//  indice_ultima_coluna := High(campos_do_controle);
//
//  // Cria os campos do controle.
//  sgrDiferenca_qt_alt_2.Columns.Clear;
//  for uA := 0 to indice_ultima_coluna do
//  begin
//    coluna_atual := sgrDiferenca_qt_alt_2.Columns.Add;
//    coluna_atual.title.Alignment := TAlignment.taCenter;
//    coluna_atual.Alignment := TAlignment.taCenter;
//    coluna_atual.title.Caption := campos_do_controle[uA];
//    sgrDiferenca_qt_alt_2.cells[uA, 0] := campos_do_controle[uA];
//  end;
//  sgrDiferenca_qt_alt_2.RowCount := 1;
//
//  // Ocultar a coluna 3, pois, ela é uma combinação dos campos 'qt_alt' e 'qt_dif_1' e 'qt_dif_2'
//  sgrDiferenca_qt_alt_2.Columns[3].Visible := False;
//
//  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
//  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
//  sgrDiferenca_qt_alt_2.Columns[indice_ultima_coluna].ButtonStyle :=
//    TColumnButtonStyle.cbsCheckboxColumn;
//
//  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
//  sgrDiferenca_qt_alt_2.FixedCols := 0;
//  sgrDiferenca_qt_alt_2.FixedRows := 1;
//end;

// TODO: Procedure será movida pra o arquivo 'ulotofacil_diferenca_entre_bolas'
//procedure TForm1.CarregarControleDiferenca_qt_alt_1(strWhere: string);
//var
//  strSql: TStringList;
//  sqlLotofacil: TSqlQuery;
//  uLinha, qt_registros: integer;
//begin
//  if strWhere = '' then
//  begin
//    sgrDiferenca_qt_alt_1.Columns.Clear;
//    exit;
//  end;
//
//  if dmLotofacil = nil then
//    dmLotofacil := TdmLotofacil.Create(Self);
//
//  strSql := TStringList.Create;
//  strSql.Add('Select qt_alt, qt_dif_1, qt_cmb, ltf_qt, res_qt');
//  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_alt_1');
//  strSql.Add('where ' + strWhere);
//  strSql.Add('order by res_qt desc, ltf_qt desc');
//
//  sqlLotofacil := dmLotofacil.sqlLotofacil;
//  sqlLotofacil.Close;
//  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
//  sqlLotofacil.SQL.Text := strSql.Text;
//  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
//  // a propriedade RecordCount o valor 1.
//  sqlLotofacil.UniDirectional := False;
//  sqlLotofacil.Prepare;
//  sqlLotofacil.Open;
//
//  // Todo: Alterar controle pra ser chamado de outro arquivo.
//  //ConfigurarControleDiferenca_qt_alt_1;
//  ConfigurarControleDiferenca_qt_alt_1(sgrDiferenca_qt_alt_1);
//
//  qt_registros := 0;
//  sqlLotofacil.First;
//  while not sqlLotofacil.EOF do
//  begin
//    Inc(qt_Registros);
//    sqlLotofacil.Next;
//  end;
//
//  if qt_Registros = 0 then
//  begin
//    sgrDiferenca_qt_alt_1.Columns.Clear;
//    sgrDiferenca_qt_alt_1.Columns.Add;
//    sgrDiferenca_qt_alt_1.FixedRows := 0;
//    sgrDiferenca_qt_alt_1.RowCount := 1;
//    sgrDiferenca_qt_alt_1.Cells[0, 0] := 'Erro, Nao há registros';
//    sgrDiferenca_qt_alt_1.AutoSizeColumns;
//    Exit;
//  end;
//
//  // Define o número de linhas, conforme a quantidade de registro
//  // Haverá uma linha mais por causa do título.
//  sgrDiferenca_qt_alt_1.RowCount := qt_Registros + 1;
//
//  // Percorrer registro
//  uLinha := 1;
//  sqlLotofacil.First;
//  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
//  begin
//    sgrDiferenca_qt_alt_1.Cells[0, uLinha] :=
//      IntToStr(sqlLotofacil.FieldByName('qt_alt').AsInteger);
//    sgrDiferenca_qt_alt_1.Cells[1, uLinha] :=
//      IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
//    sgrDiferenca_qt_alt_1.Cells[2, uLinha] :=
//      sqlLotofacil.FieldByName('qt_cmb').AsString;
//    sgrDiferenca_qt_alt_1.Cells[3, uLinha] :=
//      sqlLotofacil.FieldByName('ltf_qt').AsString;
//    sgrDiferenca_qt_alt_1.Cells[4, uLinha] :=
//      IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
//    sgrDiferenca_qt_alt_1.Cells[5, uLinha] := '0';
//
//    Inc(uLinha);
//    Dec(qt_Registros);
//
//    sqlLotofacil.Next;
//  end;
//  sqlLotofacil.Close;
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//
//  sgrDiferenca_qt_alt_1.AutoSizeColumns;
//end;

//TODO: Comentar código após realizar os testes.
//procedure TForm1.ConfigurarControleDiferenca_qt_alt_1;
//var
//  qtColunas, indice_ultima_coluna, uA: integer;
//  campos_do_controle: array[0..5] of
//  string = ('qt_alt', 'qt_dif_1',
//    'qt_cmb', 'ltf_qt',
//    'res_qt', 'Marcar');
//  coluna_atual: TGridColumn;
//begin
//
//  sgrDiferenca_qt_alt_1.Columns.Clear;
//  indice_ultima_coluna := High(campos_do_controle);
//  for uA := 0 to indice_ultima_Coluna do
//  begin
//    coluna_atual := sgrDiferenca_qt_alt_1.Columns.Add;
//    coluna_atual.title.Alignment := TAlignment.taCenter;
//    coluna_atual.Alignment := TAlignment.taCenter;
//    coluna_atual.title.Caption := campos_do_controle[uA];
//    sgrDiferenca_qt_alt_1.RowCount := 1;
//    sgrDiferenca_qt_alt_1.Cells[uA, 0] := campos_do_controle[uA];
//  end;
//  // Ocultar a coluna 2, pois, ela é uma combinação dos campos 'qt_alt' e 'qt_dif_1'
//  sgrDiferenca_qt_alt_1.Columns[2].Visible := False;
//
//  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
//  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
//  sgrDiferenca_qt_alt_1.Columns[indice_ultima_coluna].ButtonStyle :=
//    TColumnButtonStyle.cbsCheckboxColumn;
//
//  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
//  sgrDiferenca_qt_alt_1.FixedCols := 0;
//  sgrDiferenca_qt_alt_1.FixedRows := 1;
//end;
//

// TODO: Esta procedure foi substituída por outra no arquivo 'ulotofacil_diferenca_entre_bolas'.
//procedure TForm1.CarregarControleDiferenca_qt_alt;
//var
//  strSql: TStringList;
//  sqlLotofacil: TSqlQuery;
//  uLinha, qt_registros: integer;
//begin
//  if dmLotofacil = nil then
//    dmLotofacil := TdmLotofacil.Create(Self);
//
//  strSql := TStringList.Create;
//  strSql.Add('Select qt_alt, ltf_qt, res_qt');
//  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_alt');
//  strSql.Add('order by res_qt desc, ltf_qt desc');
//
//  sqlLotofacil := dmLotofacil.sqlLotofacil;
//  sqlLotofacil.Close;
//  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
//  sqlLotofacil.SQL.Text := strSql.Text;
//  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
//  // a propriedade RecordCount o valor 1.
//  sqlLotofacil.UniDirectional := False;
//  sqlLotofacil.Prepare;
//  sqlLotofacil.Open;
//
//  //ConfigurarControleDiferenca_qt_alt;
//  ConfigurarControleDiferenca_qt_alt(sgrDiferenca_qt_alt);
//
//  sqlLotofacil.First;
//  sqlLotofacil.Last;
//  qt_registros := sqlLotofacil.RecordCount;
//
//  if qt_Registros = 0 then
//  begin
//    sgrDiferenca_qt_alt.Columns.Clear;
//    sgrDiferenca_qt_alt.Columns.Add;
//    sgrDiferenca_qt_alt.FixedRows := 0;
//    sgrDiferenca_qt_alt.RowCount := 1;
//    sgrDiferenca_qt_alt.Cells[0, 0] := 'Erro, Nao há registros';
//    sgrDiferenca_qt_alt.AutoSizeColumns;
//    Exit;
//  end;
//
//  // Define o número de linhas, conforme a quantidade de registro
//  // Haverá uma linha mais por causa do título.
//  sgrDiferenca_qt_alt.RowCount := qt_Registros + 1;
//
//  // Percorrer registro
//  uLinha := 1;
//  sqlLotofacil.First;
//  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
//  begin
//    sgrDiferenca_qt_alt.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_alt').AsInteger);
//    sgrDiferenca_qt_alt.Cells[1, uLinha] := sqlLotofacil.FieldByName('ltf_qt').AsString;
//    sgrDiferenca_qt_alt.Cells[2, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
//    sgrDiferenca_qt_alt.Cells[3, uLinha] := '0';
//
//    Inc(uLinha);
//    Dec(qt_Registros);
//
//    sqlLotofacil.Next;
//  end;
//  sqlLotofacil.Close;
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//
//  sgrDiferenca_qt_alt.AutoSizeColumns;
//end;

//TODO: Procedure ConfigurarControleDiferenca_qt_alt será deletada.
//procedure TForm1.ConfigurarControleDiferenca_qt_alt;
//var
//  qtColunas, indice_ultima_coluna, uA: integer;
//  campos_do_controle: array[0..3] of
//  string = ('qt_alt', 'ltf_qt',
//    'res_qt', 'Marcar');
//begin
//  qtColunas := Length(campos_do_controle);
//
//  // Cria os campos do controle.
//  sgrDiferenca_qt_alt.Columns.Clear;
//  while qtColunas > 0 do
//  begin
//    sgrDiferenca_qt_alt.Columns.Add;
//    Dec(qtColunas);
//  end;
//  sgrDiferenca_qt_alt.RowCount := 1;
//
//  indice_ultima_coluna := High(campos_do_controle);
//
//  for uA := 0 to indice_ultima_Coluna do
//  begin
//    sgrDiferenca_qt_alt.Columns[uA].title.Alignment := TAlignment.taCenter;
//    sgrDiferenca_qt_alt.Columns[uA].Alignment := TAlignment.taCenter;
//    sgrDiferenca_qt_alt.Columns[uA].title.Caption := campos_do_controle[uA];
//    sgrDiferenca_qt_alt.Cells[uA, 0] := campos_do_controle[uA];
//  end;
//
//  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
//  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
//  sgrDiferenca_qt_alt.Columns[indice_ultima_coluna].ButtonStyle :=
//    TColumnButtonStyle.cbsCheckboxColumn;
//
//  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
//  sgrDiferenca_qt_alt.FixedCols := 0;
//  sgrDiferenca_qt_alt.FixedRows := 1;
//
//end;

procedure TForm1.CarregarDiferencaEntreBolas;
begin
  CarregarControleDiferencaEntreBolas_qt_1(sgrDiferenca_qt_1);
end;

procedure TForm1.Controle_Diferenca_entre_Bolas_alterou(objControle: TStringGrid);
var
  ultima_coluna: integer;
  ultima_linha, linha: integer;
  strWhere: string;
begin
  ultima_linha := objControle.RowCount - 1;
  ultima_coluna := objControle.ColCount - 1;

  // O controle 'sgrDiferenca_qt_1_qt_2' depende do controle
  // sgrDiferenca_qt_1, então, se houver alteração no controle
  // sgrDiferenca_qt_1, devemos apagar os dados do controle
  // sgrDiferenca_qt_1_qt_2 e em seguida popular os dados
  // conforme as marcações realizadas no controle 'sgrDiferenca_qt_1'.
  if objControle = sgrDiferenca_Qt_1 then
  begin
    sgrDiferenca_Qt_1_Qt_2.Columns.Clear;

    if ultima_linha = 0 then
    begin
      exit;
    end;

    strWhere := '';
    for linha := 1 to ultima_linha do
    begin
      if objControle.Cells[ultima_coluna, linha] = '1' then
      begin
        if strWhere <> '' then
        begin
          strWhere := strWhere + ',';
        end;
        strWhere := strWhere + objControle.Cells[0, linha];
      end;
    end;
    CarregarControleDiferencaEntreBolas_Qt_1_Qt_2(sgrDiferenca_Qt_1_Qt_2, strWhere);
    exit;
  end;

  // Os controles 'sgrDiferenca_qt_alt_1' e 'sgrDiferenca_qt_alt_2'
  // depende do controle 'sgrDiferenca_qt_alt', então, se houver alteração
  // neste controle, devemos apagar os controles 'sgrDiferenca_qt_alt_1' e
  // 'sgrDiferenca_qt_alt_2', e em seguida atualizar tais controles
  // conforme as marcações realizadas no controle 'sgrDiferenca_qt_alt_1'.
  if objControle = sgrDiferenca_qt_alt then
  begin
    sgrDiferenca_qt_alt_1.Columns.Clear;
    sgrDiferenca_qt_alt_2.Columns.Clear;

    if ultima_linha = 0 then
    begin
      exit;
    end;

    strWhere := '';
    for linha := 1 to ultima_linha do
    begin
      if objControle.Cells[ultima_coluna, linha] = '1' then
      begin
        if strWhere <> '' then
        begin
          strWhere := strWhere + ',';
        end;
        // Neste caso, iremos pegar a coluna qt_alt e interseparar com vírgula.
        strWhere := strWhere + objControle.Cells[0, linha];
      end;
    end;
    if strWhere <> '' then
    begin
      strWhere := 'qt_alt in (' + strWhere + ') ';
    end;
    CarregarControleDiferenca_qt_alt_1(sgrDiferenca_qt_alt_1, strWhere);
    exit;
  end;

  if objControle = sgrDiferenca_qt_alt_1 then
  begin
    sgrDiferenca_qt_alt_2.Columns.Clear;

    if ultima_linha = 0 then
    begin
      exit;
    end;

    strWhere := '';
    for linha := 1 to ultima_linha do
    begin
      if objControle.Cells[ultima_coluna, linha] = '1' then
      begin
        if strWhere <> '' then
        begin
          strWhere := strWhere + ',';
        end;
        // Neste caso, iremos pegar a coluna qt_alt e qt_dif_1, interseparadas
        // pelo caractere '_', que está na coluna 2, no campo 'qt_cmb'
        strWhere := strWhere + QuotedStr(objControle.Cells[2, linha]);
      end;
    end;
    if strWhere <> '' then
    begin
      strWhere := 'qt_alt || ''_'' || qt_dif_1 in (' + strWhere + ') ';
    end;
    CarregarControleDiferenca_qt_alt_2(sgrDiferenca_qt_alt_2, strWhere);
    exit;
  end;

end;

//procedure TForm1.ConfigurarControleDiferencaEntreBolas_qt_1_qt_2;
//var
//  qtColunas, indice_ultima_coluna, uA: integer;
//  campos_do_controle: array[0..5] of
//  string = ('qt_dif_1', 'qt_dif_2',
//    'qt_dif_cmb', 'ltf_qt_vezes',
//    'res_qt', 'Marcar');
//begin
//  qtColunas := Length(campos_do_controle);
//
//  // Cria os campos do controle.
//  sgrDiferenca_Qt_1_Qt_2.Columns.Clear;
//  while qtColunas > 0 do
//  begin
//    sgrDiferenca_Qt_1_Qt_2.Columns.Add;
//    Dec(qtColunas);
//  end;
//  sgrDiferenca_Qt_1_Qt_2.RowCount := 1;
//
//  indice_ultima_coluna := High(campos_do_controle);
//
//  for uA := 0 to indice_ultima_Coluna do
//  begin
//    sgrDiferenca_Qt_1_Qt_2.Columns[uA].title.Alignment := TAlignment.taCenter;
//    sgrDiferenca_Qt_1_Qt_2.Columns[uA].Alignment := TAlignment.taCenter;
//    sgrDiferenca_Qt_1_Qt_2.Columns[uA].title.Caption := campos_do_controle[uA];
//    sgrDiferenca_Qt_1_Qt_2.Cells[uA, 0] := campos_do_controle[uA];
//  end;
//  // Ocultar a coluna qt_cmb pois esta coluna é utilizada pra concatenar pra
//  // concatenar os campos qt_1 e qt_2.
//  sgrDiferenca_Qt_1_Qt_2.Columns[2].Visible := False;
//
//  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
//  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
//  sgrDiferenca_Qt_1_Qt_2.Columns[indice_ultima_coluna].ButtonStyle :=
//    TColumnButtonStyle.cbsCheckboxColumn;
//
//  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
//  sgrDiferenca_Qt_1_Qt_2.FixedCols := 0;
//  sgrDiferenca_Qt_1_Qt_2.FixedRows := 1;
//
//end;

// TODO: Isto será movido pra outro arquivo.
//procedure TForm1.CarregarControleDiferencaEntreBolas_Qt_1_Qt_2(strWhere: string);
//var
//  strSql: TStringList;
//  sqlLotofacil: TSqlQuery;
//  uLinha, qt_registros: integer;
//begin
//  if Trim(strWhere) = '' then
//  begin
//    sgrDiferenca_Qt_1_Qt_2.Clear;
//    Exit;
//  end;
//
//  if dmLotofacil = nil then
//    dmLotofacil := TdmLotofacil.Create(Self);
//
//  strSql := TStringList.Create;
//  strSql.Add('Select qt_dif_1, qt_dif_2, qt_dif_cmb, ltf_qt_vezes, res_qt');
//  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_Qt_dif_1_a_Qt_dif_2');
//  strSql.Add('where qt_dif_1');
//  strSql.Add('in (' + strWhere + ')');
//  strSql.Add('order by res_qt desc, ltf_qt_vezes desc');
//  //Writeln('sql: ', strSql.Text);
//
//  sqlLotofacil := dmLotofacil.sqlLotofacil;
//  sqlLotofacil.Close;
//  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
//  sqlLotofacil.SQL.Text := strSql.Text;
//  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
//  // a propriedade RecordCount o valor 1.
//  sqlLotofacil.UniDirectional := False;
//  sqlLotofacil.Prepare;
//  sqlLotofacil.Open;
//
//  //ConfigurarControleDiferencaEntreBolas_Qt_1_Qt_2;
//  ConfigurarControleDiferencaEntreBolas_qt_1_qt_2(sgrDiferenca_Qt_1_Qt_2);
//
//  qt_registros := 0;
//  sqlLotofacil.First;
//  while not sqlLotofacil.EOF do
//  begin
//    Inc(qt_Registros);
//    sqlLotofacil.Next;
//  end;
//
//  if qt_Registros = 0 then
//  begin
//    sgrDiferenca_Qt_1_Qt_2.Columns.Clear;
//    sgrDiferenca_Qt_1_Qt_2.Columns.Add;
//    sgrDiferenca_Qt_1_Qt_2.FixedRows := 0;
//    sgrDiferenca_Qt_1_Qt_2.RowCount := 1;
//    sgrDiferenca_Qt_1_Qt_2.Cells[0, 0] := 'Erro, Nao há registros';
//    sgrDiferenca_Qt_1_Qt_2.AutoSizeColumns;
//    Exit;
//  end;
//
//  // Define o número de linhas, conforme a quantidade de registro
//  // Haverá uma linha mais por causa do título.
//  sgrDiferenca_Qt_1_Qt_2.RowCount := qt_Registros + 1;
//
//  // Percorrer registro
//  uLinha := 1;
//  sqlLotofacil.First;
//  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
//  begin
//    sgrDiferenca_Qt_1_Qt_2.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
//    sgrDiferenca_Qt_1_Qt_2.Cells[1, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_2').AsInteger);
//    sgrDiferenca_Qt_1_Qt_2.Cells[2, uLinha] := sqlLotofacil.FieldByName('qt_dif_cmb').AsString;
//    sgrDiferenca_Qt_1_Qt_2.Cells[3, uLinha] := sqlLotofacil.FieldByName('ltf_qt_vezes').AsString;
//    sgrDiferenca_Qt_1_Qt_2.Cells[4, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
//    sgrDiferenca_Qt_1_Qt_2.Cells[5, uLinha] := '0';
//
//    Inc(uLinha);
//    Dec(qt_Registros);
//
//    sqlLotofacil.Next;
//  end;
//
//  // Oculta a coluna qt_dif_cmb
//  sgrDiferenca_Qt_1_Qt_2.Columns[2].Visible := False;
//
//  sqlLotofacil.Close;
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//
//  sgrDiferenca_Qt_1_Qt_2.AutoSizeColumns;
//end;

//TODO: Esta procedure será movida pra o arquivo 'uLotofacil_diferenca_entre_bolas'.
//procedure TForm1.CarregarControleDiferencaEntreBolas_qt_1;
//var
//  strSql: TStringList;
//  sqlLotofacil: TSqlQuery;
//  uLinha, qt_registros: integer;
//begin
//  if dmLotofacil = nil then
//    dmLotofacil := TdmLotofacil.Create(Self);
//
//  strSql := TStringList.Create;
//  strSql.Add('Select qt_dif_1, ltf_qt_vezes, res_qt');
//  strSql.Add('from lotofacil.v_lotofacil_resultado_diferenca_qt_dif_1');
//  strSql.Add('order by res_qt desc, ltf_qt_vezes desc');
//
//  sqlLotofacil := dmLotofacil.sqlLotofacil;
//  sqlLotofacil.Close;
//  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
//  sqlLotofacil.SQL.Text := strSql.Text;
//  // Na linha abaixo, se uniDirectional, ficar true, sempre vai retornar
//  // a propriedade RecordCount o valor 1.
//  sqlLotofacil.UniDirectional := False;
//  sqlLotofacil.Prepare;
//  sqlLotofacil.Open;
//
//  // ConfigurarControleDiferencaEntreBolas_qt_1;
//  ConfigurarControleDiferencaEntreBolas_qt_1(sgrDiferenca_qt_1);
//
//  qt_registros := 0;
//  sqlLotofacil.First;
//  while not sqlLotofacil.EOF do
//  begin
//    Inc(qt_Registros);
//    sqlLotofacil.Next;
//  end;
//
//  if qt_Registros = 0 then
//  begin
//    sgrDiferenca_Qt_1.Columns.Clear;
//    sgrDiferenca_Qt_1.Columns.Add;
//    sgrDiferenca_Qt_1.FixedRows := 0;
//    sgrDiferenca_Qt_1.RowCount := 1;
//    sgrDiferenca_Qt_1.Cells[0, 0] := 'Erro, Nao há registros';
//    sgrDiferenca_Qt_1.AutoSizeColumns;
//    Exit;
//  end;
//
//  // Define o número de linhas, conforme a quantidade de registro
//  // Haverá uma linha mais por causa do título.
//  sgrDiferenca_Qt_1.RowCount := qt_Registros + 1;
//
//  // Percorrer registro
//  uLinha := 1;
//  sqlLotofacil.First;
//  while (not sqlLotofacil.EOF) and (qt_Registros > 0) do
//  begin
//    sgrDiferenca_Qt_1.Cells[0, uLinha] := IntToStr(sqlLotofacil.FieldByName('qt_dif_1').AsInteger);
//    sgrDiferenca_Qt_1.Cells[1, uLinha] := sqlLotofacil.FieldByName('ltf_qt_vezes').AsString;
//    sgrDiferenca_Qt_1.Cells[2, uLinha] := IntToStr(sqlLotofacil.FieldByName('res_qt').AsInteger);
//    sgrDiferenca_Qt_1.Cells[3, uLinha] := '0';
//
//    Inc(uLinha);
//    Dec(qt_Registros);
//
//    sqlLotofacil.Next;
//  end;
//  sqlLotofacil.Close;
//  dmLotofacil.Free;
//  dmLotofacil := nil;
//
//  sgrDiferenca_Qt_1.AutoSizeColumns;
//end;


// TODO: Comentar este código após os testes.
//procedure TForm1.ConfigurarControleDiferencaEntreBolas_qt_1;
//var
//  qtColunas, indice_ultima_coluna, uA: integer;
//  campos_do_controle: array[0..3] of
//  string = ('qt_dif_1', 'ltf_qt_vezes',
//    'res_qt', 'Marcar');
//begin
//  qtColunas := Length(campos_do_controle);
//
//  // Cria os campos do controle.
//  sgrDiferenca_Qt_1.Columns.Clear;
//  while qtColunas > 0 do
//  begin
//    sgrDiferenca_Qt_1.Columns.Add;
//    Dec(qtColunas);
//  end;
//  sgrDiferenca_Qt_1.RowCount := 1;
//
//  indice_ultima_coluna := High(campos_do_controle);
//
//  for uA := 0 to indice_ultima_Coluna do
//  begin
//    sgrDiferenca_Qt_1.Columns[uA].title.Alignment := TAlignment.taCenter;
//    sgrDiferenca_Qt_1.Columns[uA].Alignment := TAlignment.taCenter;
//    sgrDiferenca_Qt_1.Columns[uA].title.Caption := campos_do_controle[uA];
//    sgrDiferenca_Qt_1.Cells[uA, 0] := campos_do_controle[uA];
//  end;
//
//  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
//  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
//  sgrDiferenca_Qt_1.Columns[indice_ultima_coluna].ButtonStyle :=
//    TColumnButtonStyle.cbsCheckboxColumn;
//
//  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
//  sgrDiferenca_Qt_1.FixedCols := 0;
//  sgrDiferenca_Qt_1.FixedRows := 1;
//
//end;

{
 Carrega os controles que exibe a frequência por concurso.
 O concurso será escolhido conforme o número do concurso escolhido pelo usuário.
}
procedure TForm1.CarregarFrequenciaPorConcurso(objControle: TStringGrid);
var
  strSql: TStringList;
  sqlLotofacil: TSqlQuery;
  concurso: ansistring;
  qtRegistros, uLinha: integer;
  bola_numero, indice_selecionado: integer;
begin

  if objControle = sgrFrequencia_Bolas_Sair_Nao_Sair then
  begin
    indice_selecionado := cmbConcursoFrequenciaSair.ItemIndex;
    if indice_selecionado < 0 then
    begin
      exit;
    end;
    concurso := cmbConcursoFrequenciaSair.Items[indice_selecionado];
  end
  else if objControle = sgrFrequenciaBolasNaoSair then
  begin
    indice_selecionado := cmbConcursoFrequenciaNaoSair.ItemIndex;
    if indice_selecionado < 0 then
    begin
      exit;
    end;
    concurso := cmbConcursoFrequenciaNaoSair.Items[indice_selecionado];
  end;

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  strSql := TStringList.Create;
  strSql.Add(
    'Select bola, frequencia_status, frequencia from lotofacil.v_lotofacil_resultado_bolas_frequencia');
  strSql.Add('where concurso = ' + concurso);
  strSql.Add('order by frequencia asc, bola asc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;

  try
    sqlLotofacil.Open;
  except
    On exc: Exception do
    begin
      strErro := exc.Message;
      exit;
    end;
  end;

  ConfigurarFrequenciaPorConcurso(objControle);

  try
    qtRegistros := 0;
    sqlLotofacil.First;
    sqlLotofacil.Last;
    qtRegistros := sqlLotofacil.RecordCount;

    if qtRegistros <> 25 then
    begin
      objControle.Columns.Clear;
      objControle.Columns.Add;
      objControle.FixedRows := 0;
      objControle.RowCount := 1;

      if qtRegistros = 0 then
      begin
        objControle.Cells[0, 0] := 'Erro, não há registros, atualize a frequencia.';
      end
      else
      begin
        objControle.Cells[0, 0] := 'Erro, não há 25 registros, atualize a frequencia.';
      end;
      objControle.AutoSizeColumns;
      exit;
    end;

    uLinha := 1;
    sqlLotofacil.First;
    objControle.RowCount := qtRegistros + 1;
    while not sqlLotofacil.EOF do
    begin
      bola_numero := sqlLotofacil.FieldByName('bola').AsInteger;

      objControle.Cells[0, uLinha] := IntToStr(bola_numero);
      objControle.Cells[1, uLinha] :=
        sqlLotofacil.FieldByName('frequencia_status').AsString;
      objControle.Cells[2, uLinha] :=
        IntToStr(sqlLotofacil.FieldByName('frequencia').AsInteger);
      objControle.Cells[3, uLinha] := IntToStr(concurso_frequencia_sair[bola_numero]);
      objControle.Cells[4, uLinha] :=
        IntToStr(concurso_frequencia_nao_sair[bola_numero]);

      Inc(uLinha);

      sqlLotofacil.Next;
    end;
    sqlLotofacil.Close;
  except
    ON exc: Exception do
    begin
      strErro := Exc.Message;
      Exit;
    end
  end;

  objControle.AutoSizeColumns;

  AtualizarControleFrequenciaMinimoMaximo;

end;

procedure TForm1.ConfigurarFrequenciaPorConcurso(objControle: TStringGrid);
var
  qtColunas, indice_ultima_coluna, uA: integer;
  frequencia_bolas_campo: array[0..4] of
  string = ('Bola', 'Frequencia_Status',
    'Freq.', 'Deve_Sair',
    'Nao_Deve_Sair');
  coluna_atual: TGridColumn;
begin
  qtColunas := Length(frequencia_bolas_campo);

  // Nos controles stringGrid, devemos criar títulos, se queremos configurar
  // as colunas, como por exemplo, centralizá-la.
  uA := 0;
  objControle.Columns.Clear;
  while qtColunas > 0 do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := frequencia_bolas_campo[uA];
    objControle.Cells[uA, 0] := frequencia_bolas_campo[uA];

    Dec(qtColunas);
    Inc(uA);
  end;

  indice_ultima_coluna := High(frequencia_bolas_campo);

  {
  for uA := 0 to indice_ultima_Coluna do begin
    objControle.Columns[uA].title.Alignment := TAlignment.taCenter;
    objControle.Columns[uA].Alignment := TAlignment.taCenter;
    objControle.Columns[uA].title.Caption := frequencia_bolas_campo[uA];
    objControle.Cells[uA, 0] := frequencia_bolas_campo[uA];
  end;
  }

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  //objControle.Columns[indice_ultima_coluna].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

  // As duas últimas colunas, 'DEVE_SAIR', 'NAO_DEVE_SAIR' deverá ter o estilo
  // checkbox, pois, o usuário deve marcar pra indicar se deve sair ou não.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;
  objControle.Columns[indice_ultima_coluna - 1].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;


  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

{TODO:
      Alterar, futuramente, esta procedure pra que a mesma armazene o concurso escolhido
      pelo usuário antes de alterar o controle e em seguida, após o controle ser atualizado
      armazena o concurso que havia sido escolhido.
}
{
 Há várias caixas de combinação que armazena todos os números dos concurso,
 o objetivo desta procedure é carregar todas as caixas de combinação com
 a informação de todos os concursos.
}
procedure TForm1.CarregarConcursos;
var
  strSql: TStringList;
  sqlLotofacil: TSqlquery;
  strConcurso: string;
begin
  // Carrega o módulo, se não está carregado.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  strSql := TStringList.Create;
  strSql.Add('Select concurso from lotofacil.v_lotofacil_concursos');
  strSql.Add('order by concurso desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;
  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  // Verifica se há registros
  if sqlLotofacil.RecordCount = 0 then
  begin
    cmbConcursoNovosRepetidos.Clear;
    exit;
  end;

  // Limpa os combobox.
  //cmbConcursoNovosRepetidos.Clear;
  //cmbConcursoDeletar.Clear;
  cmbConcursoFrequenciaSair.Clear;
  cmbConcursoFrequenciaNaoSair.Clear;
  cmbConcursoFrequenciaTotalSair.Clear;
  cmbConcursoVerificarAcerto.Clear;
  cmbConcurso_Aleatorio_Verificar_Acerto.Clear;

  cmbNovosRepetidosConsolidadoConcursoInicial.Clear;
  cmbNovosRepetidosConsolidadoConcursoFinal.Clear;

  cmbParImparConsolidadoConcursoInicial.Clear;
  cmbParImparConsolidadoConcursoFinal.Clear;

  cmbExternoInternoConsolidadoConcursoInicial.Clear;
  cmbExternoInternoConsolidadoConcursoFinal.Clear;

  cmbPrimoNaoPrimoConsolidadoConcursoInicial.Clear;
  cmbPrimoNaoPrimoConsolidadoConcursoFinal.Clear;

  cmbConcursoNovosRepetidos.Clear;
  cmbNovosRepetidosConsolidadoConcursoInicial.Clear;
  cmbNovosRepetidosConsolidadoConcursoFinal.Clear;

  cmbConcursoDeletar.Clear;

  cmbAlgarismo_na_dezena_consolidado_concurso_inicial.Clear;
  cmbAlgarismo_na_dezena_consolidado_concurso_final.Clear;

  if sqlLotofacil.RecordCount = 0 then
  begin
    Exit;
  end;



  // Achamos registros, inserir então.
  sqlLotofacil.First;
  strConcurso := '';
  while sqlLotofacil.EOF = False do
  begin
    //cmbConcursoNovosRepetidos.Items.Add(sqlLotofacil.FieldByName('concurso').AsString);

    // Aqui, vamos aproveitar o código e carregar o controle 'cmbConcursoDeletar';
    //cmbConcursoDeletar.Items.Add(sqlLotofacil.FieldByName('concurso').AsString);
    strConcurso := sqlLotofacil.FieldByName('concurso').AsString;

    cmbConcursoFrequenciaSair.Items.Add(strConcurso);
    cmbConcursoFrequenciaNaoSair.Items.Add(strConcurso);
    cmbConcursoFrequenciaTotalSair.Items.Add(strConcurso);
    cmbConcursoVerificarAcerto.Items.Add(strConcurso);
    cmbConcurso_Aleatorio_Verificar_Acerto.Items.Add(strConcurso);

    // Os controles com sufixo 'Inicial', terão o concurso adicionado no final
    // mas os controles com sufixo 'Final', terá o concurso adicionado em ordem decrescente.
    // Pois, quando o usuário selecionar o primeiro número do concurso inicial terá o menor
    // valor e o primeiro número do sufixo final terá o último concurso.
    cmbNovosRepetidosConsolidadoConcursoInicial.Items.Insert(0, strConcurso);
    cmbNovosRepetidosConsolidadoConcursoFinal.Items.Add(strConcurso);

    cmbParImparConsolidadoConcursoInicial.Items.Insert(0, strConcurso);
    cmbParImparConsolidadoConcursoFinal.Items.Add(strConcurso);

    cmbExternoInternoConsolidadoConcursoInicial.Items.Insert(0, strConcurso);
    cmbExternoInternoConsolidadoConcursoFinal.Items.Add(strConcurso);

    cmbPrimoNaoPrimoConsolidadoConcursoInicial.Items.Insert(0, strConcurso);
    cmbPrimoNaoPrimoConsolidadoConcursoFinal.Items.Add(strConcurso);

    cmbAlgarismo_na_dezena_consolidado_concurso_inicial.Items.Insert(0, strConcurso);
    cmbAlgarismo_na_dezena_consolidado_concurso_final.Items.Add(strConcurso);

    cmbConcursoNovosRepetidos.Items.Add(strConcurso);

    cmbConcursoDeletar.Items.Add(strConcurso);


    sqlLotofacil.Next;
  end;

  sqlLotofacil.Close;

  // Define o primeiro ítem da lista.
  // cmbConcursoNovosRepetidos.ItemIndex := 0;
  //cmbConcursoDeletar.ItemIndex := 0;
  cmbConcursoFrequenciaSair.ItemIndex := 0;
  cmbConcursoFrequenciaNaoSair.ItemIndex := 0;
  cmbConcursoFrequenciaTotalSair.ItemIndex := 0;
  cmbConcursoVerificarAcerto.ItemIndex := 0;
  cmbConcurso_Aleatorio_Verificar_Acerto.ItemIndex := 0;

  cmbNovosRepetidosConsolidadoConcursoInicial.ItemIndex := 0;
  cmbNovosRepetidosConsolidadoConcursoFinal.ItemIndex := 0;

  cmbParImparConsolidadoConcursoInicial.ItemIndex := 0;
  cmbParImparConsolidadoConcursoFinal.ItemIndex := 0;

  cmbPrimoNaoPrimoConsolidadoConcursoInicial.ItemIndex := 0;
  cmbPrimoNaoPrimoConsolidadoConcursoFinal.ItemIndex := 0;

  cmbExternoInternoConsolidadoConcursoInicial.ItemIndex := 0;
  cmbExternoInternoConsolidadoConcursoFinal.ItemIndex := 0;

  cmbAlgarismo_na_dezena_consolidado_concurso_inicial.ItemIndex := 0;
  cmbAlgarismo_na_dezena_consolidado_concurso_final.ItemIndex := 0;

  cmbConcursoNovosRepetidos.ItemIndex := 0;

  cmbConcursoDeletar.ItemIndex := 0;



end;

procedure TForm1.CarregarFrequenciaBolas;
var
  strSql: TStrings;
  dsLotofacil: TSqlQuery;
  uLinha: integer;
  qtRegistros: longint;
begin
  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  strSql := TStringList.Create;
  strSql.add('Select bola1, qt_vezes');
  strSql.Add('from lotofacil.v_lotofacil_resultado_grupo_1_bola');
  strSql.Add('order by qt_vezes desc, bola1 asc');

  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := False;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  dsLotofacil.First;
  dsLotofacil.Last;
  qtRegistros := dsLotofacil.RecordCount;

  if qtRegistros = 0 then
  begin
    sgrFrequenciaSair.ColCount := 1;
    sgrFrequenciaSair.RowCount := 1;
    sgrFrequenciaSair.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    sgrFrequenciaSair.AutoSizeColumns;
    exit;
  end;

  // Devemos, 1 registro a mais por causa do cabeçalho.
  sgrFrequenciaSair.RowCount := qtRegistros + 1;
  sgrFrequenciaNaoSair.RowCount := qtRegistros + 1;

  ConfigurarControleFrequenciaBolas(sgrFrequenciaSair);
  ConfigurarControleFrequenciaBolas(sgrFrequenciaNaoSair);

  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  dsLotofacil.First;
  while dsLotofacil.EOF = False do
  begin
    // As células são strings, entretanto, não iremos atribuir o string diretamente,
    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
    // string, assim, se o campo for zero, não aparece nulo, em branco.
    sgrFrequenciaSair.Cells[0, uLinha] := IntToStr(dsLotofacil.FieldByName('bola1').AsInteger);
    sgrFrequenciaSair.Cells[1, uLinha] := IntToStr(dsLotofacil.FieldByName('qt_vezes').AsInteger);
    sgrFrequenciaSair.Cells[2, uLinha] := '0';

    sgrFrequenciaNaoSair.Cells[0, uLinha] := IntToStr(dsLotofacil.FieldByName('bola1').AsInteger);
    sgrFrequenciaNaoSair.Cells[1, uLinha] := IntToStr(dsLotofacil.FieldByName('qt_vezes').AsInteger);
    sgrFrequenciaNaoSair.Cells[2, uLinha] := '0';

    dsLotofacil.Next;
    Inc(uLinha);
  end;

  // Oculta a primeira coluna
  //objControle.Columns[0].Visible := false;

  // Fecha o dataset.
  dsLotofacil.Close;

  // Redimensiona as colunas.
  sgrFrequenciaSair.AutoSizeColumns;
  sgrFrequenciaNaoSair.AutoSizeColumns;

  strSql.Free;

end;

procedure TForm1.ConfigurarControleFrequenciaBolas(objControle: TStringGrid);
var
  indice_ultima_coluna, uA: integer;
  frequencia_bolas_campo: array[0..2] of
  string = ('Bola', 'qt_vezes',
    'Marcar');
  coluna_atual: TGridColumn;
begin
  indice_ultima_coluna := High(frequencia_bolas_campo);

  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := frequencia_bolas_campo[uA];
    objControle.Cells[uA, 0] := frequencia_bolas_campo[uA];
  end;

  // A coluna Marcar terá um checkBox, pois, se o usuário clicar em uma célula
  // da coluna Marcar, quer dizer, que ele quer selecionar aquela linha.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
end;

{
 Controle: sgrFrequenciaTotalSair.
}
procedure TForm1.CarregarConcursoFrequenciaTotalSair;
var
  strSql: TStrings;
  sql_registro: TSqlQuery;
  uLinha: integer;
  qtRegistros, bola_numero: longint;
  concursoFrequenciaTotalSair: string;
begin
  // Inicia o módulo de dados.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // Devemos pegar o número do concurso atual selecionado.
  if cmbConcursoFrequenciaTotalSair.Items.Count > 0 then
  begin
    ;
    concursoFrequenciaTotalSair :=
      cmbConcursoFrequenciaTotalSair.Items[cmbConcursoFrequenciaTotalSair.ItemIndex];
  end
  else
  begin
    concursoFrequenciaTotalSair := '-1';
  end;

  strSql := TStringList.Create;
  strSql.add('Select bola, frequencia');
  strSql.Add('from lotofacil.lotofacil_resultado_bolas_frequencia_total');
  strSql.Add('where concurso = ' + concursoFrequenciaTotalSair);
  strSql.Add('order by frequencia desc, bola asc');

  sql_registro := dmLotofacil.sqlLotofacil;

  sql_registro.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := strSql.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := False;
  dmLotofacil.sqlLotofacil.Prepare;
  sql_registro.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  qtRegistros := 0;
  sql_registro.First;
  sql_registro.Last;
  qtRegistros := sql_registro.RecordCount;

  if qtRegistros = 0 then
  begin
    sgrFrequenciaTotalSair.Columns.Clear;
    sgrFrequenciaTotalSair.Columns.Add;
    sgrFrequenciaTotalSair.FixedRows := 0;
    sgrFrequenciaTotalSair.RowCount := 1;
    sgrFrequenciaTotalSair.Cells[0, 0] := 'Não há registros...';
    // Redimensiona as colunas.
    sgrFrequenciaTotalSair.AutoSizeColumns;
    exit;
  end;

  if qtRegistros <> 25 then
  begin
    sgrFrequenciaTotalSair.Columns.Clear;
    sgrFrequenciaTotalSair.Columns.Add;
    sgrFrequenciaTotalSair.FixedRows := 0;
    sgrFrequenciaTotalSair.RowCount := 1;
    sgrFrequenciaTotalSair.Cells[0, 0] := 'Erro, Não há 25 registros...';
    // Redimensiona as colunas.
    sgrFrequenciaTotalSair.AutoSizeColumns;
    exit;
  end;

  // Devemos ter 1 registro a mais por causa do cabeçalho.
  sgrFrequenciaTotalSair.RowCount := qtRegistros + 1;

  ConfigurarControleConcursoFrequenciaTotalSair(sgrFrequenciaTotalSair);

  // Agora, iremos percorrer o registro e inserir na grade de strings.
  // A primeira linha, de índice zero, é o nome dos campos, devemos começar
  // na linha 1.
  uLinha := 1;
  sql_registro.First;
  while sql_registro.EOF = False do
  begin
    bola_numero := sql_registro.FieldByName('bola').AsInteger;

    // As células são strings, entretanto, não iremos atribuir o string diretamente,
    // iremos pegar o valor do campo como inteiro e em seguida, converter pra
    // string, assim, se o campo for zero, não aparece nulo, em branco.
    sgrFrequenciaTotalSair.Cells[0, uLinha] := IntToStr(bola_numero);
    sgrFrequenciaTotalSair.Cells[1, uLinha] :=
      IntToStr(sql_registro.FieldByName('frequencia').AsInteger);
    sgrFrequenciaTotalSair.Cells[2, uLinha] :=
      IntToStr(concurso_frequencia_sair[bola_numero]);
    sgrFrequenciaTotalSair.Cells[3, uLinha] :=
      IntToStr(concurso_frequencia_nao_sair[bola_numero]);

    sql_registro.Next;
    Inc(uLinha);
  end;


  // Oculta a primeira coluna
  //objControle.Columns[0].Visible := false;

  // Fecha o dataset.
  sql_registro.Close;

  // Redimensiona as colunas.
  sgrFrequenciaTotalSair.AutoSizeColumns;

  strSql.Free;

end;

{
 Configura o controle, pra ter o layout antes de inserir os dados.
}
procedure TForm1.ConfigurarControleConcursoFrequenciaTotalSair(objControle: TStringGrid);
var
  indice_ultima_coluna, uA: integer;
  frequencia_bolas_campo: array[0..3] of
  string = ('Bola', 'qt_vezes',
    'Deve_sair', 'Nao_deve_sair');
  coluna_atual: TGridColumn;
begin
  indice_ultima_coluna := High(frequencia_bolas_campo);

  objControle.Columns.Clear;
  for uA := 0 to indice_ultima_Coluna do
  begin
    coluna_atual := objControle.Columns.Add;
    coluna_atual.title.Alignment := TAlignment.taCenter;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.title.Caption := frequencia_bolas_campo[uA];
    objControle.Cells[uA, 0] := frequencia_bolas_campo[uA];
  end;

  // As duas últimas colunas terá um checkbox, pois, o usuário pode selecionar
  // se a bola deve ou não aparecer em todas as combinações.
  objControle.Columns[indice_ultima_coluna].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;
  objControle.Columns[indice_ultima_coluna - 1].ButtonStyle :=
    TColumnButtonStyle.cbsCheckboxColumn;

  // Indica a primeira linha como fixa, pois, é onde fica o nome dos campos.
  objControle.FixedCols := 0;
  objControle.FixedRows := 1;
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
  edConcurso.Enabled := False;
  grConcursoData.Enabled := False;
  btnLotofacilResultadoInserir.Enabled := False;
  btnLotofacilResultadoAtualizar.Enabled := False;
  dtpConcursoData.Enabled := False;

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


procedure TForm1.tgBolaChange(Sender: TObject);
var
  botaoAtual: TToggleBox;
  nomeControle: string;
  idControle, uA: integer;
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

  if botaoAtual.Checked = True then
  begin
    // Altera o fundo do botão.
    botaoAtual.Color := clGreen;
    botaoAtual.Font.Color := clWhite;

    Inc(lotofacil_qt_bolas_escolhidas);

    // Verifica se atingiu 15 bolas, se sim, desativar as não escolhidas
    if lotofacil_qt_bolas_escolhidas = 15 then
    begin
      for uA := 1 to 25 do
      begin
        lotofacil_resultado_botoes[uA].Enabled :=
          lotofacil_resultado_botoes
          [uA].Checked;
      end;
    end;

  end
  else
  begin
    botaoAtual.Color := clDefault;

    // Aqui, iremos ativar as bolas que foram desativadas.
    for uA := 1 to 25 do
    begin
      if lotofacil_resultado_botoes[uA].Enabled = False then
      begin
        lotofacil_resultado_botoes[uA].Enabled := True;
      end;
    end;

    botaoAtual.Font.Color := clDefault;
    Dec(lotofacil_qt_bolas_escolhidas);
  end;

  strStatusLotofacil := '';
  for uA := 1 to 25 do
  begin
    if lotofacil_resultado_botoes[uA].Checked then
    begin
      lotofacil_numeros_escolhidos[uA] := 1;
      if strStatusLotofacil <> '' then
      begin
        strStatusLotofacil := strStatusLotofacil + ' - ' + IntToStr(uA);
      end
      else
      begin
        strStatusLotofacil := IntToStr(ua);
      end;

    end
    else
    begin
      lotofacil_numeros_escolhidos[uA] := 0;
    end;
  end;
  strStatusLotofacil := 'Bolas escolhidas ' + #13#10 + strStatusLotofacil;

  //txtLotofacilBolas.Caption := strStatusLotofacil;

  // Se o total de bolas escolhidas for 15, desativar ativar o botão de envio.
  if lotofacil_qt_bolas_escolhidas = 15 then
  begin
    btnLotofacilResultadoInserir.Enabled := True;
    edConcurso.Enabled := True;
    grConcursoData.Enabled := True;
    dtpConcursoData.Enabled := True;
  end
  else
  begin
    btnLotofacilResultadoInserir.Enabled := False;
    edConcurso.Enabled := False;
    grConcursoData.Enabled := False;
    dtpConcursoData.Enabled := False;
  end;

end;

procedure TForm1.tgExibirCamposChange(Sender: TObject);
begin
  pnExibirCampos.Visible := tgExibirCampos.Checked;
  if tgExibirCampos.Checked then
  begin
    tgExibirCampos.Color := clGreen;
    tgExibirCampos.Font.Color := clWhite;
  end
  else
  begin
    tgExibirCampos.Color := clDefault;
    tgExibirCampos.Font.Color := clDefault;
  end;
end;

procedure TForm1.tgGeradorOpcoesChange(Sender: TObject);
begin
  pnGerador_Opcoes.Visible := tgGeradorOpcoes.Checked;
  if tgGeradorOpcoes.Checked then
  begin
    tgGeradorOpcoes.Color := clGreen;
    tgGeradorOpcoes.Font.Color := clWhite;
  end
  else
  begin
    tgGeradorOpcoes.Color := clDefault;
    tgGeradorOpcoes.Font.Color := clDefault;
  end;
end;

procedure TForm1.tgVerificarAcertosChange(Sender: TObject);
begin
  pnVerificarAcertos.Visible := tgVerificarAcertos.Checked;
  if tgVerificarAcertos.Checked then
  begin
    tgVerificarAcertos.Color := clGreen;
    tgVerificarAcertos.Font.Color := clWhite;
  end
  else
  begin
    tgVerificarAcertos.Color := clDefault;
    tgVerificarAcertos.Font.Color := clDefault;
  end;

end;

//procedure TForm1.rdDeslocamentoSelectionChanged(Sender: TObject);
//begin
//end;

procedure TForm1.rdGerador_Quantidade_de_BolasSelectionChanged(Sender: TObject);
begin
  case rdGerador_Quantidade_de_Bolas.ItemIndex of
    0: spinGerador_Combinacoes.MaxValue := 3268760;
    1: spinGerador_Combinacoes.MaxValue := 2042975;
    2: spinGerador_Combinacoes.MaxValue := 1081575;
    3: spinGerador_Combinacoes.MaxValue := 480700;
  end;
end;

procedure TForm1.sgrAlgarismo_na_dezena_consolidadoSelectCell(Sender : TObject; aCol, aRow : Integer;
  var CanSelect : Boolean);
begin
    AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrAlgarismo_na_dezena_por_concursoSelectCell(Sender : TObject; aCol, aRow : Integer;
  var CanSelect : Boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrBolas_na_mesma_colunaSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

// Indica que o valor do concurso de ínicio alterou.
procedure TForm1.cmbFrequenciaInicioChange(Sender: TObject);
begin
  AtualizarFrequencia;
end;

procedure TForm1.cmbNovosRepetidosConsolidadoConcursoFinalChange(Sender: TObject);
begin
  NovosRepetidosConsolidadoConcursoInicialFinalAlterou;
end;

procedure TForm1.cmbNovosRepetidosConsolidadoConcursoInicialChange(Sender: TObject);
begin
  NovosRepetidosConsolidadoConcursoInicialFinalAlterou;
end;

procedure TForm1.NovosRepetidosConsolidadoConcursoInicialFinalAlterou;
var
  indice_concurso_inicial, indice_concurso_final: integer;
  concurso_inicial, concurso_final: integer;
begin
  indice_concurso_inicial := cmbNovosRepetidosConsolidadoConcursoInicial.ItemIndex;
  indice_concurso_final := cmbNovosRepetidosConsolidadoConcursoFinal.ItemIndex;

  if (indice_concurso_inicial > -1) and (indice_concurso_final > -1) then
  begin
    concurso_inicial := StrToInt(
      cmbNovosRepetidosConsolidadoConcursoInicial.Items[indice_concurso_inicial]);
    concurso_final := StrToInt(
      cmbNovosRepetidosConsolidadoConcursoFinal.Items[indice_concurso_final]);

    CarregarNovosRepetidosConsolidadoIntervaloConcurso(sgrNovosRepetidosConsolidado,
      concurso_inicial, concurso_final);
  end;
end;


procedure TForm1.cmbNovo_MaximoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

procedure TForm1.cmbNovo_MinimoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

procedure TForm1.cmbParImparConsolidadoConcursoFinalChange(Sender: TObject);
begin
  parImparConsolidadoConcursoInicialFinalAlterou;
end;

//procedure TForm1.controle_cmb_intervalo_por_concurso_alterou(Sender: TObject);
//begin
//  parImparConsolidadoConcursoInicialFinalAlterou;
//end;

procedure TForm1.cmbPrimoNaoPrimoConsolidadoConcursoFinalChange(Sender: TObject);
begin
  PrimoNaoPrimoConsolidadoConcursoInicialFinalAlterou;
end;

procedure TForm1.cmbPrimoNaoPrimoConsolidadoConcursoInicialChange(Sender: TObject);
begin
  PrimoNaoPrimoConsolidadoConcursoInicialFinalAlterou;
end;

{
 Atualiza o controle PrimoNaoPrimoConsolidadoConcurso toda vez que
 o controle cmbPrimoNaoPrimoConsolidadoConcursoInicial ou cmbPrimoNaoprimoConsolidadoConcursoFinal
 for alterado.
}
procedure TForm1.PrimoNaoPrimoConsolidadoConcursoInicialFinalAlterou;
var
  indice_concurso_inicial, indice_concurso_final: integer;
  concurso_inicial, concurso_final: integer;
begin
  indice_concurso_inicial := cmbPrimoNaoPrimoConsolidadoConcursoInicial.ItemIndex;
  indice_concurso_final := cmbPrimoNaoPrimoConsolidadoConcursoFinal.ItemIndex;

  if (indice_concurso_inicial > -1) and (indice_concurso_final > -1) then
  begin
    concurso_inicial := StrToInt(
      cmbPrimoNaoPrimoConsolidadoConcursoInicial.Items[indice_concurso_inicial]);
    concurso_final := StrToInt(
      cmbPrimoNaoPrimoConsolidadoConcursoFinal.Items[indice_concurso_final]);

    CarregarPrimoNaoPrimoConsolidadoIntervaloConcurso(sgrPrimoNaoPrimoConsolidado,
      concurso_inicial, concurso_final);
  end;
end;

procedure TForm1.Soma_Frequencia_Status(status : string);
begin
  lblStatus.Caption := status;
end;

procedure TForm1.Soma_Frequencia_Status_Concluido(status : string);
begin
     lblStatus.Caption := status;
     btnAtualizarSomaFrequencia.Enabled := true;
end;

procedure TForm1.Soma_Frequencia_Status_Erro(status_erro : string);
begin
  lblStatus.Caption := status_erro;
  btnAtualizarSomaFrequencia.Enabled := true;
end;

procedure TForm1.parImparConsolidadoConcursoInicialFinalAlterou;
var
  indice_concurso_inicial, indice_concurso_final: integer;
  concurso_inicial, concurso_final: integer;
begin
  indice_concurso_inicial := cmbParImparConsolidadoConcursoInicial.ItemIndex;
  indice_concurso_final := cmbParImparConsolidadoConcursoFinal.ItemIndex;

  if (indice_concurso_inicial > -1) and (indice_concurso_final > -1) then
  begin
    concurso_inicial := StrToInt(cmbParImparConsolidadoConcursoInicial.Items[indice_concurso_inicial]);
    concurso_final := StrToInt(cmbParImparConsolidadoConcursoFinal.Items[indice_concurso_final]);

    CarregarParImparConsolidadoIntervaloConcurso(sgrParImparConsolidado, concurso_inicial, concurso_final);
  end;
end;



procedure TForm1.cmbRepetindo_MaximoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

procedure TForm1.cmbRepetindo_MinimoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

//procedure TForm1.edConcursoKeyDown(Sender: TObject; var Key: word;
//  Shift: TShiftState);
//begin
//
//end;

procedure TForm1.edConcursoKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8]) then
  begin
    Key := #0;
  end;
end;

procedure TForm1.cmbFrequenciaFimChange(Sender: TObject);
begin
  AtualizarFrequencia;
end;

procedure TForm1.btnLotofacilResultadoInserirClick(Sender: TObject);
var
  strData: string;
  uA, qt_de_bolas_escolhidas: integer;
  qt_registros: longint;
  strSql: TStringList;
  sqlRegistro: TSqlQuery;
  uConcurso: integer;

begin
  // Garante que o controle está preenchido.
  if edConcurso.Text = '' then
  begin
    MessageDlg('', 'Você deve fornecer o número do concurso',
      TMsgDlgType.mtError, [mbOK], 0);
    exit;
  end;

  // Pega o número do concurso, pra ser usado posteriormente.
  try
    uConcurso := StrToInt(edConcurso.Text);
  except
    On exc: Exception do
    begin
      MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  // Cria o objeto se não existe.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;
  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Active := False;


  sqlRegistro.SQL.Clear;
  sqlRegistro.Sql.Add('Select concurso from lotofacil.lotofacil_resultado_num');
  sqlRegistro.Sql.Add('where concurso = :concurso');
  sqlRegistro.Prepare;

  // Vamos passar o parâmetro, iremos pegar o número do concurso do botão
  // edConcurso.
  sqlRegistro.Params.ParamByName('concurso').AsInteger := uConcurso;
  sqlRegistro.Open;

  sqlRegistro.First;
  sqlRegistro.Last;
  qt_registros := sqlRegistro.RecordCount;

  // Não podemos inserir um concurso que já existe, indicar como um erro e sair.
  if qt_registros <> 0 then
  begin
    MessageDlg('Erro', 'Registro já existente.', TMsgDlgType.mtError, [mbOK], 0);
    exit;
  end;

  // Se não há erros, podemos inserir o novo concurso.
  sqlRegistro.Close;

  strSql := TStringList.Create;
  strSql.Clear;
  strSql.Add('Insert Into lotofacil.lotofacil_resultado_num (');
  strSql.Add(' concurso, data');

  // Vamos inserir o novo registros, primeiro iremos verificar se há 15 bolas selecionadas.
  qt_de_bolas_escolhidas := 0;
  for uA := 1 to 25 do
  begin
    if lotofacil_numeros_escolhidos[uA] = 1 then
    begin
      Inc(qt_de_bolas_escolhidas);
      // Se a quantidade é maior que 15, devemos sair do loop e retornar da função.
      if qt_de_bolas_escolhidas > 15 then
      begin
        MessageDlg('Erro', 'Foram escolhidos mais de 15 bolas.',
          TMsgDlgType.mtError, [mbOK], 0);
        exit;
      end;
      strSql.Add(', num_' + IntToStr(uA));
    end;
  end;
  // Verifica se realmente, houve 15 números escolhidos.
  if qt_de_bolas_escolhidas <> 15 then
  begin
    MessageDlg('Erro', 'Deve ser escolhidos 15 números.',
      TMsgDlgType.mtError, [mbOK], 0);
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
    dmLotofacil.pgLtk.Close(True);

  except
    on Exc: EDataBaseError do
    begin
      MessageDlg('Erro', 'Erro: ' + Exc.Message, TMsgDlgType.mtError, [mbOK], 0);
    end;
  end;

  // Só iremos desmarcar os botões se não tiver dado erro.
  for uA := 1 to 25 do
  begin
    lotofacil_resultado_botoes[uA].Checked := False;
  end;
  lotofacil_qt_bolas_escolhidas := 0;

  // Atualiza todos os controles que recupera informações do banco de dados.
  CarregarTodosControles;
end;

{
 Esta procedure será utilizada pelos botões: btnNovosFiltros e btnAleatorioNovo.
 Pois, praticamente, o código é o mesmo.
 Novos, iremos obter novos filtros e/ou novos aleatorios.
}
procedure TForm1.obterNovosFiltros(Sender: TObject);
var
  objButton: TButton;
  objData: TComboBox;

  sql_registro: TSqlQuery;
  qt_registros: integer;
begin
  if Sender is TButton then begin
    objButton := TButton(Sender);
  end else begin
    MessageDlg('', 'Controle não é um TButton', mtError, [mbok], 0);
    Exit;
  end;

  // Apaga o conteúdo dos controles 'cmbFiltroData' e 'cmbFiltroHora'
  // se o controle clicado foi btnNovosFiltros, ou,
  // Apaga o contéudo dos controles 'cmbFiltroAleatorioData' e 'cmbFiltroAleatorioHora'
  // se o controle clicado foi btnAleatorioNovo.
  if objButton = btnNovosFiltros then
  begin

    cmbFiltroData.Items.Clear;
    cmbFiltroHora.Items.Clear;
    objData := cmbFiltroData;

  end
  else
  if objButton = btnAleatorioNovo then
  begin

    cmbAleatorioFiltroData.Items.Clear;
    cmbAleatorioFiltroHora.Items.Clear;
    objData := cmbAleatorioFiltroData;

  end
  else
  begin
    exit;
  end;

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sql_registro := TSqlQuery.Create(Self);
  sql_registro.DataBase := dmLotofacil.pgLTK;
  sql_registro.UniDirectional := False;
  sql_registro.Active := False;

  // Aqui, iremos recuperar as datas, em ordem decrescente.
  if objButton = btnNovosFiltros then
  begin
    sql_registro.SQL.Add('Select data_1 from lotofacil.v_lotofacil_filtros_por_data');
    // O campo data_1, é um campo do tipo string formatado como um data em formato
    // brasileiro, entretanto, não é possível ordenar este tipo string, desta forma
    // pois, a data estará ordenada incorretamente.
    // O formato correto pra classificar é 'yyyy-mm-dd', por isto, há um outro campo
    // de nome 'data_2' em formato americano 'yyyy-mm-dd', assim é possível ordenar.
    sql_registro.Sql.Add('order by data_2 desc');
  end
  else
  if objButton = btnAleatorioNovo then
  begin
    sql_registro.SQL.Add('Select data_1 from lotofacil.v_lotofacil_aleatorio_por_data');
    sql_registro.Sql.Add('order by data_2 desc');
  end;

  try
    sql_registro.Open;
    sql_registro.First;

    // Iremos sempre definir a quantidade de registro igual a zero
    // e em seguida, percorrer se houver registro, somente após saberemos
    // a quantidade de registros que há, bem mais prático e eficiente do que
    // realizar 'first' e 'last', pra saber a quantidade de registros.
    qt_registros := 0;
    while not sql_registro.EOF do
    begin
      Inc(qt_registros);
      objData.Items.Add(sql_registro.FieldByName('data_1').AsString);
      sql_registro.Next;
    end;
    sql_registro.Close;
    sql_registro.Sql.Clear;
    dmLotofacil.Free;
    dmLotofacil := nil;

  except
    ON exc: Exception do
    begin
      MessageDlg('Erro', Exc.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  if qt_registros = 0 then
  begin
    // Se não há registros não iremos indicar nada, simplesmente
    // retornar, em seguida, o procedure que o chamou verificará se
    // o controle está vazio.
    exit;
  end;

  // Aponta pra o primeiro item do comboBox, terá a data mais recente.
  objData.ItemIndex := 0;

  // Agora, iremos selecionar a hora baseado na seleção atual.
  AtualizarFiltroData(objData, objData.Items[0]);
end;

{
    Esta procedure atualiza os controles cmbFiltroData e cmbFiltroHora,
    com novos filtros, se houver.
}
procedure TForm1.btnNovosFiltrosClick(Sender: TObject);
begin
  obterNovosFiltros(Sender);

  // Verifica se o controle ficou vazio, se sim, quer dizer
  // que houve nenhum resultado.
  if cmbFiltroData.Items.Count = 0 then begin
    MessageDlg('', 'Nenhum filtro localizado', mtInformation, [mbok], 0);
  end;


  exit;

   {

  // Apaga os controles 'cmbFiltroData' e 'cmbFiltroHora'.
  cmbFiltroData.Items.Clear;
  cmbFiltroHora.Items.Clear;

  if dmLotofacil = nil then begin
     dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLTK;
  sqlRegistro.UniDirectional := false;
  sqlRegistro.Active := false;

  sqlRegistro.SQL.Add('Select data_1 from lotofacil.v_lotofacil_filtros_por_data');
  sqlRegistro.Sql.Add('order by data_2 desc');

  sqlRegistro.Open;
  // Verifica o total de registros.
  qt_registros := 0;
  while not sqlRegistro.EOF do begin
      Inc(qt_registros);
      cmbFiltroData.Items.Add(sqlRegistro.FieldByName('data_1').AsString);
      sqlRegistro.Next;
  end;
  sqlRegistro.Close;
  sqlRegistro.Sql.Clear;
  dmLotofacil.Free;
  dmLotofacil := nil;

  if qt_registros = 0 then begin
     exit;
  end;

  cmbFiltroData.ItemIndex := 0;

  // Agora, iremos selecionar a hora baseado na seleção atual.
  AtualizarFiltroData(cmbFiltroData, cmbFiltroData.Items[0]);

  }
end;

procedure TForm1.btnAtualizarTabelaResultadosClick(Sender: TObject);
const
  campos_cabecalho: array[0..18] of string = (
    'status', 'status_ja_inserido',
    'concurso', 'data',
    'b_1', 'b_2', 'b_3', 'b_4', 'b_5',
    'b_6', 'b_7', 'b_8', 'b_9', 'b_10',
    'b_11', 'b_12', 'b_13', 'b_14', 'b_15'
    );
var
  sql_registro: TSQLQuery;
  lista_campos: TStringList;
  uA, qt_registros, linha_controle: integer;
  coluna_atual: TGridColumn;
  obj_fonte: TFont;
  lista_sql_insert: TStringList;
  sql_insert, nome_do_campo, concurso_data: string;
  bolas_sorteadas: array[1..25] of integer;
  bola_numero, concurso_numero: longint;
begin
  sql_registro := TSqlQuery.Create(Self);
  lista_sql_insert := TStringList.Create;

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sql_registro.DataBase := dmLotofacil.pgLTK;

  lista_campos := TStringList.Create;
  lista_campos.SkipLastLineBreak := True;
  for uA := 0 to High(campos_cabecalho) do
  begin
    lista_campos.Add(campos_cabecalho[uA]);
  end;
  lista_campos.Delimiter := ',';

  sql_registro.SQL.Clear;
  sql_registro.SQl.Add('Select');
  sql_registro.Sql.Add(lista_campos.DelimitedText);
  sql_registro.Sql.Add('from lotofacil.v_lotofacil_resultado_importacao');

  // Aqui, iremos pegar somente novos registros, neste caso
  // o campo que identifica novos registros, chama-se 'status
  sql_registro.Sql.Add('where status = ' + QuotedStr('NOVO'));
  sql_registro.Sql.Add('order by concurso asc');
  sql_registro.Close;
  sql_registro.Open;

  // Vamos verificar se houve registros.
  sql_registro.First;
  sql_registro.Last;
  qt_registros := sql_registro.RecordCount;

  if qt_registros = 0 then
  begin
    MessageDlg('', 'Não há registros novos', mtError, [mbOK], 0);
    Exit;
  end;

  // Se chegarmos aqui, há registros novos, devemos, atualizar gerar o sql.
  sql_registro.First;
  lista_sql_insert.Clear;
  while sql_registro.EOF = False do
  begin
    sql_insert := 'Insert into lotofacil.lotofacil_resultado_num (';
    sql_insert := sql_insert + 'concurso, data';

    // O arranjo bolas_sorteadas, serve pra evitar que tenhamos a mesma bola
    // sorteada mais de uma vez.
    FillChar(bolas_sorteadas, 25 * sizeof(integer), 0);

    // A tabela lotofacil_resultado_num, as bolas tem os campos correspondentes,
    // por exemplo, a bola 1 tem o campo num_1, a bola 2 tem o campo num_2
    // e assim por diante.
    // Então, iremos percorrer os campos b_1 até b_15 pra identificar cada bola.
    concurso_numero := sql_registro.FieldByName('concurso').AsInteger;



    // Bug[Corrigido]: Se o sistema operacional está indicando o ano com dois dígitos,
    // a expressão abaixo retorna o ano com 2 dígitos, entretanto, ao inserir na
    // tabela no banco de dados, está configurado pra ano de 4 dígitos.
    // concurso_data := sql_registro.FieldByName('data').AsString;
    // A correção foi formatar pra ser um ano de 4 dígitos.
    concurso_data := FormatDateTime('yyyy-mm-dd', sql_registro.FieldByName('data').AsDateTime);

    for uA := 1 to 15 do
    begin
      nome_do_campo := 'b_' + IntToStr(uA);
      bola_numero := sql_registro.FieldByName(nome_do_campo).AsInteger;

      // Verifica a faixa do número.
      if (bola_numero < 1) or (bola_numero > 25) then
      begin
        MessageDlg('Erro', 'Concurso : ' + IntToStr(concurso_numero) +
          ', Campo ' + nome_do_campo +
          ' tem bola fora do intervalo válido.',
          mtError, [mbOK], 0);
        sql_registro.Close;
        Exit;
      end;

      // Verifica por bolas duplicadas.
      if bolas_sorteadas[bola_numero] > 1 then
      begin
        MessageDlg('Erro', 'Concurso : ' + IntToStr(concurso_numero) +
          ' tem bola duplicada, bola: ' +
          IntToStr(bola_numero),
          mtError, [mbOK], 0);
        sql_registro.Close;
        Exit;
      end;

      bolas_sorteadas[bola_numero] := 1;

      // Gera os nomes dos campos conforme a bola sorteada.
      sql_insert := sql_insert + ', num_' + IntToStr(bola_numero);
    end;
    // Gera o novo insert.
    // Fecha
    sql_insert := sql_insert + ')';
    sql_insert := sql_insert + 'values (';

    // Número do concurso.
    sql_insert := sql_insert + IntToStr(concurso_numero) + ', ';

    // Data do concurso.
    // A data já está no formato americano: yyyy-mm-dd, só precisamos
    // Colocar entre aspas simples.
    sql_insert := sql_insert + QuotedStr(concurso_data);

    // Na tabela lotofacil_resultado_num, os valores que foram sorteados,
    // terão nos campos num_ correspondentes o valor 1, então.
    sql_insert := sql_insert + strUtils.DupeString(',1', 15) + ')';

    // Agora, vamos inserir o sql gerado na lista de sql a ser inseridos.

    // Insere um ';' pra separar as instruções sql.
    if lista_sql_insert.Count > 0 then
    begin
      sql_insert := ';' + sql_insert;
    end;

    lista_sql_insert.Add(sql_insert);

    Writeln(sql_insert);

    // Ir pra o próximo registro.
    sql_registro.Next;
  end;

  // Agora, temos o sql gerados, devemos enviar pra o banco.
  // Verifica se realmente, há algo na lista.
  if lista_sql_insert.Count = 0 then
  begin
    MessageDlg('', 'Não há registros novos', mtError, [mbOK], 0);
    Exit;
  end;

  // Agora, vamos adicionar nosso sql que foi criado.
  sql_registro.Close;
  sql_registro.SQL.Clear;
  sql_registro.SQL.Text := lista_sql_insert.Text;

  try
    //sql_registro.DataBase := dmLotofacil.pgLTK;
    sql_registro.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_registro.Close;
    dmLotofacil.pgLtk.Close(True);
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit;
    end;
  end;

  MessageDlg('', 'Tabela atualizada com sucesso!!!',
    TMsgDlgType.mtInformation, [mbOK], 0);

end;


procedure TForm1.btnObterResultadosClick(Sender: TObject);
//const
//  diretorio_download = '.' + DirectorySeparator + 'lotofacil_resultado';
//var
//  arquivo_lotofacil_zip: TMemoryStream;
//  arquivo_unzip: TUnZipper;
//  arquivo_zip, zip_extraido_no_diretorio, arquivo_conteudo_html,
//  nome_arquivo_htm: ansistring;
//  conteudo_html: TStrings;

begin

  if Obter_Lotofacil_Resultado = False then
  begin
    MessageDlg('Erro', strErro, mtError, [mbOK], 0);
    Exit;
  end;

  CarregarConcursos;

  MessageDlg('', 'Importado com sucesso!!!', mtConfirmation, [mbOK], 0);

end;

procedure TForm1.btnPararDeAtualizarNovosRepetidosClick(Sender: TObject);
begin

  if Assigned(ltf_novos_repetidos) then
  begin
    if MessageDlg('', 'Você deseja interromper a atualização?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      ltf_novos_repetidos.Terminate;
      btnPararDeAtualizarNovosRepetidos.Enabled := false;
    end;
  end;

end;

procedure TForm1.btnFiltroExcluirClick(Sender : TObject);
var
  indice_data_selecionado, indice_hora_selecionado: integer;
  strFiltroData, strFiltroHora, strFiltroDataHora: string;
begin

  indice_data_selecionado := cmbFiltroData.ItemIndex;
  indice_hora_selecionado := cmbFiltroHora.ItemIndex;

  if (indice_data_selecionado <= -1) or (indice_hora_selecionado <= -1) then
  begin
    sgrFiltros.Columns.Clear;
    sgrFiltros.Columns.Add;
    sgrFiltros.RowCount := 1;
    sgrFiltros.Cells[0, 0] := 'Nenhum filtro selecionado';
    sgrFiltros.AutoSizeColumns;
    exit;
  end;

  strFiltroData := cmbFiltroData.Items[indice_data_selecionado];
  strFiltroHora := cmbFiltroHora.Items[indice_hora_selecionado];
  strFiltroDataHora := strFiltroData + ' ' + strFiltroHora;

  Filtro_Excluir(strFiltroDataHora);

end;

{
 Deleta o filtro selecionado pelo usuário.
}
procedure TForm1.Filtro_Excluir(filtro_data_hora : AnsiString);
var
  sql_registros : TSQLQuery;
  data_hora , data: TStringArray;
  filtro_data_hora_original : String;
begin

  // Aqui, verificaremos se o usuário deseja excluir o filtro
  // Se a resposta for não, retornaremos imediatamente.
  if mrNo = MessageDlg('', 'Deseja excluir o filtro criado em ' + filtro_data_hora + '?', mtConfirmation, [mbYes, mbNo], 0)  then
  begin
     Exit;
  end;

  if filtro_data_hora = '' then
  begin
     Exit;
  end;

  // Armazena o filtro original, pra ser exibido caso o filtro seja
  // excluído com sucesso.
  filtro_data_hora_original := filtro_data_hora;

  // A data está em formato brasileiro, assim: dd-mm-yyyy hh:nn:ss.mi
  // Vamos criar um arranjo, pra isto, o campo data é separado do campo tempo por um
  // espaço.
  data_hora := filtro_data_hora.Split(' ');

  if Length(data_hora) <> 2 then begin
    MessageDlg('', 'Erro, deve haver um espaço separado a data e hora.', mtError, [mbOk], 0);
    Exit;
  end;

  // Agora, iremos separar a parte data, em dia, mes e ano.
  data := data_hora[0].Split('-');

  // Deve haver 3 valores.
  if Length(data) <> 3 then begin
    MessageDlg('', 'Erro, os campos de dia, mês e ano, deve ser interseparados pelo caractere ' + '-', mtError, [mbok], 0);
    Exit;
  end;

  // Ficará desta forma:
  // data[0] => dia
  // data[1] => mes
  // data[2] => ano

  // Agora, iremos colocar a data no formato americano.
  filtro_data_hora := data[2] + '-' + data[1] + '-' + data[0] + ' ' + data_hora[1];

  if dmLotofacil = nil then begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sql_registros := TSqlQuery.Create(Self);
  sql_registros.DataBase := dmLotofacil.pgLTK;

  sql_registros.Close;
  sql_registros.SQL.Clear;
  sql_registros.Sql.Add('Delete from lotofacil.lotofacil_filtros');
  sql_registros.Sql.Add('where data = ' + QuotedStr(filtro_data_hora));

  try
    sql_registros.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_registros.Close;
    dmLotofacil.pgLtk.Close(True);
  except
    on Exc: EDataBaseError do
    begin
      MessageDlg('', 'Erro, ' + exc.Message, mtError, [mbok], 0);
      Exit;
    end;
  end;

  // Atualiza o controle com os filtros.
  obterNovosFiltros(btnNovosFiltros);

  MessageDlg('', 'Filtro ' + filtro_data_hora_original, mtInformation, [mbok], 0);

end;

function TForm1.Obter_Lotofacil_Resultado: boolean;
const
  diretorio_download = '.' + DirectorySeparator + 'lotofacil_resultado';
var
  arquivo_lotofacil_zip: TMemoryStream;
  arquivo_unzip: TUnZipper;
  arquivo_zip, zip_extraido_no_diretorio, arquivo_conteudo_html,
  nome_arquivo_htm: ansistring;
  conteudo_html: TStrings;

begin
  // Cria o diretório se não existe.
  try
    if DirectoryExists(diretorio_download) = False then
    begin
      CreateDir(diretorio_download);
    end;
  except
    On exc: Exception do
    begin
      MessageDlg('Erro', Exc.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  // Gera um nome de arquivo, pra ser gravado.
  arquivo_zip := 'lotofacil_resultado_' + FormatDateTime('yyyy_mm_dd_hh_nn_ss',
    now) + '.zip';
  arquivo_zip := diretorio_download + DirectorySeparator + arquivo_zip;

  // Baixa o arquivo, se nenhum erro ocorrer.
  arquivo_lotofacil_zip := TMemoryStream.Create;
  try
    objHttp.AllowCookies := True;
    objHttp.HandleRedirects := True;
    objHttp.Get('http://www1.caixa.gov.br/loterias/_arquivos/loterias/D_lotfac.zip',
      arquivo_lotofacil_zip);
    arquivo_lotofacil_zip.SaveToFile(arquivo_zip);
  except
    On exc: Exception do
    begin
      MessageDlg('', Exc.Message, mtError, [mbOK], 0);
      Exit(False);
    end;
  end;

  // Vamos criar um diretório baseado no nome do arquivo zip.
  zip_extraido_no_diretorio := ExtractFileNameWithoutExt(arquivo_zip);
  try
    if DirectoryExists(zip_extraido_no_diretorio) = False then
    begin
      CreateDir(zip_extraido_no_diretorio);
    end;
  except
    On exc: Exception do
    begin
      strErro := Exc.Message;
      Exit;
    end;
  end;

  // Unzip o arquivo zip e em seguida, vamos analisar o arquivo.
  arquivo_unzip := TUnZipper.Create;
  arquivo_unzip.FileName := arquivo_zip;
  arquivo_unzip.OutputPath := zip_extraido_no_diretorio;
  arquivo_unzip.UnZipAllFiles;

  FreeAndNil(arquivo_unzip);

  // Agora, pega o conteúdo do arquivo html que foi extraído do arquivo zip.
  arquivo_conteudo_html := '';
  nome_arquivo_htm := zip_extraido_no_diretorio + DirectorySeparator + 'D_LOTFAC.HTM';

  conteudo_html := TStringList.Create;

  try
    conteudo_html.LoadFromFile(nome_arquivo_htm);
    arquivo_conteudo_html := conteudo_html.Text;
  except
    On exc: Exception do
    begin
      MessageDlg('Erro', Exc.Message, mtError, [mbOK], 0);
      Exit(False);
    end;
  end;

  if Obter_Lotofacil_Resultado(nome_arquivo_htm) = False then
  begin
    Exit(False);
  end;

  if Atualizar_Controle_Lotofacil_Resultado = False then
  begin
    Exit(False);
  end;

end;

function TForm1.Atualizar_Controle_Lotofacil_Resultado: boolean;
const
  campos_cabecalho: array[0..32] of string = (
    'status', 'status_ja_inserido',
    'concurso', 'data',
    'b_1', 'b_2', 'b_3', 'b_4', 'b_5',
    'b_6', 'b_7', 'b_8', 'b_9', 'b_10',
    'b_11', 'b_12', 'b_13', 'b_14', 'b_15',
    'arrecadacao_total', 'g_15_numeros',
    'g_14_numeros', 'g_13_numeros',
    'g_12_numeros', 'g_11_numeros',
    'rateio_15_numeros', 'rateio_14_numeros',
    'rateio_13_numeros', 'rateio_12_numeros',
    'rateio_11_numeros', 'acumulado_15_numeros',
    'estimativa_premio', 'valor_acum_especial'
    );
var
  sql_registro: TSQLQuery;
  lista_campos: TStringList;
  uA, qt_registros, linha_controle: integer;
  coluna_atual: TGridColumn;
  obj_fonte: TFont;
begin
  sql_registro := TSqlQuery.Create(Self);

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sql_registro.DataBase := dmLotofacil.pgLTK;

  // Gera o sql dinamicamente.
  lista_campos := TStringList.Create;
  lista_campos.SkipLastLineBreak := True;
  for uA := 0 to High(campos_cabecalho) do
  begin
    lista_campos.Add(campos_cabecalho[uA]);
  end;
  lista_campos.Delimiter := ',';

  sql_registro.SQL.Clear;
  sql_registro.SQl.Add('Select');
  sql_registro.Sql.Add(lista_campos.DelimitedText);
  sql_registro.Sql.Add('from lotofacil.v_lotofacil_resultado_importacao');
  sql_registro.Close;
  sql_registro.Open;

  // Quantidade de registros.
  qt_registros := 0;
  sql_registro.First;
  sql_registro.Last;
  qt_registros := sql_registro.RecordCount;

  // Configura o controle sgrResultado_Importacao;
  sgrResultado_Importacao.Columns.Clear;
  for uA := 0 to High(campos_cabecalho) do
  begin
    coluna_atual := sgrResultado_Importacao.Columns.Add;
    coluna_atual.Title.Caption := campos_cabecalho[uA];
    coluna_atual.Title.Alignment := taCenter;
    coluna_atual.Alignment := taCenter;
  end;

  // Define a quantidade de linhas e indica uma linha fixa.
  sgrResultado_Importacao.FixedRows := 1;
  sgrResultado_Importacao.RowCount := qt_registros + 1;

  // Agora, vamos inserir os dados.
  linha_controle := 1;
  sql_registro.First;
  while (sql_registro.EOF = False) and (linha_controle <= qt_registros) do
  begin
    for uA := 0 to High(campos_cabecalho) do
    begin
      case uA of
        0..1: // Status, Status_ja_inserido
        begin
          sgrResultado_Importacao.Cells[uA, linha_controle] :=
            sql_registro.Fields[uA].AsString;
        end;
        2, 4..18, 20..24:
        begin
          sgrResultado_Importacao.Cells[uA, linha_controle] :=
            IntToStr(sql_registro.Fields[uA].AsInteger);
        end;

        3:  // Data
        begin
          sgrResultado_Importacao.Cells[uA, linha_controle] :=
            DateToStr(sql_registro.Fields[uA].AsDateTime);
        end;

        19, 25..32:
        begin
          sgrResultado_Importacao.Cells[uA, linha_controle] :=
            FloatToStr(sql_registro.Fields[uA].AsFloat);
        end;

      end;
    end;
    Inc(linha_controle);
    sql_registro.Next;
  end;

  sgrResultado_Importacao.AutoSizeColumns;

end;



{
 Analisa o arquivo html e recupera todos os dados referentes aos concursos.
}
function TForm1.Obter_Lotofacil_Resultado(arquivo_html: ansistring): boolean;
const
   {$ifdef WINDOWS}
  NEW_LINE = #10#13;
   {$ELSE}
           {$IFDEF LINUX}
  NEW_LINE = #10;
           {$ELSE}
  NEW_LINE = #13;
           {$ENDIF}
   {$ENDIF}
var
  lotofacil_html_doc: THTMLDocument;
  lotofacil_tabela_nodes, lotofacil_tabela_linhas, tabela_colunas: TDOMNodeList;
  lotofacil_tabela_node, lotofacil_linha_atual, tabela_coluna_atual,
  coluna_atual, coluna_atributo: TDOMNode;
  total_de_linhas_na_tabela: longword;
  strTexto, valor_coluna_atual, concurso_sql: string;
  uA, uB, rowspan: integer;
  coluna_atributos: TDOMNamedNodeMap;
  rowspan_temp: longint;
  lista_concurso, lista_concurso_sql: TStringList;

  //lista_resultado : TLista_TStrings;
begin
  // Ler arquivo, html.
  lotofacil_html_doc := nil;
  ReadHTMLFile(lotofacil_html_doc, arquivo_html);

  // Verifica se há uma única tabela dentro do arquivo html.
  lotofacil_tabela_nodes := lotofacil_html_doc.GetElementsByTagName('table');

  // Não há tabela, retornar.
  if 0 = lotofacil_tabela_nodes.Count then
  begin
    Exit(False);
  end;

  // No nó tabela, os nós secundários, corresponde, a linhas da tabela
  // Vamos verificar se há nós.
  lotofacil_tabela_node := lotofacil_tabela_nodes[0];
  lotofacil_tabela_linhas := lotofacil_tabela_node.ChildNodes;

  if lotofacil_tabela_linhas.Count = 0 then
  begin
    Exit(False);
  end;

  // O nó 'lotofacil_tabela_linhas', contém todas as linhas da tabela,
  // Agora, iremos, percorrer cada linha e extrair os dados.
  total_de_linhas_na_tabela := lotofacil_tabela_linhas.Count;

  // A primeira linha é o cabeçalho, não precisa analisar.
  // O cabeçalho está desta forma:
  // concurso, data, bola1 até bola15
  // Arrecadação total
  // ganhadores_15_numeros;
  // cidade;
  // uf;
  // ganhadores_14_numeros;
  // ganhadores_13_numeros;
  // ganhadores_12_numeros;
  // ganhadores_11_numeros;
  // valor_rateio_15_numeros;
  // valor_rateio_14_numeros;
  // valor_rateio_13_numeros;
  // valor_rateio_12_numeros;
  // valor_rateio_11_numeros;
  // Acumulado_15_numeros;
  // Estimativa_premio
  // Valor_acumulado_especial
  strTexto := 'Concurso;Data';

  for uA := 1 to 15 do
  begin
    strTexto := strTexto + ';Bola' + IntToStr(uA);
  end;

  strTexto := strTexto + ';Arrecadacao_Total' + ';ganhadores_15_numeros' +
    ';Cidade' + ';UF' + ';ganhadores_14_numeros' + ';ganhadores_13_numeros' +
    ';ganhadores_12_numeros' + ';ganhadores_11_numeros' + ';valor_rateio_15_numeros' +
    ';valor_rateio_14_numeros' + ';valor_rateio_13_numeros' +
    ';valor_rateio_12_numeros' + ';valor_rateio_11_numeros' +
    ';Acumulado_15_numeros' + ';Estimativa_premio' + ';Valor_acumulado_especial';

  lista_concurso := TStringList.Create;
  lista_concurso.Clear;
  lista_concurso.Add(strTexto);


  lista_concurso_sql := TStringList.Create;
  concurso_sql := 'insert into lotofacil.lotofacil_resultado_importacao (' +
    'concurso,' + 'data, b_1, b_2, b_3, b_4, b_5,' +
    'b_6, b_7, b_8, b_9, b_10,' +
    'b_11, b_12, b_13, b_14, b_15,' +
    'arrecadacao_total, g_15_numeros,' +
    'g_14_numeros, g_13_numeros, g_12_numeros,' +
    'g_11_numeros, rateio_15_numeros,' +
    'rateio_14_numeros, rateio_13_numeros,' +
    'rateio_12_numeros, rateio_11_numeros,' +
    'acumulado_15_numeros, estimativa_premio, valor_acum_especial)values';

  uA := 1;
  while uA <= Pred(total_de_linhas_na_tabela) do
  begin
    lotofacil_linha_atual := lotofacil_tabela_linhas.Item[uA];

    // Obtém todos os nós secundários da linha, atual, neste caso, nó 'th'.
    tabela_colunas := lotofacil_linha_atual.GetChildNodes;

    // Cada tag pode ter um atributo, estamos interessado no atributo
    // rowspan, isto quer dizer, que uma coluna pode expandir pra
    // mais de uma linha, então, haverá mais linhas pra indicar aquela coluna
    // específica.
    // Então, segue-se exemplo, se rowspan="2", quer dizer, que há duas linhas
    // pra aquela coluna ou mais coluna, neste caso, haverá 1 linha após a linha
    // atual.
    // Então, no nosso caso, estas colunas, corresponde a nome de cidades e/ou
    // de estados, então, no nosso caso, não estamos interessados nestas informações,
    // simplesmente, iremos pular tais linhas desnecessárias.
    rowspan := 0;

    // Agora, iremos percorrer cada coluna da linha atual.
    strTexto := '';

    // Na lotofacil, há 33 colunas pra informações sobre o concurso da lotofacil
    // Devemos garantir que há estas colunas.
    if tabela_colunas.Count <> 33 then
    begin
      MessageDlg('', 'Lotofacil deve ter 33 colunas, pra cada resultado, entretanto,'
        +
        ' quantidade de colunas é diferente de 33', mtError, [mbOK], 0);
      Exit(False);
    end;

    // Neste for, iremos percorrer todas as colunas da linha atual
    // Na lotofacil, há 33 colunas.
    for uB := 0 to Pred(tabela_colunas.Count) do
    begin
      tabela_coluna_atual := tabela_colunas.Item[uB];
      valor_coluna_atual := Trim(tabela_coluna_atual.TextContent);

      // Verifica se tem atributo, se sim, verifica se tem um rowspan.
      if tabela_coluna_atual.HasAttributes then
      begin
        coluna_atributos := tabela_coluna_atual.Attributes;
        coluna_atributo := nil;
        coluna_atributo := coluna_atributos.GetNamedItem('rowspan');

        if coluna_atributo <> nil then
        begin
          try
            rowspan_temp := 0;
            rowspan_temp := StrToInt(coluna_atributo.NodeValue);
          except
            rowspan_temp := 0;
          end;
          if rowspan_temp <> 0 then
          begin
            // Se rowspan for maior que o rowspan atual, devemos
            // atualizar.
            if rowspan_temp > rowspan then
            begin
              rowspan := rowspan_temp;
            end;
          end;
        end;
      end;

      // A propriedade 'TextContent', contém o valor que queremos,
      // entretanto, pode haver outras tags, que formatam este valor
      // Então, vamos percorrer, até chegar no nós mais profundo.
      coluna_atual := tabela_coluna_atual;

      while coluna_atual.HasChildNodes do
      begin
        Writeln('Coluna: ', coluna_atual.NodeName, ', valor = ',
          coluna_atual.nodeValue, ', conteudo: ',
          coluna_atual.TextContent);
        coluna_atual := coluna_atual.ChildNodes[0];
        valor_coluna_atual := coluna_atual.TextContent;
      end;

      if strTexto <> '' then
      begin
        strTexto := strTexto + ';';
      end;

      strTexto := strTexto + Trim(valor_coluna_atual);
    end;
    lista_concurso.Add(strTexto);

    // Rowspan, indica a quantidade de linhas, que fazem parte do mesmo concurso
    // Então, como analisamos uma linha, devemos considerar uma linha a menos
    if rowspan > 0 then
    begin
      Dec(rowspan, 1);
    end;

    // Aqui, iremos pra última linha, do mesmo concurso, entretanto,
    // não precisamos analisar, esta linha
    Inc(uA, rowspan);

    // Sempre, iremos pra o próximo concurso, nunca, iremos pra a próxima
    // linha do mesmo concurso, por isso, incrementamos em 1.
    Inc(uA, 1);
  end;

  // Evitar quebra de linha no final do arquivo
  lista_concurso.SkipLastLineBreak := True;
  lista_concurso.SaveToFile('resultado_lotofacil.csv');

  // Agora, vamos importar os dados pra a tabela 'lotofacil.lotofacil_resultado_importacao'
  if Inserir_Lotofacil_Resultado_Importacao(lista_concurso) = False then
  begin
    MessageDlg('Erro', strErro, mtError, [mbOK], 0);
    Exit(False);
  end;


  FreeAndNil(lista_concurso);
  FreeAndNil(lotofacil_html_doc);

  Exit(True);
end;

{
 Ler o conteúdo que foi obtido do arquivo html e formata pra ser inserido
 na tabela 'lotofacil.lotofacil_resultado_importacao'
}
function TForm1.Inserir_Lotofacil_Resultado_Importacao(lista_concurso:
  TStringList): boolean;
var
  texto_atual, sql_insert, bolas_repetidas, valor_arrecadacao_total,
  valor_coluna: string;
  texto_colunas, data_concurso: TStringArray;
  uA, uB, uC, qt_bolas_sorteadas: integer;
  lista_sql_insert: TStringList;
  numero_do_concurso, bola_numero, numero_bola, dia_concurso,
  mes_concurso, ano_concurso: longint;
  lotofacil_bolas: array[0..25] of integer;
  bolas_sorteadas: ansistring;
  ponto_decimal_anterior, ponto_milhar_anterior: char;
  arrecadacao, arrecadacao_total, valor_float: extended;

  numero_formato_brasileiro, numero_formato_americano: TFormatSettings;
  sql_lotofacil: TSQLQuery;

begin
  lista_sql_insert := TStringList.Create;
  sql_insert := 'insert into lotofacil.lotofacil_resultado_importacao (' +
    'concurso,' + 'data, b_1, b_2, b_3, b_4, b_5,' +
    'b_6, b_7, b_8, b_9, b_10,' +
    'b_11, b_12, b_13, b_14, b_15,' +
    'arrecadacao_total, g_15_numeros,' +
    'g_14_numeros, g_13_numeros, g_12_numeros,' +
    'g_11_numeros, rateio_15_numeros,' +
    'rateio_14_numeros, rateio_13_numeros,' +
    'rateio_12_numeros, rateio_11_numeros,' +
    'acumulado_15_numeros, estimativa_premio, valor_acum_especial) values';
  lista_sql_insert.Add(sql_insert);

  // Cada linha, tem estes campos, os índices de cada coluna entre colchetes.
  // Concurso,                [0]
  // Data,                    [1]
  // Bola1 até Bola15         [2..16]
  // Arrecadacao_Total         [17]
  // Ganhadores_15_numeros     [18]
  // Cidade                    [19]
  // UF                        [20]
  // Ganhadores_14_numeros     [21]
  // Ganhadores_13_numeros     [22]
  // Ganhadores_12_numeros     [23]
  // Ganhadores_11_numeros     [24]
  // Valor_Rateio_15_numeros   [25]
  // Valor_Rateio_14_numeros   [26]
  // Valor_Rateio_13_numeros   [27]
  // Valor_Rateio_12_numeros   [28]
  // Valor_Rateio_15_numeros   [29]
  // Acumulado_15_numeros      [30]
  // Estimativa_Premio         [31]
  // Valor_acumulado_premio    [32]

  {
  ';Arrecadacao_Total'+
  ';ganhadores_15_numeros'+
  ';Cidade'+
  ';UF'+
  ';ganhadores_14_numeros'+
  ';ganhadores_13_numeros'+
  ';ganhadores_12_numeros'+
  ';ganhadores_11_numeros'+
  ';valor_rateio_15_numeros'+
  ';valor_rateio_14_numeros'+
  ';valor_rateio_13_numeros'+
  ';valor_rateio_12_numeros'+
  ';valor_rateio_11_numeros'+
  ';Acumulado_15_numeros'+
  ';Estimativa_premio'+
  ';Valor_acumulado_especial';
  }

  // Índice 0, é o cabeçalho, desnecessário analisar.
  for uA := 1 to Pred(lista_concurso.Count) do
  begin
    texto_atual := lista_concurso.Strings[uA];
    texto_colunas := texto_atual.Split(';');

    // Verifica se há 33 colunas, se não houver indicar erro.
    // Há, estes campos:


    if Length(texto_colunas) <> 33 then
    begin
      strErro := Format('Erro, Linha: %i, colunas: %i, entretanto, na lotofacil ' +
        'deve haver 33 colunas', [uA + 1, Length(texto_colunas)]);
      Exit(False);
    end;

    if uA = 1 then
    begin
      sql_insert := '(';
    end
    else
    begin
      sql_insert := ',(';
    end;

    // Zera este arranjo, pois, será usado quando precisarmos ordenar
    // as bolas do concurso.
    FillChar(lotofacil_bolas, sizeof(integer) * 26, 0);

    // Pra ficar melhor, iremos mostrar todas as bolas repetidas,
    // ao invés de parar na primeira bola repetida.
    bolas_repetidas := '';

    for uB := 0 to High(texto_colunas) do
    begin
      case uB of
        // Número do concurso.
        0:
        begin
          try
            numero_do_concurso := StrToInt(texto_colunas[uB]);
          except
            on Exc: Exception do
            begin
              strErro := Exc.Message;
              Exit(False);
            end;
          end;
          sql_insert := sql_insert + IntToStr(numero_do_concurso);
        end;

        // Data do concurso
        // A data do concurso está em formato brasileiro, devemos
        // colocar a data em formato americano.
        1:
        begin
          data_concurso := texto_colunas[uB].Split('/');
          if Length(data_concurso) <> 3 then
          begin
            strErro :=
              'Data inválida, deve haver 3 números, separados por ''/''';
            Exit(False);
          end;

          try
            dia_concurso := StrToInt(data_concurso[0]);
            mes_concurso := StrToInt(data_concurso[1]);
            ano_concurso := StrToInt(data_concurso[2]);

          except
            On exc: Exception do
            begin
              strErro := 'Erro: ' + exc.Message;
              Exit(False);
            end;
          end;

          // Não iremos validar a data, iremos passar diretamente, pra o banco.
          sql_insert :=
            sql_insert + ', ' + QuotedStr(Format('%d-%d-%d', [ano_concurso, mes_concurso, dia_concurso]));
        end;

        // Bolas do concurso
        // No concurso, as bolas do resultado podem estar disposta sfora da ordem
        // ou repetidas, ao inserir no banco, não pode haver bolas repetidas e
        // tais bolas devem estar dispostas em ordem crescente, devemos validar
        // isto.
        // Pra isto, iremos utilizar o arranjo 'lotofacil_bolas', todos os ítens
        // tem o valor zero, então ao inserir, incrementa o valor daquela célula
        // do arranjo. Se houver alguma bola repetida, ao verificar o valor
        // da célula daquela bola, ela terá o valor 1, quer dizer que a bola já saiu,
        // então, devemos sair com um erro de bola repetida.
        2..16:
          // Do índice 2 ao 16, corresponde as 15 bolas, então, quando chegarmos
          // ao último índice, 16, iremos ordenar as bolas pra inserir.
        begin
          // Verifica se é uma número inteiro válido.
          try
            bola_numero := StrToInt(texto_colunas[uB]);
          except
            on Exc: Exception do
            begin
              strErro := Exc.Message;
              Exit(False);
            end;
          end;
          // Verifica se a bola está no intervalo entre 1 e 25.
          if not ((bola_numero >= 1) and (bola_numero <= 25)) then
          begin
            strErro := Format(       'Erro, Linha: %i, Intervalo inválido: %i, ' +
                                     'A faixa válida deve ser entre 1 e 25.',
                                     [uA + 1, bola_numero]);
            Exit(False);
          end;

          // Verifica se este número já foi encontrado.
          if lotofacil_bolas[bola_numero] >= 1 then
          begin
            if bolas_repetidas <> '' then
            begin
              bolas_repetidas := bolas_repetidas + ', ';
            end;
            bolas_repetidas := bolas_repetidas + IntToStr(bola_numero);
          end;

          lotofacil_bolas[bola_numero] := lotofacil_bolas[bola_numero] + 1;

          if uB <> 16 then
          begin
            Continue;
          end;

          // Verifica se há bolas repetidas.
          if bolas_repetidas <> '' then
          begin
            strErro := 'Há bolas repetidas: ' + bolas_repetidas;
            Exit(False);
          end;

          // Vamos pegar as bolas em ordem crescente, bem simples isto
          // é só percorrer o arranjo sequencialmente do menor pra o maior
          // e ao encontrar um arranjo com a célula com valor 1, pegar
          // este número.
          bolas_sorteadas := '';
          qt_bolas_sorteadas := 0;
          for uC := 1 to 25 do
          begin
            if lotofacil_bolas[uC] = 1 then
            begin
              bolas_sorteadas := bolas_sorteadas + ', ' + IntToStr(uC);
              Inc(qt_bolas_sorteadas);
            end;
          end;

          // Verifica se realmente, há 15 bolas sorteadas
          if qt_bolas_sorteadas <> 15 then
          begin
            strErro := Format('Erro, linha: %i, bolas encontradas: %i', [uA + 1, qt_bolas_sorteadas]);
            Exit(False);
          end;

          sql_insert := sql_insert + bolas_sorteadas;
        end;

        // Analisar os campos:
        //     Campo                Índice
        // Arrecadacao_Total         [17]
        // Valor_Rateio_15_numeros   [25]
        // Valor_Rateio_14_numeros   [26]
        // Valor_Rateio_13_numeros   [27]
        // Valor_Rateio_12_numeros   [28]
        // Valor_Rateio_15_numeros   [29]
        // Acumulado_15_numeros      [30]
        // Estimativa_Premio         [31]
        // Valor_acumulado_premio    [32]
        17, 25..32:
        begin
          // Altera o ponto decimal pra o formato brasileiro
          numero_formato_brasileiro := DefaultFormatSettings;
          numero_formato_brasileiro.DecimalSeparator := ',';
          numero_formato_brasileiro.ThousandSeparator := '.';

          valor_coluna := AnsiReplaceText(texto_colunas[uB], '.', '');

          try
            valor_float := StrToFloat(valor_coluna, numero_formato_brasileiro);

          except
            On exc: EConvertError do
            begin
              // Altera o ponto decimal e milhar pra o formato definido anteriormente.
              strErro := Format('Erro: %s, linha: %i, Coluna: %i', [Exc.Message, uA + 1, uB + 1]);
              Exit(False);
            end;
          end;

          // Altera o ponto decimal e milhar pra o formato americano, pois
          // precisamos inserir o numero decimal no sql com o formato americano.
          numero_formato_americano := DefaultFormatSettings;
          numero_formato_americano.DecimalSeparator := '.';
          numero_formato_americano.ThousandSeparator := ',';

          // Insere o sql.
          sql_insert := sql_insert + ', ' + FloatToStr(valor_float, numero_formato_americano);
        end;

        // Analisar estes campos:
        // Ganhadores_15_numeros     [18]
        // Cidade                    [19]
        // UF                        [20]
        // Ganhadores_14_numeros     [21]
        // Ganhadores_13_numeros     [22]
        // Ganhadores_12_numeros     [23]
        // Ganhadores_11_numeros     [24]
        18, 21..24:
        begin
          try
            numero_bola := StrToInt(texto_colunas[uB]);
          except
            On exc: Exception do
            begin
              strErro := Exc.Message;
              Exit(False);
            end;
          end;
          sql_insert := sql_insert + ', ' + IntToStr(numero_bola);
        end;
      end;
    end;
    // Coloca o fecha parênteses.
    sql_insert := sql_insert + ')';

    // Após isto, iremos inserir no string
    lista_sql_insert.Add(sql_insert);
  end;
  lista_concurso.Clear;

  // Evitar quebra de linha no final do arquivo.
  lista_sql_insert.SkipLastLineBreak := True;
  lista_sql_insert.SaveToFile('lotofacil_resultado.sql');

  // Agora, iremos inserir os dados recebidos na tabela
  // 'lotofacil.lotofacil_resultado_importacao'.
  sql_lotofacil := TSqlQuery.Create(Self);

  // Apaga, a tabela primeiro.
  sql_lotofacil.Clear;
  sql_lotofacil.SQL.Text := 'Delete from lotofacil.lotofacil_resultado_importacao';

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  try
    sql_lotofacil.DataBase := dmLotofacil.pgLTK;
    sql_lotofacil.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_lotofacil.Close;
    dmLotofacil.pgLtk.Close(True);
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit(False);
    end;
  end;


  // Agora, inserir os dados.
  sql_lotofacil.Close;
  sql_lotofacil.SQL.Text := lista_sql_insert.Text;

  try
    sql_lotofacil.DataBase := dmLotofacil.pgLTK;
    sql_lotofacil.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_lotofacil.Close;
    dmLotofacil.pgLtk.Close(True);
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit(False);
    end;
  end;


  lista_sql_insert.Clear;
  FreeAndNil(lista_sql_insert);

  Exit(True);

end;

procedure TForm1.lotofacil_novos_repetidos_status(ltf_msg: string);
begin
  stxtNovosRepetidos.Caption := ltf_msg;
end;

procedure TForm1.lotofacil_novos_repetidos_status_atualizacao(ltf_id: longword;
  ltf_qt: byte);
begin

  Writeln('ltf_id: ', ltf_id);

end;

procedure TForm1.lotofacil_novos_repetidos_status_concluido(ltf_status: string);
begin
  btnAtualizarNovosRepetidos2.Enabled := True;
  btnPararDeAtualizarNovosRepetidos.Enabled := False;
  stxtNovosRepetidos.Caption := ltf_status;
end;

procedure TForm1.lotofacil_novos_repetidos_status_erro(ltf_erro: string);
begin
  btnAtualizarNovosRepetidos2.Enabled := True;
  btnPararDeAtualizarNovosRepetidos.Enabled := False;
  stxtNovosRepetidos.Caption := ltf_erro;
end;

{
 Ao clicar neste botão, iremos atualizar o controle 'sgrFiltros', conforme
 a data e hora do filtro selecionado, e depois iremos ocultar os campos
 que o usuário escolheu.
}
procedure TForm1.btnSelecionarClick(Sender: TObject);
var
  indice_data_selecionado, indice_hora_selecionado: integer;
  strFiltroData, strFiltroHora, strFiltroDataHora: string;
begin

  indice_data_selecionado := cmbFiltroData.ItemIndex;
  indice_hora_selecionado := cmbFiltroHora.ItemIndex;

  if (indice_data_selecionado <= -1) or (indice_hora_selecionado <= -1) then
  begin
    sgrFiltros.Columns.Clear;
    sgrFiltros.Columns.Add;
    sgrFiltros.RowCount := 1;
    sgrFiltros.Cells[0, 0] := 'Nenhum filtro selecionado';
    sgrFiltros.AutoSizeColumns;
    exit;
  end;

  strFiltroData := cmbFiltroData.Items[indice_data_selecionado];
  strFiltroHora := cmbFiltroHora.Items[indice_hora_selecionado];
  strFiltroDataHora := strFiltroData + ' ' + strFiltroHora;

  Atualizar_Controle_sgrFiltro(strFiltroDataHora);

  if cmbFiltroData.Items.Count = 0 then begin
    MessageDlg('', 'Nenhum registro localizado', mtInformation, [mbok], 0);
  end;
end;

procedure TForm1.Atualizar_Controle_sgrFiltro(strWhere_Data_Hora: string);
begin
  Configurar_Controle_sgrFiltro;
  Carregar_Controle_sgrFiltro(strWhere_Data_Hora);
end;

procedure TForm1.Carregar_Controle_sgrFiltro(strWhere_Data_Hora: string);
var
  sqlRegistros: TSqlQuery;
  qt_registros, uA, linha: integer;
  campo_nome: string;
begin
  if dmLotofacil = nil then
  begin
    dmLotofacil := tDmLotofacil.Create(Self);
  end;

  sqlRegistros := TSqlQuery.Create(Self);
  sqlRegistros.DataBase := DmLotofacil.pgLTK;
  sqlRegistros.Active := False;
  sqlRegistros.Close;

  sqlRegistros.Sql.Clear;
  sqlRegistros.Sql.Add('Select');
  for uA := 0 to High(lotofacil_filtro_campos) do
  begin
    if uA <> 0 then
    begin
      sqlRegistros.Sql.Add(', ');
    end;
    sqlRegistros.Sql.Add(lotofacil_filtro_campos[uA]);
  end;
  sqlRegistros.Sql.Add('from lotofacil.v_lotofacil_filtros');
  sqlRegistros.sql.Add('Where to_char(data,');
  sqlRegistros.Sql.Add(QuotedStr('dd-MM-YYYY HH24:MI:SS.US') + ')');
  sqlRegistros.Sql.Add('= ' + QuotedStr(strWhere_Data_Hora));
  sqlRegistros.SQL.Add('order by');
  sqlRegistros.SQL.Add('filtros_id asc,');
  sqlRegistros.Sql.Add('ltf_qt asc,');
  sqlRegistros.Sql.Add('qt_alt asc,');
  sqlRegistros.Sql.Add('qt_dif_1 asc,');
  sqlRegistros.Sql.Add('qt_dif_2 asc,');
  sqlRegistros.Sql.Add('qt_dif_3 asc,');
  sqlRegistros.Sql.Add('qt_dif_4 asc,');
  sqlRegistros.Sql.Add('qt_dif_5 asc,');
  sqlRegistros.Sql.Add('qt_dif_6 asc,');
  sqlRegistros.Sql.Add('qt_dif_7 asc,');
  sqlRegistros.Sql.Add('qt_dif_8 asc,');
  sqlRegistros.Sql.Add('qt_dif_9 asc,');
  sqlRegistros.Sql.Add('qt_dif_10 asc,');
  sqlRegistros.Sql.Add('qt_dif_11 asc');

  // Vamos abrir a consulta, e ir pra o primeiro registro e
  // em seguida, pra o último pra conseguirmos determinar
  // a quantidade de registros.
  sqlRegistros.Open;
  sqlRegistros.First;
  sqlRegistros.Last;
  qt_registros := sqlRegistros.RecordCount;

  if qt_registros = 0 then
  begin
    sgrFiltros.Columns.Clear;
    sgrFiltros.Columns.Add;
    sgrFiltros.RowCount := 1;
    sgrFiltros.Cells[0, 0] := 'Nenhum registro localizado';
    sgrFiltros.AutoSizeColumns;
    exit;
  end;

  // Um registro a mais, pois a primeira linha é o cabeçalho.
  sgrFiltros.RowCount := qt_registros + 1;

  // A variável lotofacil
  for uA := 0 to High(filtro_campos_selecionados) do
  begin
    sgrFiltros.Columns[uA].Visible := filtro_campos_selecionados[uA];
  end;

  linha := 1;
  sqlRegistros.First;
  while (not sqlRegistros.EOF) and (qt_registros > 0) do
  begin
    // Vamos percorrer todos os campos e também ocultar o campo
    // se o usuário não selecionou aquele campo.
    for uA := 0 to High(lotofacil_filtro_campos) do
    begin
      campo_nome := lotofacil_filtro_campos[uA];
      sgrFiltros.Cells[uA, linha] :=
        sqlRegistros.FieldByName(campo_nome).AsString;
    end;

    sqlRegistros.Next;
    Dec(qt_Registros);
    Inc(linha);
  end;
  sqlRegistros.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;

  sgrFiltros.AutoSizeColumns;
  sgrFiltros.FixedRows := 1;
end;

procedure TForm1.Configurar_Controle_sgrFiltro;
var
  qt_colunas, uA: integer;
  coluna_atual: TGridColumn;
begin
  // Apaga as colunas.
  sgrFiltros.Columns.Clear;
  sgrFiltros.RowCount := 1;

  qt_colunas := High(filtros_campos);
  for uA := 0 to qt_colunas do
  begin
    coluna_atual := sgrFiltros.Columns.Add;
    coluna_atual.Title.Caption := filtros_campos[uA];
    coluna_atual.Title.Alignment := TAlignment.taCenter;
    coluna_atual.Visible := filtro_campos_selecionados[uA];
  end;
  sgrFiltros.FixedRows := 1;
  sgrFiltros.AutoSizeColumns;
end;

{
 Toda vez que o controle 'cmbFiltroData', for atualizado, devemos
 atualizar o controle 'cmbFiltroHora'.
}
procedure TForm1.AtualizarFiltroData(Sender: TObject; strWhere: string);
var
  sqlRegistro: TSqlQuery;
  qt_registros: integer;
  objHora: TComboBox;
  objData: TComboBox;
begin
  if Sender = cmbFiltroData then
  begin
    objData := cmbFiltroData;
    objHora := cmbFiltroHora;
  end
  else
  if Sender = cmbAleatorioFiltroData then
  begin
    objData := cmbAleatorioFiltroData;
    objHora := cmbAleatorioFiltroHora;
  end;
  objHora.Items.Clear;

  // Sempre haverá um parte da hora, senão, indica erro.
  if strWhere = '' then
  begin
    objData.Items.Clear;
    exit;
  end;

  if dmLotofacil = nil then
  begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLTK;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Active := False;
  sqlRegistro.Close;

  sqlRegistro.SQL.Clear;

  if Sender = cmbFiltroData then
  begin
    sqlRegistro.Sql.Add('Select hora_1 from lotofacil.v_lotofacil_filtros_por_data_hora');
    sqlRegistro.Sql.Add('where to_char(data, ''DD-MM-YYYY'') = ' + QuotedStr(strWhere));
    sqlRegistro.Sql.Add('order by hora_1 desc');
  end
  else
  begin
    sqlRegistro.Sql.Add('Select hora_1 from lotofacil.v_lotofacil_aleatorio_por_data_hora');
    sqlRegistro.Sql.Add('where to_char(aleatorio_data, ''DD-MM-YYYY'') = ' +
      QuotedStr(strWhere));
    sqlRegistro.Sql.Add('order by hora_1 desc');
  end;

  try
    sqlRegistro.Open;

    sqlRegistro.First;
    while not sqlRegistro.EOF do
    begin
      objHora.Items.Add(sqlRegistro.FieldByName('hora_1').AsString);

      Inc(qt_registros);
      sqlRegistro.Next;
    end;
    sqlRegistro.Close;
    dmLotofacil.Free;
    dmLotofacil := nil;

  except
    On Exc: Exception do
    begin
      MessageDlg('Erro', Exc.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  if qt_registros = 0 then
  begin
    cmbFiltroData.Items.Clear;
    cmbFiltroHora.Items.Clear;
    exit;
  end;

  objHora.ItemIndex := 0;

end;

{
 Esta procedura é utilizada pelos controles 'btnVerificarAcertos' e
 'btnAleatorio_Verificar_Acertos'.
}
procedure TForm1.Verificar_Acertos(Sender: TObject);
var
  strFiltroData, strFiltroHora, strWhere, bola_concurso, strInsert_Set_Acerto,
  strWhere_data_hora, concursoSelecionado: string;
  indiceSelecionado, totalItens: integer;
  b_ha_itens, b_indice_selecionado: boolean;
  indice_data_selecionado: integer;
  indice_hora_selecionado: integer;

  sqlRegistros: TSQLQuery;
  qt_registros, uA, linha: integer;

  objData, objHora: TComboBox;
  obj_sgr_acertos: TStringGrid;
  obj_cmb_concurso: TComboBox;
begin
  if Sender = btnVerificarAcerto then
  begin
    objData := cmbFiltroData;
    objHora := cmbFiltroHora;
    obj_sgr_acertos := sgrVerificarAcertos;
    obj_cmb_concurso := cmbConcursoVerificarAcerto;
  end
  else
  if Sender = btnAleatorio_Verificar_Acerto then
  begin
    objData := cmbAleatorioFiltroData;
    objHora := cmbAleatorioFiltroHora;
    obj_sgr_acertos := sgrAleatorioVerificarAcertos;
    obj_cmb_concurso := cmbConcurso_Aleatorio_Verificar_Acerto;
  end;


  b_ha_itens := (objData.Items.Count > 0) and (objHora.Items.Count > 0);

  if not b_ha_itens then
  begin
    obj_sgr_acertos.Columns.Clear;
    obj_sgr_acertos.Columns.Add;
    obj_sgr_acertos.RowCount := 1;
    obj_sgr_acertos.Cells[0, 0] := 'Nenhum filtro disponível';
    obj_sgr_acertos.AutoSizeColumns;
    exit;
  end;

  indice_data_selecionado := objData.ItemIndex;
  indice_hora_selecionado := objHora.ItemIndex;
  b_indice_selecionado := (indice_data_selecionado >= 0) and
    (indice_hora_selecionado >= 0);

  if not b_indice_selecionado then
  begin
    obj_sgr_acertos.Columns.Clear;
    obj_sgr_acertos.Columns.Add;
    obj_sgr_acertos.RowCount := 1;
    obj_sgr_acertos.Cells[0, 0] := 'Data e hora não selecionados';
    obj_sgr_acertos.AutoSizeColumns;
    exit;
  end;

  strFiltroData := objData.Items[indice_data_selecionado];
  strFiltroHora := objHora.Items[indice_hora_selecionado];

  strWhere_data_hora := strFiltroData + ' ' + strFiltroHora;

  // Verificar se há concursos
  if obj_cmb_concurso.Items.Count = 0 then
  begin
    obj_sgr_acertos.Columns.Clear;
    obj_sgr_acertos.Columns.Add;
    obj_sgr_acertos.RowCount := 1;
    obj_sgr_acertos.Cells[0, 0] := 'Nenhum concurso disponível.';
    obj_sgr_acertos.AutoSizeColumns;
    ;
    Exit;
  end;

  // Vamos primeira recuperar as bolas que foram selecionadas
  // no concurso atual e em seguida, iremos atualizar somente
  // o filtro que está selecionado no momento.
  indiceSelecionado := obj_cmb_concurso.ItemIndex;
  if indiceSelecionado < 0 then
  begin
    obj_sgr_acertos.Columns.Clear;
    obj_sgr_acertos.Columns.Add;
    obj_sgr_acertos.RowCount := 1;
    obj_sgr_acertos.Cells[0, 0] := 'Nenhum concurso selecionado.';
    obj_sgr_acertos.AutoSizeColumns;
  end;

  concursoSelecionado := obj_cmb_concurso.Items[indiceSelecionado];

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistros := TSqlQuery.Create(Self);
  sqlRegistros.DataBase := dmLotofacil.pgLTK;
  sqlRegistros.Active := False;
  sqlRegistros.Close;

  sqlRegistros.Sql.Clear;
  sqlRegistros.SQL.Add('Select b_1, b_2, b_3, b_4, b_5,');
  sqlRegistros.Sql.Add('b_6, b_7, b_8, b_9, b_10,');
  sqlRegistros.Sql.Add('b_11, b_12, b_13, b_14, b_15');
  sqlRegistros.Sql.Add('from lotofacil.lotofacil_resultado_bolas');
  sqlRegistros.Sql.Add('where concurso = ' + concursoSelecionado);

  try
    sqlRegistros.Open;
    if sqlRegistros.EOF = True then
    begin
      sgrVerificarAcertos.Columns.Clear;
      sgrVerificarAcertos.Columns.Add;
      sgrVerificarAcertos.RowCount := 1;
      sgrVerificarAcertos.Cells[0, 0] := 'Concurso não localizado!!!';
      sgrVerificarAcertos.AutoSizeColumns;
      exit;
    end;
  except
    On Exc: Exception do
    begin
      MessageDlg('Erro', Exc.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  // Agora, iremos gerar o sql que realizará a contabilização de acertos
  // Isto, é bem simples, no banco de dados existe uma tabela chamada
  // lotofacil_num, nela cada bola, é identificada por um campo, por exemplo,
  // a bola 1, pelo campo num_1, a bola 25, pelo campo num_25.
  // Então, se aquela bola está na combinação, ela terá o valor 1, senão o valor 0.
  // Lógico que não podemos somar todos os campos pois sempre dar 15, 16, 17 ou 18,
  // conforme a quantidade de bolas.
  // Então, o que faremos é somar somente os campos das bolas correspondentes.
  // Por exemplo, se o concurso, saiu as bolas:
  // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
  // então, iremos somar os campos
  // num_1 + num_2 + num_3 + num_4 + num_5 +
  // num_6 + num_7 + num_8 + num_9 + num_10 +
  // num_11 + num_12 + num_13 + num_14 + num_15
  // de todas as combinações.
  // Assim, conseguimos saber a quantidade de acertos.

  // Pra atualizar o campo 'acertos', devemos pegar as bolas do concurso
  // selecionados, e no nosso caso, iremos prefixar a palavra
  // 'num_' pois iremos
  strInsert_Set_Acerto := '';
  for uA := 1 to 15 do
  begin
    bola_concurso := sqlRegistros.FieldByName('b_' + IntToStr(uA)).AsString;
    if uA <> 1 then
    begin
      strInsert_Set_Acerto := strInsert_Set_Acerto + ' + ';
    end;
    strInsert_Set_Acerto := strInsert_Set_Acerto + 'num_' + bola_concurso;
  end;
  sqlRegistros.Close;

  // Agora, iremos atualizar o campo acerto somente do filtro atual selecionado.
  if Sender = btnVerificarAcerto then
  begin

    sqlRegistros.Sql.Clear;
    sqlRegistros.Sql.Add('Update lotofacil.lotofacil_filtros');
    sqlRegistros.Sql.Add('set acertos = ');
    sqlRegistros.Sql.Add(strInsert_Set_Acerto);
    sqlRegistros.Sql.Add('from lotofacil.lotofacil_num');
    sqlRegistros.sql.Add('where lotofacil.lotofacil_filtros.ltf_id = ');
    sqlRegistros.Sql.Add('lotofacil.lotofacil_num.ltf_id');
    sqlRegistros.sql.Add('And to_char(data,');
    sqlRegistros.Sql.Add(QuotedStr('dd-MM-YYYY HH24:MI:SS.US') + ')');
    sqlRegistros.Sql.Add('= ' + QuotedStr(strWhere_data_hora));
    Writeln(sqlRegistros.SQL.Text);

  end
  else
  begin

    sqlRegistros.Sql.Clear;
    sqlRegistros.Sql.Add('Update lotofacil.lotofacil_aleatorio');
    sqlRegistros.Sql.Add('set acertos = ');
    sqlRegistros.Sql.Add(strInsert_Set_Acerto);
    sqlRegistros.Sql.Add('from lotofacil.lotofacil_num');
    sqlRegistros.sql.Add('where lotofacil.lotofacil_aleatorio.ltf_id = ');
    sqlRegistros.Sql.Add('lotofacil.lotofacil_num.ltf_id');
    sqlRegistros.sql.Add('And to_char(aleatorio_data,');
    sqlRegistros.Sql.Add(QuotedStr('dd-MM-YYYY HH24:MI:SS.US') + ')');
    sqlRegistros.Sql.Add('= ' + QuotedStr(strWhere_data_hora));
    Writeln(sqlRegistros.SQL.Text);

  end;

  // Vamos executar e realizar o commit.
  try
    sqlRegistros.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sqlRegistros.Close;
  except
    On exc: EDataBaseError do
    begin
      sgrVerificarAcertos.Columns.Clear;
      sgrVerificarAcertos.Columns.Add;
      sgrVerificarAcertos.RowCount := 1;
      sgrVerificarAcertos.Cells[0, 0] := Exc.Message;
      sgrVerificarAcertos.AutoSizeColumns;
      exit;
    end;
  end;

  if Sender = btnVerificarAcerto then
  begin

    // Agora, exibe o registro atualizado.
    sqlRegistros.SQL.Clear;
    sqlRegistros.SQL.Add('Select acertos, qt_vezes');
    sqlRegistros.Sql.Add('from lotofacil.v_lotofacil_filtros_acertos_por_data_hora');
    sqlRegistros.SQL.Add('where to_char(data,');
    sqlRegistros.Sql.Add(QuotedStr('dd-MM-YYYY HH24:MI:SS.US') + ')');
    sqlRegistros.Sql.Add('= ' + QuotedStr(strWhere_data_hora));
    sqlRegistros.Sql.Add('order by acertos asc');

  end
  else
  if Sender = btnAleatorio_Verificar_Acerto then
  begin

    // Agora, exibe o registro atualizado.
    sqlRegistros.SQL.Clear;
    sqlRegistros.SQL.Add('Select acertos, qt_vezes');
    sqlRegistros.Sql.Add('from lotofacil.v_lotofacil_aleatorio_acertos_por_data_hora');
    sqlRegistros.SQL.Add('where to_char(aleatorio_data,');
    sqlRegistros.Sql.Add(QuotedStr('dd-MM-YYYY HH24:MI:SS.US') + ')');
    sqlRegistros.Sql.Add('= ' + QuotedStr(strWhere_data_hora));
    sqlRegistros.Sql.Add('order by acertos asc');

  end
  else
  begin
    MessageDlg('Erro', 'Este controle não está configurado pra esta função',
      mtError, [mbOK], 0);
    Exit;
  end;

  try
    sqlRegistros.Open;
    sqlRegistros.First;
    if sqlRegistros.EOF = True then
    begin
      sgrVerificarAcertos.Columns.Clear;
      sgrVerificarAcertos.Columns.Add;
      sgrVerificarAcertos.RowCount := 1;
      sgrVerificarAcertos.Cells[0, 0] := 'Não há registros.';
      sgrVerificarAcertos.AutoSizeColumns;
      exit;
    end;
  except
    On Exc: Exception do
    begin
      MessageDlg('Erro', Exc.Message, mtError, [mbOK], 0);
      Exit;
    end;
  end;

  // Configura o controle pra receber dados.
  obj_sgr_acertos.Columns.Clear;
  obj_sgr_acertos.Columns.Add;
  obj_sgr_acertos.Columns.Add;
  obj_sgr_acertos.RowCount := 1;
  obj_sgr_acertos.Columns[0].Title.Caption := 'Acertos';
  obj_sgr_acertos.Columns[1].Title.Caption := 'Qt_vezes';
  obj_sgr_acertos.FixedRows := 1;


  linha := 1;
  qt_registros := 0;
  while not sqlRegistros.EOF do
  begin
    obj_sgr_acertos.RowCount := obj_sgr_acertos.RowCount + 1;
    obj_sgr_acertos.Cells[0, linha] := sqlRegistros.FieldByName('acertos').AsString;
    obj_sgr_acertos.Cells[1, linha] := sqlRegistros.FieldByName('qt_vezes').AsString;

    sqlRegistros.Next;
    Inc(linha);
  end;

  sqlRegistros.Close;
  dmLotofacil.Free;
  dmLotofacil := nil;
end;


{
 Aqui, iremos verificar o número de acertos baseado no concurso selecionado.
}
procedure TForm1.btnVerificarAcertoClick(Sender: TObject);
var
  strFiltroData, strFiltroHora, strWhere, bola_concurso, strInsert_Set_Acerto,
  strWhere_data_hora, concursoSelecionado: string;
  indiceSelecionado, totalItens: integer;
  b_ha_itens, b_indice_selecionado: boolean;
  indice_data_selecionado: integer;
  indice_hora_selecionado: integer;

  sqlRegistros: TSQLQuery;
  qt_registros, uA, linha: integer;
begin
  Verificar_Acertos(Sender);
end;

procedure TForm1.btnAtualizarNovosRepetidos2Click(Sender: TObject);
var
  concurso_numero, indice_cmb_novos_repetidos: integer;
begin
  if Assigned(ltf_novos_repetidos) then begin
    FreeAndNil(ltf_novos_repetidos);
  end;

  ltf_novos_repetidos := TLotofacilNovosRepetidos.Create(Self, True);
  ltf_novos_repetidos.OnStatusErro := @lotofacil_novos_repetidos_status_erro;
  ltf_novos_repetidos.OnStatusAtualizacao := @lotofacil_novos_repetidos_status_atualizacao;
  ltf_novos_repetidos.OnStatus := @lotofacil_novos_repetidos_status;
  ltf_novos_repetidos.OnStatusConcluido := @lotofacil_novos_repetidos_status_concluido;

  indice_cmb_novos_repetidos := cmbConcursoNovosRepetidos.ItemIndex;
  if indice_cmb_novos_repetidos <= -1 then
  begin
    MessageDlg('Erro', 'Nenhum concurso selecionado', TMsgDlgtype.mtError, [mbOK], 0);
    Exit;
  end;

  stxtNovosRepetidos.Caption := '';


  concurso_numero := StrToInt(cmbConcursoNovosRepetidos.Items[indice_cmb_novos_repetidos]);
  ltf_novos_repetidos.atualizar(concurso_numero);
  ltf_novos_repetidos.Start;

  btnAtualizarNovosRepetidos2.Enabled := False;
  btnPararDeAtualizarNovosRepetidos.Enabled := True;

end;

procedure TForm1.chkExibirCamposClickCheck(Sender: TObject);
var
  indiceSelecionado: integer;
begin
  indiceSelecionado := chkExibirCampos.ItemIndex;
  if indiceSelecionado >= 0 then
  begin
    filtro_campos_selecionados[indiceSelecionado] :=
      chkExibirCampos.Checked[indiceSelecionado];
    if sgrFiltros.Columns.Count = Length(filtro_campos_selecionados) then
    begin
      sgrFiltros.Columns[indiceSelecionado].Visible :=
        filtro_campos_selecionados[indiceSelecionado];
    end;
  end;
end;

procedure TForm1.cmbAinda_Nao_Saiu_MaximoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

procedure TForm1.cmbAinda_Nao_Saiu_MinimoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

{
 Valida a entrada do usuário.
}
procedure TForm1.Verificar_Controle_Frequencia_Minimo_Maximo(Sender: TObject);
var
  qt_ainda_nao_saiu_minimo, qt_ainda_nao_saiu_maximo, qt_deixou_de_sair_minimo,
  qt_deixou_de_sair_maximo, qt_novo_minimo, qt_novo_maximo,
  qt_repetindo_minimo, qt_repetindo_maximo, indice_minimo, indice_maximo: integer;
  objControle_Minimo: TComboBox;
  objControle_Maximo: TComboBox;
  valor_minimo, valor_maximo: integer;
begin
  qt_ainda_nao_saiu_minimo := 0;
  qt_ainda_nao_saiu_maximo := 0;
  qt_deixou_de_sair_minimo := 0;
  qt_deixou_de_sair_maximo := 0;
  qt_novo_minimo := 0;
  qt_novo_maximo := 0;
  qt_repetindo_minimo := 0;
  qt_repetindo_maximo := 0;

  if (Sender = cmbAinda_Nao_Saiu_Minimo) or (Sender = cmbAinda_Nao_Saiu_Maximo) then
  begin
    objControle_Minimo := cmbAinda_Nao_Saiu_Minimo;
    objControle_Maximo := cmbAinda_Nao_Saiu_Maximo;
  end
  else
  if (Sender = cmbDeixou_de_Sair_Minimo) or (Sender = cmbDeixou_de_Sair_Maximo) then
  begin
    objControle_Minimo := cmbDeixou_de_Sair_Minimo;
    objControle_Maximo := cmbDeixou_de_Sair_Maximo;
  end
  else
  if (Sender = cmbNovo_Minimo) or (Sender = cmbNovo_Maximo) then
  begin
    objControle_Minimo := cmbNovo_Minimo;
    objControle_Maximo := cmbNovo_Maximo;
  end
  else
  if (Sender = cmbRepetindo_Minimo) or (Sender = cmbRepetindo_Maximo) then
  begin
    objControle_Minimo := cmbRepetindo_Minimo;
    objControle_Maximo := cmbRepetindo_Maximo;
  end;

  // Em seguida, verifica se o valor mínimo é maior que o valor máximo.
  indice_minimo := objControle_Minimo.ItemIndex;
  indice_maximo := objControle_Maximo.ItemIndex;

  if (indice_minimo > -1) and (indice_maximo > -1) then
  begin
    valor_minimo := StrToInt(objControle_Minimo.Items[indice_minimo]);
    valor_maximo := StrToInt(objControle_Maximo.Items[indice_maximo]);

    // Verifica se valor mínimo é maior que máximo, se sim, fazer
    // com que máximo seja igual a mínimo.
    if valor_minimo > valor_maximo then
    begin
      // Localizar o índice onde está o valor mínimo dentro da caixa de combinação
      // máximo e define este índice como o índice selecionado.
      indice_maximo := objControle_Maximo.Items.IndexOf(IntToStr(valor_minimo));
      objControle_Maximo.ItemIndex := indice_maximo;
    end;
  end;
end;

procedure TForm1.cmbAleatorioFiltroDataChange(Sender: TObject);
var
  strData: ansistring;
  indiceSelecionado: integer;
begin
  indiceSelecionado := cmbAleatorioFiltroData.ItemIndex;
  if indiceSelecionado >= 0 then
  begin
    strData := cmbAleatorioFiltroData.Items[indiceSelecionado];
    AtualizarFiltroData(cmbAleatorioFiltroData, strData);
  end;
end;

procedure TForm1.cmbAlgarismo_na_dezena_consolidado_concurso_finalChange(Sender : TObject);
begin
  Algarismo_na_dezena_consolidado_concurso_inicial_final_alterou;
end;

procedure TForm1.cmbAlgarismo_na_dezena_consolidado_concurso_inicialChange(Sender : TObject);
begin
  Algarismo_na_dezena_consolidado_concurso_inicial_final_alterou;
end;

{
 Atualiza o controle PrimoNaoPrimoConsolidadoConcurso toda vez que
 o controle cmbPrimoNaoPrimoConsolidadoConcursoInicial ou cmbPrimoNaoprimoConsolidadoConcursoFinal
 for alterado.
}
procedure TForm1.Algarismo_na_dezena_consolidado_concurso_inicial_final_alterou;
var
  indice_concurso_inicial, indice_concurso_final: integer;
  concurso_inicial, concurso_final: integer;
begin
  indice_concurso_inicial := cmbAlgarismo_na_dezena_consolidado_concurso_inicial.ItemIndex;
  indice_concurso_final := cmbAlgarismo_na_dezena_consolidado_concurso_final.ItemIndex;

  if (indice_concurso_inicial > -1) and (indice_concurso_final > -1) then
  begin
    concurso_inicial := StrToInt(cmbAlgarismo_na_dezena_consolidado_concurso_inicial.Items[indice_concurso_inicial]);
    concurso_final := StrToInt(cmbAlgarismo_na_dezena_consolidado_concurso_Final.Items[indice_concurso_final]);
    Carregar_algarismo_na_dezena_consolidado_intervalo_concurso(sgrAlgarismo_na_dezena_consolidado,
                                                                                                      concurso_inicial,
                                                                                                      concurso_final);
  end;
end;

//{
// Neste caso, o controle sgrFrequenciaNaoSair, terá as bolas marcadas que não
// devem sair nos jogos.
// Então, antes de atualizar a caixa de combinação devemos pegar as frequências
// das bolas.
//}
//procedure TForm1.cmbConcursoFrequenciaNaoSairChange(Sender : TObject);
//var
//  frequencia_antes_de_atualizar: array[1..25] of AnsiString;
//  ultimaColuna , uA: Integer;
//begin

//end;

{
 Toda vez que o usuário altera o número do concurso devemos pegar
 quais foram as bolas selecionadas, antes de atualizar o controle, em seguida,
 devemos atualizar o controle com as novas bolas.
}
procedure TForm1.cmbConcursoFrequenciaSairChange(Sender: TObject);
var
  frequencia_antes_de_atualizar: array[1..25] of ansistring;
  ultimaColuna, uA: integer;
begin
  // Se não há 25 linhas + 1 linha de cabeçalho, devemos atualizar o controle.
  if sgrFrequencia_Bolas_Sair_Nao_Sair.RowCount < 26 then
  begin
    CarregarFrequenciaPorConcurso(sgrFrequencia_Bolas_Sair_Nao_Sair);
    exit;
  end;

  // Pega a frequência das bolas antes de atualizar, pois ao atualizar o controle,
  // a frequência será perdida.
  ultimaColuna := sgrFrequencia_Bolas_Sair_Nao_Sair.Columns.Count - 1;
  for uA := 1 to 25 do
  begin
    frequencia_antes_de_atualizar[StrToInt(
      sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[0, uA])] :=
      sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultimaColuna, uA];
  end;

  CarregarFrequenciaPorConcurso(sgrFrequencia_Bolas_Sair_Nao_Sair);

  if sgrFrequencia_Bolas_Sair_Nao_Sair.RowCount < 26 then
  begin
    CarregarFrequenciaPorConcurso(sgrFrequencia_Bolas_Sair_Nao_Sair);
    exit;
  end;

  // Atualizar o controle com a frequência que estava antes.
  for uA := 1 to 25 do
  begin
    sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultimaColuna, uA] :=
      frequencia_antes_de_atualizar[StrToInt(
      sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[0, uA])];
  end;

  AtualizarControleFrequenciaMinimoMaximo;
end;

{
 Toda vez que o usuário altera o número do concurso devemos atualizar o controle
 sgrFrequenciaTotalSair.
}
procedure TForm1.cmbConcursoFrequenciaTotalSairChange(Sender: TObject);
var
  frequencia_antes_de_atualizar: array[1..25] of ansistring;
  ultimaColuna, uA: integer;
  bolaAtual: longint;
begin
  // Se o controle está vazio, devemos atualizar, isto pode acontecer,
  // se por exemplo, atualizarmos inserindo novos concursos, então
  if sgrFrequenciaTotalSair.RowCount < 26 then
  begin
    CarregarConcursoFrequenciaTotalSair;
    exit;
  end;

  // Devemos pegar a frequência que foram marcadas, antes de atualizar
  // o controle 'sgrConcursoFrequenciaTotalSair'.
  ultimaColuna := sgrFrequenciaTotalSair.Columns.Count - 1;
  for uA := 1 to 25 do
  begin
    // A coluna 0, tem o número da bola e a última coluna tem o valor 1 ou 0
    // conforme usuário marcou ou não a bola.
    frequencia_antes_de_atualizar[StrToInt(sgrFrequenciaTotalSair.Cells[0, uA])]
    :=
      sgrFrequenciaTotalSair.Cells[ultimaColuna, uA];
  end;

  CarregarConcursoFrequenciaTotalSair;

  // Atualizar o controle com a frequência que havia antes.
  // Só iremos atualizar, se houver dados.
  // Quando há dados, deve haver, 1 linha pra o cabeçalho e mais 1 linha pra
  // cada bola.
  if sgrFrequenciaTotalSair.RowCount = 26 then
  begin
    for uA := 1 to 25 do
    begin
      // Agora, iremos atualizar a última coluna com o valor que foi armazenado
      // no arranjo frequencia_antes_de_atualizar.
      // Pra isto devemos saber qual é a bola da primeira coluna, em seguida,
      // acessar o arranjo 'frequencia_antes_de_atualizar' com o valor desta bola
      // como índice.;
      bolaAtual := StrToInt(sgrFrequenciaTotalSair.Cells[0, uA]);
      sgrFrequenciaTotalSair.Cells[ultimaColuna, uA] :=
        frequencia_antes_de_atualizar[bolaAtual];
    end;
  end;

end;

procedure TForm1.cmbDeixou_de_Sair_MaximoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

procedure TForm1.cmbDeixou_de_Sair_MinimoChange(Sender: TObject);
begin
  Verificar_Controle_Frequencia_Minimo_Maximo(Sender);
end;

procedure TForm1.cmbExternoInternoConsolidadoConcursoFinalChange(Sender: TObject);
begin
  ExternoInternoConsolidadoConcursoInicialFinalAlterou;
end;

procedure TForm1.cmbExternoInternoConsolidadoConcursoInicialChange(Sender: TObject);
begin
  ExternoInternoConsolidadoConcursoInicialFinalAlterou;
end;

procedure TForm1.ExternoInternoConsolidadoConcursoInicialFinalAlterou;
var
  indice_concurso_inicial, indice_concurso_final: integer;
  concurso_inicial, concurso_final: integer;
begin
  indice_concurso_inicial := cmbExternoInternoConsolidadoConcursoInicial.ItemIndex;
  indice_concurso_final := cmbExternoInternoConsolidadoConcursoFinal.ItemIndex;

  if (indice_concurso_inicial > -1) and (indice_concurso_final > -1) then
  begin
    concurso_inicial := StrToInt(
      cmbExternoInternoConsolidadoConcursoInicial.Items[indice_concurso_inicial]);
    concurso_final := StrToInt(
      cmbExternoInternoConsolidadoConcursoFinal.Items[indice_concurso_final]);

    CarregarExternoInternoConsolidadoIntervaloConcurso(sgrExternoInternoConsolidado,
      concurso_inicial, concurso_final);
  end;
end;



{
 Toda vez que o usuário alterar o valor da data, devemos atualizar o campo de hora.
}
procedure TForm1.cmbFiltroDataChange(Sender: TObject);
var
  strData: ansistring;
  indiceSelecionado: integer;
begin
  indiceSelecionado := cmbFiltroData.ItemIndex;
  if indiceSelecionado >= 0 then
  begin
    strData := cmbFiltroData.Items[indiceSelecionado];
    AtualizarFiltroData(cmbFiltroData, strData);
  end;
end;

procedure TForm1.btnGrupo2BolasMarcarTodosClick(Sender: TObject);
begin
  MarcarGrupo2Bolas;
end;


procedure TForm1.MarcarGrupo2Bolas;
var
  uLinha, indiceMarcar: integer;
begin
  CarregarGrupo2Bolas;

  indiceMarcar := sgrGrupo2Bolas.Columns.Count - 1;
  for uLinha := 1 to sgrGrupo2Bolas.RowCount - 1 do
  begin
    sgrGrupo2Bolas.Cells[indiceMarcar, uLinha] := '1';
  end;
end;

{
 Este procedimento é chamando quando o usuário deseja excluir um concurso na
 tabela lotofacil_resultado
 }
procedure TForm1.btnLotofacilResultadoExcluirClick(Sender: TObject);
var
  strData: string;
  uA, bolasEscolhidas: integer;
  qtRegistros: longint;
  strSql: TStringList;
  sqlRegistro: TSqlQuery;
  uConcurso: integer;

begin
  // Garante que haja concurso pra deletar.
  if cmbConcursoDeletar.Items.Count = 0 then
  begin
    MessageDlg('', 'Não há nenhum concurso pra excluir',
      tMsgDlgType.mtError, [mbOK], 0);
    exit;
  end;

  // Pega o concurso selecionado.
  uConcurso := StrToInt(cmbConcursoDeletar.Items[cmbConcursoDeletar.ItemIndex]);

  // Aparece uma mensagem indicando se realmente o usuário deseja deletar o concurso.
  if MessageDlg('', 'Deseja realmente excluir o concurso ' +
    IntToStr(uConcurso) + '???', TMsgDlgType.mtConfirmation,
    [mbYes, mbNo], 0) = mrNo then
  begin
    // Se a resposta é não, iremos retornar, não precisamos implementar o sim
    // pois senão deveriamos ter uma condição if enorme.
    exit;
  end;

  // Se chegarmos aqui, quer dizer, que devemos excluir o concurso.

  // Cria o objeto se não existe.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;
  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Active := False;


  sqlRegistro.SQL.Clear;
  sqlRegistro.Sql.Add('Delete from lotofacil.lotofacil_resultado_num');
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
    on Exc: EDataBaseError do
    begin
      MessageDlg('Erro', 'Erro: ' + Exc.Message, TMsgDlgType.mtError, [mbOK], 0);
    end;
  end;

  // Atualiza todos os controles que recupera informações do banco de dados.
  CarregarTodosControles;
end;

{
 Este procedimento gera o sql das opções escolhidas pelo usuário.
 Praticamente, é o mais importante do sistema.
 }
procedure TForm1.btnFiltroGerarClick(Sender: TObject);
  procedure DeletarSqlTabela(var lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas: TStrings;
    nome_da_tabela: AnsiString);
    var
      indice_a_deletar , uA: Integer;
    begin
      indice_a_deletar := lista_de_tabelas_selecionadas.IndexOf(nome_da_tabela);
      if indice_a_deletar > -1 then begin
         lista_de_tabelas_selecionadas.Delete(indice_a_deletar);
      end;

      // Agora, da lista de tabelas relacionadas.
      uA := 0;
      while uA < lista_de_tabelas_relacionadas.Count do begin
        if AnsiContainsStr(lista_de_tabelas_relacionadas.Strings[uA], nome_da_tabela) then
        begin
          lista_de_tabelas_relacionadas.Delete(uA);
          continue;
        end;
        Inc(uA);
      end;
    end;
const
  tabelas_usadas : array[1..9] of string = (
                 'lotofacil.lotofacil_num',
                 'lotofacil.lotofacil_bolas',
                 'lotofacil.lotofacil_novos_repetidos',
                 'lotofacil.lotofacil_num_bolas_concurso',
                 'lotofacil.lotofacil_diferenca_entre_bolas',
                 'lotofacil.lotofacil_id',
                 'lotofacil.lotofacil_soma',
                 'lotofacil.v_lotofacil_num_nao_sorteado',
                 'lotofacil.lotofacil_coluna_b'
                 );
var
  sqlNovosRepetidos: ansistring;
  sqlParImpar: ansistring;
  sqlExternoInterno: ansistring;
  sqlPrimoNaoPrimo, sqlColunaB, sqlTemp, sqlLotofacilSoma, sql_b1_a_b15: string;
  sqlFrequencia: ansistring;
  sqlDiferenca_qt_dif: ansistring;
  sqlDiferenca_qt_alt: ansistring;
  sqlBolas_por_posicao: ansiString;
  sqlAlgarismo_na_dezena: ansiString;
  sql_bolas_na_mesma_coluna: ansiString;

  sqlGerado: TStringList;
  uA, limite_aleatorio, uB, indice_a_deletar: integer;
  total_registros: longint;
  deslocamento_inicial: int64;

  // Armazena tabelas usadas na consulta.
  lista_de_tabelas_selecionadas : TSTrings;

  // Armazena o relacionamento entre os campos das tabelas.
  lista_de_tabelas_relacionadas : TStrings;

  // Armazena os nomes dos campos no select
  lista_campo_select: TStrings;
  lista_campo_insert: TStrings;

  // Armazena as clausulas dos sql gerado dinamicamente.
  lista_where : TStrings;


begin
  // Se ocorrer um erro dentro de alguma das funções, indicar pra o usuário.
  strErro := '';

  sqlNovosRepetidos := GerarSqlNovosRepetidos;
  sqlParImpar := GerarSqlParImpar;
  sqlExternoInterno := GerarSqlExternoInterno;
  sqlPrimoNaoPrimo := GerarSqlPrimo;
  sqlColunaB := GerarSqlColunaB;
  sqlFrequencia := GerarSqlFrequencia;
  sqlDiferenca_qt_dif := GerarSqlDiferenca_qt_dif;
  sqlDiferenca_qt_alt := GerarSqlDiferenca_qt_alt;
  sqlLotofacilSoma := GerarSqlLotofacilSoma;
  sqlBolas_Por_Posicao := GerarSqlBolas_Por_Posicao;
  sqlAlgarismo_na_dezena := Gerar_sql_algarismo_na_dezena;
  sql_bolas_na_mesma_coluna:= ulotofacil_bolas_na_mesma_coluna.Gerar_sql_bolas_na_mesma_coluna(sgrBolas_na_mesma_coluna);
  sql_b1_a_b15 := Gerar_sql_b1_a_b15;

  if strErro <> '' then
  begin
    MessageDlg('Erro', 'Erro: ' + strErro, mtError, [mbOK], 0);
    Exit;
  end;

  // Inicializa as listas;
  lista_campo_insert := TStringList.Create;
  lista_campo_select := TStringList.Create;
  lista_de_tabelas_relacionadas := TStringList.Create;
  lista_de_tabelas_selecionadas := TStringList.Create;
  lista_where := TStringList.Create;

  // Apaga as listas.
  lista_campo_insert.Clear;
  lista_campo_select.Clear;
  lista_de_tabelas_relacionadas.Clear;
  lista_de_tabelas_selecionadas.Clear;
  lista_where.Clear;

  // Gerar sql.
  sqlGerado := TStringList.Create;
  sqlGerado.Add('Insert into lotofacil.lotofacil_filtros');

  //sqlGerado.Add('(data,');
  //sqlGerado.Add('ltf_id,');
  //sqlGerado.Add('ltf_qt,');
  //sqlGerado.Add('concurso,');
  //sqlGerado.Add('acertos,');

  // Insere os campos do insert que são fixos.
  lista_campo_insert.Add('data');
  lista_campo_insert.Add('ltf_id');
  lista_campo_insert.Add('ltf_qt');
  lista_campo_insert.Add('concurso');
  lista_campo_insert.Add('acertos');

  // Insere os campos correspondentes do select que corresponde ao insert.
  lista_campo_select.Add('Now()');                                        // data
  lista_campo_select.Add('lotofacil.lotofacil_num.ltf_id');               // ltf_id
  lista_campo_select.Add('lotofacil.lotofacil_num.ltf_qt');               // ltf_qt
  lista_campo_select.Add(QuotedStr(cmbConcursoNovosRepetidos.Text));      // concurso
  lista_campo_select.Add('0');                                            // acertos


  //if sqlNovosRepetidos <> '' then
  //begin
  //  sqlGerado.Add('novos_repetidos_id_alternado,');
  //  sqlGerado.Add('novos_repetidos_id,');
  //end;

  {TODO: Verificar se deixa este campo na tabela. }
  // sqlGerado.Add('qt_alt_seq,');
  //sqlGerado.Add('concurso_soma_frequencia_bolas)');
  //sqlGerado.Add('Select now(),');
  //sqlGerado.Add('tb_ltf_num.ltf_id,');
  //sqlGerado.Add('tb_ltf_num.ltf_qt,');
  //sqlGerado.Add(QuotedStr(cmbConcursoNovosRepetidos.Text) + ',');
  //// Número do concurso.
  //sqlGerado.Add('0,');
  // Quantidade de acertos.

  // Iremos relaciona um tabela com todas as outras tabelas
  // Depois, em código posteriores iremos retirar desta lista, relacionamento entre tabelas
  // desnecessários, por exemplo, se o usuário não seleciona
  // nenhuma informação da tabela de soma, então, não é necessário
  // fazer este relacionamento

  lista_de_tabelas_relacionadas := TStringList.Create;
  lista_de_tabelas_relacionadas.Clear;
  for uA := 1 to High(tabelas_usadas) do begin
    for uB := uA + 1 to High(tabelas_usadas) do begin
      lista_de_tabelas_relacionadas.Add('AND ' + tabelas_usadas[uA] + '.ltf_id = ' + tabelas_usadas[uB] + '.ltf_id');
    end;
  end;

  lista_de_tabelas_selecionadas := TSTringList.Create;
  for uA := 1 to Length(tabelas_usadas) do
  begin
       lista_de_tabelas_selecionadas.Add(tabelas_usadas[uA]);
  end;

  // No caso do campo 'novos_repetidos_id_alternado' e 'novos_repetidos_id_alternado'
  // a cada concurso, um identificador de novos x repetidos pode ser
  // diferente, por este motivo, iremos sempre incluir este campo no filtro.
  lista_campo_insert.Add('novos_repetidos_id_alternado');
  lista_campo_select.Add('novos_repetidos_id_alternado');
  lista_campo_insert.Add('novos_repetidos_id');
  lista_campo_select.Add('novos_repetidos_id');

  // Se o usuário marcou que somente algumas combinações de novos x repetidos
  // deve sair devemos filtrar isto.
  if sqlNovosRepetidos <> '' then begin
    lista_where.Add('AND ' + sqlNovosRepetidos);
  end;

  // Verifica se o usuaŕio escolheu novos x repetidos.
  //if sqlNovosRepetidos <> '' then begin
  //  lista_campo_insert.Add('novos_repetidos_id_alternado');
  //  lista_campo_select.Add('novos_repetidos_id_alternado');
  //
  //  lista_campo_insert.Add('novos_repetidos_id');
  //  lista_campo_select.Add('novos_repetidos_id');
  //
  //  lista_where.Add('AND ' + sqlNovosRepetidos);
  //
  //end else begin
  //
  //
  //
  //  //DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas, 'lotofacil_novos_repetidos');
  //
  //  //// Neste caso, devemos retirar a tabela da lista de tabelas selecionadas.
  //  //indice_a_deletar := lista_de_tabelas_selecionadas.IndexOf('lotofacil.lotofacil_novos_repetidos');
  //  //if indice_a_deletar > -1 then begin
  //  //   lista_de_tabelas_selecionadas.Delete(indice_a_deletar);
  //  //end;
  //  //
  //  //// Agora, da lista de tabelas relacionadas.
  //  //uA := 0;
  //  //while uA < lista_de_tabelas_relacionadas.Count do
  //  //begin
  //  //  if AnsiContainsStr(lista_de_tabelas_relacionadas.Strings[uA], 'lotofacil.lotofacil_novos_repetidos') then
  //  //  begin
  //  //    lista_de_tabelas_relacionadas.Delete(uA);
  //  //    continue;
  //  //  end;
  //  //  Inc(uA);
  //  //end;
  //
  //end;

  //if sqlNovosRepetidos <> '' then
  //begin
  //  sqlGerado.Add('novos_repetidos_id_alternado,');
  //  sqlGerado.Add('novos_repetidos_id,');
  //end;

  {TODO: Verificar se deixa este campo na tabela. }
  //sqlGerado.Add('qt_alt_seq,');

  lista_campo_insert.Add('concurso_soma_frequencia_bolas');
  lista_campo_select.Add('concurso_soma_frequencia_bolas');


  //sqlGerado.Add('concurso_soma_frequencia_bolas');
  //sqlGerado.Add('from');

  // Será utilizado as tabelas abaixo:
  // lotofacil_num
  // lotofacil_id
  // lotofacil_num_bolas_concurso
  // lotofacil_diferenca_entre_bolas
  // lotofacil_soma
  // lotofacil_bolas

  // Algumas tabelas serão fixas e outras serão adicionadas à consulta
  // se o usuário selecionou os campos correspondentes.


  //sqlGerado.Add('lotofacil.lotofacil_num                   tb_ltf_num,');
  //sqlGerado.Add('lotofacil.lotofacil_id                    tb_ltf_id,');
  //sqlGerado.Add('lotofacil.lotofacil_num_bolas_concurso    tb_num_bolas_concurso,');
  //sqlGerado.Add('lotofacil.lotofacil_diferenca_entre_bolas tb_ltf_dif');

  if sqlBolas_por_posicao <> '' then
  begin
    lista_where.Add('AND ' + sqlBolas_por_posicao);
  end else
  begin
    DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas, 'lotofacil.lotofacil_bolas');

    //// Neste caso, devemos retirar a tabela 'lotofacil.lotofacil_bolas' tanto
    //// da lista de tabelas selecionadas, tanto da lista de tabelas relacionadas.
    //indice_a_deletar := lista_de_tabelas_selecionadas.IndexOf('lotofacil.lotofacil_bolas');
    //if indice_a_deletar > -1 then begin
    //   lista_de_tabelas_selecionadas.Delete(indice_a_deletar);
    //end;
    //
    //// Agora, da lista de tabelas relacionadas.
    //uA := 0;
    //while uA < lista_de_tabelas_relacionadas.Count do
    //begin
    //  if AnsiContainsStr(lista_de_tabelas_relacionadas.Strings[uA], 'lotofacil.lotofacil_bolas') then
    //  begin
    //    lista_de_tabelas_relacionadas.Delete(uA);
    //    continue;
    //  end;
    //  Inc(uA);
    //end;

  end;;

  //if sqlBolas_por_posicao <> '' then begin
  //  sqlGerado.Add('lotofacil.lotofacil_bolas ltf_bolas');
  //end;
  //
  if sqlAlgarismo_na_dezena <> '' then begin
    lista_where.Add('and ' + sqlAlgarismo_na_dezena);
  end;

  if sql_b1_a_b15 <> '' then begin
    lista_where.Add('and ' + sql_b1_a_b15);
  end
  else begin
    DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas, 'lotofacil.lotofacil_coluna_b');
  end;

  IF sqlLotofacilSoma <> '' then begin
    lista_where.Add('and ' + sqlLotofacilSoma);
  end else
  begin
    DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas, 'lotofacil.lotofacil_soma');

    //// Apaga a tabela da lista select e também apagar do relacionamento entre tabelas.
    //indice_a_deletar := lista_de_tabelas_selecionadas.IndexOf('lotofacil.lotofacil_soma');
    //if indice_a_deletar > -1 then begin
    //  lista_de_tabelas_selecionadas.Delete(indice_a_deletar);
    //end;
    //
    //// Agora, da lista de tabelas relacionadas.
    //uA := 0;
    //while uA < lista_de_tabelas_relacionadas.Count do begin
    //  if AnsiContainsStr(lista_de_tabelas_relacionadas.Strings[uA], 'lotofacil.lotofacil_soma') then
    //  begin
    //    lista_de_tabelas_relacionadas.Delete(uA);
    //    continue;
    //  end;
    //  Inc(uA);
    //end;
  end;

  // A view lotofacil.v_lotofacil_num_nao_sorteado indica todas
  // as combinações ainda não sorteadas.
  // Se o usuário marcar, então, iremos pegar somente combinações
  // que ainda não saíram, entretanto, devemos pegar todas as combinações
  if chkExcluir_Jogos_Ja_Sorteados.Checked[0] = false then
  begin
    // Se é falso, ou seja, usuário não marcou, devemos retirar o relacionamento where entre a view
    // com as demais tabelas.
    DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas, 'lotofacil.v_lotofacil_num_nao_sorteado');

    //// Apaga a tabela da lista select e também apagar do relacionamento entre tabelas.
    //indice_a_deletar := lista_de_tabelas_selecionadas.IndexOf('lotofacil.v_lotofacil_num_nao_sorteado');
    //if indice_a_deletar > -1 then begin
    //  lista_de_tabelas_selecionadas.Delete(indice_a_deletar);
    //end;
    //
    //// Agora, da lista de tabelas relacionadas.
    //uA := 0;
    //while uA < lista_de_tabelas_relacionadas.Count do begin
    //  if AnsiContainsStr(lista_de_tabelas_relacionadas.Strings[uA], 'lotofacil.v_lotofacil_num_nao_sorteado') then
    //  begin
    //    lista_de_tabelas_relacionadas.Delete(uA);
    //    continue;
    //  end;
    //  Inc(uA);
    //end;
  end;

  //if sqlLotofacilSoma <> '' then
  //begin
  //  ;
  //  sqlGerado.Add(', lotofacil.lotofacil_soma tb_ltf_soma');
  //end;
  // Se o usuário selecionou quer não quer exibir combinados já sorteadas, devemos
  // listar a tabela.
  //if chkExcluir_Jogos_Ja_Sorteados.Checked[0] = True then
  //begin
  //  sqlGerado.Add(', lotofacil.v_lotofacil_num_nao_sorteado  tb_ltf_nao_sorteado');
  //end;

  //if sqlNovosRepetidos <> '' then
  //begin
  //  sqlGerado.Add(', lotofacil.lotofacil_novos_repetidos     tb_ltf_novos_repetidos');
  //end;

  // Devemos relacionar as tabelas
  // lotofacil_num, lotofacil_id, lotofacil_diferenca_entre_bolas,
  // lotofacil_novos_repetidos e v_lotofacil_num_nao_sorteado.

  //sqlGerado.Add('where');
  //sqlGerado.Add('    tb_ltf_num.ltf_id = tb_ltf_id.ltf_id');
  //sqlGerado.Add('AND tb_ltf_num.ltf_id = tb_ltf_dif.ltf_id');
  //sqlGerado.add('AND tb_ltf_id.ltf_id = tb_ltf_dif.ltf_id');
  //
  //sqlGerado.Add('AND tb_num_bolas_concurso.ltf_id = tb_ltf_num.ltf_id');
  //sqlGerado.Add('AND tb_num_bolas_concurso.ltf_id = tb_ltf_id.ltf_id');
  //sqlGerado.Add('AND tb_num_bolas_concurso.ltf_id = tb_ltf_dif.ltf_id');

  // Se o usuário deseja excluir combinações já sorteadas, devemos relacionar
  // a tabela de novos e repetidos com as outras tabelas.
  //if chkExcluir_Jogos_Ja_Sorteados.Checked[0] = True then
  //begin
  //  sqlGerado.Add('---[Usuário escolheu excluir combinações já sorteadas]----');
  //  sqlGerado.Add('AND tb_ltf_num.ltf_id  = tb_ltf_nao_sorteado.ltf_id');
  //  sqlGerado.Add('AND tb_ltf_id.ltf_id   = tb_ltf_nao_sorteado.ltf_id');
  //  sqlGerado.Add('AND tb_ltf_dif.ltf_id  = tb_ltf_nao_sorteado.ltf_id');
  //  sqlGerado.Add('AND tb_num_bolas_concurso.ltf_id = tb_ltf_nao_sorteado.ltf_id');
  //
  //  if sqlNovosRepetidos <> '' then
  //  begin
  //    sqlGerado.Add('AND tb_ltf_novos_repetidos.ltf_id = tb_ltf_nao_sorteado.ltf_id');
  //  end;
  //end;

  if sqlParImpar <> '' then
  begin
    lista_where.Add('AND ' + sqlParImpar);
  end;

  if sqlPrimoNaoPrimo <> '' then
  begin
    lista_where.Add('AND ' + sqlPrimoNaoPrimo);
  end;

  if sqlExternoInterno <> '' then
  begin
    lista_where.Add('AND ' + sqlExternoInterno);
  end;

  if sqlColunaB <> '' then
  begin
    lista_where.Add('AND ' + sqlColunaB);
  end;

  if sql_bolas_na_mesma_coluna <> '' then
  begin
    lista_where.Add('AND ' + sql_bolas_na_mesma_coluna);
  end;

  if sqlFrequencia <> '' then
  begin
    lista_where.Add('AND ' + sqlFrequencia);
  end;

  // O controle 'chkExcluirJogo_LTF_QT' terá 4 checkbox, correspondendo a
  // jogos que excluídos conforme a quantidade de bolas daquela combinação.
  sqlTemp := '';
  for uA := 0 to chkExcluirJogos_LTF_QT.Items.Count - 1 do
  begin
    if chkExcluirJogos_LTF_QT.Checked[uA] = True then
    begin
      if sqlTemp <> '' then
      begin
        sqlTemp := sqlTemp + ', ';
      end;
      sqlTemp := sqlTemp + IntToStr(15 + uA);
    end;
    // Se sqlTemp é diferente de vazio, quer dizer, que devemos excluir algumas
    // combinações baseado na quantidade de bolas.
  end;

  // Se houve algo selecionados, devemos retornar ao usuário.
  if sqlTemp <> '' then
  begin
    lista_where.Add('And lotofacil.lotofacil_num.ltf_qt not in (' + sqlTemp + ')');
  end;

  if sqlDiferenca_qt_alt <> '' then
  begin
    // sqlGerado.Add('And ' + sqlDiferenca_qt_alt);
    lista_where.Add('And ' + sqlDiferenca_qt_alt);
  end;

  if sqlDiferenca_qt_dif <> '' then
  begin
    // sqlGerado.Add('And ' + sqlDiferenca_qt_dif);
    lista_where.Add('And ' + sqlDiferenca_qt_dif);
  end;

  // Se os dois strings está vazio, quer dizer que a tabela não está sendo utilizada.
  if (sqldiferenca_qt_alt = '') and (sqldiferenca_qt_dif = '') then begin
    DeletarSqlTabela(lista_de_tabelas_selecionadas, lista_de_tabelas_relacionadas, 'lotofacil.lotofacil_diferenca_entre_bolas');
  end;

  // Agora montar o sql dinamicamente.
  sqlGerado := TStringList.Create;
  sqlGerado.Clear;
  sqlGerado.Add('Insert into lotofacil.lotofacil_filtros(');

  lista_campo_insert.Delimiter := ',';
  sqlGerado.Add(lista_campo_insert.DelimitedText);
  sqlGerado.Add(')');

  sqlGerado.Add('Select');
  lista_campo_select.Delimiter := ',';
  sqlGerado.Add(lista_campo_select.DelimitedText);

  sqlGerado.Add('from ');
  lista_de_tabelas_selecionadas.Delimiter := ',';
  sqlGerado.Add(lista_de_tabelas_selecionadas.DelimitedText);

  sqlGerado.Add('where');

  // Na lista de tabelas relacionadas devemos apagar o primeiro and
  if lista_de_tabelas_relacionadas.Count > 0 then begin
    lista_de_tabelas_relacionadas.Strings[0] := LowerCase(lista_de_tabelas_relacionadas.Strings[0]).TrimLeft('and');
    lista_de_tabelas_relacionadas.Strings[0] := lista_de_tabelas_relacionadas.Strings[0].Trim;
  end;
  sqlGerado.Add(lista_de_tabelas_relacionadas.Text);
  sqlGerado.Add(lista_where.Text);

  // Ordenar sempre pelo campos abaixo.
  sqlGerado.Add('order by');
  sqlGerado.Add('ltf_qt asc');
  sqlGerado.Add(', concurso_soma_frequencia_bolas desc');

  sqlGerado.Add(', novos_repetidos_id_alternado');

  try
    total_registros := StrToInt(Trim(mskTotalRegistros.Text));
    if total_registros > 0 then
    begin
      sqlGerado.Add('LIMIT ' + IntToStr(total_registros));

      // No controle 'rdDeslocamento' o índice 0 corresponde a opção
      // aleatório.
      if rdDeslocamento.ItemIndex = 0 then
      begin
        limite_aleatorio := StrToInt(mskDeslocamento.Text);
        deslocamento_inicial := Random(limite_aleatorio);
      end
      else
      if rdDeslocamento.ItemIndex = 1 then
      begin
        deslocamento_inicial := StrToInt(mskDeslocamento.Text);
      end;
      sqlGerado.Add('OFFSET ' + IntToStr(deslocamento_inicial));
    end;
  except
  end;

  mmFiltroSql.Clear;
  mmFiltroSql.Lines.AddStrings(sqlGerado);

  // TODO: Descomentar código abaixo, após teste.
  InserirNovoFiltro(sqlGerado);
end;

procedure TForm1.InserirNovoFiltro(sqlFiltro: TStringList);
var
  sqlRegistros: TSqlQuery;
begin
  if dmLotofacil = nil then
  begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sqlRegistros := TSqlQuery.Create(Self);
  sqlRegistros.Database := dmLotofacil.pgLTK;

  sqlRegistros.Active := False;
  sqlRegistros.Close;
  sqlRegistros.SQL.Clear;
  sqlRegistros.Sql.Text := sqlFiltro.Text;

  try
    sqlRegistros.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sqlRegistros.Close;
  except
    on Exc: EDatabaseError do
    begin
      MessageDlg('Erro', Exc.Message, TMsgDlgType.mtError, [mbOK], 0);
      exit;
    end;
  end;

  MessageDlg('', 'Filtros gerados com sucesso!!!', TMsgDlgType.mtError, [mbOK], 0);
end;

procedure TForm1.btnFrequenciaAtualizarClick(Sender: TObject);
begin
  AtualizarFrequenciaBolas;
end;

procedure TForm1.btnGeradorAleatorioComFiltroClick(Sender: TObject);
var
  lotofacil_ltf_id: integer;
begin
  lotofacil_ltf_id := identificador_grupo_16_bolas(
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16);
  Writeln('id: ', lotofacil_ltf_id);

  lotofacil_ltf_id := identificador_grupo_17_bolas(9, 10, 11, 12, 13,
    14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25);
  Writeln('id: ', lotofacil_ltf_id);

end;

procedure TForm1.btnGeradorAleatorioSemFiltroClick(Sender: TObject);
type
  TGerador_Etapa = (ANTES_DE_GERAR,
    ETAPA_ZERO,
    ETAPA_UM,
    ETAPA_DOIS,
    ETAPA_TRES,
    ETAPA_QUATRO,
    ETAPA_CINCO,
    ETAPA_SEIS,
    ETAPA_SETE,
    ETAPA_OITO,
    ETAPA_NOVE,
    ETAPA_DEZ
    );
var
  lotofacil_numeros: array[0..25] of integer;

  lista_sql, lista_lotofacil: TStringList;

  bolas_por_combinacao: integer;
  bolas_fixas: integer;
  bolas_nao_fixas, uA, indice_combinacao_principal, indice_combinacao,
  indice_coluna, indice_coluna_controle, indice_linha_controle, uC,
  indice_combinacao_2, qt_repetidos, indice_linha_controle_2,
  qt_de_combinacoes: integer;

  gerador_etapa: TGerador_Etapa;

  lotofacil_combinacoes: array of array of integer;
  indice_lista, bola_numero: longint;
  coluna_atual: TGridColumn;

  lista_nao_fixa_origem_str, lista_nao_fixa_destino_str, lista_fixa_str,
  lista_numeros: TStringList;
begin
  // Obtém a quantidade de bolas por combinacao
  if rdGerador_Quantidade_de_Bolas.ItemIndex < 0 then
  begin
    MessageDlg('Vc deve escolher uma quantidadade de bolas: [15 a 18]',
      mtError, [mbOK], 0);
    Exit;
  end;

  bolas_por_combinacao := 15 + rdGerador_Quantidade_de_Bolas.ItemIndex;
  if bolas_por_combinacao > 18 then
  begin
    MessageDlg('Vc deve escolher uma quantidadade de bolas: [15 a 18]',
      mtError, [mbOK], 0);
    Exit;
  end;

  qt_de_combinacoes := spinGerador_Combinacoes.Value;

  //if Gerar_Lotofacil_Aleatorio(lotofacil_combinacoes, bolas_por_combinacao,
  //  qt_de_combinacoes) = False then
  //begin
  //  MessageDlg('Erro', strErro, mtError, [mbOK], 0);
  //  Exit;
  //end;

  if Gerar_Lotofacil_Aleatorio_Novo(lotofacil_combinacoes, bolas_por_combinacao,
    qt_de_combinacoes) = False then
  begin
    MessageDlg('Erro', strErro, mtError, [mbOK], 0);
    Exit;
  end;


  // Agora, gravar, no banco de dados, na tabela 'lotofacil_aleatorio_temporario';
  Inserir_Aleatorio_Temporario(lotofacil_combinacoes, bolas_por_combinacao);
  //Exit;


  //lista_lotofacil.SkipLastLineBreak := True;
  //lista_lotofacil.SaveToFile('teste_lotofacil.csv');

  sgrGeradorAleatorio.Columns.Clear;
  coluna_atual := sgrGeradorAleatorio.Columns.Add;
  coluna_atual.Title.Caption := '#';
  coluna_atual.Title.Alignment := taCenter;
  coluna_atual.Alignment := taCenter;

  for uA := 1 to bolas_por_combinacao do begin
    coluna_atual := sgrGeradorAleatorio.Columns.Add;
    coluna_atual.Title.Caption := 'b' + IntToStr(uA);
    coluna_atual.Title.Alignment := taCenter;
    coluna_atual.Alignment := taCenter;
  end;

  indice_linha_controle := 1;
  sgrGeradorAleatorio.FixedRows := 1;
  sgrGeradorAleatorio.RowCount := qt_de_combinacoes + 1;

  for indice_combinacao := 0 to Pred(qt_de_combinacoes) do
  begin
    for indice_coluna_controle := 1 to bolas_por_combinacao do
    begin
      sgrGeradorAleatorio.Cells[indice_coluna_controle, indice_linha_controle] := IntToStr(lotofacil_combinacoes[indice_combinacao, indice_coluna_controle]);
    end;
    Inc(indice_linha_controle);
  end;

  indice_linha_controle := 1;
  for indice_combinacao := 0 to Pred(qt_de_combinacoes) do
  begin
    indice_linha_controle := indice_combinacao + 1;
    indice_linha_controle_2 := indice_linha_controle + 1;
    for indice_combinacao_2 := indice_combinacao + 1 to Pred(qt_de_combinacoes) do
    begin
      qt_repetidos := 0;
      for indice_coluna_controle := 1 to bolas_por_combinacao do
      begin
        if sgrGeradorAleatorio.Cells[indice_coluna_controle, indice_linha_controle] =
           sgrGeradorAleatorio.Cells[indice_coluna_controle, indice_linha_controle_2] then
        begin
          Inc(qt_repetidos);
        end;
      end;
      if qt_repetidos = bolas_por_combinacao then
      begin
        sgrGeradorAleatorio.Cells[0, indice_linha_controle_2] := 'REPETIDOS';
      end;
      Inc(indice_linha_controle_2);
    end;
    Inc(indice_linha_controle);
  end;

  sgrGeradorAleatorio.AutoSizeColumns;


end;


{
 Retorna true, se dados estão corretos.
}
function TForm1.Gerar_Lotofacil_Aleatorio(
  var lotofacil_aleatorio: TAleatorio_Resultado; bolas_por_combinacao: integer;
  qt_de_combinacoes: integer): boolean;
const
  lotofacil_qualquer: array[1..15] of integer = (
    2, 4, 5, 6, 7, 12, 14, 15, 17, 20, 21, 22, 23, 24, 25

    );
type
  TGerador_Etapa = (ANTES_DE_GERAR,
    ETAPA_ZERO,
    ETAPA_UM,
    ETAPA_DOIS,
    ETAPA_TRES,
    ETAPA_QUATRO,
    ETAPA_CINCO,
    ETAPA_SEIS,
    ETAPA_SETE,
    ETAPA_OITO,
    ETAPA_NOVE,
    ETAPA_DEZ
    );
var
  bolas_fixas, bolas_nao_fixas, indice_combinacao, uA, indice_coluna, indice_a_ser_gerado: integer;
  lista_numeros, lista_fixa, lista_nao_fixa_origem, lista_nao_fixa_destino: TStringList;
  lotofacil_numeros: array[0..25] of integer;
  gerador_etapa: TGerador_Etapa;
  indice_lista, bola_numero: longint;
begin
  // Validar entrada.
  if not bolas_por_combinacao in [15..18] then
  begin
    strErro := Format('Erro, bolas_por_combinacao: %d.' + #1013 +
      'Intervalo válido é: [15 a 18]', [bolas_por_combinacao]);
    Exit(False);
  end;
  if qt_de_combinacoes <= 0 then
  begin
    strErro := Format('Erro, qt_de_combinacoes: %d. ' + #1013 +
      'Valor deve ser maior que zero.', [qt_de_combinacoes]);
    Exit(False);
  end;
  if not Assigned(lotofacil_aleatorio) then
  begin
    SetLength(lotofacil_aleatorio, qt_de_combinacoes, 26);
  end;

  // Define a quantidade de bolas fixas e não_fixas conforme a quantidade de
  // bolas por combinação.
  case bolas_por_combinacao of
    15:
    begin
      bolas_fixas := 10;
      bolas_nao_fixas := 5;
    end;
    16:
    begin
      bolas_fixas := 9;
      bolas_nao_fixas := 7;
    end;
    17:
    begin
      bolas_fixas := 8;
      bolas_nao_fixas := 9;
    end;
    18:
    begin
      bolas_fixas := 7;
      bolas_nao_fixas := 11;
    end;
  end;

  lista_numeros := TStringList.Create;
  lista_fixa := TStringList.Create;
  lista_nao_fixa_origem := TStringList.Create;
  lista_nao_fixa_destino := TStringList.Create;


  gerador_etapa := ANTES_DE_GERAR;

  indice_combinacao := 0;
  indice_a_ser_gerado := 0;

  while indice_combinacao <= Pred(qt_de_combinacoes) do
  begin

    case gerador_etapa of
      ANTES_DE_GERAR:
        // Nesta etapa, iremos gerar aleatoriamente, a primeira combinação
        // Esta estapa, é iterada somente uma vez.
      begin
        // Adiciona os números à lista, pra posterior sorteio.
        lista_numeros.Clear;
        for uA := 1 to 25 do
        begin
          lista_numeros.Add(IntToStr(uA));
        end;

        // Zera a variável.
        FillChar(lotofacil_numeros, 26 * sizeof(integer), 0);

        // Vamos gerar aleatoriamente, a primeira combinação,
        // O número do índice do arranjo lotofacil_numeros é igual ao
        // número da bola, então, se a bola for escolhida, a célula
        // deste arranjo terá o valor 1, senão zero.
        Randomize;
        for uA := 1 to bolas_por_combinacao do
        begin

          indice_lista := Random(lista_numeros.Count);
          bola_numero := StrToInt(lista_numeros.Strings[indice_lista]);
          lista_numeros.Delete(indice_lista);

          lotofacil_numeros[bola_numero] := 1;
        end;


        FillChar(lotofacil_numeros, 26 * sizeof(integer), 0);
        for uA := 1 to 15 do begin
          bola_numero := lotofacil_qualquer[uA];
          lotofacil_numeros[bola_numero] := 1;
        end;


        // Em seguida, devemos pegar as bolas sorteadas aleatoriamente
        // e posicionar as bolas em ordem crescente dentro do arranjo
        // lotofacil_aleatorio.
        indice_coluna := 1;
        for uA := 1 to 25 do
        begin
          if lotofacil_numeros[uA] = 1 then
          begin
            lotofacil_aleatorio[0, indice_coluna] := uA;
            Inc(indice_coluna);
          end;
        end;
        gerador_etapa := ETAPA_ZERO;
        continue;
      end;

      // Na etapa zero, obtermos a lista de fixo e não fixo.
      // Pra isto, iremos considerar a última combinação gerada
      // pra basear a lista de fixa e não fixo.
      ETAPA_ZERO:
      begin
        lista_fixa.Clear;
        lista_nao_fixa_origem.Clear;
        lista_nao_fixa_destino.Clear;

        // Zera sempre a variável.
        FillChar(lotofacil_numeros, 26 * sizeof(integer), 0);

        // Percorre a última combinação gerada e obtém os números sorteados.
        for uA := 1 to bolas_por_combinacao do
        begin
          bola_numero := lotofacil_aleatorio[indice_a_ser_gerado, uA];
          lotofacil_numeros[bola_numero] := 1;
        end;
        Inc(indice_a_ser_gerado);

        // Obtém a lista fixa e não fixa.
        for uA := 1 to 25 do
        begin
          if lotofacil_numeros[uA] = 1 then
          begin
            lista_nao_fixa_origem.Add(IntToStr(uA));
          end
          else
          begin
            lista_fixa.Add(IntToStr(uA));
          end;
        end;

        gerador_etapa := ETAPA_UM;
        continue;
      end;

      // Na etapa 1, geramos o derivado da combinação principal.
      ETAPA_UM, ETAPA_DOIS, ETAPA_TRES, ETAPA_QUATRO, ETAPA_CINCO,
      ETAPA_SEIS, ETAPA_SETE, ETAPA_OITO, ETAPA_NOVE, ETAPA_DEZ:
      begin
        Inc(indice_combinacao);
        if indice_combinacao >= qt_de_combinacoes then
          break;

        // A próxima combinação é composta da lista fixa e não-fixa,
        // entretanto, pode ocorrer da lista não-fixa, ser menor
        // que a quantidade de bolas nao fixas, neste caso, devemos
        // completá-la.
        // Pra resolver isto, pegas as bolas que faltam da lista
        // não-fixa destino, pois, toda vez que retiramos um ítem
        // da lista não-fixa origem, ela é enviada pra lista não-fixa destino.
        // Por este motivo, que existe duas lista de não-fixas, uma de origem
        // e uma de destino.
        while lista_nao_fixa_origem.Count < bolas_nao_fixas do
        begin
          indice_lista := Random(lista_nao_fixa_destino.Count);
          bola_numero := StrToInt(lista_nao_fixa_destino.Strings[indice_lista]);

          // Move a bola da lista de destino pra lista de origem.
          lista_nao_fixa_destino.Delete(indice_lista);
          lista_nao_fixa_origem.add(IntToStr(bola_numero));
        end;

        // Zera o arranjo.
        FillChar(lotofacil_numeros, 26 * SizeOf(integer), 0);

        // Pega as bolas fixas.
        for uA := 0 to Pred(bolas_fixas) do
        begin
          bola_numero := StrToInt(lista_fixa.Strings[uA]);
          lotofacil_numeros[bola_numero] := 1;
        end;

        // Pega as bolas não-fixas.
        for uA := 0 to Pred(bolas_nao_fixas) do
        begin

          indice_lista := Random(lista_nao_fixa_origem.Count);
          bola_numero := StrToInt(lista_nao_fixa_origem.Strings[indice_lista]);

          // Move a bola da lista não-fixa origem pra lista não-fixa destino.
          lista_nao_fixa_origem.Delete(indice_lista);
          lista_nao_fixa_destino.Add(IntToStr(bola_numero));

          lotofacil_numeros[bola_numero] := 1;
        end;

        indice_coluna := 1;
        for uA := 1 to 25 do
        begin
          if lotofacil_numeros[uA] = 1 then
          begin
            lotofacil_aleatorio[indice_combinacao, indice_coluna] := uA;
            Inc(indice_coluna);
          end;
        end;

        case gerador_etapa of
          ETAPA_UM: gerador_etapa := ETAPA_DOIS;
          ETAPA_DOIS: gerador_etapa := ETAPA_TRES;
          ETAPA_TRES: gerador_etapa := ETAPA_ZERO;
                    {
                    ETAPA_TRES: gerador_etapa := ETAPA_QUATRO;
                    ETAPA_QUATRO : gerador_etapa := ETAPA_CINCO;
                    ETAPA_CINCO  : gerador_etapa := ETAPA_SEIS;
                    ETAPA_SEIS   : gerador_etapa := ETAPA_SETE;
                    ETAPA_SETE   : gerador_etapa := ETAPA_OITO;
                    ETAPA_OITO   : gerador_etapa := ETAPA_NOVE;
                    ETAPA_NOVE   : gerador_etapa := ETAPA_DEZ;
                    ETAPA_DEZ    : gerador_etapa := ANTES_DE_GERAR;
                    }
        end;
        continue;
      end;
    end;
  end;

end;

{
 Na procedure abaixo, iremos gerar combinações derivadas das bolas do concurso escolhido pelo usuário.
 As derivações serão baseadas nas bolas novas e repetidas, por exemplo, se o usuário escolher que quer
 derivar 10 bolas e 5 repetidas, iremos gerar a combinação das bolas do concurso atual com 10 bolas novas
 e 5 bolas repetidas, se vc observar, que geramos 15 bolas, 5 bolas é do concurso escolhido pelo usuário.
 Entretanto, 10 bolas do concurso não foi escolhida por isto, iremos gerar mais 2 concursos.
 Então, haverá sempre 3 combinações, a primeira, é a derivação da combinação do concurso atual conforme
 a quantidade de novos x repetidos, em seguida, devemos gerar as outras combinações complementares da
 combinação derivada que foi gerada.
 Um detalhe a observar, que há 11 combinações de novos x repetidos, então, se o usuário selecionar mais de uma
 combinação, a cada derivação iremos pegar a próxima combinação de novos x repetidos, ao terminar todas as combinações
 de novos x repetidos, recomeçamos do início, a vantagem desta abordagem é que conseguimos gerar todas
 as combinações derivadas de todas as combinações escolhidas pelo usuário junto com os complementares destas
 derivações.
}


function TForm1.Gerar_Lotofacil_Aleatorio_Novo(
  var lotofacil_aleatorio: TAleatorio_Resultado; bolas_por_combinacao: integer;
  qt_de_combinacoes: integer): boolean;
const
  lotofacil_qualquer: array[1..15] of integer = (
    2, 4, 5, 6, 7, 12, 14, 15, 17, 20, 21, 22, 23, 24, 25
    );
  lotofacil_ultima_combinacao_gerada: array[1..25] of Integer = (
    2, 4, 5, 6, 7, 12, 14, 15, 17, 20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  );
type
  TGerador_Etapa = (
    GERAR_DERIVADO,
    ANTES_DE_GERAR_COMPLEMENTAR,
    COMPLEMENTAR_1,
    COMPLEMENTAR_2,
    COMPLEMENTAR_3,
    ANTES_DE_GERAR,
    ETAPA_ZERO,
    ETAPA_UM,
    ETAPA_DOIS,
    ETAPA_TRES,
    ETAPA_QUATRO,
    ETAPA_CINCO,
    ETAPA_SEIS,
    ETAPA_SETE,
    ETAPA_OITO,
    ETAPA_NOVE,
    ETAPA_DEZ
    );
var
  bolas_fixas, bolas_nao_fixas, indice_combinacao, uA, indice_coluna, indice_a_ser_gerado,
    indice_novos_repetidos, indice_final_novos_repetidos, qt_novos, qt_repetidos, diferenca_de_bolas: integer;
  lista_numeros, lista_fixa, lista_nao_fixa_origem, lista_nao_fixa_destino, lista_de_novos,
    lista_de_repetidos: TStringList;
  lotofacil_numeros: array[0..25] of integer;
  lotofacil_bolas_selecionadas: array[0..25] of Integer;
  gerador_etapa: TGerador_Etapa;
  indice_lista, bola_numero, indice_bola_numero: longint;
  lotofacil_novos_repetidos: array[1..1] of Integer = (10);
begin
  // Validar entrada.
  if not bolas_por_combinacao in [15..18] then
  begin
    strErro := Format('Erro, bolas_por_combinacao: %d.' + #1013 +
      'Intervalo válido é: [15 a 18]', [bolas_por_combinacao]);
    Exit(False);
  end;
  if qt_de_combinacoes <= 0 then
  begin
    strErro := Format('Erro, qt_de_combinacoes: %d. ' + #1013 +
      'Valor deve ser maior que zero.', [qt_de_combinacoes]);
    Exit(False);
  end;
  if not Assigned(lotofacil_aleatorio) then
  begin
    SetLength(lotofacil_aleatorio, qt_de_combinacoes, 26);
  end;

  // No código abaixo, será gerado as combinações:
  // "Combinação derivada", que é a combinação gerada baseada na quantidade de novos x repetidos das bolas escolhidas
  // pelo usuário de um concurso específico;
  // "3 combinações complementares à combinação derivada que foi gerada", onde em todas as 3 combinações,
  // haverá todas as bolas que não está na combinação derivada mais as bolas da combinação derivada distribuída nas três
  // combinações.
  // Segue-exemplo:
  // Bolas do concurso:           1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15;
  // Combinação derivada:        16, 17, 18, 19, 20, 21, 22, 23, 24, 25,  1,  2,  3,  4,  5
  // Combinação complementares:   [Bolas que não estão na combinação derivada + 5 bolas repetidas neste caso]
  // Combinação complementar 1:   [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
  // Combinação complementar 2:   [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 21, 22, 23, 24, 25]
  // Combinação complementar 3:   [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1, 2, 3, 4, 5, 6]
  // Aqui, as bolas estão em ordem crescente, entretanto, ao gerar as combinações derivadas as bolas serão escolhidas
  // aleatoriamente, pode acontecer, como no exemplo, algum dos complementares ser igual à combinação do concurso,
  // mas provavelmente, isto será raro.
  // Deve-se observar, que se houver combinações duplicadas, somente um das combinações ficará disponível.
  // Observe que após gerarmos as combinações deve-se aplicar o filtro pra selecionar somente as melhores combinações
  // com provável chance de ser sorteada.
  // O gerador é bem inteligente, ao invés de gerar combinações em que não tem alguma relação com a combinação, este
  // gerador gera cada combinação, onde a combinação anterior tem alguma relação com a combinação que foi gerada.

  // Neste gerador, haverá uma lista fixa e duas listas não-fixas, uma chamada lista_nao_fixa_origem e, a outra, lista_nao_fixa_destino.
  // Na lista fixa, haverá as bolas que são novas em relação a combinação derivada e que se repetirá nas combinações complementares.
  // Na lista nao_fixa_origem, haverá as bolas que iremos selecionar pra completar cada combinação complementar, a cada bola
  // selecionada da lista nao_fixa_origem, esta bola será retirada desta lista e será inserida na lista_nao_fixa_destino.
  // Se ao tentar completar a combinação complementar, não houver nenhuma bola na lista nao_fixa_origem, iremos pegar as bolas
  // que faltam da lista_nao_fixa_destino.
  // Na lista nao_fixa_destino, armazenará todas as bolas que já foram utilizadas pra completar cada combinação complementar.



  // Define a quantidade de bolas fixas e não_fixas conforme a quantidade de
  // bolas por combinação.
  case bolas_por_combinacao of
    15:
    begin
      bolas_fixas := 10;
      bolas_nao_fixas := 5;
    end;
    16:
    begin
      bolas_fixas := 9;
      bolas_nao_fixas := 7;
    end;
    17:
    begin
      bolas_fixas := 8;
      bolas_nao_fixas := 9;
    end;
    18:
    begin
      bolas_fixas := 7;
      bolas_nao_fixas := 11;
    end;
  end;

  lista_numeros := TStringList.Create;
  lista_fixa := TStringList.Create;
  lista_nao_fixa_origem := TStringList.Create;
  lista_nao_fixa_destino := TStringList.Create;

  indice_novos_repetidos := 1;
  indice_final_novos_repetidos := High(lotofacil_novos_repetidos);

  gerador_etapa := GERAR_DERIVADO;

  indice_combinacao := 0;
  indice_a_ser_gerado := 0;

  while indice_combinacao <= Pred(qt_de_combinacoes) do
  begin

    case gerador_etapa of
      // Gera o número derivado do concurso que foi escolhido,
      // considerando a quantidade de bolas novas x repetidas escolhida,
      // há 11 combinações de novos x repetidos, então, o usuário pode escolher de 1 a 11 combinações
      GERAR_DERIVADO:
      begin
        // A cada iteração do loop, neste estado, pega a próxima quantidade de novos
        // que o usuário escolheu.
        qt_novos := lotofacil_novos_repetidos[indice_novos_repetidos];
        Inc(indice_novos_repetidos);
        if indice_novos_repetidos > indice_final_novos_repetidos then
        begin
          indice_novos_repetidos := 1;
        end;

        // Zera a variável antes de utilizar.
        FillChar(lotofacil_bolas_selecionadas, 26 * sizeof(integer), 0);

        // Marcar no arranjo, o valor 1, se a bola está no concurso.
        // Há sempre 15 bolas no concurso.
        for uA := 1 to 15 do
        begin
          // bola_numero := lotofacil_qualquer[uA];
          bola_numero := lotofacil_ultima_combinacao_gerada[uA];
          // Verifica se a bola está na faixa válida.
          if not((bola_numero >= 1) and (bola_numero <= 25)) then
          begin
            Exit(False);
          end;
          // Terá o valor 1, se a bola saiu no concurso.
          lotofacil_bolas_selecionadas[bola_numero] := 1;
        end;

        // Em seguida, identifica quais bolas são repetidas e quais não são.
        lista_de_novos := TSTringList.Create;
        lista_de_repetidos := TStringList.Create;
        for uA := 1 to 25 do
        begin
          // Se o valor é 1, quer dizer que é repetida.
          if lotofacil_bolas_selecionadas[uA] = 1 then
          begin
            lista_de_repetidos.Add(IntToStr(uA));
          end else
          begin
            lista_de_novos.Add(IntToStr(uA));
          end;
        end;

        // Zera a variável novamente.
        FillChar(lotofacil_bolas_selecionadas, 26 * sizeof(integer), 0);

        // Agora, iremos gerar as bolas da combinação derivada.
        for uA := 1 to qt_novos do
        begin
             // Pega uma bola aleatoriamente da lista de novos e em seguida,
             // retira da lista e define como a bola selecionada.
             indice_bola_numero := Random(lista_de_novos.Count);
             bola_numero := StrToInt(lista_de_novos.Strings[indice_bola_numero]);
             lista_de_novos.Delete(indice_bola_numero);
             lotofacil_bolas_selecionadas[bola_numero] := 1;
        end;

        // Agora, iremos pegar as bolas repetidas.
        qt_repetidos := 15 - qt_novos;
        for uA := 1 to qt_repetidos do
        begin
          // Pega uma bola aleatoriamente da lista de repetidos e em seguida,
          // retira da lista e define como a bola selecionada.
          indice_bola_numero := Random(lista_de_repetidos.Count);
          bola_numero := StrToInt(lista_de_repetidos.Strings[indice_bola_numero]);
          lista_de_repetidos.Delete(indice_bola_numero);
          lotofacil_bolas_selecionadas[bola_numero] := 1;
        end;

        // Se o usuário selecionou mais de 15 bolas, devemos, pegar as bolas restantes
        diferenca_de_bolas := bolas_por_combinacao - 15;
        for uA := 1 to diferenca_de_bolas do
        begin
          if lista_de_repetidos.Count <> 0 then
          begin
            indice_bola_numero := Random(lista_de_repetidos.Count);
            bola_numero := StrToInt(lista_de_repetidos.Strings[indice_bola_numero]);
            lista_de_repetidos.Delete(indice_bola_numero);
            lotofacil_bolas_selecionadas[bola_numero] := 1;
          end else
          if lista_de_novos.Count <> 0 then
          begin
            indice_bola_numero := Random(lista_de_novos.Count);
            bola_numero := StrToInt(lista_de_novos.Strings[indice_bola_numero]);
            lista_de_novos.Delete(indice_bola_numero);
            lotofacil_bolas_selecionadas[bola_numero] := 1;
          end else
          begin
            Exit(False);
          end;
        end;

        // Agora, iremos gravar a combinação derivada no arranjo.
        indice_coluna := 1;
        for uA := 1 to 25 do
        begin
          if lotofacil_bolas_selecionadas[uA] = 1 then
          begin
            lotofacil_aleatorio[indice_combinacao, indice_coluna] := uA;
            Inc(indice_coluna);
          end;
        end;

        gerador_etapa := ANTES_DE_GERAR_COMPLEMENTAR;
        continue;
      end;

      // Antes de gerar as bolas complementares, precisamos saber
      // quais são as bolas novas e as bolas repetidas
      ANTES_DE_GERAR_COMPLEMENTAR:
      begin
        // Pega as bolas da combinação derivada
        FillChar(lotofacil_bolas_selecionadas, 26 * sizeof(integer), 0);

        // As bolas da combinação derivada está armazenada no
        // arranjo bidimensional lotofacil_aleatorio, há uma variável
        // também que identifica qual posição do arranjo estamos.
        // Iremos pegar a quantidade de bolas igual a quantidade de bolas por combinação, que pode
        // ser 15, 16, 17 ou 18.
        for uA := 1 to bolas_por_combinacao do
        begin
          bola_numero := lotofacil_aleatorio[indice_combinacao, uA];
          lotofacil_bolas_selecionadas[bola_numero] := 1;
        end;

        lista_fixa.Clear;
        lista_nao_fixa_origem.Clear;
        lista_nao_fixa_destino.Clear;

        // Na lista fixa, haverá as bolas, que serão repetidas em todas as combinações
        // complementares, a lista fixa corresponde a lista de bolas novos.
        // As outras duas listas: lista_nao_fixa_origem e lista_nao_fixa_destino
        // corresponde as bolas da combinação derivada.
        for uA := 1 to 25 do
        begin
          if lotofacil_bolas_selecionadas[uA] = 1 then
          begin
            lista_nao_fixa_origem.Add(IntToStr(uA));
          end else
          begin
            lista_fixa.Add(IntToStr(uA));
          end;
        end;

        gerador_etapa := COMPLEMENTAR_1;
        continue;
      end;

      COMPLEMENTAR_1, COMPLEMENTAR_2, COMPLEMENTAR_3:
      begin
        Inc(indice_combinacao);
        if indice_combinacao >= qt_de_combinacoes then
          break;

        // A próxima combinação é composta da lista fixa e não-fixa,
        // entretanto, pode ocorrer da lista não-fixa, ser menor
        // que a quantidade de bolas nao fixas, neste caso, devemos
        // completá-la.
        // Pra resolver isto, pegas as bolas que faltam da lista
        // não-fixa destino, pois, toda vez que retiramos um ítem
        // da lista não-fixa origem, ela é enviada pra lista não-fixa destino.
        // Por este motivo, que existe duas lista de não-fixas, uma de origem
        // e uma de destino.
        while lista_nao_fixa_origem.Count < bolas_nao_fixas do
        begin
          indice_lista := Random(lista_nao_fixa_destino.Count);
          bola_numero := StrToInt(lista_nao_fixa_destino.Strings[indice_lista]);

          // Move a bola da lista de destino pra lista de origem.
          lista_nao_fixa_destino.Delete(indice_lista);
          lista_nao_fixa_origem.add(IntToStr(bola_numero));
        end;

        // Zera o arranjo.
        FillChar(lotofacil_bolas_selecionadas, 26 * SizeOf(integer), 0);

        // Pega as bolas fixas.
        for uA := 0 to Pred(bolas_fixas) do
        begin
          bola_numero := StrToInt(lista_fixa.Strings[uA]);
          lotofacil_bolas_selecionadas[bola_numero] := 1;
        end;

        // Pega as bolas não-fixas.
        for uA := 0 to Pred(bolas_nao_fixas) do
        begin

          indice_lista := Random(lista_nao_fixa_origem.Count);
          bola_numero := StrToInt(lista_nao_fixa_origem.Strings[indice_lista]);

          // Move a bola da lista não-fixa origem pra lista não-fixa destino.
          lista_nao_fixa_origem.Delete(indice_lista);
          lista_nao_fixa_destino.Add(IntToStr(bola_numero));

          lotofacil_bolas_selecionadas[bola_numero] := 1;
        end;

        indice_coluna := 1;
        for uA := 1 to 25 do
        begin
          if lotofacil_bolas_selecionadas[uA] = 1 then
          begin
            lotofacil_aleatorio[indice_combinacao, indice_coluna] := uA;
            lotofacil_ultima_combinacao_gerada[indice_coluna] := uA;
            Inc(indice_coluna);
          end;
        end;

        case gerador_etapa of
          COMPLEMENTAR_1: gerador_etapa := COMPLEMENTAR_2;
          COMPLEMENTAR_2: gerador_etapa := COMPLEMENTAR_3;
          COMPLEMENTAR_3: gerador_etapa := GERAR_DERIVADO;
        end;
      end;
    end;


       {
      ANTES_DE_GERAR:
        // Nesta etapa, iremos gerar aleatoriamente, a primeira combinação
        // Esta estapa, é iterada somente uma vez.
      begin
        // Adiciona os números à lista, pra posterior sorteio.
        lista_numeros.Clear;
        for uA := 1 to 25 do
        begin
          lista_numeros.Add(IntToStr(uA));
        end;

        // Zera a variável.
        FillChar(lotofacil_numeros, 26 * sizeof(integer), 0);

        // Vamos gerar aleatoriamente, a primeira combinação,
        // O número do índice do arranjo lotofacil_numeros é igual ao
        // número da bola, então, se a bola for escolhida, a célula
        // deste arranjo terá o valor 1, senão zero.
        Randomize;
        for uA := 1 to bolas_por_combinacao do
        begin

          indice_lista := Random(lista_numeros.Count);
          bola_numero := StrToInt(lista_numeros.Strings[indice_lista]);
          lista_numeros.Delete(indice_lista);

          lotofacil_numeros[bola_numero] := 1;
        end;


        FillChar(lotofacil_numeros, 26 * sizeof(integer), 0);
        for uA := 1 to 15 do begin
          bola_numero := lotofacil_qualquer[uA];
          lotofacil_numeros[bola_numero] := 1;
        end;

        // Em seguida, devemos pegar as bolas sorteadas aleatoriamente
        // e posicionar as bolas em ordem crescente dentro do arranjo
        // lotofacil_aleatorio.
        indice_coluna := 1;
        for uA := 1 to 25 do
        begin
          if lotofacil_numeros[uA] = 1 then
          begin
            lotofacil_aleatorio[0, indice_coluna] := uA;
            Inc(indice_coluna);
          end;
        end;
        gerador_etapa := ETAPA_ZERO;
        continue;
      end;

      // Na etapa zero, obtermos a lista de fixo e não fixo.
      // Pra isto, iremos considerar a última combinação gerada
      // pra basear a lista de fixa e não fixo.
      ETAPA_ZERO:
      begin
        lista_fixa.Clear;
        lista_nao_fixa_origem.Clear;
        lista_nao_fixa_destino.Clear;

        // Zera sempre a variável.
        FillChar(lotofacil_numeros, 26 * sizeof(integer), 0);

        // Percorre a última combinação gerada e obtém os números sorteados.
        for uA := 1 to bolas_por_combinacao do
        begin
          bola_numero := lotofacil_aleatorio[indice_a_ser_gerado, uA];
          lotofacil_numeros[bola_numero] := 1;
        end;
        Inc(indice_a_ser_gerado);

        // Obtém a lista fixa e não fixa.
        for uA := 1 to 25 do
        begin
          if lotofacil_numeros[uA] = 1 then
          begin
            lista_nao_fixa_origem.Add(IntToStr(uA));
          end
          else
          begin
            lista_fixa.Add(IntToStr(uA));
          end;
        end;

        gerador_etapa := ETAPA_UM;
        continue;
      end;

      // Na etapa 1, geramos o derivado da combinação principal.
      ETAPA_UM, ETAPA_DOIS, ETAPA_TRES, ETAPA_QUATRO, ETAPA_CINCO,
      ETAPA_SEIS, ETAPA_SETE, ETAPA_OITO, ETAPA_NOVE, ETAPA_DEZ:
      begin
        Inc(indice_combinacao);
        if indice_combinacao >= qt_de_combinacoes then
          break;

        // A próxima combinação é composta da lista fixa e não-fixa,
        // entretanto, pode ocorrer da lista não-fixa, ser menor
        // que a quantidade de bolas nao fixas, neste caso, devemos
        // completá-la.
        // Pra resolver isto, pegas as bolas que faltam da lista
        // não-fixa destino, pois, toda vez que retiramos um ítem
        // da lista não-fixa origem, ela é enviada pra lista não-fixa destino.
        // Por este motivo, que existe duas lista de não-fixas, uma de origem
        // e uma de destino.
        while lista_nao_fixa_origem.Count < bolas_nao_fixas do
        begin
          indice_lista := Random(lista_nao_fixa_destino.Count);
          bola_numero := StrToInt(lista_nao_fixa_destino.Strings[indice_lista]);

          // Move a bola da lista de destino pra lista de origem.
          lista_nao_fixa_destino.Delete(indice_lista);
          lista_nao_fixa_origem.add(IntToStr(bola_numero));
        end;

        // Zera o arranjo.
        FillChar(lotofacil_numeros, 26 * SizeOf(integer), 0);

        // Pega as bolas fixas.
        for uA := 0 to Pred(bolas_fixas) do
        begin
          bola_numero := StrToInt(lista_fixa.Strings[uA]);
          lotofacil_numeros[bola_numero] := 1;
        end;

        // Pega as bolas não-fixas.
        for uA := 0 to Pred(bolas_nao_fixas) do
        begin

          indice_lista := Random(lista_nao_fixa_origem.Count);
          bola_numero := StrToInt(lista_nao_fixa_origem.Strings[indice_lista]);

          // Move a bola da lista não-fixa origem pra lista não-fixa destino.
          lista_nao_fixa_origem.Delete(indice_lista);
          lista_nao_fixa_destino.Add(IntToStr(bola_numero));

          lotofacil_numeros[bola_numero] := 1;
        end;

        indice_coluna := 1;
        for uA := 1 to 25 do
        begin
          if lotofacil_numeros[uA] = 1 then
          begin
            lotofacil_aleatorio[indice_combinacao, indice_coluna] := uA;
            Inc(indice_coluna);
          end;
        end;

        case gerador_etapa of
          ETAPA_UM: gerador_etapa := ETAPA_DOIS;
          ETAPA_DOIS: gerador_etapa := ETAPA_TRES;
          ETAPA_TRES: gerador_etapa := ETAPA_ZERO;
                    {
                    ETAPA_TRES: gerador_etapa := ETAPA_QUATRO;
                    ETAPA_QUATRO : gerador_etapa := ETAPA_CINCO;
                    ETAPA_CINCO  : gerador_etapa := ETAPA_SEIS;
                    ETAPA_SEIS   : gerador_etapa := ETAPA_SETE;
                    ETAPA_SETE   : gerador_etapa := ETAPA_OITO;
                    ETAPA_OITO   : gerador_etapa := ETAPA_NOVE;
                    ETAPA_NOVE   : gerador_etapa := ETAPA_DEZ;
                    ETAPA_DEZ    : gerador_etapa := ANTES_DE_GERAR;
                    }
        end;
        continue;
        }
      end; // FIM DO while.
end;

{
 Iremos capturar as combinações que foram geradas aleatoriamente, e iremos
 inserir na tabela 'lotofacil_aleatorio_temporario', em seguida, iremos
 recuperar os valores para o campo ltf_id.
 Pra isto, iremos relacionar os campos b_1, até b_18, com a tabela 'lotofacil_bolas'
 com isto, conseguirmos recuperar o campo 'ltf_id'.
 Em seguida, iremos inserir os dados desta tabela temporaria 'lotofacil_aleatorio_temporario'
 na tabela 'lotofacil_aleatorio', utilizando os campos
 'ltf_id', 'ltf_qt', 'data_aleatorio', 'aleatorio_sequencial'.
}
function TForm1.Inserir_Aleatorio_Temporario(ltf_aleatorio: TAleatorio_Resultado;
  bolas_por_combinacao: integer): boolean;
var
  sql_registro: TSQLQuery;
  id_aleatorio_sequencial, uA, uB: integer;
  data_hora, sql_texto: string;
  lista_sql: TStringList;
begin
  sql_registro := TSqlQuery.Create(Self);

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;
  sql_registro.DataBase := dmLotofacil.pgLTK;

  // Valores que estarão em todos os registros, ao ser inserido.
  lista_sql := TStringList.Create;
  data_hora := FormatDateTime('YYYY-mm-dd hh:nn:ss.zzz', Now);
  id_aleatorio_sequencial := 1;
  sql_texto := '';

  lista_sql.Clear;
  lista_sql.Add('Insert into lotofacil.lotofacil_aleatorio_temporario');
  lista_sql.Add('(ltf_qt, aleatorio_data, aleatorio_sequencial,');
  lista_sql.Add(
    'b_1, b_2, b_3, b_4, b_5, b_6, b_7, b_8, b_9, b_10, b_11, b_12, b_13, b_14, b_15');

  // Se há mais de 15 bolas, devemos, selecionar também.
  case bolas_por_combinacao of
    16: lista_sql.Add(', b_16');
    17: lista_sql.Add(', b_16, b_17');
    18: lista_sql.Add(', b_16, b_17, b_18');
  end;
  lista_sql.Add(')values');
  Writeln(lista_sql.Text);

  for uA := 0 to High(ltf_aleatorio) do
  begin
    if uA > 0 then
    begin
      sql_texto := ',(';
    end
    else
    begin
      sql_texto := '(';
    end;

    sql_texto := sql_texto + IntToStr(bolas_por_combinacao) + ', ';
    sql_texto := sql_texto + QuotedStr(data_hora) + ', ';
    sql_texto := sql_texto + IntToStr(id_aleatorio_sequencial);

    // A primeira bola começa no índice 1.
    for uB := 1 to bolas_por_combinacao do
    begin
      sql_texto := sql_texto + ', ' + IntToStr(ltf_aleatorio[uA, uB]);
    end;
    sql_texto := sql_texto + ')';
    lista_sql.Add(sql_texto);
    Inc(id_aleatorio_sequencial);
  end;
  // Evitar linhas em branco no final.
  lista_sql.SkipLastLineBreak := True;

  // Antes de inserir no banco de dados, devemos apagar a tabela temporaria.
  try
    sql_registro.Sql.Clear;
    sql_registro.Sql.Add('Delete from lotofacil.lotofacil_aleatorio_temporario');
    sql_registro.ExecSql;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_registro.Close;
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit(False);
    end;
  end;

  // Agora, inserir os dados.
  try
    sql_registro.Sql.Clear;
    sql_registro.Sql.Text := lista_sql.Text;
    sql_registro.ExecSql;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_registro.Close;
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit(False);
    end;
  end;

  // Em seguida, iremos 'capturar' o valor do campo ltf_id
  try
    sql_registro.Sql.Clear;
    sql_registro.Sql.Add('Update lotofacil.lotofacil_aleatorio_temporario ltf_temp');
    sql_registro.Sql.Add('set ltf_id = ltf_bolas.ltf_id');
    sql_registro.Sql.Add('from lotofacil.lotofacil_bolas ltf_bolas');
    sql_registro.SQL.Add('where ltf_bolas.ltf_qt = ' + IntToStr(bolas_por_combinacao));

    for uA := 1 to bolas_por_combinacao do
    begin
      sql_registro.Sql.Add('and ltf_temp.b_' + IntToStr(uA) + ' = ');
      sql_registro.Sql.Add('ltf_bolas.b_' + IntToStr(uA));
    end;

    Writeln(sql_registro.Sql.Text);

    sql_registro.ExecSql;
    dmLotofacil.pgLTK.Transaction.Commit;
    sql_registro.Close;
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit(False);
    end;
  end;

  // Em seguida, iremos inserir os valores de todos os campos 'ltf_id', 'ltf_qt',
  // 'aleatorio_data', 'aleatorio_sequencial', de cada registro da tabela
  // 'lotofacil_aleatorio_temporario' na tabela 'lotofacil_aleatorio'.
  try
    sql_registro.Sql.Clear;
    sql_registro.Sql.Add('Insert into lotofacil.lotofacil_aleatorio');
    sql_registro.Sql.Add(
      '(ltf_id, ltf_qt, aleatorio_data, aleatorio_sequencial, acertos)');
    sql_registro.Sql.Add(
      'Select ltf_id, ltf_qt, aleatorio_data, aleatorio_sequencial, 0');
    sql_registro.Sql.Add('from lotofacil.lotofacil_aleatorio_temporario');
    sql_registro.Sql.Add('where ltf_qt = ' + IntToStr(bolas_por_combinacao));
    sql_registro.Sql.Add('and aleatorio_data = ' + QuotedStr(data_hora));
    sql_registro.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    dmLotofacil.pgLTK.CloseDataSets;
    sql_registro.Close;
  except
    on Exc: EDataBaseError do
    begin
      strErro := Exc.Message;
      Exit(False);
    end;
  end;


  Exit(True);
end;


{
 Quando inserimos novos concursos, devemos sempre atualizar a tabela
 de frequência de bolas.
 Esta tabela contabiliza a quantidade de novos, repetidos, deixou de sair, ainda
 não saiu, comparando um concurso com outro.
}
procedure TForm1.AtualizarFrequenciaBolas;
var
  sqlRegistro: TSqlQuery;
begin
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := TSqlQuery.Create(Self);
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Active := False;

  sqlRegistro.SQL.Clear;
  sqlRegistro.Sql.Add('Select lotofacil.fn_lotofacil_resultado_frequencia_atualizar()');
  sqlRegistro.Prepare;

  try
    sqlRegistro.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
    sqlRegistro.Close;
  except
    on Exc: EDataBaseError do
    begin
      MessageDlg('Erro', 'Erro: ' + Exc.Message, TMsgDlgType.mtError, [mbOK], 0);
    end;
  end;

  // Atualiza todos os controles que recupera informações do banco de dados.
  //CarregarTodosControles;

  cmbConcursoFrequenciaTotalSairChange(cmbConcursoFrequenciaTotalSair);
  cmbConcursoFrequenciaSairChange(cmbConcursoFrequenciaSair);

  CarregarConcursos;

end;

function TForm1.GerarSqlLotofacilSoma: string;
var
  ultima_linha, indice_ultima_coluna, uA: integer;
  strSql: string;
begin
  if sgrLotofacilSoma.Columns.Count <> 4 then
  begin
    exit('');
  end;

  strSql := '';

  ultima_linha := sgrLotofacilSoma.RowCount - 1;

  // Coluna com o título 'Marcar' é a última coluna.
  indice_ultima_coluna := sgrLotofacilSoma.ColCount - 1;

  for uA := 1 to ultima_linha do
  begin
    if sgrLotofacilSoma.Cells[indice_ultima_coluna, uA] = '1' then
    begin
      if strSql <> '' then
      begin
        strSql := strSql + ', ';
      end;
      strSql := strSql + sgrLotofacilSoma.Cells[0, uA];
    end;
  end;

  if strSql <> '' then
  begin
    strSql := 'tb_ltf_soma.bola_soma in(' + strSql + ')';
  end;
  exit(strSql);
end;

{
 Iremos percorrer todas as bolas que está no controle sgrFrequenciaBolasSairNaoSair
 e verificar se o usuário marcou as mesmas, se sim, iremos pegar a bola
 e inclue no sql dinamicamente, há duas colunas, 'DEVE_SAIR' e 'NAO_DEVE_SAIR',
 um das colunas terá o valor '1' se o usuário escolheu, '0' caso contrário.

 Cada bola, pode pertencer a uma única categoria, há 4 categorias específicas:
 AINDA_NAO_SAIU,
 DEIXOU_DE_SAIR,
 NOVO
 REPETINDO.

 Pra cada categoria, há a quantidade mínima e máxima de bolas que cada categoria
 deve sair.

 Então, esta function retorna um sql das bolas escolhidas, e o intervalo mínimo
 e máximo de todas as bolas, conforme o grupo.

}
function TForm1.GerarSqlFrequencia: string;
var
  sql_bolas_sair: ansistring;
  sql_bolas_nao_sair: ansistring;
  ultima_coluna_controle_sair, ultima_coluna_controle_nao_sair, uA,
  indice_minimo, indice_maximo: integer;
  minimo_sair, maximo_sair, minimo_nao_sair, maximo_nao_sair,
  bola_numero, sql_bolas_ainda_nao_saiu, sql_bolas_deixou_de_sair,
  sql_bolas_novo, sql_bolas_repetindo, frequencia_status,
  minimo_ainda_nao_saiu, maximo_ainda_nao_saiu, minimo_novo,
  maximo_novo, minimo_deixou_de_sair, maximo_deixou_de_sair,
  minimo_repetindo, maximo_repetindo: string;
  lista_bola_sair, lista_bola_nao_sair, lista_ainda_nao_saiu,
  lista_deixou_de_sair, lista_novo, lista_repetindo, lista_sql: TStringList;
begin
  sql_bolas_sair := '';
  sql_bolas_nao_sair := '';

  sql_bolas_ainda_nao_saiu := '';
  sql_bolas_deixou_de_sair := '';
  sql_bolas_novo := '';
  sql_bolas_repetindo := '';

  // No controle sgrFrequencia_Bolas_Sair_Nao_Sair há duas colunas: deve_sair, nao_deve_sair
  ultima_coluna_controle_nao_sair := Pred(sgrFrequencia_Bolas_Sair_Nao_Sair.Columns.Count);
  ultima_coluna_controle_sair := ultima_coluna_controle_nao_sair - 1;

  // Iremos percorrer todas as linhas do controle: sgrFrequencia_Bolas_Sair_Nao_Sair e
  // sgrFrequenciaBolasNaoSair, e verificar se o usuário marcou a bola pra sair
  // e a bola pra não sair.
  // E também iremos gerar o sql por categoria, iremos identificar de qual
  // categoria a bola se encontra no momento, por exemplo: ainda_nao_saiu,
  // deixou_de_sair, novo e repetindo.

  lista_bola_sair := TStringList.Create;
  lista_bola_nao_sair := TStringList.Create;

  lista_ainda_nao_saiu := TStringList.Create;
  lista_deixou_de_sair := TStringList.Create;
  lista_novo := TStringList.Create;
  lista_repetindo := TStringList.Create;

  lista_bola_sair.Clear;
  lista_bola_nao_sair.Clear;
  lista_ainda_nao_saiu.Clear;
  lista_deixou_de_sair.Clear;
  lista_novo.Clear;
  lista_repetindo.Clear;

  for uA := 1 to 25 do
  begin
    // Vamos pegar somente bolas que usuário marcou que devem sair na combinação.
    if sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_controle_sair,
      uA] = '1' then
    begin
      bola_numero := sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[0, uA];
      lista_bola_sair.Add('num_' + bola_numero);

      // Na coluna 1, temos o tipo da categoria de frequência.
      frequencia_status := sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[1, uA];
      frequencia_status := LowerCase(frequencia_status);
      if frequencia_status = 'ainda_nao_saiu' then
      begin
        lista_ainda_nao_saiu.Add('num_' + bola_numero);
      end
      else
      if frequencia_status = 'deixou_de_sair' then
      begin
        lista_deixou_de_sair.Add('num_' + bola_numero);
      end
      else
      if frequencia_status = 'novo' then
      begin
        lista_novo.Add('num_' + bola_numero);
      end
      else
      if frequencia_status = 'repetindo' then
      begin
        lista_repetindo.Add('num_' + bola_numero);
      end;

    end;
    // Pega as bolas que não devem sair.
    if sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_controle_nao_sair,
      uA] = '1' then
    begin
      bola_numero := sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[0, uA];
      lista_bola_nao_sair.Add('num_' + bola_numero);
    end;
  end;

  // ==================== BOLAS NAO SAIR =========================

  sql_bolas_nao_sair := '';
  if lista_bola_nao_sair.Count <> 0 then
  begin
    for uA := 0 to Pred(lista_bola_nao_sair.Count) do
    begin
      if uA <> 0 then
      begin
        sql_bolas_nao_sair := sql_bolas_nao_sair + ' + ';
      end;
      sql_bolas_nao_sair := sql_bolas_nao_sair + lista_bola_nao_sair.Strings[uA];
    end;
    indice_minimo := cmbFrequencia_Minimo_Nao_sair.ItemIndex;
    indice_maximo := cmbFrequencia_Maximo_Nao_sair.ItemIndex;

    if (indice_minimo = -1) or (indice_maximo = -1) then
    begin
      strErro := strErro + 'Vc deve escolher mínimo e máximo da frequência';
      Exit('');
    end;
    minimo_nao_sair := cmbFrequencia_Minimo_Nao_sair.Items[indice_minimo];
    maximo_nao_sair := cmbFrequencia_Maximo_Nao_sair.Items[indice_maximo];

    // No caso, das bolas que não devem sair, a soma dos campos corresponentes deve
    // ser igual a zero.
    //sql_bolas_nao_sair := '(' + sql_bolas_nao_sair + ' between ' + minimo_nao_sair + ' and ' + maximo_nao_sair + ')';
    sql_bolas_nao_sair := '(' + sql_bolas_nao_sair + ' = 0)';
  end;


  // ==================== BOLAS AINDA NAO SAIU =========================
  sql_bolas_ainda_nao_saiu := '';
  if lista_ainda_nao_saiu.Count <> 0 then
  begin
    for uA := 0 to Pred(lista_ainda_nao_saiu.Count) do
    begin
      if uA <> 0 then
      begin
        sql_bolas_ainda_nao_saiu := sql_bolas_ainda_nao_saiu + ' + ';
      end;
      sql_bolas_ainda_nao_saiu := sql_bolas_ainda_nao_saiu + lista_ainda_nao_saiu.Strings[uA];
    end;
    indice_minimo := cmbAinda_nao_saiu_minimo.ItemIndex;
    indice_maximo := cmbAinda_nao_saiu_maximo.ItemIndex;

    if (indice_minimo = -1) or (indice_maximo = -1) then
    begin
      strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
      Exit('');
    end;
    minimo_ainda_nao_saiu := cmbAinda_nao_saiu_minimo.Items[indice_minimo];
    maximo_ainda_nao_saiu := cmbAinda_nao_saiu_maximo.Items[indice_maximo];

    sql_bolas_ainda_nao_saiu :=
      '(' + sql_bolas_ainda_nao_saiu + ' between ' + minimo_ainda_nao_saiu +
      ' and ' + maximo_ainda_nao_saiu + ')';
  end;


  // ==================== BOLAS DEIXOU DE SAIR =========================
  sql_bolas_deixou_de_sair := '';
  if lista_deixou_de_sair.Count <> 0 then
  begin
    for uA := 0 to Pred(lista_deixou_de_sair.Count) do
    begin
      if uA <> 0 then
      begin
        sql_bolas_deixou_de_sair := sql_bolas_deixou_de_sair + ' + ';
      end;
      sql_bolas_deixou_de_sair :=
        sql_bolas_deixou_de_sair + lista_deixou_de_sair.Strings[uA];
    end;
    indice_minimo := cmbdeixou_de_sair_minimo.ItemIndex;
    indice_maximo := cmbdeixou_de_sair_maximo.ItemIndex;

    if (indice_minimo = -1) or (indice_maximo = -1) then
    begin
      strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
      Exit('');
    end;
    minimo_deixou_de_sair := cmbdeixou_de_sair_minimo.Items[indice_minimo];
    maximo_deixou_de_sair := cmbdeixou_de_sair_maximo.Items[indice_maximo];

    sql_bolas_deixou_de_sair :=
      '(' + sql_bolas_deixou_de_sair + ' between ' + minimo_deixou_de_sair +
      ' and ' + maximo_deixou_de_sair + ')';
  end;

  // ==================== BOLAS AINDA NAO SAIU =========================
  sql_bolas_novo := '';
  if lista_novo.Count <> 0 then
  begin
    for uA := 0 to Pred(lista_novo.Count) do
    begin
      if uA <> 0 then
      begin
        sql_bolas_novo := sql_bolas_novo + ' + ';
      end;
      sql_bolas_novo := sql_bolas_novo + lista_novo.Strings[uA];
    end;
    indice_minimo := cmbnovo_minimo.ItemIndex;
    indice_maximo := cmbnovo_maximo.ItemIndex;

    if (indice_minimo = -1) or (indice_maximo = -1) then
    begin
      strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
      Exit('');
    end;
    minimo_novo := cmbnovo_minimo.Items[indice_minimo];
    maximo_novo := cmbnovo_maximo.Items[indice_maximo];

    sql_bolas_novo := '(' + sql_bolas_novo + ' between ' + minimo_novo +
      ' and ' + maximo_novo + ')';
  end;

  // ==================== BOLAS REPETINDO =========================
  sql_bolas_repetindo := '';
  if lista_repetindo.Count <> 0 then
  begin
    for uA := 0 to Pred(lista_repetindo.Count) do
    begin
      if uA <> 0 then
      begin
        sql_bolas_repetindo := sql_bolas_repetindo + ' + ';
      end;
      sql_bolas_repetindo := sql_bolas_repetindo + lista_repetindo.Strings[uA];
    end;
    indice_minimo := cmbrepetindo_minimo.ItemIndex;
    indice_maximo := cmbrepetindo_maximo.ItemIndex;

    if (indice_minimo = -1) or (indice_maximo = -1) then
    begin
      strErro := strErro + 'Vc deve escolher mínimo e máxima da frequência';
      Exit('');
    end;
    minimo_repetindo := cmbrepetindo_minimo.Items[indice_minimo];
    maximo_repetindo := cmbrepetindo_maximo.Items[indice_maximo];

    sql_bolas_repetindo := '(' + sql_bolas_repetindo + ' between ' +
      minimo_repetindo + ' and ' + maximo_repetindo + ')';
  end;

  // Cada bola em uma frequência pode estar nestes status:
  // Ainda não saiu
  // Deixou de sair
  // Novo
  // Repetindo

  // Antes, eu pegava todas as bolas e gerava o sql dinamicamente.
  // Nesta abordagem, a quantidade mínima e máxima era baseada em todas as bolas
  // e não no status da frequência, agora, posso definir a quantidade mínima
  // e máxima conforme o status da frequência que a bola pertence, assim,
  // provavelmente, conseguirei realizar uma melhor filtragem das combinações
  // e ser mais preciso.
  lista_sql := TStringList.Create;
  lista_sql.Clear;

  if sql_bolas_nao_sair <> '' then
  begin
    lista_sql.Add(sql_bolas_nao_sair);
  end;

  // ======== AINDA NAO SAIU ===========
  if sql_bolas_ainda_nao_saiu <> '' then
  begin

    // Coloca o operador 'and' entre os sql.
    if lista_sql.Count > 0 then
    begin
      lista_sql.Add('And');
    end;

    lista_sql.Add(sql_bolas_ainda_nao_saiu);
  end;

  // ======== DEIXOU DE SAIR ===========
  if sql_bolas_deixou_de_sair <> '' then
  begin

    // Coloca o operador 'and' entre os sql.
    if lista_sql.Count > 0 then
    begin
      lista_sql.Add('And');
    end;

    lista_sql.Add(sql_bolas_deixou_de_sair);
  end;

  // ======== NOVO ===========
  if sql_bolas_novo <> '' then
  begin

    // Coloca o operador 'and' entre os sql.
    if lista_sql.Count > 0 then
    begin
      lista_sql.Add('And');
    end;

    lista_sql.Add(sql_bolas_novo);
  end;

  if sql_bolas_repetindo <> '' then
  begin

    // Coloca o operador 'and' entre os sql.
    if lista_sql.Count > 0 then
    begin
      lista_sql.Add('And');
    end;

    lista_sql.Add(sql_bolas_repetindo);
  end;

  // Em seguida, se a lista não está vazia, devemos
  // circundar tudo com o '(' + ')'.
  if lista_sql.Count > 0 then
  begin
    lista_sql.Insert(0, '(');
    lista_sql.Append(')');
  end;

  Writeln(lista_sql.Text);
  Exit(lista_sql.Text);

end;

{
 Nesta função, selecionamos quais controles da forma sgr_bx_a_by devemos utilizar
 no programa.
}
function TForm1.Selecionar_sgr_bx_a_by: boolean;
begin
  // Se controle já está instanciado, retornar true.
  if Assigned(f_sgr_bx_a_by_lista) then begin
    Exit(True);
  end;

  try
    f_sgr_bx_a_by_lista := TLista_Controle_B1_a_B15.Create;
    f_sgr_bx_a_by_lista.Clear;

    f_sgr_bx_a_by_lista.Add(sgr_b1_a_b1);
    f_sgr_bx_a_by_lista.Add(sgr_b1_a_b2);
    f_sgr_bx_a_by_lista.Add(sgr_b1_a_b3);
    f_sgr_bx_a_by_lista.Add(sgr_b1_a_b4);
    f_sgr_bx_a_by_lista.Add(sgr_b1_a_b5);

    f_sgr_bx_a_by_lista.Add(sgr_b2_a_b2);
    f_sgr_bx_a_by_lista.Add(sgr_b2_a_b3);
    f_sgr_bx_a_by_lista.Add(sgr_b2_a_b4);
    f_sgr_bx_a_by_lista.Add(sgr_b2_a_b5);
    f_sgr_bx_a_by_lista.Add(sgr_b2_a_b6);

    f_sgr_bx_a_by_lista.Add(sgr_b3_a_b3);
    f_sgr_bx_a_by_lista.Add(sgr_b3_a_b4);
    f_sgr_bx_a_by_lista.Add(sgr_b3_a_b5);
    f_sgr_bx_a_by_lista.Add(sgr_b3_a_b6);
    f_sgr_bx_a_by_lista.Add(sgr_b3_a_b7);

    f_sgr_bx_a_by_lista.Add(sgr_b4_a_b4);
    f_sgr_bx_a_by_lista.Add(sgr_b4_a_b5);
    f_sgr_bx_a_by_lista.Add(sgr_b4_a_b6);
    f_sgr_bx_a_by_lista.Add(sgr_b4_a_b7);
    f_sgr_bx_a_by_lista.Add(sgr_b4_a_b8);

    f_sgr_bx_a_by_lista.Add(sgr_b5_a_b5);
    f_sgr_bx_a_by_lista.Add(sgr_b5_a_b6);
    f_sgr_bx_a_by_lista.Add(sgr_b5_a_b7);
    f_sgr_bx_a_by_lista.Add(sgr_b5_a_b8);
    f_sgr_bx_a_by_lista.Add(sgr_b5_a_b9);
    f_sgr_bx_a_by_lista.Add(sgr_b5_a_b10);

    f_sgr_bx_a_by_lista.Add(sgr_b6_a_b6);
    f_sgr_bx_a_by_lista.Add(sgr_b6_a_b7);
    f_sgr_bx_a_by_lista.Add(sgr_b6_a_b8);
    f_sgr_bx_a_by_lista.Add(sgr_b6_a_b9);
    f_sgr_bx_a_by_lista.Add(sgr_b6_a_b10);

    f_sgr_bx_a_by_lista.Add(sgr_b7_a_b7);
    f_sgr_bx_a_by_lista.Add(sgr_b7_a_b8);
    f_sgr_bx_a_by_lista.Add(sgr_b7_a_b9);
    f_sgr_bx_a_by_lista.Add(sgr_b7_a_b10);
    f_sgr_bx_a_by_lista.Add(sgr_b7_a_b11);

    f_sgr_bx_a_by_lista.Add(sgr_b8_a_b8);
    f_sgr_bx_a_by_lista.Add(sgr_b8_a_b9);
    f_sgr_bx_a_by_lista.Add(sgr_b8_a_b10);
    f_sgr_bx_a_by_lista.Add(sgr_b8_a_b11);
    f_sgr_bx_a_by_lista.Add(sgr_b8_a_b12);

    f_sgr_bx_a_by_lista.Add(sgr_b9_a_b9);
    f_sgr_bx_a_by_lista.Add(sgr_b9_a_b10);
    f_sgr_bx_a_by_lista.Add(sgr_b9_a_b11);
    f_sgr_bx_a_by_lista.Add(sgr_b9_a_b12);
    f_sgr_bx_a_by_lista.Add(sgr_b9_a_b13);

    f_sgr_bx_a_by_lista.Add(sgr_b10_a_b10);
    f_sgr_bx_a_by_lista.Add(sgr_b10_a_b11);
    f_sgr_bx_a_by_lista.Add(sgr_b10_a_b12);
    f_sgr_bx_a_by_lista.Add(sgr_b10_a_b13);
    f_sgr_bx_a_by_lista.Add(sgr_b10_a_b13);
    f_sgr_bx_a_by_lista.Add(sgr_b10_a_b13);

    f_sgr_bx_a_by_lista.Add(sgr_b11_a_b11);
    f_sgr_bx_a_by_lista.Add(sgr_b11_a_b12);
    f_sgr_bx_a_by_lista.Add(sgr_b11_a_b13);
    f_sgr_bx_a_by_lista.Add(sgr_b11_a_b14);
    f_sgr_bx_a_by_lista.Add(sgr_b11_a_b15);

    f_sgr_bx_a_by_lista.Add(sgr_b12_a_b12);
    f_sgr_bx_a_by_lista.Add(sgr_b12_a_b13);
    f_sgr_bx_a_by_lista.Add(sgr_b12_a_b14);
    f_sgr_bx_a_by_lista.Add(sgr_b12_a_b15);

    f_sgr_bx_a_by_lista.Add(sgr_b13_a_b13);
    f_sgr_bx_a_by_lista.Add(sgr_b13_a_b14);
    f_sgr_bx_a_by_lista.Add(sgr_b13_a_b15);

    f_sgr_bx_a_by_lista.Add(sgr_b14_a_b14);
    f_sgr_bx_a_by_lista.Add(sgr_b14_a_b15);

    f_sgr_bx_a_by_lista.Add(sgr_b15_a_b15);

  except
    if Assigned(f_sgr_bx_a_by_lista) then begin
      FreeAndNil(f_sgr_bx_a_by_lista);
      Exit(False);
    end;
  end;

  Exit(True);
end;

function TForm1.gerar_sql_b1_a_b15: string;
var
  //f_lista_de_controles_b1_a_b15 : TLista_Controle_B1_a_B5;
  uA, indice_ultima_coluna, indice_ultima_linha, coluna_inicial,
    coluna_final, linha_atual: Integer;
  controle_atual: TStringGrid;
  lista_sql_controle_atual, lista_sql: TStringList;
  sufixo_nome: String;
begin

  // Aqui, vc seleciona quais controles vc deseja que apareça no select.
  if Selecionar_sgr_bx_a_by = false then begin
    Exit('');
  end;

  lista_sql := TStringList.Create;
  lista_sql.Clear;

  lista_sql_controle_atual := TStringList.Create;
  lista_sql_controle_atual.Clear;

  for uA := 0 to Pred(f_sgr_bx_a_by_lista.Count) do
  begin
    controle_atual := f_sgr_bx_a_by_lista.Items[uA];
    if controle_atual.rowCount <= 0 then begin
      continue;
    end;

    lista_sql_controle_atual.Clear;

    indice_ultima_coluna := Pred(controle_atual.ColCount);
    indice_ultima_linha := Pred(controle_atual.RowCount);

    linha_atual := 1;
    while linha_atual <= indice_ultima_linha do begin
      if controle_atual.Cells[indice_ultima_coluna, linha_atual] = '1' then begin
        // Pega o identificador na coluna 'grp_id'.
        lista_sql_controle_atual.Add(controle_atual.Cells[0, linha_atual]);
      end;

      Inc(linha_atual);
    end;

    // Agora, se houve algo selecionado pelo usuário devemos armazenar na lista
    // principal.
    if lista_sql_controle_atual.Count > 0 then begin
      sufixo_nome := '';
      coluna_inicial := 0;
      coluna_final := 0;
      lista_sql_controle_atual.Delimiter:=',';
      obter_sufixo_do_nome_da_tabela(controle_atual, sufixo_nome, coluna_inicial, coluna_final);

      // Agora, insere na lista principal.
      if lista_sql.Count > 0 then begin
        lista_sql.Add('and');
      end;

      lista_sql.Add('(' + sufixo_nome +'_id in (' + lista_sql_controle_atual.DelimitedText + '))');

    end;
  end;

  Result := '';
  if lista_sql.Count > 0 then begin
    Exit('(' + lista_sql.Text + ')');
  end else begin
    Exit('');
  end;

end;

{
 Gera o sql dinâmica das opções escolhidas pelo usuário.
 Iremos pegar o id da combinação novos x repetidos, que está selecionado,
 que está na coluna 0, do stringGrid.
}
function TForm1.GerarSqlNovosRepetidos: string;
var
  uA, indiceUltimaColuna: integer;
  indiceUltimaLinha: integer;
  linhaCelula, total_id_escolhidos, ultimo_indice: integer;
  sqlNovosRepetidos: TStringList;
  sqlResultado: ansistring;
begin
  sqlNovosRepetidos := TStringList.Create;
  sqlResultado := '';

  indiceUltimaColuna := Pred(sgrNovosRepetidos.ColCount);
  indiceUltimaLinha := Pred(sgrNovosRepetidos.RowCount);

  // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
  // o id da combinação.
  for linhaCelula := 1 to indiceUltimaLinha do
  begin
    if sgrNovosRepetidos.Cells[indiceUltimaColuna, linhaCelula] = '1' then
    begin
      sqlNovosRepetidos.Add(sgrNovosRepetidos.Cells[0, linhaCelula]);
    end;
  end;

  // Se houver alguma combinação escolhida, iremos concatenar todos os id
  // e retornaremos a consulta where parcial.
  sqlResultado := '';
  uA := 0;
  total_id_escolhidos := sqlNovosRepetidos.Count;
  ultimo_indice := total_id_escolhidos - 1;

  if sqlNovosRepetidos.Count > 0 then
  begin
    for uA := 0 to ultimo_indice do
    begin
      if sqlResultado <> '' then
      begin
        sqlResultado := sqlResultado + ', ';
      end;

      sqlResultado := sqlResultado + sqlNovosRepetidos.Strings[uA];
    end;
    sqlResultado := 'novos_repetidos_id in (' + sqlResultado + ')';
  end;

  Result := sqlResultado;
end;



{
 Gera o sql das combinações pares e impares.
 No programa, as combinações de pares e ímpares são de 15 números, após o usuário
 selecionar tais combinações, a função abaixo, recupera automaticamente as combinações
 pares e ímpares das outras quantidades de 16, 17 e 18 números.
 Tais combinações estão localizadas na tabela par_impar_comum.
}
//TODO: Falta mover esta funçtion pra a classe TLofacilParImpar.
function TForm1.GerarSqlParImpar: string;
var
  uA, indiceUltimaColuna: integer;
  indiceUltimaLinha: integer;
  linhaCelula, total_id_escolhidos, ultimo_indice: integer;
  sqlParImpar: TStringList;
  sqlResultado: ansistring;
  sqlParImparComum: string;
  sqlRegistro: TSQLQuery;
begin
  sqlParImpar := TStringList.Create;
  sqlResultado := '';

  indiceUltimaColuna := sgrParImpar15Bolas.ColCount - 1;
  indiceUltimaLinha := sgrParImpar15Bolas.RowCount - 1;

  // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
  // o id da combinação.
  for linhaCelula := 1 to indiceUltimaLinha do
  begin
    if sgrParImpar15Bolas.Cells[indiceUltimaColuna, linhaCelula] = '1' then
    begin
      sqlParImpar.Add(sgrParImpar15Bolas.Cells[0, linhaCelula]);
    end;
  end;

  // Se houver alguma combinação escolhida, iremos concatenar todos os id
  // e retornaremos a consulta where parcial.
  total_id_escolhidos := sqlParImpar.Count;

  if total_id_escolhidos = 0 then
  begin
    Result := '';
    exit;
  end;

  sqlResultado := '';
  uA := 0;
  ultimo_indice := total_id_escolhidos - 1;

  for uA := 0 to ultimo_indice do
  begin
    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlParImpar.Strings[uA];
  end;

  sqlResultado := 'par_impar_id in (' + sqlResultado + ')';

  // Em seguida, devemos, recuperar os ids comuns às outras combinações de
  // de 16, 17 e 18 números, na tabela lotofacil.lotofacil_par_impar_comum.
  // Nesta tabela, tem o próprio id da combinação de 15 números, também.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // No select abaixo, iremos retornar todos as combinações pares x ímpares comum
  // de 16, 17, e 18 bolas, referente à combinação de pares x ímpares de 15 bolas.
  // Eu indiquei 'distinct', pois, há combinaçõe que são comum a mais de uma combinação
  // e retornar somente identificadores sem repetir.

  sqlParImparComum :=
    'Select distinct par_impar_comum_id from lotofacil.lotofacil_id_par_impar_comum where ';
  sqlParImparComum := sqlParImparComum + sqlResultado;
  sqlParImparComum := sqlParImparComum + ' order by par_impar_comum_id asc';

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := sqlParImparComum;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Sempre haverá registros comuns nas outras combinações.
  sqlResultado := '';

  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin

    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlRegistro.FieldByName(
      'par_impar_comum_id').AsString;
    sqlRegistro.Next;
  end;

  // Após isto, devemo gerar a claúsula where parcial.
  sqlResultado := 'par_impar_id in (' + sqlResultado + ')';

  Result := sqlResultado;
end;

{
 Gera o sql das combinações externo x internos
 No programa, as combinações de externos e internos são de 15 números, após o usuário
 selecionar tais combinações, a função abaixo, recupera automaticamente as combinações
 externas e internas das outras quantidades de 16, 17 e 18 números.
 Tais combinações estão localizadas na tabela externo_interno_comum.
}
function TForm1.GerarSqlExternoInterno: string;
var
  uA, indiceUltimaColuna: integer;
  indiceUltimaLinha: integer;
  linhaCelula, total_id_escolhidos, ultimo_indice: integer;
  sqlExternoInterno: TStringList;
  sqlResultado: ansistring;
  sqlExternoInternoComum: string;
  sqlRegistro: TSQLQuery;
begin
  sqlExternoInterno := TStringList.Create;
  sqlResultado := '';

  indiceUltimaColuna := sgrExternoInterno15Bolas.ColCount - 1;
  indiceUltimaLinha := sgrExternoInterno15Bolas.RowCount - 1;

  // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
  // o id da combinação.
  for linhaCelula := 1 to indiceUltimaLinha do
  begin
    if sgrExternoInterno15Bolas.Cells[indiceUltimaColuna, linhaCelula] = '1' then
    begin
      sqlExternoInterno.Add(sgrExternoInterno15Bolas.Cells[0, linhaCelula]);
    end;
  end;

  // Se houver alguma combinação escolhida, iremos concatenar todos os id
  // e retornaremos a consulta where parcial.
  total_id_escolhidos := sqlExternoInterno.Count;

  if total_id_escolhidos = 0 then
  begin
    Result := '';
    exit;
  end;

  sqlResultado := '';
  uA := 0;
  ultimo_indice := total_id_escolhidos - 1;

  for uA := 0 to ultimo_indice do
  begin
    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlExternoInterno.Strings[uA];
  end;

  sqlResultado := 'ext_int_id in (' + sqlResultado + ')';

  // Em seguida, devemos, recuperar os ids comuns às outras combinações de
  // de 16, 17 e 18 números, na tabela lotofacil.lotofacil_par_impar_comum.
  // Nesta tabela, tem o próprio id da combinação de 15 números, também.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // No select abaixo, iremos retornar todos as combinações pares x ímpares comum
  // de 16, 17, e 18 bolas, referente à combinação de pares x ímpares de 15 bolas.
  // Eu indiquei 'distinct', pois, há combinaçõe que são comum a mais de uma combinação
  // e retornar somente identificadores sem repetir.

  sqlExternoInternoComum :=
    'Select distinct ext_int_comum_id from lotofacil.lotofacil_id_externo_interno_comum where ';
  sqlExternoInternoComum := sqlExternoInternoComum + sqlResultado;
  sqlExternoInternoComum := sqlExternoInternoComum + ' order by ext_int_comum_id asc';

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := sqlExternoInternoComum;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Sempre haverá registros comuns nas outras combinações.
  sqlResultado := '';

  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin

    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlRegistro.FieldByName(
      'ext_int_comum_id').AsString;
    sqlRegistro.Next;
  end;

  // Após isto, devemo gerar a claúsula where parcial.
  sqlResultado := 'ext_int_id in (' + sqlResultado + ')';

  Result := sqlResultado;
end;

{
 Gera o sql das combinações externo x internos
 No programa, as combinações de externos e internos são de 15 números, após o usuário
 selecionar tais combinações, a função abaixo, recupera automaticamente as combinações
 externas e internas das outras quantidades de 16, 17 e 18 números.
 Tais combinações estão localizadas na tabela externo_interno_comum.
}
function TForm1.GerarSqlPrimo: string;
var
  uA, indiceUltimaColuna: integer;
  indiceUltimaLinha: integer;
  linhaCelula, total_id_escolhidos, ultimo_indice: integer;
  sqlPrimo: TStringList;
  sqlResultado: ansistring;
  sqlPrimoComum: string;
  sqlRegistro: TSQLQuery;
begin
  sqlPrimo := TStringList.Create;
  sqlResultado := '';

  indiceUltimaColuna := sgrPrimo15Bolas.ColCount - 1;
  indiceUltimaLinha := sgrPrimo15Bolas.RowCount - 1;

  // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
  // o id da combinação.
  for linhaCelula := 1 to indiceUltimaLinha do
  begin
    if sgrPrimo15Bolas.Cells[indiceUltimaColuna, linhaCelula] = '1' then
    begin
      sqlPrimo.Add(sgrPrimo15Bolas.Cells[0, linhaCelula]);
    end;
  end;

  // Se houver alguma combinação escolhida, iremos concatenar todos os id
  // e retornaremos a consulta where parcial.
  total_id_escolhidos := sqlPrimo.Count;

  if total_id_escolhidos = 0 then
  begin
    Result := '';
    exit;
  end;

  sqlResultado := '';
  uA := 0;
  ultimo_indice := total_id_escolhidos - 1;

  for uA := 0 to ultimo_indice do
  begin
    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlPrimo.Strings[uA];
  end;

  sqlResultado := 'prm_id in (' + sqlResultado + ')';

  // Em seguida, devemos, recuperar os ids comuns às outras combinações de
  // de 16, 17 e 18 números, na tabela lotofacil.lotofacil_par_impar_comum.
  // Nesta tabela, tem o próprio id da combinação de 15 números, também.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // No select abaixo, iremos retornar todos as combinações pares x ímpares comum
  // de 16, 17, e 18 bolas, referente à combinação de pares x ímpares de 15 bolas.
  // Eu indiquei 'distinct', pois, há combinaçõe que são comum a mais de uma combinação
  // e retornar somente identificadores sem repetir.

  sqlPrimoComum :=
    'Select distinct prm_comum_id from lotofacil.lotofacil_id_primo_comum where ';
  sqlPrimoComum := sqlPrimoComum + sqlResultado;
  sqlPrimoComum := sqlPrimoComum + ' order by prm_comum_id asc';

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := sqlPrimoComum;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Sempre haverá registros comuns nas outras combinações.
  sqlResultado := '';

  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin

    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlRegistro.FieldByName('prm_comum_id').AsString;
    sqlRegistro.Next;
  end;

  // Após isto, devemo gerar a claúsula where parcial.
  sqlResultado := 'prm_id in (' + sqlResultado + ')';

  Result := sqlResultado;
end;

{
 Retorna o sql de todos os controles onde o usuário seleciona as bolas
 conforme a posição na combinação.
}
function TForm1.GerarSqlBolas_Por_Posicao: string;
var
  controle_bolas_por_posicao : array[1..15] of TStringGrid;
  lista_de_sql : TSTrings;
  str_sql : AnsiString;
  celula_linha , indice_ultima_linha, uA, indice_ultima_coluna: Integer;
begin
  lista_de_sql := TStringList.Create;
  lista_de_sql.Clear;

  // Popula os controles:
  controle_bolas_por_posicao[1] := sgrColunaB1;
  controle_bolas_por_posicao[2] := sgrColunaB2;
  controle_bolas_por_posicao[3] := sgrColunaB3;
  controle_bolas_por_posicao[4] := sgrColunaB4;
  controle_bolas_por_posicao[5] := sgrColunaB5;
  controle_bolas_por_posicao[6] := sgrColunaB6;
  controle_bolas_por_posicao[7] := sgrColunaB7;
  controle_bolas_por_posicao[8] := sgrColunaB8;
  controle_bolas_por_posicao[9] := sgrColunaB9;
  controle_bolas_por_posicao[10] := sgrColunaB10;
  controle_bolas_por_posicao[11] := sgrColunaB11;
  controle_bolas_por_posicao[12] := sgrColunaB12;
  controle_bolas_por_posicao[13] := sgrColunaB13;
  controle_bolas_por_posicao[14] := sgrColunaB14;
  controle_bolas_por_posicao[15] := sgrColunaB15;

  // Agora, iremos percorrer cada linha do controle
  // e verificar se a coluna 'marcar' tem algo marcado.
  for uA := 1 to High(controle_bolas_por_posicao) do begin

    // A coluna 'marcar' é a última coluna do controle.
    indice_ultima_coluna := controle_bolas_por_posicao[uA].Columns.Count - 1;
    indice_ultima_linha := controle_bolas_por_posicao[uA].RowCount - 1;

    str_sql := '';
    for celula_linha := 1 to indice_ultima_linha do begin

        // Verifica se a coluna marcar da linha atual foi selecionada.
        // Uma seleção terá o valor 1 na célula.
        if controle_bolas_por_posicao[uA].Cells[indice_ultima_coluna, celula_linha] = '1' then begin

           // Se já houve alguma bola selecionada, iremos intersepará com o caractere ','
           // Exemplo: Saiu as bolas 5 e 8, ficará assim: 5, 8
           // Após percorrer todas as linhas, iremos montar o sql parcial deste controle,
           // algo semelhante a: b_1 in (5, 8)
          if str_sql <> '' then begin
            str_sql := str_sql + ', ';
          end;

          str_sql := str_sql + controle_bolas_por_posicao[uA].Cells[0, celula_linha];

        end;
    end;

    // Percorreu todas as linhas deste controle, vamos verificar se houve alguma
    // marcação.
    if str_sql <> '' then begin
      // Houve marcação, então, iremos montar o sql parcial deste controle.
      // Algo semelhante a: b_1 in (5, 8)

      str_sql := '(b_' + IntToStr(uA) + ' in (' + str_sql + '))';

      // Vamos verificar se já houve sql gerados anteriormente, se sim interseparar
      // com o operador 'and'.
      if lista_de_sql.Count <> 0 then begin
        lista_de_sql.Add('and');
      end;

      // Adiciona o sql gerado.
      lista_de_sql.Add(str_sql);

    end;
  end;

  // Retorna a lista de sql gerados com um string.
  Exit(Trim(lista_de_sql.Text));
end;

{
 Gera o sql das colunas b: b1, b4, b8, b12, b15 e também das colunas b: b1, b2, b3, b4 e b5.
 Aqui, é gerado dois sql, um pra os controles:
 sgrColunaB1_B2_B3_B4_B5_15Bolas,
 sgrColunaB1_B2_B3_B4_15Bolas,
 sgrColunaB1_B2_B3_15Bolas,
 sgrColunaB1_B2_15Bolas
 sgrColunaB1_15Bolas
 e,
 o segundo sql:
 sgrColunaB1_B4_B8_B12_B15_15Bolas;
 sgrColunaB1_B8_B15_15Bolas;
 sgrColunaB1_B15_15Bolas;
 sgrColunaB1_15Bolas;

 Isto ocorre por que antes, eu gerava sql somente pra os controles:
 sgrColunaB1_B4_B8_B12_B15_15Bolas;
 sgrColunaB1_B8_B15_15Bolas;
 sgrColunaB1_B15_15Bolas;
 sgrColunaB1_15Bolas;

 Então, posteriormente, resolvi criar os outros controles:
 sgrColunaB1_B2_B3_B4_B5_15Bolas,
 sgrColunaB1_B2_B3_B4_15Bolas,
 sgrColunaB1_B2_B3_15Bolas,
 sgrColunaB1_B2_15Bolas
 sgrColunaB1_15Bolas

 No programa, o usuário seleciona o controle mais a esquerda, automaticamente,
 o próximo controle a direita é atualizado então, ao gerarmos o sql com
 as informações selecionadas pelo usuário devemos começar com o controle mais a
 direita, pois este controle é atualizado conforme o controle a esquerda.
 Se vc observar, a combinação b1_b2_b3_b4_b5 contém a combinação b1_b2_b3_b4,
 a combinação b1_b2_b3_b4 contém a combinação b1_b2_b3 e assim por diante.
 Algo, quase semelhante ocorreu pra as combinações: b1, b4, b8, b12 e b15, neste caso:
 b1_b4_b8_b12_15 contém b1_b8_b15;
 b1_b8_15 contém b1_b15.

 O objetivo deste controle é pegar as combinações que mais saí baseado, onde
 as bolas estão na posição das colunas.
}
function TForm1.GerarSqlColunaB: string;
var
  uA, indiceUltimaColuna: integer;
  indiceUltimaLinha: integer;
  linhaCelula, total_id_escolhidos, ultimo_indice, uB: integer;

  sqlColuna_b: TStringList;

  controles_coluna_b1_b2_b3_b4_b5: array[0..4] of TStringGrid;

  // O controle sgrColuna_b1_15Bolas é comum aos dois tipos de sql, então
  // ele será analizado posteriomente.
  coluna_b: array[0..4] of ansistring = (
            'b1_b2_b3_b4_b5_id',
            'b1_b2_b3_b4_id',
            'b1_b2_b3_id',
            'b1_b2_id',
            'b1_id');

  controles_coluna_b1_b4_b8_b12_b15: array[0..3] of TStringGrid;
  coluna_b1_b4_b8_b12_b15: array[0..3] of AnsiString = (
                           'b1_b4_b8_b12_b15_id',
                           'b1_b8_b15_id',
                           'b1_b15_id',
                           'b1_id'
  );

  sqlResultado_b1_b2_b3_b4_b5: ansistring;
  sqlResultado_b1_b4_b8_b12_b15 : String;

begin
  sqlColuna_b := TStringList.Create;

  sqlColuna_b.Clear;
  sqlResultado_b1_b2_b3_b4_b5 := '';

  controles_coluna_b1_b2_b3_b4_b5[0] := sgrColunaB1_B2_B3_B4_B5_15Bolas;
  controles_coluna_b1_b2_b3_b4_b5[1] := sgrColunaB1_B2_B3_B4_15Bolas;
  controles_coluna_b1_b2_b3_b4_b5[2] := sgrColunaB1_B2_B3_15Bolas;
  controles_coluna_b1_b2_b3_b4_b5[3] := sgrColunaB1_B2_15Bolas;
  controles_coluna_b1_b2_b3_b4_b5[4] := sgrColunaB1_15Bolas;  ;

  // Vamos percorrer cada controle, começando do controle com maior quantidade
  // de coluna e indo até o controle com menor quantidade de colunas,
  // Ao encontrarmos o primeiro controle com alguma marcação, iremos gerar o sql
  // e saíremos do loop.
  for uA := 0 to High(controles_coluna_b1_b2_b3_b4_b5) do
  begin
    indiceUltimaColuna := controles_coluna_b1_b2_b3_b4_b5[uA].ColCount - 1;
    indiceUltimaLinha := controles_coluna_b1_b2_b3_b4_b5[uA].RowCount - 1;

    // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
    // o id da combinação.
    for linhaCelula := 1 to indiceUltimaLinha do
    begin
      if controles_coluna_b1_b2_b3_b4_b5[uA].Cells[indiceUltimaColuna, linhaCelula] = '1' then
      begin
        sqlColuna_b.Add(controles_coluna_b1_b2_b3_b4_b5[uA].Cells[0, linhaCelula]);
      end;
    end;

    // Se houver alguma combinação escolhida, iremos concatenar todos os id
    // e retornaremos a consulta where parcial.
    total_id_escolhidos := sqlColuna_b.Count;

    if total_id_escolhidos = 0 then
    begin
      Continue;
    end;

    sqlResultado_b1_b2_b3_b4_b5 := '';

    ultimo_indice := total_id_escolhidos - 1;

    uB := 0;
    for uB := 0 to ultimo_indice do
    begin
      if sqlResultado_b1_b2_b3_b4_b5 <> '' then
      begin
        sqlResultado_b1_b2_b3_b4_b5 := sqlResultado_b1_b2_b3_b4_b5 + ', ';
      end;
      sqlResultado_b1_b2_b3_b4_b5 := sqlResultado_b1_b2_b3_b4_b5 + sqlColuna_b.Strings[uB];
    end;

    sqlResultado_b1_b2_b3_b4_b5 := coluna_b[uA] + ' in (' + sqlResultado_b1_b2_b3_b4_b5 + ')';

    // Se chegarmos aqui, quer dizer que encontramos algum controle marcado e geramos o sql
    // deste controle, então, devemos sair do loop.
    break;
  end;

  // Verificar os controles:
  // sgrColunaB1_B4_B8_B12_B15_15Bolas;
  // sgrColunaB1_B8_B15_15Bolas;
  // sgrColunaB1_B15_15Bolas;
  // sgrColunaB1_15Bolas;
  // O código for abaixo é semelhante ao código do for anterior, simplesmente,
  // copie o código e alterei o nome das variáveis, poderia ter utilizado um único
  // for entretanto, o código não ficaria bem claro.

  controles_coluna_b1_b4_b8_b12_b15[0] := sgrColunaB1_B4_B8_B12_B15_15Bolas;
  controles_coluna_b1_b4_b8_b12_b15[1] := sgrColunaB1_B8_B15_15Bolas;
  controles_coluna_b1_b4_b8_b12_b15[2] := sgrColunaB1_B15_15Bolas;
  controles_coluna_b1_b4_b8_b12_b15[3] := sgrColunaB1_15Bolas;

  // Vamos percorrer cada controle, começando do controle com maior quantidade
  // de coluna e indo até o controle com menor quantidade de colunas,
  // Ao encontrarmos o primeiro controle com alguma marcação, iremos gerar o sql
  // e saíremos do loop.
  sqlColuna_b.Clear;
  for uA := 0 to High(controles_coluna_b1_b4_b8_b12_b15) do
  begin
    indiceUltimaColuna := controles_coluna_b1_b4_b8_b12_b15[uA].ColCount - 1;
    indiceUltimaLinha := controles_coluna_b1_b4_b8_b12_b15[uA].RowCount - 1;

    // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
    // o id da combinação.
    for linhaCelula := 1 to indiceUltimaLinha do
    begin
      if controles_coluna_b1_b4_b8_b12_b15[uA].Cells[indiceUltimaColuna, linhaCelula] = '1' then
      begin
        sqlColuna_b.Add(controles_coluna_b1_b4_b8_b12_b15[uA].Cells[0, linhaCelula]);
      end;
    end;

    // Se houver alguma combinação escolhida, iremos concatenar todos os id
    // e retornaremos a consulta where parcial.
    total_id_escolhidos := sqlColuna_b.Count;

    if total_id_escolhidos = 0 then
    begin
      Continue;
    end;

    sqlResultado_b1_b4_b8_b12_b15 := '';
    ultimo_indice := total_id_escolhidos - 1;

    uB := 0;
    for uB := 0 to ultimo_indice do
    begin
      if sqlResultado_b1_b4_b8_b12_b15 <> '' then
      begin
        sqlResultado_b1_b4_b8_b12_b15 := sqlResultado_b1_b4_b8_b12_b15 + ', ';
      end;
      sqlResultado_b1_b4_b8_b12_b15 := sqlResultado_b1_b4_b8_b12_b15 + sqlColuna_b.Strings[uB];
    end;

    sqlResultado_b1_b4_b8_b12_b15 := coluna_b1_b4_b8_b12_b15[uA] + ' in (' + sqlResultado_b1_b4_b8_b12_b15 + ')';
    // Se chegarmos aqui, quer dizer que encontramos algum controle marcado e geramos o sql
    // deste controle, então, devemos sair do loop.
    break;
  end;

  // Retorna o sql gerado.
  if (sqlResultado_b1_b2_b3_b4_b5 <> '') and (sqlResultado_b1_b4_b8_b12_b15 <> '') then
  begin
    Result := '((' + sqlResultado_b1_b2_b3_b4_b5 + ') and (' + sqlResultado_b1_b4_b8_b12_b15 + '))';
  end else begin
    // Um dos string ou ambos são vazios, então não há problema em concatená-los.
    Result := sqlResultado_b1_b2_b3_b4_b5 + sqlResultado_b1_b4_b8_b12_b15;
  end;
end;

{
 Gera o sql das combinações algarismo_na_dezena selecionado pelo usuário.
 Retorna um string vazio, se nada foi selecionado.
 Observação:
 No caso das combinações de algarismos, devemos após pegar o id
 das combinações selecionadas, devemos executar uma segunda consulta
 desta vez pra obter as combinações comuns a cada id selecionado
 das outras quantidades de bolas.
}
//TODO: Falta mover esta funçtion pra a classe TLofacilParImpar.
function TForm1.Gerar_sql_algarismo_na_dezena: string;
var
  uA, indiceUltimaColuna: integer;
  indiceUltimaLinha: integer;
  linhaCelula, total_id_escolhidos, ultimo_indice: integer;
  lista_de_itens_marcados: TStringList;
  sqlResultado: ansistring;
  sqlParImparComum: string;
  sqlRegistro: TSQLQuery;
begin
  lista_de_itens_marcados := TStringList.Create;
  sqlResultado := '';

  indiceUltimaColuna := sgrAlgarismo_na_dezena.ColCount - 1;
  indiceUltimaLinha := sgrAlgarismo_na_dezena.RowCount - 1;

  // Iremos verificar se a coluna marcar, tem o valor 1, se sim, iremos pegar
  // o id da combinação.
  for linhaCelula := 1 to indiceUltimaLinha do
  begin
    if sgrAlgarismo_na_dezena.Cells[indiceUltimaColuna, linhaCelula] = '1' then
    begin
      lista_de_itens_marcados.Add(sgrAlgarismo_na_dezena.Cells[0, linhaCelula]);
    end;
  end;

  // Se houver alguma combinação escolhida, iremos concatenar todos os id
  // e retornaremos a consulta where parcial.
  total_id_escolhidos := lista_de_itens_marcados.Count;

  if total_id_escolhidos = 0 then
  begin
    Result := '';
    exit;
  end;

  sqlResultado := '';
  uA := 0;
  ultimo_indice := total_id_escolhidos - 1;

  for uA := 0 to ultimo_indice do
  begin
    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + lista_de_itens_marcados.Strings[uA];
  end;

  sqlResultado := 'dz_id in (' + sqlResultado + ')';

  // Em seguida, devemos, recuperar os ids comuns às outras combinações de
  // de 16, 17 e 18 números, na tabela lotofacil.lotofacil_par_impar_comum.
  // Nesta tabela, tem o próprio id da combinação de 15 números, também.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // No select abaixo, iremos retornar todos as combinações pares x ímpares comum
  // de 16, 17, e 18 bolas, referente à combinação de pares x ímpares de 15 bolas.
  // Eu indiquei 'distinct', pois, há combinaçõe que são comum a mais de uma combinação
  // e retornar somente identificadores sem repetir.

  sqlParImparComum :=
    'Select distinct dz_id_comum from lotofacil.lotofacil_id_algarismo_na_dezena_comum where ';
  sqlParImparComum := sqlParImparComum + sqlResultado;
  sqlParImparComum := sqlParImparComum + ' order by dz_id_comum asc';

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := sqlParImparComum;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Sempre haverá registros comuns nas outras combinações.
  sqlResultado := '';

  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin

    if sqlResultado <> '' then
    begin
      sqlResultado := sqlResultado + ', ';
    end;

    sqlResultado := sqlResultado + sqlRegistro.FieldByName(
      'dz_id_comum').AsString;
    sqlRegistro.Next;
  end;

  // Após isto, devemo gerar a claúsula where parcial.
  sqlResultado := 'dz_id in (' + sqlResultado + ')';

  Result := sqlResultado;
end;


function TForm1.GerarSqlDiferenca_qt_dif: string;
var
  uA, indice_ultima_coluna, indice_ultima_linha: integer;
  sqlResultado: ansistring;
begin
  // Primeiro verifica o controle sgrDiferencia_qt_1_qt_2
  // Se houver algo marcado, não iremos verificar o próximo controle.
  indice_ultima_coluna := sgrDiferenca_Qt_1_Qt_2.ColCount - 1;
  indice_ultima_linha := sgrDiferenca_Qt_1_Qt_2.RowCount - 1;

  // Se a coluna marcar, estiver com o valor 1, quer dizer
  // que foi selecionada, devemos pegar o campo
  // qt_cmb, que está no índice de número 2.
  sqlResultado := '';
  for uA := 1 to indice_ultima_linha do
  begin
    if sgrDiferenca_Qt_1_Qt_2.Cells[indice_ultima_coluna, uA] = '1' then
    begin
      if sqlResultado <> '' then
      begin
        sqlResultado := sqlResultado + ', ';
      end;
      // A coluna na posição número 2, armazena a combinação dos campos qt_1 e qt_2 interseparados pelo
      // caractere sublinhado: '_'.
      sqlResultado := sqlResultado + QuotedStr(sgrDiferenca_Qt_1_Qt_2.Cells[2, uA]);
    end;
  end;

  if sqlResultado <> '' then
  begin
    sqlResultado := 'qt_dif_1 || ''_'' || qt_dif_2 in (' + sqlResultado + ')';
    Exit(sqlResultado);
  end;

  indice_ultima_coluna := sgrDiferenca_Qt_1.ColCount - 1;
  indice_ultima_linha := sgrDiferenca_Qt_1.RowCount - 1;

  // Se a coluna marcar, estiver com o valor 1, quer dizer
  // que foi selecionada, devemos pegar o campo
  // qt_cmb, que está no índice de número 2.
  sqlResultado := '';
  for uA := 1 to indice_ultima_linha do
  begin
    if sgrDiferenca_Qt_1.Cells[indice_ultima_coluna, uA] = '1' then
    begin
      if sqlResultado <> '' then
      begin
        sqlResultado := sqlResultado + ', ';
      end;
      // Corrigido: Estava apontando pra a coluna 2 ao invés da coluna 1.
      sqlResultado := sqlResultado + QuotedStr(sgrDiferenca_Qt_1.Cells[0, uA]);
    end;
  end;

  if sqlResultado <> '' then
  begin
    sqlResultado := 'qt_dif_1 in (' + sqlResultado + ')';
    Exit(sqlResultado);
  end;



end;

{
 Gera o sql para a quantidade de alternadores de diferenças que o usuário selecionou.
 Há 3 controles:
 //    sgrDiferenca_qt_alt_2
 //    sgrDiferenca_qt_alt_1
 //    sgrDiferenca_qt_alt

 // Os 3 controles:
 //    sgrDiferenca_qt_alt_2
 //    sgrDiferenca_qt_alt_1
 //    sgrDiferenca_qt_alt
 // Serão analisados nesta ordem:
 //    sgrDiferenca_qt_alt_2
 //    sgrDiferenca_qt_alt_1
 //    sgrDiferenca_qt_alt
 // Pois, o controle sgrDiferenca_qt_alt_2 depende do controle sgrDiferenca_qt_alt_1,
 // e o controle sgrDiferenca_qt_alt_1 depende do controle sgrDiferenca_qt_alt;
 // Ou seja, quando o usuário clica no controle: sgrDiferenca_qt_alt, automaticamente,
 // o controles sgrDiferenca_qt_alt_1 e sgrDiferenca_qt_alt_2 são atualizados.;
}
function TForm1.GerarSqlDiferenca_qt_alt: string;
var
  uA, indice_ultima_coluna, indice_ultima_linha: integer;
  sqlResultado: ansistring;
begin
  // Primeiro verifica o controle sgrDiferencia_qt_1_qt_2
  // Se houver algo marcado, não iremos verificar o próximo controle.
  indice_ultima_coluna := sgrDiferenca_qt_alt_2.ColCount - 1;
  indice_ultima_linha := sgrDiferenca_qt_alt_2.RowCount - 1;

  // Se a coluna marcar, estiver com o valor 1, quer dizer
  // que foi selecionada, devemos pegar o campo
  // qt_cmb, que está no índice de número 3.
  sqlResultado := '';
  for uA := 1 to indice_ultima_linha do
  begin
    if sgrDiferenca_qt_alt_2.Cells[indice_ultima_coluna, uA] = '1' then
    begin
      if sqlResultado <> '' then
      begin
        sqlResultado := sqlResultado + ', ';
      end;
      // No controle 'sgrDiferenca_qt_alt_2' tem os campos:
      // 'qt_alt', 'qt_dif_1', 'qt_dif_2', qt_cmb, ltf_qt, res_qt'
      // Iremos pegar o campo 'qt_cmb', que tem os campos 'qt_alt', 'qt_dif_1' e 'qt_dif_2'
      // concatenados e interseparados pelo caractere sublinhado: _ .
      sqlResultado := sqlResultado + QuotedStr(sgrDiferenca_qt_alt_2.Cells[3, uA]);
    end;
  end;

  // Se houve alguma linha selecionada pelo usuário devemos gerar o sql dinamicamente
  // e em seguida, retornar o string selecionado e não iremos analisar mais
  // nenhum controle
  if sqlResultado <> '' then
  begin
    sqlResultado := 'qt_alt || ''_'' || qt_dif_1 || ''_'' || qt_dif_2 in (' +
      sqlResultado + ')';
    Exit(sqlResultado);
  end;

  // Se chegamos aqui, quer dizer, que o controle anterior: sgrDiferenca_qt_alt_2
  // não foi selecionado nenhuma combinação.
  // Então, devemos analisar o próximo controle.
  indice_ultima_coluna := sgrDiferenca_qt_alt_1.ColCount - 1;
  indice_ultima_linha := sgrDiferenca_qt_alt_1.RowCount - 1;

  // Se a coluna marcar, estiver com o valor 1, quer dizer
  // que foi selecionado algo, devemos pegar o campo
  // qt_cmb, que está no índice de número 2.
  sqlResultado := '';
  for uA := 1 to indice_ultima_linha do
  begin
    if sgrDiferenca_qt_alt_1.Cells[indice_ultima_coluna, uA] = '1' then
    begin
      if sqlResultado <> '' then
      begin
        sqlResultado := sqlResultado + ', ';
      end;
      // O controle sgrDiferenca_qt_alt_1 tem estes campos:
      // qt_alt, qt_dif_1, qt_cmb, ltf_qt, res_qt,
      // Iremos pegar o campo 'qt_cmb', que está no índice 2.
      sqlResultado := sqlResultado + QuotedStr(sgrDiferenca_qt_alt_1.Cells[2, uA]);
    end;
  end;

  if sqlResultado <> '' then
  begin
    sqlResultado := 'qt_alt || ''_'' || qt_dif_1 in (' + sqlResultado + ')';
    Exit(sqlResultado);
  end;

  // Se chegarmos aqui, que dizer, que no controle 'sgrDiferenca_qt_alt_1'
  // nenhuma combinação foi escolhida.
  // Devemos verificar o próximo controle.
  indice_ultima_coluna := sgrDiferenca_qt_alt.ColCount - 1;
  indice_ultima_linha := sgrDiferenca_qt_alt.RowCount - 1;

  // Se a coluna marcar, estiver com o valor 1, quer dizer
  // que foi selecionado algo, devemos pegar o campo
  // qt_cmb, que está no índice de número 2.
  sqlResultado := '';
  for uA := 1 to indice_ultima_linha do
  begin
    if sgrDiferenca_qt_alt.Cells[indice_ultima_coluna, uA] = '1' then
    begin
      if sqlResultado <> '' then
      begin
        sqlResultado := sqlResultado + ', ';
      end;
      // O controle sgrDiferenca_qt_alt tem estes campos:
      // qt_alt, ltf_qt, res_qt,
      // Iremos pegar o campo 'qt_alt', que está no índice 0.
      sqlResultado := sqlResultado + QuotedStr(sgrDiferenca_qt_alt.Cells[0, uA]);
    end;
  end;

  if sqlResultado <> '' then
  begin
    sqlResultado := 'qt_alt in (' + sqlResultado + ')';
    Exit(sqlResultado);
  end;

  // Se chegarmos aqui, quer dizer, que nada foi selecionado retornar um
  // string vazio.
  Exit('');

end;


{
 Atualizar lista de novos x repetidos.
}
procedure TForm1.btnAtualizarNovosRepetidosAntigoClick(Sender: TObject);
var
  strSql: TStringList;
  sqlRegistro: TSqlQuery;
  qtRegistros, uLinha, uA: integer;
  concursoAtualizar: longint;
  concursoParametro: TParam;
begin
  {
  // Pega o concurso atual do combobox.
  concursoAtualizar := StrToInt(
    cmbConcursoNovosRepetidos.Items[cmbConcursoNovosRepetidos.ItemIndex]);

  strSql := TStringList.Create;
  strSql.Add('select lotofacil.fn_lotofacil_atualizar_novos_repetidos_4($1)');

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := strSql.Text;
  sqlRegistro.UniDirectional := True;

  concursoParametro := sqlRegistro.Params.CreateParam(TFieldType.ftInteger,
    '$1', TParamType.ptInput);
  concursoParametro.AsInteger := concursoAtualizar;

  sqlRegistro.Prepare;

  sqlRegistro.ExecSQL;
  dmLotofacil.pgLTK.Transaction.Commit;

  sqlRegistro.Close;

  ;

  CarregarTodosControles;
  }

end;

procedure TForm1.btnAtualizarSomaFrequenciaClick(Sender : TObject);
const
  TOTAL_DE_ITENS = 500000;
type
  rd_lotofacil_arquivo = record
    ltf_id: Integer;
    ltf_qt: Integer;
    grp_id: Integer;
  end;
  type
    p_Lotofacil_arquivo = ^rd_lotofacil_arquivo;
var
  fbArquivo : TFileStream;
  ltf_arquivo: array[0..TOTAL_DE_ITENS-1] of rd_lotofacil_arquivo;
  ltf_arquivo_2: rd_lotofacil_arquivo;
  total_lido , total_lido_do_arquivo: LongInt;
  mensagem : String;
  p_ltf_arquivo : Pointer;
  lotofacil_soma_frequencia : TLotofacilSomaFrequenciaThread;

begin

  btnAtualizarSomaFrequencia.Enabled := false;

  lotofacil_soma_frequencia := TLotofacilSomaFrequenciaThread.Create(Self, true);
  lotofacil_soma_frequencia.concurso_inicial := 1;
  lotofacil_soma_frequencia.concurso_final := 1900;
  lotofacil_soma_frequencia.qt_bolas_por_grupo := rdSomaFrequenciaPrecisaoBolas.ItemIndex + 1;
  lotofacil_soma_frequencia.OnStatus := @Soma_Frequencia_Status;
  lotofacil_soma_frequencia.OnStatus_Erro := @Soma_Frequencia_Status_Erro;
  lotofacil_soma_frequencia.OnStatus_Concluido := @Soma_Frequencia_Status_Concluido;
  lotofacil_soma_frequencia.Start;
  {

  fbArquivo := TFileStream.Create('/run/media/fabiuz/000E4C3400030AE7/LTK/ltk_gerador_binario_de_grupos/arquivos_csv/lotofacil_grupo_2_bolas.ltf_bin',
            fmOpenRead);

  total_lido := sizeof(rd_lotofacil_arquivo);

  total_lido_do_arquivo := fbArquivo.Read(ltf_arquivo, total_lido  * TOTAL_DE_ITENS);

  ltf_arquivo_2 := ltf_arquivo[0];
  ltf_arquivo_2 := ltf_arquivo[1];



  //ltf_arquivo.ltf_id := p_lotofacil_arquivo(p_ltf_arquivo)^.ltf_id;
  //Inc(p_ltf_arquivo, sizeof(rd_lotofacil_arquivo));

  //ltf_arquivo := p_Lotofacil_arquivo(p_ltf_arquivo)^;


  //while total_lido = fbArquivo.Read(ltf_arquivo, 12) do
  //begin
  //     mensagem := 'ltf_id: ' + IntToStr(ltf_arquivo.ltf_id) + ', ltf_qt: ' + IntToStr(ltf_arquivo.ltf_qt) + ', grp_id: ' +
  //                     IntToStr(ltf_arquivo.grp_id);
  //     total_lido := fbArquivo.Read(ltf_arquivo, 12)
  //end;


  // SetLength(ltf_soma_frequencia, 6704071, 2);



  ShowMessage(mensagem);
  }



end;


{
 Obtém novas combinações aleatórias do banco de dados.
 E atualiza os controles 'cmbAleatorioFiltroData', 'cmbAleatorioFiltroHora'.
}
procedure TForm1.btnAleatorioNovoClick(Sender: TObject);
begin
  obterNovosFiltros(Sender);
end;

procedure TForm1.btnAtualizar_Combinacao_ComplementarClick(Sender: TObject);
var
  uA: integer;
begin

  if Gerar_Complementar_15_Numeros = False then
  begin
    MessageDlg('Erro', 'Erro: ' + strErro, mtError, [mbOK], 0);
    exit;
  end
  else
  begin
    MessageDlg('', 'Combinação complementares com 15 bolas gerado com sucesso.',
      mtError, [mbOK], 0);
  end;


  {
  for uA := 0 to Pred(chkComplementar_Bolas_por_combinacao.Items.Count) do
  begin
    if chkComplementar_Bolas_por_combinacao.Checked[uA] then begin
      Atualizar_Combinacao_Complementar(15 + uA);
    end;
  end;
  }

end;

{
 Ao clicar no botão btnFiltroExcluirTodos, exibe mensagem pra o usuário
 perguntando se realmente deseja excluir todos os registros, se sim,
 faça a exclusão.
}
procedure TForm1.btnFiltroExcluirTodosClick(Sender : TObject);
var
  sql_registros : TSQLQuery;
begin
  // Pergunta ao usuário se realmente deseja excluir
  if mrNo = MessageDlg('', 'Você desejar excluir todos os filtros?', mtConfirmation, [mbYes, mbNo], 0) then
  begin
    Exit;
  end;

  if dmLotofacil = nil then begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sql_registros := TSqlQuery.Create(Self);
  sql_registros.DataBase := dmLotofacil.pgLTK;
  sql_registros.SQL.Clear;
  sql_registros.Sql.Add('Truncate lotofacil.lotofacil_filtros');

  try
    sql_registros.ExecSQL;
    dmLotofacil.pgLTK.Transaction.Commit;
  except
    On exc: EDatabaseError do begin
       MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbok], 0);
       Exit;
    end;
  end;

  MessageDlg('', 'Todos os filtros foram excluídos com sucesso!!!', mtInformation, [mbok], 0);

  sgrFiltros.Clear;
  obterNovosFiltros(btnNovosFiltros);

end;

{
 Atualizar a tabela 'lotofacil_complementar'.
}
procedure TForm1.Atualizar_Combinacao_Complementar(bolas_por_combinacao: integer);
var
  sql_registro, sql_atualizar: TSQLQuery;
  id_complementar_sequencia, id_complementar_sequencial, uA, uB: integer;
  lotofacil_ltf_id, bola_numero: longint;
  lotofacil_bolas: array[0..26] of integer;
  lotofacil_aleatorio: array of array of integer;
  sql_texto: ansistring;
  lista_ltf_id: TStringList;
  qt_registros_afetados: TRowsCount;

  lotofacil_id: array of integer;
  lista_de_ltf_id: TStringList;
begin

  if (bolas_por_combinacao < 15) and (bolas_por_combinacao > 18) then
  begin
    strErro := Format('Erro, bolas_por_combinacao, fora do intervalo: %d',
      [bolas_por_combinacao]);
    Exit;
  end;

  // Zera o campo id_complementar_sequencial
  sql_registro := TSqlQuery.Create(Self);

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;
  sql_registro.DataBase := dmLotofacil.pgLTK;
  sql_registro.Sql.Clear;

  try
    sql_registro.Sql.Add('Update lotofacil.lotofacil_complementar');
    sql_registro.Sql.Add('set id_complementar_sequencial = 0');
    sql_registro.ExecSql;
    dmLotofacil.pgLTK.Transaction.Commit;
  except
    On exc: EDatabaseError do
    begin
      strErro := exc.Message;
      Exit;
    end;
  end;

  sql_atualizar := TSqlQuery.Create(Self);
  sql_atualizar.DataBase := dmLotofacil.pgLtk;

  id_complementar_sequencial := 0;

  lista_ltf_id := TStringList.Create;

  // Agora, vamos atualizar os complementares.
  while True do
  begin
    sql_registro.Sql.Clear;
    sql_registro.Sql.Add('Select ltf_id from lotofacil.lotofacil_complementar');
    sql_registro.Sql.Add('where id_complementar_sequencial = 0');
    sql_registro.Sql.Add('and ltf_qt = ' + IntToStr(bolas_por_combinacao));
    sql_registro.Sql.Add('order by random() limit 1');
    try
      sql_registro.Open;
    except
      On exc: EDataBaseError do
      begin
        strErro := exc.Message;
        Exit;
      end;
    end;
    sql_registro.First;
    sql_registro.Last;
    if sql_registro.RecordCount = 0 then
    begin
      Exit;
    end;

    sql_registro.First;
    lotofacil_ltf_id := sql_registro.FieldByName('ltf_id').AsInteger;

    // Agora, atualiza este campo, com o valor do id_complementar_sequencial.
    Inc(id_complementar_sequencial);
    sql_registro.Close;
    sql_registro.Sql.Clear;
    sql_registro.SQL.Add('Update lotofacil.lotofacil_complementar');
    sql_registro.Sql.Add('set id_complementar_sequencial = ' +
      IntToStr(id_complementar_sequencial));
    sql_registro.Sql.Add('where ltf_id = ' + IntToStr(lotofacil_ltf_id));

    try
      sql_registro.ExecSql;
      dmLotofacil.pgLTK.Transaction.Commit;
      sql_registro.Close;
    except
      On exc: EDataBaseError do
      begin
        strErro := exc.Message;
        Exit;
      end;
    end;

    // Em seguida, pega as bolas do campo 'ltf_id'.
    sql_registro.SQL.Clear;
    sql_registro.SQL.Add(
      'Select ltf_id, b_1, b_2, b_3, b_4, b_5, b_6, b_7, b_8, b_9, b_10,');
    sql_registro.Sql.Add('b_11, b_12, b_13, b_14, b_15, b_16, b_17, b_18');
    sql_registro.Sql.Add('from lotofacil.lotofacil_bolas');
    sql_registro.Sql.Add('where ltf_id = ' + IntToStr(lotofacil_ltf_id));

    try
      sql_registro.Open;
    except
      On exc: EDataBaseError do
      begin
        strErro := exc.Message;
        Exit;
      end
    end;

    sql_registro.First;
    sql_registro.Last;

    if sql_registro.RecordCount = 0 then
    begin
      strErro := Format('Registro não encontrado, ltf_id = %d', [lotofacil_ltf_id]);
      Exit;
    end;

    // Em seguida, pega as bolas sorteadas.
    FillChar(lotofacil_bolas, sizeof(integer) * 26, 0);

    sql_registro.First;
    for uA := 1 to bolas_por_combinacao do
    begin
      bola_numero := sql_registro.Fields[uA].AsInteger;
      if not ((bola_numero >= 1) and (bola_numero <= 25)) then
      begin
        strErro := Format('Número fora do intervalo: %d', [bola_numero]);
        Exit;
      end;
      lotofacil_bolas[bola_numero] := 1;
    end;

    if Gerar_Combinacao_Complementar(lotofacil_bolas, bolas_por_combinacao,
      lotofacil_aleatorio) = False then
    begin
      Exit;
    end;

    // Obtém o campo 'ltf_id' das bolas geradas.
    sql_registro.Close;
    sql_registro.Sql.Clear;
    sql_registro.Sql.Add('Select ltf_id from lotofacil.lotofacil_bolas');
    sql_registro.Sql.Add('where');

    for uA := 0 to 2 do
    begin
      if uA = 0 then
      begin
        sql_texto := '(';
      end
      else
      begin
        sql_texto := 'or (';
      end;

      for uB := 1 to bolas_por_combinacao do
      begin
        if uB > 1 then
        begin
          sql_texto := sql_texto + ' and ';
        end;
        sql_texto := sql_texto + Format('b_%d = %d', [uB, lotofacil_aleatorio[uA, uB]]);
      end;
      sql_texto := sql_texto + ' and ltf_qt = ' + IntToStr(bolas_por_combinacao);
      sql_texto := sql_texto + ')';
      sql_registro.Sql.Add(sql_texto);
    end;

    Writeln(sql_registro.Sql.Text);

    try
      sql_registro.Open;
    except
      On exc: EDataBaseError do
      begin
        strErro := exc.Message;
        Exit;
      end
    end;

    sql_registro.First;
    sql_registro.Last;

    if (sql_registro.RecordCount = 0) then
    begin
      strErro := Format('Registro não encontrado', []);
      Exit;
    end;

    Writeln(sql_registro.RecordCount);

    if (sql_registro.RecordCount <> 3) then
    begin
      strErro := Format('Era pra ter 3 registros', []);
      Exit;
    end;

    lista_ltf_id.Clear;
    sql_registro.First;
    for uA := 0 to 2 do
    begin
      lista_ltf_id.Add(IntToStr(sql_registro.FieldByName('ltf_id').AsInteger));
      sql_registro.Next;
    end;
    sql_registro.Close;

    // Agora, vamos atualizar o campo 'id_complementar_sequencial';
    for uA := 0 to 2 do
    begin
      Inc(id_complementar_sequencial);
      lotofacil_ltf_id := StrToInt(lista_ltf_id[uA]);
      sql_atualizar.Close;
      sql_atualizar.Sql.Clear;
      sql_atualizar.Sql.Add('Update lotofacil.lotofacil_complementar');
      sql_atualizar.Sql.Add('set id_complementar_sequencial = ' +
        IntToStr(id_complementar_sequencial));
      sql_atualizar.Sql.Add('where id_complementar_sequencial = 0');
      sql_atualizar.Sql.Add('and ltf_id = ' + IntToStr(lotofacil_ltf_id));

      try
        sql_atualizar.ExecSQL;
        dmLotofacil.pgLTK.Transaction.Commit;
      except
        On exc: EDataBaseError do
        begin
          strErro := exc.Message;
          Exit;
        end;
      end;

      qt_registros_afetados := sql_atualizar.RowsAffected;
      if sql_atualizar.RowsAffected >= 1 then
      begin
        Inc(id_complementar_sequencial);
      end;
    end;
  end;
end;

{
 Gerar complementar 15 números.
}
{TODO: Nõa existe mais o complementar de uma combinação.
}
function TForm1.Gerar_Complementar_15_Numeros: boolean;
const
  LOTOFACIL_COMBINACOES = 3268760;
var
  b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15,
  lotofacil_ltf_id: integer;
  lista_id_sequencial: TStringList;

  lotofacil_id: array of array of integer;
  lotofacil_bolas: array[0..25] of integer;
  lotofacil_aleatorio: TAleatorio_Resultado;

  // Na tabela, há um campo 'ltf_id', que é o identificador lotofacil da
  // combinação.
  ltf_id_1, ltf_id_2, ltf_id_3, ltf_id_4, id_lotofacil, uA, uB, qt_itens: integer;
  indice_lista, id_sequencial: longint;

  lista_sql: TStringList;
  sql_registro: TSQLQuery;
begin

  // Pra cada id, haverá 3 combinações complementares,
  // então, iremos gerar ids sequencialmente pra
  // 4 números, a combinação principal e as combinações
  // complementares, pra isso devemos armazenar na lista
  // somente o primeiro id das combinações principais.
  // Pois, esta os números desta lista, serão sorteados aleatoriamente.
  // Nos iremos percorrer todas as combinações possíveis começando
  // do menor identificador pra esta combinação, então pra evitar
  // que as combinações estejam sequencialmente, iremos
  // sortear os números desta lista.
  lista_id_sequencial := TStringList.Create;
  uA := 1;
  while uA <= 13075041 do
  begin
    lista_id_sequencial.Add(IntToStr(uA));
    Inc(uA, 4);
  end;

  SetLength(lotofacil_id, 3268761, 2);
  SetLength(lotofacil_aleatorio, 3, 26);

  lista_sql := TStringList.Create;
  lista_sql.Clear;

  // A cada iteração do loop, esta variável terá o valor incrementado.
  // E também serve pra comparar este valor com o valor retornado
  // pela função 'identificador_grupo_15_bolas'.
  id_lotofacil := 0;
  for b1 := 1 to 25 do
    for b2 := b1 + 1 to 25 do
      for b3 := b2 + 1 to 25 do
        for b4 := b3 + 1 to 25 do
          for b5 := b4 + 1 to 25 do
            for b6 := b5 + 1 to 25 do
              for b7 := b6 + 1 to 25 do
                for b8 := b7 + 1 to 25 do
                  for b9 := b8 + 1 to 25 do
                    for b10 := b9 + 1 to 25 do
                      for b11 := b10 + 1 to 25 do
                        for b12 := b11 + 1 to 25 do
                          for b13 := b12 + 1 to 25 do
                            for b14 := b13 + 1 to 25 do
                              for b15 := b14 + 1 to 25 do
                              begin
                                // Pega o identificador da combinação atual.
                                ltf_id_1 := identificador_grupo_15_bolas(b1, b2, b3, b4, b5,
                                  b6, b7, b8, b9, b10, b11, b12, b13, b14, b15);

                                // Valida o identificador retornado pela função.
                                Inc(id_lotofacil);
                                if ltf_id_1 <> id_lotofacil then
                                begin
                                  strErro := Format(
                                    'Identificador inválido: ltf_id=%d, retornado pela função: %d',
                                    [id_lotofacil, ltf_id_1]);
                                  Exit(False);
                                end;

                                // Verifica se este identificador já foi sorteado.
                                if lotofacil_id[ltf_id_1][0] <> 0 then
                                begin
                                  continue;
                                end;

                                // Vamos zerar o arranjo e obter as três combinações complementares.
                                FillChar(lotofacil_bolas, 26 * sizeof(integer), 0);

                                // Atribui valor 1 pra as bolas sorteadas.
                                lotofacil_bolas[b1] := 1;
                                lotofacil_bolas[b2] := 1;
                                lotofacil_bolas[b3] := 1;
                                lotofacil_bolas[b4] := 1;
                                lotofacil_bolas[b5] := 1;
                                lotofacil_bolas[b6] := 1;
                                lotofacil_bolas[b7] := 1;
                                lotofacil_bolas[b8] := 1;
                                lotofacil_bolas[b9] := 1;
                                lotofacil_bolas[b10] := 1;
                                lotofacil_bolas[b11] := 1;
                                lotofacil_bolas[b12] := 1;
                                lotofacil_bolas[b13] := 1;
                                lotofacil_bolas[b14] := 1;
                                lotofacil_bolas[b15] := 1;

                                if Gerar_Combinacao_Complementar(lotofacil_bolas, 15, lotofacil_aleatorio) =
                                  False then
                                begin
                                  Exit(False);
                                end;

                                // Aqui, iremos pegar o próximo id aleatoriamente que será utilizado
                                // no campo 'id_complementar_sequencial'.
                                if lista_id_sequencial.Count = 0 then
                                begin
                                  MessageDlg('Erro', 'Aumentar a quantidade de ítens', mtError, [mbOK], 0);
                                  Exit(False);
                                end;

                                indice_lista := Random(lista_id_sequencial.Count);
                                id_sequencial := StrToInt(lista_id_sequencial.Strings[indice_lista]);
                                lista_id_sequencial.Delete(indice_lista);

                                lotofacil_id[ltf_id_1][0] := 1;
                                lotofacil_id[ltf_id_1][1] := id_sequencial;

                                // Agora, vamos pegar os 3 identificadores das três combinações complementares
                                // Somente iremos inserir, se nenhum valor foi definido pra aquela combinação.
                                for uA := 0 to 2 do
                                begin
                                  for uB := 1 to 15 do
                                  begin
                                    lotofacil_bolas[uB] := lotofacil_aleatorio[uA, uB];
                                  end;

                                  lotofacil_ltf_id := identificador_grupo_15_bolas(
                                    lotofacil_bolas[1], lotofacil_bolas[2],
                                    lotofacil_bolas[3], lotofacil_bolas[4],
                                    lotofacil_bolas[5], lotofacil_bolas[6],
                                    lotofacil_bolas[7], lotofacil_bolas[8],
                                    lotofacil_bolas[9], lotofacil_bolas[10],
                                    lotofacil_bolas[11],
                                    lotofacil_bolas[12],
                                    lotofacil_bolas[13],
                                    lotofacil_bolas[14],
                                    lotofacil_bolas[15]);

                                  // Só gerar o sql, se a combinação ainda não foi sorteada.
                                  if lotofacil_id[lotofacil_ltf_id][0] = 0 then
                                  begin
                                    Inc(id_sequencial);

                                    lotofacil_id[lotofacil_ltf_id][0] := 1;
                                    lotofacil_id[lotofacil_ltf_id][1] := id_sequencial;

                                  end;

                                end;
                              end;

  // Agora, salvar no banco de dados, primeiro, deletar o registro que está lá
  sql_registro := TSqlQuery.Create(Self);

  if not Assigned(dmLotofacil) then
  begin
    dmLotofacil := TDmLotofacil.Create(Self);
  end;

  sql_registro.DataBase := dmLotofacil.pgLTK;
  sql_registro.SQL.Clear;
  sql_registro.Sql.Add('Delete from lotofacil.lotofacil_complementar');
  sql_registro.Sql.Add('where ltf_qt = 15');

  try
    sql_registro.ExecSql;
  except
    on exc: Exception do
    begin
      strErro := exc.Message;
      Exit(False);
    end;
  end;

  // Evitar linha em branco no final
  lista_sql.Clear;
  lista_sql.SkipLastLineBreak := True;

  qt_itens := 0;
  for uA := 1 to LOTOFACIL_COMBINACOES do
  begin

    if qt_itens = 0 then
    begin
      sql_registro.Sql.Add('Insert lotofacil.lotofacil_complementar(ltf_id, ltf_qt,');
      sql_registro.Sql.Add('id_complementar_sequencial)values');
      sql_registro.Sql.Add(Format('(%d,%d,%d)',
        [lotofacil_id[uA, 0], 15, lotofacil_id
        [uA, 1]]));
    end
    else
    begin
      sql_registro.Sql.Add(Format(',(%d,%d,%d)',
        [lotofacil_id[uA, 0], 15, lotofacil_id
        [uA, 1]]));
    end;

    Inc(qt_itens);

    // Pra evitar que exaurimos a memória, iremos fazer inserções
    // incrementais, a cada 50000 ítens, iremos inserir no banco de dados.
    if qt_itens = 50000 then
    begin
      qt_itens := 0;

      // Em seguida, inserir os dados.
      sql_registro.Close;
      sql_registro.SQL.Clear;
      sql_registro.Sql.Text := lista_sql.Text;
      lista_sql.Clear;
      try
        sql_registro.ExecSql;
      except
        on exc: Exception do
        begin
          strErro := exc.Message;
          Exit(False);
        end;
      end;
    end;
  end;

  // Se há ainda registros não inseridos, devemos fazer agora
  if lista_sql.Count <> 0 then
  begin
    // Em seguida, inserir os dados.
    sql_registro.Close;
    sql_registro.SQL.Clear;
    sql_registro.Sql.Text := lista_sql.Text;
    lista_sql.Clear;
    try
      sql_registro.ExecSql;
    except
      on exc: Exception do
      begin
        strErro := exc.Message;
        Exit(False);
      end;
    end;
  end;

  Exit(True);
end;

function TForm1.Gerar_Combinacao_Complementar(lotofacil_bolas: array of integer;
  bolas_por_combinacao: integer;
  out lotofacil_aleatorio: TAleatorio_Resultado): boolean;
var
  lista_fixa, lista_nao_fixa_origem, lista_nao_fixa_destino: TStringList;
  uA, bolas_fixas, bolas_nao_fixas, uC, indice_coluna, qt_bolas_valor_um,
  uB: integer;
  bola_numero, indice_lista: longint;
  ultimo_indice: longint;
begin
  ultimo_indice := High(lotofacil_bolas);
  if High(lotofacil_bolas) <> 25 then
  begin
    strErro := 'Deve haver um arranjo com índice final igual a 25';
    Exit(False);
  end;

  SetLength(lotofacil_aleatorio, 3, 26);

  lista_fixa := TStringList.Create;
  lista_nao_fixa_origem := TStringList.Create;
  lista_nao_fixa_destino := TStringList.Create;

  lista_fixa.Clear;
  lista_nao_fixa_origem.Clear;
  lista_nao_fixa_destino.Clear;

  case bolas_por_combinacao of
    15:
    begin
      bolas_fixas := 10;
      bolas_nao_fixas := 5;
    end;
    16:
    begin
      bolas_fixas := 9;
      bolas_nao_fixas := 7;
    end;
    17:
    begin
      bolas_fixas := 8;
      bolas_nao_fixas := 9;
    end;
    18:
    begin
      bolas_fixas := 7;
      bolas_nao_fixas := 11;
    end;
  end;

  qt_bolas_valor_um := 0;
  for uA := 1 to 25 do
  begin
    if lotofacil_bolas[uA] = 1 then
    begin
      lista_nao_fixa_origem.Add(IntToStr(uA));
      Inc(qt_bolas_valor_um);
    end
    else
    begin
      lista_fixa.Add(IntToStr(uA));
    end;
  end;

  if qt_bolas_valor_um <> bolas_por_combinacao then
  begin
    strErro :=
      'Quantidade de bolas sorteadas diferente de quantidade de bolas por combinação';
    Exit(False);
  end;


  for uB := 0 to 2 do
  begin

    // Preenche
    FillChar(lotofacil_bolas, 26 * sizeof(integer), 0);
    for uC := 0 to Pred(bolas_fixas) do
    begin
      bola_numero := StrToInt(lista_fixa.Strings[uC]);
      lotofacil_bolas[bola_numero] := 1;
    end;

    // Completa a lista, se estiver faltando.
    while lista_nao_fixa_origem.Count < bolas_nao_fixas do
    begin
      indice_lista := Random(lista_nao_fixa_destino.Count);
      bola_numero := StrToInt(lista_nao_fixa_destino.Strings[indice_lista]);
      lista_nao_fixa_destino.Delete(indice_lista);
      lista_nao_fixa_origem.Add(IntToStr(bola_numero));
    end;

    // Sortea aleatoriamente bolas da lista não-fixa origem.
    for uC := 1 to bolas_nao_fixas do
    begin
      indice_lista := Random(lista_nao_fixa_origem.Count);
      bola_numero := StrToInt(lista_nao_fixa_origem.Strings[indice_lista]);
      lista_nao_fixa_origem.Delete(indice_lista);
      lista_nao_fixa_destino.Add(IntToStr(bola_numero));

      lotofacil_bolas[bola_numero] := 1;
    end;

    indice_coluna := 1;
    for uC := 1 to 25 do
    begin
      if lotofacil_bolas[uC] = 1 then
      begin
        lotofacil_aleatorio[uB, indice_coluna] := uC;
        Inc(indice_coluna);
      end;
    end;
  end;

  Exit(True);
end;

procedure TForm1.GerarSqlGrupo(sqlGrupo: TStringList);
var
  uLinha, uA, indiceMarcar, indiceSql, ultimoIndiceGrupo, uB, uC,
  uD, ultima_Linha: integer;
  controlesGrupo: array[0..3] of TStringGrid;
  colunaMarcar: array[0..3] of integer;
  colunaSql: array[0..3] of integer;
  bControleSelecionado: boolean;
  objControle: TStringGrid;
  sqlTemp: string;
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
  bControleSelecionado := False;
  for uA := 0 to 3 do
  begin
    // Vamos criar uma variável para armazenar o arranjo pra ficar economizar no digitar.
    objControle := controlesGrupo[uA];
    indiceMarcar := colunaMarcar[uA];
    indiceSql := colunaSql[uA];

    // Se o controle está zerado, passar para o próximo controle.
    if objControle.RowCount = 0 then
    begin
      continue;
    end;

    // Vamos percorrer todas as linhas do controle e verificar se algo foi
    // marcado.
    // Linha sempre começa em 1, pois, a linha 0 é o título.
    // Quantidade de linhas:
    ultima_Linha := objControle.RowCount - 1;

    for uLinha := 1 to ultima_Linha do
    begin
      if objControle.Cells[indiceMarcar, uLinha] = '1' then
      begin
        bControleSelecionado := True;
        sqlGrupo.Add(objControle.Cells[indiceSql, uLinha]);
      end;
    end;

    // Se algum controle teve algo marcado devemos sair do loop.
    if bControleSelecionado = True then
    begin
      break;
    end;
  end;

  // Se nenhum controle foi marcado, devemos retornar.
  if bControleSelecionado = False then
  begin
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
  if ultimoIndiceGrupo > 39 then
  begin
    ultimoIndiceGrupo := 39;
  end;

  sqlTemp := '';
  for uA := 0 to ultimoIndiceGrupo do
  begin
    for uB := uA + 1 to ultimoIndiceGrupo do
    begin
      for uC := uB + 1 to ultimoIndiceGrupo do
      begin
        sqlTemp := '(' + sqlGrupo[uA] + ' and ';
        sqlTemp := sqlTemp + sqlGrupo[uB] + ' and ';
        sqlTemp := sqlTemp + sqlGrupo[uC] + ')';

        if (uC - uB <> 0) or (uC <> ultimoIndiceGrupo) then
        begin
          sqlTemp := sqlTemp + ' or ';
        end;

        sqlGrupo.Add(sqlTemp);
      end;
    end;
  end;
  //exit;

  mmFiltroSql.Lines.Clear;
  // Aqui, iremos pegar do último, para o primeiro.
  for uA := sqlGrupo.Count - 1 downto 0 do
  begin
    mmFiltroSql.Lines.Add(sqlGrupo.Strings[uA]);
  end;
end;

procedure TForm1.sgrColunaB1_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

//procedure TForm1.sgrColunaB1_16BolasSelectCell(Sender: TObject;
//  aCol, aRow: integer; var CanSelect: boolean);
//begin
//  AlterarMarcador(Sender, aCol, aRow, CanSelect);
//end;


procedure TForm1.sgrColunaB1_B15_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_16BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_17BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B15_18BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B2_15BolasDrawCell(Sender: TObject;
  aCol, aRow: integer; aRect: TRect; aState: TGridDrawState);
begin

end;

procedure TForm1.sgrColunaB1_B2_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B2_B3_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B2_B3_B4_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B2_B3_B4_B5_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_16BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_17BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B4_B8_B12_B15_18BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_16BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_17BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrColunaB1_B8_B15_18BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrExternoInterno15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrExternoInternoPorConcursoSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

{
TODO: Esta procedure é utilizada pra colorir as células do stringGrid,
devemos verificar posteriormente, se queremos utilizar ainda está procedure.
}
procedure TForm1.sgrFrequenciaDrawCell(Sender: TObject; aCol, aRow: integer;
  aRect: TRect; aState: TGridDrawState);
var
  grdFrequencia: TDBGrid;
  valorFrequencia: integer;
  gradeCanvas: TCanvas;

  larguraTexto: integer;
  alturaTexto: integer;

  textoAtual: string;

  textoX: integer;
  textoY: integer;

  corColuna: TColor;
  corTexto: TColor;

begin
  grdFrequencia := TDBGrid(Sender);
  gradeCanvas := grdFrequencia.Canvas;
  textoAtual := sgrFrequencia.Cells[aCol, aRow];

  corColuna := clWhite;
  corTexto := clBlack;

  // Só iremos pegar as células das colunas que tem as bolas
  // e ela começa na linha 1.
  if (aCol >= 1) and (aCol <= 25) and (aRow > 0) then
  begin
    valorFrequencia := StrToInt(textoAtual);

    if valorFrequencia = 1 then
    begin
      corColuna := clGreen;
    end
    else
    if valorFrequencia = -1 then
    begin
      corColuna := clRed;
      corTexto := clWhite;
    end
    else
    if valorFrequencia > 1 then
    begin
      corColuna := clYellow;
      corTexto := clRed;
    end
    else
    if valorFrequencia < -1 then
    begin
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

procedure TForm1.sgrGrupo2BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrGrupo3BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);

end;

procedure TForm1.sgrGrupo4BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrGrupo5BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;


procedure TForm1.sgrNovosRepetidosSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  // TODO: Verificar isto.
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.sgrParImpar15BolasSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  AlterarMarcador(Sender, aCol, aRow, CanSelect);
end;

procedure TForm1.AlterarMarcador(Sender: TObject; aCol, aRow: integer;
  var CanSelect: boolean);
var
  gradeTemp, obj_controle_b1_a_b15: TStringGrid;
  titulo_coluna: TCaption;
  indice_na_lista: Integer;
  indice_b1_a_b15: LongInt;
begin
  // Write('ARow: ', aRow);
  // Se está na coluna marcar, então, altera o valor da célula.
  gradeTemp := TStringGrid(Sender);
  // Se a coluna é maior que gradeTemp.Columns, então retorna.

  if (aCol <= -1) or (ARow <= -1) then
  begin
    exit;
  end;

  if aCol > gradeTemp.Columns.Count then
  begin
    exit;
  end;


  if gradeTemp.Columns[ACol].Title <> nil then
  begin
    titulo_coluna := gradeTemp.Columns[Acol].Title.Caption;
    titulo_coluna := Upcase(titulo_coluna);
  end;
  // Se a coluna 'marcar' foi clicada, devemos alterar de 0 pra 1 ou vice-versa.
  if (gradeTemp.Columns[ACol].Title <> nil) and
    //(UpCase(gradeTemp.Cells[Acol, 0]) = 'MARCAR') or
    ((titulo_coluna = 'MARCAR') or
    (titulo_coluna = 'DEVE_SAIR') or
    (titulo_coluna = 'NAO_DEVE_SAIR')) then
  begin
    if aRow <> 0 then
    begin
      if gradeTemp.Cells[aCol, aRow] = '0' then
      begin
        gradeTemp.Cells[aCol, aRow] := '1';
      end
      else
      begin
        gradeTemp.Cells[aCol, aRow] := '0';
      end;
    end;

    // Se os controles são um dos controles referentes as colunas, então, atualizar
    // o próximo controle.
    if (gradeTemp = sgrColunaB1_15Bolas) or
       (gradeTemp = sgrColunaB1_B15_15Bolas) or
       (gradeTemp = sgrColunaB1_B8_B15_15Bolas) or
       (gradeTemp = sgrColunaB1_B2_15Bolas) or
       (gradeTemp = sgrColunaB1_B2_B3_15Bolas) or
       (gradeTemp = sgrColunaB1_B2_B3_B4_15Bolas) or
       (gradeTemp = sgrColunaB1_B2_B3_B4_B5_15Bolas) then
    begin
      {Todo: A procedure AtualizarColuna_B está vazia, verificar onde o novo código foi utilizado. }
      //AtualizarColuna_B(gradeTemp);
      GerarSqlColuna_B(gradeTemp);
    end;

    // Toda vez que o usuário clicar nos controles sgrGrupo2Bolas, sgrGrupo3Bolas,
    // sgrGrupo4Bolas ou sgrGrupo5Bolas,
    // o próximo controle será atualizado.
    if (gradeTemp = sgrGrupo2Bolas) or (gradeTemp = sgrGrupo3Bolas) or
      (gradeTemp = sgrGrupo4Bolas) or (gradeTemp = sgrGrupo5Bolas) then
    begin
      AtualizarControleGrupo(gradeTemp);
    end;

    // Se o controle é um dos controles da guia 'Frequencia':
    // sgrFrequenciaTodas, sgrFrequencia_Bolas_Sair_Nao_Sair, sgrFrequenciaBolasNaoSair
    // iremos atualizar o outro controle que ficou desatualizado, ou seja,
    // sempre os controles estarão em sincronia.
    if (gradeTemp = sgrFrequenciaSair) or (gradeTemp = sgrFrequenciaNaoSair) or
      (gradeTemp = sgrFrequencia_Bolas_Sair_Nao_Sair) or
      (gradeTemp = sgrFrequenciaBolasNaoSair) or (gradeTemp =
      sgrFrequenciaTotalSair) or (gradeTemp = sgrFrequenciaTotalNaoSair) then
    begin
      AtualizarControleFrequencia(gradeTemp);
    end;

    // Se o controle é um dos controles de diferença entre bolas, atualmente,
    // o próximo controle.
    if (gradeTemp = sgrDiferenca_Qt_1) then
    begin
      Controle_Diferenca_entre_Bolas_alterou(sgrDiferenca_QT_1);
      exit;
    end;

    if (gradeTemp = sgrDiferenca_qt_alt) then
    begin
      Controle_Diferenca_entre_Bolas_alterou(sgrDiferenca_qt_alt);
      exit;
    end;

    if (gradeTemp = sgrDiferenca_qt_alt_1) then
    begin
      Controle_Diferenca_entre_Bolas_alterou(sgrDiferenca_qt_alt_1);
    end;

    indice_na_lista := 0;
    if not f_controles_b1_a_b15_pra_ser_atualizado.sorted then begin
      f_controles_b1_a_b15_pra_ser_atualizado.Sort;
    end;


    indice_b1_a_b15 := f_sgr_bx_a_by_lista.IndexOf(gradeTemp);
    if indice_b1_a_b15 >= 0 then begin
      sgr_bx_a_by_atualizar_dependentes(gradeTemp);
    end;

  end;
end;

{
 Atualiza os controles de frequência:
 Os 3 controles abaixo indicam bolas que devem sair, o usuário deve marcar
 as bolas que devem sair em todas as combinações.

 sgrFrequenciaSair:            Bolas dispostas em ordem crescente conforme o a quantidade de vezes
                               que saiu nos concursos já sorteados.
 sgrFrequenciaBolasSair:       Bolas dispostas em ordem crescente conforme a quantidade de vezes
                               que a bola saiu, não saiu, deixou de saiu ou está repetindo desde
                               o último concurso.
 sgrFrequenciaBolasTotalSair:  Bolas dispostas em ordem crescente conforme a soma de cada frequência
                               de todos os concursos anteriores, inclusive o atual.

 Os outros 3 controles: sgrFrequenciaNaoSair, sgrFrequenciaBolasNaoSair e sgrFrequenciaBolaTotalSair
 são semelhantes à descrição acima, entretanto, o usuário deve marcar as bolas que não devem sair
 em nenhuma combinação.

 Quando um dos controles de frequência é atualizado, os demais devem ser atualizados
 também, neste caso, a atualização é baseado na bola que foi selecionada.
 Há 6 controles com frequências, 3 deles indicam bolas que devem sair nas combinações
 e os outros 3, indicam bolas que não devem sair nas combinações.
 Então, por exemplo, se uma das bolas do controle que devem sair é selecionada, devemos
 atualizar todos os controles que indicam bola que devem sair, pra ter a mesma bola selecionada.
 E ao mesmo tempo, nos controles que indicam bolas que não devem sair devemos deselecionar
 a mesma bola, se a mesma está selecionada em tais controles.
 }

procedure TForm1.AtualizarControleFrequencia(objControle: TStringGrid);
var
  uA, ultima_coluna_frequencia_sair, ultima_coluna_frequencia_bolas_sair,
  ultima_coluna_frequencia_total_sair, ultima_coluna_frequencia_nao_sair,
  ultima_coluna_frequencia_bolas_nao_sair, ultima_coluna_frequencia_total_nao_sair,
  ultima_coluna_sair, ultima_coluna_nao_sair: integer;
  bolaAtual, bola_numero: longint;
  linha_frequencia_sair, linha_frequencia_bolas_sair,
  linha_frequencia_total_sair, linha_frequencia_nao_sair,
  linha_frequencia_bolas_nao_sair, linha_frequencia_total_nao_sair: boolean;
  valor_marcado_sair, valor_marcado_nao_sair: string;
begin
  // Agora, haverá as colunas 'DEVE_SAIR' e 'NAO_DEVE_SAIR'
  ultima_coluna_frequencia_bolas_nao_sair :=
    Pred(sgrFrequencia_Bolas_Sair_Nao_Sair.Columns.Count);
  ultima_coluna_frequencia_bolas_sair := ultima_coluna_frequencia_bolas_nao_sair - 1;

  ultima_coluna_frequencia_total_nao_sair := Pred(sgrFrequenciaTotalSair.Columns.Count);
  ultima_coluna_frequencia_total_sair := ultima_coluna_frequencia_total_nao_sair - 1;


  // ultima_coluna_frequencia_sair := sgrFrequenciaSair.Columns.Count - 1;
  // ultima_coluna_frequencia_bolas_sair := sgrFrequencia_Bolas_Sair_Nao_Sair.Columns.Count - 1;
  // ultima_coluna_frequencia_total_sair := sgrFrequenciaTotalSair.Columns.Count - 1;

  // Agora, iremos percorrer cada linha e pega o valor que foi marcado e inserir
  // no arranjo 'concurso_frequencia_sair' e 'concurso_frequencia_nao_sair', em seguida,
  // iremos, validar pra evitar que a mesma bola tem sido marcado pra sair e não sair.
  if (objControle = sgrFrequencia_Bolas_Sair_Nao_Sair) or
    (objControle = sgrFrequenciaTotalSair) then
  begin
    ultima_coluna_nao_sair := Pred(objControle.Columns.Count);
    ultima_coluna_sair := ultima_coluna_nao_sair - 1;

    // Agora, percorre o controle
    for uA := 1 to 25 do
    begin
      bola_numero := StrToInt(objControle.Cells[0, uA]);
      concurso_frequencia_sair[bola_numero] :=
        StrToInt(objControle.Cells[ultima_coluna_sair, uA]);
      concurso_frequencia_nao_sair[bola_numero] :=
        StrToInt(objControle.Cells[ultima_coluna_nao_sair, uA]);

      // Se a bola foi marcada pra sair e também pra não sair, não sabemos
      // o que realmente, o usuário deseja, então desmarcamos as duas.
      if (concurso_frequencia_sair[bola_numero] = 1) and
        (concurso_frequencia_nao_sair[bola_numero] = 1) then
      begin
        concurso_frequencia_nao_sair[bola_numero] := 0;
        concurso_frequencia_sair[bola_numero] := 0;
      end;
    end;
  end;

  // ultima_coluna_frequencia_bolas_nao_sair := sgrFrequencia_Bolas_Sair_Nao_Sair.Columns.Count - 1;
  // ultima_coluna_frequencia_total_nao_sair := sgrFrequenciaTotalSair.Columns.Count - 1;

  // Pega a frequencia do controle que foi atualizado, devemos armazenar
  // na variável correta.
  // if (objControle = sgrFrequenciaSair) or
  {
  IF
     (objControle = sgrFrequencia_Bolas_Sair_Nao_Sair) or
     (objControle = sgrFrequenciaTotalSair) then
  begin
     // Vamos verificar se há 26 linhas o controle, se não houver, quer dizer
     // que não há registros, devemos retornar.
     if objControle.RowCount <> 26 then begin
       Exit;
     end;

     // A última coluna do controle é a coluna 'marcar', que tem o valor '0' ou '1'.
     // '0' indica 'não selecionado' e '1' indica 'selecionado'.
     ultima_coluna_sair := objControle.Columns.Count - 1;
     for uA := 1 to 25 do
     begin
         bolaAtual := StrToInt(objControle.Cells[0, uA]);
         concurso_frequencia_sair[bolaAtual] := StrToInt(objControle.Cells[ultima_coluna_sair, uA]);
         concurso_frequencia_nao_sair[bolaAtual] := StrToInt(objControle.Cells[ultima_coluna_nao_sair, uA]);

         // Se a bola foi marcada pra sair e também pra não sair, não sabemos
         // o que realmente, o usuário deseja, então desmarcamos as duas.
         if (concurso_frequencia_sair[bolaAtual] = 1) and (concurso_frequencia_nao_sair[bolaAtual] = 1) then
         begin
            concurso_frequencia_nao_sair[bolaAtual] := 0;
            concurso_frequencia_sair[bolaAtual] := 0;
         end;
     end;
  end;

  else
  if (objControle = sgrFrequenciaNaoSair) or
     (objControle = sgrFrequenciaBolasNaoSair) or
     (objControle = sgrFrequenciaTotalNaoSair) then
  begin
     // Vamos verificar se há 26 linhas o controle, se não houver, quer dizer
     // que não há registros, devemos retornar.
     if objControle.RowCount <> 26 then begin
       Exit;
     end;

     // A última coluna do controle é a coluna 'marcar', que tem o valor '0' ou '1'.
     // '0' indica 'não selecionado' e '1' indica 'selecionado'.
     ultima_coluna_sair := objControle.Columns.Count - 1;
     for uA := 1 to 25 do
     begin
         bolaAtual := StrToInt(objControle.Cells[0, uA]);
         concurso_frequencia_nao_sair[bolaAtual] := StrToInt(objControle.Cells[ultima_coluna_sair, uA]);

         // Se a bola está marcar tanto pra sair, quando pra não sair, devemos desmarcar a outra.
         if (concurso_frequencia_sair[bolaAtual] = 1) and (concurso_frequencia_nao_sair[bolaAtual] = 1) then
         begin
            concurso_frequencia_sair[bolaAtual] := 0;
         end;
     end;
  end;
  }

  // Vamos verificar quais controles tem linhas completas de dados.
  //linha_frequencia_sair := sgrFrequenciaSair.RowCount = 26;
  linha_frequencia_bolas_sair := sgrFrequencia_Bolas_Sair_Nao_Sair.RowCount = 26;
  linha_frequencia_total_sair := sgrFrequenciaTotalSair.RowCount = 26;

  //linha_frequencia_nao_sair := sgrFrequenciaNaoSair.RowCount = 26;
  //linha_frequencia_bolas_nao_sair := sgrFrequenciaBolasNaoSair.RowCount = 26;
  //linha_frequencia_total_nao_sair := sgrFrequenciaTotalNaoSair.RowCount = 26;

  // Agora, iremos atualizar os campos 'DEVE_SAIR' e 'NAO_DEVE_SAIR'.
  for uA := 1 to 25 do
  begin

      {
      if linha_frequencia_sair then begin
         bolaAtual := StrToInt(sgrFrequenciaSair.Cells[0, uA]);
         sgrFrequenciaSair.Cells[ultima_coluna_frequencia_sair, uA] := IntToStr(concurso_frequencia_sair[bolaAtual]);
      end;
      }

    // Atualiza
    if linha_frequencia_bolas_sair then
    begin
      bola_numero := StrToInt(sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[0, uA]);

      valor_marcado_sair := IntToStr(concurso_frequencia_sair[bola_numero]);
      sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_frequencia_bolas_sair, uA]
      := valor_marcado_sair;

      valor_marcado_nao_sair := IntToStr(concurso_frequencia_nao_sair[bola_numero]);
      sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_frequencia_bolas_nao_sair,
        uA] := valor_marcado_nao_sair;

      //sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_frequencia_bolas_sair, uA] := IntToStr(concurso_frequencia_sair[bolaAtual]);
    end;

    if linha_frequencia_total_sair then
    begin
      bola_numero := StrToInt(sgrFrequenciaTotalSair.Cells[0, uA]);

      valor_marcado_sair := IntToStr(concurso_frequencia_sair[bola_numero]);
      sgrFrequenciaTotalSair.Cells[ultima_coluna_frequencia_total_sair, uA] :=
        valor_marcado_sair;

      valor_marcado_nao_sair := IntToStr(concurso_frequencia_nao_sair[bola_numero]);
      sgrFrequenciaTotalSair.Cells[ultima_coluna_frequencia_total_nao_sair, uA] :=
        valor_marcado_nao_sair;

      // bolaAtual := StrToInt(sgrFrequenciaTotalSair.Cells[0, uA]);
      //sgrFrequenciaTotalSair.Cells[ultima_coluna_frequencia_total_sair, uA] := IntToStr(concurso_frequencia_sair[bolaAtual]);
    end;

      {
      // Controles que indicam as bolas que não devem sair.
      if linha_frequencia_nao_sair then begin
         bolaAtual := StrToInt(sgrFrequenciaNaoSair.Cells[0, uA]);
         sgrFrequenciaNaoSair.Cells[ultima_coluna_frequencia_nao_sair, uA] := IntToStr(concurso_frequencia_nao_sair[bolaAtual]);
      end;
      if linha_frequencia_bolas_nao_sair then begin
         bolaAtual := StrToInt(sgrFrequenciaBolasNaoSair.Cells[0, uA]);
         sgrFrequenciaBolasNaoSair.Cells[ultima_coluna_frequencia_bolas_nao_sair, uA] := IntToStr(concurso_frequencia_nao_sair[bolaAtual]);
      end;
      if linha_frequencia_total_nao_sair then begin
         bolaAtual := StrToInt(sgrFrequenciaTotalNaoSair.Cells[0, uA]);
         sgrFrequenciaTotalNaoSair.Cells[ultima_coluna_frequencia_total_nao_sair, uA] := IntToStr(concurso_frequencia_nao_sair[bolaAtual]);
      end;
      }
  end;

  AtualizarControleFrequenciaMinimoMaximo;
end;

{
 Haverá 8 controles, 4 armazenará a quantidade mínima de bolas que deve sair da
 categoria e 4 armazenará a quantidade máxima de bolas que deve sair da categorias.
 As categorias são:
 ainda_nao_saiu
 deixou_de_sair
 novo
 repetindo.

 Antes de atualizar os controles iremos pegar o valor antigo, e em seguida,
 atualizar o controle de mínimo e máximo, e em seguida, iremos atualizar o
 controle pra mostrar o valor antigo se possível.

 Por exemplo, há 5 bolas na categoria 'ainda_nao_saiu', quer dizer, que
 podemos escolher mínimo 1 até 5, por exemplo, se escolhemos 2.
 Após atualizar o controle foi pra 5 bolas, devemos mostrar o valor 2 no campo
 mínimo, pois assim, o usuário não precisa toda hora fica mudando os valores.

 Toda vez, que os controles sgrFrequencia_Bolas_Sair_Nao_Sair ou sgrFrequenciaBolasNaoSair
 é atualizado, devemos atualizar os controles que ar

}
procedure TForm1.AtualizarControleFrequenciaMinimoMaximo;
var
  qt_marcado_valor_um_sair: integer;
  qt_marcado_valor_um_nao_sair, uA, ultima_coluna_controle_sair,
  ultima_coluna_controle_nao_sair, bolas_disponiveis, indiceNovaPosicao,
  qt_minima_ainda_nao_saiu_atualizado, qt_ainda_nao_saiu, qt_deixou_de_sair,
  ainda_nao_saiu_minimo_anterior, ainda_nao_saiu_maximo_anterior,
  deixou_de_sair_minimo_anterior, deixou_de_sair_maximo_anterior,
  novo_minimo_anterior, novo_maximo_anterior, repetindo_minimo_anterior,
  repetindo_maximo_anterior, indice, qt_novo, qt_repetindo, uB,
  indice_minimo, indice_maximo: integer;
  valorAntigoMinimoSair, valorAntigoMaximoSair, valorAntigoMinimoNaoSair,
  valorAntigoMaximoNaoSair: TCaption;
  frequencia_status: string;
begin
  // A quantidade de mínimo e máximo é definida, conforme, as marcações
  // realizações no controle sgrFrequencia_Bolas_Sair_Nao_Sair, entretanto, pode
  // ocorrer de o usuário selecionar algum concurso que não foi atualizado
  // a frequência ainda, pra isto, iremos verificar isto.
  if sgrFrequencia_Bolas_Sair_Nao_Sair.RowCount <> 26 then
  begin
    exit;
  end;

  ultima_coluna_controle_nao_sair :=
    Pred(sgrFrequencia_Bolas_Sair_Nao_Sair.Columns.Count);
  ultima_coluna_controle_sair := ultima_coluna_controle_nao_sair - 1;

  qt_marcado_valor_um_sair := 0;
  qt_marcado_valor_um_nao_sair := 0;


  // Toda vez que o usuário marcar o valor 1, em uma das bolas
  // devemos contabilizar de qual grupo é.
  // Pra isto, no loop for seguinte iremos fazer isto.
  qt_ainda_nao_saiu := 0;
  qt_deixou_de_sair := 0;
  qt_novo := 0;
  qt_repetindo := 0;

  // Sempre haverá 25 bolas.
  for uA := 1 to 25 do
  begin

    // Iremos pegar o valor da coluna 'frequencia_status', está na posição 1.
    frequencia_status := sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[1, uA];
    frequencia_status := LowerCase(frequencia_status);

    if sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_controle_sair,
      uA] = '1' then
    begin
      Inc(qt_marcado_valor_um_sair);

      if frequencia_status = 'ainda_nao_saiu' then
      begin
        Inc(qt_ainda_nao_saiu);
      end
      else if frequencia_status = 'deixou_de_sair' then
      begin
        Inc(qt_deixou_de_sair);
      end
      else if frequencia_status = 'novo' then
      begin
        Inc(qt_novo);
      end
      else if frequencia_status = 'repetindo' then
      begin
        Inc(qt_repetindo);
      end;
    end;

    if sgrFrequencia_Bolas_Sair_Nao_Sair.Cells[ultima_coluna_controle_nao_sair,
      uA] = '1' then
    begin
      Inc(qt_marcado_valor_um_nao_sair);
    end;
  end;

  // Pega o valor mínímo e máximo dos controles se houver.
  // Toda vez que um controle é preenchido mínímo, o controle de máximo é também
  // preenchido, por isto, se a quantidade de um dos controles é zero, o outro
  // também o é.
  ainda_nao_saiu_minimo_anterior := 0;
  ainda_nao_saiu_maximo_anterior := 0;

  deixou_de_sair_minimo_anterior := 0;
  deixou_de_sair_maximo_anterior := 0;

  novo_minimo_anterior := 0;
  novo_maximo_anterior := 0;

  repetindo_minimo_anterior := 0;
  repetindo_maximo_anterior := 0;

  // Ainda não saiu.
  indice := cmbAinda_Nao_Saiu_Minimo.ItemIndex;
  if indice >= 0 then
  begin
    ainda_nao_saiu_minimo_anterior := StrToInt(cmbAinda_Nao_Saiu_Minimo.Items[indice]);
  end;

  indice := cmbAinda_Nao_Saiu_Maximo.ItemIndex;
  if indice >= 0 then
  begin
    ainda_nao_saiu_Maximo_anterior := StrToInt(cmbAinda_Nao_Saiu_Maximo.Items[indice]);
  end;

  // Deixou de sair.
  indice := cmbDeixou_de_Sair_Minimo.ItemIndex;
  if indice >= 0 then
  begin
    Deixou_de_Sair_minimo_anterior := StrToInt(cmbDeixou_de_Sair_Minimo.Items[indice]);
  end;

  indice := cmbDeixou_de_Sair_Maximo.ItemIndex;
  if indice >= 0 then
  begin
    Deixou_de_Sair_Maximo_anterior := StrToInt(cmbDeixou_de_Sair_Maximo.Items[indice]);
  end;

  // Mínimo.
  indice := cmbNovo_Minimo.ItemIndex;
  if indice >= 0 then
  begin
    Novo_minimo_anterior := StrToInt(cmbNovo_Minimo.Items[indice]);
  end;

  indice := cmbNovo_Maximo.ItemIndex;
  if indice >= 0 then
  begin
    Novo_Maximo_anterior := StrToInt(cmbNovo_Maximo.Items[indice]);
  end;

  // Repetindo.
  indice := cmbRepetindo_Minimo.ItemIndex;
  if indice >= 0 then
  begin
    Repetindo_minimo_anterior := StrToInt(cmbRepetindo_Minimo.Items[indice]);
  end;

  indice := cmbRepetindo_Maximo.ItemIndex;
  if indice >= 0 then
  begin
    Repetindo_Maximo_anterior := StrToInt(cmbRepetindo_Maximo.Items[indice]);
  end;

  // Agora, vamos apagar os controles e inserir os dados.
  cmbAinda_Nao_Saiu_Minimo.Clear;
  cmbAinda_Nao_Saiu_Maximo.Clear;
  cmbDeixou_de_Sair_Minimo.Clear;
  cmbDeixou_de_Sair_Maximo.Clear;
  cmbNovo_Minimo.Clear;
  cmbNovo_Maximo.Clear;
  cmbRepetindo_Minimo.Clear;
  cmbRepetindo_Maximo.Clear;

  // Iremos popular os números nos controles, observe
  // que no controle 'minimo', as bolas, são adicionadas
  // em ordem crescente e no controle 'maximo', as bolas são
  // adicionadas em ordem decrescente.

  // *********** AINDA NÃO SAIU ******************
  if qt_ainda_nao_saiu > 0 then
  begin
    uB := qt_ainda_nao_saiu;
    for uA := 1 to qt_ainda_nao_saiu do
    begin
      cmbAinda_Nao_Saiu_Minimo.Items.Add(IntToStr(uA));
      cmbAinda_Nao_Saiu_Maximo.Items.Add(IntToStr(uB));
      Dec(uB);
    end;
    // Inicialmente, o valor mínimo e máximo terá o mesmo valor, em seguida,
    // iremos verificar quais eram os valores antigos.
    // Neste caso, a caixa de combinação de mínimo, os números estão em
    // ordem crescente e na caixa de combinação de máximo, os números estão em
    // ordem decrescente, neste caso, devemos, pegar o primeiro índice do
    // controle mínimo e o último índice do controle máximo.
    cmbAinda_Nao_Saiu_Minimo.ItemIndex :=
      cmbAinda_Nao_Saiu_Minimo.Items.IndexOf(IntToStr(qt_ainda_nao_saiu));
    cmbAinda_Nao_Saiu_Maximo.ItemIndex :=
      cmbAinda_Nao_Saiu_Maximo.Items.IndexOf(IntToStr(qt_ainda_nao_saiu));
    // Em seguida, devemos verificar se os valores anteriores estão na lista, se
    // sim, alterar o valor do índice selecionado do controle.
    indice_minimo := cmbAinda_Nao_Saiu_Minimo.Items.IndexOf(
      IntToStr(ainda_nao_saiu_minimo_anterior));
    indice_maximo := cmbAinda_Nao_Saiu_Maximo.Items.IndexOf(
      IntToStr(ainda_nao_saiu_maximo_anterior));

    if indice_minimo >= 0 then
    begin
      cmbAinda_Nao_Saiu_Minimo.ItemIndex := indice_minimo;
    end;

    if indice_maximo >= 0 then
    begin
      cmbAinda_Nao_Saiu_Maximo.ItemIndex := indice_maximo;
    end;

  end;

  // *********** DEIXOU DE SAIR ******************
  if qt_Deixou_de_Sair > 0 then
  begin
    uB := qt_Deixou_de_Sair;
    for uA := 1 to qt_Deixou_de_Sair do
    begin
      cmbDeixou_de_Sair_Minimo.Items.Add(IntToStr(uA));
      cmbDeixou_de_Sair_Maximo.Items.Add(IntToStr(uB));
      Dec(uB);
    end;
    // Inicialmente, o valor mínimo e máximo terá o mesmo valor, em seguida,
    // iremos verificar quais eram os valores antigos.
    // Neste caso, a caixa de combinação de mínimo, os números estão em
    // ordem crescente e na caixa de combinação de máximo, os números estão em
    // ordem decrescente, neste caso, devemos, pegar o primeiro índice do
    // controle mínimo e o último índice do controle máximo.
    cmbDeixou_de_Sair_Minimo.ItemIndex :=
      cmbDeixou_de_Sair_Minimo.Items.IndexOf(IntToStr(qt_Deixou_de_Sair));
    cmbDeixou_de_Sair_Maximo.ItemIndex :=
      cmbDeixou_de_Sair_Maximo.Items.IndexOf(IntToStr(qt_Deixou_de_Sair));
    // Em seguida, devemos verificar se os valores anteriores estão na lista, se
    // sim, alterar o valor do índice selecionado do controle.
    indice_minimo := cmbDeixou_de_Sair_Minimo.Items.IndexOf(
      IntToStr(Deixou_de_Sair_minimo_anterior));
    indice_maximo := cmbDeixou_de_Sair_Maximo.Items.IndexOf(
      IntToStr(Deixou_de_Sair_maximo_anterior));

    if indice_minimo >= 0 then
    begin
      cmbDeixou_de_Sair_Minimo.ItemIndex := indice_minimo;
    end;

    if indice_maximo >= 0 then
    begin
      cmbDeixou_de_Sair_Maximo.ItemIndex := indice_maximo;
    end;
  end;

  // *********** NOVOS ******************
  if qt_Novo > 0 then
  begin
    uB := qt_Novo;
    for uA := 1 to qt_Novo do
    begin
      cmbNovo_Minimo.Items.Add(IntToStr(uA));
      cmbNovo_Maximo.Items.Add(IntToStr(uB));
      Dec(uB);
    end;
    // Inicialmente, o valor mínimo e máximo terá o mesmo valor, em seguida,
    // iremos verificar quais eram os valores antigos.
    // Neste caso, a caixa de combinação de mínimo, os números estão em
    // ordem crescente e na caixa de combinação de máximo, os números estão em
    // ordem decrescente, neste caso, devemos, pegar o primeiro índice do
    // controle mínimo e o último índice do controle máximo.
    cmbNovo_Minimo.ItemIndex := cmbNovo_Minimo.Items.IndexOf(IntToStr(qt_Novo));
    cmbNovo_Maximo.ItemIndex := cmbNovo_Maximo.Items.IndexOf(IntToStr(qt_Novo));
    // Em seguida, devemos verificar se os valores anteriores estão na lista, se
    // sim, alterar o valor do índice selecionado do controle.
    indice_minimo := cmbNovo_Minimo.Items.IndexOf(IntToStr(Novo_minimo_anterior));
    indice_maximo := cmbNovo_Maximo.Items.IndexOf(IntToStr(Novo_maximo_anterior));

    if indice_minimo >= 0 then
    begin
      cmbNovo_Minimo.ItemIndex := indice_minimo;
    end;

    if indice_maximo >= 0 then
    begin
      cmbNovo_Maximo.ItemIndex := indice_maximo;
    end;
  end;

  // *********** RepetindoS ******************
  if qt_Repetindo > 0 then
  begin
    uB := qt_Repetindo;
    for uA := 1 to qt_Repetindo do
    begin
      cmbRepetindo_Minimo.Items.Add(IntToStr(uA));
      cmbRepetindo_Maximo.Items.Add(IntToStr(uB));
      Dec(uB);
    end;
    // Inicialmente, o valor mínimo e máximo terá o mesmo valor, em seguida,
    // iremos verificar quais eram os valores antigos.
    // Neste caso, a caixa de combinação de mínimo, os números estão em
    // ordem crescente e na caixa de combinação de máximo, os números estão em
    // ordem decrescente, neste caso, devemos, pegar o primeiro índice do
    // controle mínimo e o último índice do controle máximo.
    cmbRepetindo_Minimo.ItemIndex :=
      cmbRepetindo_Minimo.Items.IndexOf(IntToStr(qt_Repetindo));
    cmbRepetindo_Maximo.ItemIndex :=
      cmbRepetindo_Maximo.Items.IndexOf(IntToStr(qt_Repetindo));
    // Em seguida, devemos verificar se os valores anteriores estão na lista, se
    // sim, alterar o valor do índice selecionado do controle.
    indice_minimo := cmbRepetindo_Minimo.Items.IndexOf(
      IntToStr(Repetindo_minimo_anterior));
    indice_maximo := cmbRepetindo_Maximo.Items.IndexOf(
      IntToStr(Repetindo_maximo_anterior));

    if indice_minimo >= 0 then
    begin
      cmbRepetindo_Minimo.ItemIndex := indice_minimo;
    end;

    if indice_maximo >= 0 then
    begin
      cmbRepetindo_Maximo.ItemIndex := indice_maximo;
    end;
  end;



  // Preenche os controles com o mínimo e o máximo.
  cmbFrequencia_Minimo_Nao_Sair.Clear;
  cmbFrequencia_Maximo_Nao_Sair.Clear;
  cmbFrequencia_Minimo_Sair.Clear;
  cmbFrequencia_Maximo_Sair.Clear;

  if qt_marcado_valor_um_sair <> 0 then
  begin
    for uA := 1 to qt_marcado_valor_um_sair do
    begin
      cmbFrequencia_Minimo_Sair.Items.Add(IntToStr(uA));
      cmbFrequencia_Maximo_Sair.Items.Add(
        IntToStr(qt_marcado_valor_um_sair - uA + 1));
    end;

    // No controle que indica o mínimo, a bola começa em ordem crescente.
    // No controle que indica o máximo, a bola começa em ordem descrente.
    cmbFrequencia_Minimo_Sair.ItemIndex := qt_marcado_valor_um_sair - 1;
    cmbFrequencia_Maximo_Sair.ItemIndex := 0;
  end;

  if qt_marcado_valor_um_nao_sair <> 0 then
  begin
    for uA := 1 to qt_marcado_valor_um_nao_sair do
    begin
      cmbFrequencia_Minimo_Nao_Sair.Items.Add(IntToStr(uA));
      cmbFrequencia_Maximo_Nao_Sair.Items.Add(
        IntToStr(qt_marcado_valor_um_nao_sair - uA + 1));
    end;

    // No controle que indica o mínimo, a bola começa em ordem crescente.
    // No controle que indica o máximo, a bola começa em ordem descrente.
    cmbFrequencia_Minimo_Nao_Sair.ItemIndex := qt_marcado_valor_um_nao_sair - 1;
    cmbFrequencia_Maximo_Nao_Sair.ItemIndex := 0;
  end;

  // Procura pelo valor antigo na caixa de combinação, se o encontra define a nova posição.
  indiceNovaPosicao := cmbFrequencia_Minimo_Nao_Sair.Items.IndexOf(
    valorAntigoMinimoNaoSair);
  if indiceNovaPosicao <> -1 then
  begin
    cmbFrequencia_Minimo_Nao_Sair.ItemIndex := indiceNovaPosicao;
  end;

  indiceNovaPosicao := cmbFrequencia_Maximo_Nao_Sair.Items.IndexOf(
    valorAntigoMaximoNaoSair);
  if indiceNovaPosicao <> -1 then
  begin
    cmbFrequencia_Maximo_Nao_Sair.ItemIndex := indiceNovaPosicao;
  end;

  // Vamos verificar se há pelo menos 15 bolas pra serem filtradas, pois se o usuário
  // marcar mais de 10 bolas pra não sair, a quantidade de registros é igual a zero.
  bolas_disponiveis := 25 - qt_marcado_valor_um_nao_sair;
  if bolas_disponiveis < 15 then
  begin
    MessageDlg('Erro', 'Há menos de 15 bolas disponíveis para gerar as combinações'
      +
      '#10Desselecione uma das bolas, pra haver pelo menos 15 bolas',
      TMsgDlgType.mtError,
      [mbOK], 0);
  end;

end;

procedure TForm1.AtualizarControleGrupo(objControle: TStringGrid);
var
  strWhereSql: TStringList;
  uA: integer;
begin
  strWhereSql := TStringList.Create;
  if objControle = sgrGrupo2Bolas then
  begin
    // Apaga os dados dos outros controles.
    sgrGrupo3Bolas.Columns.Clear;
    sgrGrupo4Bolas.Columns.Clear;
    sgrGrupo5Bolas.Columns.Clear;

    strWhereSql.Clear;
    // Vamos percorrer o controle e verificar se alguma célula foi marcada.
    for uA := 1 to sgrGrupo2Bolas.RowCount - 1 do
    begin
      // Neste controle há 6 colunas:
      // b_1, b_2, sql_bolas, ltf_bolas, res_qt e marcar.
      // Iremos selecionar a última coluna, a coluna marcar, que indica
      // se o usuário selecionou aquela combinação, se o usuário selecionou
      // aquele combinações, iremos pegar o valor da coluna sql_bolas
      // pois, estes dados serão usados para gerar a claúsula where que
      // será passada para o próximo controle.
      if sgrGrupo2Bolas.Cells[5, uA] = '1' then
      begin
        if strWhereSql.Text <> '' then
        begin
          strWhereSql.Add('or');
        end;
        strWhereSql.Add(sgrGrupo2Bolas.Cells[2, uA]);
      end;
    end;
    // Só iremos inserir a claúsula where se houver algo selecionado.
    if strWhereSql.Count <> 0 then
    begin
      // Insere a claúsula where antes das condições e em seguida
      strWhereSql.Insert(0, 'where');
      // Atualiza o próximo controle.
      CarregarGrupo3Bolas(strWhereSql.Text);
    end;
  end
  else
  if objControle = sgrGrupo3Bolas then
  begin
    // Apaga os dados dos outros controles.
    sgrGrupo4Bolas.Columns.Clear;
    sgrGrupo5Bolas.Columns.Clear;

    strWhereSql.Clear;
    // Vamos percorrer o controle e verificar se alguma célula foi marcada.
    for uA := 1 to objControle.RowCount - 1 do
    begin
      // Neste controle há 6 colunas:
      // b_1, b_2, sql_bolas, ltf_bolas, res_qt e marcar.
      // Iremos selecionar a última coluna, a coluna marcar, que indica
      // se o usuário selecionou aquela combinação, se o usuário selecionou
      // aquele combinações, iremos pegar o valor da coluna sql_bolas
      // pois, estes dados serão usados para gerar a claúsula where que
      // será passada para o próximo controle.
      if objControle.Cells[6, uA] = '1' then
      begin
        if strWhereSql.Text <> '' then
        begin
          strWhereSql.Add('or');
        end;
        strWhereSql.Add(objControle.Cells[3, uA]);
      end;
    end;
    // Só iremos inserir a claúsula where se houver algo selecionado.
    if strWhereSql.Count <> 0 then
    begin
      // Insere a claúsula where antes das condições e em seguida
      strWhereSql.Insert(0, 'where');
      // Atualiza o próximo controle.
      CarregarGrupo4Bolas(strWhereSql.Text);
    end;
  end
  else
  if objControle = sgrGrupo4Bolas then
  begin
    // Apaga os dados dos outros controles.
    sgrGrupo5Bolas.Columns.Clear;

    strWhereSql.Clear;
    // Vamos percorrer o controle e verificar se alguma célula foi marcada.
    for uA := 1 to objControle.RowCount - 1 do
    begin
      // Neste controle há 6 colunas:
      // b_1, b_2, sql_bolas, ltf_bolas, res_qt e marcar.
      // Iremos selecionar a última coluna, a coluna marcar, que indica
      // se o usuário selecionou aquela combinação, se o usuário selecionou
      // aquele combinações, iremos pegar o valor da coluna sql_bolas
      // pois, estes dados serão usados para gerar a claúsula where que
      // será passada para o próximo controle.
      if objControle.Cells[7, uA] = '1' then
      begin
        if strWhereSql.Text <> '' then
        begin
          strWhereSql.Add('or');
        end;
        strWhereSql.Add(objControle.Cells[4, uA]);
      end;
    end;
    // Só iremos inserir a claúsula where se houver algo selecionado.
    if strWhereSql.Count <> 0 then
    begin
      // Insere a claúsula where antes das condições e em seguida
      strWhereSql.Insert(0, 'where');
      // Atualiza o próximo controle.
      CarregarGrupo5Bolas(strWhereSql.Text);
    end;
  end;

end;

{TODO: Mover Tudo referente a grupo de 5, 4, 3, 2 bolas pra um novo arquivo de nome:
       uLotofacil_grupos
}
procedure TForm1.ConfigurarControleGrupo5Bolas;
var
  uColunas, uA, indice_ultima_coluna: integer;
  cabecalho_nome: array[0..8] of
  string = ('b_1', 'b_2', 'b_3', 'b_4', 'b_5', 'sql_bolas', 'ltf_qt',
    'res_qt', 'Marcar');
  coluna_atual: TGridColumn;
begin
  // São 9 colunas, uma das colunas não usaremos, cmb_bolas.
  // A coluna sql_bolas, estará oculta, pois ela servirá somente para
  // podermos atualizar o controle de 3 bolas.
  // b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt, marcar

  sgrGrupo5Bolas.FixedCols := 0;
  sgrGrupo5Bolas.FixedRows := 1;
  sgrGrupo5Bolas.RowCount := 1;

  indice_ultima_coluna := High(cabecalho_nome);
  sgrGrupo5Bolas.Columns.Clear;
  for uA := 0 to indice_ultima_coluna do
  begin
    coluna_atual := sgrGrupo5Bolas.Columns.Add;
    coluna_atual.Alignment := TAlignment.taCenter;
    coluna_atual.Title.Alignment := TAlignment.taCenter;
    coluna_atual.Title.Caption := cabecalho_nome[uA];
    sgrGrupo5Bolas.Cells[uA, 0] := cabecalho_nome[uA];
  end;

  // Oculta a coluna 'sql_bolas'
  sgrGrupo5Bolas.Columns[5].Visible := False;

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
  qtRegistros, uLinha: integer;
begin
  strSql := TStringList.Create;

  ConfigurarControleGrupo5Bolas;

  strSql.Add('Select b_1, b_2, b_3, b_4, b_5, sql_bolas, ltf_qt, res_qt');
  strSql.Add('from lotofacil_resultado_agregado_grupo_5bolas');
  if strSqlWhere <> '' then
  begin
    strSql.Add(strSqlWhere);
  end;
  strSql.Add('order by res_qt desc, ltf_qt desc');
  WriteLn(strSql.Text);

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := strSql.Text;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
    Inc(qtRegistros);
    sqlRegistro.Next;
  end;

  if qtRegistros = 0 then
  begin
    exit;
  end;

  // Define a quantidade de linhas igual a quantidade de registro + 1
  // pois, a primeira linha é o nome do título.
  sgrGrupo5Bolas.RowCount := qtRegistros + 1;
  ;

  // Se encontrarmos registros, inserir.
  // Vamos desativar a atualizar no controle, pra ficar mais rápido.
  sgrGrupo5Bolas.BeginUpdate;
  uLinha := 1;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
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
  sgrGrupo5Bolas.EndUpdate(True);
  sqlRegistro.Close;

  // Ajusta as colunas.
  sgrGrupo5Bolas.AutoSizeColumns;
end;



procedure TForm1.ConfigurarControleGrupo4Bolas;
var
  uColunas, uA: integer;
  strTitulo: array[0..7] of
  string = ('b_1', 'b_2', 'b_3', 'b_4', 'sql_bolas', 'ltf_qt', 'res_qt',
    'Marcar');
begin
  // São 7 colunas, uma das colunas não usaremos, cmb_bolas.
  // A coluna sql_bolas, estará oculta, pois ela servirá somente para
  // podermos atualizar o controle de 3 bolas.
  // b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt, marcar
  uColunas := 8;
  sgrGrupo4Bolas.Columns.Clear;
  while uColunas > 0 do
  begin
    sgrGrupo4Bolas.Columns.Add;
    Dec(uColunas);
  end;

  sgrGrupo4Bolas.FixedCols := 0;
  sgrGrupo4Bolas.FixedRows := 1;
  sgrGrupo4Bolas.RowCount := 1;

  for uA := 0 to 7 do
  begin
    sgrGrupo4Bolas.Columns[uA].Alignment := TAlignment.taCenter;
    sgrGrupo4Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
    sgrGrupo4Bolas.Columns[uA].Title.Caption := strTitulo[uA];
    sgrGrupo4Bolas.Cells[uA, 0] := strTitulo[uA];
  end;

  // Oculta a coluna 'sql_bolas'
  sgrGrupo4Bolas.Columns[4].Visible := False;

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
  qtRegistros, uLinha, uA: integer;
begin
  strSql := TStringList.Create;

  ConfigurarControleGrupo4Bolas;

  strSql.Add('Select b_1, b_2, b_3, b_4, sql_bolas, ltf_qt, res_qt');
  strSql.Add('from lotofacil_resultado_agregado_grupo_4bolas');
  if strSqlWhere <> '' then
  begin
    strSql.Add(strSqlWhere);
  end;
  strSql.Add('order by res_qt desc, ltf_qt desc');
  WriteLn(strSql.Text);

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := strSql.Text;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
    Inc(qtRegistros);
    sqlRegistro.Next;
  end;

  if qtRegistros = 0 then
  begin
    exit;
  end;

  // Define a quantidade de linhas igual a quantidade de registro + 1
  // pois, a primeira linha é o nome do título.
  sgrGrupo4Bolas.RowCount := qtRegistros + 1;
  ;

  // Se encontrarmos registros, inserir.
  // Vamos desativar a atualizar no controle, pra ficar mais rápido.
  sgrGrupo4Bolas.BeginUpdate;
  uLinha := 1;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
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
  sgrGrupo4Bolas.EndUpdate(True);
  sqlRegistro.Close;

  // Ajusta as colunas.
  sgrGrupo4Bolas.AutoSizeColumns;
end;




procedure TForm1.ConfigurarControleGrupo3Bolas;
var
  uColunas, uA: integer;
  strTitulo: array[0..6] of
  string = ('b_1', 'b_2', 'b_3', 'sql_bolas', 'ltf_qt', 'res_qt', 'Marcar');
begin
  // São 7 colunas, uma das colunas não usaremos, cmb_bolas.
  // A coluna sql_bolas, estará oculta, pois ela servirá somente para
  // podermos atualizar o controle de 3 bolas.
  // b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt, marcar
  uColunas := 7;
  sgrGrupo3Bolas.Columns.Clear;
  while uColunas > 0 do
  begin
    sgrGrupo3Bolas.Columns.Add;
    Dec(uColunas);
  end;

  sgrGrupo3Bolas.FixedCols := 0;
  sgrGrupo3Bolas.FixedRows := 1;
  sgrGrupo3Bolas.RowCount := 1;

  for uA := 0 to 6 do
  begin
    sgrGrupo3Bolas.Columns[uA].Alignment := TAlignment.taCenter;
    sgrGrupo3Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
    sgrGrupo3Bolas.Columns[uA].Title.Caption := strTitulo[uA];
    sgrGrupo3Bolas.Cells[uA, 0] := strTitulo[uA];
  end;

  // Oculta a coluna 'sql_bolas'
  sgrGrupo3Bolas.Columns[3].Visible := False;

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
  qtRegistros, uLinha : integer;
begin
  strSql := TStringList.Create;

  ConfigurarControleGrupo3Bolas;

  strSql.Add('Select b_1, b_2, b_3, sql_bolas, ltf_qt, res_qt');
  strSql.Add('from lotofacil_resultado_agregado_grupo_3bolas');
  if strSqlWhere <> '' then
  begin
    strSql.Add(strSqlWhere);
  end;
  strSql.Add('order by res_qt desc, ltf_qt desc');
  WriteLn(strSql.Text);

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := strSql.Text;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
    Inc(qtRegistros);
    sqlRegistro.Next;
  end;

  if qtRegistros = 0 then
  begin
    exit;
  end;

  // Define a quantidade de linhas igual a quantidade de registro + 1
  // pois, a primeira linha é o nome do título.
  sgrGrupo3Bolas.RowCount := qtRegistros + 1;
  ;

  // Se encontrarmos registros, inserir.
  // Vamos desativar a atualizar no controle, pra ficar mais rápido.
  sgrGrupo3Bolas.BeginUpdate;
  uLinha := 1;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
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
  sgrGrupo3Bolas.EndUpdate(True);
  sqlRegistro.Close;

  // Ajusta as colunas.
  sgrGrupo3Bolas.AutoSizeColumns;
end;


procedure TForm1.CarregarGrupo2Bolas;
var
  strSql: TStringList;
  sqlRegistro: TSqlQuery;
  qtRegistros, uLinha: integer;
begin
  strSql := TStringList.Create;

  ConfigurarControleGrupo2Bolas;

  strSql.Add('Select b_1, b_2, sql_bolas, ltf_qt, res_qt');
  //    strSql.Add('from v_lotofacil_resultado_grupo_2bolas');
  strSql.Add('from lotofacil_resultado_agregado_grupo_2bolas');
  strSql.Add('order by res_qt desc, ltf_qt desc');

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlRegistro := dmLotofacil.sqlLotofacil;
  sqlRegistro.Active := False;
  sqlRegistro.DataBase := dmLotofacil.pgLtk;
  sqlRegistro.SQL.Text := strSql.Text;
  sqlRegistro.UniDirectional := False;
  sqlRegistro.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
    Inc(qtRegistros);
    sqlRegistro.Next;
  end;

  if qtRegistros = 0 then
  begin
    exit;
  end;

  // Define a quantidade de linhas igual a quantidade de registro + 1
  // pois, a primeira linha é o nome do título.
  sgrGrupo2Bolas.RowCount := qtRegistros + 1;
  ;

  // Se encontrarmos registros, inserir.
  uLinha := 1;
  sqlRegistro.First;
  while not sqlRegistro.EOF do
  begin
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
  uColunas, uA: integer;
  strTitulo: array[0..5] of string = ('b_1', 'b_2', 'sql_bolas',
    'ltf_qt', 'res_qt', 'Marcar');
begin
  // São 6 colunas, uma das colunas não usaremos, cmb_bolas.
  // A coluna sql_bolas, estará oculta, pois ela servirá somente para
  // podermos atualizar o controle de 3 bolas.
  // b_1, b_2, sql_bolas, ltf_qt, res_qt, marcar
  uColunas := 6;
  sgrGrupo2Bolas.Columns.Clear;
  while uColunas > 0 do
  begin
    sgrGrupo2Bolas.Columns.Add;
    Dec(uColunas);
  end;

  sgrGrupo2Bolas.FixedCols := 0;
  sgrGrupo2Bolas.FixedRows := 1;
  sgrGrupo2Bolas.RowCount := 1;

  for uA := 0 to 5 do
  begin
    sgrGrupo2Bolas.Columns[uA].Alignment := TAlignment.taCenter;
    sgrGrupo2Bolas.Columns[uA].Title.Alignment := TAlignment.taCenter;
    sgrGrupo2Bolas.Columns[uA].Title.Caption := strTitulo[uA];
    sgrGrupo2Bolas.Cells[uA, 0] := strTitulo[uA];
  end;

  // Oculta a coluna 'sql_bolas'
  sgrGrupo2Bolas.Columns[2].Visible := False;

  // Indica o tipo da coluna 5, a coluna marcar
  sgrGrupo2Bolas.Columns[5].ButtonStyle := TColumnButtonStyle.cbsCheckboxColumn;

end;

procedure TForm1.CarregarDiagonal;
begin
  //CarregarDiagonal(sgrDiagonal15Bolas);
  //CarregarDiagonal(sgrDiagonal16Bolas);
  //CarregarDiagonal(sgrDiagonal17Bolas);
  //CarregarDiagonal(sgrDiagonal18Bolas);

end;



procedure TForm1.CarregarDiagonal(objControle: TStringGrid);
var
  strSql: TStringList;
  sqlConcurso: TSqlQuery;
  qtRegistros, uLinha, uA: integer;
begin
  {
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

  }

end;

procedure TForm1.ConfigurarControleDiagonal(objControle: TStringGrid);
var
  uA, uColunas: integer;
begin
  {
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
    }
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
  concursoFim, strSql: string;
begin
  concursoInicio := cmbFrequenciaInicio.Items[cmbFrequenciaInicio.ItemIndex];
  concursoFim := cmbFrequenciaFim.Items[cmbFrequenciaFim.ItemIndex];

  if StrToInt(concursoInicio) > StrToInt(concursoFim) then
  begin
    MessageDlg('', 'Concurso de início deve ser menor que concurso fim',
      TMsgDlgType.mtError, [mbOK], 0);
    exit;
  end;

  strSql := 'where concurso >= ' + concursoInicio + ' and ';
  strSql := strSQl + 'concurso <= ' + concursoFim;
  CarregarFrequencia(strSql);
end;

procedure TForm1.CarregarFrequencia(strSqlWhere: string);
var
  strSql: TStringList;
  qtRegistros, uLinha, uA: integer;
  sqlConcurso: TSqlQuery;
begin
  strSql := TStringList.Create;
  strSql.Add('Select * from lotofacil_resultado_frequencia');
  // Não iremos validar o sqlSqlWhere.
  strSql.Add(strSqlWhere);
  strSql.Add('order by concurso');

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlConcurso := dmLotofacil.sqlLotofacil;
  sqlConcurso.Active := False;
  sqlConcurso.DataBase := dmLotofacil.pgLtk;
  sqlConcurso.SQL.Text := strSql.Text;
  sqlConcurso.UniDirectional := False;
  sqlConcurso.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlConcurso.First;
  while not sqlConcurso.EOF do
  begin
    Inc(qtRegistros);
    sqlConcurso.Next;
  end;

  if qtRegistros = 0 then
  begin
    exit;
  end;

  // Vamos alterar a quantidade de linhas do stringGrid.
  // Haverá 1 linha a mais.
  sgrFrequencia.RowCount := qtRegistros + 1;

  // Vamos inserir os registros.
  sqlConcurso.First;

  // Definir os rótulos da linha 0.
  sgrFrequencia.Cells[0, 0] := 'Concurso';
  for uA := 1 to 25 do
  begin
    sgrFrequencia.Cells[uA, 0] := IntToStr(uA);
  end;

  // A linha 0, é o título da stringGrid.
  uLinha := 1;
  while not sqlConcurso.EOF do
  begin
    // Insere o concurso na coluna 1.
    sgrFrequencia.Cells[0, uLinha] := sqlConcurso.FieldByName('concurso').AsString;

    // Aqui, como as colunas 'num_' terminar em número, iremos concatenar pra
    // pegar os nomes dos campos.
    for uA := 1 to 25 do
    begin
      sgrFrequencia.Cells[uA, uLinha] :=
        sqlConcurso.FieldByName('num_' + IntToStr(uA)).AsString;
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
  qtRegistros: integer;
begin
  strSql := 'Select * from v_lotofacil_concurso_todos order by concurso';

  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  sqlConcurso := dmLotofacil.sqlLotofacil;
  sqlConcurso.Active := False;
  sqlConcurso.DataBase := dmLotofacil.pgLtk;
  sqlConcurso.SQL.Text := strSql;
  sqlConcurso.UniDirectional := False;
  sqlConcurso.Open;

  // Vamos verificar quantos registros houve.
  qtRegistros := 0;
  sqlConcurso.First;
  while not sqlConcurso.EOF do
  begin
    Inc(qtRegistros);
    sqlConcurso.Next;
  end;

  if qtRegistros = 0 then
  begin
    exit;
  end;

  // Apaga os ítens do combobox.
  cmbFrequenciaInicio.Items.Clear;
  cmbFrequenciaFim.Items.Clear;


  // Se encontrarmos registros, inserir.
  sqlConcurso.First;
  while not sqlConcurso.EOF do
  begin
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
  uColunas, uA: integer;
begin
  // Haverá 26 colunas.
  // Vamos apagar todas as colunas.
  sgrFrequencia.Columns.Clear;
  uColunas := 26;
  while uColunas > 0 do
  begin
    sgrFrequencia.Columns.Add;
    Dec(uColunas);
  end;

  sgrFrequencia.Columns[0].Alignment := TAlignment.taCenter;
  sgrFrequencia.Columns[0].Title.Caption := 'Concurso';
  sgrFrequencia.Columns[0].Title.Alignment := TAlignment.taCenter;

  for uA := 1 to 25 do
  begin
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
    Há 4 controles stringGrid, controle para as colunas:
    b1, b1_b15, b1_b8_b15 e b1_b4_b8_b12_b15.
    Ao clicar em qual elemento do controle que armazena as combinações b1,
    automaticamente, a coluna b1_b15, será atualizada, pra exibir somente
    combinações que tem a coluna b1 selecionada.
    Utilizando a mesma lógica, se qualquer elemento do controle que armazena
    as combinações b1 e b15, automaticamente, a coluna b1_b8_b15, terá combinações
    correspondente, as colunas b1 e b15 selecionadas.
    Então, pra os demais controles aplica-se a mesma lógica.
    Segue-se abaixo, os controles na ordem sequencial que efetua atualização
    no controle sucessor.
    Na lista abaixo, da ordem de cima pra baixo,
    o primeiro item é o que atualiza o segundo item,
    o segundo item atualiza o terceiro item.
    Um controle só atualiza o próximo da lista, nunca atualiza vários controles
    ao mesmo tempo, pois, o usuário precisa clicar no controle primeiro, pra
    posteriormente, o seguinte a ele ser atualizado.
    }
procedure TForm1.GerarSqlColuna_B(objControle: TStringGrid);
var
  strSql, coluna_b1, coluna_b2, coluna_b3, coluna_b8, coluna_b15,
  coluna_combinada, coluna_b4: string;
  indiceUltimaColuna: integer;
  uA: integer;
begin
  strSql := '';
  indiceUltimaColuna := objControle.ColCount - 1;

  if objControle = sgrColunaB1_15Bolas then
  begin
    // Apaga os outros controles.
    sgrColunaB1_B15_15Bolas.Columns.Clear;
    sgrColunaB1_B8_B15_15Bolas.Columns.Clear;
    sgrColunaB1_B4_B8_B12_B15_15Bolas.Columns.Clear;

    sgrColunaB1_B2_15Bolas.Columns.Clear;
    sgrColunaB1_B2_B3_15Bolas.Columns.Clear;
    sgrColunaB1_B2_B3_B4_15Bolas.Columns.Clear;
    sgrColunaB1_B2_B3_B4_B5_15Bolas.Columns.Clear;

    // Colunas: b_1, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_15Bolas.RowCount - 1 do
    begin
      if sgrColunaB1_15Bolas.Cells[indiceUltimaColuna, uA] = '1' then
      begin
        if strSql <> '' then
        begin
          strSql := strSql + ',';
        end;
        strSql := strSql + sgrColunaB1_15Bolas.Cells[1, uA];
      end;
    end;

    if strSql <> '' then
    begin
      // Insere a clausula where
      strSql := 'where b1 in (' + strSql + ')';
      CarregarColuna_B(sgrColunaB1_B15_15Bolas, strSql);
      CarregarColuna_B(sgrColunaB1_B2_15Bolas, strSql);
    end;
  end
  else if objControle = sgrColunaB1_B15_15Bolas then
  begin
    // Apaga os outros controles.
    sgrColunaB1_B8_B15_15Bolas.Columns.Clear;
    sgrColunaB1_B4_B8_B12_B15_15Bolas.Columns.Clear;

    // Colunas: b1_b15_id, b_1, b_15, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_B15_15Bolas.RowCount - 1 do
    begin

      // Se é 1, quer dizer que o usuário selecionou a opção.
      if sgrColunaB1_B15_15Bolas.Cells[indiceUltimaColuna, uA] = '1' then
      begin

        // Se há mais de um argumento, então devemos interseparar com vírgula.
        if strSql <> '' then
        begin
          strSql := strSql + ',';
        end;

        // No controle sgrColunaB1_B15_15Bolas,
        // a coluna 0, é o campo identificador da combinação;
        // As colunas 1 e 2, corresponde, respectivamente, aos campos b1 e b15.

        // Iremos concatenar os campos b1 e b15, interseparando com o caractere '_'.
        coluna_b1 := sgrColunaB1_B15_15Bolas.Cells[1, uA];
        coluna_b15 := sgrColunaB1_B15_15Bolas.Cells[2, uA];
        coluna_combinada := coluna_b1 + '_' + coluna_b15;
        coluna_combinada := QuotedStr(coluna_combinada);

        strSql := strSql + coluna_combinada;
      end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo.
    if strSql <> '' then
    begin
      // Insere a claúsula where.
      // Neste caso, iremos concatenar os campos b_1 e b_15, e interseparar com
      // sublinhado,
      strSql := 'where b1 || ''_'' || b15 in (' + strSql + ')';
      WriteLn(strSql);
      CarregarColuna_B(sgrColunaB1_B8_B15_15Bolas, strSql);
    end;
  end
  else if objControle = sgrColunaB1_B8_B15_15Bolas then
  begin
    // Apaga outros controles.
    sgrColunaB1_B4_B8_B12_B15_15Bolas.Columns.Clear;

    // Coluns: b1, b_8, b_15, cmb_b1_b8_b15, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunaB1_B8_B15_15Bolas.RowCount - 1 do
    begin

      // Se é 1, quer dizer, que o usuário selecionou a opção.
      if sgrColunaB1_B8_B15_15Bolas.Cells[indiceUltimaColuna, uA] = '1' then
      begin
        // Se há mais de um argumento, devemos interseparar com vírgula.
        if strSql <> '' then
        begin
          strSql := strSql + ',';
        end;

        // No controle sgrColunaB1_B8_B15_15Bolas,
        // a coluna 0, é o identificador da combinação
        // As colunas 1, 2 e 3, corresponde, respectivamente, aos campos b1, b8 e b15.

        // Iremos concatenar os campos b1 e b15, interseparando com o caractere '_'.
        coluna_b1 := sgrColunaB1_B8_B15_15Bolas.Cells[1, uA];
        coluna_b8 := sgrColunaB1_B8_B15_15Bolas.Cells[2, uA];
        coluna_b15 := sgrColunaB1_B8_B15_15Bolas.Cells[3, uA];

        coluna_combinada := coluna_b1 + '_' + coluna_b8 + '_' + coluna_b15;
        coluna_combinada := QuotedStr(coluna_combinada);

        strSql := strSql + coluna_combinada;
      end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
    // pelo usuário.
    if strSql <> '' then
    begin
      // Insere a claúsula where.
      // Neste caso, iremos concatenar os campos b_1, b_8 e b_15 e interseparar
      // com sublinhado:
      strSql := 'where b1 || ''_'' || b8 || ''_'' || b15 in (' + strSql + ')';
      WriteLn(strSql);
      CarregarColuna_B(sgrColunaB1_B4_B8_B12_B15_15Bolas, strSql);
    end;
  end

  else if objControle = sgrColunab1_b2_15Bolas then
  begin
    // Apaga os outros controles que depende deste controle.

    sgrColunaB1_B2_B3_15Bolas.Columns.Clear;
    sgrColunaB1_B2_B3_B4_15Bolas.Columns.Clear;
    sgrColunaB1_B2_B3_B4_B5_15Bolas.Columns.Clear;

    // Colunas: b1_b2_id, b_1, b_2, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunab1_b2_15Bolas.RowCount - 1 do
    begin

      // Se é 1, quer dizer que o usuário selecionou a opção.
      if sgrColunab1_b2_15Bolas.Cells[indiceUltimaColuna, uA] = '1' then
      begin

        // Se há mais de um argumento, então devemos interseparar com vírgula.
        if strSql <> '' then
        begin
          strSql := strSql + ',';
        end;

        // No controle sgrColunab1_b2_15Bolas,
        // a coluna 0, é o campo identificador da combinação;
        // As colunas 1 e 2, corresponde, respectivamente, aos campos b1 e b15.

        // Iremos concatenar os campos b1 e b15, interseparando com o caractere '_'.
        coluna_b1 := sgrColunab1_b2_15Bolas.Cells[1, uA];
        coluna_b2 := sgrColunab1_b2_15Bolas.Cells[2, uA];
        coluna_combinada := coluna_b1 + '_' + coluna_b2;
        coluna_combinada := QuotedStr(coluna_combinada);

        strSql := strSql + coluna_combinada;
      end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo.
    if strSql <> '' then
    begin
      // Insere a claúsula where.
      // Neste caso, iremos concatenar os campos b_1 e b_15, e interseparar com
      // sublinhado,
      strSql := 'where b1 || ''_'' || b2 in (' + strSql + ')';
      WriteLn(strSql);
      CarregarColuna_B(sgrColunaB1_B2_B3_15Bolas, strSql);
    end;
  end
  else if objControle = sgrColunab1_b2_b3_15Bolas then
  begin
    // Apaga os outros controles que depende deste controle.
    sgrColunaB1_B2_B3_B4_15Bolas.Columns.Clear;
    sgrColunaB1_B2_B3_B4_B5_15Bolas.Columns.Clear;

    // Coluns: b1, b_2, b_3, b4, cmb_b1_b2_b3, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunab1_b2_b3_15Bolas.RowCount - 1 do
    begin

      // Se é 1, quer dizer, que o usuário selecionou a opção.
      if sgrColunab1_b2_b3_15Bolas.Cells[indiceUltimaColuna, uA] = '1' then
      begin
        // Se há mais de um argumento, devemos interseparar com vírgula.
        if strSql <> '' then
        begin
          strSql := strSql + ',';
        end;

        // No controle sgrColunab1_b2_b3_15Bolas,
        // a coluna 0, é o identificador da combinação
        // As colunas 1, 2 e 3, corresponde, respectivamente, aos campos b1, b2 e b3.

        // Iremos concatenar os campos b1 e b15, interseparando com o caractere '_'.
        coluna_b1 := sgrColunab1_b2_b3_15Bolas.Cells[1, uA];
        coluna_b2 := sgrColunab1_b2_b3_15Bolas.Cells[2, uA];
        coluna_b3 := sgrColunab1_b2_b3_15Bolas.Cells[3, uA];

        coluna_combinada := coluna_b1 + '_' + coluna_b2 + '_' + coluna_b3;
        coluna_combinada := QuotedStr(coluna_combinada);

        strSql := strSql + coluna_combinada;
      end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
    // pelo usuário.
    if strSql <> '' then
    begin
      // Insere a claúsula where.
      // Neste caso, iremos concatenar os campos b_1, b_2 e b_3 e interseparar
      // com sublinhado:
      strSql := 'where b1 || ''_'' || b2 || ''_'' || b3 in (' + strSql + ')';
      WriteLn(strSql);
      // Em seguida, vamos passar pra o outro controle a direita que depende dele.
      CarregarColuna_B(sgrColunaB1_B2_B3_B4_15Bolas, strSql);
    end;
  end
  else if objControle = sgrColunab1_b2_b3_b4_15Bolas then
  begin
    // Apaga os outros controles que depende deste controle.
    sgrColunaB1_B2_B3_B4_B5_15Bolas.Columns.Clear;

    // Coluns: b1, b_2, b_3, b4, cmb_b1_b2_b3, ltf_qt, res_qt, marcar.
    for uA := 1 to sgrColunab1_b2_b3_b4_15Bolas.RowCount - 1 do
    begin

      // Se é 1, quer dizer, que o usuário selecionou a opção.
      if sgrColunab1_b2_b3_b4_15Bolas.Cells[indiceUltimaColuna, uA] = '1' then
      begin
        // Se há mais de um argumento, devemos interseparar com vírgula.
        if strSql <> '' then
        begin
          strSql := strSql + ',';
        end;

        // No controle sgrColunab1_b2_b3_15Bolas,
        // a coluna 0, é o identificador da combinação
        // As colunas 1, 2 e 3, corresponde, respectivamente, aos campos b1, b2 e b3.

        // Iremos concatenar os campos b1 e b15, interseparando com o caractere '_'.
        coluna_b1 := sgrColunab1_b2_b3_b4_15Bolas.Cells[1, uA];
        coluna_b2 := sgrColunab1_b2_b3_b4_15Bolas.Cells[2, uA];
        coluna_b3 := sgrColunab1_b2_b3_b4_15Bolas.Cells[3, uA];
        coluna_b4 := sgrColunab1_b2_b3_b4_15Bolas.Cells[4, uA];

        coluna_combinada :=
          coluna_b1 + '_' + coluna_b2 + '_' + coluna_b3 + '_' + coluna_b4;
        coluna_combinada := QuotedStr(coluna_combinada);

        strSql := strSql + coluna_combinada;
      end;
    end;

    // Se strSql não está vazio, quer dizer, que encontramos algo que foi selecionado
    // pelo usuário.
    if strSql <> '' then
    begin
      // Insere a claúsula where.
      // Neste caso, iremos concatenar os campos b_1, b_2 e b_3 e interseparar
      // com sublinhado:
      strSql := 'where b1 || ''_'' || b2 || ''_'' || b3 || ''_'' || b4 in (' +
        strSql + ')';
      WriteLn(strSql);
      // Em seguida, vamos passar pra o outro controle a direita que depende dele.
      CarregarColuna_B(sgrColunaB1_B2_B3_B4_B5_15Bolas, strSql);
    end;
  end;
end;

{
 Colunas_B: Início.
}
procedure TForm1.CarregarColuna_B;
begin
  // Configura todos os controles
  CarregarColuna_B(sgrColunaB1_15Bolas, '');
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB1);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB2);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB3);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB4);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB5);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB6);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB7);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB8);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB9);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB10);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB11);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB12);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB13);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB14);
  Carregar_Controle_Bolas_Por_Posicao(sgrColunaB15);

  //CarregarColuna_B(sgrColunaB1_B15_15Bolas, '');
  // CarregarColuna_B(sgrColunaB1_17Bolas, '');
  // CarregarColuna_B(sgrColunaB1_18Bolas, '');
end;

{
 Iremos fazer, dois procedimentos para carregar as colunas_b
 Um será para os controles da coluna B_1, pois inicialmente estes controles
 exibirão os dados da tabela, então, se o usuário clicar em uma das células,
 o próximo controle será carregado, baseado, no valor selecionado.
 Então, se o controle b1, for clicado, preenche-se o controle b1_b15.
 Se o controle b1_b15, é clicado, preenche o controle b1_b8_b15.
 Se o controle b1_b8_b15, for clicado, preenche-se o controle b1_b4_b8_b12_b15.
 Então, ao analisar os controles, pra gerar o sql, será baseado o controle que
 tem mais colunas selecionados, então será nesta ordem:
 b1_b4_b8_b12_b15;
 b1_b8_b15;
 b1_b15;
 b1
 Se o usuário desmarcar todos as opções do controle b1, nenhum sql, será baseado
 nestes campos.
 }
procedure TForm1.CarregarColuna_B(objControle: TStringGrid; strSql: string);
var
  sqlTemp: TStringList;
  qtRegistros: longint;
  dsLotofacil: TSqlQuery;
  uLinha, uA: integer;
begin
  sqlTemp := TStringList.Create;

  ConfigurarControlesBolas_B(objControle);
  // ConfigurarControlesBolas_B;

  //exit;

  // Para os controles de 'Bolas nas Colunas', os controles de 15 Bolas:
  // sgrColunaB1_15Bolas, sgrColunaB1_B15_15Bolas, sgrColunaB1_B8_B15_15Bolas
  // e sgrColunaB1_B4_B8_B12_B15_15Bolas, devemos implementar o sql separadamente.
  // Pois, eles tem 1 campos a mais, indicando a quantidade de combinações que
  // já saíram na lotofacil de 15 números.
  sqlTemp.Clear;
  if objControle = sgrColunaB1_15Bolas then
  begin
    sqlTemp.Add('Select b1_id, b1, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1');

  end
  else if objControle = sgrColunaB1_B15_15Bolas then
  begin
    sqlTemp.Add('Select b1_b15_id, b1, b15, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b15');

  end
  else if objControle = sgrColunaB1_B8_B15_15Bolas then
  begin
    sqlTemp.Add('Select b1_b8_b15_id, b1, b8, b15, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b8_b15');

  end
  else if objControle = sgrColunaB1_B4_B8_B12_B15_15Bolas then
  begin
    sqlTemp.Add('Select b1_b4_b8_b12_b15_id, b1, b4, b8, b12, b15, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b4_b8_b12_b15');

  end
  else if objControle = sgrColunaB1_B2_15Bolas then
  begin
    sqlTemp.Add('Select b1_b2_id, b1, b2, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b2');

  end
  else if objControle = sgrColunaB1_B2_B3_15Bolas then
  begin
    sqlTemp.Add('Select b1_b2_b3_id, b1, b2, b3, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b2_b3');

  end
  else if objControle = sgrColunaB1_B2_B3_B4_15Bolas then
  begin
    sqlTemp.Add('Select b1_b2_b3_b4_id, b1, b2, b3, b4, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b2_b3_b4');

  end
  else if objControle = sgrColunaB1_B2_B3_B4_B5_15Bolas then
  begin
    sqlTemp.Add('Select b1_b2_b3_b4_b5_id, b1, b2, b3, b4, b5, ltf_qt, res_qt');
    sqlTemp.Add('from lotofacil.v_lotofacil_resultado_b1_b2_b3_b4_b5');
  end;

  // Se houver algum string sql passado, devemos adicionar
  if strSql <> '' then
  begin
    sqlTemp.Add(strSql);
  end;

  // Ordenar pela coluna de resultado.
  sqlTemp.Add('order by res_qt desc, ltf_qt desc');

  // Verifica se o módulo está instanciado.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // Agora, verificar se tem um módulo
  dsLotofacil := dmLotofacil.sqlLotofacil;

  dsLotofacil.Active := False;
  dmLotofacil.sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  dmLotofacil.sqlLotofacil.SQL.Text := sqlTemp.Text;
  dmLotofacil.sqlLotofacil.UniDirectional := False;
  dmLotofacil.sqlLotofacil.Prepare;
  dsLotofacil.Open;

  // RecordCount está retornando menos registros que a quantidade atual, segue-se
  // contorno.
  dsLotofacil.First;
  dsLotofacil.Last;
  qtRegistros := dsLotofacil.RecordCount;

  if qtRegistros = 0 then
  begin
    objControle.Columns.Clear;
    objControle.Columns.Add;
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
  while not dsLotofacil.EOF do
  begin
    uA := 0;
    // Gravar cada campo na respectiva célula correspondente.
    for uA := 0 to dsLotofacil.FieldCount - 1 do
    begin
      objControle.Cells[uA, uLinha] := dsLotofacil.Fields[uA].AsString;
    end;
    // Coloca 0, na última coluna, que é a coluna 'marcar'.
    objControle.Cells[dsLotofacil.FieldCount, uLinha] := '0';
    Inc(uLinha);
    dsLotofacil.Next;
  end;

  // Ocultar a coluna 0, com o id das combinações.
  objControle.Columns[0].Visible := False;

  // Insere o nome dos campos na fileira 0.
  for uA := 0 to dsLotofacil.FieldCount - 1 do
  begin
    objControle.Cells[uA, 0] := dsLotofacil.Fields[uA].Name;
  end;
  objControle.Cells[uA, 0] := 'Marcar';


  objControle.AutoSizeColumns;
end;

{
 Esta procedure configura cada controle stringGrid das colunas b1, b4, b8, b12 e b15.
 As colunas b1, b4, b8, b12 e b15, são comuns a todas as quantidades de 15, 16, 17
 e 18 bolas, então, não é necessário configurar controles de 16, 17 e 18 bolas.
}
procedure TForm1.ConfigurarControlesBolas_B(objControle: TStringGrid);
begin
  if objControle = sgrColunaB1_15Bolas then
  begin
    ConfigurarControlesBolas_B1(sgrColunaB1_15Bolas);
  end
  else if objControle = sgrColunaB1_B15_15Bolas then
  begin
    ConfigurarControlesBolas_B1_B15(sgrColunaB1_B15_15Bolas);
  end
  else if objControle = sgrColunaB1_B8_B15_15Bolas then
  begin
    ConfigurarControlesBolas_b1_b8_b15(sgrColunaB1_B8_B15_15Bolas);
  end
  else if objControle = sgrColunaB1_B4_B8_B12_B15_15Bolas then
  begin
    ConfigurarControlesBolas_b1_b4_b8_b12_b15(sgrColunaB1_B4_B8_B12_B15_15Bolas);
  end
  // Adicionado em 21/03/2018.
  else if objControle = sgrColunaB1_B2_15Bolas then
  begin
    ConfigurarControlesBolas_b1_b2(sgrColunaB1_B2_15Bolas);
  end
  else if objControle = sgrColunaB1_B2_B3_15Bolas then
  begin
    ConfigurarControlesBolas_b1_b2_b3(sgrColunaB1_b2_b3_15Bolas);
  end
  else if objControle = sgrColunaB1_B2_B3_B4_15Bolas then
  begin
    ConfigurarControlesBolas_b1_b2_b3_b4(sgrColunaB1_b2_b3_b4_15Bolas);
  end
  else if objControle = sgrColunaB1_B2_B3_B4_B5_15Bolas then
  begin
    ConfigurarControlesBolas_b1_b2_b3_b4_b5(sgrColunaB1_b2_b3_b4_b5_15Bolas);
  end;

end;


{
 Carrega os controles que armazena as estatísticas de novos x repetidos.
}
procedure TForm1.CarregarNovosRepetidos;
begin
  uLotofacilNovosRepetidos.CarregarNovosRepetidos(sgrNovosRepetidos);
  uLotofacilNovosRepetidos.CarregarNovosRepetidos(sgrNovosRepetidosConsolidado);
  uLotofacilNovosRepetidos.CarregarNovosRepetidosPorConcurso(
    sgrNovosRepetidosPorConcurso);

  CarregarNovosRepetidosUltimaAtualizacao;
end;

{
Esta procedure verificar o último concurso atualizado na tabela
lotofacil_novos_repetidos e exibe o mesmo para o usuário em um campo label.
Então, o usuário pode atualizar se assim desejar.
}
procedure TForm1.CarregarNovosRepetidosUltimaAtualizacao;
var
  strSql: TStringList;
  sqlLotofacil: TSqlquery;
  totalRegistros, concurso: longint;
begin
  // Carrega o módulo, se não está carregado.
  if dmLotofacil = nil then
  begin
    dmLotofacil := TdmLotofacil.Create(Self);
  end;

  // Aqui, iremos pegar o total de registros e o concurso,
  // se houver mais de 1 registro, quer dizer, que os dados da tabela
  // estão corrompidos, devemos apagar.
  // Deve há um único concurso, e um total de 6.874.010 registros.
  strSql := TStringList.Create;
  strSql.Add('Select concurso, ');
  strSql.Add('  count(concurso) as qt_vezes');
  strSql.Add('  from lotofacil.lotofacil_novos_repetidos');
  strSql.Add('group by concurso');
  strSql.Add('order by concurso desc');

  sqlLotofacil := dmLotofacil.sqlLotofacil;

  sqlLotofacil.Close;
  sqlLotofacil.DataBase := dmLotofacil.pgLtk;
  sqlLotofacil.SQL.Text := strSql.Text;
  sqlLotofacil.UniDirectional := False;
  sqlLotofacil.Prepare;
  sqlLotofacil.Open;

  // Verifica se há registros
  if sqlLotofacil.RecordCount = 0 then
  begin
    lblNovosRepetidosUltimaAtualizacao.Caption := 'Não há nenhuma atualizacao';
    exit;
  end;

  // Achamos registros, inserir então.
  sqlLotofacil.First;

  // Vamos verificar se há 6.874.010 registros, se não houver, vamos indicar
  // que não há nenhuma atualização.
  totalRegistros := sqlLotofacil.FieldByName('qt_vezes').AsInteger;
  concurso := sqlLotofacil.FieldByName('concurso').AsInteger;

  // Se não há esta quantidade, devemos apagar todos os registros.
  if totalRegistros <> 6874010 then
  begin
    sqlLotofacil.Close;
    sqlLotofacil.SQL.Text := 'Delete from lotofacil.lotofacil_novos_repetidos';
    sqlLotofacil.Prepare;
    sqlLotofacil.Open;
    lblNovosRepetidosUltimaAtualizacao.Caption := 'Não há nenhuma atualizacao';
    exit;
  end;

  // Fecha a consulta.
  sqlLotofacil.Close;

  // Informa ao usuário o último concurso atualizado.
  lblNovosRepetidosUltimaAtualizacao.Caption := IntToStr(concurso);

  dmLotofacil.Free;
  dmLotofacil := nil;
end;

{
 Esta procedure configura todos os controles que são referentes à
 combinações pares x ímpares.
}
procedure TForm1.CarregarParImpar;
begin

  CarregarParImparAgrupado(sgrParImpar15Bolas);
  CarregarParImparAgrupado(sgrParImparConsolidado);
  CarregarParImparPorConcurso(sgrParImparPorConcurso);

end;

procedure TForm1.CarregarExternoInterno;
begin
  CarregarExternoInternoAgrupado(sgrExternoInterno15Bolas);
  CarregarExternoInternoAgrupado(sgrExternoInternoConsolidado);
  CarregarExternoInternoPorConcurso(sgrExternoInternoPorConcurso);

end;


{
 PRIMO X NÃO PRIMO
 }

procedure TForm1.CarregarPrimo;
begin
  CarregarPrimoNaoPrimo(sgrPrimo15Bolas);
  CarregarPrimoNaoPrimo(sgrPrimoNaoPrimoConsolidado);
  CarregarPrimoNaoPrimoPorConcurso(sgrPrimoNaoPrimoPorConcurso);
end;

procedure TForm1.Carregar_Controles_Algarismo_na_dezena;
begin
  Carregar_algarismo_nas_dezenas_agrupado(sgrAlgarismo_na_dezena);
  Carregar_algarismo_nas_dezenas_agrupado(sgrAlgarismo_na_dezena_consolidado);
  Carregar_algarismo_na_dezena_por_concurso(sgrAlgarismo_na_dezena_por_concurso);
end;

end.
