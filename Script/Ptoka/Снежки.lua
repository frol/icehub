--Snowball War 1.0g3 LUA 5
--
--User Settings----------------------------------------------------------------------------------------------------------------
--
--//-- Botname pulled from the hub
SnowBot = "{Снег}"
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
SnowSubMenu = "Снежки"
--//-- Filename for user data
SnowFile="SnowTable3.dat"
--//-- Declaration of War message
WarCry = "\r\n\r\nДавайте начнем битву!"
--//-- Inactivity time (in minutes) to declare time of peace.
WarEndTime = 20
--//-- Minimum time (in seconds) a user must wait before be able to throw again.
WaitTime = 10
--//--Set your profiles permissions here.
--profile_idx, Commands/Menus enabled [0=no 1=yes], "Profile Name"
SnowProfiles = {
[-1] = {1,"Незарегистрированный пользователь"},
[4] = {1,"Мастер"},
[3] = {1,"ОПератор"},
[1] = {1,"VIP"},
[0] = {1,"Зарегистрированный пользователь"},
}

--//Player Upgrades [idx] = {"Upgrade Name", point cost}
Upgrades={
[1] = {"Силовой уровень 1",25},
[2] = {"Силовой уровень 2",50},
[3] = {"Улучшенная точность 1",25},
[4] = {"Улучшенная точность 2",50},
[5] = {"Защитный экран",75},
}

--//Ранги игроков
Rankings = {
[1] = {10, "Штатский"},
[1] = {25, "Ефрейтор"},
[2] = {50, "Младший сержант"},
[3] = {75, "Сержант"},
[4] = {100, "Старший сержант"},
[5] = {150, "Старшина"},
[6] = {200, "Младший лейтенант"},
[7] = {300, "Лейтенант"},
[8] = {400, "Старший лейтенант"},
[9] = {500, "Капитан"},
[10] = {700, "Майор"},
[11] = {1000, "Подполковник"},
[12] = {1300, "Полковник"},
[13] = {1500, "Генерал-майор"},
[14] = {1800, "Генерал-лейтенант"},
[15] = {1900, "Генерал-полковник"},
[16] = {2000, "Маршал"},
[17] = {2001, "Генералиссимус"},
}

--//Ранги игроков
Rankings = {
[1] = {10, "Штатский"},
[1] = {25, "Ефрейтор"},
[2] = {50, "Младший сержант"},
[3] = {75, "Сержант"},
[4] = {100, "Старший сержант"},
[5] = {150, "Старшина"},
[6] = {200, "Младший лейтенант"},
[7] = {300, "Лейтенант"},
[8] = {400, "Старший лейтенант"},
[9] = {500, "Капитан"},
[10] = {700, "Майор"},
[11] = {1000, "Подполковник"},
[12] = {1300, "Полковник"},
[13] = {1500, "Генерал-майор"},
[14] = {1800, "Генерал-лейтенант"},
[15] = {1900, "Генерал-полковник"},
[16] = {2000, "Маршал"},
[17] = {2001, "Генералиссимус"},
}

--//-- Set your hit/miss responses here
Hit = {
"Мать вашу, user1 извини помоему я тебя убил user2.", 
"user1 брасает снежок в user2, это должно быть больно!", 
"user2 За Родину,за Сталина user1 В! Ты попал ему в глаз ему наверно не очень'.", 
"user1 ранил user2, еще таких пару выстрелов и ты труп.",
"user1 идет прямо на него user2 и бросает снежок ему в лицо.", 
"Подкравшись, user1 встает позади это ты Дура спряталась тут user2 и забрасывает ему снег прямо зашиворот.", 
"user1 ,А вот и я что не ожидали 'Стрелок' ломает user2's руку и говорит помоему тебе жопа.", 
"Получая унизительный выстрел в задницу от user1, user2 вскрикнул 'Ой, он твой! ' и передаёт ход.", 
"'О нет,только не Headshot я умоляю!!!', вопит user2, но user1 попадает снежком в голову!", 
"user1 попадает снежком в ухо user2 - ухshot!", 
}

