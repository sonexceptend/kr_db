unit krdb_fmPacient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, Grids, StdCtrls, Buttons, ExtCtrls
  , LazUTF8
  , dmPoliclinik
  , krdb_editpacient
  , krdb_newvisit
  ;

type

  { TfmOperator }

  TfmOperator = class(TForm)
    acClearFilter: TAction;
    acNewPatient: TAction;
    acEditPatient: TAction;
    acDeletePatient: TAction;
    acNewVisit: TAction;
    acUpdate: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    edFirstName: TEdit;
    edSecondName: TEdit;
    edMiddleName: TEdit;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Splitter1: TSplitter;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure acClearFilterExecute(Sender: TObject);
    procedure acDeletePatientExecute(Sender: TObject);
    procedure acEditPatientExecute(Sender: TObject);
    procedure acNewPatientExecute(Sender: TObject);
    procedure acNewVisitExecute(Sender: TObject);
    procedure acUpdateExecute(Sender: TObject);
    procedure edFirstNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1BeforeSelection(Sender: TObject; aCol, aRow: Integer);
  private
    { private declarations }
  public
    procedure UpdateTable(SQL_Select : string);
    procedure UpdateTableVisit(SQL_Select : string);
    { public declarations }
  end;

var
  fmOperator: TfmOperator;

implementation

{$R *.lfm}

{ TfmOperator }

procedure TfmOperator.acUpdateExecute(Sender: TObject);
begin
  UpdateTable('SELECT * FROM tbPatients');
end;

