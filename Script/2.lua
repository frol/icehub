--Snowball War 1.0g3 LUA 5
--
--User Settings----------------------------------------------------------------------------------------------------------------
--
--//-- Botname pulled from the hub
SnowBot = "{����}"
--//-- Command Prefix
Prefix = "!"
--//-- Throw a snowball
SnowCmd = "sb"
--//-- Take liberty [off active duty]
SnowLiberty = "sl"
--//-- Get scores
ScoresCmd = "ss"
--//-- Buy Upgrade(s)
UpgradeCmd = "su"
--//-- Display Upgrade(s)
ShowUpgrade = "ups"
--//-- Menu name pulled from hub, uses hub name for menu
SnowMenu = frmHub:GetHubName()
--//-- Custom submenu
SnowSubMenu = "������"
--//-- Filename for user data
SnowFile="SnowTable3.dat"
--//-- Declaration of War message
WarCry = "\r\n\r\n������� ������ �����!"
--//-- Inactivity time (in minutes) to declare time of peace.
WarEndTime = 20
--//-- Minimum time (in seconds) a user must wait before be able to throw again.
WaitTime = 10
--//--Set your profiles permissions here.
--profile_idx, Commands/Menus enabled [0=no 1=yes], "Profile Name"
SnowProfiles = {
[-1] = {1,"�������������������� ������������"},
[4] = {1,"������"},
[3] = {1,"��������"},
[1] = {1,"VIP"},
[0] = {1,"������������������ ������������"},
}

--//Player Upgrades [idx] = {"Upgrade Name", point cost}
Upgrades={
[1] = {"������� ������� 1",25},
[2] = {"������� ������� 2",50},
[3] = {"���������� �������� 1",25},
[4] = {"���������� �������� 2",50},
[5] = {"�������� �����",75},
}

--//����� �������
Rankings = {
[1] = {10, "��������"},
[1] = {25, "��������"},
[2] = {50, "������� �������"},
[3] = {75, "�������"},
[4] = {100, "������� �������"},
[5] = {150, "��������"},
[6] = {200, "������� ���������"},
[7] = {300, "���������"},
[8] = {400, "������� ���������"},
[9] = {500, "�������"},
[10] = {700, "�����"},
[11] = {1000, "������������"},
[12] = {1300, "���������"},
[13] = {1500, "�������-�����"},
[14] = {1800, "�������-���������"},
[15] = {1900, "�������-���������"},
[16] = {2000, "������"},
[17] = {2001, "��������������"},
}

--//����� �������
Rankings = {
[1] = {10, "��������"},
[1] = {25, "��������"},
[2] = {50, "������� �������"},
[3] = {75, "�������"},
[4] = {100, "������� �������"},
[5] = {150, "��������"},
[6] = {200, "������� ���������"},
[7] = {300, "���������"},
[8] = {400, "������� ���������"},
[9] = {500, "�������"},
[10] = {700, "�����"},
[11] = {1000, "������������"},
[12] = {1300, "���������"},
[13] = {1500, "�������-�����"},
[14] = {1800, "�������-���������"},
[15] = {1900, "�������-���������"},
[16] = {2000, "������"},
[17] = {2001, "��������������"},
}

--//-- Set your hit/miss responses here
Hit = {
"���� ����, user1 ������ ������� � ���� ���� user2.", 
"user1 ������� ������ � user2, ��� ������ ���� ������!", 
"user2 �� ������,�� ������� user1 �! �� ����� ��� � ���� ��� ������� �� �����'.", 
"user1 ����� user2, ��� ����� ���� ��������� � �� ����.",
"user1 ���� ����� �� ���� user2 � ������� ������ ��� � ����.", 
"�����������, user1 ������ ������ ��� �� ���� ���������� ��� user2 � ����������� ��� ���� ����� ���������.", 
"user1 ,� ��� � � ��� �� ������� '�������' ������ user2's ���� � ������� ������� ���� ����.", 
"������� ������������ ������� � ������� �� user1, user2 ��������� '��, �� ����! ' � ������� ���.", 
"'� ���,������ �� Headshot � ������!!!', ����� user2, �� user1 �������� ������� � ������!", 
"user1 �������� ������� � ��� user2 - ��shot!", 
}

