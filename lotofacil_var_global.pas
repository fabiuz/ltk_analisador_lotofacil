{
 Declara variáveis que serão usadas em mais de um módulo.
}

unit lotofacil_var_global;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Grids, ExtCtrls, StdCtrls, fgl;

type
    R_Filtro_Controle = record
        sql: string;
        sql_campos: string;
        sgr_controle_cabecalho: string;
        sgr_controle: TStringGrid;
        rd_controle: TRadioGroup;
        sql_campo_id: string;
        exibir_campo_id: boolean;
    end;

    T_Filtro_Controle = class
        sql_campos: string;
        sql_controle_cabecalho: string;
        sgr_controle: TStringGrid;
        sql: string;
    end;

type
    TLotofacil_Concurso = record
        concurso: Integer;
        b1_a_b15: array[0..15] of Byte;
        num1_a_num_25: array[0..25] of Byte;
    end;
    TLotofacil_Concurso_Array = array of TLotofacil_Concurso;


type
    // Neste record, iremos armazenar três controles pois eles estão interligados
    // na mesma estatística.
    R_Filtro_Binario_Controle = record
        sql: string;                       // Sql a ser executado.
        sql_campos: string;                // Campos da query que utilizaremos.
        sql_order_by: string;
        sql_campo_id: string;              // Os ids dos filtros, sempre está na coluna 0, entretanto,
                                           // precisamos saber qual é o nome deste campo.
        sql_temporario: string;            // Gera um sql dinâmico pra ser usado posteriormente.
        sgr_controle_cabecalho: string;    // Nome dos cabeçalhos que corresponde aos campos sql.
        btn_controle: TButton;
        sgr_controle: TStringGrid;         // Controle que armazena todos os filtros.
        chk_controle: TCheckGroup;         // Controle que serve pra filtrar baseado na quantidade de bolas.
        rd_controle: TRadioGroup;          // Controle que serve pra marcar/desmarcar coluna 'sim' ou coluna 'nao'.
        chk_controle_excluir_bolas: string;           // Armazena as bolas selecionadas do controle 'chkcontrole',
                                                      // se houver mais de 1 bola selecionada será interseparada
                                                      // pelo caractere ',' (vírgula).
    end;
    PR_Filtro_Binario_Controle = ^R_Filtro_Binario_Controle;

type
        R_Filtro_Info = record
            sql: string;
            sql_campos: string;
            sql_order_by: string;
            sql_campos_id: string;
            sgr_controle: TStringGrid;
            sgr_controle_cabecalho: string;
            btn_controle: TButton;
            chk_controle: TCheckGroup;
            rd_controle: TRadioGroup;
        end;
        PR_Filtro_Info = ^R_Filtro_Info;
//type
        TLista_Filtro_Info = specialize TFPGList<PR_Filtro_Info>;
        TMapa_Filtro_Info = specialize TFPGMap<Integer, R_Filtro_Info>;

type
    T_lista_filtro_binario = specialize TFPGList<PR_Filtro_Binario_Controle>;
    T_mapa_filtro_binario  = specialize TFPGMap<integer, R_Filtro_Binario_Controle>;

type
    R_Frequencia_Minimo_Maximo = record
        cmb_ainda_nao_saiu_minimo: TComboBox;
        cmb_ainda_nao_saiu_maximo: TComboBox;
        cmb_novo_minimo:      TComboBox;
        cmb_novo_maximo:      TComboBox;
        cmb_repetindo_minimo: TComboBox;
        cmb_repetindo_maximo: TComboBox;
        cmb_deixou_de_sair_minimo: TComboBox;
        cmb_deixou_de_sair_maximo: TComboBox;
    end;

var

    // Armazena cada controle.
    sgr_filtro_controle: array of TStringGrid;
    rd_filtro_controle:  array of TRadioGroup;

    sgr_filtro_cabecalho: array of string;

    // Define o nome dos campos ao montar o sql.
    sgr_filtro_sql: array of array of string;

    sgr_filtro_controle_info: array of R_Filtro_Controle;

    lista_filtro_binario:     T_lista_filtro_binario;
    mapa_filtro_binario_info: T_mapa_filtro_binario;

    lista_filtro_info: TLista_Filtro_Info;
    mapa_filtro_info: TMapa_Filtro_Info;

    lista_filtro_estatistica_por_concurso: TLista_Filtro_Info;
    mapa_filtro_estatistica_por_concurso: TMapa_Filtro_Info;

implementation

end.


