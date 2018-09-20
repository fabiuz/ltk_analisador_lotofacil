unit lotofacil_concursos;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, ZConnection, ZDataset, Dialogs, StdCtrls, lotofacil_constantes, Grids, IdHTTP,
    fpjson, strUtils, dateutils, IdGlobal, variants;

type
    TArrayInt = array of integer;

function obter_concursos(sql_conexao: TZConnection; var lista_de_concursos: TArrayInt; ordem_asc: string): boolean;

function obter_bolas_do_concurso(sql_conexao: TZConnection; concurso: integer;
    var bolas_do_concurso: TArrayInt): boolean;

function concurso_excluir(sql_conexao: TZConnection; concurso_numero: integer; status_erro: string): boolean;

procedure preencher_combobox_com_concursos(sql_conexao: TZConnection; cmb_controle: TComboBox; ordem_asc: string);

procedure baixar_novos_concursos(sql_conexao: TZConnection; sgr_controle: TStringGrid);
procedure exibir_concursos_importados(sql_conexao: TZConnection; sgr_controle: TStringGrid);
function gerar_sql_dinamicamente(lista_de_resultado_json: TStringList): string;

//procedure atualizar_controle_de_concursos(sql_conexao: TZConnection; cmb_controle: TComboBox);

implementation

{
 Retorna as bolas do concurso, se o número do concurso foi localizado
 na tabela 'lotofacil.lotofacil_resultado_bolas'.
 Se o concurso existe, a função retorna true, falso, caso contrário.
}
function obter_bolas_do_concurso(sql_conexao: TZConnection; concurso: integer;
    var bolas_do_concurso: TArrayInt): boolean;
var
    sql_query: TZQuery;
    uA: integer;
begin

    sql_query := TZQuery.Create(nil);
    sql_query.Connection := sql_conexao;
    sql_query.Sql.Clear;
    sql_query.Sql.Add('Select * from lotofacil.lotofacil_resultado_bolas');
    sql_query.Sql.Add('where concurso = ' + IntToStr(concurso));
    sql_query.Open;

    if sql_query.RecordCount <= 0 then
    begin
        bolas_do_concurso := nil;
        Exit(False);
    end;

    // Há 15 bolas, iremos criar um arranjo com 16 bolas, iremos
    // usar índices de 1 a 7.
    SetLength(bolas_do_concurso, 16);

    sql_query.First;

    for uA := 1 to 15 do
    begin
        bolas_do_concurso[uA] := sql_query.FieldByName('b_' + IntToStr(uA)).AsInteger;
    end;

    sql_query.Close;
    FreeAndNil(sql_query);

    Exit(True);
end;

{
 Retorna true, se o concurso foi excluído com sucesso da tabela no banco de dados.
 Se houver erro, false é retorna, e o parâmetro status_erro indica a mensagem de erro.
}
function concurso_excluir(sql_conexao: TZConnection; concurso_numero: integer; status_erro: string): boolean;
var
    sql_query: TZQuery;
begin
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Connection.Connected := False;
        sql_query.Connection.AutoCommit := False;

        sql_query.Sql.Add('Delete from lotofacil.lotofacil_resultado_num');
        sql_query.Sql.Add('where concurso =');
        sql_query.Sql.Add(IntToStr(concurso_numero));
        sql_query.ExecSql;
        sql_query.Connection.Commit;
        sql_query.Close;
        sql_query.Connection.Connected := False;
        FreeAndNil(sql_query);

    except
        On Exc: Exception do
        begin
            status_erro := Exc.Message;
            Exit(False);
        end;

    end;
    Exit(True);
end;

{
 Preenche um controle do tipo caixa de combinação com todos os concursos
 em ordem crescente ou decrescente.
}
procedure preencher_combobox_com_concursos(sql_conexao: TZConnection; cmb_controle: TComboBox; ordem_asc: string);
var
    uA: integer;
    lista_de_concursos: TArrayInt;
begin
    cmb_controle.Items.Clear;
    if not obter_concursos(sql_conexao, lista_de_concursos, ordem_asc) then
    begin
        Exit;
    end;
    for uA := 0 to High(lista_de_concursos) do
    begin
        cmb_controle.Items.Add(IntToStr(lista_de_concursos[uA]));
    end;
    cmb_controle.ItemIndex := 0;
end;

{
 Retorna todos os concursos, em ordem ascendente ou descente.
 A função retorna true, se há concursos, falso, caso contrário.
}
function obter_concursos(sql_conexao: TZConnection; var lista_de_concursos: TArrayInt; ordem_asc: string): boolean;
var
    sql_query: TZQuery;
    uA: integer;
    qt_registros: longint;
