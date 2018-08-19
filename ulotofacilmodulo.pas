unit uLotofacilModulo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, pqconnection, FileUtil,
  PQTEventMonitor, ZConnection;

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
    ZConnection1: TZConnection;
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

