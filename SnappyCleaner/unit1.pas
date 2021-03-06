unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Process,
  Dialogs, Buttons, StdCtrls, ComCtrls, ExtCtrls, XMLPropStorage,
  LCLType, Translations, CheckLst, Menus, ClipBrd;

type

  { TMainForm }

  TMainForm = class(TForm)
    AnalyzeBtn: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    AboutBtn: TBitBtn;
    AutoOrphansBox: TCheckListBox;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    CacheChromiumCheck: TCheckBox;
    CachePaleMoonCheck: TCheckBox;
    Label23: TLabel;
    Label27: TLabel;
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
    LangBtn: TBitBtn;
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
    procedure LangBtnClick(Sender: TObject);
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
    procedure SelectAllCheckClick(Sender: TObject);
    procedure Timer1StartTimer(Sender: TObject);
    procedure Timer1StopTimer(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure OrphanedDeps(CLB: TCheckListBox);
    procedure LangSetting;
    procedure StartProcess;

  private
    { private declarations }
  public
    { public declarations }
  end;

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

procedure TMainForm.LangSetting;
begin
  if LangBtn.Caption = 'EN' then
  begin
    if Label24.Caption = 'no' then
      Label24.Caption := 'нет';
    if Label24.Caption = 'empty' then
      Label24.Caption := 'пусто';

    if Label10.Caption = 'no' then
      Label10.Caption := 'нет';
    if Label10.Caption = 'empty' then
      Label10.Caption := 'пусто';

    if Label12.Caption = 'no' then
      Label12.Caption := 'нет';
    if Label12.Caption = 'empty' then
      Label12.Caption := 'пусто';

    if Label14.Caption = 'no' then
      Label14.Caption := 'нет';
    if Label14.Caption = 'empty' then
      Label14.Caption := 'пусто';

    if Label18.Caption = 'no' then
      Label18.Caption := 'нет';
    if Label18.Caption = 'empty' then
      Label18.Caption := 'пусто';

    if Label20.Caption = 'no' then
      Label20.Caption := 'нет';
    if Label20.Caption = 'empty' then
      Label20.Caption := 'пусто';

    if Label22.Caption = 'no' then
      Label22.Caption := 'нет';
    if Label22.Caption = 'empty' then
      Label22.Caption := 'пусто';

    if Label23.Caption = 'no' then
      Label23.Caption := 'нет';
    if Label23.Caption = 'empty' then
      Label23.Caption := 'пусто';

    if Label27.Caption = 'no' then
      Label27.Caption := 'нет';
    if Label27.Caption = 'empty' then
      Label27.Caption := 'пусто';

    Label7.Caption := 'Пользователь:';
    SelectAllCheck.Caption := 'Выбрать/Сбросить все';
    RepairRPMCheck.Caption := 'Ремонтировать RPM-DB';
    RootTMPCheck.Caption := 'Каталог /root/tmp:';
    UserTrashCheck.Caption := 'Корзина юзера:';
    UserTMPCheck.Caption := 'Временные файлы:';
    CacheURPMICheck.Caption := 'Каталог-кеш URPMI:';
    CacheMozillaCheck.Caption := 'Кеш Mozilla Firefox:';
    CacheChromeCheck.Caption := 'Кеш Google Chrome:';
    CacheOperaCheck.Caption := 'Кеш браузера Opera:';
    CacheChromiumCheck.Caption := 'Кеш Chromium:';
    CachePaleMoonCheck.Caption := 'Кеш PaleMoon:';
    Label25.Caption := 'Использование HDD:';

    CleanBtn.Caption := 'Очистка';
    AnalyzeBtn.Caption := 'Анализ';

    Label9.Caption := 'Новое ядро:';
    Label5.Caption := 'Список старых ядер:';
    Label11.Caption := 'Список осиротевших пакетов:';

    OldSelectAllBtn.Hint := 'Выбрать все';
    OldResetSelection.Hint := 'Сброс выбора';
    OrphansSelectAllBtn.Hint := 'Выбрать все';
    OrphansResetSelection.Hint := 'Сброс выбора';
    OldKernelDepsBtn.Hint := 'Показать зависимости';
    OrphansDepsBtn.Hint := 'Показать зависимости';
    NotOrphanBtn.Hint := 'Отметить как не осиротевший';

    StaticText1.Caption := 'запустите анализ системы...';

    //Русские диалоги и кнопки
    Translations.TranslateUnitResourceStrings('LCLStrConsts',
      ExtractFilePath(ParamStr(0)) + 'lclstrconsts.ru.po', 'ru', 'ru');
  end
  else
  begin
    if Label24.Caption = 'нет' then
      Label24.Caption := 'no';
    if Label24.Caption = 'пусто' then
      LAbel24.Caption := 'empty';
    if Label10.Caption = 'нет' then
      LAbel10.Caption := 'no';
    if Label10.Caption = 'пусто' then
      LAbel10.Caption := 'empty';
    if Label12.Caption = 'нет' then
      LAbel12.Caption := 'no';
    if Label12.Caption = 'пусто' then
      LAbel12.Caption := 'empty';
    if Label14.Caption = 'нет' then
      LAbel14.Caption := 'no';
    if Label14.Caption = 'пусто' then
      LAbel14.Caption := 'empty';

    if Label18.Caption = 'нет' then
      LAbel18.Caption := 'no';
    if Label18.Caption = 'пусто' then
      LAbel18.Caption := 'empty';

    if Label20.Caption = 'нет' then
      LAbel20.Caption := 'no';
    if Label20.Caption = 'пусто' then
      LAbel20.Caption := 'empty';

    if Label22.Caption = 'нет' then
      LAbel22.Caption := 'no';
    if Label22.Caption = 'пусто' then
      LAbel22.Caption := 'empty';

    if Label23.Caption = 'нет' then
      LAbel23.Caption := 'no';
    if Label23.Caption = 'пусто' then
      LAbel23.Caption := 'empty';

    if Label27.Caption = 'нет' then
      LAbel27.Caption := 'no';
    if Label27.Caption = 'пусто' then
      LAbel27.Caption := 'empty';

    Label7.Caption := 'UserName:';
    SelectAllCheck.Caption := 'Select/Reset all';
    RepairRPMCheck.Caption := 'Repair RPM DataBase';
    RootTMPCheck.Caption := 'Directory /root/tmp:';
    UserTrashCheck.Caption := 'User Trash files:';
    UserTMPCheck.Caption := 'User Temporary files:';
    CacheURPMICheck.Caption := 'URPMI Cache:';
    CacheMozillaCheck.Caption := 'Mozilla Firefox cache:';
    CacheChromeCheck.Caption := 'Google Chrome cache:';
    CacheOperaCheck.Caption := 'Opera cache:';
    CacheChromiumCheck.Caption := 'Chromium cache:';
    CachePaleMoonCheck.Caption := 'PaleMoon cache:';
    Label25.Caption := 'HDD usage:';

    CleanBtn.Caption := 'Clean';
    AnalyzeBtn.Caption := 'Analyze';

    Label9.Caption := 'New kernel:';
    Label5.Caption := 'Old kernels list:';
    Label11.Caption := 'Orphaned packages list:';

    OldSelectAllBtn.Hint := 'Select all';
    OldResetSelection.Hint := 'Reset selection';
    OrphansSelectAllBtn.Hint := 'Select all';
    OrphansResetSelection.Hint := 'Reset selection';
    OldKernelDepsBtn.Hint := 'Show dependencies';
    OrphansDepsBtn.Hint := 'Show dependencies';
    NotOrphanBtn.Hint := 'Mark as not orphaned';

    StaticText1.Caption := 'start analysis of system...';

    //Английские диалоги и кнопки
    Translations.TranslateUnitResourceStrings('LCLStrConsts',
      ExtractFilePath(ParamStr(0)) + 'lclstrconsts.po', 'en', 'en');
  end;
end;

procedure TMainForm.OrphanedDeps(CLB: TCheckListBox);
var
  FStartShowDepsThread: TThread;
begin
  if (MainForm.LangBtn.Caption = 'EN') then
  begin
    DepsForm.Label1.Caption := 'Требуются для пакета:';
    DepsForm.Label2.Caption := 'Сам пакет требуется для:';
    DepsForm.SEdit.Button.Caption := 'Поиск';
    DepsForm.BreakBtn.Caption := 'Отмена';
  end
  else
  begin
    DepsForm.Label1.Caption := 'Required for this package:';
    DepsForm.Label2.Caption := 'Package itself is needed to:';
    DepsForm.SEdit.Button.Caption := 'Search';
    DepsForm.BreakBtn.Caption := 'Cancel';
  end;

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
    if LangBtn.Caption = 'EN' then
      DepsForm.Caption := 'Поиск зависимостей пакета'
    else
      DepsForm.Caption := 'Search the packages dependencies';
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

  AutoOrphansBox.Clear;
  RemKernelBox.Clear;

  if (MainForm.LangBtn.Caption = 'EN') then
    StaticText1.Caption := 'запущен анализ системы, ждите...'
  else
    StaticText1.Caption := 'run analysis of the system, wait...';

  ProgressBar1.Visible := True;
  Timer1.Enabled := True;

  FStartAnalizeThread := StartAnalyze.Create(False); //сразу
  FStartAnalizeThread.Priority := tpLowest;
end;

procedure TMainForm.LangBtnClick(Sender: TObject);
begin
  if LangBtn.Caption = 'EN' then
    LangBtn.Caption := 'RU'
  else
    LangBtn.Caption := 'EN';

  //Настраиваем локализацию
  LangSetting;
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
  a: string;
  FStartNotOrphan: TThread;
begin
  //Строка с отмеченными пакетами-сиротами
  NotOrphans := '';

  //Подключаем русские диалоги, если rus
  if LangBtn.Caption = 'EN' then
    a := 'Исключить выбранные пакеты из списка сирот?'
  else
    a := 'Exclude the selected packages from the list of orphans?';

  //Начитываем выделеные сироты в переменную
  for i := 0 to AutoOrphansBox.Count - 1 do
    if AutoOrphansBox.Checked[i] then
      NotOrphans := NotOrphans + AutoOrphansBox.Items[i] + ' ';

  //Если есть, что маркировать - запускаем процесс
  if NotOrphans <> '' then
  begin
    if MessageDlg(a, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if (MainForm.LangBtn.Caption = 'EN') then
        StaticText1.Caption :=
          'запущен процесс маркировки, ждите...'
      else
        StaticText1.Caption := 'launched by the marking process, wait...';

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

  //Выбираем язык
  if LangBtn.Caption = 'EN' then
  begin
    PopUpMenu1.Items[0].Caption := 'Сохранить список в файл';
    PopUpMenu1.Items[2].Caption := 'Скопировать позицию в буфер';
  end
  else
  begin
    PopUpMenu1.Items[0].Caption := 'Save the list to file';
    PopUpMenu1.Items[2].Caption := 'Copy position to clipboard';
  end;
end;

procedure TMainForm.SelectAllCheckClick(Sender: TObject);
begin
  if Sender = SelectAllCheck then
  begin
    RepairRPMCheck.State := SelectAllCheck.State;
    RootTmpCheck.State := SelectAllCheck.State;
    UserTrashCheck.State := SelectAllCheck.State;
    UserTmpCheck.State := SelectAllCheck.State;
    UserRecentCheck.State := SelectAllCheck.State;
    CacheURPMICheck.State := SelectAllCheck.State;
    CacheMozillaCheck.State := SelectAllCheck.State;
    CacheChromeCheck.State := SelectAllCheck.State;
    CacheOperaCheck.State := SelectAllCheck.State;
    CacheChromiumCheck.State := SelectAllCheck.State;
    CachePaleMoonCheck.State := SelectAllCheck.State;
  end
  else
  begin
    if (RepairRPMCheck.State = cbChecked) and (RootTmpCheck.State = cbChecked) and
      (UserTrashCheck.State = cbChecked) and (UserTmpCheck.State = cbChecked) and
      (UserRecentCheck.State = cbChecked) and (CacheURPMICheck.State = cbChecked) and
      (CacheMozillaCheck.State = cbChecked) and (CacheChromeCheck.State = cbChecked) and
      (CacheOperaCheck.State = cbChecked) and (CachePaleMoonCheck.State = cbChecked) and
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
      DelKernels := DelKernels + RemKernelBox.Items[i] + #13#10;

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
    (DelKernels <> '') or (DelOrphans <> '')) then
  begin
    if MainForm.LangBtn.Caption = 'EN' then
      MessageDlg('Ничего не выбрано для очистки!',
        mtWarning, [mbOK], 0)
    else
      MessageDlg('Nothing is selected to clean!', mtWarning, [mbOK], 0);
    Exit;
  end;

  //Если ядра отмечены - подтверждение очистки с ядрами
  if DelKernels <> '' then
  begin
    if (MainForm.LangBtn.Caption = 'EN') then
      if MessageDlg('Выбраны ядра на удаление: ' +
        #13#10 + #13#10 + DelKernels + #13#10 +
        'Подтверждаете запуск очистки?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        DelKernels := StringReplace(DelKernels, #13#10, ' ', [rfReplaceAll])
      else
        Exit
    else
    if MessageDlg('The kernels selected for removal: ' + #13#10 +
      #13#10 + DelKernels + #13#10 + 'Confirm running the cleanup?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      DelKernels := StringReplace(DelKernels, #13#10, ' ', [rfReplaceAll])
    else
      Exit;
  end
  else  //Иначе - обычное подтвеждение очистки
  begin
    if MainForm.LangBtn.Caption = 'EN' then
    begin
      if MessageDlg('Подтверждаете запуск очистки?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        Exit;
    end
    else
    begin
      if MessageDlg('Confirm running the cleanup?', mtConfirmation,
        [mbYes, mbNo], 0) <> mrYes then
        Exit;
    end;
  end;

  //Запуск очистки
  Panel1.Enabled := False;
  Panel2.Enabled := False;

  ProgressBar1.Visible := True;
  Timer1.Enabled := True;

  FStartClearThread := StartClear.Create(False);
  FStartClearThread.Priority := tpLowest;
end;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  if LangBtn.Caption = 'RU' then
  begin
    AboutForm.Caption := 'About';

    AboutForm.Label3.Caption :=
      'MgaRemix cleanup program' + #13#10 + #13#10 + 'License: GNU GPL' +
      #13#10 + 'Compilation: Lazarus 1.8.4' + #13#10 +
      'Author: alex_q_2000 (C) 2020' + #13#10 + 'Co-authorship: ingvaro' +
      #13#10 + 'Gratitudes: algri14, AlexL' + #13#10 +
      'mozg1986, Zomby, TopE, kvv-vp' + #13#10 + #13#10 +
      'Russian Linux Forum:' + #13#10 + 'https://linuxforum.ru';
  end
  else
  begin
    AboutForm.Caption := 'О программе';

    AboutForm.Label3.Caption :=
      'Программа очистки MgaRemix' + #13#10 + #13#10 +
      'Лицензия: GNU GPL' + #13#10 + 'Компиляция: Lazarus 1.8.4' +
      #13#10 + 'Автор: alex_q_2000 (C) 2020' + #13#10 +
      'Соавторство: ingvaro' + #13#10 +
      'Благодарности: algri14, AlexL,' + #13#10 +
      'mozg1986, Zomby, TopE, kvv-vp' + #13#10 + #13#10 +
      'Russian Linux Forum:' + #13#10 + 'https://linuxforum.ru';
  end;

  AboutForm.ShowModal;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ActUser.Free;
  //Останавливаем процесс зависимостей, если запущен
  if FileExists(ExtractFilePath(ParamStr(0)) + '/tmp/process') then
    DepsForm.BreakBtn.Click;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
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
  LangSetting;
end;

procedure TMainForm.Label24ChangeBounds(Sender: TObject);
begin
  if ((Sender as TLabel).Caption = '0') or ((Sender as TLabel).Caption = 'пусто') or
    ((Sender as TLabel).Caption = 'empty') then

  begin
    (Sender as TLabel).Font.Color := clGreen;
    if (MainForm.LangBtn.Caption = 'EN') then
      (Sender as TLabel).Caption := 'пусто'
    else
      (Sender as TLabel).Caption := 'empty';
  end
  else
  if ((Sender as TLabel).Caption = 'нет') or ((Sender as TLabel).Caption = 'no') then
    (Sender as TLabel).Font.Color := clInActiveCaption
  else
    (Sender as TLabel).Font.Color := clRed;
end;

end.
