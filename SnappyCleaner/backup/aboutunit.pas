unit AboutUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, XMLPropStorage;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    XMLPropStorage1: TXMLPropStorage;
    procedure FormCreate(Sender: TObject);
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

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  AboutForm.XMLPropStorage1.FileName := ExtractFilePath(ParamStr(0)) + 'tmp/fsettings';
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  XMLPropStorage1.Restore;
end;

end.
