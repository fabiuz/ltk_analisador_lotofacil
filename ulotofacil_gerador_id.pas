unit uLotofacil_Gerador_id;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils;

function identificador_grupo_1_bolas(bola1: Integer): Integer;
function identificador_grupo_2_bolas(bola1, bola2: Integer): Integer;
function identificador_grupo_3_bolas(bola1, bola2, bola3: Integer): Integer;
function identificador_grupo_4_bolas(bola1, bola2, bola3, bola4: Integer): Integer;
function identificador_grupo_5_bolas(bola1, bola2, bola3, bola4, bola5: Integer): Integer;
function identificador_grupo_6_bolas(bola1, bola2, bola3, bola4, bola5, bola6: Integer): Integer;
function identificador_grupo_7_bolas(bola1, bola2, bola3, bola4, bola5, bola6, bola7: Integer): Integer;
function identificador_grupo_8_bolas(bola1, bola2, bola3, bola4, bola5, bola6, bola7, bola8: Integer): Integer;
function identificador_grupo_9_bolas(bola1, bola2, bola3, bola4, bola5, bola6, bola7, bola8, bola9: Integer): Integer;
function identificador_grupo_10_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10: Integer): Integer;
function identificador_grupo_11_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11: Integer): Integer;
function identificador_grupo_12_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12: Integer): Integer;
function identificador_grupo_13_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12, bola13: Integer): Integer;
function identificador_grupo_14_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14: Integer): Integer;
function identificador_grupo_15_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15: Integer): Integer;
function identificador_grupo_16_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15, bola16: Integer): Integer;
function identificador_grupo_17_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15, bola16, bola17: Integer): Integer;
// function identificador_grupo_18_bolas(bola1, bola2, bola3, bola4, bola5, bola6,  bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15, bola16, bola17, bola18: Integer): Integer;


