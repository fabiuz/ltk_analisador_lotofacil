unit lotofacil_id_classificado;

{$mode objfpc}{$H+}

interface

uses
    Classes, SysUtils, ZConnection, ZDataset, fgl, strutils, Dialogs, sqldb, DB,
    pqconnection;

type
    TList_Int = specialize TFPGList<integer>;

    TStatus = procedure(AStatus: string) of object;
    TStatus_Error = procedure(AErro: string) of object;

type


    { TLotofacil_id_classificado }

    TLotofacil_id_classificado = class(TThread)
    private
        FInterromper: boolean;
        FSql_Conexao: TZConnection;
        FStatus:      TStatus;
        FStatus_Mensagem: string;
        FStatus_Error: TStatus_Error;
        FStatus_Error_Mensagem: string;
        procedure Gerar_id_classificado;
        procedure SetInterromper(AValue: boolean);
        procedure SetSql_Conexao(AValue: TZConnection);
        procedure SetStatus(AValue: TStatus);
        procedure SetStatus_Error(AValue: TStatus_Error);
        procedure DoStatus;
        procedure DoStatus_Erro;
    public
        constructor Create(CreateSuspended: boolean);
        procedure Execute; override;
        property Sql_Conexao: TZConnection read FSql_Conexao write SetSql_Conexao;

        property OnStatus: TStatus read FStatus write SetStatus;
        property OnStatus_Error: TStatus_Error read FStatus_Error write SetStatus_Error;

        property Interromper: boolean read FInterromper write SetInterromper;
    end;

implementation

{ TLotofacil_id_classificado }

procedure TLotofacil_id_classificado.SetStatus(AValue: TStatus);
begin
    if FStatus = AValue then
        Exit;
    FStatus := AValue;
end;

procedure TLotofacil_id_classificado.SetStatus_Error(AValue: TStatus_Error);
begin
    if FStatus_Error = AValue then
        Exit;
    FStatus_Error := AValue;
end;

procedure TLotofacil_id_classificado.DoStatus;
begin
    if Assigned(FStatus) then
    begin
        FStatus(fStatus_Mensagem);
    end;
end;

procedure TLotofacil_id_classificado.DoStatus_Erro;
begin
    if Assigned(FStatus_Error) then
    begin
        FStatus_Error(FStatus_Error_Mensagem);
    end;
end;

constructor TLotofacil_id_classificado.Create(CreateSuspended: boolean);
begin
    inherited Create(CreateSuspended);
    FInterromper := False;
end;

procedure TLotofacil_id_classificado.Execute;
begin
    Gerar_id_classificado;
end;

{
 Nesta procedure iremos pegar em cada campo, da tabela 'lotofacil_id' o menor id e o maior id,
 em seguida, iremos gerar pra cada campo, um vetor com o comprimento igual ao maior id + 1 do campo,
 correspondente.
 Cada id pra cada campo, terá um identificador sequencial exclusivo.
 O objetivo disto é que quando formos utilizar o analisador lotofacil, os ids escolhidos no filtros
 sairá em grupos, por exemplo, se escolhermos 3 ids que corresponde a combinação par x ímpar,
 se ordenar pelo campo 'par_impar_id' da tabela 'lotofacil_id_classificado', sempre, a cada 3 registros,
 os 3 ids sairá, ou seja, não terá ids repetidos, pode ocorrer repetição, no caso, de outros filtros
 escolhidos, pois, pode ocorrer alguma combinação par x ímpar não sair, por que a combinação de 15
 bolas ter sido excluída de outra tipo de combinação.
}
procedure TLotofacil_id_classificado.Gerar_id_classificado;
const
    LOTOFACIL_TOTAL_DE_COMBINACOES = 6874010;
