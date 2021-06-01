unit NotOrphanTRD;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Process;

type
  StartNotOrphan = class(TThread)
  private

    { Private declarations }
  protected
  var
    Result: TStringList;

    procedure Execute; override;
    procedure ShowRemOrphansSize;
    procedure ShowNewList;
  end;

implementation

uses Unit1;

{ TRD }

procedure StartNotOrphan.Execute;
var
  ExProcess: TProcess;
begin
  try
    FreeOnTerminate := True;
    Result := TStringList.Create;

    ExProcess := TProcess.Create(nil);
    ExProcess.Executable := '/usr/bin/sh';
    ExProcess.Options := ExProcess.Options + [poWaitOnExit];
    ExProcess.Parameters.Add('-c');

    //Снимаем признак "сирота" с выбранных пакетов
    ExProcess.Parameters.Add('/usr/sbin/urpmi ' + NotOrphans);
    ExProcess.Execute;
    //Формируем и показываем новый список сирот
    Synchronize(@ShowNewList);

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
    Result.Free;
    ExProcess.Free;
    Terminate;
  end;
end;


////// БЛОК ЗАВЕРШЕНИЯ ПРОЦЕССА /////////////

//Показываем новый размер сирот и завершаем
procedure StartNotOrphan.ShowRemOrphansSize;
begin
  with MainForm do
  begin
    Label1.Caption := Result[0];

    Timer1.Enabled := False;
    ProgressBar1.Visible := False;
    ProgressBar1.Position := 0;

    Panel1.Enabled := True;
    Panel2.Enabled := True;

    if LangBtn.Caption = 'EN' then
      StaticText1.Caption := 'отметки пакетов расставлены...'
    else
      StaticText1.Caption := 'mark packages placed...';
  end;
end;


//Показываем новый список сирот
procedure StartNotOrphan.ShowNewList;
var
  i, a: integer;
begin
  //Скрываем прогресс
  with MainForm do
  begin
    a := 0; //Указатель верхнего отмеченного Items
    //Удаляем выделеные сироты из списка
    for i := AutoOrphansBox.Count - 1 downto 0 do
      if AutoOrphansBox.Checked[i] then
      begin
        AutoOrphansBox.Items.Delete(i);
        a := i;
      end;

    //Возвращаем указатель в список пакетов-сирот
    if a > 0 then
      AutoOrphansBox.ItemIndex := a - 1
    else
    if AutoOrphansBox.Items.Count > 0 then
      AutoOrphansBox.ItemIndex := 0;
  end;
end;

end.
