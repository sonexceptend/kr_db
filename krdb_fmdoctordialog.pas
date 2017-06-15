unit krdb_fmdoctordialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, LazUtf8
  , dmPoliclinik
  ;

type

  { TfmDoctorDialog }

  TfmDoctorDialog = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Vacancy : TStringList;
    Workers : TStringList;
    procedure UpdateVakanciList;
    procedure UpdateWorkerList;
    { private declarations }
  public
    DocID : integer;
    VacancyID : integer;
    WorkersID : integer;
    { public declarations }
  end;

var
  fmDoctorDialog: TfmDoctorDialog;

implementation

{$R *.lfm}

{ TfmDoctorDialog }

procedure TfmDoctorDialog.FormShow(Sender: TObject);
begin
  UpdateVakanciList;
  UpdateWorkerList;
  if DocID>=0 then begin
    if VacancyID>=0 then
      ComboBox1.ItemIndex:=Vacancy.IndexOf(inttostr(VacancyID));
    if Workers>=0 then
      ComboBox2.ItemIndex:=Workers.IndexOf(inttostr(WorkersID));
  end;
end;

procedure TfmDoctorDialog.FormCreate(Sender: TObject);
begin
  Vacancy := TStringList.Create;
  Workers := TStringList.Create;
end;

procedure TfmDoctorDialog.BitBtn2Click(Sender: TObject);
var idVac, idWork  :integer;
  SQLText : string;
  SQLVALUES : string = '';
  SQLCOLS : string = '';
begin
  if Caption='Новый врач поликлиники' then begin
    idVac:=-1;
    idWork:=-1;
    if ComboBox1.ItemIndex>=0 then
      idVac:=strtoint(Vacancy.ValueFromIndex[ComboBox1.ItemIndex]);
    if ComboBox2.ItemIndex>=0 then
      idWork:=strtoint(Workers.ValueFromIndex[ComboBox2.ItemIndex]);
    if idWork>=0 then begin
      SQLVALUES := SQLVALUES+'[id_Workers],';
      SQLCOLS := SQLCOLS + inttostr(idWork)+',';
    end;
    if idVac>=0 then begin
      SQLVALUES := SQLVALUES+'[id_Vacancy],';
      SQLCOLS := SQLCOLS + inttostr(idVac)+',';
    end;
    if Edit1.Text<>'' then begin
      SQLVALUES := SQLVALUES+'[Specialty],';
      SQLCOLS := SQLCOLS + #39+Edit1.Text+#39+',';
    end;
    SQLVALUES:=Copy(SQLVALUES,1,Length(SQLVALUES)-1);
    SQLCOLS:=Copy(SQLCOLS,1,Length(SQLCOLS)-1);
    SQLText := Format(dmPoliclinic.SQLList[21],[SQLVALUES,SQLCOLS]);
    //SQLText := Format(dmPoliclinic.SQLList[21],[idWork,idVac,Edit1.Text]);
    if (SQLVALUES<>'') and (SQLCOLS<>'') then begin
      dmPoliclinic.ExectSQL(SQLText);
      MOdalResult:=mrOK;
      Hide;
    end;
  end else begin
    idVac:=-1;
    idWork:=-1;
    if ComboBox1.ItemIndex>=0 then
      idVac:=strtoint(Vacancy.ValueFromIndex[ComboBox1.ItemIndex]);
    if ComboBox2.ItemIndex>=0 then
      idWork:=strtoint(Workers.ValueFromIndex[ComboBox2.ItemIndex]);
    if idWork>=0 then begin
      SQLVALUES := SQLVALUES+'[id_Workers]='+ inttostr(idWork)+',';
    end;
    if idVac>=0 then begin
      SQLVALUES := SQLVALUES+'[id_Vacancy]='+ inttostr(idVac)+',';
    end;
    if Edit1.Text<>'' then begin
      SQLVALUES := SQLVALUES+'[Specialty]='+ #39+Edit1.Text+#39+',';
    end;
    SQLVALUES:=Copy(SQLVALUES,1,Length(SQLVALUES)-1);
    SQLText := Format(dmPoliclinic.SQLList[22],[SQLVALUES,DocID]);
    //SQLText := Format(dmPoliclinic.SQLList[21],[idWork,idVac,Edit1.Text]);
    if (SQLVALUES<>'') then begin
      dmPoliclinic.ExectSQL(SQLText);
      MOdalResult:=mrOK;
      Hide;
    end;
  end;
end;

procedure TfmDoctorDialog.FormDestroy(Sender: TObject);
begin
  Vacancy.Free;
  Workers.Free;
end;

procedure TfmDoctorDialog.UpdateVakanciList;
begin
  Vacancy.Clear;
  ComboBox1.Clear;
  dmPoliclinic.ApplySQL(dmPoliclinic.SQLList[11]) ;
  if not dmPoliclinic.SQLQueryApplyData.EOF then begin
    with dmPoliclinic.SQLQueryApplyData do begin
      First;
      while not EOF do begin
        Vacancy.Add(WinCPToUtf8(Fields[0].AsString));
        ComboBox1.Items.Add(WinCPToUtf8(Fields[1].AsString)+' ['+WinCPToUtf8(Fields[2].AsString)+']');
        Next;
      end;
    end;
  end;
end;

procedure TfmDoctorDialog.UpdateWorkerList;
begin
  Workers.Clear;
  ComboBox2.Clear;
  dmPoliclinic.ApplySQL(dmPoliclinic.SQLList[15]) ;
  if not dmPoliclinic.SQLQueryApplyData.EOF then begin
    with dmPoliclinic.SQLQueryApplyData do begin
      First;
      while not EOF do begin
        Workers.Add(WinCPToUtf8(Fields[0].AsString));
        ComboBox2.Items.Add(WinCPToUtf8(Fields[1].AsString)+#32+WinCPToUtf8(Fields[2].AsString)+#32+WinCPToUtf8(Fields[3].AsString));
        Next;
      end;
    end;
  end;
end;

end.

