unit dmPoliclinik;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, FileUtil, LazUTF8;

type

  { TdmPoliclinic }

  TdmPoliclinic = class(TDataModule)
    ODBCConnection1: TODBCConnection;
    SQLExecuteQuery: TSQLQuery;
    SQLQueryApplyData: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    SQLList : TStringList;
    procedure ApplySQL(SQL_Select : string);
    procedure ExectSQL(SQL_Select : string);
    { public declarations }
  end;

var
  dmPoliclinic: TdmPoliclinic;

implementation

{$R *.lfm}

{ TdmPoliclinic }

procedure TdmPoliclinic.DataModuleCreate(Sender: TObject);
begin
  SQLList := TStringList.Create;
  SQLList.LoadFromFile('SQL.txt');

end;

procedure TdmPoliclinic.DataModuleDestroy(Sender: TObject);
begin
  SQLList.Free;
end;

procedure TdmPoliclinic.ApplySQL(SQL_Select: string);
var SQLlistLog : TStringList;
begin
  SQLlistLog := TStringList.Create;
  if FileExists('sqllog.txt') then
    SQLlistLog.LoadFromFile('sqllog.txt');
  SQLlistLog.Add(SQL_Select);
  SQLlistLog.SaveToFile('sqllog.txt');
  SQLlistLog.Free;
  SQLlistLog:=nil;
  SQLQueryApplyData.Active:=false;
  if not ODBCConnection1.Connected then exit;
  SQLQueryApplyData.SQL.Text:=Utf8ToWinCP(SQL_Select);
  try
    SQLQueryApplyData.Active:=true;
  except
    SQLQueryApplyData.Active:=false;
  end;

end;

procedure TdmPoliclinic.ExectSQL(SQL_Select: string);
var stmp : string;
begin
  if not ODBCConnection1.Connected then exit;
  SQLExecuteQuery.Active:=false;
  //stmp:=StringReplace(SQL_Select,#39,#39,[rfReplaceAll]);
  SQLExecuteQuery.SQL.Text:=Utf8ToWinCP(SQL_Select);
  try
    SQLExecuteQuery.ExecSQL;
  except
    //SQLQueryApplyData.Active:=false;
  end;
end;

end.