Miss = {
"user2 спрашивает, 'Вы кидали в меня снежок user1?, Я сказал, 'Вы кидали в МЕНЯ!? Ну вы нарвались уроды!..'", 
"user1 кидает в user2, промазывает, и без расуждений упрекает как так можна он читер наверно!", 
"user1 ,мне прос100 лень кидать в тебя, промахивает аж за милю в user2", 
"user2 уходит от снежка от user1 и говорит та не пошел ли ты нах....", 
"user2 бежит словно ветер,что бы ты промазал 'и кидает снежок'от user1", 
"Все угарают как user1 бросает каробок спичок в user2, который никогда не достигает цели.",
"user2 фух!уцелел, так как user1 не умеет вообще кидать тебе руки побрить надо!.",  
"Ослпелённый вышедшим сонцем, user1  бросает снежок далеко в сторону. user2'ааааа я ослеп .",
"Хотя user1 делает сильнейший бросок прямо в цель, шустрый user2 уворачивается! Какой я быстрый осел!", 
"user2 кричит 'ФУ! Вы бросаете подобно девочке user1'",
"user2 прячется за Мамой, и  уклоняется от снежка, запущенного в user1",  
}
--
--End User Settings-------------------------------------------------------------------------------------------------------------

Players = {}
Throw = {0,1,0,1,0,1,0,0,0,0}

Main = function()
	if SnowBot ~= frmHub:GetHubBotName() then
		frmHub:RegBot(SnowBot, 1, "[ИГРА] Зимняя забава", "")
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
		user:SendData(SnowBot, SnowProfiles[user.iProfile][2].." Snowball fight команды активированы. Нажмите правой кнопку мыши на любого пользователя, чтобы ознакомится с подменю игры.")
	end
end

OpConnected = NewUserConnected

