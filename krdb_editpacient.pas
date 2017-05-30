unit krdb_editpacient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Calendar, EditBtn, MaskEdit, Buttons;

type

  { TfmEditPatient }

  TfmEditPatient = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    edBrithDate: TDateEdit;
    edFirstName: TEdit;
    edSecondName: TEdit;
    edMiddleName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edPasport: TMaskEdit;
    edPolis: TMaskEdit;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fmEditPatient: TfmEditPatient;

implementation

{$R *.lfm}

{ TfmEditPatient }

procedure TfmEditPatient.FormShow(Sender: TObject);
begin
  edFirstName.SetFocus;
end;

end.

