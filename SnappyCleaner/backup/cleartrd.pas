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
    procedure ShowDNFCache;
    procedure ShowFireFoxCache;
    procedure ShowChromeCache;
    procedure ShowOperaCache;
    procedure ShowChromiumCache;
    procedure ShowPaleMoonCache;
    procedure ShowBraveCache;
    procedure ShowThumbnails;
    procedure ShowBashHistory;
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

    //RecentDocuments and recent*.xbel
    if MainForm.UserRecentCheck.Checked then
    begin
      Synchronize(@ShowRecentDocuments);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.local/share/RecentDocuments" ]; then /usr/bin/rm -rf /home/' +
        ActUser[0] + '/.local/share/RecentDocuments/* ' + '/home/' +
        ActUser[0] + '/.local/share/RecentDocuments/.*; fi; ' +
        'rm -f /home/' + ActUser[0] + '/.local/share/recent*.xbel');
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

    //Кеш DNF
    if MainForm.CacheDNFCheck.Checked then
    begin
      Synchronize(@ShowDNFCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('/usr/bin/dnf clean all');
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

    //Кеш Brave
    if MainForm.CacheBraveCheck.Checked then
    begin
      Synchronize(@ShowBraveCache);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/BraveSoftware/Brave-Browser/Default" ]; then /usr/bin/rm -rf "/home/'
        +
        ActUser[0] + '/.cache/BraveSoftware/Brave-Browser/Default/"* "/home/' +
        ActUser[0] + '/.cache/BraveSoftware/Brave-Browser/Default/."*; fi;');
      ExProcess.Execute;
    end;

    //Кеш ~/.cache/thumbnails/* (без индикации KБ/MБ)
    begin
      Synchronize(@ShowThumbnails);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
        '/.cache/thumbnails" ]; then /usr/bin/rm -rf /home/' +
        ActUser[0] + '/.cache/thumbnails/* ; fi;');
      ExProcess.Execute;
    end;

    //Очистка истории BASH для всех пользователей (без индикации KБ/MБ)
    begin
      Synchronize(@ShowBashHistory);
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add(
        'for dir in /root /home/*; do if [ -d "$dir" ]; ' +
        'then rm -f "$dir/.bash_history" "$dir/.bash_history-*.tmp"; fi; done');
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
  MainForm.StaticText1.Caption := SCleanTMPRootFiles;
end;

//Показываю очистку корзины $USER
procedure StartClear.ShowUserTrash;
begin
  MainForm.StaticText1.Caption := SCleanUserRecycle;
end;

//Показываю очистку временных файлов $USER
procedure StartClear.ShowUserTMP;
begin
  MainForm.StaticText1.Caption := SCleanTMPUserFiles;
end;

//Показываю удаление RecentDocuments and recent*.xbel
procedure StartClear.ShowRecentDocuments;
begin
  MainForm.StaticText1.Caption := SCleanRecentDocuments;
end;

//Показываю ремонт базы данных RPM
procedure StartClear.ShowRepairRPM;
begin
  MainForm.StaticText1.Caption := SRPMDBRepairing;
end;

//Показываю очистку кеша URPMI
procedure StartClear.ShowURPMICache;
begin
  MainForm.StaticText1.Caption := SCleanURPMICache;
end;

//Показываю очистку кеша DNF
procedure StartClear.ShowDNFCache;
begin
  MainForm.StaticText1.Caption := SCleanDNFCache;
end;

//Показываю удаление кеша Mozilla FireFox
procedure StartClear.ShowFireFoxCache;
begin
  MainForm.StaticText1.Caption := SCleanMozillaCache;
end;

//Показываю удаление кеша Google Chrome
procedure StartClear.ShowChromeCache;
begin
  MainForm.StaticText1.Caption := SCleanChromeCache;
end;

//Показываю удаление кеша Opera
procedure StartClear.ShowOperaCache;
begin
  MainForm.StaticText1.Caption := SCleanOperaCache;
end;

//Показываю удаление кеша Chromium
procedure StartClear.ShowChromiumCache;
begin
  MainForm.StaticText1.Caption := SCleanChromiumCache;
end;

//Показываю удаление кеша PaleMoon
procedure StartClear.ShowPaleMoonCache;
begin
  MainForm.StaticText1.Caption := SCleanPalemoonCache;
end;

//Показываю удаление кеша Brave
procedure StartClear.ShowBraveCache;
begin
  MainForm.StaticText1.Caption := SCleanBraveCache;
end;

//Показываю удаление ~/.cache/thumbnails/large/*
procedure StartClear.ShowThumbnails;
begin
  MainForm.StaticText1.Caption := SCleanThumbnails;
end;

//Показываю удаление истории BASH для всех пользователей
procedure StartClear.ShowThumbnails;
begin
  MainForm.StaticText1.Caption := SCleanBashHistory;
end;

//Показываю удаление пакетов (ядра и сироты)
procedure StartClear.ShowDelPackages;
begin
  MainForm.StaticText1.Caption := SRemoveSelectedPackages;
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
