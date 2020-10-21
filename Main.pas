unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, Sockets, ComCtrls, DCPockets, ExtCtrls, LuaUnit,
  Menus, About, Lua, XPMan, TabNotBk, Registry, TrayIcon, AppEvnts, SyntaxU;

type
  TBuffer = Record
   Mess: String;
   Time: TDateTime;
   Key: byte;
   ValidateNick: byte;
   Client: TCustomWinSocket;
  End;

  TMainForm = class(TForm)
    ServerSocket1: TServerSocket;
    Button1: TButton;
    Button2: TButton;
    Edit3: TEdit;
    Label2: TLabel;
    Button3: TButton;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Timer2: TTimer;
    XPManifest1: TXPManifest;
    RichEdit2: TRichEdit;
    TabbedNotebook1: TTabbedNotebook;
    LW: TListView;
    PopupMenu1: TPopupMenu;
    N6: TMenuItem;
    Button4: TButton;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    IP1: TEdit;
    IP2: TEdit;
    CheckBox2: TCheckBox;
    Button5: TButton;
    UpSocket: TClientSocket;
    PopupMenu2: TPopupMenu;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    Timer3: TTimer;
    Lichka: TRichEdit;
    PopupMenu3: TPopupMenu;
    N14: TMenuItem;
    N15: TMenuItem;
    MainEdit: TRichEdit;
    procedure N15Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure TrIconClick(Sender: TObject);
    procedure UpSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure UpSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure UpSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure Button5Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ServerSocket1ClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button3Click(Sender: TObject);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure RichEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure LWEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure N6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure OnMinimize(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);

  private
    procedure WMHotkey( var msg: TWMHotkey ); message WM_HOTKEY;
  public
    procedure TiTimer(Sender: TObject);
  end;

  Procedure AddText(S: String; Into: TRichEdit);
  Function DelFromList(S: String):Boolean;


var
  MainForm: TMainForm;
  DCreate, DClose: TDateTime;
  T : TTimer;
  LastMessage, LastSend, Mess, UpMess, UpHost: String;
  LastClient: TCustomWinSocket;
  NormNick: String;
  LastSellectedItem: Integer;
  Blocked: Boolean = false;
  IsBreak: Boolean = false;
  Chat: Boolean = true;
  Servers: Array Of TServerSocket;
  Buffers: Array of TBufFer;
  Rezerved, Znak: Array of TRezerved;
  Skobki: Array of TSkobki;
  GetMessCount: LongInt;
  AutoScroll, AutoCheck, AutoRun, AutoMinimaze, AutoLog: Boolean;
  TrIcon: TTrayIcon;
  TempCommand: String;

implementation

{$R *.dfm}

Uses Options;

function PosAfter(Sub, S: String; Num: LongInt): LongInt;

var T: Longint;

begin
  delete(S, 1, Num);
  T:=Pos(Sub, S);
  if T>0 then
    PosAfter:=T+Num
  else
    PosAfter:=0;
end;

Procedure LoadRezerved;

begin
 SetLength(Skobki, 6);
 Skobki[0].First:='[GREEN]';
 Skobki[0].Last:='[/GREEN]';
 Skobki[0].Style.Color:=clGreen;
 Skobki[0].Stat:=True;
 Skobki[1].First:='[RED]';
 Skobki[1].Last:='[/RED]';
 Skobki[1].Style.Color:=clRed;
 Skobki[1].Stat:=True;
 Skobki[2].First:='[BLUE]';
 Skobki[2].Last:='[/BLUE]';
 Skobki[2].Style.Color:=clSkyBlue-50000;
 Skobki[2].Stat:=True;
 Skobki[3].First:='[B]';
 Skobki[3].Last:='[/B]';
 Skobki[3].Style.Styles:=[fsBold];
 Skobki[3].Stat:=False;
 Skobki[4].First:='[I]';
 Skobki[4].Last:='[/I]';
 Skobki[4].Style.Styles:=[fsItalic];
 Skobki[4].Stat:=False;
 Skobki[5].First:='[U]';
 Skobki[5].Last:='[/U]';
 Skobki[5].Style.Styles:=[fsUnderline];
 Skobki[5].Stat:=False;
 SetLength(Rezerved, 0);
 SetLength(Znak, 0);
