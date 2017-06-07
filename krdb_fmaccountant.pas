unit krdb_fmaccountant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, ExtendedNotebook, Forms, Controls, Graphics,
  Dialogs, Grids, ComCtrls, DBGrids, ActnList
  , LazUTF8
  , dmPoliclinik
  , krdb_fmvakancidialog
  ;

type

  { TfmVakanci }

  TfmVakanci = class(TForm)
    acNewVakanci: TAction;
    acEditVakanci: TAction;
    acDeleteVakanci: TAction;
    ActionList1: TActionList;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ExtendedNotebook1: TExtendedNotebook;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    procedure acDeleteVakanciExecute(Sender: TObject);
    procedure acEditVakanciExecute(Sender: TObject);
    procedure acNewVakanciExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
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

procedure TfmVakanci.acDeleteVakanciExecute(Sender: TObject);
var SQLText : string;
  id : integer;
begin
  if MessageDlg('Вы действительно хотите удалить текущую вакансию?',mtWarning,mbOKCancel,0)<>mrOK then exit;
  id:=DBGrid1.DataSource.DataSet.FieldByName('id').AsInteger;
  SQLText:=Format(dmPoliclinic.SQLList[14],[id]);
  dmPoliclinic.ExectSQL(SQLText);
  dmPoliclinic.SQLtbVakancy.Active:=false;
  dmPoliclinic.SQLtbVakancy.Active:=true;
  DBGrid1.Columns[0].Visible:=false;
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

end.