ChatArrival = function(user, data)
local s,e,pre,cmd = string.find(data, "^%b<>%s+(%p)(%w+)")
local s,e,nick = string.find(data, "^%b<>%s+%p%w+%s(%S+)|$")
	if pre and pre==Prefix then
		if cmd and cmd==ScoresCmd then
			if SnowProfiles[user.iProfile] and SnowProfiles[user.iProfile][1] == 1 then
				local Scores = "\r\n\r\n\t•Snowball Fight ТОП•\r\n\r\n"..string.rep("Ї",105).."\r\n"
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
						Scores = Scores.." • "..string.format("%-35.30s",usr).."\tПопадания: "..string.format("%-5.4d",hit).."  Промахи: "..
						string.format("%-5.4d",miss).."  Точность: "..string.format("%-4s",pct).."  Сила: "..string.format("%2d",pwr)..
						"  Цель: "..string.format("%2d",aim).."  Защита: "..string.format("%2d",shield).."   Ранг: "..string.format("%-25s",rank).."\r\n"
					end
				end
					user:SendData(SnowBot, Scores.."\r\n"..string.rep("Ї",105).."\r\n\t•Конец списка•\r\n\r\n")
					return 1
			else
				user:SendData("\r\n\r\n\tПростите "..user.sName.." команда ' "..Prefix..ScoresCmd..
				" ' не доступна для "..SnowProfiles[user.iProfile][2].."\r\n")
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
									user:SendData(SnowBot,"\r\n\t"..SnowTable[user.sName][4].." "..user.sName.." вы уже"..
									" имеете апгрейд "..upgrade..".")
									return 1
								end
								user:SendData(SnowBot,"\r\n\t"..SnowTable[user.sName][4].." "..user.sName.." вы только что "..
								"приобрели "..upgrade..".\r\n\t"..cost.." очков с вас было снято.")
								GetRank()
								return 1
							else
								user:SendData(SnowBot,"\r\n\tПростите "..SnowTable[user.sName][4].." "..
								user.sName..", вы не можете произвести апгрейд "..upgrade..".\r\n\tЭтот  апгрейд стоит "..
								cost.." очков, а у вас только "..SnowTable[user.sName][1].." очков.")
								return 1
							end
						else
							user:SendData(SnowBot,"***Ошибка = "..Prefix..UpgradeCmd.." <#>\t"..
							"где '#' - число между 1 и 5")
							return 1
						end
					else
						user:SendData(SnowBot,"***Ошибка = "..Prefix..UpgradeCmd.." <#>\t"..
						"где '#' число между 1 и 5")
						return 1
					end
				else
					user:SendData(SnowBot,"\r\n\r\n\tПростите "..user.sName..", апгрейды покупаются "..
					"с помощью набранных очков. Вы должны играть, чтобы получить очки.\r\n")
					return 1
				end
			else
				user:SendData(SnowBot,"\r\n\r\n\tПростите "..user.sName.." команда ' "..Prefix..UpgradeCmd..
				" ' не доступна для "..SnowProfiles[user.iProfile][2].."'s\r\n")
				return 1
			end
		elseif cmd and cmd==SnowCmd then
			if SnowProfiles[user.iProfile] and SnowProfiles[user.iProfile][1] == 1 then
				if SnowTable[user.sName] and SnowTable[user.sName][3] == 1 then
					local reply = user.sName.." вы не можете присоединиться к игре, пока вы находитесь в мире. "..
					"Чтобы вступить в битву введите ' "..Prefix..SnowLiberty.." '"
					user:SendData(SnowBot,reply)
					return 1
				end
				local start = os.clock()
				if Players[user.sName] then
					local interval = Players[user.sName]
					if os.difftime(os.clock(), interval) < WaitTime then
						local reply = "Уфф!! Попредержи свой пыл! Вы должны подождать "..WaitTime.." секунд, прежде чем снова сможете бросить снежок."
						user:SendData(SnowBot,reply)
						return 1
					end
				end
				if nick then
					local usrnick = GetItemByName(nick)
					if not usrnick then
						local reply = "Пользователь "..nick.." не найден. Попытайте удачу с теми, кто сейчас на хабе."
						user:SendData(SnowBot,reply)
						return 1
					elseif SnowTable[usrnick.sName] then
						if SnowTable[usrnick.sName][3] == 1 then
							local reply = "Пользователь "..nick.." выбрал мир - он не учавствует в битве. Попробуйте сразиться с кем-нибудь другим."
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
						local reply = "У вас забирают одно очко, "..user.sName..", чтобы больше Вы не пытались себя убить."
						SendToAll(SnowBot,reply)
						return 1
					end
					if GameOn == 0 then
						GameOn = 1
						WarStopTime = WarStartTime
						WarCry = WarCry.." Когда Они спросят, кто начал войну, помните, это был "..user.sName..".\r\n\r\n"
					else
						WarStopTime = math.floor(os.clock())
						WarCry = ""
							if (WarStopTime - WarStartTime) > WarEndTime then
								GameOn = 1
								WarCry = "\r\n\r\nПосле более чем "..(WarEndTime / 60).." минут мира "..
								user.sName.." фанаты войны снова раздули пламя вражды.\r\n\r\n"
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
					user:SendData("\r\n\r\n\tОшибка! Введите = "..Prefix..SnowCmd.." <ник>\r\n")
					return 1
				end
			else
				user:SendData("\r\n\r\n\tПростите "..user.sName.." команда ' "..Prefix..SnowCmd..
				" ' не доступна для "..SnowProfiles[user.iProfile][2].."'s\r\n")
				return 1
			end
		elseif cmd and cmd == SnowLiberty then
			if SnowTable[user.sName] then
				if SnowTable[user.sName][3] == 0 then
					SnowTable[user.sName][3] = 1
					user:SendData(SnowBot,"OK! "..SnowTable[user.sName][4].." "..user.sName.." вы выбрали мир и больше не учавствуете в сражениях.")
					Save_File(SnowFile,SnowTable,"SnowTable")
					return 1
				elseif SnowTable[user.sName][3] == 1 then
					SnowTable[user.sName][3] = 0
					user:SendData(SnowBot,"OK! "..SnowTable[user.sName][4].." "..user.sName.." вы снова вышли на тропу войны.")
					Save_File(SnowFile,SnowTable,"SnowTable")
					return 1
				end
			else
				SnowTable[user.sName]={0,0,1,Rankings[1][2],0,0,0}
				user:SendData(SnowBot,"\r\n\tЯ не знаю, как вы вели себя до этого "..
				SnowTable[user.sName][4].." "..user.sName..".\r\n"..
				"\tНо вы решили больше не сражаться и выбрали мир.\r\n"..
				"\tТеперь уходите и не смейте возвращаться!.")
				Save_File(SnowFile,SnowTable,"SnowTable")
				return 1
			end
		elseif cmd and cmd == ShowUpgrade then
			local ups = "\r\n\r\n\tДоступные для вас апгрейды\r\n"..
			"\t"..string.rep("Ї",32).."\r\n"
			for i,v in Upgrades do
				ups = ups.."\t"..i..".  "..string.format("%-18s",v[1]).."\t"..v[2].."  очков\r\n"
			end
			ups = ups.."\r\n\t"..string.rep("Ї",32).."\r\n"
			user:SendData(SnowBot,ups)
			return 1
		end
	end
end

function Commands(user)
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\Бросить снежок в... $<%[mynick]> "..Prefix..SnowCmd.." %[line:Nick]&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\Бросить снежок $<%[mynick]> "..Prefix..SnowCmd.." %[nick]&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\Очки $<%[mynick]> "..Prefix..ScoresCmd.."&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\Мир/Война $<%[mynick]> "..Prefix..SnowLiberty.."&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\Сделать апгрейд $<%[mynick]> "..Prefix..UpgradeCmd.." %[line:1=Сила1, 2=Сила2, 3=Цель1, 4=Цель2, 5=Щит]&#124;")
	user:SendData("$UserCommand 1 3 "..SnowSubMenu.."\\Доступные апгрейды $<%[mynick]> "..Prefix..ShowUpgrade.."&#124;")
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

