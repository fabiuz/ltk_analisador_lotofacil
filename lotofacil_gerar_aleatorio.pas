unit lotofacil_gerar_aleatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, Grids, Dialogs;

type
  R_Gerador_Aleatorio_Opcoes = record
    concurso: Integer;
    qt_de_combinacoes: Integer;
    gerador_controle: TStringGrid;
    novos_escolhidos: array[0..10] of Boolean;
  end;

  procedure gerar_combinacoes_aleatorias(sql_conexao: TZConnection; gerador_opcoes: R_Gerador_Aleatorio_Opcoes);
  procedure gerar_combinacoes_aleatorias_2(sql_conexao: TZConnection; gerador_opcoes: R_Gerador_Aleatorio_Opcoes);
  procedure gerar_combinacoes_aleatorias_3(sql_conexao: TZConnection; gerador_opcoes: R_Gerador_Aleatorio_Opcoes);

implementation
uses fgl,
  lotofacil_concursos;

procedure gerar_combinacoes_aleatorias(sql_conexao: TZConnection;
  gerador_opcoes: R_Gerador_Aleatorio_Opcoes);
type
  TList_Byte = specialize TFPGList<Byte>;
var
  lotofacil_bolas: array[0..25] of Byte;
  bolas_sorteadas: TList_Byte;
  bolas_nao_sorteadas : TList_Byte;
  concurso, bola_atual, qt_de_combinacoes, indice_cmb_geradas, uB, uC,
    uA, linha_sgr_controle, coluna_sgr_controle, indice_lista_de_novos,
    indice_final_lista_de_novos, indice_atual_lista_de_novos,
    indice_combinacao_gerada: Integer;
  bolas_do_concurso: TArrayInt;

  combinacoes_geradas : Array of Array of Byte;
  indice_selecionado, indice_aleatorio: Byte;
  sgr_controle: TStringGrid;
  coluna_atual: TGridColumn;

  // Lista de novos, é uma lista de bolas, que não está no concurso
  // que o usuário escolheu.
  lista_de_novos : TList_Byte;

  // Lista de repetidos, é uma lista de bolas, que está no concurso
  // que o usuário escolheu.
  lista_de_repetidos: TList_Byte;

  // Há um arranjo com 10 ítens, cada célula deste arranjo armazena
  // uma lista de bolas.
  // Haverá dois tipos de lista, uma lista de origem e uma lista de destino.
  // Na lotofacil, podemos ter de 0 a 10 bolas novas, então, haverá um vetor
  // com 10 posições, cada posição armazenará uma lista com 10 bolas.
  // Cada posição do vetor, corresponde ao número de bolas que devemos capturar
  // e também a posição indica a quantidade de bolas que o usuário
  // selecionou, então, se o usuário selecionou '5' bolas novas, iremos
  // capturar aleatoriamente 5 bolas da lista que está no vetor 5:
  // lista_de_novos_origem[5].
  // Todas as bolas selecionadas da lista na posição escolhida será
  // movidas pra a lista de destino.
  // Toda vez, que a lista a qual formos selecionar estiver faltando alguma bola
  // iremos capturar aleatoriamente as bolas que faltam da lista de destino.
  lista_de_novos_origem: Array[0..10] of TList_Byte;
  lista_de_novos_destino: Array[0..10] of TList_Byte;

  lista_de_repetidos_origem: Array[0..10] of TList_Byte;
  lista_de_repetidos_destino: Array[0..10] of TList_Byte;

  // Aqui, iremos armazenar cada quantidade de novos
  // escolhidos pelo o usuário
  lista_de_novos_escolhidos: TList_Byte;
  qt_bolas_por_combinacao: Byte;
  qt_bolas_novas: Byte;
  bola_sorteada, qt_bolas_repetidas: Byte;

  lista_novo_origem_atual, lista_novo_destino_atual,
  lista_repetido_origem_atual, lista_repetido_destino_atual: TList_Byte;
  indice_escolhido: Byte;

