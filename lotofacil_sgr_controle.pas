unit lotofacil_sgr_controle;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, Lcl, Grids, ExtCtrls, StdCtrls;

type



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
