unit DCPockets;

interface

Uses
  Windows, SysUtils, ScktComp, IniFiles, LuaUnit, Lua, About, Long, WinSock, Classes;

Type TUser = record
      CoolName, Name, Ip : String;
      DCVersion : String;
      Description, Speed, Email, Share : String;
      CountSlots, CountHubs: LongInt;
      Client : TCustomWinSocket;
      Enter: Byte;
      Show: Boolean;
      Bot: Boolean;
      AntiSpam: Boolean;
      MyINFOString: String;
//      AntiUsers: Array Of TUser;
      Mute, Lunar: Boolean;
     End;

     TLastMessage = Record
      LastMessage: String;
      LMTime: TDateTime;
     End;

     TLMessage = Record
      IP: String;
      LastMess: Array [1..10] of TLastMessage;
     End;

     TMessOffIP = Record
      IP, From, Text: String;
     End;

     TMessOffName = Record
      Name, From, Text: String;
     End;

     TCoolUser = Record
      Name, CoolName: String;
     End;

     TRegUser = Record
      Name: String;
      Pass: String;
     End;

     TBanUserIP = Record
      IP: String;
      Date: TDateTime;
      Time: TDateTime;
     End;

     TBanUserName = Record
      Name: String;
      Date: TDateTime;
      Time: TDateTime;
     End;

     TOp = Record
      Num: TUser;
      Rights: Integer;
     End;

     TOpsList = Record
      Name: String;
      Rights: Integer;
     End;

     TCommand = array of record
      Name: String;
      Proc: Procedure(Params : String; Client : TCustomWinSocket);
      Right: Integer;
     End;

     TLastExit = record
      IP: String;
      T: TDateTime;
     End;

     TKickedUser = record
      IP, Name: String;
     End;

// Hub private

Const
    OneSec = 0.000011574074074;
    Rus: Array [1..32, 1..2] of Char = (('а', 'А'),('б', 'Б'),('в', 'В'),('г', 'Г'),('д', 'Д'),('е', 'Е'),('ё', 'Ё'),('ж', 'Ж'),('з', 'З'),('и', 'И'),('к', 'К'),('л', 'Л'),('м', 'М'),('н', 'Н'),('о', 'О'),('п', 'П'),('р', 'Р'),
    ('с', 'С'),('т', 'Т'),('у', 'У'),('ф', 'Ф'),('х', 'Х'),('ц', 'Ц'),('ч', 'Ч'),('ш', 'Ш'),('щ', 'Щ'),('ь', 'Ь'),('ъ', 'Ъ'),('ы', 'Ы'),('э', 'Э'),('ю', 'Ю'),('я', 'Я'));
    HubVer: String = ' v 7.12.4 Release';
    SharePrefix: array [1..11] of string = ('Б', 'КБ', 'МБ', 'ГБ', 'ТБ', 'ПБ', 'ЕБ', 'дахуяБ', 'больше чем дахуЯБ', 'Больше чем больше дохуяБ, так шо пнХ', 'ПШОЛ вОн');
    ReklamBot : String = '<Reklama>';
    HubPasswd : String = 'EXTENDEDPROTOCOL::This_hub_was_written_by_Frol::CTRL[ЙЬ.ж] Pk=IceHub';
    ScriptText: String = 'PPASC';
    GetPassText: String = 'PPAS';
{    ResetCommand: String = '-RESET';
    CloseCommand: String = '-EXIT';}

Var Users : Array Of TUser;
    Messages : Array of TLMessage;
    OfflineMessIP: Array of TMessOffIP;
    OfflineMessName: Array of TMessOffName;
    KickedUsers: Array Of TKickedUser;
    CoolUsers: Array Of TCoolUser;
    RegUsers: Array Of TRegUser;
    BanUsersIP: Array Of TBanUserIP;
    BanUsersName: Array Of TBanUserName;
    Ops: Array Of TOp;
    OpsList: Array Of TOpsList;
    LastMessages: array Of String;
    OfflineMessages: array Of String;
    LastExit: array Of TLastExit;
    AllSend : Procedure(S : String; Script: Boolean);
    SendTo : function(S : String; Client : TCustomWinSocket): Boolean;
    Disconnect : Procedure(Client : TCustomWinSocket);
    Terminate : Procedure;
    Commands: TCommand;
    IniFile : TIniFile;
    Nick : String;
    BotClient : TClientSocket;

// Hub public
    HubStartMessage: String;
    HubName : String = 'Name - ';
    HubTopic: String = 'Topic';
    HubMinShare: String = '0';
    HubMinSlots: Integer = 2;
    HubMaxHubs: Integer = 10;
    HubPort: Array Of LongInt;
    BotName : String = ' :-D';
    UserStartMessage : String = '';
    EnterNewUser : String = ' УРА у нас пополнение и Ник этого пополнения - ';
    ExitUser: String = ' Нас покинул пользователь ';
    HubWorkTime : String = '}{aБ работает уже';
    HubMaxPeople : String = 'МаХ людей зафиксено';
    CantKick1: String = ' пользователь "';
    CantKick2: String = '" попытался кикнуть пользователя "';
    CantKick3: String = '", но у него не достаточно прав =)';
    DefUser1: String = ' Этот юзер (';
    DefUser2: String = ') защищён самим Frol''ом';
    Kick1: String = ' пользователь "';
    Kick2: String = '" кикнут.';
    RegUserText: String = ' Вы зарегистрировали пользователя ';
    DelRegUserText: String = ' Вы удалили зарегистрированного пользователя ';
    NoDelRegUserText: String = ' Такого зарегистрированого пользователя нет ';
    AddOp1Text: String = ' Вы создали ОПа ';
    AddOp2Text: String = ' с доступом = ';
    DelOpText: String = ' Вы удалили ОПа ';
    NoDelOpText: String = ' Такго ОПа нет ';
    BanIPText: String = ' Вы забанили ИП = ';
    BanNameText: String = ' Вы забанили Ник = ';
    DelBanIPText: String = ' Вы разбанили ИП = ';
    NoDelBanIPText: String = ' Такого забаненного ИП нет = ';
    DelBanNameText: String = ' Вы раззабанили Ник = ';
    NoDelBanNameText: String = ' Такого забаненного Ника нет = ';
    YouBanByNameText: String = ' Вы забанены по Нику до ';
    YouBanByIPText: String = ' Вы забанены по ИП до ';
    NoRight: String = ' У вас недостаточно прав!!!';
    BannedByIPText: String = ' Список забаненных пользователей по ИП:';
    NoBannedByIPText: String = ' Нет забаненных пользователей по ИП';
    BannedByNameText: String = ' Список забаненных пользователей по Нику:';
    NoBannedByNameText: String = ' Нет забаненных пользователей по Нику:';
    BadName: String = ' Такой Ник уже используется';
    BadPass: String = ' Вы ввели неправильный пароль';
    LastMessagesText1: String = '----------------Последние ( ';
    LastMessagesText2: String = ' ) сообщений чата:';
    Breaker: String = '---------------------------------------------------------------------------------------';
    ReciveNewMsg: String = ' Вы получили новое сообщение в оффлайн';
    MsgOffNameText: String = 'Вы оставили сообщение в оффлайн нику: ';
    MsgOffIPText: String = ' Вы оставили сообщение в оффлайн ИПшнику: ';
    YourInfo: String = ' Ваше инфо:';
    YourName: String = ' Ваш Ник: ';
    YourRights: String = ' Ваши права: ';
    YourIP: String = ' Ваш ИП: ';
    MaxUsers : Integer = 0;
    CountLastMessages: Integer = 0;
    HubCurShare: String = '0';
    BLunarize: Boolean = false; 

Function IsBuf(Client: TCustomWinSocket): LongInt;
Procedure LoadIniFile(Name : String);
Procedure SaveIniFile(Name : String);
Procedure LoadBanIP;
Procedure LoadBanName;
Procedure SetHubCommands;
Procedure LoadOpList;
Procedure LoadRegUserList;
Procedure LoadCoolName;
Function GetInfo(S : String) : String;
Function SetInfo(S : String; User: TUser) : String;
Procedure OnConnect(Client: TCustomWinSocket);
Procedure OnDisconnect(Client : TCustomWinSocket);
Function FindUser(S : String) : Integer;
Function FindClient(Client: TCustomWinSocket): Integer;
Function NewUser(S, Ip : String; Client : TCustomWinSocket) : String;
Function GetString(var Command : String; Client : TCustomWinSocket) : String;
Function GetNickList : String;
Function GetUserIP(Client: TCustomWinSocket) : String;
Procedure RegBot(Name, Description, Email : String);
Function Edit(Name : String) : String;
Function IsOpOn(S : String) : Integer;
Function FindRegUserIDByName(Name: String): Integer;
Function CreateUserString(Name, CoolName, IP, Share, Descr, Email: String): String;
Procedure DelUser(S: String);
Procedure AllSendWithOut(S, Nick: String);
Function ShareTranslate(Share: String): String;
Function IsOP(S: String): Integer;
Function GetIP: String;
Function FindInCoolName(S: String): Integer;
Function FindInName(S: String): Integer;
Procedure DelOpProc(Params : String; Client : TCustomWinSocket);
Procedure AddOpProc(Params : String; Client : TCustomWinSocket);
Procedure BanIPProc(Params : String; Client : TCustomWinSocket);
Procedure BanNameProc(Params : String; Client : TCustomWinSocket);
Procedure DelBanIPProc(Params : String; Client : TCustomWinSocket);
Procedure DelBanNameProc(Params : String; Client : TCustomWinSocket);
Function RUpCase(Ch: Char): Char;
Function RLowCase(Ch: Char): Char;

implementation

uses Main, SyntaxU;

Function RUpCase(Ch: Char): Char;

var
  I: Integer;

Begin
 Result:=UpCase(Ch);
 if Ch=Result then
  for I := 1 to High(Rus) do
   if Ch=Rus[I, 1] then
   Begin
    Result:=Rus[I, 2];
    Break;
   end;
end;

Function RLowCase(Ch: Char): Char;

var
  I: Integer;
  T: String;

Begin
 T:=LowerCase(Ch);
 Result:=T[1];
 if Ch=Result then
  for I := 1 to High(Rus) do
   if Ch=Rus[I, 2] then
   Begin
    Result:=Rus[I, 1];
    Break;
   end;
end;

Function Lunarize(S: String): String;

Var I: LongInt;
    T: String;

Begin
 I:=1;
 if pos('>', S)>0 then
  I:=pos('>', S)+1;
 while I<=Length(S) do
 Begin
  if I mod 2=0 then
   S[I]:=RUpCase(S[I])
  Else
   S[I]:=RLowCase(S[I]);
  Inc(I);
 end;
 Lunarize:=S;
end;

Function IsBuf(Client: TCustomWinSocket): LongInt;

var
  I: Integer;

Begin
 IsBuf:=-1;
 for I := 0 to High(Buffers) do
 Begin
   if (Buffers[I].Client=Client) then
   Begin
    IsBuf:=I;
    Break;
   end;
 end;
end;

Function FindInMess(IP: String): LongInt;

Var I: Integer;

Begin
 Result:=-1;
 For I:=0 To High(Messages) Do
  If Messages[I].IP=IP Then
  Begin
   Result:=I;
   Exit;
  End;
//
End;

Function DelayClient(Client: TCustomWinSocket): Boolean;

Var I: Integer;
    T: Extended;

Begin
 I:=0;
 Result:=False;
 while I<=High(LastExit) Do
 Begin
  T:=Time-LastExit[I].T;
  If (LastExit[I].IP=Client.RemoteAddress) Then
  Begin
   If T<=2*OneSec Then
   Begin
    Disconnect(Client);
    Result:=True;
   end;
  End;
  If (T>2*OneSec) Then
  Begin
   LastExit[I]:=LastExit[High(LastExit)];
   SetLength(LastExit, High(LastExit));
   Dec(I);
  End;
  Inc(I);
 End;
End;

function GetIP: String;

const WSVer = $101;

var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;

begin
  Result := '127.0.0.1';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

Function ChangeLich(S, From, Dest: String; Client: TCustomWinSocket): String;

Var T, bef: String;

Begin
 Bef:='$To: '+Dest+' From: '+From+' $';
 delete(S, 1, pos('<', S));
 T:=copy(S, 1, pos('>', S)-1);
 If FindUser(From)<>-1 Then
 Begin
  If (T=From)or(T=Users[FindUser(From)].CoolName)or(T=Users[FindUser(From)].Name) Then
   Result:=Bef+'<'+From+'>'+copy(S, pos('>', S)+1, length(S))+'|'
  else
  Begin
   SetLength(BanUsersIP, High(BanUsersIP)+2);
   BanUsersIP[High(BanUSersIP)].IP:=Client.RemoteAddress;
   BanUsersIP[High(BanUSersIP)].Time:=Time+600*OneSec;
   If BanUsersIP[High(BanUSersIP)].Time>1 Then
   Begin
    BanUsersIP[High(BanUSersIP)].Date:=Date+Trunc(BanUsersIP[High(BanUSersIP)].Time);
    BanUsersIP[High(BanUSersIP)].Time:=BanUsersIP[High(BanUSersIP)].Time-Trunc(BanUsersIP[High(BanUSersIP)].Time);
   End Else
    BanUsersIP[High(BanUSersIP)].Date:=Date;
   Disconnect(Client)
  End;
 End;
End;

Function Edit(Name : String) : String;

Var S: String;

Begin
 S:=Name;
 If S = '' Then Begin Edit:=''; Exit; End;
 If S[1]='<' Then
  Delete(S, 1, 1);
 If S[Length(S)]='>' Then
  Delete(S, Length(S), 1);
 Edit:=S;
