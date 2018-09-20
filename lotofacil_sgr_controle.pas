unit lotofacil_sgr_controle;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Lcl, Grids, ExtCtrls, StdCtrls;

type
    // Neste record, iremos armazenar três controles pois eles estão interligados
    // na mesma estatística.
    R_Filtro_Binario_Controle = Record
        sql: string;                       // Sql a ser executado.
        sql_campos: string;                // Campos da query que utilizaremos.
        sql_order_by: string;
        sql_campo_id: string;              // Os ids dos filtros, sempre está na coluna 0, entretanto,
                                           // precisamos saber qual é o nome deste campo.
        sql_temporario: string;            // Gera um sql dinâmico pra ser usado posteriormente.
        sgr_controle_cabecalho : string;   // Nome dos cabeçalhos que corresponde aos campos sql.
        btn_controle : TButton;
        sgr_controle : TStringGrid;        // Controle que armazena todos os filtros.
        chk_controle: TCheckGroup;         // Controle que serve pra filtrar baseado na quantidade de bolas.
        rd_controle: TRadioGroup;          // Controle que serve pra marcar/desmarcar coluna 'sim' ou coluna 'nao'.
        chk_controle_excluir_bolas: string;           // Armazena as bolas selecionadas do controle 'chkcontrole',
                                           // se houver mais de 1 bola selecionada será interseparada
                                           // pelo caractere ',' (vírgula).
    end;
    PR_Filtro_Binario_Controle = ^R_Filtro_Binario_Controle;


    R_Filtro_Controle = record
        sql: string;
        sql_campos: string;
        sgr_controle_cabecalho: string;
        sgr_controle: TStringGrid;
        rd_controle: TRadioGroup;
        sql_campo_id: string;
    end;

    T_Filtro_Controle = class
        sql_campos: string;
        sql_controle_cabecalho: string;
        sgr_controle: TStringGrid;
        sql: string;
    end;

implementation

end.