begin
    ordem_asc := LowerCase(ordem_asc);
    if (ordem_asc <> 'asc') and (ordem_asc <> 'desc') then
    begin
        ordem_asc := 'desc';
    end;

    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Connection.Connected := False;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select concurso from lotofacil.lotofacil_resultado_bolas');
        sql_query.Sql.Add('order by concurso');
        sql_query.Sql.Add(ordem_asc);
        sql_query.Open;
        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        if qt_registros <= 0 then
        begin
            sql_query.Close;
            sql_query.Connection.Connected := False;
            SetLength(lista_de_concursos, 0);
            Exit(False);
        end;

        SetLength(lista_de_concursos, qt_registros);
        sql_query.First;
        for uA := 0 to Pred(qt_registros) do
        begin
            lista_de_concursos[uA] := sql_query.FieldByName('concurso').AsInteger;
            sql_query.Next;
        end;

        sql_query.Close;
        sql_query.Connection.Connected := False;
        FreeAndNil(sql_query);

    except
        On Exc: Exception do
        begin
            MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
            Exit(False);
        end;
    end;

    Exit(True);
end;

{
 A procedure abaixo, conecta no site da caixa, em seguida, pega o último concurso
 sorteado, em seguida, de posse deste número, gera várias urls do último concurso ao
 primeiro concurso, em seguida, baixa o json de cada url, em seguida, analisa cada json
 e insere tais dados analisados na tabela 'd_sorte_resultado_importacao'.
 }
procedure baixar_novos_concursos(sql_conexao: TZConnection; sgr_controle: TStringGrid);
var
    ultimo_concurso, uA: integer;
    obj_http:   TIdHTTP;
    url_lotofacil, conteudo_recebido, sql_gerado: string;
    request:    TIdHTTPRequest;
    resultado_json: TJSONData;
    json_chave_valor: TJSONObject;
    json_valor: variant;
    lista_de_url, lista_de_resultado_json: TStringList;
    sql_query:  TZQuery;
begin
    // Pra obter o último concurso, deve-se enviar pra o webservice,
    // um concurso vazio e um timestamp da hora atual da solicitação.
    url_lotofacil := lotofacil_url_download;
    url_lotofacil := ReplaceText(url_lotofacil, '@timestamp@', IntToStr(DateTimeToUnix(Now)));
    url_lotofacil := ReplaceText(url_lotofacil, '@concurso@', '');

    // Agora, vamos enviar a requisição
    obj_http := TIdHTTP.Create;
    obj_http.AllowCookies := True;
    obj_http.HandleRedirects := True;
    ;
    try
        conteudo_recebido := obj_http.Get(url_lotofacil, IndyTextEncoding_UTF8);
        conteudo_recebido := LowerCase(conteudo_recebido);

    except
        On exc: EIdHTTPProtocolException do
        begin
            MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    // A requisição retorna um json, este json é um objeto
    resultado_json := GetJSON(conteudo_recebido);
    json_chave_valor := TJSONObject(resultado_json);

    if not Assigned(json_chave_valor) then
    begin
        MessageDlg('', 'Erro: Nenhum concurso localizado', mtError, [mbOK], 0);
        Exit;
    end;

    // Vamos obter o número do concurso.
    json_valor := json_chave_valor.Get('nu_concurso');
    if varType(json_valor) = varnull then
    begin
        MessageDlg('', 'Erro: Nenhum concurso localizado', mtError, [mbOK], 0);
        Exit;
    end;

    // Aqui, obtemos o número do concurso.
    ultimo_concurso := json_valor;

    // Os concursos são sorteados sequencialmente, então, iremos gerar, a url
    // pra cada concurso, indo do último ao primeiro concurso.
    lista_de_url := TStringList.Create;
    lista_de_url.Clear;
    for uA := ultimo_concurso downto 1 do
    begin
        url_lotofacil := lotofacil_url_download;
        url_lotofacil := ReplaceText(url_lotofacil, '@timestamp@', IntToStr(DateTimeToUnix(Now)));
        url_lotofacil := ReplaceText(url_lotofacil, '@concurso@', IntToStr(uA));
        lista_de_url.Add(url_lotofacil);
    end;

    // Agora, iremos fazer requisição pra o webservice pra obter o json de cada
    // url.
    lista_de_resultado_json := TStringList.Create;
    lista_de_resultado_json.Clear;
    for uA := 0 to Pred(lista_de_url.Count) do
    begin
        try
            url_lotofacil := lista_de_url.Strings[uA];
            conteudo_recebido := obj_http.Get(url_lotofacil, IndyTextEncoding_UTF8);
            conteudo_recebido := LowerCase(conteudo_recebido);
            lista_de_resultado_json.Add(conteudo_recebido);
            //if uA = 1707 then begin
            //    Writeln('');
            //end;

            Writeln('uA: ', uA);

        except
            On exc: Exception do
            begin
                // Isto, indica um erro no servidor, neste caso, devemos descartar esta requisição.
                // e continuar o processamento, este erro vai ocorrer no concurso de número 1.
                // Depois, irei criar um sql separadamente pra o concurso de número 1.
                if (obj_http.ResponseCode >= 500) and (obj_http.ResponseCode <= 599) then
                begin
                    //MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
                    continue;
                end;

                //MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
                //Exit;
            end;
        end;
    end;

    // Agora, irei gerar o sql de cada url, pra isto, irei analisar
    // cada json que foi obtido.
    sql_gerado := gerar_sql_dinamicamente(lista_de_resultado_json);

    // Agora, vamos inserir na tabela 'd_sorte.d_sorte_resultado_importacao'.
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Connection.AutoCommit := False;

        sql_query.Sql.Clear;
        sql_query.SQL.Add('Truncate lotofacil.lotofacil_resultado_importacao;');
        sql_query.Sql.Add(sql_gerado);
        sql_query.ExecSQL;
        sql_query.Connection.Commit;
        sql_query.Close;
    except
        ON Exc: Exception do
        begin
            sql_query.Connection.Rollback;
            sql_query.Close;

            MessageDlg('', 'Erro: ' + exc.Message, mtError, [mbOK], 0);
            Exit;
        end;
    end;

    // Se chegarmos aqui, quer dizer, que os concursos foram importados.
    exibir_concursos_importados(sql_conexao, sgr_controle);

