program Bioritmi;

uses
  Vcl.Forms,
  F_Main in 'F_Main.pas' {FMain};

{$R *.res}
var
  FMain: TFMain;
begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
