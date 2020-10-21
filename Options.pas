unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, TabNotBk, Main, DCPockets, LuaUnit,
  Add, Registry, ScktComp, RichEdit, SyntaxU, ExtCtrls;

type
  TOptionsForm = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    LB: TListBox;
    Button4: TButton;
    Button5: TButton;
    OpenDialog1: TOpenDialog;
    Button6: TButton;
    Label3: TLabel;
    Edit8: TEdit;
    OOps: TListView;
    OBanIP: TListView;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    OBanName: TListView;
    Button12: TButton;
    Button11: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    OCoolName: TListView;
    Button13: TButton;
    Button14: TButton;
    Label16: TLabel;
    CheckBox1: TCheckBox;
    Edit13: TEdit;
    Button15: TButton;
    Label17: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ScriptEdit: TRichEdit;
    Edit1: TLabeledEdit;
    Edit2: TLabeledEdit;
    Edit3: TLabeledEdit;
    Edit6: TLabeledEdit;
    Edit7: TLabeledEdit;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ScriptEditChange(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure LBDblClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure RichEdit1Change(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure ScriptEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  Procedure Save;
  Procedure Load;

var
  OptionsForm: TOptionsForm;
  Edited: String;
  RChanged: Boolean = False;
  Rezerved, Znak: Array of TRezerved;
  Skobki: Array of TSkobki;
  Edit: Boolean;
  Ti: TDateTime;

implementation

{$R *.dfm}
//---------------------------------------------------------


Procedure LoadRezerved;

begin
 SetLength(Skobki, 6);
 Skobki[0].First:='{';
 Skobki[0].Last:='}';
 Skobki[0].Style.Color:=clNavy-50000;
 Skobki[0].Style.Styles:=[];
 Skobki[1].First:='(';
 Skobki[1].Last:=')';
 Skobki[1].Style.Color:=clSkyBlue-50000;
 Skobki[1].Style.Styles:=[];
 Skobki[2].First:='"';
 Skobki[2].Last:='"';
 Skobki[2].Style.Color:=clSkyBlue-50000;
 Skobki[2].Style.Styles:=[];
 Skobki[3].First:='''';
 Skobki[3].Last:='''';
 Skobki[3].Style.Color:=clSkyBlue-50000;
 Skobki[3].Style.Styles:=[];
 Skobki[4].First:='--[[';
 Skobki[4].Last:=']]--';
 Skobki[4].Comment:=True;
 Skobki[4].Style.Color:=clGreen;
 Skobki[4].Style.Styles:=[fsItalic];
 Skobki[5].First:='--';
 Skobki[5].Last:=#13;
 Skobki[5].Comment:=True;
 Skobki[5].Style.Color:=clGreen;
 Skobki[5].Style.Styles:=[fsItalic];
 SetLength(Rezerved, 8);
 Rezerved[0].S:='THEN';
 Rezerved[0].Style.Color:=clNavy;
 Rezerved[0].Style.Styles:=[fsBold];
 Rezerved[1].S:='END';
 Rezerved[1].Style.Color:=clNavy;
 Rezerved[1].Style.Styles:=[fsBold];
 Rezerved[2].S:='IF';
 Rezerved[2].Style.Color:=clNavy;
 Rezerved[2].Style.Styles:=[fsBold];
 Rezerved[3].S:='FUNCTION';
 Rezerved[3].Style.Color:=clNavy;
 Rezerved[3].Style.Styles:=[fsBold];
 Rezerved[4].S:='RETURN';
 Rezerved[4].Style.Color:=clNavy;
 Rezerved[4].Style.Styles:=[fsBold];
 Rezerved[5].S:='FOR';
 Rezerved[5].Style.Color:=clNavy;
 Rezerved[5].Style.Styles:=[fsBold];
 Rezerved[6].S:='DO';
 Rezerved[6].Style.Color:=clNavy;
 Rezerved[6].Style.Styles:=[fsBold];
 Rezerved[7].S:='IN';
 Rezerved[7].Style.Color:=clNavy;
 Rezerved[7].Style.Styles:=[fsBold];
 SetLength(Znak, 5);
 Znak[0].S:='';
 Znak[0].Style.Color:=clBlack;
 Znak[0].Style.Styles:=[fsBold];
 Znak[1].S:='';
 Znak[1].Style.Color:=clBlack;
 Znak[1].Style.Styles:=[fsBold];
 Znak[2].S:='';
 Znak[2].Style.Color:=clBlack;
 Znak[2].Style.Styles:=[fsBold];
 Znak[3].S:='';
 Znak[3].Style.Color:=clBlack;
 Znak[3].Style.Styles:=[fsBold];
 Znak[4].S:='';
 Znak[4].Style.Color:=clBlack;
 Znak[4].Style.Styles:=[fsBold];
end;

//---------------------------------------------------------

Procedure Save;

Var I: LongInt;
    F: TextFile;
    T, A, B: Extended;
    RegProcess: function (p1, p2:integer): integer; stdcall;
    hDllKernel: HInst; reg: TRegistry;
    PortText: String;
    J: Integer;
    Bool: Boolean;

Begin
 Done;
 HubName:=OptionsForm.Edit1.Text;
 HubTopic:=OptionsForm.Edit2.Text;
 AllSend('$HubName '+HubName+HubTopic+'|', False);
 BotName:=OptionsForm.Edit3.Text;
 HubMinShare:=OptionsForm.Edit7.Text;
 CountLastMessages:=StrToInt(OptionsForm.Edit6.Text);
 HubMaxHubs:=StrToInt(OptionsForm.Edit7.Text);
 I:=0;
 //SetLength(Servers, 0);
 SetLength(HubPort, 0);
 PortText:=OptionsForm.Edit8.Text;
 while Pos(';', PortText)<>0 do
 Begin
  SetLength(HubPort, High(HubPort)+2);
  HubPort[High(HubPort)]:=StrToInt(Copy(PortText, 1, Pos(';', PortText)-1));
  PortText:=Copy(PortText, Pos(';', PortText)+1, Length(PortText));
  Bool:=True;
  for J := 0 to High(Servers) do
   if Servers[J].Port=HubPort[I] then
   begin
    Bool:=False;
    Break;
   end;
  if not Bool then
  begin
   AddText('[b][blue]**Server port = [/blue][/b]'+InttoStr(HubPort[I])+' already opened', MainForm.MainEdit);
  end;
  if I>High(Servers) then
   SetLength(Servers, High(Servers)+2);
  if (Bool) then
  begin
   Servers[I]:=TServerSocket.Create(nil);
   Servers[I].OnClientConnect:=MainForm.ServerSocket1.OnClientConnect;
   Servers[I].OnClientDisconnect:=MainForm.ServerSocket1.OnClientDisconnect;
   Servers[I].OnClientRead:=MainForm.ServerSocket1.OnClientRead;
   Servers[I].OnClientWrite:=MainForm.ServerSocket1.OnClientWrite;
   Servers[I].OnClientError:=MainForm.ServerSocket1.OnClientError;
   Servers[I].Port:=HubPort[High(HubPort)];
   try
    Servers[I].Open;
    AddText('[b][green]**Open server, port = [/green][/b]'+InttoStr(Servers[High(Servers)].Port), MainForm.MainEdit);
   except
    AddText('[b][red]**Can''t open server, port = [/red][/b]'+InttoStr(Servers[High(Servers)].Port), MainForm.MainEdit);
   end;
  end;
  inc(I);
 end;
 if PortText<>'' then
 Begin
  SetLength(HubPort, High(HubPort)+2);
  HubPort[High(HubPort)]:=StrToInt(PortText);
  Bool:=True;
  for J := 0 to High(Servers) do
   if Servers[J].Port=HubPort[I] then
   begin
    Bool:=False;
    Break;
   end;
  if not Bool then
  begin
   AddText('[b][blue]**Server port = [/blue][/b]'+InttoStr(HubPort[I])+' already opened', MainForm.MainEdit);
  end;
  if I>High(Servers) then
   SetLength(Servers, High(Servers)+2);
  if (Bool) then
  begin
   Servers[I]:=TServerSocket.Create(nil);
   Servers[I].OnClientConnect:=MainForm.ServerSocket1.OnClientConnect;
   Servers[I].OnClientDisconnect:=MainForm.ServerSocket1.OnClientDisconnect;
   Servers[I].OnClientRead:=MainForm.ServerSocket1.OnClientRead;
   Servers[I].OnClientWrite:=MainForm.ServerSocket1.OnClientWrite;
   Servers[I].OnClientError:=MainForm.ServerSocket1.OnClientError;
   Servers[I].Port:=HubPort[High(HubPort)];
   try
    Servers[I].Open;
    AddText('[b][green]**Open server, port = [/green][/b]'+InttoStr(Servers[High(Servers)].Port), MainForm.MainEdit);
   except
    AddText('[b][red]**Can''t open server, port = [/red][/b]'+InttoStr(Servers[High(Servers)].Port), MainForm.MainEdit);
   end;
  end;
 end;
 UpHost:=OptionsForm.Edit13.Text;
 AutoCheck:=OptionsForm.CheckBox1.Checked;
 AutoMinimaze:=OptionsForm.CheckBox3.Checked;
 AutoRun:=OptionsForm.CheckBox2.Checked;
 AutoLog:=OptionsForm.CheckBox4.Checked;
 AssignFile(F, 'Script\files.cfg');
 ReWrite(F);
 Writeln(F, OptionsForm.LB.Items.Count);
 For I:=0 To OptionsForm.LB.Items.Count-1 Do
 Begin
  Writeln(F, OptionsForm.LB.Items[I]);
 End;
 CloseFile(F);
 SaveIniFile('Settings\config.ini');
 SetLength(Ops, 0);
 SetLength(OpsList, 0);
 SetLength(BanUsersIP, 0);
 SetLength(BanUsersName, 0);
 Assign(F, 'Settings\OpList.txt');
 ReWrite(F);
 I:=0;
 While I<=OptionsForm.OOps.Items.Count-1 Do
 Begin
  WriteLn(F, OptionsForm.OOps.Items.Item[I].Caption+';#'+OptionsForm.OOps.Items.Item[I].SubItems[0]);
  Inc(I);
 End;
 Close(F);
 Assign(F, 'Settings\BanIP.txt');
 ReWrite(F);
 I:=0;
 While I<=OptionsForm.OBanIP.Items.Count-1 Do
 Begin
  T:=StrToFloat(OptionsForm.OBanIP.Items.Item[I].SubItems[0]);
  A:=Time+T*60*OneSec;
  B:=Date;
  If A>1 Then
  Begin
   B:=B+Trunc(A);
   A:=A-Trunc(A);
  End;
  Write(F, OptionsForm.OBanIP.Items.Item[I].Caption+';#'+FloatToStr(B)+';#'+FloatToStr(A));
  Inc(I);
 End;
 Close(F);
 Assign(F, 'Settings\BanName.txt');
 ReWrite(F);
 I:=0;
 While I<=OptionsForm.OBanName.Items.Count-1 Do
 Begin
  T:=StrToInt64(OptionsForm.OBanName.Items.Item[I].SubItems[0]);
  A:=Time+T*60*OneSec;
  B:=Date;
  If A>1 Then
  Begin
   B:=B+Trunc(A);
   A:=A-Trunc(A);
  End;
  Write(F, OptionsForm.OBanName.Items.Item[I].Caption+';#'+FloatToStr(B)+';#'+FloatToStr(A));
  Inc(I);
 End;
 Close(F);
 Assign(F, 'Settings\CoolNames.txt');
 ReWrite(F);
 I:=0;
 While I<=OptionsForm.OCoolName.Items.Count-1 Do
 Begin
  WriteLn(F, OptionsForm.OCoolName.Items.Item[I].Caption+';#'+OptionsForm.OCoolName.Items.Item[I].SubItems[0]);
  Inc(I);
 End;
 Close(F);
 LoadOpList;
 LoadBanIP;
 LoadBanName;
 LoadCoolName;
 Init;
 RegBot(BotName, '', '');
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
End;

Procedure Load;

Var I: Integer;
    T, A, B: Extended;

Begin
 Edit:=True;
 OptionsForm.ScriptEdit.Lines.Clear;
 OptionsForm.Edit1.Text:=HubName;
 OptionsForm.Edit2.Text:=HubTopic;
 OptionsForm.Edit3.Text:=BotName;
 OptionsForm.Edit7.Text:=HubMinShare;
 OptionsForm.Edit6.Text:=IntToStr(CountLastMessages);
 OptionsForm.Edit8.Text:='';
 for I := 0 to High(HubPort) do
   OptionsForm.Edit8.Text:=OptionsForm.Edit8.Text+IntToStr(HubPort[I])+';';
 OptionsForm.Edit13.Text:=UpHost;
 OptionsForm.CheckBox1.Checked:=AutoCheck;
 OptionsForm.LB.Items.Clear;
 OptionsForm.CheckBox3.Checked:=AutoMinimaze;
 OptionsForm.CheckBox2.Checked:=AutoRun;
 OptionsForm.CheckBox4.Checked:=AutoLog;
 For I:=0 To High(Files) Do
 Begin
  OptionsForm.LB.Items.Add(Files[I].FileName);
 End;
 OptionsForm.OOps.Items.Clear;
 OptionsForm.OBanIP.Items.Clear;
 OptionsForm.OBanName.Items.Clear;
 OptionsForm.OCoolName.Items.Clear;
 For I:=0 To High(OpsList) Do
 Begin
  OptionsForm.OOps.Items.Add;
  OptionsForm.OOps.Items.Item[I].Caption:=OpsList[I].Name;
  OptionsForm.OOps.Items.Item[I].SubItems.Add(IntToStr(OpsList[I].Rights));
 End;
 For I:=0 To High(BanUsersIP) Do
 Begin
  OptionsForm.OBanIP.Items.Add;
  OptionsForm.OBanIP.Items.Item[I].Caption:=BanUsersIP[I].IP;
  A:=BanUsersIP[I].Date-Date;
  B:=BanUsersIP[I].Time-Time;
  A:=A+B;
  OptionsForm.OBanIP.Items.Item[I].SubItems.Add(FloatToStr(Trunc(A/OneSec/60*100)/100));
 End;
 For I:=0 To High(BanUsersName) Do
 Begin
  OptionsForm.OBanName.Items.Add;
  OptionsForm.OBanName.Items.Item[I].Caption:=BanUsersName[I].Name;
  A:=BanUsersIP[I].Date-Date;
  B:=BanUsersIP[I].Time-Time;
  A:=A+B;
  OptionsForm.OBanName.Items.Item[I].SubItems.Add(FloatToStr(Trunc(A/OneSec/60*100)/100));
 End;
 For I:=0 To High(CoolUsers) Do
 Begin
  OptionsForm.OCoolName.Items.Add;
  OptionsForm.OCoolName.Items.Item[I].Caption:=CoolUsers[I].Name;
  OptionsForm.OCoolName.Items.Item[I].SubItems.Add(CoolUsers[I].CoolName);
 End;
 OptionsForm.TabbedNotebook1.PageIndex:=2;
 OptionsForm.TabbedNotebook1.PageIndex:=0;
End;

procedure TOptionsForm.Button2Click(Sender: TObject);
begin
 OptionsForm.Close;
end;

procedure TOptionsForm.Button1Click(Sender: TObject);

var F: TextFile;

begin
 If Edited<>'' Then
 Begin
  AssignFile(F, Edited);
  Rewrite(F);
  WriteLn(F, ScriptEdit.Lines.Text);
  CloseFile(F);
 End;
 Save;
 Button2Click(Button1);
end;

procedure TOptionsForm.Button3Click(Sender: TObject);

var F: TextFile;

begin
 If Edited<>'' Then
 Begin
  AssignFile(F, Edited);
  Rewrite(F);
  WriteLn(F, ScriptEdit.Lines.Text);
  CloseFile(F);
 End;
 Save;
end;

procedure TOptionsForm.LBDblClick(Sender: TObject);

Var I: Integer;
    F: TextFile;

begin
 If (RChanged)And(Edited<>'') Then
 Begin
  I:=MessageBox(Application.Handle, 'Вы хотите сохранить?? или вы промахнулись??', 'Сохранение', MB_YESNOCANCEL);
  If I=IDYES Then //Yes
  Begin
   AssignFile(F, Edited);
   Rewrite(F);
   WriteLn(F, ScriptEdit.Lines.Text);
   CloseFile(F);
   if FileExists(LB.Items[I]) then
   begin
    ScriptEdit.Lines.LoadFromFile(LB.Items[I]);
    Edit:=True;
    Syntax(ScriptEdit, Rezerved, Skobki, clBlack, []);
    Edit:=False;
   end else
    ScriptEdit.Lines.Clear;
   Edited:=LB.Items[I];
  End;
  If I=IDNO Then //NO
  Begin
   if FileExists(LB.Items[I]) then
   begin
    ScriptEdit.Lines.LoadFromFile(LB.Items[I]);
    Edit:=True;
    ScriptEdit.Lines.BeginUpdate;
    Syntax(ScriptEdit, Rezerved, Skobki, clBlack, []);
    ScriptEdit.Lines.EndUpdate;
    Edit:=False;
   end else
    Scriptedit.Lines.Clear;
   Edited:=LB.Items[I];
  End;
  If I=IDCANCEL Then //Cancel
  Begin
 {  For I:=0 To LB.Items.Count-1 Do
    If LB.Selected[I] Then
     Edited:=LB.Items.Strings[I];
   For I:=0 To LB.Items.Count-1 Do
   Begin
    If LB.Selected[I] Then
    Begin
     ScriptEdit.Lines.LoadFromFile(LB.Items[I]);
     Break;
    End;
   End;
   RChanged:=False;
   Edited:='';
   For I:=0 To LB.Items.Count-1 Do
    If LB.Selected[I] Then
     Edited:=LB.Items.Strings[I];}
  End;
 End Else
 Begin
  RChanged:=False;
  For I:=0 To LB.Items.Count-1 Do
  Begin
   If LB.Selected[I] Then
   Begin
    if FileExists(LB.Items[I]) then
    begin
     ScriptEdit.Lines.LoadFromFile(LB.Items[I]);
     Edit:=True;
     ScriptEdit.Lines.BeginUpdate;
     Syntax(ScriptEdit, Rezerved, Skobki, clBlack, []);
     ScriptEdit.Lines.EndUpdate;
     Edit:=False;
    end else
     Scriptedit.Lines.Clear;
    Edited:=LB.Items[I];
    Break;
   End;
  End;
  For I:=0 To LB.Items.Count-1 Do
   If LB.Selected[I] Then
    Edited:=LB.Items.Strings[I];
 End;
end;

procedure TOptionsForm.Button5Click(Sender: TObject);

Var S: String;

begin
 S:=GetCurrentDir;
 If OpenDialog1.Execute Then
  LB.Items.Add(OpenDialog1.FileName);
 SetCurrentDir(S);
end;

procedure TOptionsForm.Button4Click(Sender: TObject);

var I: LongInt;

begin
 For I:=0 To LB.Items.Count-1 Do
  If LB.Selected[I] Then
  begin
   if Edited=LB.Items.Strings[I] then
   begin
     Edited:='';
   end;
   Break;
  end;
 LB.DeleteSelected;
end;

procedure TOptionsForm.Button6Click(Sender: TObject);

Var F: TextFile;

begin
 If Edited<>'' Then
 Begin
  AssignFile(F, Edited);
  Rewrite(F);
  WriteLn(F, ScriptEdit.Lines.Text);
  CloseFile(F);
 End;
end;

procedure TOptionsForm.RichEdit1Change(Sender: TObject);
begin
 RChanged:= True;
end;

procedure TOptionsForm.ScriptEditChange(Sender: TObject);
begin
  Ti:=Time;
  if Not Edit then
  begin
    Edit:=True;
    Syntax(ScriptEdit, Rezerved, Skobki, clBlack, []);
    Edit:=False;
  end;
end;

procedure TOptionsForm.Button7Click(Sender: TObject);
begin
 AddForm.Label1.Caption:='Ник: ';
 AddForm.Label2.Caption:='Права (>0, <=10): ';
 AddForm.Caption:='Добавить Админа';
 Add.AddForm.ShowModal;
 If (Ed1<>'')And(Ed2<>'') Then
 Begin
  OOps.Items.Add;
  OOps.Items.Item[OOps.Items.Count-1].Caption:=Ed1;
  OOps.Items.Item[OOps.Items.Count-1].SubItems.Add(Ed2);
 End;
end;

procedure TOptionsForm.Button9Click(Sender: TObject);
begin
 AddForm.Label1.Caption:='ИП: ';
 AddForm.Label2.Caption:='На сколько (минуты): ';
 AddForm.Caption:='Забанить по ИП';
 AddForm.ShowModal;
 If (Ed1<>'')And(Ed2<>'') Then
 Begin
  OBanIP.Items.Add;
  OBanIP.Items.Item[OBanIP.Items.Count-1].Caption:=Ed1;
  OBanIP.Items.Item[OBanIP.Items.Count-1].SubItems.Add(Ed2);
 End;
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
begin
 LoadRezerved;
end;

procedure TOptionsForm.Button12Click(Sender: TObject);
begin
 AddForm.Label1.Caption:='Ник: ';
 AddForm.Label2.Caption:='На сколько (минуты): ';
 AddForm.Caption:='Забанить по Нику';
 AddForm.ShowModal;
 If (Ed1<>'')And(Ed2<>'') Then
 Begin
  OBanName.Items.Add;
  OBanName.Items.Item[OBanName.Items.Count-1].Caption:=Ed1;
  OBanName.Items.Item[OBanName.Items.Count-1].SubItems.Add(Ed2);
 End;
end;

procedure TOptionsForm.Button13Click(Sender: TObject);
begin
 AddForm.Label1.Caption:='Ник: ';
 AddForm.Label2.Caption:='Новый Ник: ';
 AddForm.Caption:='Переименовка';
 AddForm.ShowModal;
 If (Ed1<>'')And(Ed2<>'') Then
 Begin
  OCoolName.Items.Add;
  OCoolName.Items.Item[OCoolName.Items.Count-1].Caption:=Ed1;
  OCoolName.Items.Item[OCoolName.Items.Count-1].SubItems.Add(Ed2);
 End;
end;

procedure TOptionsForm.Button14Click(Sender: TObject);

Var I: LongInt;

begin
 I:=0;
 While I<=OCoolName.Items.Count-1 Do
 Begin
  If OCoolName.Items.Item[I].Selected Then
  Begin
   OCoolName.Items.Item[I].Delete;
   Dec(I);
  End;
  Inc(I);
 End;
end;

procedure TOptionsForm.Button15Click(Sender: TObject);
begin
 MainForm.UpSocket.Close;
 MainForm.UpSocket.Host:=Edit13.Text;
 MainForm.UpSocket.Open;
end;

procedure TOptionsForm.Button8Click(Sender: TObject);

Var I: LongInt;

begin
 I:=0;
 While I<=OOps.Items.Count-1 Do
 Begin
  If OOps.Items.Item[I].Selected Then
  Begin
   OOps.Items.Item[I].Delete;
   Dec(I);
  End;
  Inc(I);
 End;
end;

procedure TOptionsForm.Button10Click(Sender: TObject);

Var I: LongInt;

begin
 I:=0;
 While I<=OBanIP.Items.Count-1 Do
 Begin
  If OBanIP.Items.Item[I].Selected Then
  Begin
   OBanIP.Items.Item[I].Delete;
   Dec(I);
  End;
  Inc(I);
 End;
end;

procedure TOptionsForm.Button11Click(Sender: TObject);

Var I: LongInt;

begin
 I:=0;
 While I<=OBanName.Items.Count-1 Do
 Begin
  If OBanName.Items.Item[I].Selected Then
  Begin
   OBanName.Items.Item[I].Delete;
   Dec(I);
  End;
  Inc(I);
 End;
end;

procedure TOptionsForm.ScriptEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);

var Be, Len: LongInt;
    F: TextFile;
    T, Te: String;
    I: LongInt;

begin
  if (ssCtrl in Shift) and (Key = ord('S')) then
  begin
    if Edited<>'' then
    begin
      AssignFile(F, Edited);
      Rewrite(F);
      WriteLn(F, ScriptEdit.Lines.Text);
      CloseFile(F);
    end;
  end;

{  if Key=13 then
  begin
//    key:=0;
    T:='';
//    Te:=Copy(ScriptEdit.Lines[ScriptEdit.CaretPos.Y], ScriptEdit.CaretPos.X+1, Length(ScriptEdit.Lines[ScriptEdit.CaretPos.Y]));
    for I:=1 To Length(ScriptEdit.Lines[ScriptEdit.CaretPos.Y-1]) do
    begin
      if ScriptEdit.Lines[ScriptEdit.CaretPos.Y-1][I]<>' ' then Break;
      T:=T+' ';
    end;
    ScriptEdit.Lines[ScriptEdit.CaretPos.Y]:=T+ScriptEdit.Lines[ScriptEdit.CaretPos.Y];
  end;
{  if (ssCtrl in Shift) and (Key = ord('V')) then Syntax(ScriptEdit, Rezerved, Skobki, clBlack, [], True)
  else
  begin
    GetWord(ScriptEdit.Text, Be, Len);
    if CheckWord(S) then
  end;}
end;

procedure TOptionsForm.Timer1Timer(Sender: TObject);

var A, B: Extended;
    I: LongInt;
    
begin
 if (not OOps.Focused)and(not Button8.Focused) then
 begin
  OptionsForm.OOps.Items.Clear;
  For I:=0 To High(OpsList) Do
  Begin
   OptionsForm.OOps.Items.Add;
   OptionsForm.OOps.Items.Item[I].Caption:=OpsList[I].Name;
   OptionsForm.OOps.Items.Item[I].SubItems.Add(IntToStr(OpsList[I].Rights));
  End;
 end;
 if (not OBanIP.Focused)and(not Button10.Focused) then
 begin
  OptionsForm.OBanIP.Items.Clear;
  For I:=0 To High(BanUsersIP) Do
  Begin
   OptionsForm.OBanIP.Items.Add;
   OptionsForm.OBanIP.Items.Item[I].Caption:=BanUsersIP[I].IP;
   A:=BanUsersIP[I].Date-Date;
   B:=BanUsersIP[I].Time-Time;
   A:=A+B;
   OptionsForm.OBanIP.Items.Item[I].SubItems.Add(FloatToStr(Trunc(A/OneSec/60*100)/100));
  End;
 end;
 if (not OBanName.Focused)and(not Button11.Focused) then
 begin
  OptionsForm.OBanName.Items.Clear;
  For I:=0 To High(BanUsersName) Do
  Begin
   OptionsForm.OBanName.Items.Add;
   OptionsForm.OBanName.Items.Item[I].Caption:=BanUsersName[I].Name;
   A:=BanUsersIP[I].Date-Date;
   B:=BanUsersIP[I].Time-Time;
   A:=A+B;
   OptionsForm.OBanName.Items.Item[I].SubItems.Add(FloatToStr(Trunc(A/OneSec/60*100)/100));
  End;
 end;
 if (not OCoolName.Focused)and(not Button14.Focused) then
 begin
  OptionsForm.OCoolName.Items.Clear;
  For I:=0 To High(CoolUsers) Do
  Begin
   OptionsForm.OCoolName.Items.Add;
   OptionsForm.OCoolName.Items.Item[I].Caption:=CoolUsers[I].Name;
   OptionsForm.OCoolName.Items.Item[I].SubItems.Add(CoolUsers[I].CoolName);
  End;
 end;
end;

end.