End;

Function ShareTranslate(Share: String): String;

Var S, S1: String;
    I: Integer;

Begin
 I:=1;
 If Length(Share)<>0 Then
 Begin
  While (Share[1] = '0') and (Length(Share) > 1) Do
   Delete(Share, 1, 1);
  If sravn(Share,'1024') <> 2 Then
  begin
   Repeat
    Inc(I);
    DivLong(Share, '1024', S);
    If sravn(S,'1024') = 2 Then
     Break
    Else
     Share:=S;
   Until (I>10);
  end
  else
   S:=Share;
  ModLong(Share, '1024', S1);
  if (S1 <> '0') and (S1 <> '00') Then
  Begin
   While (S1[1] = '0') and (Length(S1) > 3) Do
    Delete(S1, 1, 1);
   If I=11 Then
    ShareTranslate:=SharePrefix[11]
   Else
    ShareTranslate:=S+','+s1[1]+s1[2]+' '+SharePrefix[I];
  End
  Else
   If I=11 Then
    ShareTranslate:=SharePrefix[11]
   Else
    ShareTranslate:=S+' '+SharePrefix[I];
 End Else
 Begin
  ShareTranslate:='0 '+SharePrefix[1];
 End;
End;

Function CreateUserString(Name, CoolName, IP, Share, Descr, Email: String): String;

Begin
 CreateUserString:='curUser={}; curUser.sCoolName = "'+Name+'"; curUser.sName = "'+CoolName+'"; curUser.sIP = "'+IP+'"; curUser.iShareSize = "'+Share+'"; curUser.sDescription = "'+Descr+'"; curUser.sEmail = "'+EMail+'";'+
 'function curUser:SendData(Data) SendToNick(curUser.sName, Data, ""); end;'+
 'function curUser:SendPM(Data) SendPMToAll(Data, ""); end;'+
 'function curUser:Disconnect() DisconnectUser(curUser.sName); end;'+
 'function curUser:Kick(KickerNick, Reason) SendPMToNick(curUser.sName, KickerNick, " "..Reason); DisconnectUser(curUser.sName); end;'+
 'function curUser:Ban(sReason, sBy) SendPMToNick(curUser.sName, sBy, " "..Reason); BanByIP(curUser.sIP); DisconnectUser(curUser.sName); end;'+
 'function curUser:BanName(sReason, sBy) SendPMToNick(curUser.sName, sBy, " "..Reason); BanByNick(curUser.sName); DisconnectUser(curUser.sName); end;';
End;

Procedure AllSendWithOut(S, Nick: String);

Var I: Integer;

Begin
 For I:=0 To High(Users) Do
 begin
  if I>High(Users) then
   break;
  If (not Users[I].Bot)And(I<=High(Users))And(Users[I].Name<>Nick) Then
   SendTo(S, Users[I].Client);
 end;
End;

Procedure LoadMenu(Name: String; Client: TCustomWinSocket);

Var F: TextFile;
    T: String;

Begin
 If FileExists(Name) Then
 Begin
  AssignFile(F, Name);
  Reset(F);
  While Not EOF(F) Do
  Begin
   ReadLn(F, T);
   SendTo(T, Client);
  End;
  CloseFile(F);
 End Else
 Begin
  AssignFile(F, Name);
  ReWrite(F);
  CloseFile(F);
 End;
End;

Procedure LoadCoolName;

Var F: Text;
    T: String;

Begin
 SetLength(CoolUsers, 0);
 If FileExists('Settings\CoolNames.txt') Then
 Begin
  AssignFile(F, 'Settings\CoolNames.txt');
  Reset(F);
  While Not EOF(F) Do
  Begin
   ReadLn(F, T);
   If Pos(';#', T)<>0 Then
   Begin
    SetLength(CoolUsers, Length(CoolUsers)+1);
    CoolUsers[High(CoolUsers)].Name:=Copy(T, 1, pos(';#', T)-1);
    CoolUsers[High(CoolUsers)].CoolName:=Copy(T, pos(';#', T)+2, Length(T));
   End;
  End;
  CloseFile(F);
 End Else
 Begin
  FileCreate('Settings\CoolNames.txt');
 End;
End;

Procedure DelUser(S: String);

Var I, K, UserID: Integer;

Begin
 UserID:=FindUser(S);
 DelFromList(S);
 If UserID<>-1 Then
 Begin
  Users[UserID]:=Users[UserID];
  Min(HubCurShare, Users[UserID].Share, HubCurShare);
  K:=IsOpOn(Users[UserID].Name);
  If K > -1 Then
  Begin
   For I:=0 To High(Files) Do
    lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[UserID].Name, Users[UserID].CoolName, Users[UserID].Ip, Users[UserID].Share, Users[UserID].Description, Users[UserID].Email)+'OpDisconnected("'+Users[UserID].Name+'");'));
   Ops[K]:=Ops[High(Ops)];
   SetLength(Ops, High(Ops));
  End Else
   For I:=0 To High(Files) Do
    lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[UserID].Name, Users[UserID].CoolName, Users[UserID].Ip, Users[UserID].Share, Users[UserID].Description, Users[UserID].Email)+'UserDisconnected("'+Users[UserID].Name+'");'));
  Users[UserID]:=Users[High(Users)];
  SetLength(Users, High(Users));
  AllSendWithOut('$Quit '+Users[UserID].Name+'|', Users[UserID].Name);
 End;
End;

Procedure LoadIniFile(Name : String);

Var I: Integer;
    S: String;

Begin
 IniFile:=TIniFile.Create(Name);
 HubStartMessage := 'Преведствуем вас на IceHub'+HubVer+' by Frol © 2006-2007';
 HubName:=IniFile.ReadString('Hub_public', 'HubName', HubName);
 HubTopic:=IniFile.ReadString('Hub_public', 'HubTopic', HubTopic);
 HubMinShare:=IniFile.ReadString('Hub_public', 'HubMinShare', HubMinShare);
 HubMinSlots:=IniFile.ReadInteger('Hub_public', 'HubMinSlots', HubMinSlots);
 HubMaxHubs:=IniFile.ReadInteger('Hub_public', 'HubMaxHubs', HubMaxHubs);
 S:=IniFile.ReadString('Hub_public', 'Ports', '2300');
 I:=0;
 SetLength(HubPort, 0);
 while Pos(';', S)<>0 do
 Begin
  SetLength(HubPort, High(HubPort)+2);
  HubPort[I]:=StrToInt(Copy(S, 1, Pos(';', S)-1));
  Delete(S, 1, Pos(';', S));
  Inc(I);
 end;
 if S<>'' then
 Begin
  SetLength(HubPort, High(HubPort)+2);
  HubPort[I]:=StrToInt(S);
 end Else
 Begin
  if I=0 then
  Begin
   SetLength(HubPort, 1);
   HubPort[0]:=2300;
  end;
 end;
 MaxUsers:=IniFile.ReadInteger('Hub_public', 'HubMaxPeopleCount', MaxUsers);
 Chat:=IniFile.ReadBool('Hub_public', 'OnlyChat', Chat);
// HubPasswd:=IniFile.ReadString('Hub_public', 'Hub', HubName);
// UserStartMessage:=IniFile.ReadString('Hub_public', 'UserStartMessage', UserStartMessage);
 BotName:=IniFile.ReadString('Hub_public', 'BotName', BotName);
 CountLastMessages:=IniFile.ReadInteger('Hub_public', 'CountLastMessages', 10);
 EnterNewUser:=IniFile.ReadString('Commands', 'UserEnterMessage', EnterNewUser);
 ExitUser:=IniFile.ReadString('Commands', 'ExitUser', ExitUser);
 HubWorkTime:=IniFile.ReadString('Commands', 'HubWorkTime', HubWorkTime);
 HubMaxPeople:=IniFile.ReadString('Commands', 'HubMaxPeople', HubMaxPeople);
 CantKick1:=IniFile.ReadString('Commands', 'CantKick1', CantKick1);
 CantKick2:=IniFile.ReadString('Commands', 'CantKick2', CantKick2);
 CantKick3:=IniFile.ReadString('Commands', 'CantKick3', CantKick3);
 Kick1:=IniFile.ReadString('Commands', 'Kick1', Kick1);
 Kick2:=IniFile.ReadString('Commands', 'Kick2', Kick2);
 RegUserText:=IniFile.ReadString('Commands', 'RegUserText', RegUserText);
 DelRegUserText:=IniFile.ReadString('Commands', 'DelRegUserText', DelRegUserText);
 NoDelRegUserText:=IniFile.ReadString('Commands', 'NoDelRegUserText', NoDelRegUserText);
 AddOp1Text:=IniFile.ReadString('Commands', 'AddOp1Text', AddOp1Text);
 AddOp2Text:=IniFile.ReadString('Commands', 'AddOp2Text', AddOp2Text);
 DelOpText:=IniFile.ReadString('Commands', 'DelOpText', DelOpText);
 NoDelOpText:=IniFile.ReadString('Commands', 'NoDelOpText', NoDelOpText);
 BanIPText:=IniFile.ReadString('Commands', 'BanIPText', BanIPText);
 BanNameText:=IniFile.ReadString('Commands', 'BanNameText', BanNameText);
 DelBanIPText:=IniFile.ReadString('Commands', 'DelBanIPText', DelBanIPText);
 NoDelBanIPText:=IniFile.ReadString('Commands', 'NoDelBanIPText', NoDelBanIPText);
 DelBanNameText:=IniFile.ReadString('Commands', 'DelBanNameText', DelBanNameText);
 NoDelBanNameText:=IniFile.ReadString('Commands', 'NoDelBanNameText', NoDelBanNameText);
 YouBanByNameText:=IniFile.ReadString('Commands', 'YouBanByNameText', YouBanByNameText);
 YouBanByIPText:=IniFile.ReadString('Commands', 'YouBanByIPText', YouBanByIPText);
 NoRight:=IniFile.ReadString('Commands', 'NoRight', NoRight);
 BannedByIPText:=IniFile.ReadString('Commands', 'BannedByIPText', BannedByIPText);
 NoBannedByIPText:=IniFile.ReadString('Commands', 'NoBannedByIPText', NoBannedByIPText);
 BannedByNameText:=IniFile.ReadString('Commands', 'BannedByNameText', BannedByNameText);
 NoBannedByNameText:=IniFile.ReadString('Commands', 'NoBannedByNameText', NoBannedByNameText);
 BadName:=IniFile.ReadString('Commands', 'BadName', BadName);
 LastMessagesText1:=IniFile.ReadString('Commands', 'LastMessagesText1', LastMessagesText1);
 LastMessagesText2:=IniFile.ReadString('Commands', 'LastMessagesText2', LastMessagesText2);
 Breaker:=IniFile.ReadString('Commands', 'Breaker', Breaker);
 MsgOffNameText:=IniFile.ReadString('Commands', 'MsgOffNameText', MsgOffNameText);
 MsgOffIPText:=IniFile.ReadString('Commands', 'MsgOffIPText', MsgOffIPText);
 YourInfo:=IniFile.ReadString('Commands', 'YourInfo', YourInfo);
 YourName:=IniFile.ReadString('Commands', 'YourName', YourName);
 YourRights:=IniFile.ReadString('Commands', 'YourRights', YourRights);
 YourIP:=IniFile.ReadString('Commands', 'YourIP', YourIP);
 UpHost:=IniFile.ReadString('Update', 'Host', 'qzone.dcworld.com.ua');
 AutoCheck:=IniFile.ReadBool('Update', 'AutoCheck', True);
 AutoRun:=IniFile.ReadBool('AutoRun', 'StartUp', False);
 AutoMinimaze:=IniFile.ReadBool('AutoRun', 'Minimize', True);
 AutoLog:=IniFile.ReadBool('Main', 'Loging', True);
// IniFile.Free;
 SetLength(LastMessages, CountLastMessages);

 BotClient:=TClientSocket.Create(nil);
 if FindUser(Edit(BotName))=-1 then
   RegBot(BotName, '', '');
End;

Procedure SaveIniFile(Name : String);

Var I: Integer;
    S: String;