end;

{
 Exibe em um controle TStringGrid, os concursos importados.
}
procedure exibir_concursos_importados(sql_conexao: TZConnection; sgr_controle: TStringGrid);
const
    sql_nome_dos_campos: array [0..37] of string = (
        'status',
        'status_ja_inserido',
        'concurso',
        'data',
        'data_proximo_concurso',
        'b_1',
        'b_2',
        'b_3',
        'b_4',
        'b_5',
        'b_6',
        'b_7',
        'b_8',
        'b_9',
        'b_10',
        'b_11',
        'b_12',
        'b_13',
        'b_14',
        'b_15',

        'qt_ganhadores_15_numeros',
        'qt_ganhadores_14_numeros',
        'qt_ganhadores_13_numeros',
        'qt_ganhadores_12_numeros',
        'qt_ganhadores_11_numeros',

        'rateio_15_numeros',
        'rateio_14_numeros',
        'rateio_13_numeros',
        'rateio_12_numeros',
        'rateio_11_numeros',

        'acumulado_15_numeros',
        'acumulado_14_numeros',

        'valor_arrecadado',
        'valor_acumulado_especial',
        'estimativa_premio',

        'concurso_especial',
        'sorteio_acumulado',
        'rateio_processamento');

    sgr_controle_cabecalho: array [0..37] of string = (
        'STATUS',
        'STATUS_JA_INSERIDO',
        'CONCURSO',
        'DATA',
        'DATA_PROX_CONC',
        'b_1',
        'b_2',
        'b_3',
        'b_4',
        'b_5',
        'b_6',
        'b_7',
        'b_8',
        'b_9',
        'b_10',
        'b_11',
        'b_12',
        'b_13',
        'b_14',
        'b_15',

        'QT_G_15_NUM',
        'QT_G_14_NUM',
        'QT_G_13_NUM',
        'QT_G_12_NUM',
        'QT_G_11_ACERTOS',

        'RATEIO_15_NUM',
        'RATEIO_14_NUM',
        'RATEIO_13_NUM',
        'RATEIO_12_NUM',
        'RATEIO_11_NUM',

        'ACUM_15_NUM',
        'ACUM_14_NUM',

        'VLR_ARRECADADO',
        'VLR_ACUM_ESPECIAL',
        'ESTIMATIVA_PREMIO',

        'CONCURSO_ESPECIAL',
        'SORTEIO_ACUMULADO',
        'RATEIO_PROCESSAMENTO');
