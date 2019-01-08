unit lotofacil_matriz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl, Dialogs, Grids;

type
  TMatriz_Arquivo = record
    matriz_id: Integer;
    matriz_qt_de_bolas: Integer;
    matriz_qt_de_celula_1: Integer;
    matriz_zero_um: array[1..18, 1..25] of Byte;
  end;
  //TList_Matriz_Arquivo = specialize TFPGObjectList<TMatriz_Arquivo>;
  TMap_Matriz_Arquivo = specialize TFPGMap<Integer, TMatriz_Arquivo>;

  { TMatriz }

  TMatriz = class
    constructor create;
    private
      mapa_matriz_arquivo : TMap_Matriz_Arquivo;
  end;

  function matriz_gravar_no_arquivo(matriz_conteudo: TMatriz_Arquivo): boolean;

  procedure matriz_exibir_no_controle(sgr_controle: TStringGrid; matriz_conteudo: TMatriz_Arquivo);

  function matriz_obter_ultimo_id: Integer;

implementation

function matriz_gravar_no_arquivo(matriz_conteudo: TMatriz_Arquivo): boolean;
var
  matriz_arquivo: TFileStream;
begin

  If Not FileExists('.lotofacil_matriz.ltf_bin') then begin
    try
       matriz_arquivo := TFileStream.Create('.lotofacil_matriz.ltf_bin', fmCreate);
       FreeAndNil(matriz_arquivo);
    except
      On exc: Exception do begin
        MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbok], 0);
        Exit(False);
      end;
    end;
  end;

  matriz_conteudo.matriz_id:= matriz_obter_ultimo_id;
  Inc(matriz_conteudo.matriz_id);

  // Abre o arquivo pra gravar.
  try
     matriz_arquivo := TFileStream.Create('.lotofacil_matriz.ltf_bin', fmOpenWrite);
     matriz_arquivo.Seek(0, soEnd);
     if matriz_arquivo.Write(matriz_conteudo, Sizeof(matriz_conteudo)) = Sizeof(matriz_conteudo) then
     begin
       MessageDlg('', 'Arquivo gravado com sucesso!!!', mtInformation, [mbok], 0);
     end;
     FreeAndNil(matriz_arquivo);
     Exit(True);
  except
    On Exc: Exception do begin
        MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbok], 0);
        Exit(False);
    end;
  end;
end;

procedure matriz_exibir_no_controle(sgr_controle: TStringGrid;
  matriz_conteudo: TMatriz_Arquivo);
var
  matriz_qt_de_bolas, uA, largura_texto,
    matriz_qt_de_celula_1, uB: Integer;
  coluna_atual: TGridColumn;
  celula_valor_zero_um: Byte;
begin
  matriz_qt_de_bolas := matriz_conteudo.matriz_qt_de_bolas;
  matriz_qt_de_celula_1 := matriz_conteudo.matriz_qt_de_celula_1;

  sgr_controle.Columns.Clear;
  coluna_atual := sgr_controle.Columns.Add;
  coluna_atual.font.Name := 'IBM Plex Mono';
  coluna_atual.Font.Size := 10;
  coluna_atual.Alignment:= taCenter;
  coluna_atual.Title.Caption := '#';
  coluna_atual.Title.Font.Name := 'IBM Plex Mono';
  coluna_atual.Title.Font.Size := 10;
  coluna_atual.Title.Alignment:= taCenter;

  largura_texto := sgr_controle.Canvas.TextWidth('MMM');

  for uA := 1 to matriz_qt_de_bolas do begin
      coluna_atual := sgr_controle.Columns.Add;
      coluna_atual.font.Name := 'IBM Plex Mono';
      coluna_atual.Font.Size := 10;
      coluna_atual.Alignment:= taCenter;
      coluna_atual.Title.Caption := IntToStr(uA);
      coluna_atual.Title.Font.Name := 'IBM Plex Mono';
      coluna_atual.Title.Font.Size := 10;
      coluna_atual.Width := largura_texto;
  end;
  sgr_controle.FixedRows := 1;
  sgr_controle.RowCount := matriz_qt_de_celula_1 + 1;

  for uA := 1 to matriz_qt_de_celula_1 do begin
    for uB := 1 to matriz_qt_de_bolas do begin
      celula_valor_zero_um := matriz_conteudo.matriz_zero_um[uA, uB];
      sgr_controle.Cells[uB, uA] := IntToStr(celula_valor_zero_um);
      //matriz_atual_conteudo.matriz_zero_um[uA, uB] := celula_valor_zero_um;
    end;
  end;
  sgr_controle.Update;

end;

function matriz_obter_ultimo_id: Integer;
var
  matriz_arquivo: TFileStream;
  matriz_conteudo: TMatriz_Arquivo;
  matriz_id_ultimo: Integer;
begin
  matriz_id_ultimo := -1;
  If Not FileExists('.lotofacil_matriz.ltf_bin') then begin
    Exit(0);
  end;
  try
     matriz_arquivo := TFileStream.Create('.lotofacil_matriz.ltf_bin', fmOpenRead);
     matriz_arquivo.Seek(0, TSeekOrigin.soBeginning);

     while matriz_arquivo.Read(matriz_conteudo, sizeof(TMatriz_Arquivo)) = sizeof(TMatriz_Arquivo) do begin
       if matriz_conteudo.matriz_id > matriz_id_ultimo then begin
         matriz_id_ultimo := matriz_conteudo.matriz_id;
       end;
     end;
     FreeAndNil(matriz_arquivo);
     Exit(matriz_id_ultimo);
  except
    On Exc: Exception do begin
      MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbok], 0);
      Exit(-1);
    end;
  end;
end;

{ TMatriz }

constructor TMatriz.create;
begin

end;

end.

