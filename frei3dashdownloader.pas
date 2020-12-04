unit Frei3DashDownloader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process, fpjson, jsonparser, Frei3Utils;

type

  { TDashDownloader }

  TDashDownloader = class
  private
    fUuid: string;
    fArrayCount: integer;
    jArray: TJSONArray;
  public
    constructor Create(uuid: string);

    function getStreamCount: integer;
    function getCodecType(index: integer): string;
    function getCodecName(index: integer): string;
    function getBitRate(index: integer): integer;
    function getVideoHeight(index: integer): integer;

    procedure Play;
    procedure Save(filename: string; index: integer);
  end;

implementation

const
  mpd_url = 'https://media.frei3.de/files/video/[UUID]/dash/video.mpd';

{ TDashDownloader }

constructor TDashDownloader.Create(uuid: string);
var
  p: TProcess = nil;
  jObject: TJSONObject;
  test: string;
begin
  if IsUuid(uuid) then
  begin
    fUuid := uuid;
    fArrayCount := 0;
  end
  else
  begin
    raise Exception.Create('no UUID exception');
  end;

  try
    p := TProcess.Create(nil);
    {$IFDEF WINDOWS}
    p.Executable := GetCurrentDir + '\ffprobe.exe';
    p.ShowWindow := swoHide;
    {$ELSE}
    p.Executable := 'ffprobe';
    {$ENDIF}

    p.Parameters.Append('-v');
    p.Parameters.Append('quiet');
    p.Parameters.Append('-print_format');
    p.Parameters.Append('json');
    p.Parameters.Append('-show_format');
    p.Parameters.Append('-show_streams');
    p.Parameters.Append(StringReplace(mpd_url, '[UUID]', fUuid, []));

    p.Options := p.Options + [poUsePipes];
    p.Execute;
    test := readOutput(p);

    jObject := TJSONObject(GetJSON(test));//.FindPath('streams[5]'));
    jArray := jObject.Get('streams', TJSONArray.Create);
    fArrayCount := jArray.Count;
  finally
    if p <> nil then
      p.Free;
  end;
end;

function TDashDownloader.getStreamCount: integer;
begin
  Result := fArrayCount;
end;

function TDashDownloader.getCodecType(index: integer): string;
begin
  Result := '';

  if (index >= 0) and (index < fArrayCount) then
  begin
    Result := jArray.Objects[index].Get('codec_type', '');
  end;
end;

function TDashDownloader.getCodecName(index: integer): string;
begin
  Result := '';

  if (index >= 0) and (index < fArrayCount) then
  begin
    Result := jArray.Objects[index].Get('codec_name', '');
  end;
end;

function TDashDownloader.getBitRate(index: integer): integer;
begin
  Result := -1;

  if (index >= 0) and (index < fArrayCount) then
  begin
    Result := StrToInt(jArray.Objects[index].Get('bit_rate', ''));
  end;
end;

function TDashDownloader.getVideoHeight(index: integer): integer;
begin
  Result := -1;

  if (index >= 0) and (index < fArrayCount) then
  begin
    if jArray.Objects[index].Get('codec_type', '') = 'video' then
    begin
      Result := jArray.Objects[index].Get('height', -1);
    end;
  end;
end;

procedure TDashDownloader.Play;
var
  p: TProcess;
begin
  p := TProcess.Create(nil);
  {$IFDEF WINDOWS}
  p.Executable := GetCurrentDir + '\ffplay.exe';
  {$ELSE}
  p.Executable := 'ffplay';
  {$ENDIF}

  p.Parameters.Append(StringReplace(mpd_url, '[UUID]', fUuid, []));
  p.Execute;
  p.Free;
end;

procedure TDashDownloader.Save(filename: string; index: integer);
var
  p: TProcess;
begin
  if FileExists(filename) then
  begin
    Exit;
  end;

  p := TProcess.Create(nil);
  //p.CommandLine := 'gnome-terminal -- ffmpeg -i ';

  {$IFDEF WINDOWS}
  p.Executable := GetCurrentDir + '\ffmpeg.exe';
  {$ELSE}
  p.Executable := 'gnome-terminal';
  p.Parameters.Append('--');
  p.Parameters.Append('ffmpeg');
  {$ENDIF}

  p.Parameters.Append('-i');
  p.Parameters.Append(StringReplace(mpd_url, '[UUID]', fUuid, []));
  p.Parameters.Append('-map');
  p.Parameters.Append('0:' + IntToStr(index));
  p.Parameters.Append('-map');
  p.Parameters.Append('0:' + IntToStr(fArrayCount - 1));
  p.Parameters.Append('-codec');
  p.Parameters.Append('copy');
  p.Parameters.Append(filename);

  p.Options := p.Options + [poWaitOnExit];
  p.Execute;
  p.Free;
end;

end.