begin
  // Vamos obter as bolas do concurso escolhido.
  concurso := gerador_opcoes.concurso;
  if obter_bolas_do_concurso(sql_conexao, concurso, bolas_do_concurso) = false then begin
    Exit;
  end;

  // Vamos criar a lista que armazenará as bolas que saiu e as bolas que não saiu.
  bolas_sorteadas := TList_Byte.Create;
  bolas_nao_sorteadas := TList_Byte.Create;

  bolas_sorteadas.Clear;
  bolas_nao_sorteadas.Clear;

  // O arranjo bolas_do_concurso é baseado em 1, e tem 15 bolas retornadas
  // pela função.
  // Vamos percorrer e inserir as bolas no arranjo
  // Se a bola está no concurso, o arranjo 'lotofacil_bolas' terá o valor '1'.
  FillByte(lotofacil_bolas, 26 * sizeof(Byte), 0);
  for uA := 1 to 15 do begin
    bola_atual := bolas_do_concurso[uA];
    lotofacil_bolas[bola_atual] := 1;
  end;

  // Em seguida, iremos separar em duas listas, as bolas que foram
  // sorteadas e as bolas que não foram sorteadas.
  for uA := 1 to 25 do begin
    if lotofacil_bolas[uA] = 1 then begin
      bolas_sorteadas.Add(uA);
    end else begin
      bolas_nao_sorteadas.Add(uA);
    end;
  end;

  // O usuário pode escolher combinações que tenha de 0 a 10 bolas
  // novas, por exemplo, se ele escolher ter combinações com
  // 5, 6, e 7 bolas novas, então, haverá combinações com 5, 6 e 7
  // combinações
  lista_de_novos_escolhidos := TList_Byte.Create;
  lista_de_novos_escolhidos.Clear;
  for uA := 0 to High(gerador_opcoes.novos_escolhidos) do begin
    if gerador_opcoes.novos_escolhidos[uA] then begin
      lista_de_novos_escolhidos.Add(uA);
    end;
  end;

  // Agora, vamos iniciar a lista das bolas das combinações
  // de quantidade que foram escolhidas pelo o usuário.
  for uA := 0 to Pred(lista_de_novos_escolhidos.Count) do begin
    indice_escolhido := lista_de_novos_escolhidos.Items[uA];
    lista_de_novos_origem[indice_escolhido] := TList_Byte.Create;
    lista_de_novos_destino[indice_escolhido] := TList_Byte.Create;
    lista_de_repetidos_origem[indice_escolhido] := TList_Byte.Create;
    lista_de_repetidos_destino[indice_escolhido] := TList_Byte.Create;

    // Vamos alimentar as listas de origem com as bolas correspondentes.
    // A lista 'bolas_sorteadas', corresponderá a lista de bolas repetidas, e,
    // a lista 'bolas_nao_sorteadas', corresponderá a lista de bolas novas.
    for uB := 0 to Pred(bolas_nao_sorteadas.Count) do begin
      lista_de_novos_origem[indice_escolhido].Add(bolas_nao_sorteadas.Items[uB]);
    end;

    for uB := 0 to Pred(bolas_sorteadas.Count) do begin
      lista_de_repetidos_origem[indice_escolhido].Add(bolas_sorteadas.Items[uB]);
    end;
  end;

  // Vamos obter a quantidade de combinações escolhidas pelo usuário e
  // também alocar memória pra o arranjo bidimensional.
  qt_de_combinacoes:=gerador_opcoes.qt_de_combinacoes;

  // Haverá 1 posição a mais pois, o arranjo é baseado em zero.
  SetLength(combinacoes_geradas, qt_de_combinacoes + 1, 26);

  // Armazena em qual posição estamos no arranjo bidimensional.
  indice_combinacao_gerada := -1;

  // Serve pra percorrer cada valor de combinações escolhidas.
  indice_atual_lista_de_novos := 0;
  indice_final_lista_de_novos := Pred(lista_de_novos_escolhidos.Count);

  for uA := 1 to qt_de_combinacoes do
  begin
    qt_bolas_novas := lista_de_novos_escolhidos.Items[indice_atual_lista_de_novos];
    qt_bolas_repetidas := 15 - qt_bolas_novas;

    lista_novo_origem_atual := lista_de_novos_origem[qt_bolas_novas];
    lista_novo_destino_atual := lista_de_novos_destino[qt_bolas_novas];
    lista_repetido_origem_atual := lista_de_repetidos_origem[qt_bolas_novas];
    lista_repetido_destino_atual := lista_de_repetidos_destino[qt_bolas_novas];

    // Enquanto não houve a quantidade de bolas suficiente, iremos mover as bolas
    // da lista de destino pra a lista de origem.
    while lista_de_novos_origem[qt_bolas_novas].Count < qt_bolas_novas do begin
      indice_aleatorio := Random(lista_novo_destino_atual.Count-1);
      bola_sorteada := lista_novo_destino_atual.Items[indice_aleatorio];
      lista_novo_destino_atual.Delete(indice_aleatorio);
      lista_novo_origem_atual.Add(bola_sorteada);
    end;

    // Enquanto a lista de origem não tiver as bolas suficiente, iremos mover
    // as bolas
    while lista_de_repetidos_origem[qt_bolas_novas].Count < qt_bolas_repetidas do begin
      indice_aleatorio := Random(lista_repetido_destino_atual.Count-1);
      bola_sorteada := lista_repetido_destino_atual.Items[indice_aleatorio];
      lista_repetido_destino_atual.Delete(indice_aleatorio);
      lista_repetido_origem_atual.Add(bola_sorteada);
    end;

    // Indica onde a próxima combinação será gerada no arranjo.
    Inc(indice_combinacao_gerada);

    // Agora, iremos sortear a quantidade de bolas escolhido pelo usuário da lista
    // de bolas novas e depois da lista de bolas repetidas.
    // As bolas escolhidas da lista de origem serão movidas pra a lista de destino.
    for uB := 1 to qt_bolas_novas do begin
      indice_aleatorio := Random(lista_novo_origem_atual.Count-1);
      bola_sorteada := lista_novo_origem_atual.Items[indice_aleatorio];
      lista_novo_origem_atual.Delete(indice_aleatorio);
      lista_novo_destino_atual.Add(bola_sorteada);
      combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
    end;

    for uB := 1 to qt_bolas_repetidas do begin
      indice_aleatorio := Random(lista_repetido_origem_atual.Count - 1);
      bola_sorteada := lista_repetido_origem_atual.Items[indice_aleatorio];
      lista_repetido_origem_atual.Delete(indice_aleatorio);
      lista_repetido_destino_atual.Add(bola_sorteada);
      combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
    end;

    // Vamos capturar a próxima quantidade de bolas selecionada pelo usuário.
    Inc(indice_atual_lista_de_novos);
    if indice_atual_lista_de_novos > indice_final_lista_de_novos then begin
      indice_atual_lista_de_novos:=0
    end;
  end;

  // Agora, vamos gerar as combinações no controle TStringGrid.

  sgr_controle := gerador_opcoes.gerador_controle;
  sgr_controle.Clear;
  sgr_controle.RowCount:= qt_de_combinacoes + 1;
  sgr_controle.FixedRows:=1;
  sgr_controle.FixedCols:=0;

  // Cabeçalho.
  sgr_controle.Columns.Clear;
  sgr_controle.BeginUpdate;
  for uA := 0 to 25 do begin
      coluna_atual := sgr_controle.Columns.Add;;
      coluna_atual.Alignment:=taCenter;
      if uA = 0 then begin
        coluna_atual.Title.Caption:='#';
      end else begin
        coluna_atual.Title.Caption := 'B' + IntToStr(uA);
      end;
  end;

  // Agora, vamos gerar as combinações:
  linha_sgr_controle := 1;
  for uA := 0 to indice_combinacao_gerada do begin

    //Write('Comb:', uA+1);
    sgr_controle.Cells[0, linha_sgr_controle] := IntToStr(uA+1);

    coluna_sgr_controle := 1;
    for uB := 1 to 25 do begin
      if combinacoes_geradas[uA, uB] = 1 then begin
        Write(',', uB);
        sgr_controle.Cells[coluna_sgr_controle, linha_sgr_controle] := IntToStr(uB);
        Inc(coluna_sgr_controle);
      end;
    end;
    Writeln('');
    Inc(linha_sgr_controle);
  end;
  sgr_controle.AutoSizeColumns;
  sgr_controle.EndUpdate(true);


  Exit;










  // Será gerada combinações de 15 bolas seguindo os passos abaixo:
  // [Passo 1] : Seleciona todas as bolas da lista 'bolas_nao_sorteadas';
  // [Passo 2] : Seleciona aleatoriamente 5 bolas da lista 'bolas_sorteadas';
  // [Passo 3] : Exclui as bolas selecionadas no passo 2.
  // [Passo 4] : Todas as bolas do passo 1 e todas as bolas do passo 2, tem-se
  //             uma combinação de 15 bolas geradas.
  // [Passo 4] : Enquanto houver bolas na lista 'bolas_sorteadas', vá pra o passo 1.
  // [Passo 5] : Todas as bolas selecionadas da última combinação no passo 4, será
  //             a nova lista da variável 'bolas_sorteadas'.
  // [Passo 6] : Exclui todas as bolas da lista 'bolas_nao_sorteadas'
  // [Passo 7] : Gera uma lista de 'bolas_nao_sorteadas' que consiste em todas as
  //             bolas da lotofacil não sorteadas no passo 5.
  // [Passo 8] : Se houver mais combinações a serem geradas vá pra o passo 1, se não
  //             vá pra o passo 9.
  // [Passo 9] : Conclui-se a geração de 3 ou mais combinações baseadas em uma combinação
  //             específica.

  // Vamos criar um arranjo bidimensional pra armazenar as combinações geradas.
  qt_de_combinacoes := gerador_opcoes.qt_de_combinacoes;
  //SetLength(combinacoes_geradas, (qt_de_combinacoes + 1) * 2, 26);
  SetLength(combinacoes_geradas, (qt_de_combinacoes + 1), 26);
  indice_cmb_geradas := -1;

  // Vamos gerar todas as combinações.
  for uA := 1 to qt_de_combinacoes do begin

    // Se não há bolas sorteadas mais, pega as bolas da última combinação.
    if bolas_sorteadas.Count <= 0 then begin
      bolas_sorteadas.Clear;
      bolas_nao_sorteadas.Clear;
      for uB := 1 to 25 do begin
        //if combinacoes_geradas[indice_cmb_geradas, uB] = 1 then begin
        if lotofacil_bolas[uB] = 1 then begin
          bolas_sorteadas.Add(uB);
        end else begin
          bolas_nao_sorteadas.Add(uB);
        end;
      end;

      // Verifica se realmente, há 15 bolas na lista de bolas_sorteadas
      // e 10 bolas na lista de bolas não sorteadas.
      if bolas_sorteadas.Count <> 15 then begin
      end;
    end;

    // Vamos criar a nova combinação.
    Inc(indice_cmb_geradas);

    // Preenche o arranjo com bola da lista 'bolas_nao_sorteadas'.
    //    Inc(indice_cmb_geradas);
    for uB := 0 to Pred(bolas_nao_sorteadas.Count) do begin
      bola_atual := bolas_nao_sorteadas.Items[uB];
      combinacoes_geradas[indice_cmb_geradas, bola_atual] := 1;
    end;

    // Preenche aleatoriamente com 5 bolas da lista 'bolas_sorteadas'.
    // A cada bola selecionada da lista 'bolas_sorteadas', iremos
    // mover pro arranjo que armazenas as bolas que farão parte
    // da nova combinação.
    for uC := 1 to 5 do begin
      indice_selecionado := Random(bolas_sorteadas.Count-1);
      bola_atual := bolas_sorteadas.Items[indice_selecionado];
      bolas_sorteadas.Delete(indice_selecionado);
      combinacoes_geradas[indice_cmb_geradas, bola_atual] := 1;
    end;

    // Obter as combinações invertidas.
    //for uC := 1 to 25 do begin
    //  combinacoes_geradas[indice_cmb_geradas + 1, 26 - uC] :=
    //                                         combinacoes_geradas[indice_cmb_geradas, uC];
    //end;
    //Inc(indice_cmb_geradas);
  end;

  sgr_controle := gerador_opcoes.gerador_controle;
  sgr_controle.Clear;
  sgr_controle.RowCount:= qt_de_combinacoes * 2 + 1;
  sgr_controle.FixedRows:=1;
  sgr_controle.FixedCols:=0;

  // Cabeçalho.
  sgr_controle.Columns.Clear;
  sgr_controle.BeginUpdate;
  for uA := 0 to 25 do begin
      coluna_atual := sgr_controle.Columns.Add;;
      coluna_atual.Alignment:=taCenter;
      if uA = 0 then begin
        coluna_atual.Title.Caption:='#';
      end else begin
        coluna_atual.Title.Caption := 'B' + IntToStr(uA);
      end;
  end;

  // Agora, vamos gerar as combinações:
  linha_sgr_controle := 1;
  for uA := 0 to indice_cmb_geradas do begin

    Write('Comb:', uA+1);
    sgr_controle.Cells[0, linha_sgr_controle] := IntToStr(uA+1);

    coluna_sgr_controle := 1;
    for uB := 1 to 25 do begin
      if combinacoes_geradas[uA, uB] = 1 then begin
        Write(',', uB);
        sgr_controle.Cells[coluna_sgr_controle, linha_sgr_controle] := IntToStr(uB);
        Inc(coluna_sgr_controle);
      end;
    end;
    Writeln('');
    Inc(linha_sgr_controle);
  end;
  sgr_controle.AutoSizeColumns;
  sgr_controle.EndUpdate(true);

