unit krdb_fmaccountant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, ExtendedNotebook, Forms, Controls, Graphics,
  Dialogs, Grids, ComCtrls, DBGrids, ActnList
  , LazUTF8
  , dmPoliclinik
  , krdb_fmvakancidialog
  , krdb_fmdoctordialog
  ;

type

  { TfmVakanci }

  TfmVakanci = class(TForm)
    acNewVakanci: TAction;
    acEditVakanci: TAction;
    acDeleteVakanci: TAction;
    acNewWorkers: TAction;
    acDeleteWorker: TAction;
    acNewDoctor: TAction;
    acEditDoctor: TAction;
    acDeleteDoctor: TAction;
    ActionList1: TActionList;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ExtendedNotebook1: TExtendedNotebook;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    procedure acDeleteDoctorExecute(Sender: TObject);
    procedure acDeleteVakanciExecute(Sender: TObject);
    procedure acDeleteWorkerExecute(Sender: TObject);
    procedure acEditDoctorExecute(Sender: TObject);
    procedure acEditVakanciExecute(Sender: TObject);
    procedure acNewDoctorExecute(Sender: TObject);
    procedure acNewVakanciExecute(Sender: TObject);
    procedure acNewWorkersExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1EditingDone(Sender: TObject);
  private
    procedure UpdateWorkersTable;
    procedure UpdateDoctor;
    { private declarations }
  public
    { public declarations }
  end;

var
  fmVakanci: TfmVakanci;

implementation

{$R *.lfm}

{ TfmVakanci }

procedure TfmVakanci.FormShow(Sender: TObject);
begin
  dmPoliclinic.SQLtbVakancy.Active:=true;
  DBGrid1.Columns[0].Visible:=false;
  UpdateWorkersTable;
  UpdateDoctor;
end;

procedure TfmVakanci.StringGrid1EditingDone(Sender: TObject);
var id:integer;
  SQLText : string;
begin
  if (StringGrid1.Cells[1,StringGrid1.Row]='') OR (StringGrid1.Cells[2,StringGrid1.Row]='') then exit;
  if StringGrid1.Cells[0,StringGrid1.Row]<>'' then begin
    id:=strtoint(StringGrid1.Cells[0,StringGrid1.Row]);
    SQLText:=Format(dmPoliclinic.SQLList[16],[StringGrid1.Cells[1,StringGrid1.Row],
                                              StringGrid1.Cells[2,StringGrid1.Row],
                                              StringGrid1.Cells[3,StringGrid1.Row],
                                              StringGrid1.Cells[4,StringGrid1.Row],
                                              StringGrid1.Cells[5,StringGrid1.Row],
                                              id]);
  end else begin
    SQLText:=Format(dmPoliclinic.SQLList[18],[StringGrid1.Cells[1,StringGrid1.Row],
                                              StringGrid1.Cells[2,StringGrid1.Row],
                                              StringGrid1.Cells[3,StringGrid1.Row],
                                              StringGrid1.Cells[4,StringGrid1.Row],
                                              StringGrid1.Cells[5,StringGrid1.Row]]);
  end;
  dmPoliclinic.ExectSQL(SQLText);
  UpdateWorkersTable;
end;

procedure TfmVakanci.acNewVakanciExecute(Sender: TObject);
var SQLText : string;
  fm : TFormatSettings;
begin
  fmVakanciDialog.Edit1.Text:='';
  fmVakanciDialog.FloatSpinEdit1.Value:=7000.0;
  fmVakanciDialog.Caption:='Новая вакансия';
  fmVakanciDialog.ShowModal;
  if fmVakanciDialog.ModalResult<>mrOK then exit;
  fm := FormatSettings;
  fm.DecimalSeparator:='.';
  SQLText:=Format(dmPoliclinic.SQLList[12],[fmVakanciDialog.Edit1.Text,Floattostr(fmVakanciDialog.FloatSpinEdit1.Value,fm)]);
  dmPoliclinic.ExectSQL(SQLText);
  dmPoliclinic.SQLtbVakancy.Active:=false;
  dmPoliclinic.SQLtbVakancy.Active:=true;
  DBGrid1.Columns[0].Visible:=false;
end;

procedure TfmVakanci.acNewWorkersExecute(Sender: TObject);
begin
  StringGrid1.RowCount:=StringGrid1.RowCount+1;
  StringGrid1.Row:=StringGrid1.RowCount-1;
end;

procedure TfmVakanci.acDeleteVakanciExecute(Sender: TObject);
var SQLText : string;
  id : integer;
begin
  if MessageDlg('Вы действительно хотите удалить текущую вакансию?',mtWarning,mbOKCancel,0)<>mrOK then exit;
  id:=strtoint(StringGrid1.Cells[0,StringGrid1.Row]);
  SQLText:=Format(dmPoliclinic.SQLList[17],[id]);
  dmPoliclinic.ExectSQL(SQLText);
  UpdateWorkersTable;
end;

procedure TfmVakanci.acDeleteDoctorExecute(Sender: TObject);
var SQLText : string;
  id : integer;