var
    sql_query: TZQuery;
    coluna_atual_controle: TGridColumn;
    formato_brasileiro: TFormatSettings;
    valor_campo_atual, nome_do_campo: string;
    uA: integer;
    linha_atual, coluna_atual: integer;
    qt_registros: longint;
    numero_decimal: extended;
    data_concurso: TDateTime;
begin
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := sql_conexao;
        sql_query.Connection.AutoCommit := True;

        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select * from lotofacil.v_lotofacil_resultado_importacao');
        sql_query.Sql.Add('order by concurso desc');
        sql_query.Open;

        sql_query.First;
        sql_query.Last;
        qt_registros := sql_query.RecordCount;

        if qt_registros <= 0 then
        begin
            sgr_controle.Columns.Clear;
            coluna_atual_controle := sgr_controle.Columns.Add;
            coluna_atual_controle.Alignment := taCenter;
            sgr_controle.RowCount := 1;
            sgr_controle.Cells[0, 0] := 'Nenhum registro localizado.';
            sgr_controle.AutoSizeColumns;
            Exit;
        end;

        // Vamos configurar o controle.
        sgr_controle.Columns.Clear;
        for uA := 0 to High(sgr_controle_cabecalho) do
        begin
            coluna_atual_controle := sgr_controle.Columns.Add;
            coluna_atual_controle.Alignment := taCenter;
            coluna_atual_controle.Title.Caption := sgr_controle_cabecalho[uA];
            coluna_atual_controle.Title.Alignment := taCenter;
        end;
        sgr_controle.FixedRows := 1;
        sgr_controle.FixedCols := 0;

        // Vamos inserir os registros;
        // Haverá uma linha a mais por causa do cabeçalho.
        sgr_controle.RowCount := qt_registros + 1;
        sgr_controle.FixedCols := 0;

        // Os números decimais estão em formato americano, iremos
        // representar visualmente em formato brasileiro.
        formato_brasileiro.DecimalSeparator := ',';
        formato_brasileiro.DateSeparator := '-';
        formato_brasileiro.ThousandSeparator := '.';
        formato_brasileiro.LongDateFormat := 'dd-mm-yyyy';
        formato_brasileiro.ShortDateFormat := 'dd-mm-yyyy';

        sql_query.First;
        for linha_atual := 1 to qt_registros do
        begin
            for coluna_atual := 0 to High(sql_nome_dos_campos) do
            begin
                // Vamos pegar o nome do campo e o valor do campo
                nome_do_campo := sql_nome_dos_campos[coluna_atual];
                nome_do_campo := LowerCase(nome_do_campo);

                valor_campo_atual := sql_query.FieldByName(sql_nome_dos_campos[coluna_atual]).AsString;
                valor_campo_atual := LowerCase(valor_campo_atual);
                valor_campo_atual := Trim(valor_campo_atual);

                // Há três situações interessantes, há na tabela, campos do tipo boolean que retorna
                // um true, ou false, e há também campos do tipo numérico que tem dados nulos, neste
                // caso valor_campo_atual vai armazenar um string nulo, neste caso, ao passar
                // nas funções que convertem pra float pode ter problema, pra isto iremos manipular
                // esta situação.
                if (valor_campo_atual = '') or (valor_campo_atual = 'true') or
                    (valor_campo_atual = 'false') then
                begin
                    sgr_controle.Cells[coluna_atual, linha_atual] := valor_campo_atual;
                    Continue;
                end;



                Writeln('campo: ', nome_do_campo, ', valor: ', valor_campo_atual);


                // No banco de dados, os campos que tem o tipo decimal, o separador
                // de decimal é o ponto e não a vírgula, então, iremos manipular esta situação
                if (nome_do_campo = 'rateio_15_numeros') or (nome_do_campo =
                    'rateio_14_numeros') or (nome_do_campo = 'rateio_13_numeros') or
                    (nome_do_campo = 'rateio_12_numeros') or (nome_do_campo =
                    'rateio_11_numeros') or (nome_do_campo = 'valor_arrecadado') or
                    (nome_do_campo = 'valor_acumulado_especial') or
                    (nome_do_campo = 'estimativa_premio') then



                begin
                    numero_decimal := StrToFloat(valor_campo_atual);
                    sgr_controle.Cells[coluna_atual, linha_atual] := FloatToStr(numero_decimal, formato_brasileiro);
                end
                else if (nome_do_campo = 'data') or (nome_do_campo = 'data_proximo_concurso') then
                begin
                    data_concurso := StrToDate(valor_campo_atual, '-');
                    sgr_controle.Cells[coluna_atual, linha_atual] :=
                        DateToStr(data_concurso, formato_brasileiro);
                    valor_campo_atual := DateToStr(data_concurso, formato_brasileiro);
                end
                else
                begin
                    sgr_controle.Cells[coluna_atual, linha_atual] := valor_campo_atual;
                end;
            end;
            sql_query.Next;
        end;
        sgr_controle.AutoAdjustColumns;
    except
        On Exc: Exception do
        begin
            sgr_controle.Columns.Clear;
            coluna_atual_controle := sgr_controle.Columns.Add;
            coluna_atual_controle.Alignment := taCenter;
            sgr_controle.RowCount := 1;
            sgr_controle.Cells[0, 0] := Exc.Message;
            sgr_controle.AutoSizeColumns;
            FreeAndNil(sql_query);
            Exit;
        end;
    end;

    FreeAndNil(sql_query);

