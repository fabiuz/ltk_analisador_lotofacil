unit uLotofacilSeletor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, StdCtrls,
  ExtCtrls, Graphics, strUtils;

type
  TLotofacil_Bolas_Selecionadas = array[1..25] of Integer;

  { TLotofacilSeletor }
  {$M+}

  TLotofacilSeletor = class(TFrame)
    Panel1 : TPanel;
    pn1a10 : TPanel;
    pn1a11 : TPanel;
    pn1a12 : TPanel;
    pn1a13 : TPanel;
    pn1a14 : TPanel;
    tg1 : TToggleBox;
    tg2 : TToggleBox;
    tg3 : TToggleBox;
    tg4 : TToggleBox;
    tg5 : TToggleBox;
    tg6 : TToggleBox;
    tg7 : TToggleBox;
    tg8 : TToggleBox;
    tg9 : TToggleBox;
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
    tg20 : TToggleBox;
    tg21 : TToggleBox;
    tg22 : TToggleBox;
    tg23 : TToggleBox;
    tg24 : TToggleBox;
    tg25 : TToggleBox;
    procedure tgChange(Sender : TObject);

  private
    fBotaoAtivadoCor: TColor;
    fBotaoDesativadoCor: TColor;

  published
    property BotaoAtivadoCor: TColor read FBotaoAtivadoCor write FBotaoAtivadoCor;
    property BotaoDesativadoCor: TColor read FBotaoDesativadoCor write FBotaoDesativadoCor;


  private
    { private declarations }
    lotofacil_bolas: array[1..25] of TToggleBox;
    lotofacil_bolas_selecionadas: TLotofacil_Bolas_Selecionadas;

    fQuantidadeMinimaSelecionada: Integer;
    fQuantidadeMaximaSelecionada: Integer;
    fTotal_de_bolas_selecionadas: Integer;

    function ObterQuantidadeMinimaSelecionada: Integer;
    procedure AlterarQuantidadeMinimaSelecionada(value: Integer);
  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;

    property bolas_selecionadas: TLotofacil_Bolas_Selecionadas read lotofacil_bolas_selecionadas;

  published
    property qtMinimaSelecionada: Integer
             read ObterQuantidadeMinimaSelecionada
             write AlterarQuantidadeMinimaSelecionada;

  end;

implementation

{$R *.lfm}

{ TLotofacilSeletor }

procedure TLotofacilSeletor.AlterarQuantidadeMinimaSelecionada(value : Integer);
begin
  if (value >= 1) and (value <= 25) then begin
    if (value <= fQuantidadeMaximaSelecionada) then begin
       fQuantidadeMinimaSelecionada := value;
    end;
  end;
end;

{
 Quando se seleciona um botão, ele altera de cor pra indicar que
 está selecionado.
 Quando a quantidade de bolas selecionadas for atingidas, todas
 as demais bolas não selecionadas são desativadas.
}
procedure TLotofacilSeletor.tgChange(Sender : TObject);
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

  // Se o usuário clicou no botão, devemos alterar a cor do botão
  // e em seguida, verificar se atingirmos a quantidade de bolas selecionadas,
  // se sim, devemos desativar todos os outros controles não selecionados.
  if botaoAtual.Checked = true then begin
     botaoAtual.Color := fBotaoAtivadoCor;
     botaoAtual.Font.Color := clWhite;

     inc(fTotal_de_bolas_selecionadas);

     // Se a quantidade de bolas foi atingida, devemos desativar
     // todos os demais controles não-selecionados.
     if fTotal_de_bolas_selecionadas = fQuantidadeMinimaSelecionada then begin
        for uA := 1 to 25 do begin
              lotofacil_bolas[uA].Enabled := lotofacil_bolas[uA].Checked;
        end;
     end;

  end else begin
      // Se a bola foi deselecionada, devemos, reativar todo os controles
      // que foram desativados.
      botaoAtual.Color := clDefault;

      // Aqui, iremos ativar as bolas que foram desativadas.
      for uA := 1 to 25 do begin
          if lotofacil_bolas[uA].Enabled = false then begin
               lotofacil_bolas[uA].Enabled := true;
          end;
      end;

      botaoAtual.Font.Color := clDefault;
      dec(fTotal_de_bolas_selecionadas);

  end;

  strStatusLotofacil := '';
  for uA:= 1 to 25 do begin
      if lotofacil_bolas[uA].Checked then begin
         lotofacil_bolas_selecionadas[uA] := 1;
      end else begin
         lotofacil_bolas_selecionadas[uA] := 0;
      end;
  end;
end;

function TLotofacilSeletor.ObterQuantidadeMinimaSelecionada : Integer;
begin
  if (fQuantidadeMinimaSelecionada >= 1) and
     (fQuantidadeMinimaSelecionada <= 25) then begin
     Exit(fQuantidadeMinimaSelecionada);

  end else begin
    fQuantidadeMinimaSelecionada := 15;
    Exit(fQuantidadeMinimaSelecionada);
  end;
end;

constructor TLotofacilSeletor.Create(TheOwner : TComponent);
begin
  lotofacil_bolas[1] := tg1;
  lotofacil_bolas[2] := tg2;
  lotofacil_bolas[3] := tg3;
  lotofacil_bolas[4] := tg4;
  lotofacil_bolas[5] := tg5;
  lotofacil_bolas[6] := tg6;
  lotofacil_bolas[7] := tg7;
  lotofacil_bolas[8] := tg8;
  lotofacil_bolas[9] := tg9;
  lotofacil_bolas[10] := tg10;
  lotofacil_bolas[11] := tg11;
  lotofacil_bolas[12] := tg12;
  lotofacil_bolas[13] := tg13;
  lotofacil_bolas[14] := tg14;
  lotofacil_bolas[15] := tg15;
  lotofacil_bolas[16] := tg16;
  lotofacil_bolas[17] := tg17;
  lotofacil_bolas[18] := tg18;
  lotofacil_bolas[19] := tg19;
  lotofacil_bolas[20] := tg20;
  lotofacil_bolas[21] := tg21;
  lotofacil_bolas[22] := tg22;
  lotofacil_bolas[23] := tg23;
  lotofacil_bolas[24] := tg24;
  lotofacil_bolas[25] := tg25;

  fQuantidadeMinimaSelecionada := 15;
  fQuantidadeMaximaSelecionada := 15;
  fBotaoAtivadoCor := clGreen;
  fTotal_de_bolas_selecionadas := 0;
  ;



end;

end.

