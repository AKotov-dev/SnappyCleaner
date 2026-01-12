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

{$R *.lfm}

{ TAboutForm }

procedure TAboutForm.FormShow(Sender: TObject);
begin
  AboutForm.Width := Label3.Left + Label3.Width + 40;
  AboutForm.Height := BitBtn1.Top + BitBtn1.Height + 8;
end;

procedure TAboutForm.BitBtn1Click(Sender: TObject);
begin
  AboutForm.Close;
end;

end.
