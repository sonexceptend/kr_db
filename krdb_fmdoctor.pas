unit krdb_fmDoctor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, ActnList, StdCtrls, ExtCtrls, Buttons, EditBtn
  , dmPoliclinik
  , krdb_fmdiagnosis
  , LazUTF8
  ;

type

  { TfmDoctorCabinet }

  TfmDoctorCabinet = class(TForm)
    acDiseases: TAction;
    acFilterCansel: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    ComboBox1: TComboBox;
    edDateEdit: TDateEdit;
    edFamily: TEdit;
    edDiagnosis: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure acDiseasesExecute(Sender: TObject);
    procedure acFilterCanselExecute(Sender: TObject);
    procedure acFl_LastDayExecute(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure edDateEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private
    idDoctorList:TStringList;
    { private declarations }
  public
    procedure UpdateDoctorVisitTable(WHERESQLText : string);
    { public declarations }
  end;

var
  fmDoctorCabinet: TfmDoctorCabinet;

implementation

{$R *.lfm}

{ TfmDoctorCabinet }

procedure TfmDoctorCabinet.FormShow(Sender: TObject);
begin
  ComboBox1.Clear;
  idDoctorList.Clear;
  dmPoliclinic.ApplySQL(dmPoliclinic.SQLList[4]);
  if dmPoliclinic.SQLQueryApplyData.EOF then exit;
  with dmPoliclinic.SQLQueryApplyData do begin
    First;
    while not EOF do begin
      ComboBox1.Items.Add(WinCPToUtf8(Fields[0].AsString)+#9+' ['+WinCPToUtf8(Fields[1].AsString)+']');
      idDoctorList.Add(Fields[2].AsString);
      Next;
    end;
  end;
  ComboBox1.SetFocus;
  edDateEdit.Date:=Now;
end;

procedure TfmDoctorCabinet.StringGrid1DblClick(Sender: TObject);
var SQLText : string;
begin
  fmDiagnosis.ShowModal;
  if fmDiagnosis.ModalResult=mrOk then begin
    SQLText:=Format(dmPoliclinic.SQLList[10],[fmDiagnosis.TreeListView1.Selected.Text,
                                             strtoint(StringGrid1.Cells[0,StringGrid1.Row])]);
    dmPoliclinic.ExectSQL(SQLText);
    UpdateDoctorVisitTable(' WHERE tVis.idDoc='+idDoctorList[ComboBox1.ItemIndex]+Format(' AND tVis.DateVis = %s ',[FormatDateTime('yyyy-mm-dd',edDateEdit.Date)]));
  end;
end;

procedure TfmDoctorCabinet.UpdateDoctorVisitTable(WHERESQLText: string);
var SQLtext : string;
    row:integer;
begin
  SQLtext :=dmPoliclinic.SQLList[9]+WHERESQLText;
  StringGrid1.RowCount:=2;
  StringGrid1.Rows[1].Clear;
  dmPoliclinic.ApplySQL(SQLtext);
  if dmPoliclinic.SQLQueryApplyData.EOF then exit;
  row:=1;
  with dmPoliclinic.SQLQueryApplyData do begin
    First;
    StringGrid1.BeginUpdate;
    while not EOF do begin
      StringGrid1.RowCount:=row+1;
      StringGrid1.Cells[0,row]:=Fields[0].AsString;
      StringGrid1.Cells[1,row]:=WinCPToUtf8(Fields[1].AsString);
      StringGrid1.Cells[2,row]:=WinCPToUtf8(Fields[2].AsString);
      StringGrid1.Cells[3,row]:=WinCPToUtf8(Fields[3].AsString);
      StringGrid1.Cells[4,row]:=WinCPToUtf8(Fields[4].AsString);
      StringGrid1.Cells[5,row]:=WinCPToUtf8(Fields[5].AsString);
      StringGrid1.Cells[6,row]:=WinCPToUtf8(Fields[6].AsString);
      Next;
      inc(row);
    end;
    StringGrid1.EndUpdate(true);
  end;
end;

procedure TfmDoctorCabinet.acDiseasesExecute(Sender: TObject);
begin
  fmDiagnosis.Show;
end;

procedure TfmDoctorCabinet.acFilterCanselExecute(Sender: TObject);
begin
  edDateEdit.Date:=Now;
  edDiagnosis.Text:='';
  edFamily.Text:='';
  UpdateDoctorVisitTable(' WHERE tVis.idDoc='+idDoctorList[ComboBox1.ItemIndex]+Format(' AND tVis.DateVis = %s ',[FormatDateTime('yyyy-mm-dd',edDateEdit.Date)]));
end;

procedure TfmDoctorCabinet.acFl_LastDayExecute(Sender: TObject);
begin

end;

procedure TfmDoctorCabinet.ComboBox1Select(Sender: TObject);
begin
  UpdateDoctorVisitTable(' WHERE tVis.idDoc='+idDoctorList[ComboBox1.ItemIndex]+Format(' AND tVis.DateVis = %s ',[FormatDateTime('yyyy-mm-dd',edDateEdit.Date)]));
end;

procedure TfmDoctorCabinet.edDateEditChange(Sender: TObject);
var sFilter : string;
begin
  sFilter:='';
  //if edDateEdit.Text<>'' then sFilter := sFilter + Format(' AND tVis.DateVis = %s ',[FormatDateTime('yyyy-mm-dd',edDateEdit.Date)]);
  if edFamily.Text<>'' then
      sFilter := sFilter + Format(' AND tVis.Family LIKE '+#39+'%%%s%%'+#39,[edFamily.Text]);
  if edDiagnosis.Text<>'' then
      sFilter := sFilter + Format(' AND tDoc.Description LIKE '+#39+'%%s%%'+#39,[edDiagnosis.Text]);
  if sFilter<>'' then begin
    if (ComboBox1.ItemIndex<0) or (ComboBox1.ItemIndex>=ComboBox1.Items.Count) then exit;
    UpdateDoctorVisitTable(' WHERE tVis.idDoc='+idDoctorList[ComboBox1.ItemIndex]+sFilter);
  end;
end;

procedure TfmDoctorCabinet.FormCreate(Sender: TObject);
begin
  idDoctorList:=TStringList.Create;
end;

procedure TfmDoctorCabinet.FormDestroy(Sender: TObject);
begin
  idDoctorList.Free;
end;

end.