begin
  if MessageDlg('Вы действительно хотите удалить текущую запись о враче?',mtWarning,mbOKCancel,0)<>mrOK then exit;
  id:=strtoint(StringGrid2.Cells[0,StringGrid6.Row]);
  SQLText:=Format(dmPoliclinic.SQLList[23],[id]);
  dmPoliclinic.ExectSQL(SQLText);
  UpdateDoctor;
end;

procedure TfmVakanci.acDeleteWorkerExecute(Sender: TObject);
var SQLText : string;
  id : integer;
begin
  if MessageDlg('Вы действительно хотите удалить текущего работника?',mtWarning,mbOKCancel,0)<>mrOK then exit;
  id:=DBGrid1.DataSource.DataSet.FieldByName('id').AsInteger;
  SQLText:=Format(dmPoliclinic.SQLList[14],[id]);
  dmPoliclinic.ExectSQL(SQLText);
  dmPoliclinic.SQLtbVakancy.Active:=false;
  dmPoliclinic.SQLtbVakancy.Active:=true;
  DBGrid1.Columns[0].Visible:=false;
end;

procedure TfmVakanci.acEditDoctorExecute(Sender: TObject);
begin
  fmDoctorDialog.Caption:='Изменить параметры врача';
  fmDoctorDialog.DocID:=strtoint(StringGrid2.Cells[6,StringGrid2.Row]);
  if StringGrid2.Cells[4,StringGrid2.Row]<>'' then
    fmDoctorDialog.VacancyID:=strtoint(StringGrid2.Cells[4,StringGrid2.Row])
  else
    fmDoctorDialog.VacancyID:=-1;
  if StringGrid2.Cells[0,StringGrid2.Row]<>'' then
    fmDoctorDialog.WorkersID:=strtoint(StringGrid2.Cells[0,StringGrid2.Row])
  else
    fmDoctorDialog.WorkersID:=-1;
  fmDoctorDialog.Edit1.Text:=StringGrid2.Cells[5,StringGrid2.Row];
  fmDoctorDialog.ShowModal;
  if fmDoctorDialog.ModalResult<>mrOk then exit;
  UpdateDoctor;
end;

procedure TfmVakanci.acEditVakanciExecute(Sender: TObject);
var SQLText : string;
  fm : TFormatSettings;
  id : integer;
begin
  id:=DBGrid1.DataSource.DataSet.FieldByName('id').AsInteger;
  fmVakanciDialog.Edit1.Text:=WinCPToUTF8(DBGrid1.DataSource.DataSet.FieldByName('Вакансия').AsString);
  fmVakanciDialog.FloatSpinEdit1.Value:=DBGrid1.DataSource.DataSet.FieldByName('Оклад').AsFloat;
  fmVakanciDialog.Caption:='Редактирование вакансии';
  fmVakanciDialog.ShowModal;
  if fmVakanciDialog.ModalResult<>mrOK then exit;
  fm := FormatSettings;
  fm.DecimalSeparator:='.';
  SQLText:=Format(dmPoliclinic.SQLList[13],[fmVakanciDialog.Edit1.Text,
                                            Floattostr(fmVakanciDialog.FloatSpinEdit1.Value,fm),
                                            id]);
  dmPoliclinic.ExectSQL(SQLText);
  dmPoliclinic.SQLtbVakancy.Active:=false;
  dmPoliclinic.SQLtbVakancy.Active:=true;
  DBGrid1.Columns[0].Visible:=false;
end;

procedure TfmVakanci.acNewDoctorExecute(Sender: TObject);
begin
  fmDoctorDialog.Caption:='Новый врач поликлиники';
  fmDoctorDialog.DocID:=-1;
  fmDoctorDialog.ShowModal;
  if fmDoctorDialog.ModalResult<>mrOk then exit;
  UpdateDoctor;
end;

procedure TfmVakanci.UpdateWorkersTable;
var SQLtext : string;
    row:integer;
begin
  SQLtext :=dmPoliclinic.SQLList[15];
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
      Next;
      inc(row);
    end;
    StringGrid1.EndUpdate(true);
  end;
end;

procedure TfmVakanci.UpdateDoctor;
var SQLtext : string;
    row:integer;
begin
  SQLtext :=dmPoliclinic.SQLList[19];
  StringGrid2.RowCount:=2;
  StringGrid2.Rows[1].Clear;
  dmPoliclinic.ApplySQL(SQLtext);
  if dmPoliclinic.SQLQueryApplyData.EOF then exit;
  row:=1;
  with dmPoliclinic.SQLQueryApplyData do begin
    First;
    StringGrid2.BeginUpdate;
    while not EOF do begin
      StringGrid2.RowCount:=row+1;
      StringGrid2.Cells[0,row]:=Fields[0].AsString;
      StringGrid2.Cells[1,row]:=WinCPToUtf8(Fields[1].AsString);
      StringGrid2.Cells[2,row]:=WinCPToUtf8(Fields[2].AsString);
      StringGrid2.Cells[3,row]:=WinCPToUtf8(Fields[3].AsString);
      StringGrid2.Cells[4,row]:=Fields[4].AsString;
      StringGrid2.Cells[5,row]:=WinCPToUtf8(Fields[6].AsString);
      StringGrid2.Cells[6,row]:=Fields[7].AsString;
      Next;
      inc(row);
    end;
    StringGrid2.EndUpdate(true);
  end;
end;

end.

