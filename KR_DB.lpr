program KR_DB;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, krdb_code, dmPoliclinik, krdb_fmPacient, krdb_editpacient
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfmGeneral, fmGeneral);
  Application.CreateForm(TdmPoliclinic, dmPoliclinic);
  Application.CreateForm(TfmOperator, fmOperator);
  Application.CreateForm(TfmEditPatient, fmEditPatient);
  Application.Run;
end.