implementation
const
   // Da esquerda pra direita, cada número, é possível saber a quantidade de
  // combinações do seu subconjunto
  // Por exemplo, em um grupo de 3 bolas, conseguimos saber quantas combinações
  // possíveis a bola 1 terá consultando o mesmo índice no arranjo com 2 bolas.
  // Observe que o grupo está indo de 1 a 23, pois, na realidade, nos íremos comparar

  // Observe abaixo que um grupo de 3 bolas, a última bola mais a esquerda é
  // 23, pois [23, 24, e 25]
  // Ou seja, quantas combinações, por exemplo, é possível realizar com a bola
  // 23, na primeira posição, a resposta, está no arranjo que tem o total de
  // combinações por bola.

  ////////////////////////////////// PERIGO ////////////////////////////////////
  ////    Não altere as linhas abaixo, se não sabe o que está fazendo
  ////  Estes são dados referente a cada combinação possível na lotofacil.
  ///   O arranjo bidmensional de dimensão 1 corresponde à fórmula abaixo:
  ///   n!*(p!(n-p)!)
  ///   24!*(1!(23-1)!), 23!*(1!(23-1)!) e assim por diante.
  ///
  ///   Há um arquivo em excel, com tais dados.
  //////////////////////////////////////////////////////////////////////////////



  combinacoes_por_bola: array[0..16] of array [0..24] of Integer = (
  (1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
  (0, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1  ),
  (0, 276, 253, 231, 210, 190, 171, 153, 136, 120,105, 91, 78, 66, 55, 45, 36, 28, 21, 15, 10, 6, 3, 1, 0),
  (0, 2024,1771,1540,1330,1140,969,816,680,560,455,364,286,220,165,120,84,56,35,20,10,4,1,0,0 ),
  (0, 10626,8855,7315,5985,4845,3876,3060,2380,1820,1365,1001,715,495,330,210,126,70,35,15,5,1, 0, 0, 0),
  (0, 42504,33649,26334,20349,15504,11628,8568,6188,4368,3003,2002,1287,792,462,252,126,56,21,6,1, 0, 0, 0, 0),
  (0, 134596,100947,74613,54264,38760,27132,18564,12376,8008,5005,3003,1716,924,462,210,84,28,7,1, 0, 0, 0, 0, 0),
 (0, 346104,245157,170544,116280,77520,50388,31824,19448,11440,6435,3432,1716,792,330,120,36,8,1, 0, 0, 0, 0, 0, 0),
 (0, 735471,490314,319770,203490,125970,75582,43758,24310,12870,6435,3003,1287,495,165,45,9,1, 0, 0, 0, 0, 0, 0, 0),
 (0, 1307504,817190,497420,293930,167960,92378,48620,24310,11440,5005,2002,715,220,55,10,1, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 1961256, 1144066,646646,352716,184756,92378,43758,19448,8008,3003,1001,286,66,11,1, 0, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 2496144,1352078,705432,352716,167960,75582,31824,12376,4368,1365,364,78,12,1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 2704156,1352078,646646,293930,125970,50388,18564,6188,1820,455,91,13,1,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 2496144,1144066,497420,203490,77520,27132,8568,2380,560,105,14,1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 1961256,817190,319770,116280,38760,11628,3060,680,120,15,1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 1307504,490314,170544, 54264,15504,3876,816,136,16,1,   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
 (0, 735471, 245157, 74613, 20349, 4845, 969, 153, 17, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
 );

{
 Esta função retorna um identificador pra cada combinação válida na lotofácil.
 As bolas recebidas no parâmetro da função devem estar em ordem crescente.
 O algoritmo desta função funciona desta maneira:

 Da esquerda pra direita, o programa percorrerá da esquerda pra direita cada
 bola, o número da bola será necessário pra identificar o limite dos arranjos
 que o programa percorrerá.
 Neste caso, a bola na posição 1, o algoritmo percorrerá o arranjo
 'combinacao_2_por_2_por_bola', iniciando no índice 0, e percorrer até chegar
 ao último índice do arranjo que será igual ao antecessor da bola da posição 1.
 Conforme descrito, ao percorrermos cada bola, iremos soma cada valor encontrado
 no arranjo, cada valor representa a quantidade de combinações possíveis utilizando
 aquele número naquela posição, por exemplo, o número 1 terá 276 combinações.
 Em seguida, iremos para a bola que está na posição 2, neste caso, o índice inicial
 do arranjo será igual ao sucessor do número anterior e o índice final será o
 antecessor do número atual.

 Função testada com sucesso, foi comparada a saída de 3 bolas com a saída
 de outra tabela que tem todos os dados em sequencia, os dados coincidiram.

}

function identificador_grupo_1_bolas(bola1: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[0][uA];
  end;

  result := somaCombinacao;
end;


function identificador_grupo_2_bolas(bola1, bola2: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_3_bolas(bola1, bola2, bola3: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_4_bolas(bola1, bola2, bola3, bola4: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_5_bolas(bola1, bola2, bola3, bola4, bola5: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_6_bolas(bola1, bola2, bola3, bola4, bola5, bola6: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_7_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_8_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;


function identificador_grupo_9_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;


function identificador_grupo_10_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;


function identificador_grupo_11_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;


  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_12_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11, bola12: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[11][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola11) to pred(bola12) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_13_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11, bola12, bola13: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[12][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[11][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola11) to pred(bola12) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola12) to pred(bola13) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;


function identificador_grupo_14_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14: Integer): Integer;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[13][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[12][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[11][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola11) to pred(bola12) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola12) to pred(bola13) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;

  for uA := succ(bola13) to pred(bola14) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao;
end;

function identificador_grupo_15_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15: Integer): Integer;
const
  lotofacil_id_inicial = 1;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[14][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[13][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[12][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[11][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola11) to pred(bola12) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola12) to pred(bola13) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola13) to pred(bola14) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;


  for uA := succ(bola14) to pred(bola15) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao + lotofacil_id_inicial;
end;



function identificador_grupo_16_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15, bola16: Integer): Integer;
const
  lotofacil_id_inicial = 3268761;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[15][uA];
  end;


  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[14][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[13][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[12][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[11][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola11) to pred(bola12) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola12) to pred(bola13) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola13) to pred(bola14) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola14) to pred(bola15) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;


  for uA := succ(bola15) to pred(bola16) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao + lotofacil_id_inicial;
end;

function identificador_grupo_17_bolas(bola1, bola2, bola3, bola4, bola5, bola6,
         bola7, bola8, bola9, bola10, bola11, bola12, bola13, bola14, bola15, bola16, bola17: Integer): Integer;
const
  //lotofacil_id_inicial = 5316144;
  lotofacil_id_inicial = 5311736;
var
   somaCombinacao, uA: Integer;
begin
  somaCombinacao := 0;

  for uA := 0 to pred(bola1) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[16][uA];
  end;

  for uA := succ(bola1) to pred(bola2) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[15][uA];
  end;

  for uA := succ(bola2) to pred(bola3) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[14][uA];
  end;

  for uA := succ(bola3) to pred(bola4) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[13][uA];
  end;

  for uA := succ(bola4) to pred(bola5) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[12][uA];
  end;

  for uA := succ(bola5) to pred(bola6) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[11][uA];
  end;

  for uA := succ(bola6) to pred(bola7) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[10][uA];
  end;

  for uA := succ(bola7) to pred(bola8) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[9][uA];
  end;

  for uA := succ(bola8) to pred(bola9) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[8][uA];
  end;

  for uA := succ(bola9) to pred(bola10) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[7][uA];
  end;

  for uA := succ(bola10) to pred(bola11) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[6][uA];
  end;

  for uA := succ(bola11) to pred(bola12) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[5][uA];
  end;

  for uA := succ(bola12) to pred(bola13) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[4][uA];
  end;

  for uA := succ(bola13) to pred(bola14) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[3][uA];
  end;

  for uA := succ(bola14) to pred(bola15) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[2][uA];
  end;

  for uA := succ(bola15) to pred(bola16) do begin
      somaCombinacao := somaCombinacao + combinacoes_por_bola[1][uA];
  end;


  for uA := succ(bola16) to pred(bola17) do begin
      somaCombinacao := somaCombinacao + 1;
  end;

  result := somaCombinacao + lotofacil_id_inicial;
end;



end.

