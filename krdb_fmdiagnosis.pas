unit krdb_fmdiagnosis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TreeListView, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls
  , dmPoliclinik
  , LazUTF8
  ;

type

  { TfmDiagnosis }

  TfmDiagnosis = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ToolBar1: TToolBar;
    TreeListView1: TTreeListView;
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
  TreeListView1.Items.Clear;
  UpdateTableDiagnosis(0,2,nil,'');
  fShow:=false;
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