end;

{
 Aqui, iremos gerar o sql do json que foi retornado.
}
function gerar_sql_dinamicamente(lista_de_resultado_json: TStringList): string;
var
    json_data: TJsonData;

    // Há 25 bolas, o índice corresponde ao número da bola,
    // o índice 0 não é utilizado.
    lotofacil_bolas: array[0..25] of integer;

    // Concurso retorna somente 15 bolas.
    lotofacil_concurso_bolas: array[0..15] of integer;

    lista_de_sql:    TStringList;
    uA, uB, indice_bolas: integer;
    json_value:      variant;
    data_do_concurso: TDateTime;
    outra_data:      TDateTime;
    data_concurso:   array of string;
    data_convertida: array of string;
    bolas_ordenadas: TStringArray;
    bola_numero:     longint;
    sql_insert:      string;
    formato_numero_decimal: TFormatSettings;
    arquivo_sql:     Text;
begin
    // O sql será formado desta maneira.
    // Insert campo_1, campo_2 values (valor_1, valor_2), (valor_1, valor_2);
    lista_de_sql := TStringList.Create;
    lista_de_sql.Clear;

    for uA := 0 to Pred(lista_de_resultado_json.Count) do
    begin
        Writeln(lista_de_resultado_json.Strings[ua]);
        json_data := GetJSON(lista_de_resultado_json.Strings[ua]);


        // ============ NÚMERO DO CONCURSO. ==================
        json_value := TJsonObject(json_data).Get('nu_concurso');
        if vartype(json_value) = varnull then
        begin
            continue;
        end;
        if uA <> 0 then
        begin
            lista_de_sql.Add(',');
        end;
        lista_de_sql.Add('(');
        lista_de_sql.Add(json_value);
        if json_value = 428 then
            Writeln('Erro.');

        if json_value = 3 then
        begin
            writeln('');
        end;

        // ============ DATA ======================
        // Aqui, a data está em formato brasileiro, interseparados
        // pelo caractere '/'.
        json_value := TJsonObject(json_data).Get('dt_apuracaostr');
        data_concurso := string(json_value).Split('/');
        if Length(data_concurso) <> 3 then
        begin
            MessageDlg('', 'Erro, data: ' + json_value + ' incorreto.',
                mtError, [mbOK], 0);
            Exit;
        end;
        // O arranjo está desta forma:
        // dia-mes-ano.
        // data_concurso[0] := dia
        // data_concurso[1] := mes
        // data_concurso[2] := ano
        SetLength(data_convertida, 3);
        // Iremos organizar a data neste formato:
        // ano-mes-dia.
        data_convertida[0] := data_concurso[2];
        data_convertida[1] := data_concurso[1];
        data_convertida[2] := data_concurso[0];
        lista_de_sql.Add(',' + QuotedStr(data_convertida[0] + '-' + data_convertida[1] +
            '-' + data_convertida[2]));

        // ============ DATA PRÓXIMO CONCURSO ======================
        // Aqui, a data está em formato brasileiro, interseparados
        // pelo caractere '/'.
        json_value := TJsonObject(json_data).Get('dtproximoconcursostr');
        if vartype(json_value) = varnull then
        begin
            lista_de_sql.Add(', null');
        end
        else
        begin
            data_concurso := string(json_value).Split('/');
            if Length(data_concurso) <> 3 then
            begin
                MessageDlg('', 'Erro, data: ' + json_value + ' incorreto.',
                    mtError, [mbOK], 0);
                Exit;
            end;
            // A data está neste formato:
            // dia-mes-ano.
            // data_concurso[0] := dia
            // data_concurso[1] := mes
            // data_concurso[2] := ano
            SetLength(data_convertida, 3);
            // Irei organizar a data neste formato:
            // ano-mes-dia.
            data_convertida[0] := data_concurso[2];
            data_convertida[1] := data_concurso[1];
            data_convertida[2] := data_concurso[0];
            lista_de_sql.Add(',' + QuotedStr(data_convertida[0] + '-' + data_convertida[1] +
                '-' + data_convertida[2]));
        end;

        // ================= BOLAS SORTEADAS =======================
        // No json, o campo resultadoordenado, armazena as bolas interseparadas
        // pelo caractere '-'
        json_value := TJsonObject(json_data).Get('resultadoordenado');
        bolas_ordenadas := string(json_value).Split('-');
        if Length(bolas_ordenadas) <> 15 then
        begin
            MessageDlg('', 'Erro, nao há 15 bolas no concurso.', mtError, [mbOK], 0);
            Exit;
        end;
        // Não iremos confiar no webservice, sempre devemos verificar por bolas
        // duplicadas e foram de ordem.
        // As bolas correspondem os índices do vetor, por isso, devemos
        FillChar(lotofacil_bolas, 26 * sizeof(integer), 0);
        for uB := 0 to Pred(Length(bolas_ordenadas)) do
        begin
            try
                // Verificar se o número da bola é válida pra aquele jogo.
                bola_numero := StrToInt(bolas_ordenadas[uB]);
                if (bola_numero < 1) or (bola_numero > 25) then
                begin
                    MessageDlg('', 'Erro, bola inválida: ' + IntToStr(bola_numero),
                        mtError, [mbOK], 0);
                    Exit;
                end;
            except
                On Exc: Exception do
                begin
                    MessageDlg('', 'Erro: ' + Exc.Message, mtError, [mbOK], 0);
                    Exit;
                end;
            end;
            // Verifica bolas duplicadas.
            if lotofacil_bolas[bola_numero] = 1 then
            begin
                MessageDlg('', 'Erro, bola já foi sorteada', mtError, [mbOK], 0);
                Exit;
            end;
            lotofacil_bolas[bola_numero] := 1;
        end;

        // Pega as bolas ordenadas.
        indice_bolas := 0;
        for uB := 1 to 25 do
        begin
            if lotofacil_bolas[uB] = 1 then
            begin
                lotofacil_concurso_bolas[indice_bolas] := uB;
                Inc(indice_bolas);
                if indice_bolas = 15 then
                begin
                    break;
                end;
            end;
        end;

        // Gera o sql dinamicamente.
        // As bolas está armazenada de 0 a 14.
        for uB := 0 to Pred(Length(bolas_ordenadas)) do
        begin
            lista_de_sql.Add(', ' + IntToStr(lotofacil_concurso_bolas[uB]));
        end;

        // ============================================================
        // Aqui, iremos pegar os valores dos campos:
        // qt_ganhador_faixa_1, que corresponde a quantidade de ganhadores de 15 números.
        // qt_ganhador_faixa_2, que corresponde a quantidade de ganhadores de 14 números.
        // qt_ganhador_faixa_3, que corresponde a quantidade de ganhadores de 13 números.
        // qt_ganhador_faixa_4, que corresponde a quantidade de ganhadores de 12 números.
        // qt_ganhador_faixa_5, que corresponde a quantidade de ganhadores de 11 números.
        // Tais números são números inteiros e não decimais, nenhuma conversão necessária.
        for uB := 1 to 5 do
        begin
            json_value := TJsonObject(json_data).Get('qt_ganhador_faixa' + IntToStr(uB));
            lista_de_sql.Add(',' + IntToStr(json_value));
            Writeln(FloatToStr(json_value));
        end;

        // ============================================================
        // Aqui, iremos pegar os valores dos campos:
        // qt_rateio_faixa_1, que corresponde ao valor que cada ganhador de 15 acertos recebeu.
        // qt_rateio_faixa_2, que corresponde ao valor que cada ganhador de 14 acertos recebeu.
        // qt_rateio_faixa_3, que corresponde ao valor que cada ganhador de 13 acertos recebeu.
        // qt_rateio_faixa_4, que corresponde ao valor que cada ganhador de 12 acertos recebeu.
        // qt_rateio_faixa_5, que corresponde ao valor que cada ganhador de 11 acertos recebeu.
        // Aqui, o número está no formato americano.
        formato_numero_decimal.DecimalSeparator := '.';
        formato_numero_decimal.ThousandSeparator := ',';
        for uB := 1 to 5 do
        begin
            json_value := TJsonObject(json_data).Get('vr_rateio_faixa' + IntToStr(uB));
            lista_de_sql.Add(',' + FloatToStr(double(json_value), formato_numero_decimal));
            Writeln(FloatToStr(double(json_value), formato_numero_decimal));
        end;

        // ================ VALOR ACUMULADO FAIXA 1 ====================
        // No json, 'vracumuladofaixa1' está em formato numérico brasileiro.
        // Ele pode ser nulo, devemos evitar isto.
        json_value := TJsonObject(json_data).Get('vracumuladofaixa1');
        if vartype(json_value) = varnull then
        begin
            lista_de_sql.Add(', null');
        end
        else
        begin
            formato_numero_decimal.DecimalSeparator := ',';

            // Se fossemos converter um string numérico em formato brasileiro, sem especificar,
            // o formato do número, StrToFloat, espera que o número esteja em formato americano,
            // por isso, devemos explicitar que o string tem um formato numérico do brasil.
            json_value := ReplaceText(json_value, '.', '');
            json_value := StrToFloat(json_value, formato_numero_decimal);

            // Observe agora, que json_value, está em formato americano, pois float, são números
            // decimais com ponto, sempre será desta forma, se quisermos converter pra o formato
            // brasileiro, era simplesmente informar com isto, neste caso, não precisamos mais
            // mais pra garantir iremos explicitar que quando converter de float pra string,
            // o formato seja americano pois, sql espera receber um número em formato americano.
            formato_numero_decimal.DecimalSeparator := '.';
            formato_numero_decimal.ThousandSeparator := ',';
            lista_de_sql.Add(',' + FloatToStr(double(json_value), formato_numero_decimal));
            Writeln(FloatToStr(double(json_value), formato_numero_decimal));
        end;

        // ================ VALOR ACUMULADO FAIXA 2 ====================
        // No json, 'vracumuladofaixa2' está em formato numérico brasileiro.
        json_value := TJsonObject(json_data).Get('vracumuladofaixa2');
        if vartype(json_value) = varnull then
        begin
            lista_de_sql.Add(', null');
        end
        else
        begin
            formato_numero_decimal.DecimalSeparator := ',';

            // Se fossemos converter um string numérico em formato brasileiro, sem especificar,
            // o formato do número, StrToFloat, espera que o número esteja em formato americano,
            // por isso, devemos explicitar que o string tem um formato numérico do brasil.
            json_value := ReplaceText(json_value, '.', '');
            json_value := StrToFloat(json_value, formato_numero_decimal);

            // Observe agora, que json_value, está em formato americano, pois float, são números
            // decimais com ponto, sempre será desta forma, se quisermos converter pra o formato
            // brasileiro, era simplesmente informar com isto, neste caso, não precisamos mais
            // mais pra garantir iremos explicitar que quando converter de float pra string,
            // o formato seja americano pois, sql espera receber um número em formato americano.
            formato_numero_decimal.DecimalSeparator := '.';
            lista_de_sql.Add(',' + FloatToStr(double(json_value), formato_numero_decimal));
            Writeln(FloatToStr(double(json_value), formato_numero_decimal));

            // ======================= Valor arrecadado =====================
            // O campo 'vrarrecadado' está em formato numérico brasileiro.
            json_value := TJsonObject(json_data).Get('vrarrecadado');
            if vartype(json_value) = varnull then
            begin
                lista_de_sql.Add(', null');
            end
            else
            begin
                formato_numero_decimal.DecimalSeparator := ',';
                // Retirar o separador de milhar, pois o número está em formato brasileiro.
                // e a função StrToCurr não aceita o separador de milhar ao realizar a conversão.
                json_value := ReplaceText(json_value, '.', '');
                json_value := StrToFloat(json_value, formato_numero_decimal);
                // Agora converter em formato numérico americano.
                formato_numero_decimal.DecimalSeparator := '.';
                lista_de_sql.Add(',' + FloatToStr(double(json_value), formato_numero_decimal));
                Writeln(FloatToStr(double(json_value), formato_numero_decimal));
            end;
        end;

        // ======================= Valor acumulado especial ================
        // O campo 'vracumuladoespecial' está em formato numérico brasileiro
        formato_numero_decimal.DecimalSeparator := ',';
        // Retirar o separador de milhar, pois o número está em formato brasileiro.
        // e a função StrToFloat não aceita o separador de milhar ao realizar a conversão.
        json_value := TJsonObject(json_data).Get('vracumuladoespecial');
        if vartype(json_value) = varnull then
        begin
            lista_de_sql.Add(', null');
        end
        else
        begin
            formato_numero_decimal.DecimalSeparator := ',';
            json_value := ReplaceText(json_value, '.', '');
            json_value := StrToFloat(json_value, formato_numero_decimal);
            // Agora converter em formato americano.
            formato_numero_decimal.DecimalSeparator := '.';
            lista_de_sql.Add(',' + FloatToStr(double(json_value), formato_numero_decimal));
            Writeln(FloatToStr(double(json_value), formato_numero_decimal));
        end;

        // ===================== ESTIMATIVA ===========================
        // O campo 'vrestimativa' está em formato numérico brasileiro.
        json_value := TJsonObject(json_data).Get('vrestimativa');
        if vartype(json_value) = varnull then
        begin
            lista_de_sql.Add(', null');
        end
        else
        begin
            formato_numero_decimal.DecimalSeparator := ',';
            json_value := ReplaceText(json_value, '.', '');
            json_value := StrToFloat(json_value, formato_numero_decimal);
            // Agora, converter em formato americano.
            formato_numero_decimal.DecimalSeparator := '.';
            lista_de_sql.Add(',' + FloatToStr(double(json_value), formato_numero_decimal));
            Writeln(FloatToStr(double(json_value), formato_numero_decimal));
        end;

        // ======================= é um concurso especial ======================
        json_value := TJsonObject(json_data).Get('ic_concurso_especial');
        if json_value = True then
        begin
            lista_de_sql.add(',true');
        end
        else if json_value = False then
        begin
            lista_de_sql.Add(',false');
        end
        else
        begin
            lista_de_sql.Add(',null');
        end;

        // =================== sorteio acumulado =====================
        json_value := TJsonObject(json_data).Get('sorteio_acumulado');
        if json_value = True then
        begin
            lista_de_sql.add(',true');
        end
        else if json_value = False then
        begin
            lista_de_sql.Add(',false');
        end
        else
        begin
            lista_de_sql.Add(',null');
        end;

        // =================== Rateio processamento ==================
        json_value := TJsonObject(json_data).Get('rateioprocessamento');
        if json_value = True then
        begin
            lista_de_sql.add(',true');
        end
        else if json_value = False then
        begin
            lista_de_sql.Add(',false');
        end
        else
        begin
            lista_de_sql.Add(',null');
        end;

        // Fecha o insert do registro atual
        lista_de_sql.Add(')');

    end;

    // Gera o cabeçãlho do insert, observe que a ordem dos campos
    // tem que ser igual ao insert dos valores, no loop for acima,
    // se o usuário alterar o valor dos insert de posição, deve-se
    // alterar este cabeçalho.
    sql_insert := 'Insert into lotofacil.lotofacil_resultado_importacao(';
    sql_insert := sql_insert + 'concurso, data, data_proximo_concurso,';
    sql_insert := sql_insert + 'b_1, b_2, b_3, b_4, b_5, b_6, b_7, b_8, b_9, b_10, b_11, b_12, b_13, b_14, b_15';
    sql_insert := sql_insert + ',qt_ganhadores_15_numeros';
    sql_insert := sql_insert + ',qt_ganhadores_14_numeros';
    sql_insert := sql_insert + ',qt_ganhadores_13_numeros';
    sql_insert := sql_insert + ',qt_ganhadores_12_numeros';
    sql_insert := sql_insert + ',qt_ganhadores_11_numeros';
    //sql_insert := sql_insert + ',qt_ganhadores_mes_de_sorte';
    sql_insert := sql_insert + ',rateio_15_numeros';
    sql_insert := sql_insert + ',rateio_14_numeros';
    sql_insert := sql_insert + ',rateio_13_numeros';
    sql_insert := sql_insert + ',rateio_12_numeros';
    sql_insert := sql_insert + ',rateio_11_numeros';

    sql_insert := sql_insert + ', acumulado_15_numeros';
    sql_insert := sql_insert + ', acumulado_14_numeros';

    sql_insert := sql_insert + ', valor_arrecadado';
    sql_insert := sql_insert + ', valor_acumulado_especial';
    sql_insert := sql_insert + ', estimativa_premio';

    sql_insert := sql_insert + ', concurso_especial';
    sql_insert := sql_insert + ', sorteio_acumulado';
    sql_insert := sql_insert + ', rateio_processamento';

    sql_insert := sql_insert + ') values';

    lista_de_sql.Insert(0, sql_insert);
    Exit(lista_de_sql.Text);
end;

end.