const
    // Não iremos utilizar os campos ltf_id e ltf_qt,
    campos_da_tabela: string = 'ltf_id,ltf_qt,par_impar_id,prm_id' +
        ',ext_int_id,hrz_id,vrt_id,dge_id,dgd_id,esq_dir_id' +
        ',sup_inf_id,sup_esq_inf_dir_id,sup_dir_inf_esq_id' +
        ',crz_id,lsng_id,qnt_id,trng_id,trio_id,x1_x2_id' + ',dz_id,un_id,alg_id,sm_bolas_id,sm_alg_id,lc_id' +
        ',bin_par_id,bin_impar_id,bin_primo_id,bin_nao_primo_id' +
        ',bin_ext_id,bin_int_id,bin_hrz_1_id,bin_hrz_2_id,bin_hrz_3_id' +
        ',bin_hrz_4_id,bin_hrz_5_id,bin_vrt_1_id,bin_vrt_2_id,bin_vrt_3_id' +
        ',bin_vrt_4_id,bin_vrt_5_id,bin_dge_1_id,bin_dge_2_id,bin_dge_3_id' +
        ',bin_dge_4_id,bin_dge_5_id,bin_dgd_1_id,bin_dgd_2_id,bin_dgd_3_id' +
        ',bin_dgd_4_id,bin_dgd_5_id,bin_esq_id,bin_dir_id,bin_sup_id,bin_inf_id' +
        ',bin_sup_esq_id,bin_inf_dir_id,bin_sup_dir_id,bin_inf_esq_id,bin_crz_1_id' +
        ',bin_crz_2_id,bin_crz_3_id,bin_crz_4_id,bin_crz_5_id' +
        ',bin_lsng_1_id,bin_lsng_2_id,bin_lsng_3_id,bin_lsng_4_id,bin_lsng_5_id' +
        ',bin_qnt_1_id,bin_qnt_2_id,bin_qnt_3_id,bin_qnt_4_id,bin_qnt_5_id' +
        ',bin_trng_1_id,bin_trng_2_id,bin_trng_3_id,bin_trng_4_id' +
        ',bin_trio_1_id,bin_trio_2_id,bin_trio_3_id,bin_trio_4_id,bin_trio_5_id' +
        ',bin_trio_6_id,bin_trio_7_id,bin_trio_8_id,bin_x1_id,bin_x2_id' +
        ',bin_dz_0_id,bin_dz_1_id,bin_dz_2_id' + ',bin_lc_1_id,bin_lc_2_id,bin_lc_3_id,bin_lc_4_id,bin_lc_5_id';
var
    lista_de_minimo: TList_Int;
    lista_de_maximo: TList_Int;
    campos, linhas_do_arquivo, campos_por_linha, valores_por_campo: TStringArray;
    sql_minimo, sql_maximo, arquivo_csv, campo_modificado, arquivo_exportado, conteudo, conteudo_convertido: string;
    uA, total_de_campos, uB, qt_campos, indice_campo_ltf_id, indice_campo_ltf_qt, qt_registros,
    indice_registros, indice_lotofacil_id, ultimo_indice: integer;
    id_seq_exclusivo: array of array of integer;
    lotofacil_id_combinacoes: array of array of integer;
    arquivo_conteudo: TFileStream;
    tamanho:   int64;
    f_arquivo: Text;
    f_lotofacil_id: Text;
    f_lotofacil_id_classificado: Text;
    arquivo_linha_atual, arquivo_exportado_classificado, lotofacil_id_exportado_csv,
    lotofacil_id_classificado_csv: string;
    id_atual:  longint;
    id_sequencial: longint;
    ltf_id, ltf_qt: string;
    outra_conexao: TPQConnection;
    sql_query: TZQuery;
    outro_sql: TSQLQuery;
    parametro_atual: TParam;
    valor_campo_ltf_id: integer;
    valor_campo_ltf_qt, qt_registros_lidos, penultimo_indice: integer;