end;

{
 Obtém as bolas novas e as bolas repetidas relativo ao um concurso, em seguida,
 gera combinações tendo sempre 10 bolas novas x 5 repetidas, a cada 3 combinações,
 todas as bolas que são repetidas deverá sair.
 Quando todas as bolas repetidas saíram, pega-se a próxima combinação que
 foi gerada e gera também combinações de 10 bolas novas x 5 repetidas.
 E assim por diante.
}
procedure gerar_combinacoes_aleatorias_3(sql_conexao: TZConnection;
  gerador_opcoes: R_Gerador_Aleatorio_Opcoes);
type
  TList_Byte = specialize TFPGList<Byte>;
var
  lotofacil_bolas: array[0..25] of Byte;
  bolas_sorteadas: TList_Byte;
  bolas_nao_sorteadas : TList_Byte;
  concurso, bola_atual, qt_de_combinacoes, indice_cmb_geradas, uB, uC,
    uA, linha_sgr_controle, coluna_sgr_controle, indice_lista_de_novos,
    indice_final_lista_de_novos, indice_atual_lista_de_novos,
    indice_combinacao_gerada, indice_combinacoes,
    indice_combinacoes_geradas, indice_combinacao_atual,
    indice_combinacao_proxima: Integer;
  bolas_do_concurso: TArrayInt;

  combinacoes_geradas : Array of Array of Byte;
  indice_selecionado, indice_aleatorio: Byte;
  sgr_controle: TStringGrid;
  coluna_atual: TGridColumn;

  // Lista de novos, é uma lista de bolas, que não está no concurso
  // que o usuário escolheu.
  lista_de_novos_origem : TList_Byte;
  lista_de_novos_destino : TList_Byte;

  // Lista de repetidos, é uma lista de bolas, que está no concurso
  // que o usuário escolheu.
  lista_de_repetidos_origem: TList_Byte;
  lista_de_repetidos_destino: TList_Byte;

  // Há um arranjo com 10 ítens, cada célula deste arranjo armazena
  // uma lista de bolas.
  // Haverá dois tipos de lista, uma lista de origem e uma lista de destino.
  // Na lotofacil, podemos ter de 0 a 10 bolas novas, então, haverá um vetor
  // com 10 posições, cada posição armazenará uma lista com 10 bolas.
  // Cada posição do vetor, corresponde ao número de bolas que devemos capturar
  // e também a posição indica a quantidade de bolas que o usuário
  // selecionou, então, se o usuário selecionou '5' bolas novas, iremos
  // capturar aleatoriamente 5 bolas da lista que está no vetor 5:
  // lista_de_novos_origem[5].
  // Todas as bolas selecionadas da lista na posição escolhida será
  // movidas pra a lista de destino.
  // Toda vez, que a lista a qual formos selecionar estiver faltando alguma bola
  // iremos capturar aleatoriamente as bolas que faltam da lista de destino.
  //lista_de_novos_origem: Array[0..10] of TList_Byte;
  //lista_de_novos_destino: Array[0..10] of TList_Byte;

  //lista_de_repetidos_origem: Array[0..10] of TList_Byte;
  //lista_de_repetidos_destino: Array[0..10] of TList_Byte;

  // Aqui, iremos armazenar cada quantidade de novos
  // escolhidos pelo o usuário
  lista_de_novos_escolhidos: TList_Byte;
  qt_bolas_por_combinacao: Byte;
  qt_bolas_novas: Byte;
  bola_sorteada, qt_bolas_repetidas: Byte;

  //lista_novo_origem_atual, lista_novo_destino_atual,
  //lista_repetido_origem_atual, lista_repetido_destino_atual: TList_Byte;
  indice_escolhido: Byte;

