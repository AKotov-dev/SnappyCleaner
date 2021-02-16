unit ClearTRD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Process;

type
  StartClear = class(TThread)
  private

    { Private declarations }
  protected
    procedure Execute; override;
    procedure ShowRootTMP;
    procedure ShowUserTrash;
    procedure ShowUserTMP;
    procedure ShowRecentDocuments;
    procedure ShowURPMICache;
    procedure ShowFireFoxCache;
    procedure ShowChromeCache;
    procedure ShowOperaCache;
    procedure ShowChromiumCache;
    procedure ShowPaleMoonCache;
    procedure ClearFinal;
    procedure ShowDelPackages;
    procedure ShowRepairRPM;
  end;

implementation

uses Unit1;

{ TRD }

procedure StartClear.Execute;
var
  ExProcess: TProcess;
begin
  try
    FreeOnTerminate := True;
    ExProcess := TProcess.Create(nil);
    ExProcess.Executable := '/usr/bin/sh';
    ExProcess.Options := ExProcess.Options + [poUsePipes, poWaitOnExit];

    //Временные файлы root
    if MainForm.RootTmpCheck.Checked then
    begin
      Synchronize(@ShowRootTMP);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/root/tmp" ]; then ' +
        'rm -rf /root/tmp/* /root/tmp/.*; fi;');
      ExProcess.Execute;
    end;

    //Корзина пользователя
    if MainForm.UserTrashCheck.Checked then
    begin
      Synchronize(@ShowUserTrash);

      //Очищаем корзины флешек (/run/media/user/vol/.Trash-1000)
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add(
        '/usr/bin/find /run/media -type d -name ".Trash-*" -exec rm -rf {} \;');
      ExProcess.Execute;

      //Очищаем корзину локального диска (пересоздаём скрытые папки)
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add(
        'if [ -d "/home/' + ActUser[0] + '/.local/share/Trash/files" -a ' +
        '-d "/home/' + ActUser[0] + '/.local/share/Trash/info" ]; ' +
        'then /usr/bin/rm -rf /home/' + ActUser[0] + '/.local/share/Trash/* ' +
        ' /home/' + ActUser[0] + '/.local/share/Trash/.*; ' +
        '/usr/bin/su -c "mkdir -m 700 /home/' + ActUser[0] +
        '/.local/share/Trash/files ' + '/home/' + ActUser[0] +
        '/.local/share/Trash/info" ' + ActUser[0] + '; fi;');
      ExProcess.Execute;
    end;

    //Временные файлы пользователя
    if MainForm.UserTMPCheck.Checked then
    begin
      Synchronize(@ShowUserTMP);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/tmp" ]; then /usr/bin/rm -rf /home/' + ActUser[0] + '/tmp/* ' +
        '/home/' + ActUser[0] + '/tmp/.*; fi;');
      ExProcess.Execute;
    end;

    //RecentDocuments
    if MainForm.UserRecentCheck.Checked then
    begin
      Synchronize(@ShowRecentDocuments);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.local/share/RecentDocuments" ]; then /usr/bin/rm -rf /home/' +
        ActUser[0] + '/.local/share/RecentDocuments/* ' + '/home/' +
        ActUser[0] + '/.local/share/RecentDocuments/.*; fi;');
      ExProcess.Execute;
    end;

    //Ремонт базы RPM
    if MainForm.RepairRPMCheck.Checked then
    begin
      Synchronize(@ShowRepairRPM);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add(
        '/usr/bin/rm -f /var/lib/rpm/__db*; /usr/bin/rpm --rebuilddb');
      ExProcess.Execute;
    end;

    //Кеш URPMI
    if MainForm.CacheURPMICheck.Checked then
    begin
      Synchronize(@ShowURPMICache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('/usr/sbin/urpmi --clean');
      ExProcess.Execute;
    end;

    //Кеш Mozilla Firefox
    if MainForm.CacheMozillaCheck.Checked then
    begin
      Synchronize(@ShowFireFoxCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/mozilla" ]; then /usr/bin/rm -rf /home/' + ActUser[0] +
        '/.cache/mozilla/* /home/' + ActUser[0] + '/.cache/mozilla/.*; fi;');
      ExProcess.Execute;
    end;

    //Кеш Google Chrome
    if MainForm.CacheChromeCheck.Checked then
    begin
      Synchronize(@ShowChromeCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/google-chrome" ]; then /usr/bin/rm -rf /home/' +
        ActUser[0] + '/.cache/google-chrome/* /home/' + ActUser[0] +
        '/.cache/google-chrome/.*; fi;');
      ExProcess.Execute;
    end;

    //Кеш Opera
    if MainForm.CacheOperaCheck.Checked then
    begin
      Synchronize(@ShowOperaCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/opera" ]; then /usr/bin/rm -rf /home/' + ActUser[0] +
        '/.cache/opera/* /home/' + ActUser[0] + '/.cache/opera/.*; fi;');
      ExProcess.Execute;
    end;

    //Кеш Chromium
    if MainForm.CacheChromiumCheck.Checked then
    begin
      Synchronize(@ShowChromiumCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/chromium" ]; then /usr/bin/rm -rf /home/' + ActUser[0] +
        '/.cache/chromium/* /home/' + ActUser[0] + '/.cache/chromium/.*; fi;');
      ExProcess.Execute;
    end;

    //Кеш PaleMoon
    if MainForm.CachePaleMoonCheck.Checked then
    begin
      Synchronize(@ShowPaleMoonCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/moonchild productions" ]; then /usr/bin/rm -rf "/home/' +
        ActUser[0] + '/.cache/moonchild productions/"* "/home/' +
        ActUser[0] + '/.cache/moonchild productions/."*; fi;');
      ExProcess.Execute;
    end;


    //Удаление списка пакетов
    if (DelKernels <> '') or (DelOrphans <> '') then
    begin
      Synchronize(@ShowDelPackages);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('/usr/sbin/urpme --auto ' +
        Trim(DelKernels + DelOrphans));
      ExProcess.Execute;
    end;

  finally
    Synchronize(@ClearFinal);
    ExProcess.Free;
    Terminate;
  end;
end;


////// БЛОК ОТОБРАЖЕНИЯ ПРОЦЕССА /////////////

//Показываю удаление временных файлов root
procedure StartClear.ShowRootTMP;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю временные файлы root, ждите...'
  else
    MainForm.StaticText1.Caption :=
      'clean the temporary root files, wait...';
end;

//Показываю очистку корзины $USER
procedure StartClear.ShowUserTrash;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю корзину пользователя ' +
      ActUser[0] + ', ждите...'
  else
    MainForm.StaticText1.Caption :=
      'clean the user recycle bin, wait...';
end;

//Показываю очистку временных файлов $USER
procedure StartClear.ShowUserTMP;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю временные файлы пользователя ' +
      ActUser[0] + ', ждите...'
  else
    MainForm.StaticText1.Caption :=
      'clean temporary user files, wait...';
end;

//Показываю удаление RecentDocuments
procedure StartClear.ShowRecentDocuments;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю RecentDocuments пользователя ' +
      ActUser[0] + ', ждите...'
  else
    MainForm.StaticText1.Caption :=
      'clean RecentDocuments user files, wait...';
end;

//Показываю ремонт базы данных RPM
procedure StartClear.ShowRepairRPM;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'ремонтирую базу данных RPM, ждите...'
  else
    MainForm.StaticText1.Caption := 'repairing the RPM database, wait...';
end;

//Показываю очистку кеша URPMI
procedure StartClear.ShowURPMICache;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption := 'очищаю кеш URPMI, ждите...'
  else
    MainForm.StaticText1.Caption := 'clean URPMI cache, wait...';
end;

//Показываю удаление кеша Mozilla FireFox
procedure StartClear.ShowFireFoxCache;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption := 'очищаю кеш Mozilla Firefox, ждите...'
  else
    MainForm.StaticText1.Caption := 'clean Mozilla Firefox cache, wait...';
end;

//Показываю удаление кеша Google Chrome
procedure StartClear.ShowChromeCache;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю кеш браузера Google Chrome, ждите...'
  else
    MainForm.StaticText1.Caption := 'clean Google Chrome cache, wait...';
end;

//Показываю удаление кеша Opera
procedure StartClear.ShowOperaCache;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю кеш браузера Opera, ждите...'
  else
    MainForm.StaticText1.Caption := 'clean Opera browser cache, wait...';
end;

//Показываю удаление кеша Chromium
procedure StartClear.ShowChromiumCache;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю кеш браузера Chromium, ждите...'
  else
    MainForm.StaticText1.Caption := 'clean Chromium browser cache, wait...';
end;

//Показываю удаление кеша PaleMoon
procedure StartClear.ShowPaleMoonCache;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'очищаю кеш браузера PaleMoon, ждите...'
  else
    MainForm.StaticText1.Caption := 'clean PaleMoon browser cache, wait...';
end;

//Показываю удаление пакетов (ядра и сироты)
procedure StartClear.ShowDelPackages;
begin
  if MainForm.LangBtn.Caption = 'EN' then
    MainForm.StaticText1.Caption :=
      'удаляю выбранные пакеты, ждите...'
  else
    MainForm.StaticText1.Caption := 'remove the selected packages, wait...';
end;

//Финал очистки
procedure StartClear.ClearFinal;
begin
  //Скрываем прогресс
  with MainForm do
  begin
    Timer1.Enabled := False;
    ProgressBar1.Visible := False;
    ProgressBar1.Position := 0;
    AnalyzeBtn.Click;
  end;
end;

end.
