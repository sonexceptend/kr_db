program KR_DB;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, treelistviewpackage, krdb_code, dmPoliclinik, krdb_fmPacient,
  krdb_editpacient, krdb_newvisit, krdb_fmDoctor, krdb_fmdiagnosis
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TfmGeneral, fmGeneral);
  Application.CreateForm(TdmPoliclinic, dmPoliclinic);
  Application.CreateForm(TfmOperator, fmOperator);
  Application.CreateForm(TfmEditPatient, fmEditPatient);
  Application.CreateForm(TfmNewVisit, fmNewVisit);
  Application.CreateForm(TfmDoctorCabinet, fmDoctorCabinet);
  Application.CreateForm(TfmDiagnosis, fmDiagnosis);
  Application.Run;
end.

