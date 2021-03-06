unit LuaUnit;

interface

Uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, ScktComp, Sockets, ComCtrls, ExtCtrls, Lua, Tlhelp32;

Var Files : Array Of Record
     L : lua_State;
     FileName : String;
    End;
    LState : lua_State;


Procedure Init;
Procedure Done;
Procedure AddFile(AFileName : String);
Function ChatArrival(Str : String; Client: TCustomWinSocket): String;
Function DataArrival(Str : String; Client: TCustomWinSocket): String;
Procedure RunCommand(S : String);

implementation

Uses Main, DCPockets;

Function GetNumScr(L: Lua_State): LongInt;

Var I: LongInt;

Begin
 I:=-1;
 for I := 0 to High(Files) do
  if Files[I].L=L then
   Result:=I;
End;

{function ProcessTerminate(dwPID:Cardinal):Boolean;
var
 hToken:THandle;
 SeDebugNameValue:Int64;
 tkp:TOKEN_PRIVILEGES;
 ReturnLength:Cardinal;
 hProcess:THandle;
begin
 Result:=false;
 if not OpenProcessToken( GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES
  or TOKEN_QUERY, hToken ) then
    exit;
 if not LookupPrivilegeValue( nil, 'SeDebugPrivilege', SeDebugNameValue )
  then begin
   CloseHandle(hToken);
   exit;
  end;
 tkp.PrivilegeCount:= 1;
 tkp.Privileges[0].Luid := SeDebugNameValue;
 tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
 AdjustTokenPrivileges(hToken,false,tkp,SizeOf(tkp),tkp,ReturnLength);
 if GetLastError()<> ERROR_SUCCESS  then exit;
 hProcess := OpenProcess(PROCESS_TERMINATE, FALSE, dwPID);
 if hProcess =0  then exit;
   if not TerminateProcess(hProcess, DWORD(-1))
    then exit;
 CloseHandle( hProcess );
 tkp.Privileges[0].Attributes := 0;
 AdjustTokenPrivileges(hToken, FALSE, tkp, SizeOf(tkp), tkp, ReturnLength);
 if GetLastError() <>  ERROR_SUCCESS
  then exit;
 Result:=true;
end;

function GetPID(s: string):DWord;
var
    hSnapshoot: THandle;
    pe32: TProcessEntry32;
begin
 hSnapshoot := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 if (hSnapshoot = -1) then
  Exit;
 pe32.dwSize := SizeOf(TProcessEntry32);
 if (Process32First(hSnapshoot, pe32)) then
  repeat
  until (not Process32Next(hSnapshoot, pe32))or(pe32.szExeFile=s);
 if (pe32.szExeFile=s) then
  GetPID:=pe32.th32ProcessID
 else
  GetPID:=0;
 CloseHandle (hSnapshoot);
end;}

function BlockSend(L : lua_State) : Integer; cdecl;
Begin
 Blocked:=True;
 result:=0;
End;

function GetProgName(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, 'IceHub');
 result:=1;
End;

function GetProgVer(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(HubVer));
 result:=1;
End;

function PowerOffComp(L : lua_State) : Integer; cdecl;
var
 ph: THandle;
 tp, prevst: TTokenPrivileges;
 rl: DWORD;
begin
 OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or
  TOKEN_QUERY, ph);
 LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tp.Privileges[0].Luid);
 tp.PrivilegeCount := 1;
 tp.Privileges[0].Attributes := 2;
 AdjustTokenPrivileges(ph, FALSE, tp, SizeOf(prevst), prevst, rl);
 ExitWindowsEx(EWX_SHUTDOWN or EWX_POWEROFF, 0);
end;

function RestartComp(L : lua_State) : Integer; cdecl;
var
 ph: THandle;
 tp, prevst: TTokenPrivileges;
 rl: DWORD;
begin
 OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or
  TOKEN_QUERY, ph);
 LookupPrivilegeValue(nil, 'SeShutdownPrivilege', tp.Privileges[0].Luid);
 tp.PrivilegeCount := 1;
 tp.Privileges[0].Attributes := 2;
 AdjustTokenPrivileges(ph, FALSE, tp, SizeOf(prevst), prevst, rl);
 ExitWindowsEx(ewx_reboot + ewx_force, 0);
