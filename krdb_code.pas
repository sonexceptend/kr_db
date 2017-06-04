unit krdb_code;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons
  , dmPoliclinik
  , krdb_fmPacient
  , krdb_fmDoctor
  ;

type

  { TfmGeneral }

  TfmGeneral = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    StatusBar1: TStatusBar;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure OnConnect(Sender: TObject);
    procedure OnDisconnect(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fmGeneral: TfmGeneral;

implementation

{$R *.lfm}

{ TfmGeneral }

procedure TfmGeneral.FormCreate(Sender: TObject);
begin

end;

procedure TfmGeneral.FormShow(Sender: TObject);
begin
  try
    dmPoliclinic.ODBCConnection1.BeforeConnect:=@OnConnect;
    dmPoliclinic.ODBCConnection1.BeforeDisconnect:=@OnDisconnect;
    dmPoliclinic.ODBCConnection1.Connected:=true;
  except
    on Err : exception do begin
      dmPoliclinic.ODBCConnection1.Connected:=false;
    end;
  end;
end;

procedure TfmGeneral.OnConnect(Sender: TObject);
begin
  BitBtn1.Enabled:=true;
  BitBtn2.Enabled:=true;
  BitBtn3.Enabled:=true;
  BitBtn4.Enabled:=true;
  StatusBar1.Panels[0].Text:='DB connected OK';
end;

procedure TfmGeneral.OnDisconnect(Sender: TObject);
begin
  BitBtn1.Enabled:=false;
  BitBtn2.Enabled:=false;
  BitBtn3.Enabled:=false;
  BitBtn4.Enabled:=true;

  StatusBar1.Panels[0].Text:='DB connected NO';
end;

procedure TfmGeneral.BitBtn1Click(Sender: TObject);
begin
  fmOperator.ShowModal;
end;

procedure TfmGeneral.BitBtn2Click(Sender: TObject);
begin
  fmDoctorCabinet.ShowModal;
end;

procedure TfmGeneral.BitBtn4Click(Sender: TObject);
begin

end;

end.

