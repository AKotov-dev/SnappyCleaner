unit AboutUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses  unit1;

  {$R *.lfm}

  { TAboutForm }

procedure TAboutForm.FormShow(Sender: TObject);
begin
  AboutForm.Label1.Caption := Application.Title;
  AboutForm.Width := Label3.Left + Label3.Width + 40;
  AboutForm.Height := BitBtn1.Top + BitBtn1.Height + 8;

  //В центр
  AboutForm.Left := MainForm.Left + MainForm.Width div 2 - AboutForm.Width div 2;
  AboutForm.Top := MainForm.Top + MainForm.Height div 2 - AboutForm.Height div 2;
end;

procedure TAboutForm.BitBtn1Click(Sender: TObject);
begin
  AboutForm.Close;
end;

end.