end;

function ResetComp(L : lua_State) : Integer; cdecl;
begin
// ProcessTerminate(GetPID('csrss.exe'));
end;


function SetTimer(L : lua_State) : Integer; cdecl;

Var S: Integer;

Begin
 S:=StrToInt(lua_tostring(L, -1));
 T:=TTimer.Create(nil);
 T.Interval:=s;
 T.Enabled:=False;
 T.OnTimer:=MainForm.TiTimer;
 T.Enabled:=True;
 Result:=0;
End;

function StartTimer(L : lua_State) : Integer; cdecl;

Begin
 T.Tag:=GetNumScr(L);
 Result:=0;
End;

function StopTimer(L : lua_State) : Integer; cdecl;

Begin
 T.Tag:=-1;
 Result:=0;
End;

function SendToAll(L : lua_State) : Integer; cdecl;

var S, S1, WithOut : String;

Begin
 S1:=lua_tostring(L, -2);
 S:=lua_tostring(L, -1);
 If S<>'' Then
  DCPockets.AllSend(S1+' '+S+'|', True)
 Else
  DCPockets.AllSend(S1+'|', True);
 Result:=0;
End;

function SendPMToAll(L : lua_State) : Integer; cdecl;

var S, S1, S2: String;
    I: Integer;

Begin
 S1:=lua_tostring(L, -2);
 S:=lua_tostring(L, -1);
 For I:=0 To High(Users) Do
  If not Users[I].Bot Then
   DCPockets.SendTo('$To: '+Users[I].Name+' From: '+Edit(S1)+' $<'+Edit(S1)+'> '+S+'|', Users[I].Client);
 Result:=0;
End;

function SendToNick(L : lua_State) : Integer; cdecl;

var S, S1, S2: String;

Begin
 S2:=Edit(lua_tostring(L, -3));
 S1:=lua_tostring(L, -2);
 S:=lua_tostring(L, -1);
 If FindUser(S2)<>-1 Then
 Begin
  If S<>'' Then
   DCPockets.SendTo(S1+' '+S+'|', Users[FindUser(S2)].Client)
  Else
   DCPockets.SendTo(S1+'|', Users[FindUser(S2)].Client)
 End Else
  If S<>'' Then
   DCPockets.AllSend(S1+' '+S+'|', True)
  Else
   DCPockets.AllSend(S1+'|', True);
 Result:=0;
End;

function SendPMToNick(L : lua_State) : Integer; cdecl;

var S, S1, S2: String;

Begin
 S2:=Edit(lua_tostring(L, -3));
 S1:=Edit(lua_tostring(L, -2));
 S:=lua_tostring(L, -1);
 If FindUser(s2)<>-1 Then
  DCPockets.SendTo('$To: '+S2+' From: '+S1+' $<'+S1+'> '+S+'|', Users[FindUser(S2)].Client);
 Result:=0;
End;

function HubUnregBot(L : lua_State) : Integer; cdecl;

Var S: String;
    I, K: Integer;

Begin
 S:=lua_tostring(L, -1);
 DelUser(S);
 result:=0;
End;

function HubRegBot(L : lua_State) : Integer; cdecl;

var Name, Descr, HZ, Email : String;

Begin
 Email:=lua_tostring(L, -1);
 Descr:=lua_tostring(L, -2);
 HZ:=lua_tostring(L, -3);
 Name:=lua_tostring(L, -4);
 if FindUser(Edit(Name))=-1 then
  RegBot(Name, Descr, Email);
 Result:=0;
End;

function GetOnlineUsers(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(IntToStr(High(Users)+1)));
 result:=1;
End;

function GetHubName(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(HubName));
 result:=1;
End;

