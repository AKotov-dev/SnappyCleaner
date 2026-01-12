unit AnalyzeTRD;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Controls, SysUtils, Process, StdCtrls;

type
  StartAnalyze = class(TThread)
  private


    { Private declarations }
  protected
  var
    Result: TStringList;

    procedure Execute; override;

    procedure ShowRootTMP;
    procedure ShowUserTrash;
    procedure ShowUserTMP;
    procedure ShowRecentDocuments;
    procedure ShowURPMICache;
    procedure ShowDNFCache;
    procedure ShowMozillaCache;
    procedure ShowChromeCache;
    procedure ShowOperaCache;
    procedure ShowChromiumCache;
    procedure ShowPaleMoonCache;
    procedure ShowBraveCache;
    procedure ShowHomeUsage;

    procedure ShowNewKernel;

    procedure ShowRemKernels;
    procedure ShowRemKernelsSize;

    procedure ShowRemOrphans;
    procedure ShowRemOrphansSize;

    procedure StopAnalyzeProcess;

  end;

implementation

uses Unit1;

{ TRD }

procedure StartAnalyze.Execute;
var
  ExProcess: TProcess;
begin
  try
    FreeOnTerminate := True;

    //Результирующий список
    Result := TStringList.Create;

    ExProcess := TProcess.Create(nil);
    ExProcess.Executable := '/usr/bin/sh';
    ExProcess.Options := ExProcess.Options + [poUsePipes, poWaitOnExit];

    { ЛЕВЫЙ БЛОК - КОРЗИНА и ПРОЧЕЕ }

    //Каталог /root/tmp
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/root/tmp" ]; then ' +
      'roottmp=$(/usr/bin/du -csh /root/tmp/* /root/tmp/.[!.]* | tail -n1 | cut -f1' +
      '); else roottmp="no"; fi; echo $roottmp');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер /root/tmp
    Synchronize(@ShowRootTMP);

    //Корзина пользователя
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add(
      'if [[ -n $(/usr/bin/find /run/media -type d -name ".Trash-1000") ]]; ' +
      'then flash="$(/usr/bin/find /run/media -type d -name ".Trash-1000")/files/* ' +
      '$(/usr/bin/find /run/media -type d -name ".Trash-1000")/files/.[!.]* ' +
      '$(/usr/bin/find /run/media -type d -name ".Trash-1000")/info/* ' +
      '$(/usr/bin/find /run/media -type d -name ".Trash-1000")/info/.[!.]*"; else flash=""; fi; '
      + 'if [[ -n $(/usr/bin/find /run/media -type d -name ".Trash-500") ]]; ' +
      'then flash="$flash $(/usr/bin/find /run/media -type d -name ".Trash-500")/files/* '
      + '$(/usr/bin/find /run/media -type d -name ".Trash-500")/files/.[!.]* ' +
      '$(/usr/bin/find /run/media -type d -name ".Trash-500")/info/* ' +
      '$(/usr/bin/find /run/media -type d -name ".Trash-500")/info/.[!.]*"; else flash=""; fi; '
      + 'if [ -d "/home/' + ActUser[0] +
      '/.local/share/Trash" ]; then if [ -d "/home/' + ActUser[0] +
      '/.local/share/Trash/files" ]; then ' + 'trash=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.local/share/Trash/files/* /home/' + ActUser[0] +
      '/.local/share/Trash/files/.[!.]* ' + '/home/' + ActUser[0] +
      '/.local/share/Trash/info/* /home/' + ActUser[0] +
      '/.local/share/Trash/info/.[!.]* $flash | tail -n1 | cut -f1' +
      '); else trash="0"; fi; else trash="no"; fi; echo $trash');

    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер корзины
    Synchronize(@ShowUserTrash);

    //Временные файлы пользователя
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/tmp" ]; then ' + 'usertmp=$(/usr/bin/du -csh /home/' + ActUser[0] +
      '/tmp/* /home/' + ActUser[0] + '/tmp/.[!.]* | tail -n1 | cut -f1' +
      '); else usertmp="no"; fi; echo $usertmp');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер временных файлов пользователя
    Synchronize(@ShowUserTMP);

    //Каталог RecentDocuments and recent*.xbel
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('userrdoc=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.local/share/RecentDocuments/* /home/' +
      ActUser[0] + '/.local/share/RecentDocuments/.[!.]* /home/' +
      ActUser[0] + '/.local/share/recent*.xbel | tail -n1 | cut -f1); echo $userrdoc');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер RecentDocuments and recent*.xbel
    Synchronize(@ShowRecentDocuments);

    //Каталог кеш-URPMI
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/var/cache/urpmi" ]; then ' +
      'urpmicache=$(/usr/bin/du -csh /var/cache/urpmi/* /var/cache/urpmi/.[!.]* | tail -n1 | cut -f1'
      + '); else urpmicache="no"; fi; echo $urpmicache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша URPMI
    Synchronize(@ShowURPMICache);

    //Каталог кеш-DNF
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/var/cache/dnf" ]; then ' +
      'dnfcache=$(/usr/bin/du -csh /var/cache/dnf/* /var/cache/dnf/.[!.]* | tail -n1 | cut -f1'
      + '); else dnfcache="no"; fi; echo $dnfcache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша DNF
    Synchronize(@ShowDNFCache);

    //Кеш Mozilla Firefox
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/.cache/mozilla" ]; then ' + 'mozcache=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.cache/mozilla/* /home/' + ActUser[0] +
      '/.cache/mozilla/.[!.]* | tail -n1 | cut -f1); else mozcache="no"; fi; echo $mozcache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша Mozilla
    Synchronize(@ShowMozillaCache);

    //Кеш Google Chrome
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/.cache/google-chrome" ]; then ' + 'chromecache=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.cache/google-chrome/* /home/' + ActUser[0] +
      '/.cache/google-chrome/.[!.]* | tail -n1 | cut -f1); else chromecache="no"; fi; echo $chromecache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша Chrome
    Synchronize(@ShowChromeCache);

    //Кеш Opera
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/.cache/opera" ]; then ' + 'operacache=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.cache/opera/* /home/' + ActUser[0] +
      '/.cache/opera/.[!.]* | tail -n1 | cut -f1); else operacache="no"; fi; echo $operacache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша Opera
    Synchronize(@ShowOperaCache);

    //Кеш Chromium
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/.cache/chromium" ]; then ' + 'chromiumcache=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.cache/chromium/* /home/' + ActUser[0] +
      '/.cache/chromium/.[!.]* | tail -n1 | cut -f1); else chromiumcache="no"; fi; echo $chromiumcache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша Chromium
    Synchronize(@ShowChromiumCache);

    //Кеш PaleMoon
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/.cache/moonchild productions" ]; then ' +
      'palemooncache=$(/usr/bin/du -csh "/home/' + ActUser[0] +
      '/.cache/moonchild productions/"* "/home/' + ActUser[0] +
      '/.cache/moonchild productions/.[!.]"* | tail -n1 | cut -f1); else palemooncache="no"; fi; echo $palemooncache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша Palemoon
    Synchronize(@ShowPaleMoonCache);

    //Кеш Brave
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('if [ -d "/home/' + ActUser[0] +
      '/.cache/BraveSoftware/Brave-Browser/Default/Cache/Cache_Data" ]; then ' + 'bravecache=$(/usr/bin/du -csh /home/' +
      ActUser[0] + '/.cache/BraveSoftware/Brave-Browser/Default/Cache/Cache_Data/* /home/' + ActUser[0] +
      '/.cache/BraveSoftware/Brave-Browser/Default/Cache/Cache_Data/.[!.]* | tail -n1 | cut -f1); else bravecache="no"; fi; echo $bravecache');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем размер кеша Brave
    Synchronize(@ShowBraveCache);

    //Использование /home
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add(
      '/usr/bin/df /home/ --output=pcent | tail -n1 | cut -d% -f1');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем использование /home
    Synchronize(@ShowHomeUsage);


    { ПРАВЫЙ БЛОК - ЯДРА И СИРОТЫ }

    //Узнаём тип ядра
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('for ktype in "server" "desktop" "linus"; do ' +
      'if [ -n "$(uname -r | grep $ktype)" ]; then break; fi; done; echo $ktype');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output); //Result[0] - тип ядра


    //Начитываем список всех ядер
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');

    //Начиная с M9 теги фильтрации отличаются (Mageia-Bug 24403)
    ExProcess.Parameters.Add('if [[ $(uname -r | rev | cut -c1) -lt "9" ]]; then ' +
      'allkernel=$(rpm -qa kernel-' + Result[0] + '* --qf ' +
      '''%{name}\n''' + ' | ' + 'grep -v "latest" | sort -V); echo "$allkernel"; else ' +
      'allkernel=$(rpm -qa kernel-' + Result[0] + '* --qf ' +
      '''%{name}-%{version}-%{release}\n''' + ' | ' +
      'grep -v "latest" | sort -V); echo "$allkernel"; fi');

    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Выгружаем в файл, готовимся оставить только ядра на удаление
    Result.SaveToFile(ExtractFilePath(ParamStr(0)) + 'tmp/remkernel');

    //Выделяем активное ядро
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('actkernel=$(uname -r); echo "$actkernel"');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);
    //Показываем активное ядро
    Synchronize(@ShowNewKernel);

    //Вычислем сигнатуру активного ядра
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('signature=$(echo ' + Result[0] +
      '| sed ' + '''s/[^0-9]/' + '/g''' + '); echo $signature');
    ExProcess.Execute;
    Result.LoadFromStream(ExProcess.Output);

    //Удаляем из списка имена ядер, если сигнатура = сигнатуре активного ядра
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('while read LINE; do ' + 'if [[ $(echo "$LINE" | sed ' +
      '''s/[^0-9]/' + '/g''' + ') -eq "' + Result[0] + '" ]]; then ' +
      'sed -i "/$LINE/d" "' + ExtractFilePath(ParamStr(0)) +
      'tmp/remkernel"; ' + 'fi; done < "' + ExtractFilePath(ParamStr(0)) +
      'tmp/remkernel"');
    ExProcess.Execute;
    //Показываем список удаляемых ядер
    Synchronize(@ShowRemKernels);

    //Рассчитываем размер удаляемых ядер
    if Trim(MainForm.RemKernelBox.Items.Text) <> '' then
    begin
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('klsize=$(/usr/bin/rpm -qi ' +
        StringReplace(MainForm.RemKernelBox.Items.Text, #10, ' ', [rfReplaceAll]) +
        ' | grep "Size" | cut -f 2 -d : -s | cut -c 2-); ' +
        'klsize=$(echo $klsize | sed ' + '''s/ /+/g''' +
        '); if [[ "$klsize" -lt "1048576" ]]; then let "klsize=($klsize) / 1024"; ' +
        'echo ${klsize}K; else let "klsize=($klsize) / 1048576"; echo ${klsize}M; fi;');
      ExProcess.Execute;
      Result.LoadFromStream(ExProcess.Output);
    end
    else
      Result.Insert(0, '0');
    //Показываем размер удаляемых ядер
    Synchronize(@ShowRemKernelsSize);

    //Сохраняем список urpmq --auto-orphans в ../auto-orphans
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('/usr/bin/urpmq --auto-orphans > ' +
      ExtractFilePath(ParamStr(0)) + 'tmp/auto-orphans');
    ExProcess.Execute;

    //Исключаем из списка auto-orphans старые ядра
    ExProcess.Parameters.Clear;
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('/usr/bin/grep -f ' + ExtractFilePath(ParamStr(0)) +
      'tmp/remkernel ' + '-vFx ' + ExtractFilePath(ParamStr(0)) +
      'tmp/auto-orphans > ' + ExtractFilePath(ParamStr(0)) +
      'tmp/auto-orphans-tmp; ' + 'cp -f ' + ExtractFilePath(ParamStr(0)) +
      'tmp/auto-orphans-tmp ' + ExtractFilePath(ParamStr(0)) + 'tmp/auto-orphans');
    ExProcess.Execute;
    //Показываем список сирот
    Synchronize(@ShowRemOrphans);

    //Рассчитываем вес осиротевших пакетов
    if MainForm.AutoOrphansBox.Count > 0 then
    begin
      ExProcess.Parameters.Clear;
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add('orpsize=$(/usr/bin/rpm -qi ' +
        StringReplace(MainForm.AutoOrphansBox.Items.Text, #10, ' ', [rfReplaceAll]) +
        ' | grep "Size" | cut -f 2 -d : -s | cut -c 2-); ' +
        'orpsize=$(echo $orpsize | sed ' + '''s/ /+/g''' +
        '); if [[ "$orpsize" -lt "1048576" ]]; then let "orpsize=($orpsize) / 1024"; ' +
        'echo ${orpsize}K; else let "orpsize=($orpsize) / 1048576"; echo ${orpsize}M; fi;');
      ExProcess.Execute;
      Result.LoadFromStream(ExProcess.Output);
    end
    else
      Result.Insert(0, '0');
    //Показываем размер осиротевших пакетов
    Synchronize(@ShowRemOrphansSize);

  finally
    Synchronize(@StopAnalyzeProcess);
    ExProcess.Free;
    Result.Free;
    Terminate;
  end;
end;


{ БЛОК ОТОБРАЖЕНИЯ РЕЗУЛЬТАТОВ }

procedure StartAnalyze.ShowRootTMP;
begin
  //Каталог /root/tmp
  if (Result[0] = 'no') then
    MainForm.Label24.Caption := SNo
  else
    MainForm.Label24.Caption := Result[0];
end;

procedure StartAnalyze.ShowUserTrash;
begin
  //Показываем размер корзины
  if (Result[0] = 'no') then
    MainForm.Label10.Caption := SNo
  else
    MainForm.Label10.Caption := Result[0];
end;

procedure StartAnalyze.ShowUserTMP;
begin
  //Показываем вес временных файлов:
  if (Result[0] = 'no') then
    MainForm.Label12.Caption := SNo
  else
    MainForm.Label12.Caption := Result[0];
end;

procedure StartAnalyze.ShowRecentDocuments;
begin
  //Показываем размер RecentDocuments and recent*.xbel
  if (Result[0] = 'no') then
    MainForm.Label14.Caption := SNo
  else
    MainForm.Label14.Caption := Result[0];
end;

procedure StartAnalyze.ShowURPMICache;
begin
  //Показываем размер кеша URPMI
  MainForm.Label16.Caption := Result[0];
end;

procedure StartAnalyze.ShowDNFCache;
begin
  //Показываем размер кеша DNF
  MainForm.Label17.Caption := Result[0];
end;

procedure StartAnalyze.ShowMozillaCache;
begin
  //Показываем размер кеша Mozilla
  if (Result[0] = 'no') then
    MainForm.Label18.Caption := SNo
  else
    MainForm.Label18.Caption := Result[0];
end;

procedure StartAnalyze.ShowChromeCache;
begin
  //Показываем размер кеша Chrome
  if (Result[0] = 'no') then
    MainForm.Label20.Caption := SNo
  else
    MainForm.Label20.Caption := Result[0];
end;

procedure StartAnalyze.ShowOperaCache;
begin
  //Показываем размер кеша Opera
  if (Result[0] = 'no') then
    MainForm.Label22.Caption := SNo
  else
    MainForm.Label22.Caption := Result[0];
end;

procedure StartAnalyze.ShowChromiumCache;
begin
  //Показываем размер кеша Chromium
  if (Result[0] = 'no') then
    MainForm.Label23.Caption := SNo
  else
    MainForm.Label23.Caption := Result[0];
end;

procedure StartAnalyze.ShowPaleMoonCache;
begin
  //Показываем размер кеша PaleMoon
  if (Result[0] = 'no') then
    MainForm.Label27.Caption := SNo
  else
    MainForm.Label27.Caption := Result[0];
end;

procedure StartAnalyze.ShowBraveCache;
begin
  //Показываем размер кеша Brave
  if (Result[0] = 'no') then
    MainForm.Label28.Caption := SNo
  else
    MainForm.Label28.Caption := Result[0];
end;

procedure StartAnalyze.ShowHomeUsage;
begin
  //Показываем использование /home
  MainForm.Label26.Caption := Trim(Result[0]) + '%';
end;

procedure StartAnalyze.ShowNewKernel;
begin
  //Показываем активное ядро
  MainForm.Label2.Caption := Result[0];
end;

procedure StartAnalyze.ShowRemKernels;
begin
  //Показываем список удаляемых ядер
  MainForm.RemKernelBox.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) +
    'tmp/remkernel');
end;

procedure StartAnalyze.ShowRemKernelsSize;
begin
  //Показываем вес удаляемых ядер
  MainForm.Label6.Caption := Result[0];
end;

procedure StartAnalyze.ShowRemOrphans;
begin
  //Показываем список осиротевших пакетов
  MainForm.AutoOrphansBox.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) +
    'tmp/auto-orphans');
end;

procedure StartAnalyze.ShowRemOrphansSize;
begin
  //Показываем вес пакетов-сирот
  MainForm.Label1.Caption := Result[0];
end;

procedure StartAnalyze.StopAnalyzeProcess;
begin
  //Скрываем прогресс
  with MainForm do
  begin
    Timer1.Enabled := False;
    ProgressBar1.Visible := False;
    ProgressBar1.Position := 0;

    Panel1.Enabled := True;
    Panel2.Enabled := True;
    CleanBtn.Enabled := True;

    StaticText1.Caption := SAnalisesCompleted;

    AnalyzeBtn.SetFocus;
  end;
end;

end.
