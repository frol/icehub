--[[

	������ ��� LUA 5.0.2 / 5.1.1 by NRJ

	������� trigs ����� �� ������������ ������� �������� romiros'a
	��������� ������� ���� ����� �� NOYELL script �� NoNick'a

]]--

----------------------------------------------- ������������ -----------------------------------------------
------------------------------------------------------------------------------------------------------------

BotName = "<[debug.exe]>"		-- ��� ���� 
BotDesc = "���� ����� ����"	-- �������� ����
BotEmail = "killbill@microsoft.com"	-- email ����

-- ������� �����-����������,��� ����� ��� �� ����� ��������������
TableName = {
 ["���"] = 1,
 ["�������-���-���"] = 1,
}

-- �������: ����� ����� � ���� ��� ����� ��������������

--	������:
--
--	["��� ��������"]={
--	"[curUser], ������� ������ 1.",
--	"������� ������ 2.",
--	"������� ������ 3.",
--	},

trigs = {     

	["���"]={
	"[curUser], �� ���� ��������.",
	"�� ����� ����� � � ���.",
	"��� ���� �����������, ��� �� ��� ���.",
	"������������ - � ������ ������.",
	},

	["��"]={
	"[curUser], �� �����??",
	"� �������� ��������!!! ��������",
	},

	["��"]={
	"[curUser], �� ���� �� �����??",
	"[curUser], �� �� ��.��??",
	},

	["��"]={
	"[curUser], ��!!!",
	"[curUser], �� ���-�� � ������ �����.",
	},

	["�����"]={
	"[curUser], ��� ���� ��� ������ ���� ����� =)",
	"[curUser], �� ���������",
	},

	["must die"]={
	"[curUser], ��� ��� ���������.",
	"���������.",
	"WINDOWS MUST DIE",
	},

	["������ �����"]={
	"[curUser], ��� ��� ���.",
	"��� �� ���??.",
	"������������ - � ������ ������.",
	},

        ["dchub://"]={
	"[curUser], �� �� ������� ��������? ������.",
	"[curUser], �� ����� ����� � � ��� � �� ��� � ���� ��������.",
	"[curUser], �� �� � ���.",
	"[curUser], ����� ���������� - ������ .",
	},

	["���� ��� ���"]={
        "[curUser], ��� ��� �����.",
        "[curUser], �� �� ��� ���� ����� � �.",
	"��, � ����. ��� ����?",
	},

	["�� ���"]={
	"�������� �������. � �������� ��������.",
	"� �����, �� ���� �� ���� ������.",
	"��... ������� � ���� ������. ������������. ������ ������, �� ����� ����� ��������� ���	�����������.",
	},

	["���"]={
	"��! �� ���������� ���.",
	"� ��-������ �� ���� ��������?",
	"[curUser], ����� ������ �� ����� '����'."
	},

	["���"]={
	"������ ����������. �� � �����. �� � � ����� �� ���������."
	},
		
	["�����"]={
	"������ ����������. �� � �����. �� � � ����� �� ���������."
	},

	["���"]={
	"������ ����������. �� � �����. �� � � ����� �� ���������."
	},

	["������"]={
	"������ �� ������, � �� � �����. �� � � ����� �� ������."
	},

	["��"]={
	"��, ���������� �� ��-�����������."
	},

	["bye"]={
	"��, ���������� �� ��-�����������."
	},

	["fuck"]={
	"[curUser], ���� ������? ��� � ���� ���������� ��������."
	},

	["���"]={
	"[curUser], ���� ������? ��� � ���� ���������� ��������."
	},

	["��������"]={
	"��, ����� ��� �����?"
	},

	["�������"]={
	"��, ����� ��� �����?"
	},

	["bot"]={
	"��� �� �������� �����... � ��� ��� ��������?.."
	},

	["�����"]={
	"�� ������ ��� � ����. ���� ����� � ��� ��� ��������, ������ �� ����."
	},
		
	["����"]={
	"�� ������ ��� � ����. ���� ����� � ��� ��� ��������, ������ �� ����."
	},
		
	["���"]={
	"���� �� ������, � �� ������������."
	},

	["���"]={
	"\n         .-. \n      _( '' )_  \n      (_  :  _) \n        / ' \\ \n     (_/^\\_) \n "
	},

    ["������"]={
	"�� ����������� � ������....",
	},
}

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

Rus={["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]
="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�"}

--function OnTimer()
-- SendToAll(BotName, "���� ������ ����� :(");
--end

function Main()
 TableMaxSize = table.getn;
 frmHub:RegBot(BotName, 1, BotDesc, BotEmail)
-- SetTimer(180000);
-- StartTimer();
 return 0;
end

function ChatArrival(User, data)
	d=data;
	if TableName[User.sName] ~=1 then if string.sub(data, 1, 1) then
		data=string.sub(data,1,string.len(data)-1)
		s,e,cmd,RestOfText = string.find( data, "%b<>%s+(%S+)%s+(.*)" )                          
		if RestOfText == nil then
			RestOfText = ""						
						 
			s,e,cmd = string.find( data, "%b<>%s+(%S+)" )			
				 
		end
	end
		s,e,mess = string.find(data, "^%b<>%s(.*)$")
		for key in pairs(trigs) do
--			if mess then
				data=d;
				for b,s in pairs(Rus) do
 					data=string.gsub(data , b, Rus[b]);
					if( string.find(data, key) ) then
						answer, x = string.gsub(trigs[key][math.random(1,TableMaxSize(trigs[key]))], "%b[]", curUser.sName);
						SendToAll(BotName, answer )	
				 			
						return 1;
					end
				end
mess=d;
				if( string.find( string.lower(mess), key) ) then
					answer, x = string.gsub(trigs[key][math.random(1,TableMaxSize(trigs[key]))], "%b[]", curUser.sName)
					SendToAll(BotName, answer);
					return 1
				end
--			end
		end
	end
end