begin
    // Vamos obter os valores mínimo e máximo de cada campo.
    // Pra isto, iremos retirar os campos 'ltf_id' e 'ltf_qt', pois
    // não precisamos saber o valor mínimo e máximo de tais campos.
    campos := ReplaceText(campos_da_tabela, 'ltf_id,ltf_qt,', '').Split(',');

    // Pra isto, iremos gerar o sql dinamicamente.
    sql_minimo := '';
    sql_maximo := '';

    // Aqui, irei gerar dois sql, onde iremos, em um dos sql
    // pegar o menor número pra cada campo e no outro sql
    // iremos pegar o maior número pra cada campo.
    for uA := 0 to High(Campos) do
    begin
        // Vamos interseparar os campos pelo caractere ',', ficará assim:
        // min_par_impar_id,min_prm_id,ext_int_id, por isto, só iremos
        // colocar ',' (vírgula) após o primeiro campo ser inserido.
        if sql_minimo <> '' then
        begin
            sql_minimo := sql_minimo + ',';
        end;
        if sql_maximo <> '' then
        begin
            sql_maximo := sql_maximo + ',';
        end;

        // Em todos os campos, iremos prefixar as palavras 'min_' e 'max_'
        sql_minimo := sql_minimo + 'min(' + campos[ua] + ') as min_' + campos[uA];
        sql_maximo := sql_maximo + 'max(' + campos[uA] + ') as max_' + campos[uA];

    end;

    sql_minimo := 'Select ' + sql_minimo + ' from lotofacil.lotofacil_id';
    sql_maximo := 'Select ' + sql_maximo + ' from lotofacil.lotofacil_id';

    // Agora, iremos pegar os valores mínimos e máximo e inserir
    // nas listas: 'lista_minimo' e 'lista_maximo'.
    try
        sql_query := TZQuery.Create(nil);
        sql_query.Connection := FSql_Conexao;

        // Vamos obter os valores mínimo e máximo
        // Obtendo valor mínimo:
        sql_query.Sql.Clear;
        sql_query.Sql.Add(sql_minimo);
        sql_query.Open;
        sql_query.First;

        lista_de_minimo := TList_Int.Create;
        lista_de_minimo.Clear;
        for uA := 0 to Pred(sql_query.Fields.Count) do
        begin
            lista_de_minimo.Add(sql_query.Fields[uA].AsInteger);
        end;

        // Obtendo valor máximo.
        sql_query.Close;
        sql_query.Sql.Clear;
        sql_query.Sql.Add(sql_maximo);
        sql_query.Open;
        sql_query.First;

        lista_de_maximo := TList_Int.Create;
        lista_de_maximo.Clear;
        for uA := 0 to Pred(sql_query.Fields.Count) do
        begin
            lista_de_maximo.Add(sql_query.Fields[uA].AsInteger);
        end;

        // Cria um arranjo bidimensional, onde a primeira dimensão
        // indica a quantidade de campos, e onde a segunda dimensão
        // indica a quantidade de ítens relacionados ao id.
        SetLength(id_seq_exclusivo, Length(campos) + 1);

        // Observe que no arranjo bidimensional 'id_seq_exclusivo', a primeira dimensão
        // indica qual campos estamos, por exemplo, o primeiro campo está no índice 0,
        // da dimensão 0, que representa o campo 'par_impar_id',
        // na segunda dimensão, cada índice representa o id da combinação 'par_impar_id',
        // então, por exemplo, na tabela lotofacil_id_par_impar, há 38 registros, onde
        // o id vai de 1 a 38, então, na dimensão 1, do arranjo 'id_seq_exclusivo'
        // teremos 39 posição, de 0 a 38.
        // Observe, que o arranjo é baseado em 'zero' e não 'um', por isso colocamos
        // mais 1.
        for uA := 0 to Pred(Length(campos)) do
        begin
            SetLength(id_seq_exclusivo[uA], lista_de_maximo.Items[uA] + 1);
        end;

        // Aqui, iremos criar um arranjo bidimensional, com todas as combinações, em seguida,
        // irei reaproveitar este arranjo.
        // Observe que o arranjo 'campos', não tem os campos 'ltf_id' e 'ltf_qt', por isso,
        // adicionaremos mais 3 ítens, um para o campo 'ltf_id', um pra o campo 'ltf_qt' e
        // mais um campo pois, o índice é baseado em '0'.
        //SetLength(lotofacil_id_combinacoes, LOTOFACIL_TOTAL_DE_COMBINACOES + 1, Length(campos) + 3);

        // Vamos exportar a tabela lotofacil.lotofacil_id, usando o comando copy.
        {$IFDEF LINUX}
        lotofacil_id_exportado_csv := '/tmp/lotofacil_id_exportado.csv';
        lotofacil_id_classificado_csv := '/tmp/lotofacil_id_classificado.csv';
        {$ELSE}
               {$IFDEF MAC}
        lotofacil_id_exportado_csv := '/tmp/lotofacil_id_exportado.csv';
        lotofacil_id_classificado_csv := '/tmp/lotofacil_id_classificado.csv';
               {$ELSE}
        lotofacil_id_exportado_csv := 'c:\tmp\lotofacil_id_exportado.csv';
        lotofacil_id_classificado_csv := 'c:\tmp\lotofacil_id_classificado.csv';
               {$ENDIF}
        {$ENDIF}

        // Observe no arranjo 'campos', os campos 'ltf_id' e 'ltf_qt' não existe,
        // e no arranjo 'id_seq_exclusivo', a dimensão '0', representa os campos
        // que são os valores que estão no arranjo 'campos', no código abaixo,
        // iremos acrescentar os campos 'ltf_id' e 'ltf_qt' que faltam pois,
        // agora iremos pegar todos os registros da tabela 'lotofacil_id',
        // pra isto, iremos inserir os campos 'ltf_id' e 'ltf_qt' no final.
        // Assim, ficará mais fácil mapear os campos do arranjos 'campos'
        // diretamente, na mesma posição da dimensão '0' do arranjo 'id_seq_exclusivo'.
        campo_modificado := ReplaceText(campos_da_tabela, 'ltf_id,ltf_qt,', '');
        campo_modificado := campo_modificado + ',ltf_id,ltf_qt';
        qt_campos := Length(campo_modificado.Split(','));

        // Vamos exportar a tabela pra um arquivo *.csv, assim ficará
        // mais fácil analisar todas as linhas, rapidamente.
        sql_query.SQL.Clear;
        sql_query.Sql.Add('Copy (Select ' + campo_modificado +
            ' from lotofacil.lotofacil_id order by ltf_id) to ' +
            QuotedStr(lotofacil_id_exportado_csv) + ' with (delimiter '','', format csv, header true)');
        sql_query.Open;
        sql_query.Close;

        // No arquivo 'lotofacil_id.csv' que foi gerado através da exportação
        // da tabela 'lotofacil.lotofacil_id', na primeira linha temos o cabeçalho
        // e nas demais linhas os dados.
        // Cada campo está separado pelo caractere ';'
        Assign(f_lotofacil_id, lotofacil_id_exportado_csv);
        Reset(f_lotofacil_id);

        if IoResult <> 0 then
        begin
            FStatus_Mensagem := 'Erro, ao abrir arquivo pra leitura.';
            raise Exception.Create(FStatus_Mensagem);
            Exit;
        end;

        // Abrir arquivo pra gravação.
        Assign(f_lotofacil_id_classificado, lotofacil_id_classificado_csv);
        Rewrite(f_lotofacil_id_classificado);

        if IoResult <> 0 then
        begin
            FStatus_Mensagem := 'Erro ao abrir arquivo lotofacil_id_classificado.csv pra gravação';
            raise Exception.Create(FStatus_Mensagem);
            Exit;
        end;

        // Vamos ler o arquivo e obter os ids sequenciais.

        // Obtém o cabeçalho na primeira linha e grava no arquivo de destino.
        Readln(f_lotofacil_id, arquivo_linha_atual);
        Write(f_lotofacil_id_classificado, arquivo_linha_atual);

        qt_registros_lidos := 0;
        arquivo_linha_atual := '';
        while not EOF(f_lotofacil_id) do
        begin

            // Obtém a linha atual e cria um arranjo
            Readln(f_lotofacil_id, arquivo_linha_atual);
            valores_por_campo := arquivo_linha_atual.Split(',');

            // Verifica se a quantidade de campos é igual à quantidade de campos que foi gravado.
            if Length(valores_por_campo) <> qt_campos then
            begin
                FStatus_Mensagem := Format('Erro, linha: %d, quantidade de campos é diferente da ' +
                    'quantidade de campos que foi gerado.', [qt_registros_lidos]);
                raise Exception.Create(FStatus_Mensagem);
                Exit;
            end;

            // Agora, vamos percorrer todos os campos e gerar o id sequencial exclusivo.
            for uB := 0 to Pred(qt_campos - 2) do
            begin
                id_atual := StrToInt(valores_por_campo[uB]);

                // A primeira dimensão do arranjo 'id_seq_exclusivo' indica
                // qual campos queremos analisar, a segunda dimensão, armazena
                // pra cada id possível daquele campo, qual é o id sequencial atual.
                id_sequencial := id_seq_exclusivo[uB, id_atual];

                // Toda vez, que o id for encontrado, iremos incrementar o contador sequencial
                // referente àquele id, em cada campo, haverá um contador sequencial exclusivo
                // pra cada id.
                Inc(id_sequencial);
                id_seq_exclusivo[uB, id_atual] := id_sequencial;

                // Agora, iremos gravar no arquivo, cada campo
                if uB <> 0 then
                begin
                    Write(f_lotofacil_id_classificado, ',');
                end
                else
                begin
                    Write(f_lotofacil_id_classificado, LineEnding);
                end;
                Write(f_lotofacil_id_classificado, id_sequencial);
            end;
            // Observe que no for, desconsidere os dois últimos campos
            // que são 'ltf_id' e 'ltf_qt', pois ele não precisam
            // ser obtidos um identificador serial exclusivo, neste caso,
            // iremos simplesmente, repetir no arquivo de destino.
            ultimo_indice := Pred(qt_campos);
            penultimo_indice := ultimo_indice - 1;
            ltf_qt := valores_por_campo[ultimo_indice];
            ltf_id := valores_por_campo[penultimo_indice];
            Write(f_lotofacil_id_classificado, ',' + ltf_id + ',' + ltf_qt);

            if Interromper then
            begin
                FStatus_Mensagem := FStatus_Mensagem + ', cancelamento solicitado pelo usuário.';
                raise Exception.Create(FStatus_Mensagem);
                Exit;
            end;

            Inc(qt_registros_lidos);
            if qt_registros_lidos mod 100000 = 0 then
            begin
                FStatus_Mensagem := 'Registros lidos: ' + IntToStr(qt_registros_lidos);
                Synchronize(@DoStatus);
            end;
        end;

        // Fecha arquivos.
        Close(f_lotofacil_id);
        Close(f_lotofacil_id_classificado);

        // Vamos verificar se houve 6874010 registros.
        if qt_registros_lidos <> 6874010 then
        begin
            FStatus_Mensagem := 'Erro, não há 6874010 registros no arquivo.';
            raise Exception.Create(FStatus_Mensagem);
            Exit;
        end;

        FStatus_Mensagem:='6874010 registros lidos, OK.';
        Synchronize(@DoStatus);

        // Vamos copiar o arquivo pra a tabela 'lotofacil_id_classificado' usando
        // o comando copy.
        FStatus_Mensagem:='Apagando tabela lotofacil_id_classificado, aguarde...';
        Synchronize(@DoStatus);

        sql_query.Connection.Connected:=false;
        sql_query.Connection.AutoCommit:=false;

        sql_query.SQL.Clear;
        sql_query.Sql.Add('truncate lotofacil.lotofacil_id_classificado');
        sql_query.ExecSql;

        FStatus_Mensagem:='Apagando tabela lotofacil_id_classificado, OK.';
        Synchronize(@DoStatus);

        FStatus_Mensagem := 'Apagando índices da tabela lotofacil_id_classificado, aguarde.';
        sql_query.SQL.Clear;
        sql_query.Sql.Add('Select from lotofacil.fn_lotofacil_id_classificado_apagar_indices()');
        sql_query.ExecSql;
        sql_query.Connection.Commit;

        FStatus_Mensagem := 'Importando dados do arquivo lotofacil.lotofacil_id_classificado.csv';
        Synchronize(@DoStatus);

        sql_query.Sql.Clear;
        sql_query.Sql.Add('Copy lotofacil.lotofacil_id_classificado(' + campo_modificado +
            ') from ' + QuotedStr(lotofacil_id_classificado_csv) +
            ' with (delimiter '','', format csv, header true)');
        Writeln(sql_query.SQL.Text);
        sql_query.Open;

        FStatus_Mensagem := 'Criando índices da tabela lotofacil_id_classificado, aguarde, pode demorar.';
        Synchronize(@DoStatus);

        sql_query.SQL.Clear;
        sql_query.Sql.Add('Select from lotofacil.fn_lotofacil_id_classificado_criar_indices()');
        sql_query.ExecSql;
        sql_query.Connection.Commit;

        FStatus_Mensagem:='Comando concluído com sucesso!!!';
        Synchronize(@DoStatus);

        Exit;



        // Vamos abrir o arquivo 'lotofacil_id_classificado' pra gravação.
        Assign(f_lotofacil_id_classificado, arquivo_exportado_classificado);
        Rewrite(f_lotofacil_id_classificado);
        if IOResult <> 0 then
        begin
            FStatus_Mensagem := 'Erro ao abrir arquivo pra gravar';
            raise Exception.Create(FStatus_Mensagem);
            Exit;
        end;

        // Grava cabeçalho.
        Write(f_lotofacil_id_classificado, campo_modificado);

        sql_query.Close;
        sql_query.ReadOnly := True;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select ' + campo_modificado + ' from lotofacil.lotofacil_id');
        sql_query.Sql.Add('where ltf_id = :campo_ltf_id');
        sql_query.Sql.Add('order by ltf_id');
        sql_query.Prepare;

        for uA := 1 to LOTOFACIL_TOTAL_DE_COMBINACOES do
        begin
            sql_query.ParamByName('campo_ltf_id').AsInteger := uA;
            sql_query.Open;

            if sql_query.RecordCount <= 0 then
            begin
                raise Exception.Create('Erro, registro de número: ' + IntToStr(uA) + ' não localizado.');
                Exit;
            end;

            // Começa uma nova linha
            Write(f_lotofacil_id_classificado, LineEnding);

            for uB := 0 to Pred(qt_campos - 2) do
            begin
                id_atual := sql_query.Fields[uB].AsInteger;

                // A primeira dimensão do arranjo 'id_seq_exclusivo' indica
                // qual campos queremos analisar, a segunda dimensão, armazena
                // pra cada id possível daquele campo, qual é o id sequencial atual.
                id_sequencial := id_seq_exclusivo[uB, id_atual];

                // Toda vez, que o id for encontrado, iremos incrementar o contador sequencial
                // referente àquele id, em cada campo, haverá um contador sequencial exclusivo
                // pra cada id.
                Inc(id_sequencial);
                id_seq_exclusivo[uB, id_atual] := id_sequencial;

                // Agora, iremos gravar no arquivo, cada campo
                if uA <> uB then
                begin
                    Write(f_lotofacil_id_classificado, ',');
                end;
                Write(f_lotofacil_id_classificado, id_sequencial);
            end;

            // Após percorrer todos os campos, ainda não percorrermos os campos
            // ltf_id e ltf_qt, então, iremos pegar tais valores agora.
            ultimo_indice := qt_campos - 1;
            valor_campo_ltf_id := sql_query.Fields[ultimo_indice - 1].AsInteger;
            valor_campo_ltf_qt := sql_query.Fields[ultimo_indice].AsInteger;

            Write(f_lotofacil_id_classificado, ',' + IntToStr(valor_campo_ltf_id));
            Write(f_lotofacil_id_classificado, ',' + IntToStr(valor_campo_ltf_qt));

            //if (uA = 1) or (uA mod 500000 = 0) then
            //begin
            FStatus_Mensagem := 'Lendo registro: ' + IntToStr(uA + 1);
            Synchronize(@DoStatus);
            //end;

            if Interromper then
            begin
                fStatus_Mensagem := FStatus_Mensagem + ', interrompido por solicitação do usuário.';
                Synchronize(@DoStatus);
                raise Exception.Create(FStatus_Mensagem);
            end;
            sql_query.Close;
        end;

        // Após percorrermos todos os campos, iremos armazena os registros
        // que está na pasta temporária pra o banco de dados, pra isto
        // iremos utilizar o campo copy.
        sql_query.SQL.Clear;
        sql_query.Close;
        sql_query.SQL.Add('Truncate lotofacil.lotofacil_id_classificado');
        sql_query.ExecSQL;
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Copy lotofacil.lotofacil_id_classificado(' + campo_modificado +
            ') from ' + QuotedStr(arquivo_exportado_classificado) + ' with(format csv, header true, delimiter '','')');
        sql_query.Open;
        sql_query.Close;

        // Verifica se há 6874010 registros.
        sql_query.Sql.Clear;
        sql_query.Sql.Add('Select count(*) from lotofacil.lotofacil_id_classificado');
        sql_query.Open;

        if sql_query.Fields[0].AsInteger <> 6874010 then
        begin
            FStatus_Mensagem := FStatus_Mensagem + 'Erro, não há 6874010 registros, foi encontrado: ' +
                sql_query.Fields[0].AsString;
            raise Exception.Create(FStatus_Mensagem);
            Exit;
        end;

        FStatus_Mensagem := 'Comando executado com sucesso!!!';
        Synchronize(@DoStatus);

        Close(f_lotofacil_id_classificado);
        Exit;

        // Vamos agora obter o conteúdo de cada linha do arquivo.
        //Assign(f_arquivo, arquivo_exportado);
        //Reset(f_arquivo);

        // Vamos criar o arquivo que servirá pra armazenar os ids sequencial.
        //Assign(f_lotofacil_id_classificado, arquivo_exportado_classificado);
        //Rewrite(f_lotofacil_id_classificado);

        // Vamos percorrer cada linha do arquivo, em cada linha, iremos dividir esta linha
        // em campos, onde cada campo corresponde a um campo da tabela lotofacil_id.
        //qt_campos := Length(campo_modificado.Split(','));

        // Vamos copiar o cabeçalho.
        ///Readln(f_arquivo, arquivo_linha_atual);
        //Writeln(f_lotofacil_id_classificado, campo_modificado);

        qt_registros := 0;
        indice_lotofacil_id := 0;
        while not EOF(f_arquivo) do
        begin
            Readln(f_arquivo, arquivo_linha_atual);
            campos_por_linha := arquivo_linha_atual.split(',');
            if Length(campos_por_linha) <> qt_campos then
            begin
                FStatus_Mensagem := 'A quantidade de campos da linha atual é diferente da ' +
                    'quantidade de campos da tabela lotofacil_id';
                Synchronize(@DoStatus);
                Break;
            end;

            // Agora, irei percorrer cada campo e irei pegar qual é o id, em seguida,
            // irei pegar o valor do contador sequencial por id de cada id e incrementar
            // mais 1.
            for uA := 0 to Pred(qt_campos - 2) do
            begin
                id_atual := StrToInt(campos_por_linha[uA]);

                // A primeira dimensão do arranjo 'id_seq_exclusivo' indica
                // qual campos queremos pegar, a segunda dimensão indica o id corresponde
                // que contém o contador sequencial.
                id_sequencial := id_seq_exclusivo[uA, id_atual];

                // Toda vez, que o id for encontrado, iremos incrementar o contador sequencial
                // referente àquele id, em cada campo, haverá um contador sequencial exclusivo
                // pra cada id.
                Inc(id_sequencial);
                id_seq_exclusivo[uA, id_atual] := id_sequencial;

                // Agora, iremos gravar no arquivo, cada campo
                if uA <> 0 then
                begin
                    Write(f_lotofacil_id_classificado, ',');
                end;
                Write(f_lotofacil_id_classificado, id_sequencial);

            end;

            indice_campo_ltf_id := High(campos_por_linha) - 1;
            indice_campo_ltf_qt := High(campos_por_linha);

            // O campo ltf_id é o penúltimo campo.
            ltf_id := campos_por_linha[indice_campo_ltf_id];
            // O campo ltf_qt é o último campo.
            ltf_qt := campos_por_linha[indice_campo_ltf_qt];

            Write(f_lotofacil_id_classificado, ',' + ltf_id);
            Writeln(f_lotofacil_id_classificado, ',' + ltf_qt);

            Inc(qt_registros);
            //FStatus_Mensagem := 'Gravando registro: ' + IntToStr(qt_registros) + ' de 6874010, ' +
            //    ', ltf: ' + IntToStr(ltf_id);
            //Synchronize(@DoStatus);

            if Interromper then
            begin
                fStatus_Mensagem := FStatus_Mensagem + ', interrompido por solicitação do usuário.';
                Synchronize(@DoStatus);
                raise Exception.Create(FStatus_Mensagem);
            end;
        end;
        Close(f_arquivo);
        Close(f_lotofacil_id_classificado);

    except
        On Exc: Exception do
        begin
            FStatus_Mensagem := Exc.Message;
            Synchronize(@DoStatus);
            Synchronize(@DoStatus_Erro);
            Exit;
        end;
    end;

    FreeAndNil(sql_query);
end;

procedure TLotofacil_id_classificado.SetInterromper(AValue: boolean);
begin
    if FInterromper = AValue then
        Exit;
    FInterromper := AValue;
end;

procedure TLotofacil_id_classificado.SetSql_Conexao(AValue: TZConnection);
begin
    if FSql_Conexao = AValue then
        Exit;
    FSql_Conexao := AValue;
end;

end.