Miss = {
"user2 ����������, '�� ������ � ���� ������ user1?, � ������, '�� ������ � ����!? �� �� ��������� �����!..'", 
"user1 ������ � user2, �����������, � ��� ���������� �������� ��� ��� ����� �� ����� �������!", 
"user1 ,��� ����100 ���� ������ � ����, ����������� �� �� ���� � user2", 
"user2 ������ �� ������ �� user1 � ������� �� �� ����� �� �� ���....", 
"user2 ����� ������ �����,��� �� �� �������� '� ������ ������'�� user1", 
"��� ������� ��� user1 ������� ������� ������ � user2, ������� ������� �� ��������� ����.",
"user2 ���!������, ��� ��� user1 �� ����� ������ ������ ���� ���� ������� ����!.",  
"���������� �������� ������, user1  ������� ������ ������ � �������. user2'����� � ����� .",
"���� user1 ������ ���������� ������ ����� � ����, ������� user2 �������������! ����� � ������� ����!", 
"user2 ������ '��! �� �������� ������� ������� user1'",
"user2 �������� �� �����, �  ���������� �� ������, ����������� � user1",  
}
--
--End User Settings-------------------------------------------------------------------------------------------------------------

Players = {}
Throw = {0,1,0,1,0,1,0,0,0,0}

Main = function()
	if SnowBot ~= frmHub:GetHubBotName() then
		frmHub:RegBot(SnowBot, 1, "[����] ������ ������", "")
	end
	if loadfile(SnowFile) ~= nil then
		dofile(SnowFile)
	else
		local startdate,starttime =os.date("%B %d %Y"),os.date("%X")
		SnowTable ={}
		SnowTable["start"]={startdate,starttime}
		Save_File(SnowFile,SnowTable,"SnowTable")
	end
GameOn = 0
WarEndTime = WarEndTime * 60
GetRank()
end

OnExit = function()
Save_File(SnowFile,SnowTable,"SnowTable")
	if SnowBot ~= frmHub:GetHubBotName() then
		frmHub:UnregBot(SnowBot)
	end
end

NewUserConnected = function(user, data)
	if SnowProfiles[user.iProfile][1] == 1 then
		Commands(user)
		user:SendData(SnowBot, SnowProfiles[user.iProfile][2].." Snowball fight ������� ������������. ������� ������ ������ ���� �� ������ ������������, ����� ����������� � ������� ����.")
	end
end

OpConnected = NewUserConnected

