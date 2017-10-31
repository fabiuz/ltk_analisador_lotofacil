unit uLotofacilModulo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, db, pqconnection, FileUtil,
  PQTEventMonitor;

type

  { TdmLotofacil }

  TdmLotofacil = class(TDataModule)
    dsNovosRepetidos15Bolas : TDataSource;
    dsNovosRepetidos16Bolas : TDataSource;
    dsNovosRepetidos17Bolas : TDataSource;
    dsNovosRepetidos18Bolas : TDataSource;
    pgLTK : TPQConnection;
    PQTEventMonitor1 : TPQTEventMonitor;
    sqlNovosRepetidos15Bolas : TSQLQuery;
    sqlLotofacil : TSQLQuery;
    sqlNovosRepetidos16Bolas : TSQLQuery;
    sqlNovosRepetidos17Bolas : TSQLQuery;
    sqlNovosRepetidos18Bolas : TSQLQuery;
    SQLTransaction1 : TSQLTransaction;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  dmLotofacil : TdmLotofacil;

implementation

{$R *.lfm}

end.

