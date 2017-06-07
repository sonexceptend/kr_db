unit krdb_fmaccountant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, ExtendedNotebook, Forms, Controls, Graphics,
  Dialogs, Grids, ComCtrls, DBGrids, ActnList
  , dmPoliclinik
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
end;

procedure TfmVakanci.acNewVakanciExecute(Sender: TObject);
begin

end;

procedure TfmVakanci.acDeleteVakanciExecute(Sender: TObject);
begin

end;

end.

