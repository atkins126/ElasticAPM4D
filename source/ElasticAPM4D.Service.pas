unit ElasticAPM4D.Service;

interface

type
  TServiceAgent = class
  private
    FName: String;
    FVersion: String;
    Fephemeral_id: string;
  public
    constructor Create;

    property name: String read FName;
    property version: String read FVersion;
    property ephemeral_id: string read Fephemeral_id write Fephemeral_id;
  end;

  TServiceLanguage = class
  private
    FName: String;
    FVersion: String;
  public
    constructor Create;

    property name: String read FName write FName;
    property version: String read FVersion write FVersion;
  end;

  TServiceFramework = class
  private
    FName: String;
    FVersion: String;
  public
    constructor Create;
    property name: String read FName write FName;
    property version: String read FVersion write FVersion;
  end;

  TServiceRuntime = class
  private
    FName: String;
    FVersion: String;
  public
    constructor Create;

    property name: String read FName write FName;
    property version: String read FVersion write FVersion;
  end;

  TService = class
  private
    FEnvironment: string;
    FFramework: TServiceFramework;
    FLanguage: TServiceLanguage;
    FRuntime: TServiceRuntime;
    FVersion: String;
    FAgent: TServiceAgent;
    FName: String;
  public
    constructor Create;
    destructor Destroy; override;

    property name: String read FName;
    property version: string read FVersion write FVersion;
    property Agent: TServiceAgent read FAgent;
    property environment: string read FEnvironment write FEnvironment;
    property Framework: TServiceFramework read FFramework;
    property Language: TServiceLanguage read FLanguage;
    property Runtime: TServiceRuntime read FRuntime;
  end;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
  Vcl.Forms,
{$ENDIF}
  System.IOUtils,
  System.SysUtils;

{ TServiceAgent }

constructor TServiceAgent.Create;
begin
  FVersion := '1.0.0';
  FName := 'ElasticAPM4D';
  Fephemeral_id := '';
end;

{ TServiceLanguage }

constructor TServiceLanguage.Create;
begin
  FName := 'Delphi/Object Pascal';
  FVersion :=
{$IFDEF VER80} 'Delphi 1'; {$ENDIF}
{$IFDEF VER90} 'Delphi 2'; {$ENDIF}
{$IFDEF VER100} 'Delphi 3'; {$ENDIF}
{$IFDEF VER120} 'Delphi 4'; {$ENDIF}
{$IFDEF VER130} 'Delphi 5'; {$ENDIF}
{$IFDEF VER140} 'Delphi 6'; {$ENDIF}
{$IFDEF VER150} 'Delphi 7'; {$ENDIF}
{$IFDEF VER160} 'Delphi 8'; {$ENDIF}
{$IFDEF VER170} 'Delphi 2005'; {$ENDIF}
{$IFDEF VER180} 'Delphi 2006'; {$ENDIF}
{$IFDEF VER185} 'Delphi 2007'; {$ENDIF}
{$IFDEF VER200} 'Delphi 2009'; {$ENDIF}
{$IFDEF VER210} 'Delphi 2010'; {$ENDIF}
{$IFDEF VER220} 'Delphi XE'; {$ENDIF}
{$IFDEF VER230} 'Delphi XE2'; {$ENDIF}
{$IFDEF VER240} 'Delphi XE3'; {$ENDIF}
{$IFDEF VER250} 'Delphi XE4'; {$ENDIF}
{$IFDEF VER260} 'Delphi XE5'; {$ENDIF}
{$IFDEF VER270} 'Delphi XE6'; {$ENDIF}
{$IFDEF VER280} 'Delphi XE7'; {$ENDIF}
{$IFDEF VER290} 'Delphi XE8'; {$ENDIF}
{$IFDEF VER300} 'Delphi 10.0 Seattle'; {$ENDIF}
{$IFDEF VER310} 'Delphi 10.1 Berlin'; {$ENDIF}
{$IFDEF VER320} 'Delphi 10.2 Tokyo'; {$ENDIF}
{$IFDEF VER330} 'Delphi 10.3 Rio'; {$ENDIF}
end;

{ TServiceRuntime }

constructor TServiceRuntime.Create;
{$IFDEF MSWINDOWS}
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  FName := TPath.GetFileNameWithoutExtension(Application.ExeName);

  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
  begin
    FVersion := '0';
    exit;
  end;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) or
    not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  FVersion := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi, LongRec(FixedPtr.dwFileVersionMS).Lo,
    LongRec(FixedPtr.dwFileVersionLS).Hi, LongRec(FixedPtr.dwFileVersionLS).Lo]);
{$ENDIF}
end;

{ TService }

constructor TService.Create;
begin
  FAgent := TServiceAgent.Create;
  FLanguage := TServiceLanguage.Create;
  FRuntime := TServiceRuntime.Create;
  FFramework := TServiceFramework.Create;
  FVersion := '';
  FName := FRuntime.name;
end;

destructor TService.Destroy;
begin
  FAgent.Free;
  FLanguage.Free;
  FRuntime.Free;
  FFramework.Free;
  inherited;
end;

{ TElasticAPM4DServiceFramework }

constructor TServiceFramework.Create;
begin
{$IFDEF dmvcframework}
  FName := 'dmvcframework';
  FVersion := '3.1.0';
{$ENDIF}
end;

end.
