unit DepsUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, XMLPropStorage, ClipBrd, LCLType, Buttons, EditBtn;

type

  { TDepsForm }

  TDepsForm = class(TForm)
    BreakBtn: TButton;
    SEdit: TEditButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Panel1: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    XMLPropStorage1: TXMLPropStorage;
    procedure BreakBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SEditButtonClick(Sender: TObject);
    procedure SEditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DepsForm: TDepsForm;

implementation

uses  Unit1, DepsTRD;

{$R *.lfm}

{ TDepsForm }

procedure TDepsForm.FormCreate(Sender: TObject);
begin
  DepsForm.XMLPropStorage1.FileName := ExtractFilePath(ParamStr(0)) + 'tmp/fsettings';
end;

procedure TDepsForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  //Останавливаем процесс зависимостей, если запущен
  BreakBtn.Click;
end;

procedure TDepsForm.BreakBtnClick(Sender: TObject);
begin
  //Останавливаем процесс зависимостей, если запущен
  if FileExists(ExtractFilePath(ParamStr(0)) + 'tmp/process') then
  begin
    DeleteFile(ExtractFilePath(ParamStr(0)) + 'tmp/process');
    //Показываем статус завершения процесса
    MainForm.StaticText1.Caption := SProcessTerminate;
  end;
end;

procedure TDepsForm.FormShow(Sender: TObject);
begin
  //Фокус на строку поиска
  SEdit.SetFocus;

  //Включаем горизонтальный скрол
  ListBox1.ScrollWidth := ListBox1.Width + 1;
  ListBox2.ScrollWidth := ListBox2.Width + 1;
end;

procedure TDepsForm.SEditButtonClick(Sender: TObject);
var
  FStartShowDepsThread: TThread;
begin
  if SEdit.Text <> '' then
    //Запуск поиска сирот
    with MainForm do
    begin
      ListBox1.Clear;
      Listbox2.Clear;

      Package := SEdit.Text;

      FStartShowDepsThread := StartShowDeps.Create(False);
      FStartShowDepsThread.Priority := tpLowest;
    end;
end;

procedure TDepsForm.SEditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SEdit.Button.Click;
end;

end.
