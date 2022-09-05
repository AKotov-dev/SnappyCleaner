program SnappyCleaner;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
  cthreads,   {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Unit1,
  unique_utils,
  SysUtils,
  Dialogs,
  runtimetypeinfocontrols,
  AnalyzeTRD,
  ClearTRD,
  AboutUnit,
  DepsUnit,
  DepsTRD,
  NotOrphanTRD { you can add units after this };

var
  MyProg: TUniqueInstance;

{$R *.res}

begin
  //Создаём объект с уникальным идентификатором
  MyProg := TUniqueInstance.Create('SnappyCleaner');

  //Проверяем, нет ли в системе объекта с таким ID
  if MyProg.IsRunInstance then
  begin
    MessageDlg(SAlredyRunning, mtWarning, [mbOK], 0);
    MyProg.Free;
    Halt(1);
  end
  else
    MyProg.RunListen;

  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Title := 'SnappyCleaner v1.7';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TDepsForm, DepsForm);
  Application.Run;
end.
