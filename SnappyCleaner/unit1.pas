unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Process,
  Dialogs, Buttons, StdCtrls, ComCtrls, ExtCtrls, XMLPropStorage,
  LCLType, DefaultTranslator, CheckLst, Menus, ClipBrd;

type

  { TMainForm }

  TMainForm = class(TForm)
    AnalyzeBtn: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    AboutBtn: TBitBtn;
    AutoOrphansBox: TCheckListBox;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    CacheChromiumCheck: TCheckBox;
    CachePaleMoonCheck: TCheckBox;
    CacheDNFCheck: TCheckBox;
    CacheBraveCheck: TCheckBox;
    Image1: TImage;
    Label17: TLabel;
    Label23: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    RepairRPMCheck: TCheckBox;
    SaveDialog1: TSaveDialog;
    SelectAllCheck: TCheckBox;
    NotOrphanBtn: TSpeedButton;
    RemKernelBox: TCheckListBox;
    Label1: TLabel;
    Label11: TLabel;
    ProgressBar1: TProgressBar;
    OrphansResetSelection: TSpeedButton;
    RootTmpCheck: TCheckBox;
    OrphansSelectAllBtn: TSpeedButton;
    OldKernelDepsBtn: TSpeedButton;
    OrphansDepsBtn: TSpeedButton;
    UserTrashCheck: TCheckBox;
    UserTMPCheck: TCheckBox;
    UserRecentCheck: TCheckBox;
    CacheURPMICheck: TCheckBox;
    CacheMozillaCheck: TCheckBox;
    CacheChromeCheck: TCheckBox;
    CacheOperaCheck: TCheckBox;
    CleanBtn: TBitBtn;
    Label2: TLabel;
    Label9: TLabel;
    OldResetSelection: TSpeedButton;
    OldSelectAllBtn: TSpeedButton;
    XMLPropStorage1: TXMLPropStorage;
    Label10: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    StaticText1: TStaticText;
    Timer1: TTimer;
    procedure AboutBtnClick(Sender: TObject);
    procedure CleanBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label24ChangeBounds(Sender: TObject);
    procedure AnalyzeBtnClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure NotOrphanBtnClick(Sender: TObject);
    procedure OldKernelDepsBtnClick(Sender: TObject);
    procedure OldResetSelectionClick(Sender: TObject);
    procedure OldSelectAllBtnClick(Sender: TObject);
    procedure OrphansDepsBtnClick(Sender: TObject);
    procedure OrphansResetSelectionClick(Sender: TObject);
    procedure OrphansSelectAllBtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SelectAllCheckChange(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure OrphanedDeps(CLB: TCheckListBox);
    procedure StartProcess;

  private
    { private declarations }
  public
    { public declarations }
  end;


  //Ресурсы перевода
resourcestring
  SNo = 'no';
  SEmpty = 'empty';
  SMarkNotOrphan = 'Exclude the selected packages from the list of orphans?';
  SLaunchMarkProcess = 'launched by the marking process, wait...';
  SStartAnalyze = 'run analysis of the system, wait...';
  SAnalisesCompleted = 'analysis completed...';
  SNoToClean = 'Nothing is selected to clean!';
  SConfirmCleanUP = 'Confirm running the cleanup?';
  SKernelToRemove = 'The kernels selected for removal:';
  SCleanTMPRootFiles = 'clean the temporary root files, wait...';
  SCleanUserRecycle = 'clean the user recycle bin, wait...';
  SCleanTMPUserFiles = 'clean temporary user files, wait...';
  SCleanRecentDocuments = 'clean RecentDocuments user files, wait...';
  SRPMDBRepairing = 'repairing the RPM database, wait...';
  SCleanURPMICache = 'clean URPMI cache, wait...';
  SCleanDNFCache = 'clean DNF cache, wait...';
  SCleanMozillaCache = 'clean Mozilla Firefox cache, wait...';
  SCleanChromeCache = 'clean Google Chrome cache, wait...';
  SCleanOperaCache = 'clean Opera browser cache, wait...';
  SCleanChromiumCache = 'clean Chromium browser cache, wait...';
  SCleanPalemoonCache = 'clean PaleMoon browser cache, wait...';
  SCleanBraveCache = 'clean Brave browser cache, wait...';
  SCleanThumbnails = 'clean ~/.cache/thumbnails/*, wait...';
  SCleanBashHistory = 'clean bash history for all users, wait...';
  SRemoveSelectedPackages = 'remove the selected packages, wait...';
  SPackage = 'Package:';
  SAnalizePackagesDeps = 'run analysis of the package dependencies, wait...';
  SDepsAnalyzeEnd = 'dependency analysis package is completed...';
  SProcessTerminate = 'process is terminated, wait...';
  SMarkPackagesPlaced = 'mark packages placed';
  SSearchDeps = 'Search the packages dependencies';
  SAlredyRunning = 'The application is alredy running!';

var
  MainForm: TMainForm;
  ActUser: TStringList;
  DelKernels, DelOrphans, Package, NotOrphans: string;

implementation

uses AnalyzeTRD, ClearTRD, AboutUnit, DepsUnit, DepsTRD, NotOrphanTRD;

  {$R *.lfm}

//Общая процедура запуска команд
procedure TMainForm.StartProcess;
var
  ExProcess: TProcess;
begin
  Screen.Cursor := crHourGlass;
  ExProcess := TProcess.Create(Self);
  try
    ExProcess.Executable := '/usr/bin/sh';
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add('chown ' + ActUser[0] + ':' + ActUser[0] +
      ' "' + SaveDialog1.FileName + '"');
    ExProcess.Options := ExProcess.Options + [poWaitOnExit];
    ExProcess.Execute;
  finally
    ExProcess.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.OrphanedDeps(CLB: TCheckListBox);
var
  FStartShowDepsThread: TThread;
begin
  //Если сирота выбран
  if CLB.SelCount <> 0 then
  begin
    Package := CLB.Items[CLB.ItemIndex];
    DepsForm.SEdit.Clear;

    //Запуск поиска сирот
    FStartShowDepsThread := StartShowDeps.Create(False);
    FStartShowDepsThread.Priority := tpLowest;
  end
  else
  begin   //Если сирота не выбран - произвольный поиск
    DepsForm.Caption := SSearchDeps;
    DepsForm.ShowModal;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if ProgressBar1.Position = 50 then
    ProgressBar1.Position := 0
  else
    ProgressBar1.Position := ProgressBar1.Position + 1;
end;

procedure TMainForm.AnalyzeBtnClick(Sender: TObject);
var
  FStartAnalizeThread: TThread;
begin
  Panel1.Enabled := False;
  Panel2.Enabled := False;

  Label2.Caption := '...';
  Label6.Caption := '...';
  Label24.Caption := '...';
  Label10.Caption := '...';
  Label12.Caption := '...';
  Label14.Caption := '...';
  Label16.Caption := '...';
  Label18.Caption := '...';
  Label20.Caption := '...';
  Label22.Caption := '...';
  Label26.Caption := '...';
  Label1.Caption := '...';
  Label23.Caption := '...';
  Label27.Caption := '...';
  Label28.Caption := '...';

  AutoOrphansBox.Clear;
  RemKernelBox.Clear;

  StaticText1.Caption := SStartAnalyze;

  ProgressBar1.Visible := True;
  Timer1.Enabled := True;

  FStartAnalizeThread := StartAnalyze.Create(False); //сразу
  FStartAnalizeThread.Priority := tpLowest;
end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if PopUpMenu1.PopupComponent.ClassNameIs('TListBox') then
      (PopUpMenu1.PopupComponent as TListBox).Items.SaveToFile(SaveDialog1.FileName)
    else
      (PopUpMenu1.PopupComponent as TCheckListBox).Items.SaveToFile(
        SaveDialog1.FileName);
    StartProcess;
  end;
end;

procedure TMainForm.MenuItem3Click(Sender: TObject);
begin
  if PopUpMenu1.PopupComponent.ClassNameIs('TListBox') then
    ClipBoard.AsText := (PopUpMenu1.PopupComponent as TListBox).Items[
      (PopUpMenu1.PopupComponent as TListBox).ItemIndex]
  else
    ClipBoard.AsText := (PopUpMenu1.PopupComponent as TCheckListBox).Items[
      (PopUpMenu1.PopupComponent as TCheckListBox).ItemIndex];
end;

procedure TMainForm.NotOrphanBtnClick(Sender: TObject);
var
  i: integer;
  FStartNotOrphan: TThread;
begin
  //Строка с отмеченными пакетами-сиротами
  NotOrphans := '';

  //Начитываем выделеные сироты в переменную
  for i := 0 to AutoOrphansBox.Count - 1 do
    if AutoOrphansBox.Checked[i] then
      NotOrphans := NotOrphans + AutoOrphansBox.Items[i] + ' ';

  //Если есть, что маркировать - запускаем процесс
  if NotOrphans <> '' then
  begin
    if MessageDlg(SMarkNotOrphan, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      StaticText1.Caption := SLaunchMarkProcess;

      Panel1.Enabled := False;
      Panel2.Enabled := False;

      ProgressBar1.Visible := True;
      Timer1.Enabled := True;

      FStartNotOrphan := StartNotOrphan.Create(False);
      FStartNotOrphan.Priority := tpLowest;
    end;
  end;
end;

procedure TMainForm.OldKernelDepsBtnClick(Sender: TObject);
begin
  OrphanedDeps(RemKernelBox);
end;

procedure TMainForm.OldResetSelectionClick(Sender: TObject);
begin
  RemKernelBox.CheckAll(cbUnChecked, False, True);
  RemKernelBox.ItemIndex := -1;
end;

procedure TMainForm.OldSelectAllBtnClick(Sender: TObject);
begin
  RemKernelBox.CheckAll(cbChecked, False, True);
end;

procedure TMainForm.OrphansDepsBtnClick(Sender: TObject);
begin
  OrphanedDeps(AutoOrphansBox);
end;

procedure TMainForm.OrphansResetSelectionClick(Sender: TObject);
begin
  AutoOrphansBox.CheckAll(cbUnChecked, False, True);
  AutoOrphansBox.ItemIndex := -1;
end;

procedure TMainForm.OrphansSelectAllBtnClick(Sender: TObject);
begin
  AutoOrphansBox.CheckAll(cbChecked, False, True);
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
  //Определяем, кто вызвал меню
  if PopUpMenu1.PopupComponent.ClassNameIs('TListBox') then
  begin
    (PopUpMenu1.PopupComponent as TListBox).SetFocus;
    //Избегаем ошибки фокуса
    if (PopUpMenu1.PopupComponent as TListBox).SelCount = 0 then
      Abort;
  end
  else
  begin
    (PopUpMenu1.PopupComponent as TCheckListBox).SetFocus;
    if (PopUpMenu1.PopupComponent as TCheckListBox).SelCount = 0 then
      Abort;
  end;
end;

//Выделить все
procedure TMainForm.SelectAllCheckChange(Sender: TObject);
begin
  if Sender = SelectAllCheck then
  begin
    RepairRPMCheck.State := SelectAllCheck.State;
    RootTmpCheck.State := SelectAllCheck.State;
    UserTrashCheck.State := SelectAllCheck.State;
    UserTmpCheck.State := SelectAllCheck.State;
    UserRecentCheck.State := SelectAllCheck.State;
    CacheURPMICheck.State := SelectAllCheck.State;
    CacheDNFCheck.State := SelectAllCheck.State;
    CacheMozillaCheck.State := SelectAllCheck.State;
    CacheChromeCheck.State := SelectAllCheck.State;
    CacheOperaCheck.State := SelectAllCheck.State;
    CacheChromiumCheck.State := SelectAllCheck.State;
    CachePaleMoonCheck.State := SelectAllCheck.State;
    CacheBraveCheck.State := SelectAllCheck.State;
  end
  else
  begin
    if (RepairRPMCheck.State = cbChecked) and (RootTmpCheck.State = cbChecked) and
      (UserTrashCheck.State = cbChecked) and (UserTmpCheck.State = cbChecked) and
      (UserRecentCheck.State = cbChecked) and (CacheURPMICheck.State = cbChecked) and
      (CacheDNFCheck.State = cbChecked) and (CacheMozillaCheck.State = cbChecked) and
      (CacheChromeCheck.State = cbChecked) and (CacheOperaCheck.State = cbChecked) and
      (CachePaleMoonCheck.State = cbChecked) and (CacheBraveCheck.State = cbChecked) and
      (CacheChromiumCheck.State = cbChecked) then
      SelectAllCheck.State := cbChecked
    else
      SelectAllCheck.State := cbUnChecked;
  end;
end;

procedure TMainForm.Timer1StartTimer(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
end;

procedure TMainForm.Timer1StopTimer(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TMainForm.CleanBtnClick(Sender: TObject);
var
  i: integer;
  FStartClearThread: TThread;
begin
  //Строки с именами удаляемых ядер и сирот
  DelKernels := '';
  DelOrphans := '';

  //Начитываем выделеные ядра в переменную
  for i := 0 to RemKernelBox.Count - 1 do
    if RemKernelBox.Checked[i] then
      DelKernels := DelKernels + RemKernelBox.Items[i] + sLineBreak;

  //Начитываем выделеные сироты в переменную
  for i := 0 to AutoOrphansBox.Count - 1 do
    if AutoOrphansBox.Checked[i] then
      DelOrphans := DelOrphans + AutoOrphansBox.Items[i] + ' ';

  //Есть ли что чистить?
  if not (RepairRPMCheck.Checked or RootTmpCheck.Checked or
    UserTrashCheck.Checked or UserTMPCheck.Checked or UserRecentCheck.Checked or
    CacheURPMICheck.Checked or CacheMozillaCheck.Checked or
    CacheChromeCheck.Checked or CacheOperaCheck.Checked or
    CacheChromiumCheck.Checked or CachePaleMoonCheck.Checked or
    CacheBraveCheck.Checked or (DelKernels <> '') or (DelOrphans <> '')) then
  begin
    MessageDlg(SNoToClean, mtWarning, [mbOK], 0);
    Exit;
  end;

  //Если ядра отмечены - подтверждение очистки с ядрами
  if DelKernels <> '' then
  begin
    if MessageDlg(SKernelToRemove + ' ' + sLineBreak + sLineBreak +
      DelKernels + sLineBreak + SConfirmCleanUP, mtConfirmation, [mbYes, mbNo], 0) =
      mrYes then
      DelKernels := StringReplace(DelKernels, sLineBreak, ' ', [rfReplaceAll])
    else
      Exit;
  end
  else  //Иначе - обычное подтвеждение очистки
  begin
    if MessageDlg(SConfirmCleanUP, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;
  end;

  //Запуск очистки
  Panel1.Enabled := False;
  Panel2.Enabled := False;

  ProgressBar1.Visible := True;
  Timer1.Enabled := True;

  FStartClearThread := StartClear.Create(False);
  FStartClearThread.Priority := tpLowest;
end;

//About
procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ActUser.Free;
  //Останавливаем процесс зависимостей, если запущен
  if FileExists(ExtractFilePath(ParamStr(0)) + 'tmp/process') then
    DepsForm.BreakBtn.Click;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
begin
  //Устраняем баг иконки приложения
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.Assign(Image1.Picture.Graphic);
    Application.Icon.Assign(bmp);
  finally
    bmp.Free;
  end;

  //Выясняем имя активного пользователя Linux
  ActUser := TStringList.Create;
  ActUser.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'tmp/actuser');
  Label8.Caption := ActUser[0];

  //Настройки формы
  XMLPropStorage1.FileName := ExtractFilePath(ParamStr(0)) + 'tmp/fsettings';

  //Определяем Рабочий стол
  if DirectoryExists('/home/' + ActUser[0] + '/Рабочий стол') then
    SaveDialog1.InitialDir := '/home/' + ActUser[0] + '/Рабочий стол'
  else
  if DirectoryExists('/home/' + ActUser[0] + '/Desktop') then
    SaveDialog1.InitialDir := '/home/' + ActUser[0] + '/Desktop'
  else
    SaveDialog1.InitialDir := '/home';
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  XMLPropStorage1.Restore;
  MainForm.Caption := Application.Title;
end;

//Раскрашивание результатов
procedure TMainForm.Label24ChangeBounds(Sender: TObject);
begin
  if ((Sender as TLabel).Caption = '0') or ((Sender as TLabel).Caption = SEmpty) then
  begin
    (Sender as TLabel).Caption := SEmpty;
    (Sender as TLabel).Font.Color := clGreen;
  end
  else
  if (Sender as TLabel).Caption = SNo then
    (Sender as TLabel).Font.Color := clInActiveCaption
  else
    (Sender as TLabel).Font.Color := clRed;
end;

end.
