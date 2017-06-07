unit dmPoliclinik;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, FileUtil, LazUTF8, db;

type

  { TdmPoliclinic }

  TdmPoliclinic = class(TDataModule)
    ODBCConnection1: TODBCConnection;
    SQLExecuteQuery: TSQLQuery;
    SQLtbVakancy: TSQLQuery;
    SQLQueryApplyData: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure SQLtbVakancyAfterOpen(DataSet: TDataSet);
  private
    procedure AllText(Sender: TField; var AText: string;  DisplayText: Boolean);
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

procedure TdmPoliclinic.SQLtbVakancyAfterOpen(DataSet: TDataSet);
var i:Integer;
begin
  for i:=0 to SQLtbVakancy.Fields.Count-1 do
    if SQLtbVakancy.Fields[i].DataType=ftString then
      SQLtbVakancy.Fields[i].OnGetText:=@AllText;
end;

procedure TdmPoliclinic.AllText(Sender: TField; var AText: string;
  DisplayText: Boolean);
begin
  AText:= WinCPToUTF8(Sender.AsString);
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
    SQLlistLog : TStringList;
begin
  if not ODBCConnection1.Connected then exit;
  SQLExecuteQuery.Active:=false;
  SQLlistLog := TStringList.Create;
  if FileExists('sqllog.txt') then
    SQLlistLog.LoadFromFile('sqllog.txt');
  SQLlistLog.Add(SQL_Select);
  SQLlistLog.SaveToFile('sqllog.txt');
  SQLlistLog.Free;
  SQLlistLog:=nil;
  SQLExecuteQuery.SQL.Text:=Utf8ToWinCP(SQL_Select);
  try
    SQLExecuteQuery.ExecSQL;
  except
    //SQLQueryApplyData.Active:=false;
  end;
end;

end.