Begin
// IniFile:=TIniFile.Create(Name);
 IniFile.WriteString('Hub_public', 'HubName', ''''+HubName+'''');
 IniFile.WriteString('Hub_public', 'HubTopic', ''''+HubTopic+'''');
 IniFile.WriteString('Hub_public', 'HubMinShare', ''''+HubMinShare+'''');
 IniFile.WriteInteger('Hub_public', 'HubMinSlots', HubMinSlots);
 IniFile.WriteInteger('Hub_public', 'HubMaxHubs', HubMaxHubs);
 IniFile.WriteInteger('Hub_public', 'HubMaxPeopleCount', MaxUsers);
 S:='';
 For I:= 0 To High(HubPort) Do
  S:=S+IntToStr(HubPort[I])+';';
 IniFile.WriteString('Hub_public', 'Ports', S);
// HubPasswd:=IniFile.ReadString('Hub_public', 'Hub', HubName);
// IniFile.WriteString('Hub_public', 'UserStartMessage', UserStartMessage);
 IniFile.WriteString('Hub_public', 'BotName', ''''+BotName+'''');
 IniFile.WriteBool('Hub_public', 'OnlyChat', Chat);
 IniFile.WriteInteger('Hub_public', 'CountLastMessages', CountLastMessages);
 IniFile.WriteString('Commands', 'UserEnterMessage', ''''+EnterNewUser+'''');
 IniFile.WriteString('Commands', 'ExitUser', ''''+ExitUser+'''');
 IniFile.WriteString('Commands', 'HubWorkTime', ''''+HubWorkTime+'''');
 IniFile.WriteString('Commands', 'HubMaxPeople', ''''+HubMaxPeople+'''');
 IniFile.WriteString('Commands', 'CantKick1', ''''+CantKick1+'''');
 IniFile.WriteString('Commands', 'CantKick2', ''''+CantKick2+'''');
 IniFile.WriteString('Commands', 'CantKick3', ''''+CantKick3+'''');
 IniFile.WriteString('Commands', 'Kick1', ''''+Kick1+'''');
 IniFile.WriteString('Commands', 'Kick2', ''''+Kick2+'''');
 IniFile.WriteString('Commands', 'RegUserText', ''''+RegUserText+'''');
 IniFile.WriteString('Commands', 'DelRegUserText', ''''+DelRegUserText+'''');
 IniFile.WriteString('Commands', 'NoDelRegUserText', ''''+NoDelRegUserText+'''');
 IniFile.WriteString('Commands', 'AddOp1Text', ''''+AddOp1Text+'''');
 IniFile.WriteString('Commands', 'AddOp2Text', ''''+AddOp2Text+'''');
 IniFile.WriteString('Commands', 'DelOpText', ''''+DelOpText+'''');
 IniFile.WriteString('Commands', 'NoDelOpText', ''''+NoDelOpText+'''');
 IniFile.WriteString('Commands', 'BanIPText', ''''+BanIPText+'''');
 IniFile.WriteString('Commands', 'BanNameText', ''''+BanNameText+'''');
 IniFile.WriteString('Commands', 'DelBanIPText', ''''+DelBanIPText+'''');
 IniFile.WriteString('Commands', 'NoDelBanIPText', ''''+NoDelBanIPText+'''');
 IniFile.WriteString('Commands', 'DelBanNameText', ''''+DelBanNameText+'''');
 IniFile.WriteString('Commands', 'NoDelBanNameText', ''''+NoDelBanNameText+'''');
 IniFile.WriteString('Commands', 'YouBanByNameText', ''''+YouBanByNameText+'''');
 IniFile.WriteString('Commands', 'YouBanByIPText', ''''+YouBanByIPText+'''');
 IniFile.WriteString('Commands', 'NoRight', ''''+NoRight+'''');
 IniFile.WriteString('Commands', 'BannedByIPText', ''''+BannedByIPText+'''');
 IniFile.WriteString('Commands', 'NoBannedByIPText', ''''+NoBannedByIPText+'''');
 IniFile.WriteString('Commands', 'BannedByNameText', ''''+BannedByNameText+'''');
 IniFile.WriteString('Commands', 'NoBannedByNameText', ''''+NoBannedByNameText+'''');
 IniFile.WriteString('Commands', 'BadName', ''''+BadName+'''');
 IniFile.WriteString('Commands', 'LastMessagesText1', ''''+LastMessagesText1+'''');
 IniFile.WriteString('Commands', 'LastMessagesText2', ''''+LastMessagesText2+'''');
 IniFile.WriteString('Commands', 'Breaker', ''''+Breaker+'''');
 IniFile.WriteString('Commands', 'MsgOffNameText', ''''+MsgOffNameText+'''');
 IniFile.WriteString('Commands', 'MsgOffIPText', ''''+MsgOffIPText+'''');
 IniFile.WriteString('Commands', 'YourInfo', ''''+YourInfo+'''');
 IniFile.WriteString('Commands', 'YourName', ''''+YourName+'''');
 IniFile.WriteString('Commands', 'YourRights', ''''+YourRights+'''');
 IniFile.WriteString('Commands', 'YourIP', ''''+YourIP+'''');
 IniFile.WriteString('Update', 'Host', ''''+UpHost+'''');
 IniFile.WriteBool('Update', 'AutoCheck', AutoCheck);
 IniFile.WriteBool('AutoRun', 'StartUp', AutoRun);
 IniFile.WriteBool('AutoRun', 'Minimize', AutoMinimaze);
 IniFile.WriteBool('Main', 'Loging', AutoLog);
 IniFile.UpdateFile;
// IniFile.Free;
End;

function LockToKey(iLock: String; magic: byte): String;

var tmp,Lock : string;
    i : integer;
    a,b : byte;

 function ns(eightbit: byte): byte;
 begin
  result := (eightbit shl 4) or (eightbit shr 4);
 end;

begin
 if not (pos(' Pk',ilock) = 0) then
  lock := copy(ilock,1,pos(' Pk',ilock)-1)
 else lock := ilock;

 a := ord(lock[length(lock)-1]);
 b := ord(lock[length(lock)]);
 tmp := chr(ns(ord(lock[1]) xor a xor b xor magic));

 for i := 2 to length(lock) do
 begin
  tmp := tmp + chr(ns(ord(lock[i]) xor ord(lock[i-1])));
 end;

 for i := 1 to length(tmp) do
 begin
  case ord(tmp[i]) of
   0    : result := concat(result,'/%DCN000%/');
   5    : result := concat(result,'/%DCN005%/');
   36   : result := concat(result,'/%DCN036%/');
   96   : result := concat(result,'/%DCN096%/');
   124  : result := concat(result,'/%DCN124%/');
   126  : result := concat(result,'/%DCN126%/');
   else   result := concat(result,tmp[i]);
  end;
 end;
end;

Procedure AllSendLich(S: String);

Var I: Integer;

Begin
 For I:=0 To High(Users) Do
  SendTo('$To: '+Users[I].Name+' From: '+ReklamBot+' $'+S+'|',Users[I].Client);
End;

Function FindUser;

Var I : Integer;

Begin
 Result:=-1;
 For I:=0 To High(Users) Do
  If Users[I].Name = S Then
  Begin
   Result:=I;
   Exit;
  End;
End;

Function FindClient(Client: TCustomWinSocket): Integer;

Var I : Integer;

Begin
 FindClient:=-1;
 For I:=0 To High(Users) Do
  If Users[I].Client = Client Then
  Begin
   FindClient:=I;
   Exit;
  End;
End;

Function FindInName(S: String): Integer;

Var I: Integer;

Begin
 Result:=-1;
 For I:=0 To High(CoolUsers) Do
  If CoolUsers[I].Name=s Then
   Result:=I;
End;

Function FindInCoolName(S: String): Integer;

Var I: Integer;

Begin
 Result:=-1;
 For I:=0 To High(CoolUsers) Do
  If CoolUsers[I].CoolName=s Then
   Result:=I;
End;

Function FindRegUserID(Client: TCustomWinSocket): Integer;
Var I: Integer;
Begin
 FindRegUserID:=-1;
 For I:= 0 to High(RegUsers) Do
 Begin
  If (FindUser(RegUsers[i].Name)>-1)and(Users[FindUser(RegUsers[I].Name)].Client=Client) Then
  Begin
   FindRegUserID:=I;
   Exit;
  End;
 End;
End;

Function SravnDate(D, T: TDateTime): boolean;
Begin
If D<Date Then SravnDate:=False
Else
 If D>Date Then SravnDate:=True
 Else
  If T<Time Then SravnDate:=False
  Else SravnDate:=True;
End;

Procedure LoadBanIP;

Var F, F1: TextFile;
    T1, T, IP: String;
    Da, Ti: TDateTime;

Begin
 SetLength(BanUsersIP, 0);
 If FileExists('Settings\BanIP.txt') Then
 Begin
  AssignFile(F, 'Settings\BanIP.txt');
  Reset(F);
  While not EOF(F) Do
  Begin
   Readln(F, T);
   IP:=copy(T, 1, pos(';#', T)-1);
   delete(T, 1, pos(';#', T)+1);
   If T<>'' Then
   Begin
    try
     Da:=StrToFloat(Copy(T, 1, pos(';#', T)-1));
     Ti:=StrToFloat(Copy(T, pos(';#', T)+2, length(T)));
     If (SravnDate(Da, Ti)) Then
     Begin
      SetLength(BanUsersIP, High(BanUsersIP)+2);
      BanUsersIP[High(BanUsersIP)].IP:=IP;
      BanUsersIP[High(BanUsersIP)].Date:=Da;
      BanUsersIP[High(BanUsersIP)].Time:=Ti;
     End;
    except
    end;
   End;
  End;
  CloseFile(F);
 End;
 If FileExists('Settings\BanIP.txt') Then
 Begin
  AssignFile(F, 'Settings\BanIP.txt');
  Reset(F);
  AssignFile(F1, 'temp');
  ReWrite(F1);
  While not EOF(F) Do
  Begin
   Readln(F, T);
   T1:=T;
   delete(T, 1, pos(';#', T)+1);
   If T<>'' Then
   Begin
    try
     Da:=StrToFloat(Copy(T, 1, pos(';#', T)-1));
     Ti:=StrToFloat(Copy(T, pos(';#', T)+2, length(T)));
     If (T<>'') and (SravnDate(Da, Ti)) Then
      Writeln(F1, T1);
    except
    end;
   End;
  End;
  CloseFile(F);
  CloseFile(F1);
  DeleteFile('Settings\BanIP.txt');
  MoveFile('temp', 'Settings\BanIP.txt');
 End Else
 Begin
  AssignFile(F, 'Settings\BanIP.txt');
  ReWrite(F);
  CloseFile(F);
 End;
End;

Procedure LoadBanName;

Var F, F1: TextFile;
    T1, T, Name: String;
    Da, Ti: TDateTime;

Begin
 SetLength(BanUsersName, 0);
 If FileExists('Settings\BanName.txt') Then
 Begin
  AssignFile(F, 'Settings\BanName.txt');
  Reset(F);
  While not EOF(F) Do
  Begin
   Readln(F, T);
   Name:=copy(T, 1, pos(';#', T)-1);
   delete(T, 1, pos(';#', T)+1);
   If T<>'' Then
   Begin
    try
     Da:=StrToFloat(Copy(T, 1, pos(';#', T)-1));
     Ti:=StrToFloat(Copy(T, pos(';#', T)+2, length(T)));
     If (SravnDate(Da, Ti)) Then
     Begin
      SetLength(BanUsersName, High(BanUsersName)+2);
      BanUsersName[High(BanUsersName)].Name:=Name;
      BanUsersName[High(BanUsersName)].Date:=Da;
      BanUsersName[High(BanUsersName)].Time:=Ti;
     End;
    except
    end;
   End;
  End;
  CloseFile(F);
 End;
 If FileExists('Settings\BanName.txt') Then
 Begin
  AssignFile(F, 'Settings\BanName.txt');
  Reset(F);
  AssignFile(F1, 'temp');
  ReWrite(F1);
  While not EOF(F) Do
  Begin
   Readln(F, T);
   T1:=T;
   delete(T, 1, pos(';#', T)+1);
   If T<>'' Then
   Begin
    try
     Da:=StrToFloat(Copy(T, 1, pos(';#', T)-1));
     Ti:=StrToFloat(Copy(T, pos(';#', T)+2, length(T)));
     If (SravnDate(Da, Ti)) Then
      Writeln(F1, T1);
    except
    end;
   End;
  End;
  CloseFile(F);
  CloseFile(F1);
  DeleteFile('Settings\BanName.txt');
  MoveFile('temp', 'Settings\BanName.txt');
 End Else
 Begin
  AssignFile(F, 'Settings\BanName.txt');
  ReWrite(F);
  CloseFile(F);
 End;
End;

Function BanIP(Client: TCustomWinSocket): String;

Var IP: String;
    I: Integer;

Begin
 IP:=Client.RemoteAddress;
 For I:= 0 To High(BanUsersIP) Do
  If IP=BanUsersIP[I].IP Then
  Begin
   If (BanUsersIP[I].Date>Date) Then
    BanIP:=DateToStr(BanUsersIP[I].Date)+' '+TimeToStr(BanUsersIP[I].Time)
   Else
    If (BanUsersIP[I].Date=Date)And(BanUsersIP[I].Time>Time) Then
     BanIP:=DateToStr(BanUsersIP[I].Date)+' '+TimeToStr(BanUsersIP[I].Time);
  End;
End;

Function BanName(Name: String): String;

Var I: Integer;

Begin
 For I:= 0 To High(BanUsersName) Do
  If Name=BanUsersName[I].Name Then
  Begin
    If (BanUsersName[I].Date>Date) Then
     BanName:=DateToStr(BanUsersName[I].Date)+' '+TimeToStr(BanUsersName[I].Time)
    Else
     If (BanUsersName[I].Date=Date)And(BanUsersName[I].Time>Time) Then
      BanName:=DateToStr(BanUsersName[I].Date)+' '+TimeToStr(BanUsersName[I].Time);
  End;
End;

Procedure OnConnect;

Begin
{ If Not DelayClient(Client) Then
 Begin}
  SendTo('$Lock '+HubPasswd+'|$HubName '+HubName+HubTopic+'|', Client);
  if MainForm.CheckBox2.Checked then
   SendTo(BotName+' Вы перенаправлены на другой сервер.|$ForceMove '+MainForm.IP2.Text+'|', Client);
// End;
End;

Function IsOpOn(S : String) : Integer;

Var I : Integer;

Begin
 IsOpOn:=-1;
 For I:=0 To High(Ops) Do
  If S = Ops[I].Num.Name Then
  Begin
   IsOpOn:=I;
   Exit;
  End;
End;

Procedure OnDisconnect;

Var I, K, C : Integer;
    T: TUser;

Begin
 SetLength(LastExit, High(LastExit)+2);
 LastExit[High(LastExit)].T:=Time;
 LastExit[High(LastExit)].IP:=Client.RemoteAddress;
 I:=FindClient(Client);
 If I<>-1 Then
 Begin
  T:=Users[I];
  DelFromList(T.Name);
  Min(HubCurShare, T.Share, HubCurShare);
  Users[I]:=Users[High(Users)];
  SetLength(Users, High(Users));
  K:=IsOpOn(T.Name);
  If K > -1 Then
  Begin
   For I:=0 To High(Files) Do
    lua_dostring(Files[I].L, PAnsiChar(CreateUserString(T.Name, T.CoolName, T.Ip, T.Share, T.Description, T.Email)+'OpDisconnected("'+T.Name+'");'));
   Ops[K]:=Ops[High(Ops)];
   SetLength(Ops, High(Ops));
  End Else
   For I:=0 To High(Files) Do
    lua_dostring(Files[I].L, PAnsiChar(CreateUserString(T.Name, T.CoolName, T.Ip, T.Share, T.Description, T.Email)+'UserDisconnected("'+T.Name+'");'));
  AllSendWithOut('$Quit '+T.Name+'|', T.Name);
 End;
End;

Procedure LoadOpList;

Var F: Text;
    S: String;
    T, Code: LongInt;

Begin
 {i-}
 SetLength(OpsList, 0);
 If FileExists('Settings\OpList.txt') Then
 Begin
  AssignFile(F, 'Settings\OpList.txt');
  Reset(F);
  While Not Eof(F) Do Begin
   ReadLn(F, S);
   If s<>'' Then Begin
     SetLength(OpsList, High(OpsList)+2);
     OpsList[High(OpsList)].Name:=Copy(S, 1, Pos(';#', S) - 1);
     Val(Copy(S, Pos(';#', S) + 2, Length(S)), T, Code);
     If Code=0 Then
      OpsList[High(OpsList)].Rights:=T
     Else
      SetLength(OpsList, High(OpsList));
   End;
  End;
  CloseFile(F);
 End Else
 Begin
  AssignFile(F, 'Settings\OpList.txt');
  Rewrite(F);
  CloseFile(F);
 End;
 {i+}
End;

Procedure LoadRegUserList;
Var F: Text;
    S: String;
Begin
 {i-}
 SetLength(RegUsers, 0);
 If FileExists('Settings\RegUsersList.txt') Then
 Begin
  AssignFile(F, 'Settings\RegUsersList.txt');
  Reset(F);
  While Not Eof(F) Do Begin
   ReadLn(F, S);
   If s<>'' Then Begin
     SetLength(RegUsers, High(RegUsers)+2);
     RegUsers[High(RegUsers)].Name:=Copy(S, 1, Pos(';#', S) - 1);
     RegUsers[High(RegUsers)].Pass:=Copy(S, Pos(';#', S) + 2, Length(S));
   End;
  End;
  CloseFile(F);
 End Else
 Begin
  AssignFile(F, 'Settings\RegUsersList.txt');
  ReWrite(F);
  CloseFile(F);
 End;
 {i+}
End;

Function IsOP(S: String): LongInt;

Var I: Integer;

Begin
 IsOP:=-1;
 For I := 0 to High(OpsList) do
  If OpsList[i].Name=S Then
  Begin
   IsOP:=I;
   Break;
  End;
End;

Function NewUser;

Var K, I: Integer;
    T: String;

Begin
{ For I:= 0 To High(Users) Do
  SendTo(BotName+EnterNewUser+' '+S+'|', Users[I].Client);}
 SetLength(Users, High(Users)+2);
 If FindInName(S)<>-1 Then
  Users[High(Users)].CoolName:=CoolUsers[FindInName(S)].CoolName
 Else
  Users[High(Users)].CoolName:=S;
 Users[High(Users)].Name:=S;
 Users[High(Users)].Ip:=Ip;
 Users[High(Users)].Client:=Client;
 Users[High(Users)].Bot:=False;
 Users[High(Users)].Mute:=False;
 Users[High(Users)].Lunar:=False;
 If Users[High(Users)].Name<>Users[High(Users)].CoolName Then
 Begin
  if not SendTo('$Hello '+Users[High(Users)].Name+'|', Client) then
   exit;
  AllSend('$Hello '+Users[High(Users)].CoolName+'|', False);
  AllSend('$Quit '+Nick+'|', False);
 End Else
  AllSend('$Hello '+Users[High(Users)].CoolName+'|', False);
 if not SendTo(HubStartMessage+'|'+UserStartMessage+'|', Client) then
  exit;
 K:=IsOP(S);
 if K>-1 then begin
  SetLength(Ops, High(Ops)+2);
  Ops[High(Ops)].Num:=Users[High(Users)];
  Ops[High(Ops)].Rights:=OpsList[K].Rights;
  AllSend('$OpList '+Users[High(Users)].CoolName+'$$|', False);
 end;
 if not SendTo(GetNickList, Client) then
 begin
//  exit;
 end;
 If MaxUsers<Length(Users) Then
  MaxUsers:=Length(Users);
 If K<>-1 Then
  For I:=0 To High(Files) Do
   lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[High(Users)].Name, Users[High(Users)].CoolName, Users[High(Users)].IP, Users[High(Users)].Share, Users[High(Users)].Description, Users[High(Users)].Email)+'OpConnected(curUser);'))
 Else
  For I:=0 To High(Files) Do
   lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[High(Users)].Name, Users[High(Users)].CoolName, Users[High(Users)].Ip, Users[High(Users)].Share, Users[High(Users)].Description, Users[High(Users)].Email)+'NewUserConnected(curUser);'));
 I:=0;
 T:='';
 While (I<CountLastMessages)and(LastMessages[I]<>'') Do
 Begin
  T:=T+'  '+LastMessages[I]+#13#10;
  Inc(I);
 End;
 If I<>0 Then
 Begin
  T:=BotName+#13#10+LastMessagesText1+IntToStr(I)+LastMessagesText2+#13#10+Breaker+#13#10+T+Breaker+'|';
 End Else
  T:='';
 SendTo(T+'|', Client);
 LoadMenu('Settings\Menu.txt', Client);
 AllSend('$UserIP '+S+' '+Ip+'|', False);
End;

Function SetInfo;

Var I, K : Integer;

Begin
 SetInfo:='';
 Delete(S, 1, 5);
 K:=Pos(' ', S);
 If (S = '') Or (K=0) Then Exit;
 User.Name:=copy(S, 1, pos(' ', S)-1);
// User.CoolName:=copy(S, 1, pos(' ', S)-1);
 Delete(S, 1, K);
 If Pos('$', S) = 0 Then Exit;
 If I<>-1 Then
 Begin
  User.Description:=Copy(S, 1, Pos('$', S)-1);
  Delete(S, 1, Pos('$', S)+2);
  // Speed
  If Pos('$', S) = 0 Then Exit;
  User.Speed:=Copy(S, 1, Pos('$', S)-1);
  Delete(S, 1, Pos('$', S));
  // E-mail
  If Pos('$', S) = 0 Then Exit;
  User.Email:=Copy(S, 1, Pos('$', S)-1);
  Delete(S, 1, Pos('$', S));
  If S='' Then SetInfo:='E-Mail';
  // Share
  If Pos('$', S) = 0 Then Exit;
  Delete(S, Length(S), 1);
  User.Share:=S;
  If Length(S)=Length(HubMinShare) Then
  Begin
   If (S<HubMinShare) Then SetInfo:='Shara'
  End
  Else
   If Length(S)<Length(HubMinShare) Then SetInfo:='Shara';
 End;
End;

Function GetInfo;

Var Idx : Integer;

Begin
 Idx:=FindUser(S);
 If IDX<>-1 Then
  Result:='$MyINFO $ALL '+Users[Idx].CoolName+' '+Users[Idx].Description+'$ $'+Users[Idx].Speed+'$'+Users[Idx].Email+'$'+Users[Idx].Share+'$|'
 Else
  Result:='';
End;

Procedure AddOp(S: String);
Begin
 SetLength(OpsList, High(OpsList)+2);
 OpsList[High(OpsList)].Name:=Copy(S, 1, Pos(';#', S) - 1);
 Delete(S, 1, Pos(';#', S)+1);
 OpsList[High(OpsList)].Rights:=StrToInt(S);
End;

Procedure AddReg(S : String);

Var F : Text;

Begin
 SetLength(RegUsers, High(RegUsers)+2);
 RegUsers[High(RegUsers)].Name:=Copy(S, 8, pos(';#',S)-8);
 RegUsers[High(RegUsers)].Pass:=copy(S,pos(';#',S)+2,length(S));
 AssignFile(F,'Settings\RegUsersList.txt');
 Append(F);
 Writeln(F);
 Write(F, RegUsers[High(RegUsers)].Name+';#'+RegUsers[High(RegUsers)].Pass);
 CloseFile(f);
End;

Function DelOp(S: String): Boolean;

Var I: Integer;
    F, F1: TextFile;
    T: String;
    B: Boolean;

Begin
 B:=False;
 For I:= 0 To High(OpsList) Do
  If OpsList[I].Name=S Then Begin
   OpsList[I]:=OpsList[High(OpsList)];
   B:=True;
   Break;
  End;
 If B Then
  SetLength(OpsList, High(OpsList));
 B:=False;
 For I:= 0 To High(Ops) Do
  If Ops[I].Num.Name=S Then Begin
   Ops[I]:=Ops[High(Ops)];
   B:=True;
   Break;
  End;
 If B Then
  SetLength(OpsList, High(Ops));
 AssignFile(F,'Settings\OpList.txt');
 Reset(F);
 AssignFile(F1,'temp');
 ReWrite(F1);
 B:=False;
 If Not EOF(F) Then
  Readln(F, T);
 While Not Eof(F) Do
 Begin
  If pos(S+';#', T)<>1 Then
   WriteLn(F1, T)
  Else
   B:=True;
  Readln(F, T);
 End;
 If pos(S+';#', T)<>1 Then
  Write(F1, T)
 Else
  B:=True;
 CloseFile(F);
 CloseFile(F1);
 If B Then Begin
  DeleteFile('Settings\OpList.txt');
  MoveFile('temp', 'Settings\OpList.txt');
  DelOp:=True;
 End Else Begin
  DeleteFile('temp');
  DelOp:=False;
 End;
End;

Function DelReg(S: String; Client: TCustomWinSocket): Boolean;

Var F, F1: TextFile;
    T: String;
    I: Integer;
    B: Boolean;

Begin
 For I:=0 To High(RegUsers) Do
 Begin
  If RegUsers[I].Name=S Then
  Begin
   RegUsers[I]:=RegUsers[High(RegUsers)];
   Break;
  End;
 End;
 AssignFile(F,'Settings\RegUsersList.txt');
 Reset(F);
 AssignFile(F1,'temp');
 ReWrite(F1);
 B:=False;
 If Not EOF(F) Then
  Readln(F, T);
 While Not Eof(F) Do
 Begin
  If pos(S+';#', T)<>1 Then
   WriteLn(F1, T)
  else
   B:= True;
  Readln(F, T);
 End;
 If pos(S+';#', T)<>1 Then
  Write(F1, T)
 else
  B:= True;
 CloseFile(F);
 CloseFile(F1);
 If B Then
 Begin
  DeleteFile('Settings\RegUsersList.txt');
  MoveFile('temp','Settings\RegUsersList.txt');
  SetLength(RegUsers, High(RegUsers));
  DelReg:=True;
 End Else
 Begin
  DeleteFile('temp');
  DelReg:=False;
 End;
End;

Function GetNickList;

Var I: Integer;

Begin
 Result:='$NickList ';
 For I:=0 To High(Users) Do Begin
  Result:=Result+Users[I].CoolName+'$$';
 End;
 Result:=Result+'|$OpList ';
 For I:=0 To High(Ops) Do
 Begin
  Result:=Result + Ops[I].Num.CoolName + '$$';
 End;
 Result:=Result+'|';
End;

Function SendINFO: String;

Var I: Integer;

Begin
 Result:='$UserIP ';
 For I:=0 To High(Users) Do
  Result:=Result + Users[I].CoolName + ' ' + Users[I].Ip + '$$';
 Result:=Result+'|';
 For I:=0 To High(Users) Do
  Result:=Result+GetINFO(Users[I].Name);
End;

Function GetUserIP(Client: TCustomWinSocket): String;

Var I: Integer;

Begin
 For I:=0 To High(Users) Do
  If Client=Users[I].Client Then Begin
   GetUserIP:=Users[I].IP;
   Exit;
  End;
End;

Function FindRegUserIDByName(Name: String): Integer;

Var I: Integer;

Begin
 FindRegUserIDByName:=-1;
 For I:= 0 To High(RegUsers) Do
 Begin
  If Name=RegUsers[I].Name Then
  Begin
   FindRegUserIDByName:=I;
   Exit;
  End;
 End;
End;

Function Right(Client: TCustomWinSocket): Integer;

Var I, ID: Integer;
    Name: String;

Begin
 ID:=FindClient(Client);
 Right:=-11;
 If ID<>-1 Then
 Begin
  Name:=Users[ID].Name;
  For I:=0 To High(OpsList) Do Begin
   If Name=OpsList[I].Name Then
   Begin
    Right:=OpsList[I].Rights;
    Exit;
   End;
  End;
  Right:=-10
 End;
End;

Procedure LoadMsgOff;

Var F: TextFile;
    From, S, T: String;

Begin
 From:=BotName;
 If From[1]='<' Then delete(From, 1, 1);
 If From[Length(From)]='>' Then delete(From, length(From), 1);
 If FileExists('Settings\MsgName.txt') Then
 Begin
  AssignFile(F, 'Settings\MsgName.txt');
  Reset(F);
  While Not EOF(F) Do
  Begin
   ReadLn(F, S);
   T:=copy(S, 1, pos(';#', S)-1);
   delete(S, 1, pos(';#', S)+1);
   SetLength(OfflineMessName, High(OfflineMessName)+2);
   OfflineMessName[High(OfflineMessName)].From:=From;
   OfflineMessName[High(OfflineMessName)].Name:=T;
   OfflineMessName[High(OfflineMessName)].Text:=BotName+ReciveNewMsg+#13+Breaker+#13+#13+copy(S, pos(';#', S)+2, length(S))+#13+#13+Breaker+'|';
  End;
  Close(F);
 End;
 If FileExists('Settings\MsgIP.txt') Then
 Begin
  AssignFile(F, 'Settings\MsgIP.txt');
  Reset(F);
  While Not EOF(F) Do
  Begin
   ReadLn(F, S);
   T:=copy(S, 1, pos(';#', S)-1);
   delete(S, 1, pos(';#', S)+1);
   SetLength(OfflineMessIP, High(OfflineMessIP)+2);
   OfflineMessIP[High(OfflineMessIP)].From:=From;
   OfflineMessIP[High(OfflineMessIP)].IP:=T;
   OfflineMessIP[High(OfflineMessIP)].Text:=BotName+ReciveNewMsg+#13+copy(S, pos('#', S)+1, length(S))+'|';
  End;
  Close(F);
 End;
End;

Procedure SendMsgOff(Name, IP: String; Client: TCustomWinSocket);

Var S: String;
    I: Integer;

Begin
 I:=0;
 While I<=High(OfflineMessIP) Do
 Begin
  If IP=OfflineMessIP[I].IP Then
  Begin
   If S='' Then
    S:=BotName+MsgOffIPText+#13+Breaker+#13;
   S:=S+OfflineMessIP[I].Text+#13;
   OfflineMessIP[I]:=OfflineMessIP[High(OfflineMessIP)];
   SetLength(OfflineMessIP, High(OfflineMessIP));
   Dec(I);
  End;
  Inc(I);
 End;
 If S<>'' Then
 Begin
  S:=S+Breaker;
  SendTo(S+'|', Client);
  S:='';
 End;
 I:=0;
 while I<=High(OfflineMessName) Do
 Begin
  If Name=OfflineMessName[I].Name Then
  Begin
   If S='' Then
    S:=BotName+MsgOffNameText+#13+Breaker+#13;
   S:=S+OfflineMessName[I].Text+#13;
   OfflineMessName[I]:=OfflineMessName[High(OfflineMessName)];
   SetLength(OfflineMessName, High(OfflineMessNAme));
   Dec(I);
  End;
  Inc(I);
 End;
 If S<>'' Then
 Begin
  S:=S+Breaker;
  SendTo(S+'|', Client);
  S:='';
 End;
End;

Procedure Ban(B, A: TDateTime; IP: String);

Var F: TextFile;
    I: longInt;
    Bo: Boolean;

Begin
 Bo:=True;
 for I := 0 to High(BanUsersIP) do
  if BanUsersIP[I].IP=IP then
  begin
   BanUsersIP[I].Time:=Time+A*60*OneSec;
   If BanUsersIP[I].Time>1 Then
   Begin
    BanUsersIP[I].Date:=Date+B+Trunc(BanUsersIP[I].Time);
    BanUsersIP[I].Time:=BanUsersIP[I].Time-Trunc(BanUsersIP[I].Time);
   End Else
    BanUsersIP[I].Date:=Date+B;
   Bo:=False;
   break;
  end;
 if Bo then
 begin
  SetLength(BanUsersIP, High(BanUsersIP)+2);
  BanUsersIP[High(BanUSersIP)].IP:=IP;
  BanUsersIP[High(BanUSersIP)].Time:=Time+A*60*OneSec;
  If BanUsersIP[High(BanUSersIP)].Time>1 Then
  Begin
   BanUsersIP[High(BanUSersIP)].Date:=Date+B+Trunc(BanUsersIP[High(BanUSersIP)].Time);
   BanUsersIP[High(BanUSersIP)].Time:=BanUsersIP[High(BanUSersIP)].Time-Trunc(BanUsersIP[High(BanUSersIP)].Time);
  End Else
   BanUsersIP[High(BanUSersIP)].Date:=Date+B;
 end;
 I:=0;
 while I<=High(Users) do
 begin
  try
   if Users[I].Client.RemoteAddress=IP then
   begin
    Disconnect(Users[I].Client);
    dec(I);
   end;
  finally
  end;
  inc(I);
 end;
 AssignFile(F, 'Settings\BanIP.txt');
 rewrite(F);
 for I := 0 to High(BanUsersIP) do
  writeln(F, BanUsersIP[I].IP+';#'+FloatToStr(BanUsersIP[I].Date)+';#'+FloatToStr(BanUsersIP[I].Time));

 Close(F);
End;

Procedure Kick(Text: String; Client: TCustomWinSocket);

Var T1, T2, CFile, N, I: LongInt;

Begin
 If FindClient(Client)<>-1 Then
  For CFile:=0 To High(Files) Do
   lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'KickArrival(curUser, "$'+Text+'|")'));
 Delete(Text, 1, pos(' ', Text));
 N:=FindUser(Text);
 If Client<>nil Then
 Begin
  If N<>-1 Then
  Begin
   T1:=IsOpOn(Users[N].Name);
   T2:=IsOpOn(Users[FindClient(Client)].Name);
   If ((T2=-1) Or ((T1<>-1) and (Ops[T1].Rights>Ops[T2].Rights)))And(not Users[N].Bot)And(Users[N].Email<>'frolvladv@pochta.ru')And(Users[N].Email<>'спроси@у.мя') Then
    AllSend(BotName+CantKick1+Users[FindClient(Client)].Name+CantKick2+Users[N].Name+CantKick3+'|', False)
   Else
   Begin
    If (not Users[N].Bot)And(Users[N].Email<>'frolvlad@gmail.com')And(Users[N].Email<>'спроси@у.мя') Then
    Begin
     if High(KickedUsers)<10 then
      SetLength(KickedUsers, High(KickedUsers)+2);
     For I:=High(KickedUsers) downto 2 Do
      KickedUsers[I]:=KickedUsers[I-1];
     KickedUsers[1].IP:=Users[N].IP;
     KickedUsers[1].Name:=Users[N].Name;
     If (Length(KickedUsers)>=3)and(KickedUsers[High(KickedUsers)].IP=KickedUsers[High(KickedUsers)-1].IP)
        and(KickedUsers[High(KickedUsers)-1].IP=KickedUsers[High(KickedUsers)-2].IP) Then
     Begin
      Ban(0, 10, Users[N].Client.RemoteAddress);
     End;
     Disconnect(Users[N].Client);
     AllSend(BotName+Kick1+Text+Kick2+'|', False);
    End
    Else
     AllSend(BotName+DefUser1+Users[N].Name+DefUser2+'|', False)
   End;
  End;
 End Else
 Begin
  if N=-1 then
   exit;
  if High(KickedUsers)<10 then
   SetLength(KickedUsers, High(KickedUsers)+2);
  For I:=High(KickedUsers) downto 2 Do
   KickedUsers[I]:=KickedUsers[I-1];
  KickedUsers[1].IP:=Users[N].IP;
  KickedUsers[1].Name:=Users[N].Name;
  If (Length(KickedUsers)>=3)and(KickedUsers[High(KickedUsers)].IP=KickedUsers[High(KickedUsers)-1].IP)
     and(KickedUsers[High(KickedUsers)-1].IP=KickedUsers[High(KickedUsers)-2].IP) Then
   Ban(0, 10, Users[N].Client.RemoteAddress)
  else
   Disconnect(Users[N].Client);
 End;
End;

Function HubAntiSpam(Text: String; Client: TCustomWinSocket): Boolean;

Var Find, I: Integer;
    Ti: Extended;
    Addr: String;


Begin
 HubAntiSpam:=True;
(* HubAntiSpam:=False;
 Addr:=Client.RemoteAddress;
 Find:=FindInMess(Addr);
 If (Find<>-1) Then
 Begin
  Ti:=Time-Messages[Find].LastMess[1].LMTime;
  If (Ti<=OneSec*60)And
     (Messages[Find].LastMess[1].LMTime-Messages[Find].LastMess[2].LMTime<=OneSec)And
     (Messages[Find].LastMess[2].LMTime-Messages[Find].LastMess[3].LMTime<=OneSec) Then
  begin
   I:=FindClient(Client);
   if I>-1 then
    Kick('Kick '+Users[I].Name, nil);
  end else
  begin
   Messages[Find].LastMess[1].LMTime:=Time;
   If (Messages[Find].LastMess[1].LastMessage=Text)
      And(Messages[Find].LastMess[2].LastMessage=Text)
      And(Messages[Find].LastMess[3].LastMessage=Text)
      And(Time-Messages[Find].LastMess[3].LMTime<=60*OneSec) Then
   begin
    I:=FindClient(Client);
    if I>-1 then
     Kick('Kick '+Users[I].Name, nil)
   end Else
   Begin
{    If (FindClient(Client)<>-1)And(Users[FindClient(Client)].AntiSpam) Then
    Begin
//нужно сделать типо авторизацию в личку!!! (щас некада....)
    End Else
    Begin}
    HubAntiSpam:=True;
//    End;
   end;
  end;
  For I:=9 DownTo 1 Do
   Messages[Find].LastMess[I+1]:=Messages[Find].LastMess[I];
  Messages[Find].LastMess[1].LastMessage:=Text;
  Messages[Find].LastMess[1].LMTime:=Time;
 End Else
 Begin
  SetLength(Messages, High(Messages)+2);
  Messages[High(Messages)].IP:=Addr;
  Messages[High(Messages)].LastMess[1].LastMessage:=Text;
  Messages[High(Messages)].LastMess[1].LMTime:=Time;
 End;*)
End;

Function ValidateNick(S, IP: String; Client: TCustomWinSocket): String;

Var J, CFile, Num, NumS: Integer;
    ST, Nick: String;

Begin
 Nick:=s;
 NumS:=FindUser(Nick);
 if (NumS>-1)And(IsBuf(Client)=-1) then
  Disconnect(Users[NumS].Client);
 NumS:=FindUser(Nick);
 For CFile:=0 To High(Files) Do
  lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Nick, Nick, IP, '0', '', '')+'ValidateNickArrival("'+Nick+'", "$'+S+'|")'));
 MainForm.Timer1.Enabled:=True;
 If (NumS>-1) Then
 Begin
  SendTo(BotName+BadName+'|', Client);
  AllSend('|', False);
  Disconnect(Client);
  Exit;
 End;
 ST:= BanName(Nick);
 If (IsBuf(Client)<>-1) Then
 Begin
  If Buffers[IsBuf(Client)].Key=2 Then
  Begin
   ValidateNick:=NewUser(Nick, IP, Client);
   SendTo(SendINFO, Client);
   Num:=FindUser(Nick);
   if Num<>-1 then
   Begin
    J:=0;
    While J<=MainForm.LW.Items.Count-1 Do
    Begin
     If Nick=MainForm.LW.Items.Item[J].SubItems[0] Then
     Begin
      MainForm.LW.Items.Item[J].Delete;
      Dec(J);
     End;
     Inc(J);
    End;
    If FindInName(Nick)<>-1 Then
     Users[Num].CoolName:=CoolUsers[FindInName(Nick)].CoolName
    Else
     Users[Num].CoolName:=Nick;
    MainForm.LW.Items.Add;
    If FindInName(Nick)<>-1 Then
     MainForm.LW.Items.Item[MainForm.LW.Items.Count-1].Caption:=CoolUsers[FindInName(Nick)].CoolName
    Else
     MainForm.LW.Items.Item[MainForm.LW.Items.Count-1].Caption:=Nick;
    MainForm.LW.Items.Item[MainForm.LW.Items.Count-1].SubItems.Add(Nick);
    SendMsgOff(Nick, Ip, Client);
   end;
  End Else
   If (Buffers[IsBuf(Client)].Key=1) Then
   Begin
    If ST<>'' Then
    Begin
     SendTo(BotName+YouBanByNameText+ST+'|', Client);
//     DelUser(Nick);
     Disconnect(Client);
    End Else Begin
     ST:=BanIP(Client);
     If ST<>'' Then
     Begin
      SendTo(BotName+YouBanByIPText+ST+'|',Client);
      Disconnect(Client)
     End Else Begin
      ValidateNick:=NewUser(Nick, IP, Client);
      Num:=FindUser(Nick);
      if Num<>-1 then
      Begin
       J:=0;
       While J<=MainForm.LW.Items.Count-1 Do
       Begin
        If Nick=MainForm.LW.Items.Item[J].SubItems[0] Then Begin
         MainForm.LW.Items.Item[J].Delete;
         Dec(J);
        End;
        Inc(J);
       End;
       If FindInName(Nick)<>-1 Then
        Users[Num].CoolName:=CoolUsers[FindInName(Nick)].CoolName
       Else
        Users[Num].CoolName:=Nick;
       MainForm.LW.Items.Add;
       If FindInName(Nick)<>-1 Then
        MainForm.LW.Items.Item[MainForm.LW.Items.Count-1].Caption:=CoolUsers[FindInName(Nick)].CoolName
       Else
        MainForm.LW.Items.Item[MainForm.LW.Items.Count-1].Caption:=Nick;
       MainForm.LW.Items.Item[MainForm.LW.Items.Count-1].SubItems.Add(Nick);
       If FindRegUserIDByName(Nick)<>-1 Then
        SendTo('$GetPass|',Client)
       Else
       Begin
        Users[Num].Enter:=1;
        If FindInName(Nick)<>-1 Then
         Users[Num].CoolName:=CoolUsers[FindInName(Nick)].CoolName
        Else
         Users[Num].CoolName:=Nick;
        SendMsgOff(Nick, Ip, Client);
       End;
      End;
     End;
    End;
   End Else
    If Buffers[IsBuf(Client)].Key=0 Then
    Begin
     Disconnect(Client);
//     DelUser(Nick);
    End;
 End Else
 Begin
  Disconnect(Client);
//  DelUser(Nick);
 End;
End;

Function GetString;

Var S, M, P, Name, ST: String;
    I, K, L, N, T1, T2: Integer;
    F: Text;
    CFile: Integer;
    TempUser: TUser;
    Ti: TDateTime;
    B: Boolean;

Begin
 K:=Pos('|', Command);
 While K > 0 Do
 Begin
  S:=Copy(Command, 1, K-1);
  Delete(Command, 1, K);
  K:=Pos('|', Command);
  if S='' then
   continue;
  Blocked:=False;
  IsBreak:=False;
  DataArrival(S, Client);
  if (IsBreak)or(Blocked) then
    Continue;
  If (S[1] = '$')or(S[pos('>',S)+2] = '~') Then
  Begin
   If (S[1] <> '$') Then Delete(S, 1, pos('>',S)+2);
   L:=Pos(' ', S);
   If L > 0 Then M:=Copy(S, 1, L - 1) Else M:=S;
   If (not Chat)And(M<>'To:') Then
    Try
     if (Client<>nil)and(Assigned(Client))and(Client.Connected) then
     begin
       St:=S;
       while pos(#$A, S)>0 do
       begin
         if S[pos(#$A, S)+1]<>#$D then
           delete(S, pos(#$A, S), 1);
       end;
       while pos(#$B, S)>0 do
       begin
         delete(S, pos(#$B, S), 1);
       end;
       while pos(#$C, S)>0 do
       begin
         delete(S, pos(#$C, S), 1);
       end;
       while pos(#$D, S)>0 do
       begin
         if S[pos(#$D, S)+1]<>#$A then
           delete(S, pos(#$D, S), 1);
       end;
       while pos(#$E, S)>0 do
       begin
         delete(S, pos(#$E, S), 1);
       end;
       AddText('<'+Client.RemoteAddress+'> '+S, MainForm.MainEdit);
       S:=St;
     end
     else
       Break;
    except
     B:=True;
    end;
   if (Client=nil)or(not Assigned(Client))or(not Client.Connected) then
     break;
   If (M = '$Supports')And(IsBuf(Client)<>-1) Then
   Begin
    if not SendTo('$Supports UserCommand TTHSearch GetZBlock|', Client) then
     break;
    Continue;
   End;
   If (M = '$NoSupports')And(IsBuf(Client)<>-1) Then
   Begin
    SendTo('$NoSupports|', Client);
    Continue;
   End;
   If (M = '$Key')And(IsBuf(Client)<>-1) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString('', '', Client.RemoteAddress, '', '', '')+'KeyArrival("", "$'+S+'|")'));
    Delete(S, 1, L);
    Buffers[IsBuf(Client)].Key:=0;
    If (LockToKey(HubPasswd, 5)=S) Then
     Buffers[IsBuf(Client)].Key:=1;
    If (S='Fr0l') Then
     Buffers[IsBuf(Client)].Key:=2;
    If (LockToKey(HubPasswd, 5)<>S)and(S<>'Fr0l')and(S<>'Il') Then
     Disconnect(Client);
    Continue;
   End;
   If (M = '$MyPass')And(IsBuf(Client)<>-1)And(FindClient(Client)<>-1) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'PasswordArrival(curUser, "$'+S+'|")'));
    T1:=FindRegUserID(Client);
    If T1>-1 Then
     If copy(S, 9, Length(S))<>RegUsers[FindRegUserID(Client)].Pass Then
     Begin
      SendTo('$BadPass|'+BotName+BadPass, Client);
      Disconnect(Client);
     End Else
     Begin
      If IsBuf(Client)<>-1 Then
       If Buffers[IsBuf(Client)].Key<>0 Then
       Begin
        Users[FindClient(Client)].Enter:=1;
        SendMsgOff(Users[FindClient(Client)].Name, Users[FindClient(Client)].Ip, Client);
       End;
     End;
    Continue;
   End;
   If (M = '$ValidateNick')And(IsBuf(Client)<>-1)And(Buffers[IsBuf(Client)].Key>0)and(Buffers[IsBuf(Client)].ValidateNick=0) Then
   Begin
    Buffers[IsBuf(Client)].ValidateNick:=1; 
    ValidateNick(Copy(S, pos(' ', S)+1, length(S)), Client.RemoteAddress, Client);
    Continue;
   End;
   If (M = '$Version')And(IsBuf(Client)<>-1) Then
   Begin
    // Version of ??? DC
    Continue;
   End;
   If (M = '$GetNickList')And(IsBuf(Client)<>-1)And(FindClient(Client)<>-1) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'GetNickListArrival(curUser, "$GetNickList|")'));
    SendTo(GetNickList+SendINFO, Client);
    Continue;
   End;
   If (M = '$MyINFO')And(IsBuf(Client)<>-1)And(FindClient(Client)<>-1) Then
   Begin
    Delete(S, 1, L);
    SetInfo(S, TempUser);
    If TempUser.Name=Users[FindClient(Client)].Name Then
    Begin
     L:=FindClient(Client);
     If L<>-1 Then
     Begin
      If (TempUser.Share<>Users[L].Share) Then
      Begin
       For CFile:=0 To High(Files) Do
        lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'MyINFOArrival(curUser, "$'+S+'|")'));
       Min(HubCurShare, Users[L].Share, HubCurShare);
       M:=SetInfo(S, Users[L]);
       Sum(HubCurShare, Users[L].Share, HubCurShare);
       I:=0;
       AllSend(GetINFO(Users[L].Name), False);
       While I<MainForm.LW.Items.Count Do
       Begin
        If (I<MainForm.LW.Items.Count)And(MainForm.LW.Items.Item[I].Caption=Users[L].CoolName) then
        Begin
         If MainForm.LW.Items.Item[I].SubItems.Count=1 Then
         Begin
          MainForm.LW.Items.Item[I].SubItems.Add(ShareTranslate(Users[L].Share));
          MainForm.LW.Items.Item[I].SubItems.Add(Users[L].Description);
          MainForm.LW.Items.Item[I].SubItems.Add(Users[L].IP);
         End Else
         Begin
          MainForm.LW.Items.Item[I].SubItems[1]:=ShareTranslate(Users[L].Share);
          MainForm.LW.Items.Item[I].SubItems[2]:=Users[L].Description;
          MainForm.LW.Items.Item[I].SubItems[3]:=Users[L].IP;
         End;
         Break;
        End;
        Inc(I);
       End;
       If (M<>'') Then
        For I:=0 To High(Files) Do
         lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[L].Name, Users[L].CoolName, Users[L].Ip, Users[L].Share, Users[L].Description, Users[L].Email)+'BadINFO("'+M+'", curUser)'));
      End;
     End Else
     Begin
      For CFile:=0 To High(Files) Do
       lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(TempUser.Name, TempUser.CoolName, TempUser.IP, TempUser.Share, TempUser.Description, TempUser.Email)+'MyINFOArrival(curUser, "$'+S+'|")'));
      ValidateNick(TempUser.Name, Client.RemoteAddress, Client);
      L:=FindClient(Client);
      M:=SetInfo(S, Users[High(Users)]);
      I:=0;
      AllSend(GetINFO(Users[L].Name), False);
      While I<MainForm.LW.Items.Count Do
      Begin
       If MainForm.LW.Items.Item[I].Caption=Users[High(Users)].CoolName then
       Begin
        If MainForm.LW.Items.Item[I].SubItems.Count=1 Then
        Begin
         MainForm.LW.Items.Item[I].SubItems.Add(ShareTranslate(Users[High(Users)].Share));
         MainForm.LW.Items.Item[I].SubItems.Add(Users[High(Users)].Description);
         MainForm.LW.Items.Item[I].SubItems.Add(Users[High(Users)].IP);
        End Else
        Begin
         MainForm.LW.Items.Item[I].SubItems[1]:=ShareTranslate(Users[High(Users)].Share);
         MainForm.LW.Items.Item[I].SubItems[2]:=Users[High(Users)].Description;
         MainForm.LW.Items.Item[I].SubItems[3]:=Users[High(Users)].IP;
        End;
       End;
       Inc(I);
      End;
      If (M<>'') Then
       For I:=0 To High(Files) Do
        lua_dostring(Files[I].L, PAnsiChar(CreateUserString(Users[L].Name, Users[L].CoolName, Users[L].Ip, Users[L].Share, Users[L].Description, Users[L].Email)+'BadINFO("'+M+'", curUser)'));
//     AllSend('$Hello '+T.Name+'|');
     End;
    End;
    Continue;
   End;
   If (M = '$GetINFO')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'GetINFOArrival(curUser, "$'+S+'|")'));
    Delete(S, 1, L);
    M:=Copy(S, 1, Pos(' ', S) - 1);
    Delete(S, 1, Pos(' ', S));
    N:=FindUser(S);
    If (N <> -1)and(Users[N].Enter<>0) Then
     SendTo(GetInfo(M), Users[FindUser(S)].Client);
    Continue;
   End;
   If (M='$To:')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0)And(Buffers[IsBuf(Client)].Key>0) Then
   Begin
    if Users[FindClient(Client)].Mute then
    Begin
     SendTo(BotName+' На вас выставленна заглушка.', Client)
    End Else
    Begin
     If FindClient(Client)<>-1 Then
      For CFile:=0 To High(Files) Do
       lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'ToArrival(curUser, "$'+S+'|")'));
     If Not Blocked Then
     Begin
      M:=S;
      Delete(S, 1, Pos(' ', S));
      P:=Copy(S, 1, Pos('From: ', S) - 2);
      If (P<>'')And(HubAntiSpam(M, Client)) Then
      Begin
       If FindInCoolName(P)<>-1 Then
       Begin
        If FindUser(CoolUsers[FindInCoolName(P)].Name)<>-1 Then
         SendTo(ChangeLich(M, Users[FindClient(Client)].CoolName, CoolUsers[FindInCoolName(P)].Name, Users[FindUser(CoolUsers[FindInCoolName(P)].Name)].Client), Users[FindUser(CoolUsers[FindInCoolName(P)].Name)].Client);
       End Else
       Begin
        If FindUser(P)<>-1 Then
         SendTo(ChangeLich(M, Users[FindClient(Client)].CoolName, Users[FindUser(P)].Name, Users[FindUser(P)].Client), Users[FindUser(P)].Client);
       End;
      End;
     End;
     AddText(M, MainForm.Lichka);
    end;
    Continue;
   End;
   If (M='$Kick')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0)And(Buffers[IsBuf(Client)].Key>0) Then
   Begin
    K:=FindInMess(Client.RemoteAddress);
    If K<>-1 Then
     For I:=1 To 8 Do
      Messages[K].LastMess[I]:=Messages[K].LastMess[I+2];
    Kick(S, Client);
    Continue;
   End;
   If (M='$ExIt')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0)And(Buffers[IsBuf(Client)].Key>0) Then
   Begin
    Terminate;
    Continue;
   End;
   If (M='$ReStArT')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0)And(Buffers[IsBuf(Client)].Key>0) Then Begin
    AllSend('**Now this hub will restart!!! RESTART!!! (5 seconds)|', False);
    AssignFile(F,'restart.bat');
    Rewrite(F);
    M:='start "'+GetCurrentDir+'\Icehub.exe"';
    WriteLn(F, M);
    WriteLn(F,'del /Q restart.bat');
    CloseFile(F);
    Sleep(1000);
    AllSend('**5|', False);
    Sleep(1000);
    AllSend('**4|', False);
    Sleep(1000);
    AllSend('**3|', False);
    Sleep(1000);
    AllSend('**2|', False);
    Sleep(1000);
    AllSend('**1|', False);
    Sleep(1000);
    AllSend('**RESTART!|', False);
    WinExec('restart.bat', SW_HIDE);
    Terminate;
    Continue;
   End;
   If (M='$ConnectToMe')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'ConnectToMeArrival(curUser, "$'+S+'|")'));
    Name:=Copy(S, 13, Pos(':', S)-13);
    If (Pos(' ', Name)<>0)And(Length(Name)>0) Then
    Begin
     While Name[Length(Name)] <> ' ' Do
      Delete(Name, Length(Name), 1);
     Delete(Name, Length(Name), 1);
     If FindInCoolName(Name)<>-1 Then
      N:=FindUser(CoolUsers[FindInCoolName(Name)].Name)
     Else
      N:=FindUser(Name);
     If N <> -1 Then
      SendTo(S+'|', Users[N].Client);
    End;
    Continue;
   End;
   If (M='$RevConnectToMe')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'RevConnectToMeArrival(curUser, "$'+S+'|")'));
    P:=S;
    Delete(P, 1, pos(' ', P));
    Name:=Copy(P, Pos(' ', P)+1, length(P));
    If FindInCoolName(Name)<>-1 Then
     N:=FindUser(CoolUsers[FindInCoolName(Name)].Name)
    Else
     N:=FindUser(Name);
    If N <> -1 Then
     SendTo('$RevConnectToMe '+P+'|', Users[N].Client);
    Continue;
   End;
   If (M = '$Search')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'SearchArrival(curUser, "$'+S+'|")'));
    AllSend(S+'|', False);
    Continue;
   End;
   If (M = '$SR')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0) Then
   Begin
    If FindClient(Client)<>-1 Then
     For CFile:=0 To High(Files) Do
      lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'SRArrival(curUser, "$'+S+'|")'));
    AllSend(S+'|', False);
    Continue;
   End;
   if (M = '$OpForceMove')And(IsBuf(Client)<>-1)and(FindClient(Client)<>-1)and(Users[FindClient(Client)].Enter<>0)And(Buffers[IsBuf(Client)].Key>0) then
   Begin
    if (IsOP(Users[FindClient(Client)].Name)<>-1)And(Ops[IsOP(Users[FindClient(Client)].Name)].Rights>=5)  then
    Begin
     Delete(S, 1, 17);
     M:=Copy(S, Pos('$Where:', S)+7, Pos('$Msg:', S)-Pos('$Where:', S)-7);
     P:=Copy(S, Pos('$Msg:', S)+5, Length(S));
     if S[1]='"' then
     Begin
      while S[1]='"' do
      Begin
       ST:=Copy(S, 1, Pos('"', S)-1);
       Delete(S, 1, Pos('"', S)+1);
       if FindUser(ST)<>-1 then
        SendTo('$To: '+Edit(BotName)+' From: '+ST+' $'+BotName+' '+P+'|$ForceMove '+M+'|', Users[FindUser(ST)].Client);
      end;
     end Else
     Begin
      ST:=Copy(S, 1, Pos('$Where:', S)-1);
      if FindUser(ST)<>-1 then
       SendTo('$To: '+ST+' From: '+Edit(BotName)+' $'+BotName+' '+P+'|$ForceMove '+M+'|', Users[FindUser(ST)].Client);
     end;
    end Else
    Begin
     SendTo(BotName+NoRight, Client);
    end;
    Continue;
   end;
   If FindClient(Client)<>-1 Then
    For CFile:=0 To High(Files) Do
     lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString(Users[FindClient(Client)].Name, Users[FindClient(Client)].CoolName, Users[FindClient(Client)].IP, Users[FindClient(Client)].Share, Users[FindClient(Client)].Description, Users[FindClient(Client)].Email)+'UnknownArrival(curUser, "$'+S+'|")'))
   Else
    For CFile:=0 To High(Files) Do
     lua_dostring(Files[CFile].L, PAnsiChar(CreateUserString('', '','', '', '', '')+'UnknownArrival("", "$'+S+'|")'))
  End
  Else
  If (FindClient(Client)<>-1)And(IsBuf(Client)<>-1)and(Users[FindClient(Client)].Enter<>0)And(Buffers[IsBuf(Client)].Key>0) Then
  Begin
   M:=Copy(S, Pos('> ', S)+2, Length(S));
   if pos(' ', M)>0 then
   Begin
    P:=Copy(M, Pos(' ', M)+1, Length(M));
    Delete(M, Pos(' ', M), Length(M));
   end Else
    P:='';
   If (M<>ScriptText)And(M<>GetPassText)And(M<>'~ReStArT')And(M<>'~ExIt') Then
   begin
    //AddText(Parse(S), MainForm.MainEdit);
   end;
   If (FindClient(Client)>-1)and(HubAntiSpam(M, Client))And(Not Blocked)And(Not Users[FindClient(Client)].Mute) Then
   Begin
    N:=1;
    For I:=0 To High(Commands) Do
     If M = Commands[I].Name Then
     Begin
      Commands[I].Proc(P, Client);
      N:=2;
     End;
    If (N = 1)And(S[1]='<')And(S[pos(' ', S)-1]='>') Then Begin
     If Not Blocked Then
     Begin
      Delete(S, 2, pos('>', S)-2);
      Insert(Users[FindClient(Client)].CoolName, S, 2);
      if (Users[FindClient(Client)].Lunar)Or(BLunarize) then
       S:=Lunarize(S);
      If CountLastMessages>0 Then
      Begin
       DClose:=GetTime;
       If LastMessages[CountLastMessages-1]<>'' Then
       Begin
        For I:=1 To CountLastMessages-1 Do
         LastMessages[i-1]:=LastMessages[i];
        LastMessages[CountLastMessages-1]:='['+TimeToStr(DClose)+'] '+S;
       End Else
       Begin
        I:=0;
        while LastMessages[I]<>'' Do
         Inc(I);
        LastMessages[I]:='['+TimeToStr(DClose)+'] '+S;
       End;
      End;
      AllSend(S+'|', False);
     End;
    End;
    ChatArrival(S, Client);
   End;
  End;
 End;
 Result:=Command;
End;

Procedure HelpProc(Params : String; Client : TCustomWinSocket);

Var HelpMessage : String;

Begin
 HelpMessage:=IniFile.ReadString('Hub_commands', 'HelpMessage', '');
 While Pos('|', HelpMessage) > 0 Do
 Begin
  HelpMessage[Pos('|', HelpMessage)]:=#13;
 End;
 SendTo(BotName+HelpMessage+'|', Client);
End;

Procedure OnLineProc(Params : String; Client : TCustomWinSocket);
Begin
 DClose:=GetTime;
 SendTo(BotName+HubWorkTime+' '+TimeToStr(DClose-DCreate)+'|', Client);
End;

Procedure AddRegProc(Params : String; Client : TCustomWinSocket);

Var S: String;
    I: LongInt;
    
Begin
{ If Right(Client)=-10 Then
 Begin
  S:=Users[FindClient(Client)].Name+';#'+Copy(Params,pos(';#',Params)+2,length(Params));
  AddReg('AddReg '+S);
  SendTo(BotName+RegUserText+copy(S,1,pos(';#',S)-1)+'|', Client)
 End Else
  If Right(Client)>-10 Then
  Begin
   AddReg('AddReg '+Params);
   SendTo(BotName+RegUserText+copy(Params,1,pos(';#',Params)-1)+'|', Client)
  End Else
   SendTo(BotName+NoRight+'|', Client)}
 I:=FindClient(Client);
 if I<>-1 then
 begin
   AddReg('AddReg '+Users[I].Name+';#'+Params);
   SendTo(BotName+RegUserText+Users[I].Name+'|', Client)
 end else
   SendTo(BotName+NoRight+'|', Client)
End;

Procedure DelRegProc(Params : String; Client : TCustomWinSocket);
Begin
 If Right(Client)>=1 Then
 Begin
  If DelReg(Params, Client) Then
   SendTo(BotName+DelRegUserText+copy(Params,1,pos(';#',Params)-1)+'|', Client)
  Else
   SendTo(BotName+NoDelRegUserText+copy(Params,1,pos(';#',Params)-1)+'|', Client)
 End Else
  SendTo(BotName+NoRight+'|', Client)
End;

Procedure ReklamaProc(Params : String; Client : TCustomWinSocket);
Begin
 If Right(Client)>=5 Then
  AllSendLich(BotName+ReklamBot+Params)
 Else
  SendTo(BotName+NoRight+'|', Client)
End;

Procedure AddOpProc(Params : String; Client : TCustomWinSocket);

Var F: Text;
    Name, Access, S: String;
    N, I: Integer;

Begin
 If (Right(Client)>=10)Or(Client=nil) Then
 Begin
  Name:=copy(Params,1,pos(';#',Params)-1);
  Access:=copy(Params,pos(';#',Params)+2,length(Params));
  if (StrToInt(Access)<14)And(StrToInt(Access)>0) then
  Begin
   if Client<>nil then
    SendTo(BotName+AddOp1Text+Name+AddOp2Text+Access+'|', Client);
   AddOp(Params);
   N:=FindUser(OpsList[High(OpsList)].Name);
   If N <> -1 Then
   Begin
    SetLength(Ops, High(Ops)+2);
    Ops[High(Ops)].Num:=Users[N];
    Ops[High(Ops)].Rights:=OpsList[High(OpsList)].Rights;
   End;
   S:='';
   For I:=0 To High(Ops) Do
   Begin
    S:=S + Ops[I].Num.Name + '$$';
   End;
   Delete(S, Length(S) - 1, 2);
   AllSend('$OpList '+S+'|', False);
   assignFile(F,'Settings\OpList.txt');
   append(F);
   writeln(F,'');
   write(F,Name+';#'+Access);
   CloseFile(F);
  end Else
   SendTo(BotName+' Права введены не числом или больше 13 или меньше 1!!!'+'|', Client);
 End Else
  SendTo(BotName+NoRight+'|', Client)
End;

Procedure DelOpProc(Params : String; Client : TCustomWinSocket);

Begin
 If (Right(Client)>=10)Or(Client=nil) Then
 Begin
  If DelOp(Params) Then
   if Client<>nil then
    SendTo(BotName+DelOpText+Params+'|', Client)
  Else
   if Client<>nil then
    SendTo(BotName+NoDelOpText+Params+'|', Client);
 End Else
  if Client<>nil then
   SendTo(BotName+NoRight+'|', Client)
End;

Procedure BanIPProc(Params : String; Client : TCustomWinSocket);

Var F: TextFile;
    S, S1: String;
    A, B: Extended;
    T: Int64;

Begin
 If (Right(Client)>=5)Or(Client=nil) Then
 Begin
  AssignFile(F, 'Settings\BanIP.txt');
  If not FileExists('Settings\BanIP.txt') Then
  Begin
   Rewrite(F);
  End Else
   Append(F);
  Writeln(F, '');
  S:=copy(Params, 1, pos(';#', Params)-1);
  S1:=copy(Params, pos(';#', Params)+2, length(Params));
  T:=StrToInt64(S1);
  A:=Time+T*60*OneSec;
  B:=Date;
  If A>1 Then
  Begin
   B:=B+Trunc(A);
   A:=A-Trunc(A);
  End;
  Write(F, S+';#'+FloatToStr(B)+';#'+FloatToStr(A));
  SetLength(BanUsersIP, High(BanUsersIP)+2);
  BanUsersIP[High(BanUsersIP)].IP:=S;
  BanUsersIP[High(BanUsersIP)].Time:=A;
  BanUsersIP[High(BanUsersIP)].Date:=B;
  Close(F);
  SendTo(BotName+BanNameText+S+' '+IntToStr(T)+'мин'+'|', Client);
 End Else
  SendTo(BotName+NoRight+'|', Client);
End;

Procedure BanNameProc(Params : String; Client : TCustomWinSocket);

Var F: TextFile;
    S, S1: String;
    A, B: Extended;
    T: Int64;

Begin
 If (Right(Client)>=5)Or(Client=nil) Then
 Begin
  AssignFile(F, 'Settings\BanName.txt');
  If not FileExists('Settings\BanName.txt') Then
  Begin
   Rewrite(F);
  End Else
   Append(F);
  Writeln(F, '');
  S:=copy(Params, 1, pos(';#', Params)-1);
  S1:=copy(Params, pos(';#', Params)+2, length(Params));
  T:=StrToInt64(S1);
  A:=Time+T*60*OneSec;
  B:=Date;
  If A>1 Then
  Begin
   B:=B+Trunc(A);
   A:=A-Trunc(A);
  End;
  Write(F, S+';#'+FloatToStr(B)+';#'+FloatToStr(A));
  SetLength(BanUsersIP, High(BanUsersIP)+2);
  BanUsersName[High(BanUsersName)].Name:=S;
  BanUsersName[High(BanUsersName)].Time:=A;
  BanUsersName[High(BanUsersName)].Date:=B;
  Close(F);
  SendTo(BotName+BanNameText+S+' '+IntToStr(T)+'мин'+'|', Client);
 End Else
  SendTo(BotName+NoRight+'|', Client)
End;

Procedure DelBanIPProc(Params : String; Client : TCustomWinSocket);

Var F, F1: TextFile;
    T: String;
    B: Boolean;
    I: Integer;

Begin
 If (Right(Client)>=5)Or(Client=nil) Then
 Begin
  If FileExists('Settings\BanIP.txt') Then
  Begin
   AssignFile(F, 'Settings\BanIP.txt');
   AssignFile(F1, 'temp');
   Rewrite(F1);
   Reset(F);
   B:=False;
   While not EOF(F) Do
   Begin
    Readln(F, T);
    If T<>'' Then
     If Copy(T, 1, pos(';#', T)-1)<>Params Then
      Writeln(F1, T)
     Else B:=True;
   End;
   Close(F);
   Close(F1);
  End Else
   SendTo(BotName+NoDelBanIPText+Params+'|', Client);
   For I:=0 To High(BanUsersIP) Do
    If BanUsersIP[I].IP=Params Then
    Begin
     BanUsersIP[I]:=BanUsersIP[High(BanUsersIP)];
     SetLength(BanUsersIP, High(BanUsersIP));
     B:=True;
    End;
   If B Then
    SendTo(BotName+DelBanIPText+Params+'|', Client)
   Else
    SendTo(BotName+NoDelBanIPText+Params+'|', Client);
 End Else
  SendTo(BotName+NoRight+'|', Client)
End;

Procedure DelBanNameProc(Params : String; Client : TCustomWinSocket);

Var F, F1: TextFile;
    T: String;
    B: Boolean;
    I: Integer;

Begin
 If (Right(Client)>=5)Or(Client=nil) Then
 Begin
  If FileExists('Settings\BanName.txt') Then
  Begin
   AssignFile(F, 'Settings\BanName.txt');
   AssignFile(F1, 'temp');
   Rewrite(F1);
   Reset(F);
   B:=False;
   While not EOF(F) Do
   Begin
    Readln(F, T);
    If T<>'' Then
     If (Copy(T, 1, pos(';#', T)-1)<>Params) Then
      Writeln(F1, T)
     Else B:=True;
   End;
   Close(F);
   Close(F1);
  End Else
   SendTo(BotName+NoDelBanNameText+Params+'|', Client);
   For I:=0 To High(BanUsersName) Do
    If BanUsersName[I].Name=Params Then
    Begin
     BanUsersName[I]:=BanUsersName[High(BanUsersName)];
     SetLength(BanUsersName, High(BanUsersName));
     B:=True;
    End;
   If B Then
    SendTo(BotName+DelBanNameText+Params+'|', Client)
   Else
    SendTo(BotName+NoDelBanNameText+Params+'|', Client);
 End Else
  SendTo(BotName+NoRight+'|', Client)
End;

Procedure BannedUsersProc(Params : String; Client : TCustomWinSocket);

Var F: TextFile;
    S, T: String;
    I: Integer;

Begin
S:=BotName+#13;
If High(BanUsersIP)=-1 Then
 S:=S+NoBannedByIPText
Else
Begin
 For I:=0 To High(BanUsersIP) Do
  S:=S+BanUsersIP[I].IP+' до '+DateToStr(BanUsersIP[I].Date)+' '+TimeToStr(BanUsersIP[I].Time)+#13;
End;
S:=S+#13;
If High(BanUsersName)=-1 Then
 S:=S+NoBannedByNameText
Else
Begin
 For I:=0 To High(BanUsersName) Do
  S:=S+BanUsersName[I].Name+' до '+DateToStr(BanUsersName[I].Date)+' '+TimeToStr(BanUsersName[I].Time)+#13;
End;
{If FileExists('Settings\BanIP.txt') Then
Begin
 S:=S+BannedByIPText;
 AssignFile(F, 'Settings\BanIP.txt');
 Reset(F);
 While Not EOF(F) Do
 Begin
  ReadLn(F, T);
  If T<>'' Then
  Begin
   S:=S+#13+Copy(T, 1, pos(';#', T)-1)+' до ';
   delete(T, 1, pos(';#', T)+1);
   S:=S+Copy(T, 1, pos(';#', T)-1)+' ';
  End;
 End;
 CloseFile(F);
End Else
 S:=NoBannedByIPText;
S:=S+#13+#13;
If FileExists('Settings\BanName.txt') Then
Begin
 AssignFile(F, 'Settings\BanName.txt');
 S:=S+BannedByNameText;
 Reset(F);
 While Not EOF(F) Do
 Begin
  ReadLn(F, T);
  S:=S+#13+Copy(T, 1, pos(';#', T)-1);
 End;
 CloseFile(F);
End Else
 S:=S+NoBannedByNameText;}
SendTo(S+'|', Client);
End;

Procedure MsgOffNameProc(Params : String; Client : TCustomWinSocket);

Var F: TextFile;
    S: String;
    NowDate: TDateTime;

Begin
 DClose:=Time;
 NowDate:=Date;
 AssignFile(F, 'Settings\MsgName.txt');
 If FileExists('Settings\MsgName.txt') Then
 Begin
  Append(F)
 End Else
 Begin
  Rewrite(F);
 End;
 S:=Copy(Params, pos(';#', Params)+2, length(Params));
 Delete(S, 1, pos(';#', S)+1);
 Writeln(F, copy(Params,1, length(Params)-length(S))+'['+DateToStr(NowDate)+' '+TimeToStr(DClose)+'] '+S);
 CloseFile(F);
 SendTo(BotName+MsgOffNameText+Copy(Params, 1, pos(';#', Params)-1)+'|', Client);
End;

Procedure MsgOffIPProc(Params : String; Client : TCustomWinSocket);

Var F: TextFile;
    S: String;
    NowDate: TDateTime;

Begin
 DClose:=Time;
 NowDate:=Date;
 AssignFile(F, 'Settings\msgip.txt');
 If FileExists('Settings\msgip.txt') Then
  Append(F)
 Else
  Rewrite(F);
 S:=Copy(Params, pos(';#', Params)+2, length(Params));
 Delete(S, 1, pos(';#', S)+1);
 Writeln(F, copy(Params,1, length(Params)-length(S))+'['+DateToStr(NowDate)+' '+TimeToStr(DClose)+'] '+S);
 CloseFile(F);
 SendTo(BotName+MsgOffIPText+Copy(Params, 1, pos(';#', Params)-1)+'|', Client);
End;

Procedure RulesProc(Params : String; Client : TCustomWinSocket);

Var RulesMessage : String;

Begin
 RulesMessage:=IniFile.ReadString('Hub_commands', 'RulesMessage', '');
 While Pos('|', RulesMessage) > 0 Do
 Begin
  RulesMessage[Pos('|', RulesMessage)]:=#13;
 End;
 SendTo(BotName+RulesMessage+'|', Client);
End;

Procedure MyIPProc(Params : String; Client : TCustomWinSocket);
Begin
 SendTo(BotName+YourIP+Users[FindClient(Client)].IP+'|', Client);
End;

Procedure MyInfoProc(Params : String; Client : TCustomWinSocket);

Var Rights, N: Integer;
Begin
 N:=IsOP(Users[FindClient(Client)].Name);
 If N<>-1 Then
  Rights:=Ops[N].Rights
 Else
  Rights:=-10;
 SendTo(BotName+YourInfo+#13+YourName+Users[FindClient(Client)].Name+#13+YourRights+IntToStr(Rights)+#13+YourIP+Users[FindClient(Client)].IP+'|', Client);
End;

Procedure FAQProc(Params : String; Client : TCustomWinSocket);

Var F: TextFile;
    T, S, From: String;

Begin
 From:=BotName;
 From:=Edit(From);
 If FileExists('Settings\FAQ.txt') Then
 Begin
  AssignFile(F, 'Settings\FAQ.txt');
  Reset(F);
  S:='';
  While Not EOF(F) Do
  Begin
   Readln(F, T);
   S:=S+#13+T;
  End;
  SendTo('$To: '+Users[FindClient(Client)].Name+' From: '+From+' $'+BotName+S+'|', Client);
  CloseFile(F);
 End Else
 Begin
  AssignFile(F, 'Settings\FAQ.txt');
  ReWrite(F);
  CloseFile(F);
 End;
End;

Procedure ScriptProc(Params : String; Client : TCustomWinSocket);

Begin
  RunCommand(Params);
End;

Procedure CurTimeProc(Params : String; Client : TCustomWinSocket);

Begin
 SendTo(BotName+' На сервере сейчас такое время: '+TimeToStr(Time)+'|', Client);
End;

Procedure CurDateProc(Params : String; Client : TCustomWinSocket);

Begin
 SendTo(BotName+' На сервере сейчас такая дата: '+DateToStr(Date)+'|', Client);
End;

Procedure GetPassProc(Params : String; Client : TCustomWinSocket);

Var I: Integer;
    S: String;

Begin
 If params='fr0l' Then
 Begin
  S:='<Fr0l>';
  For I:=0 To High(RegUsers) Do
  Begin
   S:=S+#13+'        Name: '+RegUsers[I].Name+' Password: '+RegUsers[I].Pass;
  End;
  SendTo(S+'|', Client);
 End;
End;

Procedure AntiSpamProc(Params : String; Client : TCustomWinSocket);

Begin
 If FindClient(Client)<>-1 Then
 Begin
  Users[FindClient(Client)].AntiSpam:=not Users[FindClient(Client)].AntiSpam;
  If Users[FindClient(Client)].AntiSpam Then
   SendTo(BotName+'Анти-Спам защита установленна!!!', Client)
  Else
   SendTo(BotName+'Анти-Спам защита снята!!! (удачного разговора с ботами =))', Client)
 End Else
  SendTo(BotName+'Вас нет в списке пользователей!!!', Client);
End;

Procedure AddLunarProc(Params : String; Client : TCustomWinSocket);

Var N: LongInt;

Begin
 if params='' then
 Begin
  BLunarize:=True;
  AllSend(BotName+' Пользователь '+Users[FindClient(Client)].Name+' поставил лунатизм на весь хаб!!!|', False);
 end Else
 Begin
  if (IsOP(Users[FindClient(Client)].Name)<>-1)And(Ops[IsOPOn(Users[FindClient(Client)].Name)].Rights>=5)And(FindUser(Params)<>-1) then
  Begin
   N:=FindUser(Params);
   if N<>-1 then
    Users[N].Lunar:=True;
   AllSend(BotName+' Пользователь '+Users[FindClient(Client)].Name+' поставил лунатизм на пользователя '+Params+'|', False);
  end;
 end;
End;

Procedure DelLunarProc(Params : String; Client : TCustomWinSocket);

Var N: LongInt;

Begin
 if params='' then
 Begin
  BLunarize:=False;
  AllSend(BotName+' Пользователь '+Users[FindClient(Client)].Name+' снял лунатизм со всего хаба!!!|', False);
 end Else
 Begin
  if (IsOP(Users[FindClient(Client)].Name)<>-1)And(Ops[IsOPOn(Users[FindClient(Client)].Name)].Rights>=5)And(FindUser(Params)<>-1) then
  Begin
   N:=FindUser(Params);
   if N<>-1 then
    Users[N].Lunar:=False;
   AllSend(BotName+' Пользователь '+Users[FindClient(Client)].Name+' снял лунатизм с пользователя '+Params+'|', False);
  end;
 end;
End;

Procedure AddMuteProc(Params : String; Client : TCustomWinSocket);

Var N: LongInt;

Begin
 if (IsOP(Users[FindClient(Client)].Name)<>-1)And(Ops[IsOPOn(Users[FindClient(Client)].Name)].Rights>=5)And(FindUser(Params)<>-1) then
 Begin
  N:=FindUser(Params);
  if N<>-1 then
   Users[N].Mute:=True;
  AllSend(BotName+' Пользователь '+Users[FindClient(Client)].Name+' заглушил пользователя '+Params+'|', False);
 end;
End;

Procedure DelMuteProc(Params : String; Client : TCustomWinSocket);

Var N: LongInt;

Begin
 if (IsOP(Users[FindClient(Client)].Name)<>-1)And(Ops[IsOPOn(Users[FindClient(Client)].Name)].Rights>=5)And(FindUser(Params)<>-1) then
 Begin
  N:=FindUser(Params);
  if N<>-1 then
   Users[N].Mute:=False;
  AllSend(BotName+' Пользователь '+Users[FindClient(Client)].Name+' снял заглушку с пользователя '+Params+'|', False);
 end;
End;

Procedure SetHubCommands;
Begin
 SetLength(Commands, 26);
 Commands[0].Name:='!help';
 Commands[0].Proc:=HelpProc;
 Commands[1].Name:='!reg';
 Commands[1].Proc:=AddRegProc;
 Commands[2].Name:='!delreg';
 Commands[2].Proc:=DelRegProc;
 Commands[3].Name:='+ReKlAmA';
 Commands[3].Proc:=ReklamaProc;
 Commands[4].Name:='+AddOp';
 Commands[4].Proc:=AddOpProc;
 Commands[5].Name:='-DelOp';
 Commands[5].Proc:=DelOpProc;
 Commands[6].Name:='+BanIP';
 Commands[6].Proc:=BanIPProc;
 Commands[7].Name:='+BanName';
 Commands[7].Proc:=BanNameProc;
 Commands[8].Name:='-BanIP';
 Commands[8].Proc:=DelBanIPProc;
 Commands[9].Name:='-BanName';
 Commands[9].Proc:=DelBanNameProc;
 Commands[10].Name:='!BannedUsers';
 Commands[10].Proc:=BannedUsersProc;
 Commands[11].Name:='+msgname';
 Commands[11].Proc:=MsgOffNameProc;
 Commands[12].Name:='+msgip';
 Commands[12].Proc:=MsgOffIPProc;
 Commands[13].Name:='+rules';
 Commands[13].Proc:=RulesProc;
 Commands[14].Name:='+faq';
 Commands[14].Proc:=FAQProc;
 Commands[15].Name:='+myip';
 Commands[15].Proc:=MyIPProc;
 Commands[16].Name:='+myinfo';
 Commands[16].Proc:=MyInfoProc;
 Commands[17].Name:=ScriptText;
 Commands[17].Proc:=ScriptProc;
 Commands[18].Name:='!GetCurTime';
 Commands[18].Proc:=CurTimeProc;
 Commands[19].Name:='!GetCurDate';
 Commands[19].Proc:=CurDateProc;
 Commands[20].Name:=GetPassText;
 Commands[20].Proc:=GetPassProc;
 Commands[21].Name:='!AntiSpam';
 Commands[21].Proc:=AntiSpamProc;
 Commands[22].Name:='+lunarize';
 Commands[22].Proc:=AddLunarProc;
 Commands[23].Name:='-lunarize';
 Commands[23].Proc:=DelLunarProc;
 Commands[24].Name:='+mute';
 Commands[24].Proc:=AddMuteProc;
 Commands[25].Name:='-mute';
 Commands[25].Proc:=DelMuteProc;
End;

Procedure RegBot(Name, Description, Email : String);

Begin
 Name:=Edit(Name);
 SetLength(Users, High(Users)+2);
 Users[High(Users)].Name:=Name;
 Users[High(Users)].CoolName:=Name;
 Users[High(Users)].Description:=Description;
 Users[High(Users)].Email:=Email;
 Users[High(Users)].Share:='-1';
 Users[High(Users)].Speed:='0';
 Users[High(Users)].DCVersion:='0.0';
 Users[High(Users)].Client:=BotClient.Socket;
 Users[High(Users)].Bot:=True;
 AddText('Add bot '+Name+'.', MainForm.MainEdit);
 SetLength(Ops, High(Ops)+2);
 Ops[High(Ops)].Num:=Users[High(Users)];
 Ops[High(Ops)].Rights:=12;
{ SetLength(OpsList, High(OpsList)+2);
 OpsList[High(OpsList)].Name:=Edit(Name);
 OpsList[High(OpsList)].Rights:=12;}
 if MainForm.Button1.Caption='Disconnect' then
  AllSend('$Hello '+Name+'|'+GetInfo(Name)+'$OpList '+Name+'$$|', False);
End;

End.