begin
  // Vamos obter as bolas do concurso escolhido.
  concurso := gerador_opcoes.concurso;
  if obter_bolas_do_concurso(sql_conexao, concurso, bolas_do_concurso) = false then begin
    Exit;
  end;

  // Vamos criar a lista que armazenará as bolas que saiu e as bolas que não saiu.
  //bolas_sorteadas := TList_Byte.Create;
  //bolas_nao_sorteadas := TList_Byte.Create;

  //bolas_sorteadas.Clear;
  //bolas_nao_sorteadas.Clear;

  // O arranjo bolas_do_concurso é baseado em 1, e tem 15 bolas retornadas
  // pela função.
  // Vamos percorrer e inserir as bolas no arranjo
  // Se a bola está no concurso, o arranjo 'lotofacil_bolas' terá o valor '1'.
  FillByte(lotofacil_bolas, 26 * sizeof(Byte), 0);
  for uA := 1 to 15 do begin
    bola_atual := bolas_do_concurso[uA];
    lotofacil_bolas[bola_atual] := 1;
  end;

  lista_de_repetidos_origem := TList_Byte.Create;
  lista_de_repetidos_destino := TList_Byte.Create;

  lista_de_novos_origem := TList_Byte.Create;
  lista_de_novos_destino := TList_Byte.Create;

  lista_de_repetidos_origem.Clear;
  lista_de_repetidos_destino.Clear;

  lista_de_novos_origem.Clear;
  lista_de_novos_destino.Clear;

  // Iremos separar em duas listas, uma lista de bolas sorteadas
  // e outra lista de bolas não-sorteadas.
  // As bolas da lista sorteada tornaram-se as bolas da lista
  // de repetidas e as bolas da lista de bolas não-sorteadas
  // tornaram-se as bolas da lista de bolas novas.
  for uA := 1 to 25 do begin
    if lotofacil_bolas[uA] = 1 then begin
      //bolas_sorteadas.Add(uA);
      lista_de_repetidos_origem.Add(uA);
    end else begin
      //bolas_nao_sorteadas.Add(uA);
      lista_de_novos_origem.Add(uA);
    end;
  end;

  // Vamos obter a quantidade de combinações escolhidas pelo usuário e
  // também alocar memória pra o arranjo bidimensional.
  qt_de_combinacoes:=gerador_opcoes.qt_de_combinacoes;

  // Haverá 1 posição a mais pois, o arranjo é baseado em zero.
  SetLength(combinacoes_geradas, qt_de_combinacoes + 1, 26);

  indice_combinacao_atual := 0;

  // Indica a próxima combinação a ser capturada as bolas.
  indice_combinacao_proxima := 0;

  for uA := 1 to qt_de_combinacoes do begin

      // A cada geração de uma nova combinação 5 bolas repetidas da
      // lista será escolhida, quando não houver mais bolas, devemos
      // capturar as bolas novas e repetidas da próxima combinação.
      if lista_de_repetidos_origem.Count = 0 then begin
        lista_de_novos_origem.Clear;
        Inc(indice_combinacao_proxima);

        // Marca as bolas que saíram na combinação.
        for uB := 1 to 25 do begin
          if combinacoes_geradas[indice_combinacao_proxima, uB] = 1 then begin
            lista_de_repetidos_origem.Add(uB);
          end else begin
            lista_de_novos_origem.Add(uB);
          end;
        end;

        // Deve haver 10 bolas novas x 15 repetidas.
        if lista_de_repetidos_origem.Count <> 15 then begin
           MessageDlg('', 'Erro, qt de bolas repetidas é diferente de 15: ' +
                          IntToStr(lista_de_repetidos_origem.Count), mtError,
                          [mbok], 0);


           Exit;
        end;
      end;

      // Há sempre 10 bolas novas, iremos selecionar tais bolas.
      for uB := 0 to Pred(lista_de_novos_origem.Count) do begin
        bola_atual := lista_de_novos_origem.Items[uB];
        combinacoes_geradas[indice_combinacao_atual, bola_atual] := 1;
      end;

      // Agora, iremos selecionar 5 bolas repetidas, aleatoriamente.
      // Não precisamos verificar se há 5 bolas, pois, sempre haverá.
      // Após selecionar cada bola, devemos retirá-la da lista, pois,
      // não queremos bolas repetidas.
      for uB := 1 to 5 do begin
        indice_aleatorio := Random(lista_de_repetidos_origem.Count-1);
        bola_atual := lista_de_repetidos_origem.Items[indice_aleatorio];
        lista_de_repetidos_origem.Delete(indice_aleatorio);
        combinacoes_geradas[indice_combinacao_atual, bola_atual] := 1;
      end;

      Inc(indice_combinacao_atual);
    end;


  // Agora, vamos iniciar a lista das bolas das combinações
  // de quantidade que foram escolhidas pelo o usuário.
  //for uA := 0 to Pred(lista_de_novos_escolhidos.Count) do begin
  //  indice_escolhido := lista_de_novos_escolhidos.Items[uA];
  //  lista_de_novos_origem[indice_escolhido] := TList_Byte.Create;
  //  lista_de_novos_destino[indice_escolhido] := TList_Byte.Create;
  //  lista_de_repetidos_origem[indice_escolhido] := TList_Byte.Create;
  //  lista_de_repetidos_destino[indice_escolhido] := TList_Byte.Create;
  //
  //  // Vamos alimentar as listas de origem com as bolas correspondentes.
  //  // A lista 'bolas_sorteadas', corresponderá a lista de bolas repetidas, e,
  //  // a lista 'bolas_nao_sorteadas', corresponderá a lista de bolas novas.
  //  for uB := 0 to Pred(bolas_nao_sorteadas.Count) do begin
  //    lista_de_novos_origem[indice_escolhido].Add(bolas_nao_sorteadas.Items[uB]);
  //  end;
  //
  //  for uB := 0 to Pred(bolas_sorteadas.Count) do begin
  //    lista_de_repetidos_origem[indice_escolhido].Add(bolas_sorteadas.Items[uB]);
  //  end;
  //end;
  //
  // Vamos obter a quantidade de combinações escolhidas pelo usuário e
  // também alocar memória pra o arranjo bidimensional.
  //qt_de_combinacoes:=gerador_opcoes.qt_de_combinacoes;

  // Haverá 1 posição a mais pois, o arranjo é baseado em zero.
  ///SetLength(combinacoes_geradas, qt_de_combinacoes + 1, 26);

  // Armazena em qual posição estamos no arranjo bidimensional.
  //indice_combinacao_gerada := -1;

  // Serve pra percorrer cada valor de combinações escolhidas.
  //indice_atual_lista_de_novos := 0;
  //indice_final_lista_de_novos := Pred(lista_de_novos_escolhidos.Count);

  //for uA := 1 to qt_de_combinacoes do
  //begin
  //  qt_bolas_novas := lista_de_novos_escolhidos.Items[indice_atual_lista_de_novos];
  //  qt_bolas_repetidas := 15 - qt_bolas_novas;
  //
  //  lista_novo_origem_atual := lista_de_novos_origem[qt_bolas_novas];
  //  lista_novo_destino_atual := lista_de_novos_destino[qt_bolas_novas];
  //  lista_repetido_origem_atual := lista_de_repetidos_origem[qt_bolas_novas];
  //  lista_repetido_destino_atual := lista_de_repetidos_destino[qt_bolas_novas];
  //
  //  // Enquanto não houve a quantidade de bolas suficiente, iremos mover as bolas
  //  // da lista de destino pra a lista de origem.
  //  while lista_de_novos_origem[qt_bolas_novas].Count < qt_bolas_novas do begin
  //    indice_aleatorio := Random(lista_novo_destino_atual.Count-1);
  //    bola_sorteada := lista_novo_destino_atual.Items[indice_aleatorio];
  //    lista_novo_destino_atual.Delete(indice_aleatorio);
  //    lista_novo_origem_atual.Add(bola_sorteada);
  //  end;
  //
  //  // Enquanto a lista de origem não tiver as bolas suficiente, iremos mover
  //  // as bolas
  //  while lista_de_repetidos_origem[qt_bolas_novas].Count < qt_bolas_repetidas do begin
  //    indice_aleatorio := Random(lista_repetido_destino_atual.Count-1);
  //    bola_sorteada := lista_repetido_destino_atual.Items[indice_aleatorio];
  //    lista_repetido_destino_atual.Delete(indice_aleatorio);
  //    lista_repetido_origem_atual.Add(bola_sorteada);
  //  end;
  //
  //  // Indica onde a próxima combinação será gerada no arranjo.
  //  Inc(indice_combinacao_gerada);
  //
  //  // Agora, iremos sortear a quantidade de bolas escolhido pelo usuário da lista
  //  // de bolas novas e depois da lista de bolas repetidas.
  //  // As bolas escolhidas da lista de origem serão movidas pra a lista de destino.
  //  for uB := 1 to qt_bolas_novas do begin
  //    indice_aleatorio := Random(lista_novo_origem_atual.Count-1);
  //    bola_sorteada := lista_novo_origem_atual.Items[indice_aleatorio];
  //    lista_novo_origem_atual.Delete(indice_aleatorio);
  //    lista_novo_destino_atual.Add(bola_sorteada);
  //    combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
  //  end;
  //
  //  for uB := 1 to qt_bolas_repetidas do begin
  //    indice_aleatorio := Random(lista_repetido_origem_atual.Count - 1);
  //    bola_sorteada := lista_repetido_origem_atual.Items[indice_aleatorio];
  //    lista_repetido_origem_atual.Delete(indice_aleatorio);
  //    lista_repetido_destino_atual.Add(bola_sorteada);
  //    combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
  //  end;
  //
  //  // Vamos capturar a próxima quantidade de bolas selecionada pelo usuário.
  //  Inc(indice_atual_lista_de_novos);
  //  if indice_atual_lista_de_novos > indice_final_lista_de_novos then begin
  //    indice_atual_lista_de_novos:=0
  //  end;
  //end;

  // Agora, vamos gerar as combinações no controle TStringGrid.

  sgr_controle := gerador_opcoes.gerador_controle;
  sgr_controle.Clear;
  sgr_controle.RowCount:= qt_de_combinacoes + 1;
  sgr_controle.FixedRows:=1;
  sgr_controle.FixedCols:=0;

  // Cabeçalho.
  sgr_controle.Columns.Clear;
  sgr_controle.BeginUpdate;
  for uA := 0 to 25 do begin
      coluna_atual := sgr_controle.Columns.Add;;
      coluna_atual.Alignment:=taCenter;
      if uA = 0 then begin
        coluna_atual.Title.Caption:='#';
      end else begin
        coluna_atual.Title.Caption := 'B' + IntToStr(uA);
      end;
  end;

  // Agora, vamos gerar as combinações:
  linha_sgr_controle := 1;
  for uA := 0 to Pred(qt_de_combinacoes) do begin

    //Write('Comb:', uA+1);
    sgr_controle.Cells[0, linha_sgr_controle] := IntToStr(uA+1);

    coluna_sgr_controle := 1;
    for uB := 1 to 25 do begin
      if combinacoes_geradas[uA, uB] = 1 then begin
        Write(',', uB);
        sgr_controle.Cells[coluna_sgr_controle, linha_sgr_controle] := IntToStr(uB);
        Inc(coluna_sgr_controle);
      end;
    end;
    Writeln('');
    Inc(linha_sgr_controle);
  end;
  sgr_controle.AutoSizeColumns;
  sgr_controle.EndUpdate(true);


  Exit;










  // Será gerada combinações de 15 bolas seguindo os passos abaixo:
  // [Passo 1] : Seleciona todas as bolas da lista 'bolas_nao_sorteadas';
  // [Passo 2] : Seleciona aleatoriamente 5 bolas da lista 'bolas_sorteadas';
  // [Passo 3] : Exclui as bolas selecionadas no passo 2.
  // [Passo 4] : Todas as bolas do passo 1 e todas as bolas do passo 2, tem-se
  //             uma combinação de 15 bolas geradas.
  // [Passo 4] : Enquanto houver bolas na lista 'bolas_sorteadas', vá pra o passo 1.
  // [Passo 5] : Todas as bolas selecionadas da última combinação no passo 4, será
  //             a nova lista da variável 'bolas_sorteadas'.
  // [Passo 6] : Exclui todas as bolas da lista 'bolas_nao_sorteadas'
  // [Passo 7] : Gera uma lista de 'bolas_nao_sorteadas' que consiste em todas as
  //             bolas da lotofacil não sorteadas no passo 5.
  // [Passo 8] : Se houver mais combinações a serem geradas vá pra o passo 1, se não
  //             vá pra o passo 9.
  // [Passo 9] : Conclui-se a geração de 3 ou mais combinações baseadas em uma combinação
  //             específica.

  // Vamos criar um arranjo bidimensional pra armazenar as combinações geradas.
  qt_de_combinacoes := gerador_opcoes.qt_de_combinacoes;
  //SetLength(combinacoes_geradas, (qt_de_combinacoes + 1) * 2, 26);
  SetLength(combinacoes_geradas, (qt_de_combinacoes + 1), 26);
  indice_cmb_geradas := -1;

  // Vamos gerar todas as combinações.
  for uA := 1 to qt_de_combinacoes do begin

    // Se não há bolas sorteadas mais, pega as bolas da última combinação.
    if bolas_sorteadas.Count <= 0 then begin
      bolas_sorteadas.Clear;
      bolas_nao_sorteadas.Clear;
      for uB := 1 to 25 do begin
        //if combinacoes_geradas[indice_cmb_geradas, uB] = 1 then begin
        if lotofacil_bolas[uB] = 1 then begin
          bolas_sorteadas.Add(uB);
        end else begin
          bolas_nao_sorteadas.Add(uB);
        end;
      end;

      // Verifica se realmente, há 15 bolas na lista de bolas_sorteadas
      // e 10 bolas na lista de bolas não sorteadas.
      if bolas_sorteadas.Count <> 15 then begin
      end;
    end;

    // Vamos criar a nova combinação.
    Inc(indice_cmb_geradas);

    // Preenche o arranjo com bola da lista 'bolas_nao_sorteadas'.
    //    Inc(indice_cmb_geradas);
    for uB := 0 to Pred(bolas_nao_sorteadas.Count) do begin
      bola_atual := bolas_nao_sorteadas.Items[uB];
      combinacoes_geradas[indice_cmb_geradas, bola_atual] := 1;
    end;

    // Preenche aleatoriamente com 5 bolas da lista 'bolas_sorteadas'.
    // A cada bola selecionada da lista 'bolas_sorteadas', iremos
    // mover pro arranjo que armazenas as bolas que farão parte
    // da nova combinação.
    for uC := 1 to 5 do begin
      indice_selecionado := Random(bolas_sorteadas.Count-1);
      bola_atual := bolas_sorteadas.Items[indice_selecionado];
      bolas_sorteadas.Delete(indice_selecionado);
      combinacoes_geradas[indice_cmb_geradas, bola_atual] := 1;
    end;

    // Obter as combinações invertidas.
    //for uC := 1 to 25 do begin
    //  combinacoes_geradas[indice_cmb_geradas + 1, 26 - uC] :=
    //                                         combinacoes_geradas[indice_cmb_geradas, uC];
    //end;
    //Inc(indice_cmb_geradas);
  end;

  sgr_controle := gerador_opcoes.gerador_controle;
  sgr_controle.Clear;
  sgr_controle.RowCount:= qt_de_combinacoes * 2 + 1;
  sgr_controle.FixedRows:=1;
  sgr_controle.FixedCols:=0;

  // Cabeçalho.
  sgr_controle.Columns.Clear;
  sgr_controle.BeginUpdate;
  for uA := 0 to 25 do begin
      coluna_atual := sgr_controle.Columns.Add;;
      coluna_atual.Alignment:=taCenter;
      if uA = 0 then begin
        coluna_atual.Title.Caption:='#';
      end else begin
        coluna_atual.Title.Caption := 'B' + IntToStr(uA);
      end;
  end;

  // Agora, vamos gerar as combinações:
  linha_sgr_controle := 1;
  for uA := 0 to indice_cmb_geradas do begin

    Write('Comb:', uA+1);
    sgr_controle.Cells[0, linha_sgr_controle] := IntToStr(uA+1);

    coluna_sgr_controle := 1;
    for uB := 1 to 25 do begin
      if combinacoes_geradas[uA, uB] = 1 then begin
        Write(',', uB);
        sgr_controle.Cells[coluna_sgr_controle, linha_sgr_controle] := IntToStr(uB);
        Inc(coluna_sgr_controle);
      end;
    end;
    Writeln('');
    Inc(linha_sgr_controle);
  end;
  sgr_controle.AutoSizeColumns;
  sgr_controle.EndUpdate(true);

