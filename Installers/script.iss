; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Youtube Downloader"
#define MyAppVersion "1.0"
#define MyAppPublisher "STG Apps"
#define MyAppURL "https://github.com/SakshhamTheCoder"
#define MyAppExeName "youtube_downloader.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{EFBFA5BE-AC4C-4FA5-B8AF-69D744289209}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=D:\ALL CODES\Codes\youtube_downloader\Installers
OutputBaseFilename=Setup_Youtuber_Downloader
SetupIconFile=D:\ALL CODES\Codes\youtube_downloader\windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\ALL CODES\Codes\youtube_downloader\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\ALL CODES\Codes\youtube_downloader\build\windows\runner\Release\bitsdojo_window_windows_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\ALL CODES\Codes\youtube_downloader\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\ALL CODES\Codes\youtube_downloader\build\windows\runner\Release\youtube_downloader.exp"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\ALL CODES\Codes\youtube_downloader\build\windows\runner\Release\youtube_downloader.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\ALL CODES\Codes\youtube_downloader\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

