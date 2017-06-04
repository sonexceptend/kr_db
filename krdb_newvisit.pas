unit krdb_newvisit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  StdCtrls, Buttons
  , dmPoliclinik
  , LazUTF8
  ;

type

  { TfmNewVisit }

  TfmNewVisit = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    DateEdit1: TDateEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    idPatient : integer;
    { public declarations }
  end;

var
  fmNewVisit: TfmNewVisit;

implementation

{$R *.lfm}

{ TfmNewVisit }

procedure TfmNewVisit.FormShow(Sender: TObject);
begin
  ComboBox1.Clear;
  dmPoliclinic.ApplySQL(dmPoliclinic.SQLList[4]);
  if dmPoliclinic.SQLQueryApplyData.EOF then exit;
  with dmPoliclinic.SQLQueryApplyData do begin
    First;
    while not EOF do begin

      ComboBox1.Items.Add(WinCPToUtf8(Fields[0].AsString)+#9+' ['+WinCPToUtf8(Fields[1].AsString)+']');
      Next;
    end;
  end;
  ComboBox1.SetFocus;
end;

procedure TfmNewVisit.BitBtn1Click(Sender: TObject);
var docSpec : string;
    docFio  : string;
    SQLText : string;
    idDoc   : integer;
begin
  docSpec:=Copy(ComboBox1.Text,1,Pos(#9,ComboBox1.Text)-1);
  docFio:=Copy(ComboBox1.Text,Pos('[',ComboBox1.Text)+1,Pos(']',ComboBox1.Text)-Pos('[',ComboBox1.Text)-1);
  if (docSpec='') or (docFio='') then MOdalResult:=mrCancel
                                 else MOdalResult:=mrOK;
  SQLText := dmPoliclinic.SQLList[4] +' WHERE tbDoc.[Specialty] LIKE '+#39+'%'+docSpec+'%'+#39+' AND [tbWorkers].[FirstName] LIKE '+#39+'%'+docFio+'%'+#39;
  dmPoliclinic.ApplySQL(SQLText);
  if dmPoliclinic.SQLQueryApplyData.EOF then begin
    MOdalResult:=mrCancel;
    Hide;
  end;
  idDoc:=dmPoliclinic.SQLQueryApplyData.Fields[2].AsInteger;
  SQLText := Format(dmPoliclinic.SQLList[5],[idPatient,FormatDateTime('yyyy-dd-mm',DateEdit1.Date),idDoc]);
  dmPoliclinic.ExectSQL(SQLText);
  MOdalResult:=mrOK;
  Hide;
end;

procedure TfmNewVisit.BitBtn2Click(Sender: TObject);
begin
  MOdalResult:=mrCancel;
  Hide;
end;

end.