end;


 function ForceForegroundWindow(hwnd: THandle): Boolean;
 const
   SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
   SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
 var
   ForegroundThreadID: DWORD;
   ThisThreadID: DWORD;
   timeout: DWORD;
 begin
   if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

   if GetForegroundWindow = hwnd then Result := True
   else
   begin
    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
       ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
       ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
       (Win32MinorVersion > 0)))) then
     begin
       Result := False;
       ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
       ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
       if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
       begin
        BringWindowToTop(hwnd);
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
       end;
       if not Result then
       begin
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(hwnd);
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
       end;
     end
     else
     begin
      BringWindowToTop(hwnd);
      SetForegroundWindow(hwnd);
     end;

     Result := (GetForegroundWindow = hwnd);
   end;
 end;

procedure TMainForm.WMHotkey( var msg: TWMHotkey );
begin
  if msg.hotkey = 1 then
  begin
//   ShowMessage(IntToStr(GetForegroundWindow) + ' - ' + IntToStr(Application.Handle));
   if (GetForegroundWindow <> Application.Handle)And(Visible) then
     Visible:=False
   Else
     if Not Visible then
     Begin
       Visible:=True;
       ForceForegroundWindow(Application.Handle);
     end Else
       ForceForegroundWindow(Application.Handle);
   Application.ProcessMessages;
  end;
end;

Procedure AddText(S: String; Into: TRichEdit);

var Po: TPoint;

Begin
 Po:=Into.CaretPos;
 while Into.Lines.Count>400 do
   Into.Lines.Delete(0);
// Into.Lines.Add(S);
 EaseSyntax(Into, Skobki, clBlack, [], S);
 Po.X:=1;
 Po.Y:=Into.Lines.Count;
 Into.CaretPos:=Po;
 if AutoScroll then
   Into.Perform(EM_SCROLL, Length(Into.Text), Length(Into.Text));
End;

procedure TMainForm.TiTimer(Sender: TObject);

Var I: Integer;

begin
 for I := 0 to High(Files) do
 Begin
  lua_dostring(Files[I].L, 'OnTimer()');
 end;
end;

procedure TMainForm.TrIconClick(Sender: TObject);
begin
 Visible:=Not Visible;
 SetForegroundWindow(Application.Handle);
 Application.ProcessMessages;
end;

procedure TMainForm.UpSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
 Socket.SendText('$GetLastVersion|');
end;

procedure TMainForm.UpSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
 ShowMessage('На данный момент сервер не доступен!!!');
 ErrorCode:=0;
end;

procedure TMainForm.UpSocketWrite(Sender: TObject; Socket: TCustomWinSocket);

Var S, T, Par: String;

begin
 S:=Socket.ReceiveText;
 UpMess:=UpMess+S;
 While Pos('|', UpMess)<>0 Do
 Begin
  T:=Copy(UpMess, 1, pos('|', UpMess)-1);
  Delete(UpMess, 1, pos('|', UpMess));
  if Pos(' ', T)<>0 then
  Begin
   Par:=Copy(T, pos(' ', T)+1, Length(T));
   Delete(T, pos(' ', T), Length(T));
  end
  Else
   Par:='';
  if T='$CurVersion' then
  Begin
   ShowMessage('На данный момент найдена '+Par+' версия программы IceHub.');
   Continue;
  end;
  if T='$Url' then
  Begin
   ShowMessage('Скачать можно с '+Par);
   Continue;
  end;
  if T='END' then
  Begin
   UpSocket.Close;
   UpMess:='';
   Continue;
  end;
 end;
end;

Procedure Term;
Begin
 MainForm.Close;
End;

function SendTextTo(S : String; Client : TCustomWinSocket): Boolean;

var I: LongInt;
    St: String;