ChatArrival = function(user, data)
local s,e,pre,cmd = string.find(data, "^%b<>%s+(%p)(%w+)")
local s,e,nick = string.find(data, "^%b<>%s+%p%w+%s(%S+)|$")
	if pre and pre==Prefix then
		if cmd and cmd==ScoresCmd then
			if SnowProfiles[user.iProfile] and SnowProfiles[user.iProfile][1] == 1 then
				local Scores = "\r\n\r\n\t�Snowball Fight ��ϕ\r\n\r\n"..string.rep("�",105).."\r\n"
				for i,v in SnowTable do
					if i ~= "start" then
						local rank = ""
						GetRank()
						local pct = ""
						if v[1] <= 0 then
							pct = "<0.00 %"
						else
							pct = 100 - (v[2] / (v[1] + v[2])) * (100 / 1 )
							pct = string.format("%.2f %%",pct)
						end
						local usr,hit,miss,rank,away,pwr,aim,shield = i,v[1],v[2],v[4],v[3],v[5],v[6],v[7]
						Scores = Scores.." � "..string.format("%-35.30s",usr).."\t���������: "..string.format("%-5.4d",hit).."  �������: "..
						string.format("%-5.4d",miss).."  ��������: "..string.format("%-4s",pct).."  ����: "..string.format("%2d",pwr)..
						"  ����: "..string.format("%2d",aim).."  ������: "..string.format("%2d",shield).."   ����: "..string.format("%-25s",rank).."\r\n"
					end
				end
					user:SendData(SnowBot, Scores.."\r\n"..string.rep("�",105).."\r\n\t������ �������\r\n\r\n")
					return 1
			else
				user:SendData("\r\n\r\n\t�������� "..user.sName.." ������� ' "..Prefix..ScoresCmd..
				" ' �� �������� ��� "..SnowProfiles[user.iProfile][2].."\r\n")
				return 1
			end
		elseif cmd and cmd==UpgradeCmd then
			if SnowProfiles[user.iProfile] and SnowProfiles[user.iProfile][1] == 1 then
				if SnowTable[user.sName] then
					local s,e,buy = string.find(data, "^%b<>%s+%p%w+%s(%d)|$")
					if buy then
						buy = tonumber(buy)
						if Upgrades[buy] then
							local upgrade,cost = Upgrades[buy][1],Upgrades[buy][2]
							if SnowTable[user.sName][1] >= cost then
								SnowTable[user.sName][1] = SnowTable[user.sName][1] - cost
								if buy == 1 and SnowTable[user.sName][5] ~= 1 then
									SnowTable[user.sName][5] = 1
								elseif buy == 2 and SnowTable[user.sName][5] ~= 2 then
									SnowTable[user.sName][5] = 2
								elseif buy == 3 and SnowTable[user.sName][6] ~= 1 then
									SnowTable[user.sName][6] = 1
								elseif buy == 4 and SnowTable[user.sName][6] ~= 2 then
									SnowTable[user.sName][6] = 2
								elseif buy == 5 and SnowTable[user.sName][7] ~= 1 then
									SnowTable[user.sName][7] = 1
								else
									user:SendData(SnowBot,"\r\n\t"..SnowTable[user.sName][4].." "..user.sName.." �� ���"..
									" ������ ������� "..upgrade..".")
									return 1
								end
								user:SendData(SnowBot,"\r\n\t"..SnowTable[user.sName][4].." "..user.sName.." �� ������ ��� "..
								"��������� "..upgrade..".\r\n\t"..cost.." ����� � ��� ���� �����.")
								GetRank()
								return 1
							else
								user:SendData(SnowBot,"\r\n\t�������� "..SnowTable[user.sName][4].." "..
								user.sName..", �� �� ������ ���������� ������� "..upgrade..".\r\n\t����  ������� ����� "..
								cost.." �����, � � ��� ������ "..SnowTable[user.sName][1].." �����.")
								return 1
							end
						else
							user:SendData(SnowBot,"***������ = "..Prefix..UpgradeCmd.." <#>\t"..
							"��� '#' - ����� ����� 1 � 5")
							return 1
						end
					else
						user:SendData(SnowBot,"***������ = "..Prefix..UpgradeCmd.." <#>\t"..
						"��� '#' ����� ����� 1 � 5")
						return 1
					end
				else
					user:SendData(SnowBot,"\r\n\r\n\t�������� "..user.sName..", �������� ���������� "..
					"� ������� ��������� �����. �� ������ ������, ����� �������� ����.\r\n")
					return 1
				end
			else
				user:SendData(SnowBot,"\r\n\r\n\t�������� "..user.sName.." ������� ' "..Prefix..UpgradeCmd..
				" ' �� �������� ��� "..SnowProfiles[user.iProfile][2].."'s\r\n")
				return 1
			end
		elseif cmd and cmd==SnowCmd then
			if SnowProfiles[user.iProfile] and SnowProfiles[user.iProfile][1] == 1 then
				if SnowTable[user.sName] and SnowTable[user.sName][3] == 1 then
					local reply = user.sName.." �� �� ������ �������������� � ����, ���� �� ���������� � ����. "..
					"����� �������� � ����� ������� ' "..Prefix..SnowLiberty.." '"
					user:SendData(SnowBot,reply)
					return 1
				end
				local start = os.clock()
				if Players[user.sName] then
					local interval = Players[user.sName]
					if os.difftime(os.clock(), interval) < WaitTime then
						local reply = "���!! ���������� ���� ���! �� ������ ��������� "..WaitTime.." ������, ������ ��� ����� ������� ������� ������."
						user:SendData(SnowBot,reply)
						return 1
					end
				end
				if nick then
					local usrnick = GetItemByName(nick)
					if not usrnick then
						local reply = "������������ "..nick.." �� ������. ��������� ����� � ����, ��� ������ �� ����."
						user:SendData(SnowBot,reply)
						return 1
					elseif SnowTable[usrnick.sName] then
						if SnowTable[usrnick.sName][3] == 1 then
							local reply = "������������ "..nick.." ������ ��� - �� �� ���������� � �����. ���������� ��������� � ���-������ ������."
							user:SendData(SnowBot,reply)
							return 1
						end
					end
					if not SnowTable[user.sName] then
							SnowTable[user.sName]={0,0,0,Rankings[1][2],0,0,0}
					end
					if nick == user.sName then
						SnowTable[user.sName][1] = SnowTable[user.sName][1] - 1
						Save_File(SnowFile,SnowTable,"SnowTable")
						local reply = "� ��� �������� ���� ����, "..user.sName..", ����� ������ �� �� �������� ���� �����."
						SendToAll(SnowBot,reply)
						return 1
					end
					if GameOn == 0 then
						GameOn = 1
						WarStopTime = WarStartTime
						WarCry = WarCry.." ����� ��� �������, ��� ����� �����, �������, ��� ��� "..user.sName..".\r\n\r\n"
					else
						WarStopTime = math.floor(os.clock())
						WarCry = ""
							if (WarStopTime - WarStartTime) > WarEndTime then
								GameOn = 1
								WarCry = "\r\n\r\n����� ����� ��� "..(WarEndTime / 60).." ����� ���� "..
								user.sName.." ������ ����� ����� ������� ����� ������.\r\n\r\n"
							end
					end
					Players[user.sName]=start
					WarStartTime = os.clock()
					local toss = ""
					if SnowTable[user.sName][6] == 1 then
						if SnowTable[usrnick.sName] then
							if SnowTable[usrnick.sName][7] == 0 then
								toss =  Throw[math.random(1,4)]
							else
								toss =  Throw[math.random(5,10)]
							end
						else
							toss =  Throw[math.random(2,3)]
						end
					elseif SnowTable[user.sName][6] == 2 then
						if SnowTable[usrnick.sName] then
							if SnowTable[usrnick.sName][7] == 0 then
								toss =  Throw[math.random(4,6)]
							else
								toss =  Throw[math.random(6,10)]
							end
						else
							toss =  Throw[math.random(1,3)]
						end
					end
					if SnowTable[user.sName][6] == 0 and SnowTable[user.sName][7] == 0 then
						toss =  Throw[math.random(1,6)]
					end
					if toss == 0 then
						SnowTable[user.sName][2] = SnowTable[user.sName][2] + 1
						local result = Miss[math.random(1, table.getn(Miss))]
						result = string.gsub(result,"user1", user.sName)
						result = string.gsub(result,"user2", usrnick.sName)
						SendToAll(SnowBot,WarCry..result)
					else
						if GetRank(user.sName) ~= nil and GetRank(usrnick.sName) ~= nil
						and GetRank(user.sName) > GetRank(usrnick.sName) then
							if SnowTable[user.sName][5] == 1 then
								SnowTable[user.sName][1] = SnowTable[user.sName][1] + 3
							elseif SnowTable[user.sName][5] == 2 then
								SnowTable[user.sName][1] = SnowTable[user.sName][1] + 4
							else
								SnowTable[user.sName][1] = SnowTable[user.sName][1] + 2
							end
						else
							SnowTable[user.sName][1] = SnowTable[user.sName][1] + 1
						end
						local result = Hit[math.random(1, table.getn(Hit))]
						result = string.gsub(result,"user1", user.sName)
						result = string.gsub(result,"user2", usrnick.sName)
						SendToAll(SnowBot,WarCry..result)
					end
					Save_File(SnowFile,SnowTable,"SnowTable")
					return 1
				else
					user:SendData("\r\n\r\n\t������! ������� = "..Prefix..SnowCmd.." <���>\r\n")
					return 1
				end
			else
				user:SendData("\r\n\r\n\t�������� "..user.sName.." ������� ' "..Prefix..SnowCmd..
				" ' �� �������� ��� "..SnowProfiles[user.iProfile][2].."'s\r\n")
				return 1
			end
		elseif cmd and cmd == SnowLiberty then
			if SnowTable[user.sName] then
				if SnowTable[user.sName][3] == 0 then
					SnowTable[user.sName][3] = 1
					user:SendData(SnowBot,"OK! "..SnowTable[user.sName][4].." "..user.sName.." �� ������� ��� � ������ �� ����������� � ���������.")
					Save_File(SnowFile,SnowTable,"SnowTable")
					return 1
				elseif SnowTable[user.sName][3] == 1 then
					SnowTable[user.sName][3] = 0
					user:SendData(SnowBot,"OK! "..SnowTable[user.sName][4].." "..user.sName.." �� ����� ����� �� ����� �����.")
					Save_File(SnowFile,SnowTable,"SnowTable")
					return 1
				end
			else
				SnowTable[user.sName]={0,0,1,Rankings[1][2],0,0,0}
				user:SendData(SnowBot,"\r\n\t� �� ����, ��� �� ���� ���� �� ����� "..
				SnowTable[user.sName][4].." "..user.sName..".\r\n"..
				"\t�� �� ������ ������ �� ��������� � ������� ���.\r\n"..
				"\t������ ������� � �� ������ ������������!.")
				Save_File(SnowFile,SnowTable,"SnowTable")
				return 1
			end
		elseif cmd and cmd == ShowUpgrade then
			local ups = "\r\n\r\n\t��������� ��� ��� ��������\r\n"..
			"\t"..string.rep("�",32).."\r\n"
			for i,v in Upgrades do
				ups = ups.."\t"..i..".  "..string.format("%-18s",v[1]).."\t"..v[2].."  �����\r\n"
			end
			ups = ups.."\r\n\t"..string.rep("�",32).."\r\n"
			user:SendData(SnowBot,ups)
			return 1
		end
	end
