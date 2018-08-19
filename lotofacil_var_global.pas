{
 Declara variáveis que serão usadas em mais de um módulo.
}

unit lotofacil_var_global;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids, ExtCtrls;


var

  // Armazena cada controle.
  sgr_filtro_controle : array of TStringGrid;
  rd_filtro_controle : array of TRadioGroup;


  sgr_filtro_cabecalho : array of string;

  // Define o nome dos campos ao montar o sql.
  sgr_filtro_sql : array of array of string;


implementation

end.

