{
 Declara variáveis que serão usadas em mais de um módulo.
}

unit lotofacil_var_global;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Grids, ExtCtrls, lotofacil_sgr_controle, StdCtrls, fgl;

type
  T_lista_filtro_binario = specialize TFPGList<PR_Filtro_Binario_Controle>;
  T_mapa_filtro_binario = specialize TFPGMap<Integer, R_Filtro_Binario_Controle>;

type
  R_Frequencia_Minimo_Maximo = record
    cmb_ainda_nao_saiu_minimo: TComboBox;
    cmb_ainda_nao_saiu_maximo: TComboBox;
    cmb_novo_minimo : TComboBox;
    cmb_novo_maximo : TComboBox;
    cmb_repetindo_minimo : TComboBox;
    cmb_repetindo_maximo : TComboBox;
    cmb_deixou_de_sair_minimo : TComboBox;
    cmb_deixou_de_sair_maximo : TComboBox;
  end;

var

    // Armazena cada controle.
    sgr_filtro_controle: array of TStringGrid;
    rd_filtro_controle:  array of TRadioGroup;

    sgr_filtro_cabecalho: array of string;

    // Define o nome dos campos ao montar o sql.
    sgr_filtro_sql: array of array of string;

    sgr_filtro_controle_info: array of R_Filtro_Controle;

    lista_filtro_binario : T_lista_filtro_binario;
    mapa_filtro_binario_info : T_mapa_filtro_binario;


implementation

end.


