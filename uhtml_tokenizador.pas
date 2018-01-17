unit uHtml_Tokenizador;

{include syspchh.inc}

{
     Autor : Fábio Moura de Oliveira
     Data  : 30/10/2015

     Classe: THtml_Tokenizador

     Objetivo:
              Analisar um string que contém conteúdo de um arquivo html e retorna
              um lista de string, tal lista terá com conteúdo todos os tags htmls,
              propriedade deste tag entre outros.

              Esta classe é útil, se quisermos futuramente, criar um programa
              que analisa os tags htmls.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, strUtils;

type

  { Tfb_Tokenizador_Html }

  THtml_Tokenizador = class
  private
    strTokens: TStrings;               // Guarda cada token html.
    strHtml_Conteudo: UnicodeString;      // Conteúdo html a analisar.

    function getHtml_Conteudo: Unicodestring;
    // Retorna o string que o usuário forneceu.
    function getHtml_Tokens: TStrings;
    // Retorna o 'TString' gerado pela classe.
    procedure setHtmlTokens(AValue: TStrings);

    procedure setHtml_Conteudo(aValue: Unicodestring);
    // Define o conteúdo html a analisar.

  public
    constructor Create;
    destructor Destroy; override;


    property html_Conteudo: Unicodestring write setHtml_Conteudo;
    property html_Tokens: TStrings read getHtml_Tokens write setHtmlTokens;

    function Analisar_Html: boolean;
    // Separa o contéudo html em tokens html.
    function Analisar_Html(out strToken: TStrings): boolean;
    function Analisar_Html(conteudo_em_html: string; var strToken: TStrings): boolean;

  end;

implementation


{ Tfb_Tokenizador_Html }

function THtml_Tokenizador.getHtml_Conteudo: Unicodestring;
begin
  Result := strHtml_Conteudo;
end;

procedure THtml_Tokenizador.setHtml_Conteudo(aValue: Unicodestring);
begin
  self.strHtml_Conteudo := aValue;
end;

constructor THtml_Tokenizador.Create;
begin
  self.strTokens := TStringList.Create;
end;

destructor THtml_Tokenizador.Destroy;
begin
  FreeAndNil(self.strTokens);
end;

function THtml_Tokenizador.getHtml_Tokens: TStrings;
begin
  // Cuidado, se você não executou a função 'Analisar_Html', esta função
  // retornará um ponteiro nulo.
  if Assigned(strTokens) = False then
  begin
    Result := nil;
    raise Exception.Create('O string está vazio.');
  end;

  Result := strTokens;
end;

procedure THtml_Tokenizador.setHtmlTokens(AValue: TStrings);
begin
  self.strTokens := Avalue;
end;

{
    A função Analisar_Html é a principal da classe, é nela que toda a análise
    é realizada.

    // Esta função só vai retornar false, se o usuário fornecer o 'strHtml_Conteudo' vazio.
    // Ou, se por algum motivo, não for possível criar o 'TStrings' strToken.
}
function THtml_Tokenizador.Analisar_Html: boolean;
var
  pHtml, pTemp, pFechar_Tag: PUnicodechar;
  strToken_Temp: UnicodeString;
  pSeparador: PUnicodeChar;
  pNao_Espaco: PUnicodeChar;
  pFecha_Aspas: PUnicodeChar;
  pSeparador_Proximo: PUnicodeChar;
  uQuantidade: integer;
	tokens_temp: TStrings;
	iA: Integer;
  pLetraU: Char;
begin
  if self.strHtml_Conteudo = '' then
  begin
    Exit(False);
  end;

  if Assigned(strTokens) = False then
  begin
    strTokens := TStringList.Create;
  end;

  // Vamos verificar se conseguirmos criar o objeto.
  if Assigned(strTokens) = False then
  begin
    Exit(False);
  end;

  // Vamos colocar um #0 no final para indicar terminado nulo.
  strHtml_Conteudo := strHtml_conteudo + #$00;
  pHtml := PUnicodeChar(strHtml_Conteudo);
  strToken_Temp := '';

  // Vamos apagar sempre strTokens
  strTokens.Clear;

  // O algoritmo abaixo separa os tag, de todos os outros tipos de tag e propriedades.

  try

    while pHtml^ <> #0 do
    begin
      uQuantidade := strTokens.Count;

      {
      if ((pHtml - 3)^ = 'r') and ((pHtml - 2)^ = 'o') and ((pHtml - 1)^ = 's') then
         pLetraU := (pHtml - 4)^;

      if pHtml^ = 'ú' then
         Writeln('Teste');
         }
      case pHtml^ of

        '<':
        begin
          // Toda vez que encontramos o '<', quer dizer que iremos iniciar
          // um novo token, então devemos verificar se já há caracteres em
          // strToken_Temp

          if strToken_Temp <> '' then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';
          end;

          strToken_Temp := '<';
          Inc(pHtml);
          continue;
        end;

        '>':
        begin

          if strToken_Temp = '' then
          begin
            strTokens.Add('>');
            Inc(pHtml);
            Continue;
          end;

          // Se encontrarmos o '>', quer dizer que fecharemos um tag
          // Vamos verificar se há caracteres pendentes em 'strToken_Temp'
          // Se sim, verificaremos se começa com '<'
          if strToken_Temp <> '' then
          begin

            // Se o primeiro caractere começa com '<', quer dizer que há um
            // tag html formado.

            if strToken_Temp[1] = '<' then
            begin
              strToken_Temp := strToken_Temp + '>';
              strTokens.Add(strToken_Temp);
              strToken_Temp := '';

            end
            else if strToken_Temp = '--' then
            begin

              // Em, 2/11/2015, detectei que não havia implementado
              // quando houvesse um tag de comentário.
              // Se em 'strToken_Temp' for igual a '--', quer dizer, que é
              // um tag de fechamento de comentário.
              // Em html, um comentário é colocado entre os tags:
              // '<!-- -->

              strToken_Temp := strToken_Temp + '>';
              strTokens.Add(strToken_Temp);
              strToken_Temp := '';

            end
            else if strToken_Temp = '/' then
            begin
              // Em 2/11/2015, detectei que não havia implementado
              // o tag na forma: <meta />
              // Há alguns tags html, que não tem um tag de fechamento
              // correspondente, por exemplo:
              // <meta />, por haver entre '<meta' e '/>', atributo
              // na forma: propriedade=valor

              strToken_Temp := strToken_Temp + '>';
              strTokens.Add(strToken_Temp);
              strToken_Temp := '';

            end
            else
            begin
              // Se não há o caractere inicial '<', quer dizer
              // que no tag, há atributos do tag no formato
              // propriedade=valor, neste caso, iremos
              // adicionar os caracteres que já em 'strTokenTemp' em
              // strToken, então cria um novo e adicionar '>'

              strTokens.Add(strToken_Temp);
              strToken_Temp := '';
              strTokens.Add('>');
            end;
          end;
          Inc(pHtml);
        end;

        '''', '"':
          // Se encontrarmos o apostrófo simples ou duplo, devemos verificar se encontraremos
          // o outro apostrofo simples ou duplo.
        begin
          // 'pTemp' irá apontar para o próximo caractere, pois nós iremos
          // tentar localizar um segundo caractere igual a 'pHtml^':
          pTemp := pHtml + 1;


          //pTemp := PWideChar(strScan(PChar(pTemp), char(pHtml^)));
          pTemp := strScan(pTemp, pHtml^);

          // Se não encontrarmos um outro caractere, não indicaremos erro,
          // Simplesmente, iremos adicionar a 'strToken_Temp'
          if pTemp = nil then
          begin

            strToken_Temp := strToken_Temp + pHtml^;
            Inc(pHtml);
            continue;

          end
          else
          begin
            // Se strToken_Temp não está vazio, então iremos adicionar
            // a strTokens.


            if strToken_Temp <> '' then
            begin
              strTokens.Add(strToken_Temp);
              strToken_Temp := '';
            end;


            // Iremos percorrer utilizando pHtml, até encontrarmos pTemp;
            // Vamos adicionar cada caractere a strToken_Temp e formamos
            // um novo token.
            // Como localizamos a outra aspas, iremos copiar, a aspa de abertura
            // mais os caracteres depois dela até chegar a aspa de fechamento
            // e copiar a mesma

            while pHtml <= pTemp do
            begin
              if not (pHtml^ in [#255]) then
              begin
                strToken_Temp := strToken_Temp + pHtml^;
              end;
              Inc(pHtml);
            end;


              if strToken_Temp = '"num_id"' then
                 strToken_Temp := strToken_Temp;

            strTokens.Add(strToken_Temp);

            strToken_Temp := '';

            // Apos sairmos do loop anterior, pHtml, está apontado

            // Quando acabar o loop 'pHtml' apontará um caractere depois
            // do apóstrofo simples ou duplo.
            Continue;
          end;
        end;

        // Se for um dos caracteres não imprimíveis, simplesmente, não iremos
        // gravar em 'strToken', se houver caracteres remanescentes em 'strToken_Temp'
        // iremos adicionar em strTokens.
        #0..#32:
        begin
          // Se strToken_Temp está vazio, então, não iremos gravar os espaços
          // simplesmente, iremos percorrer até encontrar um caractere diferente
          // de espaço vazio.

          if strToken_Temp = '' then
          begin
            while pHtml^ in [#1..#32] do
            begin
              Inc(pHtml);
            end;

            Continue;
          end;

          // Se o primeiro caractere em 'strToken_Temp' é igual a '<',
          // quer dizer, que encontramos um novo tag, adicionar a strTokens.
          if strToken_Temp[1] = '<' then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';

            // Vamos percorrer até encontrar um caractere diferente de #1..#32.
            while pHtml^ in [#1..#32] do
            begin
              Inc(pHtml);
            end;
            Continue;
          end;

          // Vamos apontar para o próximo caractere que não seja um espaço
          pNao_Espaco := pHtml;
          while (pNao_Espaco^ <> #0) and (pNao_Espaco^ in [#1..#32] = True) do
          begin
            Inc(pNao_Espaco);
          end;


          // Aqui, para baixo, iremos verificar o primeiro caractere na palavra.

          // Se encontramos #0, quer dizer que acabou o processamento dos tokens.
          // Gravar o que estiver em strToken_Temp.
          if pNao_Espaco^ = #0 then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';
            pHtml := pNao_Espaco;
            Continue;
          end;

          // Se encontramos o caractere '=', que o que está em strToken_Temp
          // é uma propriedade.
          if pNao_Espaco^ = '=' then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';
            pHtml := pNao_Espaco;
            Continue;
          end;

          // Se encontrarmos o caractere '-', vamos verificar
          // Se os próximos caracteres indica um tag de fim de comentário.
          // Um tag de fim de comentário é representado por '-->'
          if pNao_Espaco^ = '-' then
          begin
            // Vamos verificar se há os caracteres '-->'
            if strlcomp(pNao_Espaco, '-->', 3) = 0 then
            begin
              // Se existe o comentário, então, devemos inserir strToken_Temp
              // em strTokens.
              strTokens.Add(strToken_Temp);
              strToken_Temp := '';

              // Vamos adicionar também o token '-->'
              strTokens.Add('-->');

              // Vamos apontar pHtml um caractere após '>'
              // Por que pNao_Espaco + 3, simples, pois:
              // pNao_Espaco         é igual a '-';
              // pNao_Espaco + 1     é igual a '-';
              // pNao_Espaco + 2     é igual a '>';

              pHtml := pNao_Espaco + 3;
              Continue;
            end;
          end;

          // Se o primeiro caractere, na primeira palavra é '<', quer dizer
          // que devemos adicionar strtoken_Temp a strToken
          if (pNao_Espaco^ = '<') or (pNao_Espaco^ = '>') then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';

            pHtml := pNao_Espaco;
            Continue;
          end;

          // Se o primeiro caractere, é uma aspas simples ou dupla, iremos
          // percorrer até encontrar a outra aspas.
          if pNao_Espaco^ in ['''', '"'] then
          begin
            pFecha_Aspas := StrScan(pNao_Espaco + 1, pNao_Espaco^);

            // Se acharmos a outra aspa copia de pHtml até pFecha_Aspas.
            if pFecha_Aspas <> nil then
            begin
              while pHtml <= pFecha_Aspas do
              begin
                strToken_Temp := strToken_Temp + pHtml^;
                Inc(pHtml);
              end;
              Continue;
            end
            else
            begin
              // Não encontramos uma segunda aspas, então devemos adicionar
              // a strToken_Temp.
              while pHtml <= pNao_Espaco do
              begin
                strToken_Temp := strToken_Temp + pHtml^;
                Inc(pHtml);
              end;
              Continue;
            end;
          end;

          // Se o primeiro caractere não é um Separador, iremos procurar o próximo
          // Separador,
          // No loop abaixo, quando for encontrado qualquer um dos caracteres
          // '>', '<', '#1..#32', '''', '"', '=', '-'
          // o loop é interrompido.
          // Este pSeparador_Proximo está após a primeira palavra.
          // Então deste separador podemos determinar o que iremos fazer com
          // strToken_Temp.

          pSeparador := pNao_Espaco;
          pSeparador_Proximo := pSeparador;
          while (pSeparador_Proximo^ <> #0) and
            (pSeparador_Proximo^ in ['>', '<', #1..#32,
              '''', '"', '='] = False) do
          begin
            Inc(pSeparador_Proximo);
          end;

          // Se é igual a #0, então adicionar a strToken.
          if pSeparador_Proximo^ = #0 then
          begin
            while pHtml < pSeparador_Proximo do
            begin
              strToken_Temp := strToken_Temp + pHtml^;
              Inc(pHtml);
            end;
            Continue;
          end;

          // Se o próximo caractere é '=', quer dizer, que os caracteres atuais
          // antes de pSeparador_Proximo, representa uma propriedade, devemos
          // adicionar strToken_Temp a strTokens.
          if pSeparador_Proximo^ = '=' then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';

            // Adicionar pSeparador até um caractere antes de pSeparador_Proximo a
            // strToken_Temp e adicionar a strTokens.
            while pSeparador < pSeparador_Proximo do
            begin
              strToken_Temp := strToken_Temp + pSeparador^;
              Inc(pSeparador);
            end;

            strTokens.Add(strToken_Temp);
            strToken_Temp := '';

            // Adicionar o caractere
            strTokens.Add('=');

            // Apontar pHtml um caractere após '='.
            pHtml := pSeparador_Proximo + 1;
            Continue;
          end;

          // Se o próximo caractere é '>'
          // Então adicionar todos os caractere até antes de pSeparador_Proximo
          // a strtoken_Temp e depois adicionar a strTokens.
          if (pSeparador_Proximo^ in ['>', '<'] = True) then
          begin
            while pHtml < pSeparador_Proximo do
            begin
              strToken_Temp := strToken_Temp + pHtml^;
              Inc(pHtml);
            end;
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';

            //strTokens.Add(pSeparador_Proximo^);
            pHtml := pSeparador_Proximo;
            Continue;
          end;

          // Se é um caractere de espaço então, iremos adicionar strToken_Temp
          // a strTokens.
          if (pSeparador_Proximo^ in [#1..#32] = True) then
          begin
            while pHtml < pSeparador_Proximo do
            begin
              strToken_Temp := strToken_Temp + pHtml^;
              Inc(pHtml);
            end;
            Continue;
          end;

          // Se o primeiro caractere, é uma aspas simples ou dupla, iremos
          // percorrer até encontrar a outra aspas.
          if pSeparador_Proximo^ in ['''', '"'] then
          begin
            pFecha_Aspas := StrScan(pSeparador_Proximo + 1, pSeparador_Proximo^);

            // Se acharmos a outra aspa copia de pHtml até pFecha_Aspas.
            if pFecha_Aspas <> nil then
            begin
              while pHtml <= pFecha_Aspas do
              begin
                strToken_Temp := strToken_Temp + pHtml^;
                Inc(pHtml);
              end;
              Continue;
            end
            else
            begin
              // Não encontramos uma segunda aspas, então devemos adicionar
              // a strToken_Temp.
              while pHtml <= pSeparador_Proximo do
              begin
                strToken_Temp := strToken_Temp + pHtml^;
                Inc(pHtml);
              end;
              Continue;
            end;
          end;




          // *************************************************




          // Se chegarmos aqui, quer dizer, que não foi aspas simples nem dupla
          // Vamos verificar se foi espaço em branco, se for, iremos adicionar
          // todos os caracteres até chegar em

          // Esta condição manipula a situação, onde os tags, não tem propriedades
          // na forma propriedade=valor, mas tem atributos separados por espaço
          // e entre aspas, por exemplo, o tag <!DOCTYPE:
          // <!DOCTYPE
          // html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
          // >




          // O tag <!DOCTYPE não possue propriedade na forma: propriedade=valor
          // Então, iremos considerar tudo até encontrar o caractere '>', como
          // um único token.
          // Observe que entre '<!DOCTYPE' e '>', não pode haver o caractere '<', nem '='

          // <!DOCTYPE
          // html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
          // >

          // Há uma situação em html, que indica o namespace, geralmente há
          // espaço, onde o tag que fecha.
          //pFechar_Tag := StrScan(pHtml, '>');




          // Há um situação em que o tag mais interno é composto por um conjunto
          // de palavras, separados por espaço, devemos considerar tais palavras
          // como um único token.
          // Mas para detectarmos isto devemos, verificar todos os caracteres
          // após o espaço até chegar no caractere '<', entre todos os caracteres
          // e o caractere '<' não deve existir os caracteres '>' e '='
        end;



        // Geralmente, o caractere '=', separa propriedade do seu valor, geralmente
        // na forma: propriedade=valor
        '=':
        begin
          if strToken_Temp <> '' then
          begin
            strTokens.Add(strToken_Temp);
            strToken_Temp := '';
          end;
          strTokens.Add('=');
          Inc(pHtml);
        end;

        else
        begin
          strToken_Temp := strToken_Temp + pHtml^;
          if strToken_Temp = '"num_id' then
             strToken_Temp := strToken_Temp;

          Inc(pHtml);
        end;

      end;
    end;
  except
    on exc: Exception do
      raise exc;
  end;

  Exit(true);
end;

function THtml_Tokenizador.Analisar_Html(out strToken: TStrings): boolean;
begin
  // Se a função retornar ok, iremos atribuir o strToken da classe
  // ao strToken que o usuário forneceu, neste caso, se o 'TStrings' fornecido
  // pelo usuário já houver uma lista de string, ela será sobrescrita.
  if self.Analisar_Html = True then
  begin
    if strToken = nil then
    begin
      strToken := TStringList.Create;
    end;
    if Assigned(self.strTokens) then
    begin
       self.strTokens := self.strTokens;
    end;

    strToken.Assign(self.strTokens);


    // O 'TStrings' fornecido pelo usuário será sobescrito, se já houver ítens
    // na lista, a lista será perdida.
    //strToken.Assign(self.strTokens);
    //self.strTokens.Clear;
    //FreeAndNil(self.strTokens);
    Result := True;
  end
  else
  begin
    FreeAndNil(strToken);
    Result := False;
  end;
end;

function THtml_Tokenizador.Analisar_Html(conteudo_em_html: string;
			var strToken: TStrings): boolean;
begin
      self.html_Conteudo:= conteudo_em_html;
      Result := Analisar_Html(strToken);
end;


end.

