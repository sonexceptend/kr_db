unit krdb_fmdiagnosis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TreeListView, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Buttons
  , dmPoliclinik
  , LazUTF8
  ;

type

  { TfmDiagnosis }

  TfmDiagnosis = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    TreeListView1: TTreeListView;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
    procedure TreeListView1ItemExpanded(sender: TObject; item: TTreeListItem);
  private
    fShow : boolean;
    { private declarations }
  public
    procedure UpdateTableDiagnosis(level : integer; levelCount :integer; Node : TTreeListItem; ParentCode : string);
    { public declarations }
  end;

var
  fmDiagnosis: TfmDiagnosis;

implementation

{$R *.lfm}

{ TfmDiagnosis }

procedure TfmDiagnosis.FormShow(Sender: TObject);
begin
  if TreeListView1.Items.Count<>0 then exit;
  TreeListView1.Items.Clear;
  UpdateTableDiagnosis(0,2,nil,'');
  fShow:=false;
end;

procedure TfmDiagnosis.BitBtn1Click(Sender: TObject);
begin
  ModalResult:=mrOK;
  Hide;
end;

procedure TfmDiagnosis.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
  Hide;
end;

procedure TfmDiagnosis.Edit1KeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TfmDiagnosis.TreeListView1ItemExpanded(sender: TObject;
  item: TTreeListItem);
var i : integer;
begin
  if not fShow then begin
    for i:=0 to item.SubItems.Count-1 do begin
      if item.SubItems[i].SubItems.Count=0 then
        UpdateTableDiagnosis(0,1,item.SubItems[i],item.SubItems[i].Text);
    end;
    fShow:=false;
  end;
end;

procedure TfmDiagnosis.UpdateTableDiagnosis(level: integer; levelCount :integer; Node : TTreeListItem; ParentCode : string);
var DiagnosList : TStringList;
    TmpNode:TTreeListItem;
    i : integer;
begin
  fShow:=true;

  if level>=levelCount then exit;
  DiagnosList := TStringList.Create;
  if ParentCode='' then
    dmPoliclinic.ApplySQL(dmPoliclinic.SQLList[6])
  else
    dmPoliclinic.ApplySQL(Format(dmPoliclinic.SQLList[7],[ParentCode]));
  if not dmPoliclinic.SQLQueryApplyData.EOF then begin
    with dmPoliclinic.SQLQueryApplyData do begin
      First;
      while not EOF do begin
        DiagnosList.Values[WinCPToUtf8(Fields[1].AsString)]:=WinCPToUtf8(Fields[2].AsString);
        Next;
      end;
    end;
  end;
  for i:=0 to DiagnosList.Count-1 do begin
    if Node=nil then begin
      TmpNode:=TreeListView1.Items.Add;
      with TmpNode do begin
        Text:=DiagnosList.Names[i];
        RecordItems.Add(DiagnosList.Values[DiagnosList.Names[i]]);

      end;
      UpdateTableDiagnosis(level+1,levelCount,TmpNode,DiagnosList.Names[i]);
      TmpNode.Collapse;
    end else begin
      TmpNode:=Node.SubItems.Add(DiagnosList.Names[i]);
      TmpNode.RecordItems.Add(DiagnosList.Values[DiagnosList.Names[i]]);
      UpdateTableDiagnosis(level+1,levelCount,TmpNode,DiagnosList.Names[i]);
      TmpNode.Collapse;
    end;
  end;


  DiagnosList.Free;
end;

end.

