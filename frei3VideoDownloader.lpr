program frei3VideoDownloader;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  frei3VideoDownloader_main,
  Frei3Utils,
  Frei3DashDownloader { you can add units after this },
  SysUtils,
  Process;

{$R *.res}

var
  p: TProcess;
begin
  try
    p := TProcess.Create(nil);
    p.Options := p.Options + [poUsePipes];
    p.Parameters.Append('-version');
    {$IFDEF WINDOWS}
    p.ShowWindow := swoHide;
    p.Executable := GetCurrentDir + '\ffmpeg.exe';
    {$ELSE}
    p.Executable := 'ffmpeg';
    {$ENDIF}
    p.Execute;
    readOutput(p);
    {$IFDEF WINDOWS}
    p.Executable := GetCurrentDir + '\ffprobe.exe';
    {$ELSE}
    p.Executable := 'ffprobe';
    {$ENDIF}
    p.Execute;
    readOutput(p);
    {$IFDEF WINDOWS}
    p.Executable := GetCurrentDir + '\ffplay.exe';
    {$ELSE}
    p.Executable := 'ffplay';
    {$ENDIF}
    p.Execute;
    readOutput(p);
  except
    Application.MessageBox(PChar(p.Executable + ' konnte nicht gefunden werden. ' +
      'Es wird jedoch für die korrekte Ausführung des Programms benötigt!'),
      'FFMPEG nicht gefunden', 0);
    p.Free;
    Exit;
  end;
  p.Free;

  RequireDerivedFormResource := True;
  Application.Title := 'frei3VideoDownloader (inoffiziell)';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TFrei3VideoDownloaderForm, Frei3VideoDownloaderForm);
  Application.Run;
end.