Begin
//  Application.HandleMessage;
  I:=0;
  St:=S;
  while posAfter(#$A, S, I)>0 do
  begin
    if (posAfter(#$A, S, I)<=1)or((posAfter(#$A, S, I)>1)and(S[posAfter(#$A, S, I)-1]<>#$D)) then
      delete(S, posAfter(#$A, S, I), 1);
    I:=posAfter(#$A, S, I);
  end;
  while pos(#$B, S)>0 do
    delete(S, pos(#$B, S), 1);
  while pos(#$C, S)>0 do
    delete(S, pos(#$C, S), 1);
  I:=0;
  while posAfter(#$D, S, I)>0 do
  begin
    if (posAfter(#$D, S, I)>=length(S))or((posAfter(#$D, S, I)<length(S))and(S[posAfter(#$D, S, I)+1]<>#$A)) then
      delete(S, posAfter(#$D, S, I), 1);
    I:=posAfter(#$D, S, I);
  end;
  while pos(#$E, S)>0 do
    delete(S, pos(#$E, S), 1);
  Result:=True;
  if (S='|')or(S='') then
    exit;
  if (Client<>nil)and(Assigned(Client))and(Client.Connected) then
  begin
    if (Chat) then
    begin
      if S[1]<>'$' then
        try
          AddText('<[blue]Server[/blue]> to <'+Client.RemoteAddress+'> '+S, MainForm.MainEdit);
        finally
        end;
    end
    else
      try
        AddText('<[blue]Server[/blue]> to <'+Client.RemoteAddress+'> '+S, MainForm.MainEdit);
      finally
      end;
    S:=St;
    try
      Client.SendText(S);
    except
      Result:=False;
    end;
  end
  else
    Result:=False;
End;

Function DelFromList(S: String):Boolean;

Var I: LongInt;

Begin
 DelFromList:=False;
 for I := 0 to MainForm.LW.Items.Count-1 do
  if MainForm.LW.Items[I].Caption=S then
  Begin
   MainForm.LW.Items[I].Delete;
   DelFromList:=True;
   Break;
  end;
end;

Procedure SendText(S : String; Script: Boolean);

Var I, J: Integer;
    ST: String;

Begin
  I:=0;
  St:=S;
  while posAfter(#$A, S, I)>0 do
  begin
    if (posAfter(#$A, S, I)<=1)or((posAfter(#$A, S, I)>1)and(S[posAfter(#$A, S, I)-1]<>#$D)) then
      delete(S, posAfter(#$A, S, I), 1);
    I:=posAfter(#$A, S, I);
  end;
  while pos(#$B, S)>0 do
    delete(S, pos(#$B, S), 1);
  while pos(#$C, S)>0 do
    delete(S, pos(#$C, S), 1);
  I:=0;
  while posAfter(#$D, S, I)>0 do
  begin
    if (posAfter(#$D, S, I)>=length(S))or((posAfter(#$D, S, I)<length(S))and(S[posAfter(#$D, S, I)+1]<>#$A)) then
      delete(S, posAfter(#$D, S, I), 1);
    I:=posAfter(#$D, S, I);
  end;
  while pos(#$E, S)>0 do
    delete(S, pos(#$E, S), 1);
  if (S='|')or(S='') then
    exit;
  if (Chat) then
  begin
    if (S[1]<>'$')and(not Script) then
      try
        AddText('<[blue]Server[/blue]> '+Parse(S), MainForm.MainEdit);
      finally
      end;
  end
  else
    try
      AddText('<[blue]Server[/blue]> '+Parse(S), MainForm.MainEdit);
    finally
    end;
  S:=St;
  for I:=0 to High(Servers) do
    for J:=0 to Servers[I].Socket.ActiveConnections-1 do
    begin
//      Application.HandleMessage;
      if (Servers[I].Socket.Connections[J]<>nil)and(Assigned(Servers[I].Socket.Connections[J]))and(Servers[I].Socket.Connections[J].Connected) then
      begin
        try
          Servers[I].Socket.Connections[J].SendText(S);
        finally
        end;
      end;
    end;
End;

procedure TMainForm.Button1Click(Sender: TObject);

Var I: Integer;

begin
 If Button1.Caption = 'Disconnect' Then
 Begin
  For I:= 0 To High(Servers) Do
  Begin
   Servers[I].Active:=False;
   AddText('[b][green]**Close server, port = [/green][/b]'+InttoStr(Servers[I].Port), MainEdit);
  End;
  SetLength(Users, 0);
  SetLength(Ops, 0);
  Button1.Caption:='Connect';
  N3.Caption:='Connect';
 End
 Else
 Begin
  Button3Click(Button3);
  For I:= 0 To High(HubPort) Do
  Begin
   Servers[I].Port:=HubPort[I];
   Try
    Servers[I].Open;
    AddText('[b][green]**Open server, port = [/green][/b]'+InttoStr(Servers[I].Port), MainEdit);
   Except
    AddText('[b][red]**Can''t open server, port = [/red][/b]'+InttoStr(Servers[I].Port), MainEdit);
   End;
  End;
  Button1.Caption:='Disconnect';
  N3.Caption:='Disconnect';
 End;
end;


procedure TMainForm.ServerSocket1ClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);

begin
  TempCommand:=TempCommand+Socket.ReceiveText;
  GetString(TempCommand, Socket);
end;

procedure TMainForm.Button2Click(Sender: TObject);

begin
 If RichEdit2.Text = '' Then Exit;
 If RichEdit2.Text[1]='@' Then
 Begin
  RunCommand(Copy(RichEdit2.Text, 2, Length(RichEdit2.Text)));
  Exit;
 End;
 If RichEdit2.Text[1]='$' Then
  SendText(RichEdit2.Text+'|', False)
 Else
  SendText(Edit3.Text+' '+RichEdit2.Text+'|', False);
 RichEdit2.Lines.Clear;
end;

Procedure Discon(Client : TCustomWinSocket);

Var Co, K, I, J, N : Integer;
    Name: String;

Begin
// Application.HandleMessage;
 For I:=0 To High(Buffers) Do
  If Buffers[I].Client=Client Then
  Begin
   Buffers[I]:=Buffers[High(Buffers)];
   SetLength(Buffers, High(Buffers));
   Break;
  End;
 For Co:=0 To High(Servers) Do
 Begin
  With Servers[Co].Socket Do
  Begin
   K:=ActiveConnections - 1;
   For I:=0 To K Do
   If Connections[I] = Client Then
   Begin
    N:=FindClient(Client);
    If N<>-1 Then
     DelUser(Users[N].Name);
    Connections[I].Close;
    Break;
   End;
  End;
 End;
End;

procedure TMainForm.FormCreate(Sender: TObject);

Var F: TextFile;
    I: Integer;
    RegProcess: function (p1, p2:integer): integer; stdcall;
    hDllKernel: HInst; reg: TRegistry;

begin
 LoadRezerved;
 if ParamStr(1)<>'' then
  SetCurrentDir(ParamStr(1));
 LoadIniFile(GetCurrentDir+'\Settings\config.ini');
 TrIcon:=TTrayIcon.create(nil);
 TrIcon.Icon:=MainForm.Icon;
 TrIcon.OnDblClick:=TrIconClick;
 TrIcon.Active:=True;
 TrIcon.PopupMenu:=PopupMenu2;
 if not RegisterHotkey(Handle, 1, MOD_ALT or MOD_CONTROL, VK_F3) then
  ShowMessage('Не получилось установить гарячие клавиши Alt-Ctrl-F3');
 Application.OnMinimize:=OnMinimize;
 If not DirectoryExists('Settings') Then
  MkDir('Settings');
 If not DirectoryExists('Script') Then
  MkDir('Script');
 If not DirectoryExists('Logs') Then
  MkDir('Logs');
 If not FileExists('Settings\BanName.txt') Then
  FileCreate('Settings\BanName.txt');
 If not FileExists('Settings\BanIP.txt') Then
  FileCreate('Settings\BanIP.txt');
 If not FileExists('Settings\FAQ.txt') Then
  FileCreate('Settings\FAQ.txt');
 If not FileExists('Settings\Menu.txt') Then
  FileCreate('Settings\Menu.txt');
 If not FileExists('Settings\MsgIP.txt') Then
  FileCreate('Settings\MsgIP.txt');
 If not FileExists('Settings\MsgName.txt') Then
  FileCreate('Settings\MsgName.txt');
 If not FileExists('Settings\OpList.txt') Then
  FileCreate('Settings\OpList.txt');
 If not FileExists('Settings\RegUsersList.txt') Then
  FileCreate('Settings\RegUsersList.txt');
 If not FileExists('Script\Files.cfg') Then
 Begin
  AssignFile(F, 'Script\Files.cfg');
  ReWrite(F);
  WriteLn(F, 1);
  WriteLn(F, 'Main.lua');
  CloseFile(F);
 End;
 If not FileExists('Script\Main.lua') Then
 Begin
  AssignFile(F, 'Script\Main.lua');
  ReWrite(F);
  Writeln(F, 'function Main()');
  Writeln(F, ' RegBot("Scr!ptB0t", 0, "DE5CR!PT!0N", "E-M@!l");');
  Writeln(F, 'end;');
  CloseFile(F);
 End;
 LastSellectedItem:=-1;
 DCreate:=GetTime;
 HubStartMessage:=BotName + HubStartMessage;
 AllSend:=SendText;
 SendTo:=SendTextTo;
 Disconnect:=Discon;
 Terminate:=Term;
 SetHubCommands;
 SetLength(Servers, Length(HubPort));
 For I:=0 To High(HubPort) Do
 Begin
  Servers[I]:=TServerSocket.Create(nil);
  Servers[I].OnClientConnect:=ServerSocket1.OnClientConnect;
  Servers[I].OnClientDisconnect:=ServerSocket1.OnClientDisconnect;
  Servers[I].OnClientRead:=ServerSocket1.OnClientRead;
  Servers[I].OnClientWrite:=ServerSocket1.OnClientWrite;
  Servers[I].OnClientError:=ServerSocket1.OnClientError;
 End;
 Button1Click(Button1);
 AutoScroll:=N14.Checked;
 MainForm.WindowState:=wsMaximized;
 If Chat Then
  Button4.Caption:='All'
 Else
  Button4.Caption:='Only Chat';
 if AutoCheck then
 Begin
  UpSocket.Host:=UpHost;
  UpSocket.Open;
 end;

 if AutoRun then
 Begin
  Reg := nil;
  try
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.LazyWrite := false;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',
      false);
    reg.WriteString('IceHub', '"'+Application.ExeName+'" "'+GetCurrentDir+'"');
    reg.CloseKey;
    reg.free;
  except
   if Assigned(Reg) then Reg.Free;
  end;
 end Else
 Begin
  Reg := nil;
  try
    reg := TRegistry.Create;
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.LazyWrite := false;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run',
      false);
    reg.DeleteValue('IceHub');
    reg.CloseKey;
    reg.free;
  except
   if Assigned(Reg) then Reg.Free;
  end;
 end;
 if AutoMinimaze then
 begin
  Application.ShowMainForm:=False;
  SetForegroundWindow(Application.Handle);
  Application.ProcessMessages;
 end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 UnRegisterHotkey(Handle, 1);
 SaveIniFile(GetCurrentDir+'\Settings\config.ini');
 IniFile.Free;
 Done;
 TrIcon.destroy;
end;

procedure TMainForm.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
Begin
 SetLength(Buffers, High(Buffers)+2);
 Buffers[High(Buffers)].Client:=Socket;
 if not Chat then
  AddText('[red]**Connect user [/red]'+Socket.RemoteAddress, MainEdit);
 OnConnect(Socket);
end;

procedure TMainForm.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);

Var I: Integer;

Begin
 if not Chat then
  AddText('[red]**Disconnect user [/red]'+Socket.RemoteAddress, MainEdit);
 For I:=0 To High(Buffers) Do
  If Buffers[I].Client=Socket Then
  Begin
   Buffers[I]:=Buffers[High(Buffers)];
   SetLength(Buffers, High(Buffers));
  End;
 OnDisconnect(Socket);
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
 LoadBanName;
 LoadBanIP;
 LoadCoolName;
 LoadOpList;
 LoadRegUserList;
 LoadIniFile(GetCurrentDir+'\Settings\config.ini');
 Done;
 Init;
end;

procedure TMainForm.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);

Var I, J, N, K: Integer;
    Name: String;
  Co: Integer;

begin
 if not Chat then
  AddText('[b][red]Произошла ошибка на сокете[/red][/b] №'+IntToStr(ErrorCode), MainEdit);
 I:=FindClient(Socket);
 If I<>-1 Then
  DelUser(Users[I].Name);
 for Co := 0 to High(Servers) do
 Begin
  with Servers[Co].Socket Do
  Begin
   K:=ActiveConnections - 1;
   For I:=0 To K Do
    If Connections[I] = Socket Then
    Begin
     N:=FindClient(Socket);
     Connections[I].Close;
     If N<>-1 Then
     Begin
      Name:=Users[N].Name;
      J:=0;
      While J<=MainForm.LW.Items.Count-1 Do
      Begin
       If Name=MainForm.LW.Items.Item[J].SubItems[0] Then Begin
        MainForm.LW.Items.Item[J].Delete;
        Dec(J);
       End;
       Inc(J);
      End;
      AllSend('$Quit '+Name+'|', False);
     End;
     Break;
    End;
  End;
 end;
 for I := 0 to High(Servers) do
   Servers[I].Open;
 ErrorCode:=0;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
// FlashWindow(Application.Handle, true);
  MainForm.Caption:='IceHub - Online = '+IntToStr(High(Users)+1);
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
 Button1.Click;
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
 Button3.Click;
end;

procedure TMainForm.N5Click(Sender: TObject);
begin
 MainForm.Close;
end;

procedure TMainForm.N10Click(Sender: TObject);

Var I: LongInt;

begin
 LW.Clear;
 I:=0;
 While I<=High(Users) Do
 Begin
  If (not Users[I].Bot) Then
  Begin
   LW.Items.Add;
   LW.Items.Item[LW.Items.Count-1].Caption:=Users[I].CoolName;
   LW.Items.Item[LW.Items.Count-1].SubItems.Add(Users[I].Name);
   LW.Items.Item[LW.Items.Count-1].SubItems.Add(ShareTranslate(Users[I].Share));
   LW.Items.Item[LW.Items.Count-1].SubItems.Add(Users[I].Description);
   LW.Items.Item[LW.Items.Count-1].SubItems.Add(Users[I].IP);
  End;
  Inc(I);
 End;
 LoadBanName;
 LoadBanIP;
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
 Visible:=Not Visible;
 SetForegroundWindow(Application.Handle);
 Application.ProcessMessages;
end;

procedure TMainForm.N12Click(Sender: TObject);
begin
 Button1Click(N12); 
end;

procedure TMainForm.N13Click(Sender: TObject);
begin
 MainForm.Close;
end;

procedure TMainForm.N14Click(Sender: TObject);
begin
  N14.Checked:=not N14.Checked;
  AutoScroll:=N14.Checked;
end;

procedure TMainForm.N15Click(Sender: TObject);
begin
 MainEdit.Lines.Clear;
end;

procedure TMainForm.N2Click(Sender: TObject);
begin
 AboutBox.ShowModal;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);

Var I: Integer;
    Fset: TFormatSettings;

begin
 if AutoLog then
 Begin
  Fset.TimeSeparator:='-';
  Fset.DateSeparator:='.';
  Fset.ShortDateFormat:='dd.mm.yy';
  Fset.LongDateFormat:='dd.mm.yyyy';
  Fset.ShortTimeFormat:='hh-mm-ss';
  Fset.LongTimeFormat:='hh-mm-ss';
  MainEdit.Lines.SaveToFile('logs\log '+DateToStr(Date)+' '+TimeToStr(Time, Fset)+'.txt');
  LW.Clear;
  I:=0;
  While I<=High(Users) Do
  Begin
   If (not Users[I].Bot) Then
   Begin
    LW.Items.Add;
    LW.Items.Item[LW.Items.Count-1].Caption:=Users[I].CoolName;
    LW.Items.Item[LW.Items.Count-1].SubItems.Add(Users[I].Name);
    LW.Items.Item[LW.Items.Count-1].SubItems.Add(ShareTranslate(Users[I].Share));
    LW.Items.Item[LW.Items.Count-1].SubItems.Add(Users[I].Description);
    LW.Items.Item[LW.Items.Count-1].SubItems.Add(Users[I].IP);
   End;
   Inc(I);
  End;
  LoadBanName;
  LoadBanIP;
 end;
end;

procedure TMainForm.RichEdit2KeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 Then
 Begin
  Key := #0;
  Button2Click(Button2);
 end;
end;

procedure TMainForm.LWEdited(Sender: TObject; Item: TListItem; var S: String);
begin
 AllSend('$Quit '+Item.Caption+'|', False);
 Users[FindUser(Item.SubItems[0])].CoolName:=S;
 if FindInName(Item.SubItems[0])=-1 then
 Begin
  SetLength(CoolUsers, High(CoolUsers)+2);
  CoolUsers[High(CoolUsers)].Name:=Item.SubItems[0];
  CoolUsers[High(CoolUsers)].CoolName:=S;
 end Else
  CoolUsers[FIndInName(Item.SubItems[0])].CoolName:=S;
 AllSend('$Hello '+S+'|'+GetINFO(Item.SubItems[0]), False);
 If IsOpOn(Item.SubItems[0])<>-1 Then
 Begin
  AllSend('$OpList '+S+'|', False);
 End;
end;

procedure TMainForm.N6Click(Sender: TObject);

Var T1, I, J, UserID: Integer;
    S: String;

begin
 J:=0;
 While J<=LW.Items.Count-1 Do
 Begin
  If LW.Items.Item[J].Selected Then Begin
   S:=LW.Items.Item[J].SubItems[0];
   For I:=0 To High(Files) Do
    lua_dostring(Files[I].L, PAnsiChar(CreateUserString('<SERVER>', '<SERVER>', '0.0.0.0', '0', 'SERVER', 'SERVER')+'KickArrival(curUser, "$Kick '+S+'|")'));
   UserID:=FindUser(S);
   If UserID<>-1 Then
   Begin
    T1:=IsOpOn(Users[UserID].Name);
    If (Users[UserID].Bot)Or(Users[UserID].Email='frolvladv@pochta.ru')Or(Users[UserID].Email='спроси@у.мя') Then
     AllSend(BotName+DefUser1+Users[UserID].Name+DefUser2+'|', False)
    Else
    Begin
     Dec(J);
     Disconnect(Users[UserID].Client);
     AllSend(BotName+Kick1+S+Kick2+'|', False);
    End;
   End;
   {DELETE!!!!}
   break;
  End;
  Inc(J);
 End;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
 Chat:=not Chat;
 If Chat Then
  Button4.Caption:='All'
 Else
  Button4.Caption:='Only Chat';
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
 AllSend('$ForceMove '+IP1.Text+'|', False);
end;

procedure TMainForm.N7Click(Sender: TObject);
begin
 Options.Load;
 OptionsForm.ShowModal;
end;

procedure TMainForm.OnMinimize(Sender: TObject);
begin
 Visible:=Not Visible;
 SetForegroundWindow(Application.Handle);
 Application.ProcessMessages;
end;

procedure TMainForm.Timer3Timer(Sender: TObject);
begin
{  Button1Click(nil);
  sleep(1000);
  Button1Click(nil);}
end;

end.
