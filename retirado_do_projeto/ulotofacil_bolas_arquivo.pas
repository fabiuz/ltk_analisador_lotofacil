{
 Esta unit serve pra manipular arquivo binário da lotofacil, pra a tabela
 lotofacil_num.
 A tabela lotofacil_num é composta por:
 ltf_id                 -> número identificador de cada combinação.
 ltf_qt                 -> a quantidade de bolas na combinação,
                           valores válidos: 15, 16, 17, 18.
 b_1 até b_18           -> bolas que são daquela combinação, onde b_1 ser o campo
                           com a menor bola.
}

unit ulotofacil_bolas_arquivo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  // Registro que armazena o layout binário do arquivo.
{$PACKRECORDS 1}
  TLotofacil_bolas_layout_arquivo = record
    ltf_id: cardinal;
    ltf_qt: byte;
    bolas: array[1..18] of byte;
  end;

  // Indica o status do processamento.
  TLotofacil_bolas_status = procedure(ltf_id: cardinal; ltf_qt: byte;
    ltf_bolas: array of byte) of object;
  TLotofacil_bolas_erro = procedure(erro: string) of object;

{ TLotofacil_bolas }
type
  TLotofacil_bolas = class
  const
    ltf_qt_15_id_minimo = 1;
    ltf_qt_15_id_maximo = 32768760;
    ltf_qt_16_id_minimo = 32768761;

  private

    fstatus: TLotofacil_bolas_status;

  public
    property Status: TLotofacil_bolas_status read fstatus write fstatus;

    constructor Create;
  end;

implementation

{ TLotofacil_bolas }

constructor TLotofacil_bolas.Create;
begin

end;

end.