end;

{
 Gera as combinações aleatória, relativo ao número do concurso escolhido pelo usuário,
 por exemplo, se o usuário selecionou que quer que todas as combinações tenha 5 bolas
 novas, então, haverá em todas as combinação 5 bolas novas.
}
procedure gerar_combinacoes_aleatorias_2(sql_conexao: TZConnection;
  gerador_opcoes: R_Gerador_Aleatorio_Opcoes);
type
  TList_Byte = specialize TFPGList<Byte>;
  TMap_Integer_List_Byte = specialize TFPGMap<Integer, TList_Byte>;
var
  lotofacil_bolas: array[0..25] of Byte;
  bolas_sorteadas: TList_Byte;
  bolas_nao_sorteadas : TList_Byte;
  concurso, bola_atual, qt_de_combinacoes, indice_cmb_geradas, uB, uC,
    uA, linha_sgr_controle, coluna_sgr_controle, indice_lista_de_novos,
    indice_final_lista_de_novos, indice_atual_lista_de_novos,
    indice_combinacao_gerada, qt_de_bolas_escolhidas: Integer;
  bolas_do_concurso: TArrayInt;

  combinacoes_geradas : Array of Array of Byte;
  indice_selecionado, indice_aleatorio: Byte;
  sgr_controle: TStringGrid;
  coluna_atual: TGridColumn;

  // Lista de novos, é uma lista de bolas, que não está no concurso
  // que o usuário escolheu.
  lista_de_novos : TList_Byte;

  // Lista de repetidos, é uma lista de bolas, que está no concurso
  // que o usuário escolheu.
  lista_de_repetidos: TList_Byte;

  // Há um arranjo com 10 ítens, cada célula deste arranjo armazena
  // uma lista de bolas.
  // Haverá dois tipos de lista, uma lista de origem e uma lista de destino.
  // Na lotofacil, podemos ter de 0 a 10 bolas novas, então, haverá um vetor
  // com 10 posições, cada posição armazenará uma lista com 10 bolas.
  // Cada posição do vetor, corresponde ao número de bolas que devemos capturar
  // e também a posição indica a quantidade de bolas que o usuário
  // selecionou, então, se o usuário selecionou '5' bolas novas, iremos
  // capturar aleatoriamente 5 bolas da lista que está no vetor 5:
  // lista_de_novos_origem[5].
  // Todas as bolas selecionadas da lista na posição escolhida será
  // movidas pra a lista de destino.
  // Toda vez, que a lista a qual formos selecionar estiver faltando alguma bola
  // iremos capturar aleatoriamente as bolas que faltam da lista de destino.
  lista_de_novos_origem: Array[0..10] of TList_Byte;
  lista_de_novos_destino: Array[0..10] of TList_Byte;

  lista_de_repetidos_origem: Array[0..10] of TList_Byte;
  lista_de_repetidos_destino: Array[0..10] of TList_Byte;

  // Aqui, iremos armazenar cada quantidade de novos
  // escolhidos pelo o usuário
  lista_de_novos_escolhidos: TList_Byte;
  qt_bolas_por_combinacao: Byte;
  qt_bolas_novas: Byte;
  bola_sorteada, qt_bolas_repetidas: Byte;

  lista_novo_origem_atual, lista_novo_destino_atual,
  lista_repetido_origem_atual, lista_repetido_destino_atual: TList_Byte;
  indice_escolhido: Byte;

  mapa_novos_atrasados : TMap_Integer_List_Byte;
  mapa_repetidos_atrasados : TMap_Integer_List_Byte;

  lista_de_novos_2 : array[0..10] of TMap_Integer_List_Byte;
  lista_de_repetidos_2 : array[0..10] of TMap_Integer_List_Byte;
  lista_atual: TList_Byte;
  mapa_atual: TMap_Integer_List_Byte;
  indice_chave_menor, indice_chave_maior: LongInt;
  lista_de_bolas_escolhidas: TList_Byte;
  lista_atual_2: TList_Byte;
  bola_escolhida: LongInt;
  indice_chave_atual, indice_chave_proximo: LongInt;
  lista_proxima: TList_Byte;

