unit krdb_fmDoctor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, ActnList, StdCtrls
  , dmPoliclinik
  , krdb_fmdiagnosis
  , LazUTF8
  ;

type

  { TfmDoctorCabinet }

  TfmDoctorCabinet = class(TForm)
    acDiseases: TAction;
    ActionList1: TActionList;
    ComboBox1: TComboBox;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure acDiseasesExecute(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
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

procedure TfmDoctorCabinet.acDiseasesExecute(Sender: TObject);
begin
  fmDiagnosis.Show;
end;

procedure TfmDoctorCabinet.ComboBox1Select(Sender: TObject);
begin

end;

end.

