unit krdb_fmvakancidialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons;

type

  { TfmVakanciDialog }

  TfmVakanciDialog = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit1: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fmVakanciDialog: TfmVakanciDialog;

implementation

{$R *.lfm}

end.