begin
  // Vamos obter as bolas do concurso escolhido.
  concurso := gerador_opcoes.concurso;
  if obter_bolas_do_concurso(sql_conexao, concurso, bolas_do_concurso) = false then begin
    Exit;
  end;

  // Vamos criar a lista que armazenará as bolas que saiu e as bolas que não saiu.
  bolas_sorteadas := TList_Byte.Create;
  bolas_nao_sorteadas := TList_Byte.Create;

  bolas_sorteadas.Clear;
  bolas_nao_sorteadas.Clear;

  // O arranjo bolas_do_concurso é baseado em 1, e tem 15 bolas retornadas
  // pela função.
  // Vamos percorrer e inserir as bolas no arranjo
  // Se a bola está no concurso, o arranjo 'lotofacil_bolas' terá o valor '1'.
  FillByte(lotofacil_bolas, 26 * sizeof(Byte), 0);
  for uA := 1 to 15 do begin
    bola_atual := bolas_do_concurso[uA];
    lotofacil_bolas[bola_atual] := 1;
  end;

  // Em seguida, iremos separar em duas listas, as bolas que foram
  // sorteadas e as bolas que não foram sorteadas.
  for uA := 1 to 25 do begin
    if lotofacil_bolas[uA] = 1 then begin
      bolas_sorteadas.Add(uA);
    end else begin
      bolas_nao_sorteadas.Add(uA);
    end;
  end;

  // Haverá uma lista pra cada combinação de novos x escolhidos, ou seja
  // se o usuário escolher que quer ter uma combinação de 6 novas x 9 repetidas
  // e 4 novas e 11 repetidas, então, a cada geração de uma nova combinação
  // teremos combinações alternadas de 6 e 4 novas.

  // O usuário pode escolher combinações que tenha de 0 a 10 bolas
  // novas, por exemplo, se ele escolher ter combinações com
  // 5, 6, e 7 bolas novas, então, haverá combinações com 5, 6 e 7
  // combinações
  lista_de_novos_escolhidos := TList_Byte.Create;
  lista_de_novos_escolhidos.Clear;
  for uA := 0 to High(gerador_opcoes.novos_escolhidos) do begin
    if gerador_opcoes.novos_escolhidos[uA] then begin
      lista_de_novos_escolhidos.Add(uA);
    end;
  end;

  // Agora, vamos iniciar a lista das bolas das combinações
  // de quantidade que foram escolhidas pelo o usuário.
  for uA := 0 to Pred(lista_de_novos_escolhidos.Count) do begin
    indice_escolhido := lista_de_novos_escolhidos.Items[uA];

    lista_de_novos_2[indice_escolhido] := TMap_Integer_List_Byte.Create;
    lista_de_repetidos_2[indice_escolhido] := TMap_Integer_List_Byte.Create;

    //lista_de_novos_origem[indice_escolhido] := TList_Byte.Create;
    //lista_de_novos_destino[indice_escolhido] := TList_Byte.Create;
    //lista_de_repetidos_origem[indice_escolhido] := TList_Byte.Create;
    //lista_de_repetidos_destino[indice_escolhido] := TList_Byte.Create;

    lista_de_novos_2[indice_escolhido].Add(0, TList_Byte.Create);
    lista_de_repetidos_2[indice_escolhido].Add(0, TList_Byte.Create);

    // Vamos alimentar as listas de origem com as bolas correspondentes.
    // A lista 'bolas_sorteadas', corresponderá a lista de bolas repetidas, e,
    // a lista 'bolas_nao_sorteadas', corresponderá a lista de bolas novas.
    lista_atual := lista_de_novos_2[indice_escolhido].Data[0];
    for uB := 0 to Pred(bolas_nao_sorteadas.Count) do begin
      //lista_de_novos_origem[indice_escolhido].Add(bolas_nao_sorteadas.Items[uB]);
      lista_atual.Add(bolas_nao_sorteadas.Items[uB]);
    end;

    lista_atual := lista_de_repetidos_2[indice_escolhido].Data[0];
    for uB := 0 to Pred(bolas_sorteadas.Count) do begin
      //lista_de_repetidos_origem[indice_escolhido].Add(bolas_sorteadas.Items[uB]);
      lista_atual.Add(bolas_sorteadas.Items[uB]);
    end;
  end;

  // Vamos obter a quantidade de combinações escolhidas pelo usuário e
  // também alocar memória pra o arranjo bidimensional.
  qt_de_combinacoes:=gerador_opcoes.qt_de_combinacoes;

  // Haverá 1 posição a mais pois, o arranjo é baseado em zero.
  SetLength(combinacoes_geradas, qt_de_combinacoes + 1, 26);

  // Armazena em qual posição estamos no arranjo bidimensional.
  indice_combinacao_gerada := -1;

  // Serve pra percorrer cada valor de combinações escolhidas.
  indice_atual_lista_de_novos := 0;
  indice_final_lista_de_novos := Pred(lista_de_novos_escolhidos.Count);

  lista_de_bolas_escolhidas := TList_Byte.Create;

  for uA := 1 to qt_de_combinacoes do
  begin
    // A variável 'lista_de_novos_escolhidos' armazena todos as 'quantidades
    // de bolas novas escolhidos pelo usuário, então, a variável
    // 'indice_atual_lista_de_novos' percorre cada um destas quantidades escolhidas
    // então, se o usuário escolher as quantidades: 5, 6, 7, então,
    // a cada 3 combinações, teremos uma combinação com 5, 6 e 7 bolas
    // novas.
    qt_bolas_novas := lista_de_novos_escolhidos.Items[indice_atual_lista_de_novos];
    qt_bolas_repetidas := 15 - qt_bolas_novas;

    // A variável 'lista_de_novos_2' é um arranjo com 10 posições, onde o valor do
    // índice corresponde ao números de bolas novas.
    // Em cada posição, há uma variável do tipo map da forma: integer, lista.
    // Quando iniciarmos o mapa terá o valor '0' como chave e nesta chave terá
    // uma lista de bolas novos pra serem escolhidas.
    // Cada vez que a bola é escolhida, ela será movida pra 2 chaves após a chave
    // atual que ela está, então, por exemplo, se a bola está na chave 2, ela irá
    // pra a chave 2.
    // Isto serve por que se a lista do mapa com a menor chave estiver vazia,
    // devemos ir pra a próxima chave que tem a lista das bolas que ainda não foram
    // sorteadas.
    mapa_atual := lista_de_novos_2[qt_bolas_novas];

    lista_de_bolas_escolhidas.Clear;
    indice_chave_menor := mapa_atual.Keys[0];
    indice_chave_maior := mapa_atual.Keys[mapa_atual.Count-1];
    indice_chave_atual := indice_chave_menor;

    Writeln('Novos:');

    qt_de_bolas_escolhidas := 0;
    while qt_de_bolas_escolhidas <> qt_bolas_novas do begin
      // Verifica se a lista está vazia, se sim, devemos pegar as bolas
      // do próximo mapa.
      lista_atual_2 := mapa_atual.KeyData[indice_chave_atual];
      if lista_atual_2.Count = 0 then begin
        mapa_atual.Remove(indice_chave_atual);
        indice_chave_atual := mapa_atual.Keys[0];
        Continue;
      end;

      while true do begin
            indice_aleatorio := Random(lista_atual_2.Count-1);
            bola_escolhida := lista_atual_2.Items[indice_aleatorio];
            // Verifica se já existe.
            if lista_de_bolas_escolhidas.IndexOf(bola_escolhida) = -1 then begin
              break;
            end;
      end;
      lista_atual_2.Delete(indice_aleatorio);

      indice_chave_proximo := indice_chave_atual + 2;
      if mapa_atual.IndexOf(indice_chave_proximo) = -1 then begin
        mapa_atual.Add(indice_chave_proximo, TList_Byte.Create);
        mapa_atual.KeyData[indice_chave_proximo].Clear;
      end;

      lista_proxima := mapa_atual.KeyData[indice_chave_proximo];
      lista_proxima.Add(bola_escolhida);
      Writeln(bola_escolhida, ' de: ', indice_chave_atual, 'pra=>', indice_chave_proximo);

      lista_de_bolas_escolhidas.Add(bola_escolhida);
      Inc(qt_de_bolas_escolhidas);

    end;
    Writeln('Repetidos:');

    mapa_atual := lista_de_repetidos_2[qt_bolas_novas];

    //lista_de_bolas_escolhidas.Clear;
    indice_chave_menor := mapa_atual.Keys[0];
    indice_chave_maior := mapa_atual.Keys[mapa_atual.Count-1];
    indice_chave_atual := indice_chave_menor;

    qt_de_bolas_escolhidas := 0;
    while qt_de_bolas_escolhidas <> qt_bolas_repetidas do begin
      // Verifica se a lista está vazia, se sim, devemos pegar as bolas
      // do próximo mapa.
      lista_atual_2 := mapa_atual.KeyData[indice_chave_atual];
      if lista_atual_2.Count = 0 then begin
        mapa_atual.Remove(indice_chave_atual);
        indice_chave_atual := mapa_atual.Keys[0];
        Continue;
      end;

      while true do begin
            indice_aleatorio := Random(lista_atual_2.Count-1);
            bola_escolhida := lista_atual_2.Items[indice_aleatorio];
            if lista_de_bolas_escolhidas.IndexOf(bola_escolhida) = -1 then begin
              break;
            end;
      end;
      lista_atual_2.Delete(indice_aleatorio);

      indice_chave_proximo := indice_chave_atual + 2;
      if mapa_atual.IndexOf(indice_chave_proximo) = -1 then begin
        mapa_atual.Add(indice_chave_proximo, TList_Byte.Create);
      end;

      lista_proxima := mapa_atual.KeyData[indice_chave_proximo];
      lista_proxima.Add(bola_escolhida);
      Writeln(bola_escolhida, ' de: ', indice_chave_atual, 'pra=>', indice_chave_proximo);

      lista_de_bolas_escolhidas.Add(bola_escolhida);
      Inc(qt_de_bolas_escolhidas);

    end;

    //lista_novo_origem_atual := lista_de_novos_origem[qt_bolas_novas];
    //lista_novo_destino_atual := lista_de_novos_destino[qt_bolas_novas];
    //lista_repetido_origem_atual := lista_de_repetidos_origem[qt_bolas_novas];
    //lista_repetido_destino_atual := lista_de_repetidos_destino[qt_bolas_novas];

    // Enquanto não houve a quantidade de bolas suficiente, iremos mover as bolas
    // da lista de destino pra a lista de origem.
    //while lista_de_novos_origem[qt_bolas_novas].Count < qt_bolas_novas do begin
    //  indice_aleatorio := Random(lista_novo_destino_atual.Count-1);
    //  bola_sorteada := lista_novo_destino_atual.Items[indice_aleatorio];
    //  lista_novo_destino_atual.Delete(indice_aleatorio);
    //  lista_novo_origem_atual.Add(bola_sorteada);
    //end;

    // Enquanto a lista de origem não tiver as bolas suficiente, iremos mover
    // as bolas
    //while lista_de_repetidos_origem[qt_bolas_novas].Count < qt_bolas_repetidas do begin
    //  indice_aleatorio := Random(lista_repetido_destino_atual.Count-1);
    //  bola_sorteada := lista_repetido_destino_atual.Items[indice_aleatorio];
    //  lista_repetido_destino_atual.Delete(indice_aleatorio);
    //  lista_repetido_origem_atual.Add(bola_sorteada);
    //end;

    // Indica onde a próxima combinação será gerada no arranjo.
    Inc(indice_combinacao_gerada);

    // Vamos percorrer a lista de bolas.
    for uB := 0 to Pred(lista_de_bolas_escolhidas.Count) do begin
      bola_sorteada := lista_de_bolas_escolhidas.Items[uB];
      combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
    end;


    // Agora, iremos sortear a quantidade de bolas escolhido pelo usuário da lista
    // de bolas novas e depois da lista de bolas repetidas.
    // As bolas escolhidas da lista de origem serão movidas pra a lista de destino.
    //for uB := 1 to qt_bolas_novas do begin
    //  indice_aleatorio := Random(lista_novo_origem_atual.Count-1);
    //  bola_sorteada := lista_novo_origem_atual.Items[indice_aleatorio];
    //  lista_novo_origem_atual.Delete(indice_aleatorio);
    //  lista_novo_destino_atual.Add(bola_sorteada);
    //  combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
    //end;

    //for uB := 1 to qt_bolas_repetidas do begin
    //  indice_aleatorio := Random(lista_repetido_origem_atual.Count - 1);
    //  bola_sorteada := lista_repetido_origem_atual.Items[indice_aleatorio];
    //  lista_repetido_origem_atual.Delete(indice_aleatorio);
    //  lista_repetido_destino_atual.Add(bola_sorteada);
    //  combinacoes_geradas[indice_combinacao_gerada, bola_sorteada] := 1;
    //end;

    // Vamos capturar a próxima quantidade de bolas selecionada pelo usuário.
    Inc(indice_atual_lista_de_novos);
    if indice_atual_lista_de_novos > indice_final_lista_de_novos then begin
      indice_atual_lista_de_novos:=0
    end;
  end;

  // Agora, vamos gerar as combinações no controle TStringGrid.

  sgr_controle := gerador_opcoes.gerador_controle;
  sgr_controle.Clear;
  sgr_controle.RowCount:= qt_de_combinacoes + 1;
  sgr_controle.FixedRows:=1;
  sgr_controle.FixedCols:=0;

  // Cabeçalho.
  sgr_controle.Columns.Clear;
  sgr_controle.BeginUpdate;
  for uA := 0 to 25 do begin
      coluna_atual := sgr_controle.Columns.Add;;
      coluna_atual.Alignment:=taCenter;
      if uA = 0 then begin
        coluna_atual.Title.Caption:='#';
      end else begin
        coluna_atual.Title.Caption := 'B' + IntToStr(uA);
      end;
  end;

  // Agora, vamos gerar as combinações:
  linha_sgr_controle := 1;
  for uA := 0 to indice_combinacao_gerada do begin

    //Write('Comb:', uA+1);
    sgr_controle.Cells[0, linha_sgr_controle] := IntToStr(uA+1);

    coluna_sgr_controle := 1;
    for uB := 1 to 25 do begin
      if combinacoes_geradas[uA, uB] = 1 then begin
        Write(',', uB);
        sgr_controle.Cells[coluna_sgr_controle, linha_sgr_controle] := IntToStr(uB);
        Inc(coluna_sgr_controle);
      end;
    end;
    Writeln('');
    Inc(linha_sgr_controle);
  end;
  sgr_controle.AutoSizeColumns;
  sgr_controle.EndUpdate(true);


  Exit;










  // Será gerada combinações de 15 bolas seguindo os passos abaixo:
  // [Passo 1] : Seleciona todas as bolas da lista 'bolas_nao_sorteadas';
  // [Passo 2] : Seleciona aleatoriamente 5 bolas da lista 'bolas_sorteadas';
  // [Passo 3] : Exclui as bolas selecionadas no passo 2.
  // [Passo 4] : Todas as bolas do passo 1 e todas as bolas do passo 2, tem-se
  //             uma combinação de 15 bolas geradas.
  // [Passo 4] : Enquanto houver bolas na lista 'bolas_sorteadas', vá pra o passo 1.
  // [Passo 5] : Todas as bolas selecionadas da última combinação no passo 4, será
  //             a nova lista da variável 'bolas_sorteadas'.
  // [Passo 6] : Exclui todas as bolas da lista 'bolas_nao_sorteadas'
  // [Passo 7] : Gera uma lista de 'bolas_nao_sorteadas' que consiste em todas as
  //             bolas da lotofacil não sorteadas no passo 5.
  // [Passo 8] : Se houver mais combinações a serem geradas vá pra o passo 1, se não
  //             vá pra o passo 9.
  // [Passo 9] : Conclui-se a geração de 3 ou mais combinações baseadas em uma combinação
  //             específica.

  // Vamos criar um arranjo bidimensional pra armazenar as combinações geradas.
  qt_de_combinacoes := gerador_opcoes.qt_de_combinacoes;
  //SetLength(combinacoes_geradas, (qt_de_combinacoes + 1) * 2, 26);
  SetLength(combinacoes_geradas, (qt_de_combinacoes + 1), 26);
  indice_cmb_geradas := -1;

  // Vamos gerar todas as combinações.
  for uA := 1 to qt_de_combinacoes do begin

    // Se não há bolas sorteadas mais, pega as bolas da última combinação.
    if bolas_sorteadas.Count <= 0 then begin
      bolas_sorteadas.Clear;
      bolas_nao_sorteadas.Clear;
      for uB := 1 to 25 do begin
        //if combinacoes_geradas[indice_cmb_geradas, uB] = 1 then begin
        if lotofacil_bolas[uB] = 1 then begin
          bolas_sorteadas.Add(uB);
        end else begin
          bolas_nao_sorteadas.Add(uB);
        end;
      end;

      // Verifica se realmente, há 15 bolas na lista de bolas_sorteadas
      // e 10 bolas na lista de bolas não sorteadas.
      if bolas_sorteadas.Count <> 15 then begin
      end;
    end;

    // Vamos criar a nova combinação.
    Inc(indice_cmb_geradas);

    // Preenche o arranjo com bola da lista 'bolas_nao_sorteadas'.
    //    Inc(indice_cmb_geradas);
    for uB := 0 to Pred(bolas_nao_sorteadas.Count) do begin
      bola_atual := bolas_nao_sorteadas.Items[uB];
      combinacoes_geradas[indice_cmb_geradas, bola_atual] := 1;
    end;

    // Preenche aleatoriamente com 5 bolas da lista 'bolas_sorteadas'.
    // A cada bola selecionada da lista 'bolas_sorteadas', iremos
    // mover pro arranjo que armazenas as bolas que farão parte
    // da nova combinação.
    for uC := 1 to 5 do begin
      indice_selecionado := Random(bolas_sorteadas.Count-1);
      bola_atual := bolas_sorteadas.Items[indice_selecionado];
      bolas_sorteadas.Delete(indice_selecionado);
      combinacoes_geradas[indice_cmb_geradas, bola_atual] := 1;
    end;

    // Obter as combinações invertidas.
    //for uC := 1 to 25 do begin
    //  combinacoes_geradas[indice_cmb_geradas + 1, 26 - uC] :=
    //                                         combinacoes_geradas[indice_cmb_geradas, uC];
    //end;
    //Inc(indice_cmb_geradas);
  end;

  sgr_controle := gerador_opcoes.gerador_controle;
  sgr_controle.Clear;
  sgr_controle.RowCount:= qt_de_combinacoes * 2 + 1;
  sgr_controle.FixedRows:=1;
  sgr_controle.FixedCols:=0;

  // Cabeçalho.
  sgr_controle.Columns.Clear;
  sgr_controle.BeginUpdate;
  for uA := 0 to 25 do begin
      coluna_atual := sgr_controle.Columns.Add;;
      coluna_atual.Alignment:=taCenter;
      if uA = 0 then begin
        coluna_atual.Title.Caption:='#';
      end else begin
        coluna_atual.Title.Caption := 'B' + IntToStr(uA);
      end;
  end;

  // Agora, vamos gerar as combinações:
  linha_sgr_controle := 1;
  for uA := 0 to indice_cmb_geradas do begin

    Write('Comb:', uA+1);
    sgr_controle.Cells[0, linha_sgr_controle] := IntToStr(uA+1);

    coluna_sgr_controle := 1;
    for uB := 1 to 25 do begin
      if combinacoes_geradas[uA, uB] = 1 then begin
        Write(',', uB);
        sgr_controle.Cells[coluna_sgr_controle, linha_sgr_controle] := IntToStr(uB);
        Inc(coluna_sgr_controle);
      end;
    end;
    Writeln('');
    Inc(linha_sgr_controle);
  end;
  sgr_controle.AutoSizeColumns;
  sgr_controle.EndUpdate(true);

end;


end.

