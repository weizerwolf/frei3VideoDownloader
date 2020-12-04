unit frei3VideoDownloader_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, StrUtils, Frei3DashDownloader, Frei3Utils;

type

  { TFrei3VideoDownloaderForm }

  TFrei3VideoDownloaderForm = class(TForm)
    BitBtnTutorial: TBitBtn;
    BitBtnInfo: TBitBtn;
    BitBtnSave: TBitBtn;
    BitBtnPlay: TBitBtn;
    BitBtnOpen: TBitBtn;
    EditUuid: TEdit;
    ImageLogo: TImage;
    PanelFooter: TPanel;
    PanelHeader: TPanel;
    RadioGroupStreams: TRadioGroup;
    SaveDialog: TSaveDialog;
    procedure BitBtnInfoClick(Sender: TObject);
    procedure BitBtnOpenClick(Sender: TObject);
    procedure BitBtnPlayClick(Sender: TObject);
    procedure BitBtnSaveClick(Sender: TObject);
    procedure BitBtnTutorialClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImageLogoClick(Sender: TObject);
  private
    DashDownloader: TDashDownloader;
  public

  end;

var
  Frei3VideoDownloaderForm: TFrei3VideoDownloaderForm;

implementation

{$R *.lfm}

{ TFrei3VideoDownloaderForm }

procedure TFrei3VideoDownloaderForm.FormCreate(Sender: TObject);
begin
  {$IFDEF WINDOWS}
  EditUuid.BorderSpacing.Around := 12;
  {$ENDIF}
  DashDownloader := nil;
end;

procedure TFrei3VideoDownloaderForm.FormDestroy(Sender: TObject);
begin
  if DashDownloader <> nil then
    DashDownloader.Free;
end;

procedure TFrei3VideoDownloaderForm.ImageLogoClick(Sender: TObject);
begin

end;

procedure TFrei3VideoDownloaderForm.BitBtnOpenClick(Sender: TObject);
var
  i, len: integer;
  uuid: string;
begin
  len := length(EditUuid.Text);
  if len > 36 then
  begin
    uuid := Copy(EditUuid.Text, len - 35, 36);
  end
  else
  begin
    uuid := EditUuid.Text;
  end;

  if IsUuid(uuid) then
  begin
    if DashDownloader <> nil then
      DashDownloader.Free;

    DashDownloader := TDashDownloader.Create(uuid);

    RadioGroupStreams.Items.Clear;
    for i := 0 to DashDownloader.getStreamCount - 1 do
    begin
      if DashDownloader.getCodecType(i) = 'video' then
      begin
        RadioGroupStreams.Items.Append(IntToStr(DashDownloader.getVideoHeight(i)) +
          'p ( ' + DashDownloader.getCodecName(i) + ' / ' +
          IntToStr(DashDownloader.getBitRate(i) div 1024) + 'kbit/s )');
      end;
    end;
    //Caption := IntToStr(DashDownloader.getStreamCount);
  end
  else
  begin
    ShowMessage('Ungültige UUID');
  end;
end;

procedure TFrei3VideoDownloaderForm.BitBtnInfoClick(Sender: TObject);
var
  copyR: string;
begin
  copyR :=
    //-------------->
    Caption + #13#10 + 'Version 0.0.1' +

  {$IFDEF WINDOWS}
    ' auf Windows ' +
  {$ELSE}
    ' auf Linux ' +
  {$ENDIF}

  {$ifdef cpui386}
    '32 Bit' + #13#10 +
  {$endif}
  {$ifdef cpux86_64}
    '64 Bit' + #13#10 +
  {$endif}

    'Copyright © WeizenWolf, 2020' + #13#10 + 'Kontakt: weizerwolf@web.de'
  //<--------------
  ;

  ShowMessage(copyR);
end;

procedure TFrei3VideoDownloaderForm.BitBtnPlayClick(Sender: TObject);
begin
  if DashDownloader <> nil then
  begin
    if DashDownloader.getStreamCount > 0 then
    begin
      DashDownloader.Play;
    end
    else
    begin
      ShowMessage('Quelle enthält keine gültigen Streams');
    end;
  end
  else
  begin
    ShowMessage('Tragen sie bitte eine UUID ein und klicken sie anschließend auf "Prüfen"');
  end;
end;

procedure TFrei3VideoDownloaderForm.BitBtnSaveClick(Sender: TObject);
begin
  if DashDownloader <> nil then
  begin
    if RadioGroupStreams.ItemIndex <> -1 then
    begin
      if SaveDialog.Execute then
      begin
        if not AnsiEndsText('.mp4', SaveDialog.FileName) then
        begin
          SaveDialog.FileName := SaveDialog.FileName + '.mp4';
        end;

        if FileExists(SaveDialog.FileName) then
        begin
          ShowMessage('Datei existiert bereits');
          Exit;
        end;

        BitBtnSave.Enabled := False;
        Application.ProcessMessages;
        DashDownloader.Save(SaveDialog.FileName, RadioGroupStreams.ItemIndex);
        BitBtnSave.Enabled := True;
      end;
    end
    else
    begin
      ShowMessage('Wählen sie vorher bitte einen Stream aus');
    end;
  end
  else
  begin
    ShowMessage('Tragen sie bitte eine UUID ein und klicken sie anschließend auf "Prüfen"');
  end;
end;

procedure TFrei3VideoDownloaderForm.BitBtnTutorialClick(Sender: TObject);
var
  tutorial: string;
begin
  tutorial :=
    //-------------->
    'Das hier ist ein von der Medienplattform frei3 unabhängiges Programm ' +
    'um Videos dort herunterladen zu können, ' + 'also auf eigene Gefahr ;)' +
    #13#10 + #13#10 + '(1) Im Eingabefeld im oberen Bereich die URL eines frei3-Beitrags '
    + '(frei3 Videoquelle muss vorhanden sein!)  eingeben.' +
    ' Wahlweise auch nur die UUID angeben.' + #13#10 +
    '(2) Nach einem klick auf "Prüfen", erscheinen die verfügbaren Streams. ' +
    'Bitte wähle einen der Streams.' + #13#10 +
    '(3) Mit "Abspielen" wird das Video ohne zu Speichern abgespielt werden.' +
    #13#10 + '(4) Mit "Speichern" kann die Auswahl als MP4-Datei gespeichert werden.' +
    #13#10 + #13#10 + 'Viel Spaß bei der Nutzung! ' +
    'Vorschläge gerne an die Email unter "Info".'
  //<--------------
  ;

  ShowMessage(tutorial);
end;

end.
