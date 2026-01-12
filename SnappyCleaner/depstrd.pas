unit DepsTRD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Process;

type
  StartShowDeps = class(TThread)
  private

    { Private declarations }
  protected
  var
    ListTMP: TStringList;
    //Прототип списка с исключенными дубликатами и сортировкой

    procedure Execute; override;
    procedure ShowLeftList;
    procedure ShowRightList;
    procedure ShowRemoveStart;
    procedure ShowRemoveFinal;
  end;

implementation

uses Unit1, DepsUnit;

  { TRD }

procedure StartShowDeps.Execute;
var
  ExProcess: TProcess;
begin
  try
    //Показываем старт процесса
    Synchronize(@ShowRemoveStart);

    //Временный правый список для исключения дубликатов
    ListTMP := TStringList.Create;
    ListTMP.Sorted := True; //Сортируем
    ListTMP.Duplicates := dupIgnore; //Запрещаем дубликаты

    FreeOnTerminate := True;

    ExProcess := TProcess.Create(nil);
    ExProcess.Executable := 'bash';
    ExProcess.Options := ExProcess.Options + [poUsePipes, poWaitOnExit];
    ExProcess.Parameters.Add('-c');

    //Закидываем файл-флаг начала процесса
    ExProcess.Parameters.Add('echo "$$" > ' + ExtractFilePath(ParamStr(0)) +
      'tmp/process');

    ExProcess.Execute;

    //Левый список (требуются для этого пакета)
    ExProcess.Parameters.Delete(1);
    ExProcess.Parameters.Add('/usr/bin/urpmq --requires-recursive ' +
      Package + ' | grep -v "' + Package + '"');
    ExProcess.Execute;
    ListTMP.LoadFromStream(ExProcess.Output);
    //Показываем левый список
    Synchronize(@ShowLeftList);

    //Правый список формируется из установленных (этот пакет требуется для...)
    ExProcess.Parameters.Delete(1);

    ExProcess.Parameters.Add('for i in $(/usr/bin/urpmq --whatrequires ' +
      Package + '); do /usr/bin/rpm -q $i --qf "%{name}\n"; ' +
      'if [ ! -f "' + ExtractFilePath(ParamStr(0)) +
      'tmp/process" ]; then break; fi; done ' + '| grep -v "' + Package + '"');

    ExProcess.Execute;
    ListTMP.LoadFromStream(ExProcess.Output);
    //Показываем правый список
    Synchronize(@ShowRightList);

  finally
    Synchronize(@ShowRemoveFinal);
    ListTMP.Free;
    ExProcess.Free;
    Terminate;
  end;
end;


{ БЛОК ОТОБРАЖЕНИЯ ПРОЦЕССА }

procedure StartShowDeps.ShowRemoveStart;
begin
  //Показываем старт процесса
  DepsForm.SEdit.Enabled := False;
  DepsForm.SEdit.Button.Enabled := False;

  with MainForm do
  begin
    Panel1.Enabled := False;
    Panel2.Enabled := False;

    ProgressBar1.Visible := True;
    Timer1.Enabled := True;

    DepsForm.Caption := SPackage + ' ' + Package;
    StaticText1.Caption := SAnalizePackagesDeps;
  end;
end;

procedure StartShowDeps.ShowLeftList;
begin
  //Показываем левый список
  DepsForm.ListBox1.Items.Assign(ListTMP);
end;

procedure StartShowDeps.ShowRightList;
begin
  //Показываем правый список
  DepsForm.ListBox2.Items.Assign(ListTMP);
end;

//Финал очистки
procedure StartShowDeps.ShowRemoveFinal;
begin
  //Скрываем прогресс
  with MainForm do
  begin
    Timer1.Enabled := False;
    ProgressBar1.Visible := False;
    ProgressBar1.Position := 0;

    Panel1.Enabled := True;
    Panel2.Enabled := True;

    DepsForm.SEdit.Enabled := True;
    DepsForm.SEdit.Button.Enabled := True;

    StaticText1.Caption := SDepsAnalyzeEnd;
  end;

  if DepsForm.ListBox1.Items.Count > 0 then
    DepsForm.ListBox1.ItemIndex := 0;

  if DepsForm.ListBox2.Items.Count > 0 then
    DepsForm.ListBox2.ItemIndex := 0;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'tmp/process') then
  begin
    DepsForm.Show;

    //Снимаем флаг, процесс завершен
    DeleteFile(ExtractFilePath(ParamStr(0)) + 'tmp/process');
  end;
end;

end.