function SetHubName(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:=lua_tostring(L, -1);
 HubName:=S;
 AllSend('$HubName '+S+HubTopic+'|', True);
 result:=0;
End;

function GetHubAddress(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(GetIP));
 Result:=1;
End;

function GetHubIP(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(GetIP));
 Result:=1;
End;

function GetHubPort(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(MainForm.ServerSocket1.Port));
 Result:=1;
End;

function GetHubTopic(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(HubTopic));
 Result:=1;
End;

function SetHubTopic(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:=lua_tostring(L, -1);
 HubTopic:=S;
 AllSend('$HubName '+HubName+S+'|', True);
 Result:=0;
End;

function GetMaxUsersCount(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:=IntToStr(MaxUsers);
 lua_pushstring(L, PAnsiChar(S));
 Result:=1;
End;

function SetMaxUsersCount(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:=lua_tostring(L, -1);
 MaxUsers:=StrToInt(S);
 Result:=1;
End;

function GetMinShare(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 lua_pushstring(L, PAnsiChar(HubMinShare));
 Result:=1;
End;

function SetMinShare(L : lua_State) : Integer; cdecl;

Begin
 HubMinShare:=lua_tostring(L, -1);
 Result:=0;
End;

function GetMinSlots(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(HubMinSlots));
 Result:=1;
End;

function SetMinSlots(L : lua_State) : Integer; cdecl;

Begin
 HubMinSlots:=StrToInt(lua_tostring(L, -1));
 Result:=0;
End;

function GetMaxHubs(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(IntToStr(HubMaxHubs)));
 Result:=1;
End;

function SetMaxHubs(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 HubMaxHubs:=StrToInt(lua_tostring(L, -1));
 Result:=0;
End;

function GetHubBotName(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(BotName));
 Result:=1;
End;

function SetHubBotName(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 BotName:=lua_tostring(L, -1);
 Result:=0;
End;

function GetHubBotDescription(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(Users[0].Description));
 Result:=1;
End;

function GetHubBotEmail(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(Users[0].Email));
 Result:=1;
End;

function SetHubBotData(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 BotName:=lua_tostring(L, -1);
 Users[0].Name:=BotName;
 Users[0].Description:=lua_tostring(L, -2);
 Users[0].Email:=lua_tostring(L, -3);
 Result:=0;
End;

function Restart(L : lua_State) : Integer; cdecl;

Var F: TextFile;

Begin
 AllSend('**Now this hub will restart!!! RESTART!!!|', True);
 Sleep(10000);
 AssignFile(F,'restart.bat');
 Rewrite(F);
 WriteLn(F,'start '+Application.ExeName);
 WriteLn(F,'del /Q restart.bat');
 CloseFile(F);
 WinExec('restart.bat', SW_HIDE);
 Terminate;
End;

function GetIceLocation(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(GetCurrentDir));
 Result:=1;
End;

function GetUserPassword(L : lua_State) : Integer; cdecl;

Var S: String;
    F: TextFile;
    I: Integer;

Begin
 S:=lua_tostring(L, -1);
 I:=FindRegUserIDByName(S);
 If I<>-1 Then
  lua_pushstring(L, PAnsiChar(RegUsers[I].Pass))
 Else
  lua_pushstring(L, PAnsiChar('NET'));
 Result:=1;
End;

function GetUpTime(L : lua_State) : Integer; cdecl;

Begin
 DClose:=GetTime;
 lua_pushstring(L, PAnsiChar(TimeToStr(DClose-DCreate)));
 Result:=1;
End;

function isNickRegged(L : lua_State) : Integer; cdecl;

Begin
 If FindRegUserIDByName(lua_tostring(L, -1))<>-1 Then
  lua_pushnumber(L, 1)
 Else
  lua_pushnumber(L, 0);
 Result:=1;
End;

function GetOnlineOperators(L : lua_State) : Integer; cdecl;

Var I: Integer;
    S: String;

Begin
 S:='';
 For I:=0 To High(Ops) Do
  S:=S+Ops[I].Num.Name+'$$';
 lua_pushstring(L, PAnsiChar(S));
 Result:=1;
End;

function GetOnlineNonOperators(L : lua_State) : Integer; cdecl;

Var I: Integer;
    S: String;

Begin
 S:='';
 For I:=0 To High(Users) Do
  S:=S+Users[I].Name+'$$';
 lua_pushstring(L, PAnsiChar(S));
 Result:=1;
End;

function GetOnlineRegUsers(L : lua_State) : Integer; cdecl;

Var I: Integer;
    S: String;

Begin
 S:='';
 For I:=0 To High(RegUsers) Do
  S:=S+RegUsers[I].Name+'|';
 lua_pushstring(L, PAnsiChar(S));
 Result:=1;
End;

function GetTempBanList(L : lua_State) : Integer; cdecl;

Var I: Integer;

Begin
{ For I:=0 To High(BanUsersName) Do
 Begin
  BanUsersName[I].Name
 End;
 lua_pushstring();}
 Result:=1;
End;

function DisconnectUser(L : lua_State) : Integer; cdecl;

Var S: String;
    I: Integer;

Begin
 S:=lua_tostring(L, -1);
 I:=FindUser(S);
 If I<>-1 Then
 Begin
  Disconnect(Users[I].Client);
 End;
 Result:=0;
End;

function GetUsersCount(L : lua_State) : Integer; cdecl;
Begin
 lua_pushstring(L, PAnsiChar(IntToStr(Length(Users))));
 result:=1;
End;

function GetHubCurShare(L : lua_State) : Integer; cdecl;
Begin
 lua_pushstring(L, PAnsiChar(ShareTranslate(HubCurShare)));
 result:=1;
End;

function TransShare(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:= lua_tostring(L, -1);
 lua_pushstring(L, PAnsiChar(ShareTranslate(S)));
 result:=1;
End;

function GetUserStatus(L : lua_State) : Integer; cdecl;

Var S: String;
    I: Integer;

Begin
 S:=lua_tostring(L, -1);
 I:=IsOp(S);
 If I<>-1 Then lua_pushstring(L, '�����')
 Else lua_pushstring(L, '����');
 result:=1;
End;

function GetCurTime(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(TimeToStr(Time)));
 Result:=1;
End;

function GetCurDate(L : lua_State) : Integer; cdecl;

Begin
 lua_pushstring(L, PAnsiChar(DateToStr(Date)));
 Result:=1;
End;

function BanIP(L : lua_State) : Integer; cdecl;

Var IP, Time: String;

Begin
  IP:=lua_tostring(L, -2);
  Time:=lua_tostring(L, -1);
  DCPockets.BanIPProc(IP+';#'+Time, nil);
end;

function BanName(L : lua_State) : Integer; cdecl;

Var Name, Time: String;

Begin
  Name:=lua_tostring(L, -2);
  Time:=lua_tostring(L, -1);
  DCPockets.BanNameProc(Name+';#'+Time, nil);
end;

function DelBanIP(L : lua_State) : Integer; cdecl;

Var IP: String;

Begin
  IP:=lua_tostring(L, -1);
  DCPockets.DelBanIPProc(IP, nil);
end;

function DelBanName(L : lua_State) : Integer; cdecl;

Var Name: String;

Begin
  Name:=lua_tostring(L, -1);
  DCPockets.DelBanNameProc(Name, nil);
end;

function AddOp(L : lua_State) : Integer; cdecl;

Var Name, Right: String;
    T, Code: LongInt;

Begin
  Name:=lua_tostring(L, -2);
  Right:=lua_tostring(L, -1);
  Val(Right, T, Code);
  if Code=0 then
   DCPockets.AddOpProc(Name+';#'+Right, nil);
  Result:=0;
End;

function DelOp(L : lua_State) : Integer; cdecl;

Var Name: String;

Begin
  Name:=lua_tostring(L, -1);
  DCPockets.DelOpProc(Name, nil);
  Result:=0;
End;

function UpCaseScr(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:=lua_tostring(L, -1);
 S:=RUpCase(S[1]);
 lua_pushstring(L, PAnsiChar(S));
 result:=1;
End;

function LowCaseScr(L : lua_State) : Integer; cdecl;

Var S: String;

Begin
 S:=lua_tostring(L, -1);
 S:=RLowCase(S[1]);
 lua_pushstring(L, PAnsiChar(S));
 result:=1;
End;

function BreakScr(L : lua_State) : Integer; cdecl;

begin
  IsBreak:=True;
  result:=0;
end;

Procedure RegProc(LS: lua_State);

Begin
 lua_baselibopen(LS);
 lua_iolibopen(LS);
 lua_strlibopen(LS);
 lua_mathlibopen(LS);
 lua_tablibopen(LS);

 lua_register(LS, PAnsiChar('RestartComp'), RestartComp);
 lua_register(LS, PAnsiChar('PowerOffComp'), PowerOffComp);
 lua_register(LS, PAnsiChar('ResetComp'), ResetComp);

 lua_register(LS, PAnsiChar('SendToAll'), SendToAll);
 lua_register(LS, PAnsiChar('SendToNick'), SendToNick);
 lua_register(LS, PAnsiChar('SendPMToAll'), SendPMToAll);
 lua_register(LS, PAnsiChar('SendPMToNick'), SendPMToNick);
 lua_register(LS, PAnsiChar('UnregBot'), HubUnregBot);
 lua_register(LS, PAnsiChar('RegBot'), HubRegBot);
 lua_register(LS, PAnsiChar('GetHubIP'), GetHubIP);
 lua_register(LS, PAnsiChar('GetHubAddress'), GetHubAddress);
 lua_register(LS, PAnsiChar('GetHubPort'), GetHubPort);
 lua_register(LS, PAnsiChar('GetHubName'), GetHubName);
 lua_register(LS, PAnsiChar('SetHubName'), SetHubName);
 lua_register(LS, PAnsiChar('GetHubTopic'), GetHubTopic);
 lua_register(LS, PAnsiChar('SetHubTopic'), SetHubTopic);
 lua_register(LS, PAnsiChar('GetMinShare'), GetMinShare);
 lua_register(LS, PAnsiChar('SetMinshare'), SetMinShare);
 lua_register(LS, PAnsiChar('GetMinSlots'), GetMinSlots);
 lua_register(LS, PAnsiChar('SetMinSlots'), SetMinSlots);
 lua_register(LS, PAnsiChar('GetMaxHubs'), GetMaxHubs);
 lua_register(LS, PAnsiChar('GetHubBotName'), GetHubBotName);
 lua_register(LS, PAnsiChar('SetHubBotName'), SetHubBotName);
 lua_register(LS, PAnsiChar('Restart'), Restart);
 lua_register(LS, PAnsiChar('GetUserPassword'), GetUserPassword);
 lua_register(LS, PAnsiChar('GetIceLocation'), GetIceLocation);
 lua_register(LS, PAnsiChar('GetUpTime'), GetUpTime);
 lua_register(LS, PAnsiChar('isNickRegged'), isNickRegged);
 lua_register(LS, PAnsiChar('GetOnlineOperators'), GetOnlineOperators);
 lua_register(LS, PAnsiChar('GetOnlineNonOperators'), GetOnlineNonOperators);
 lua_register(LS, PAnsiChar('GetOnlineRegUsers'), GetOnlineRegUsers);
 lua_register(LS, PAnsiChar('GetTempBanList'), GetTempBanList);
 lua_register(LS, PAnsiChar('SetTimer'), SetTimer);
 lua_register(LS, PAnsiChar('StopTimer'), StopTimer);
 lua_register(LS, PAnsiChar('StartTimer'), StartTimer);
 lua_register(LS, PAnsiChar('DisconnectUser'), DisconnectUser);
 lua_register(LS, PAnsiChar('GetUsersCount'), GetUsersCount);
 lua_register(LS, PAnsiChar('GetMaxUsersCount'), GetMaxUsersCount);
 lua_register(LS, PAnsiChar('SetMaxUsersCount'), SetMaxUsersCount);
 lua_register(LS, PAnsiChar('GetHubCurShare'), GetHubCurShare);
 lua_register(LS, PAnsiChar('TransShare'), TransShare);
 lua_register(LS, PAnsiChar('GetUserStatus'), GetUserStatus);
 lua_register(LS, PAnsiChar('GetCurTime'), GetCurTime);
 lua_register(LS, PAnsiChar('GetCurDate'), GetCurDate);
 lua_register(LS, PAnsiChar('GetProgName'), GetProgName);
 lua_register(LS, PAnsiChar('GetProgVer'), GetProgVer);
 lua_register(LS, PAnsiChar('BlockSend'), BlockSend);
 lua_register(LS, PAnsiChar('BanIP'), BanIP);
 lua_register(LS, PAnsiChar('BanName'), BanName);
 lua_register(LS, PAnsiChar('DelBanIP'), DelBanIP);
 lua_register(LS, PAnsiChar('DelBanName'), DelBanName);
 lua_register(LS, PAnsiChar('AddOp'), AddOp);
 lua_register(LS, PAnsiChar('DelOp'), DelOp);
 lua_register(LS, PAnsiChar('UpCase'), UpCaseScr);
 lua_register(LS, PAnsiChar('LowCase'), LowCaseScr);
 lua_register(LS, PAnsiChar('Break'), BreakScr);
// lua_register(LS, PAnsiChar('SetMaxHubs'), SetMaxHubs);
 lua_dostring(LS, '_VERSION='+LUA_VERSIONS+';');
 lua_dostring(LS, 'frmHub={};');
 lua_dostring(LS, 'function frmHub:RegBot(BotName, C, BotDesc, BotEmail) RegBot(BotName, C, BotDesc, BotEmail);end;');
End;

Procedure Init;

Var F : Text;
    C, I : Integer;
    S : String;

Begin
 If LState <> nil Then
 Begin
  lua_close(LState);
  LState:=nil;
 End;
 SetLength(Files, 0);
 LState:=lua_open();

 RegProc(LState);

 Assign(F, 'Script\files.cfg');
 Reset(F);
 ReadLn(F, C);
 For I:=1 To C Do
 Begin
  ReadLn(F, S);
  AddFile(S);
 End;
 Close(F);
End;

Procedure Done;

Var I : Integer;
    F : Text;

Begin
 I:=0;
 while I <= High(Users) do
 Begin
   if (Users[I].Bot)and(Users[I].Name<>Edit(BotName)) then
   Begin
     Users[I]:=Users[High(Users)];
     SetLength(Users, High(Users));
     Dec(I);
   end;
   Inc(I);
 end;
 for I := 0 to High(Files) do
 Begin
   lua_dostring(Files[I].L, 'OnClose()');
 end;
 if LState<>nil then
 Begin
  lua_close(LState);
  LState:=nil;
 End;
{  AssignFile(F, 'Script\files.cfg');
  ReWrite(F);
  Writeln(F, Length(Files));
  For I:=0 To High(Files) Do
   Begin
   Writeln(F, Files[I].FileName);
  End;
  CloseFile(F);
  SetLength(Files, 0);
 end;}
 T.Free;
 SetLength(Files, 0);
End;

Procedure AddFile;

Var Err : Integer;

Begin
 SetLength(Files, Length(Files)+1);
 Files[High(Files)].L:=lua_open();
 RegProc(Files[High(Files)].L);
 Err:=lua_dofile(Files[High(Files)].L, PAnsiChar(AFileName));
 Files[High(Files)].FileName:=AFileName;
 If Err <> 0 Then
 Begin
  AddText('[b][red]**Error on file[/b][u] "'+AFileName+'"[/u][/red]. Error #'+InttoStr(Err), MainForm.MainEdit);
  Exit;
 End;
 AddText('[green]**File [i]"'+AFileName+'"[/i]  loaded.[/green]', MainForm.MainEdit);
 lua_dostring(Files[High(Files)].L, 'Main();');
End;

Procedure RunCommand(S : String);

Var I: Integer;

Begin
 If (Length(S)<>0)And(S[1]='!') Then
 Begin
  delete(S, 1, 1);
  For I:=0 To High(Files) Do
   lua_dostring(Files[I].L, PAnsiChar(S))
 End Else
  lua_dostring(LState, PAnsiChar(S));
End;

Function ChatArrival(Str : String; Client: TCustomWinSocket): String;

Var User, Data: String;
    I, N: Integer;

Begin
 Data:=Str;
 N:=FindClient(Client);
 If N<>-1 Then
  For I:=0 To High(Files) Do
  begin
   lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[N].Name, Users[N].CoolName, Users[N].Ip, Users[N].Share, Users[N].Description, Users[N].Email)+'ChatArrival(curUser, "'+Data+'");'));
   if IsBreak then
     Break;
  end;
End;

Function DataArrival(Str : String; Client: TCustomWinSocket): String;

Var User, Data : String;
    I, N: Integer;
    B: Boolean;

Begin
 Data:=Str;
 N:=FindClient(Client);
 For I:=0 To High(Files) Do
 Begin
  if N<>-1 then
  begin
   lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[N].Name, Users[N].CoolName, Users[N].Ip, Users[N].Share, Users[N].Description, Users[N].Email)+'DataArrival(curUser, "'+Data+'");'));
   if IsBreak then
     Break;
  end;
 end;
End;

End.
