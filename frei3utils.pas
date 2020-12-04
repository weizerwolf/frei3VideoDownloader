unit Frei3Utils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process;

function IsUuid(uuid: string): boolean;
function readOutput(process: TProcess): string;

implementation

function IsUuid(uuid: string): boolean;
var
  i: integer;
begin
  if length(uuid) <> 36 then
  begin
    Exit(False);
  end;

  for i := 1 to 36 do
  begin
    if (i = 9) or (i = 14) or (i = 19) or (i = 24) then
    begin
      if uuid[i] = '-' then
      begin
        Continue;
      end
      else
      begin
        Exit(False);
      end;
    end;

    if (uuid[i] in ['0'..'9']) or (uuid[i] in ['a'..'f']) then
    begin
      Continue;
    end
    else
    begin
      Exit(False);
    end;
  end;

  Exit(True);
end;

function readOutput(process: TProcess): string;
const
  READ_BYTES = 2048;
var
  S: TStringList;
  M: TMemoryStream;
  n, BytesRead: longint;
begin
  M := TMemoryStream.Create;
  BytesRead := 0;

  while process.Running do
  begin
    // stellt sicher, dass wir Platz haben
    M.SetSize(BytesRead + READ_BYTES);

    // versuche, es zu lesen
    n := process.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
    if n > 0 then
    begin
      Inc(BytesRead, n);
    end
    else
    begin
      // keine Daten, warte 100 ms
      Sleep(100);
    end;
  end;
  // lese den letzten Teil
  repeat
    // stellt sicher, dass wir Platz haben
    M.SetSize(BytesRead + READ_BYTES);
    // versuche es zu lesen
    n := process.Output.Read((M.Memory + BytesRead)^, READ_BYTES);
    if n > 0 then
    begin
      Inc(BytesRead, n);
    end;
  until n <= 0;
  M.SetSize(BytesRead);

  S := TStringList.Create;
  S.LoadFromStream(M);
  Result := S.Text;
  S.Free;
  M.Free;
end;

end.
