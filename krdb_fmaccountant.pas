unit krdb_fmaccountant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ExtendedNotebook, Forms, Controls, Graphics,
  Dialogs, Grids, ComCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ExtendedNotebook1: TExtendedNotebook;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

end.