procedure TfmOperator.edFirstNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var sFilter : string = '';
begin
  if edFirstName.Text<>'' then sFilter := sFilter + Format(' FirstName LIKE '+#39+'%%%s%%'+#39,[edFirstName.Text]);
  if edSecondName.Text<>'' then
    if sFilter<>'' then
      sFilter := sFilter + Format(' AND SecondName LIKE '+#39+'%%%s%%'+#39,[edSecondName.Text])
    else
      sFilter := sFilter + Format(' SecondName LIKE '+#39+'%%%s%%'+#39,[edSecondName.Text]);
  if edMiddleName.Text<>'' then
    if sFilter<>'' then
      sFilter := sFilter + Format(' AND MiddleName LIKE '+#39+'%%s%%'+#39,[edMiddleName.Text])
    else
      sFilter := sFilter + Format(' MiddleName LIKE '+#39+'%%s%%'+#39,[edMiddleName.Text]);
  if sFilter<>'' then
    UpdateTable('SELECT * FROM tbPatients WHERE '+sFilter);
end;


procedure TfmOperator.acClearFilterExecute(Sender: TObject);
begin
  edFirstName.Text:='';
  edSecondName.Text:='';
  edMiddleName.Text:='';
  acUpdate.Execute;
end;

procedure TfmOperator.acDeletePatientExecute(Sender: TObject);
var FIO : string = '';
begin
  if StringGrid1.Row<0 then exit;
  FIO := Format('%s %s %s',[StringGrid1.Cells[1,StringGrid1.Row],StringGrid1.Cells[2,StringGrid1.Row],StringGrid1.Cells[3,StringGrid1.Row]]);
  if MessageDlg('Вы действительно хотите удалить данное о пациенте:'+#13#10+FIO+'?',mtWarning,mbOKCancel,0)<>mrOK then exit;
  FIO:=Format(dmPoliclinic.SQLList[2],[strtoint(StringGrid1.Cells[7,StringGrid1.Row])]);
  dmPoliclinic.ExectSQL(FIO);
  acUpdate.Execute;
end;

procedure TfmOperator.acEditPatientExecute(Sender: TObject);
var SQLText : string;
  r : integer;
  fs : TFormatSettings;
begin
  if StringGrid1.Row<0 then exit;
  r:=StringGrid1.Row;
  fs := FormatSettings;
  fs.DateSeparator:='-';
  fs.ShortDateFormat:='yyyy-mm-dd';
  fmEditPatient.Caption:='Изменить параметры пациента';
  fmEditPatient.edFirstName.Text:=StringGrid1.Cells[1,r];
  fmEditPatient.edSecondName.Text:=StringGrid1.Cells[2,r];
  fmEditPatient.edMiddleName.Text:=StringGrid1.Cells[3,r];
  fmEditPatient.edBrithDate.Date:=strtodate(StringGrid1.Cells[4,r],fs);
  SQLText:=StringGrid1.Cells[5,r];
  Insert('_',SQLText,5);
  fmEditPatient.edPasport.Text:=SQLText;
  SQLText:=StringGrid1.Cells[6,r];
  Insert('_',SQLText,3);
  Insert('_',SQLText,6);
  fmEditPatient.edPolis.Text:=SQLText;

  fmEditPatient.ShowModal;
  if fmEditPatient.ModalResult<>mrOK then exit;
  with fmEditPatient do begin
    SQLText:=Format(dmPoliclinic.SQLList[1],[edFirstName.Text,
                                             edSecondName.Text,
                                             edMiddleName.Text,
                                             FormatDateTime('yyyy-mm-dd',edBrithDate.Date),
                                             StringReplace(edPasport.Text,'_','',[rfReplaceAll]),
                                             StringReplace(edPolis.Text,'_','',[rfReplaceAll]),
                                             0,
                                             strtoint(StringGrid1.Cells[7,r])]);
    dmPoliclinic.ExectSQL(SQLText);
  end;
  acUpdate.Execute;
end;

procedure TfmOperator.acNewPatientExecute(Sender: TObject);
var SQLText : string;
begin
  fmEditPatient.Caption:='Новый пациент';
  fmEditPatient.edFirstName.Text:='';
  fmEditPatient.edSecondName.Text:='';
  fmEditPatient.edMiddleName.Text:='';
  fmEditPatient.edBrithDate.Date:=Now;
  fmEditPatient.edPasport.Text:='';
  fmEditPatient.edPolis.Text:='';

  fmEditPatient.ShowModal;
  if fmEditPatient.ModalResult<>mrOK then exit;
  with fmEditPatient do begin
    SQLText:=Format(dmPoliclinic.SQLList[0],[edFirstName.Text,
                                             edSecondName.Text,
                                             edMiddleName.Text,
                                             FormatDateTime('yyyy-mm-dd',edBrithDate.Date),
                                             StringReplace(edPasport.Text,'_','',[rfReplaceAll]),
                                             StringReplace(edPolis.Text,'_','',[rfReplaceAll]),
                                             0]);
    dmPoliclinic.ExectSQL(SQLText);
  end;
  acUpdate.Execute;
end;

procedure TfmOperator.acNewVisitExecute(Sender: TObject);
var idSelect : integer;
  SQLText : string;
begin
  fmNewVisit.Edit1.Text:=StringGrid1.Cells[1,StringGrid1.Row];
  fmNewVisit.idPatient:=strtoint(StringGrid1.Cells[7,StringGrid1.Row]);
  fmNewVisit.DateEdit1.Date:=Now;
  fmNewVisit.ShowModal;
  if fmNewVisit.ModalResult<>mrOK then exit;
  try
  idSelect:=strtoint(StringGrid1.Cells[7,StringGrid1.Row]);
  except
    exit;
  end;
  SQLText:=Format(dmPoliclinic.SQLList[3],[idSelect]);
  UpdateTableVisit(SQLText);
end;

procedure TfmOperator.FormShow(Sender: TObject);
begin
  acUpdate.Execute;
  edFirstName.SetFocus;
end;

procedure TfmOperator.StringGrid1BeforeSelection(Sender: TObject; aCol,
  aRow: Integer);
var idSelect : integer;
  SQLText : string;
begin
  try
  idSelect:=strtoint(StringGrid1.Cells[7,aRow]);
  except
    exit;
  end;
  SQLText:=Format(dmPoliclinic.SQLList[3],[idSelect]);
  UpdateTableVisit(SQLText);
end;

procedure TfmOperator.UpdateTable(SQL_Select: string);
var row:integer;
begin
  StringGrid1.RowCount:=2;
  StringGrid1.Rows[1].Clear;
  dmPoliclinic.ApplySQL(SQL_Select);
  if dmPoliclinic.SQLQueryApplyData.EOF then exit;
  row:=1;
  with dmPoliclinic.SQLQueryApplyData do begin
    First;
    StringGrid1.BeginUpdate;
    while not EOF do begin
      StringGrid1.RowCount:=row+1;
      StringGrid1.Cells[0,row]:=inttostr(row);
      StringGrid1.Cells[1,row]:=WinCPToUtf8(Fields[1].AsString);
      StringGrid1.Cells[2,row]:=WinCPToUtf8(Fields[2].AsString);
      StringGrid1.Cells[3,row]:=WinCPToUtf8(Fields[3].AsString);
      StringGrid1.Cells[4,row]:=WinCPToUtf8(Fields[4].AsString);
      StringGrid1.Cells[5,row]:=WinCPToUtf8(Fields[5].AsString);
      StringGrid1.Cells[6,row]:=WinCPToUtf8(Fields[6].AsString);
      StringGrid1.Cells[7,row]:=Fields[0].AsString;
      Next;
      inc(row);

    end;
    StringGrid1.EndUpdate(true);
  end;

end;

procedure TfmOperator.UpdateTableVisit(SQL_Select: string);
var row:integer;
begin
  StringGrid2.RowCount:=2;
  StringGrid2.Rows[1].Clear;
  dmPoliclinic.ApplySQL(SQL_Select);
  if dmPoliclinic.SQLQueryApplyData.EOF then exit;
  row:=1;
  with dmPoliclinic.SQLQueryApplyData do begin
    First;
    StringGrid2.BeginUpdate;
    while not EOF do begin
      StringGrid2.RowCount:=row+1;
      StringGrid2.Cells[0,row]:=inttostr(row);
      StringGrid2.Cells[1,row]:=WinCPToUtf8(Fields[0].AsString);
      StringGrid2.Cells[2,row]:=WinCPToUtf8(Fields[1].AsString);
      StringGrid2.Cells[3,row]:=WinCPToUtf8(Fields[2].AsString);
      Next;
      inc(row);
    end;
    StringGrid2.EndUpdate(true);
  end;
end;

end.

