BotName="<Commander>";
BotDesc = "���� ����� ����"
BotEmail = "killbill@microsoft.com"
max=0
min=0

function UserMenu(User) -- ���� �������� ������������
 SendToNick(User.sName, "$UserCommand 1 2 ���� ����\\�����������\\�����������$<%[mynick]> !reg %[nick];#%[line:������]&#124;|"..
"$UserCommand 1 2 ���� ����\\�����������\\������� ������������������� �����������$<%[mynick]> !DelReg %[nick]&#124;|"..
"$UserCommand 1 1 ���� ����\\�����������\\����������� $<%[mynick]> !reg %[line:���];#%[line:������]&#124;|"..
"$UserCommand 1 1 ���� ����\\�����������\\������� ������������������� �����������$<%[mynick]> !DelReg %[line:���]&#124;|"..
"$UserCommand 1 3 ���� ����\\�������� ��������� �������������$<%[mynick]> !BannedUsers&#124;|"..
"$UserCommand 1 3 ���� ����\\������� ����$<%[mynick]> +rules&#124;|"..
"$UserCommand 1 3 ���� ����\\������-����� FAQ $<%[mynick]> +faq&#124;|"..
"$UserCommand 1 2 ���� ����\\��������� � ������� �� ����$<%[mynick]> +msgname %[nick];#%[mynick];# %[line:���������]&#124;|"..
"$UserCommand 1 1 ���� ����\\��������� � ������� �� ����$<%[mynick]> +msgname %[line:���������� (���)];#%[mynick];# %[line:���������]&#124;|"..
"$UserCommand 1 2 ���� ����\\��������� � ������� �� �������$<%[mynick]> +msgip %[line:���������� (IP)];#%[mynick];# %[line:���������]&#124;|"..
"$UserCommand 1 1 ���� ����\\��������� � ������� �� �������$<%[mynick]> +msgip %[line:���������� (IP)];#%[mynick];# %[line:���������]&#124;|"..
"$UserCommand 1 3 ���� ����\\����������\\��� IP$<%[mynick]> +myip&#124;|"..
"$UserCommand 1 3 ���� ����\\����������\\��� Info$<%[mynick]> +myinfo&#124;|", "");
end;

function OpMenu(User) -- ���� ������
 SendToNick(User.sName, "$UserCommand 1 2 ���� ����������\\������� $$Kick %[nick]&#124;|"..
"$UserCommand 1 2 ���� ����������\\�������� �� ����$<%[mynick]> +BanName %[nick];#%[line:�� �����]&#124;|"..
"$UserCommand 1 2 ���� ����������\\�������� �� �������$<%[mynick]> +BanIP %[line:��];#%[line:�� �����]&#124;|"..
"$UserCommand 1 2 ���� ����������\\��������� �� ����$<%[mynick]> -BanName %[nick]&#124;|"..
"$UserCommand 1 2 ���� ����������\\��������� �� �������$<%[mynick]> -BanIP %[line:��]&#124;|"..
"$UserCommand 1 2 ���� ����������\\�������� ���$<%[mynick]> +AddOp %[nick];#%[line:�����]&#124;|"..
"$UserCommand 1 2 ���� ����������\\������� ���$<%[mynick]> -DelOp %[nick]&#124;|"..
"$UserCommand 1 1 ���� ����������\\�������$$Kick %[line:���]&#124;|"..
"$UserCommand 1 1 ���� ����������\\�������� �� ����$<%[mynick]> +BanName %[line:���];#%[line:�� �����]&#124;|"..
"$UserCommand 1 1 ���� ����������\\�������� �� �������$<%[mynick]> +BanIP %[line:��];#%[line:�� �����]&#124;|"..
"$UserCommand 1 1 ���� ����������\\��������� �� ����$<%[mynick]> -BanName %[line:���]&#124;|"..
"$UserCommand 1 1 ���� ����������\\��������� �� �������$<%[mynick]> -BanIP %[line:��]&#124;|"..
"$UserCommand 1 1 ���� ����������\\�������� ���$<%[mynick]> +AddOp %[line:���];#%[line:�����]&#124;|"..
"$UserCommand 1 1 ���� ����������\\������� ���$<%[mynick]> -DelOp %[line:���]&#124;|"..
"$UserCommand 1 3 ���� ����������\\�������$<%[mynick]> +ReKlAmA  %[line:�����]&#124;|", "");

end;

function Maxim(s)
 fr = string.find(s,">")+1;
 t=string.sub(s, 1, fr-1);
 for i=fr, string.len(s) do
  ch=UpCase(string.sub(s, i, i));
  t=t..ch;
 end;
 return t;
end;

function Minim(s)
 fr = string.find(s,">")+1;
 t=string.sub(s, 1, fr-1);
 for i=fr, string.len(s) do
  ch=LowCase(string.sub(s, i, i));
  t=t..ch;
 end;
 return t;
end;

function DataArrival(User, Data)
-- ���������� ������ �� ��
 if string.sub(Data,1,1)=="<" then
  s = string.find(Data,">");
  IsCom=0;
  if (s>0) then
   cmd=string.sub(Data, s+2, string.len(Data));
   if (cmd=="!online") then
    User:SendData(BotName.." ��� �������� "..GetUpTime());
    BlockSend();
    IsCom=1;
   end;
 
   if (cmd=="+maximaze") then
    SendToAll(BotName.." ������������ "..User.sName.." ������� MAXIMAZE!!!", "");
    max=1;
    BlockSend();
    IsCom=1;
   end;
   if (cmd=="-maximaze") then
    SendToAll(BotName.." ������������ "..User.sName.." �������� MAXIMAZE!!!", "");
    max=0;
    BlockSend();
    IsCom=1;
   end; 

   if (cmd=="+minimaze") then
    SendToAll(BotName.." ������������ "..User.sName.." ������� MINIMAZE!!!", "");
    min=1;
    BlockSend();
    IsCom=1;
   end;
   if (cmd=="-minimaze") then
    SendToAll(BotName.." ������������ "..User.sName.." �������� MINIMAZE!!!", "");
    min=0;
    BlockSend();
    IsCom=1;
   end; 

   if IsCom==0 then
    if (max==1)and(IsCom==0) then
     t=Maxim(Data);
     SendToAll(t, "");
     BlockSend();
     IsCom=1;
    end;
    if (min==1)and(IsCom==0) then
     t=Minim(Data);
     SendToAll(t, "");
     BlockSend();
     IsCom=1;
    end;
   end;
  end;
 end;
end;

function NewUserConnected(User)
 UserMenu(User);
end;

function OpConnected(User)
 UserMenu(User);
 OpMenu(User);
end;

function Main()
 RegBot(BotName, 0, BotDesc, BotEmail);
end;