end

function Commands(user)
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\������� ������ �... $<%[mynick]> "..Prefix..SnowCmd.." %[line:Nick]&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\������� ������ $<%[mynick]> "..Prefix..SnowCmd.." %[nick]&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\���� $<%[mynick]> "..Prefix..ScoresCmd.."&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\���/����� $<%[mynick]> "..Prefix..SnowLiberty.."&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\������� ������� $<%[mynick]> "..Prefix..UpgradeCmd.." %[line:1=����1, 2=����2, 3=����1, 4=����2, 5=���]&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\��������� �������� $<%[mynick]> "..Prefix..ShowUpgrade.."&#124;")
end

GetRank = function(nick)
	if nick then
		for a,b in Rankings do
			if SnowTable[nick] then
				if SnowTable[nick][4] == b[2] then
					return a
				end
			else
				return nil
			end
		end
	else
		for i,v in SnowTable do
			if i ~= "start" then
				for a,b in Rankings do
					if v[1] > b[1] and v[1] <= b[1] then
						v[4] = b[2]
					elseif v[1] > b[1] then
						v[4] = b[2]
					end
				end
			end
		end
		Save_File(SnowFile,SnowTable,"SnowTable")
	end
end

Save_Serialize = function(tTable, sTableName, hFile, sTab)
	sTab = sTab or "";
	hFile:write(sTab..sTableName.." = {\n" );
	for key, value in tTable do
		local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
		if(type(value) == "table") then
			Save_Serialize(value, sKey, hFile, sTab.."\t");
		else
			local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
			hFile:write( sTab.."\t"..sKey.." = "..sValue);
		end
		hFile:write( ",\n");
	end
	hFile:write( sTab.."}");
end

Save_File = function(file,table , tablename )
	local hFile = io.open (file , "w")
	Save_Serialize(table, tablename, hFile);
	hFile:close()
end

