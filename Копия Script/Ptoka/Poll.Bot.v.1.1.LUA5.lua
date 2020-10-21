--[[

	Poll Bot v.1.1
	Created by TTB on 11 July 2006
	FOR LUA 5.1x by NRJ
	Отдельное спасибо nErBoS и Jiten

	Изменения (by NRJ):
	- русификация
	- вынос всех команд для удобства изменения

]]--

--------------------------------------------------------------------
-- Настройки
--------------------------------------------------------------------

bot = "Опрос"			-- Имя бота
botDesc = "««« Кто-то умный меня слепил »»»"		-- Описание
botTag = "Новая версия какая нескажу"	-- Тэг бота
botEmail = "Есть, но я его непомню"		-- Email бота

-- Доступ к администраторским командам
Profiles = {
[-1] = 0,  -- Users
[0] = 1,   -- Masters
[1] = 0,   -- OPs
[2] = 0,   -- VIPs
[3] = 0,   -- REGs
[4] = 0,   -- MODs
[5] = 0,   -- Founders
}

prefix = "#"				-- Префикс команд

-- Команды
cPollHelp = "Помощь"			-- помощь
cOldPollDel = "Удалить_навсегда"	-- удалить опрос из архива
cPollAdd = "Добавить"			-- добавить опрос
cPollDel = "Удалить"			-- удалить опрос
cPollClose = "Закрыть"			-- закрыть опрос
cPoll = "Голосовать"			-- голосовать
cOldPoll = "Архив"			-- архив опросов


-- Таблицы
pollvotes = "Poll\\pollvotes.tbl"
pollsettings = "Poll\\pollsettings.tbl"
pollold = "Poll\\pollold.tbl"

--------------------------------------------------------------------
-- Preloading
--------------------------------------------------------------------
function loadlua(file,msg)
	local f = assert(loadfile(file), msg)
	return f()
end

loadlua(pollvotes,pollvotes.." для "..bot.." не найдены")
loadlua(pollsettings,pollsettings.." для "..bot.." не найдены")
loadlua(pollold,pollold.." не "..bot.." не найдены")

function Main()
	frmHub:RegBot(bot,1,botDesc.."<"..botTag..">", botEmail)
end

teller = 0
CurrentPoll ={}
--------------------------------------------------------------------
-- User connects // disconnects
--------------------------------------------------------------------
function NewUserConnected(curUser,data)
	if PollSettings["current"] == 2 and not PollVotes[curUser.sName] then
		ShowPollWithNoResult(curUser,data)
	end
	RC(curUser)
end
		
function UserDisconnected(curUser,data)
end

OpConnected=NewUserConnected
OpDisconnected=UserDisconnected

--------------------------------------------------------------------
-- Показ помощи
--------------------------------------------------------------------
MainInfo = ("Помощь\r\n\t--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--"..
       "\r\n\t\t [ Команда ]\t\t\t\t [ Описание ]\r\n\t"..
       "--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--"..
       "\r\n\t\t "..prefix..cPoll.."\t\t\t\t- Посмотреть текущий опрос"..
	   "\r\n\t\t "..prefix..cPoll.." <№>\t\t\t\t- Голосовать, если есть опрос"..
	   "\r\n\t\t "..prefix..cOldPoll.."\t\t\t\t\t- Посмотреть архив опросов"..
       "\r\n\t\t "..prefix..cOldPoll.." <название>\t\t\t- Посмотреть конкретный опрос из архива"..
       "\r\n\t--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--")
OPInfo = ("\r\n\t\t "..prefix..cPollAdd.." <название> <№> <вопрос>\t- Создать новый опрос"..
       "\r\n\t\t "..prefix..cPollClose.."\t\t\t\t- Закрыть текущий опрос и добавить его в архив"..
	   "\r\n\t\t "..prefix..cPollDel.."\t\t\t\t\t- Удалить текущий опрос, минуя список архив"..
	   "\r\n\t\t "..prefix..cOldPollDel.." <название>\t\t- Удалить опрос из архива навсегда"..
       "\r\n\t--<>--------------------------------------------------------------------------------------------------------------------------------------------------------<>--\r\n")

--------------------------------------------------------------------
-- ChatArrival / ToArrival for commands
--------------------------------------------------------------------
function ChatArrival(curUser,data)
	data = string.sub(data,1,string.len(data)-1)
	local s,e,cmd = string.find(data,"%b<>%s+(%S+)")
	if cmd then
		if Profiles[curUser.iProfile] == 1 then
			if string.lower(cmd) == (prefix..cPollAdd) then
				NewPoll(curUser,data)
				return 1
			elseif string.lower(cmd) == (prefix..cPollDel) then
				if PollSettings["current"] then
					ClearActivePoll()
					SendToAll(bot,"Текущий опрос был удален!")
				else
					curUser:SendData(bot, "Никаких опросов не было... Так что нечего тут удалять!")
				end
				return 1
			elseif string.lower(cmd) == (prefix..cPollClose) then
				if PollSettings["current"] == 2 then
					ClosePoll(curUser,data)
				else
					curUser:SendData(bot, "На данный момент нет активных опросов... Так что никакой опрос не закроешь!")
				end
				return 1
			elseif string.lower(cmd) == (prefix..cPollHelp) then
				curUser:SendData(bot, MainInfo..OPInfo)
				return 1
			elseif string.lower(cmd) == (prefix..cOldPollDel) then
				OldPollDel(curUser,data)
				return 1				
			end
		else
			if string.lower(cmd) == (prefix..cPollHelp) then
				curUser:SendData(bot, MainInfo)
				return 1
			end
		end
		if string.lower(cmd) == (prefix..cPoll) then
			PollPM(curUser,data)
			return 1
		elseif string.lower(cmd) == (prefix..cOldPoll) then
			OldPoll(curUser,data)
			return 1
		end
	end
end

function ToArrival(curUser,data)
	local _,_,whoTo,mes = string.find(data,"$To:%s+(%S+)%s+From:%s+%S+%s+$(.*)")
	if (whoTo == bot and string.find(mes,"%b<>%s+(.*)")) then
		data = string.sub(mes,1,string.len(mes)-1)
		if PollSettings["current"] == 1 and curUser.sName == PollSettings["currentcreator"] then
			ConfigPoll(curUser,data)
		elseif PollSettings["current"] == 2 then
			PollPM(curUser,data)
		else
			curUser:SendPM(bot,"Простите, сейчас нет никаких опросов... Так что Вы не можете голосовать в данный момент! Вы можете создать опрос в главном чате.")
		end
	end
end

--------------------------------------------------------------------
-- Creating a Poll
--------------------------------------------------------------------
function NewPoll(curUser,data)
	local _,_,_,namepoll,questions,subject = string.find(data,"^%b<>%s+(%S+)%s+(%S+)%s+(%d)%s+(.+)")
	if subject == nil or questions == nil then
		curUser:SendData(bot,"Ошибка! Введите: "..prefix..cPollAdd.." <название> <кол-во вариантов ответов> <вопрос>")
	else
		if namepoll == OldPolls[namepoll] then
			curUser:SendData(bot,"Опрос не был создан... Название твоего нового опроса совпало с названием одного из архивных опросов!")
		else
			local questions = tonumber(questions)
			if questions > 20 then
				curUser:SendData(bot,"В твоем опросе уже больше 20 вариантов ответа. 20  - это достаточное количество, ты так не считаешь?")
			elseif questions < 2 then
				curUser:SendData(bot,"Твой опрос не имеет даже двух вариантов ответа? Это плохо... Опрос не принят!")
			else
				if PollSettings["current"] == nil then
					PollSettings = {}
					PollSettings["current"] = 1
					PollSettings["currentcreator"] = curUser.sName
					PollSettings["title"] = namepoll
					PollSettings["questions"] = questions
					PollSettings["subject"] = subject
					PollSettings["date"] = os.date("[%X] / [%d-%m-20%y]")
					curUser:SendData(bot,"Теперь перейдите в приват к боту, чтобы закончить создание опроса")
					WriteFile(PollSettings, "PollSettings", pollsettings)
					curUser:SendPM(bot,"\r\n"..string.rep("*",50).."\r\n\tУПРАВЛЕНИЕ ОПРОСОМ\r\n"..string.rep("*",50).."\r\nСоздатель опроса = "..curUser.sName.."\r\nНазвание опроса = "..PollSettings["title"].."\r\nВопрос: "..PollSettings["subject"].."\r\nКол-во вариантов ответа = "..PollSettings["questions"].."\r\n"..string.rep("*",50))
					teller = 1
					curUser:SendPM(bot,"Введите вариант ответа "..teller.."/"..questions..":")
				elseif PollSettings["current"] == 1 then
					curUser:SendData(bot,"Ты не можешь создать опрос сейчас!! A poll is configured atm by "..PollSettings["currentcreator"])
				elseif PollSettings["current"] == 2 then
					curUser:SendData(bot,"В данный момент уже ведется опрос! Прежде чем создавать новый, удалите текущий опрос!")
				end
			end
		end
		return 1
	end
end

function ConfigPoll(curUser,data)
	local s,e,answer = string.find(data,"%b<>%s+(.*)")
	local tellermax = PollSettings["questions"]
	CurrentPoll[teller] = answer
	teller = teller + 1
	if teller > tellermax then
		teller = 0
		PollSettings["current"] = 2
		WriteFile(PollSettings, "PollSettings", pollsettings)
		curUser:SendPM(bot,"Спасибо! Опрос только что был создан!")
		SendToAll(bot,"-------->>>>>>>>>> СОЗДАН НОВЫЙ ОПРОС <--> ПОЖАЛУЙСТА, ПРОГОЛОСУЙТЕ <<<<<<<<<<--------")
		Convert(curUser,data)
	else
		curUser:SendPM(bot,"Введите вариант ответа "..teller.."/"..tellermax..":")
	end
end

function Convert(curUser,data)
	if PollSettings["current"] == 2 then
		PollSettings["active"] = {}
		PollSettings["votes"] = {}
		PollSettings["votes"]["n"] = 0
		for a,b in pairs(CurrentPoll) do
			PollSettings["active"][a] = b
			PollSettings["votes"][a] = 0
			WriteFile(PollSettings, "PollSettings", pollsettings)
		end
		CurrentPoll = nil
		CurrentPoll ={}
		Poll(curUser,data)
	else
		curUser:SendPM(bot,"Критическая ошибка! Все текущие результаты голосования потеряны!")
		ClearActivePoll()
	end
end

---------------------------------------------------------------------------------------------------
-- Poll is running... let all ppl know by mass message! :-)
---------------------------------------------------------------------------------------------------
function Poll(curUser,data)
	local PollText = "\r\n"..string.rep("*",50).."\r\nОПРОС: "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
	for a,b in pairs(PollSettings["active"]) do
			PollText = PollText..a..". "..b.."\r\n"
	end
	PollText = PollText.."\r\nПроголосуйте, написав "..prefix..cPoll.." и номер вашего варианта ответа (через пробел)\r\n"..string.rep("*",50).."\r\nОпрос создал: "..PollSettings["currentcreator"].."\r\n"..string.rep("*",50)
	for i,v in pairs(frmHub:GetOnlineUsers()) do
		v:SendPM(bot,PollText)
	end
end

function PollPM(curUser,data)
	local s,e,cmd = string.find(data,"%b<>%s+(%S+)")
	if cmd and (string.lower(cmd) == (prefix..cPoll)) then
		local s,e,cmd,answer = string.find(data,"%b<>%s+(%S+)%s+(%d+)")
		if PollSettings["current"] == 2 then
			if answer then
				if PollVotes[curUser.sName] then
					curUser:SendPM(bot,"Ты уже проголосовал и не можешь голосовать второй раз! Напиши "..prefix..cPoll.." (без номера), чтобы узнать последние результаты опроса!")
				else
					answer = tonumber(answer)
					if answer > PollSettings["questions"] then
						curUser:SendPM(bot,"Ошибка! Вариант ответа "..answer.." не предусморен в данном опросе!")
					else
						PollSettings["votes"][answer] = PollSettings["votes"][answer] + 1
						PollSettings["votes"]["n"] = PollSettings["votes"]["n"] + 1
						WriteFile(PollSettings, "PollSettings", pollsettings)
						PollVotes[curUser.sName] = 1
						WriteFile(PollVotes, "PollVotes", pollvotes)
						ShowPollWithResult(curUser,data)
						curUser:SendPM(bot,"Спасибо, что выбрал вариант номер "..answer..". Ты всегда можешь узнать результаты опроса, написав в приват бота  "..bot.." команду "..prefix..cPoll..". Не забудь принять участие в следующих опросах!")
						SendPmToNick(PollSettings["currentcreator"],bot,"Проголосовал:  "..curUser.sName.."   :)")
					end
				end
			else
				if PollVotes[curUser.sName] then
					ShowPollWithResult(curUser,data)
				else
					ShowPollWithNoResult(curUser,data)
				end
			end
		else
			curUser:SendPM(bot,"Простите, сейчас нет никаких опросов... Так что Вы не можете голосовать в данный момент!")
		end
	end
end

function ShowPollWithResult(curUser,data)
	local PollText = "\r\n"..string.rep("*",50).."\r\nОПРОС: "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
	local c = tonumber(PollSettings["votes"]["n"])
	for a,b in pairs(PollSettings["active"]) do
			PollText = PollText..a..". "..PollSettings["votes"][a].." ("..string.format( "%.2f",(100/c)*PollSettings["votes"][a]).."%) голос(ов)  "..b.."\r\n"
	end
	PollText = PollText.."\r\nВсего голосов: "..PollSettings["votes"]["n"].." (100.00%)\r\n"..string.rep("*",50).."\r\nОпрос создал: "..PollSettings["currentcreator"].."\r\nОпрос создан: "..PollSettings["date"].."\r\n"..string.rep("*",50)
	curUser:SendPM(bot,PollText)
	PollText = nil	
end

function ShowPollWithNoResult(curUser,data)
	local PollText = "\r\n"..string.rep("*",50).."\r\nОПРОС: "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
	for a,b in pairs(PollSettings["active"]) do
			PollText = PollText..a..". "..b.."\r\n"
	end
	PollText = PollText.."\r\nПроголосуйте, написав "..prefix..cPoll.." и номер вашего варианта ответа (через пробел).\r\n"..string.rep("*",50).."\r\nОпрос создал: "..PollSettings["currentcreator"].."\r\nОпрос создан: "..PollSettings["date"].."\r\n"..string.rep("*",50)
	curUser:SendPM(bot,PollText)
	PollText = nil
end

---------------------------------------------------------------------------------------------------
-- Close the active Poll
---------------------------------------------------------------------------------------------------
function ClosePoll(curUser,data)
	if PollSettings["current"] == 2 then
		if tonumber(PollSettings["votes"]["n"]) == 0 then
			curUser:SendData(bot, "Никто не проголосовал в этом опросе! Вы не можете переместить опрос в архив! Вы можете удалить его только с помощью команды "..prefix..cPollDel..".")
		else
			local Pollname = PollSettings["title"]
			OldPolls[Pollname] = {}
			OldPolls[Pollname]["subject"] = PollSettings["subject"]
			OldPolls[Pollname]["active"] = PollSettings["active"]
			OldPolls[Pollname]["votes"] = PollSettings["votes"]
			OldPolls[Pollname]["date"] = PollSettings["date"]
			OldPolls[Pollname]["currentcreator"] = PollSettings["currentcreator"]
			OldPolls[Pollname]["close"] = os.date("[%X] / [%d-%m-20%y]")
			WriteFile(OldPolls, "OldPolls", pollold)
			local PollText = "\r\n"..string.rep("*",50).."\r\nЗАКРЫТЫЙ ОПРОС: "..PollSettings["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
			local c = tonumber(PollSettings["votes"]["n"])
			for a,b in pairs(PollSettings["active"]) do
				PollText = PollText..a..". "..PollSettings["votes"][a].." ("..string.format( "%.2f",(100/c)*PollSettings["votes"][a]).."%) голос(ов)  "..b.."\r\n"
			end
			PollText = PollText.."\r\nВсего проголосовало: "..c.." (100.00%)\r\n"..string.rep("*",50).."\r\nОпрос создал: "..PollSettings["currentcreator"].."\r\nОпрос создан: "..PollSettings["date"].."\r\n"..string.rep("*",50)
			for i,v in pairs(frmHub:GetOnlineUsers()) do
				v:SendPM(bot,PollText)
			end
			PollText = nil
			ClearActivePoll()
			curUser:SendData(bot, "Текущий опрос был закрыт и перенесен в архив!")
		end
	end
end

---------------------------------------------------------------------------------------------------
-- Show an old Poll
---------------------------------------------------------------------------------------------------
function OldPoll(curUser,data)
	local _,_,_,namepoll = string.find(data,"^%b<>%s+(%S+)%s+(%S+)")
	if namepoll == nil then
		oTmp = ""
		iets = nil
		for a,b in pairs(OldPolls) do
			if iets then
				iets = iets..", "..a
			else
				iets = a
			end
		end
		if iets == nil then
			oTmp = "Архив опросов пуст!"
		else
			oTmp = "Введите: "..prefix..cOldPoll.." <название>. Вот названия архивных опросов:\r\n->["..iets.."]<-"
		end		
	else
		if OldPolls[namepoll] then
			ooTmp = "\r\n"..string.rep("*",50).."\r\nСТАРЫЙ ОПРОС: "..OldPolls[namepoll]["subject"].."\r\n"..string.rep("*",50).."\r\n\r\n"
			local c = tonumber(OldPolls[namepoll]["votes"]["n"])
			for a,b in pairs(OldPolls[namepoll]["active"]) do
					ooTmp = ooTmp..a..". "..OldPolls[namepoll]["votes"][a].." ("..string.format( "%.2f",(100/c)*OldPolls[namepoll]["votes"][a]).."%) голос(ов)  "..b.."\r\n"
			end
			ooTmp = ooTmp.."\r\nВсего голосов: "..c.." (100.00%)\r\n"..string.rep("*",50).."\r\nОпрос создал: "..OldPolls[namepoll]["currentcreator"].."\r\nОпрос создан: "..OldPolls[namepoll]["date"].."\r\nОпрос закрыт: "..OldPolls[namepoll]["close"].."\r\n"..string.rep("*",50)
		else
			ooTmp = "Прости, но в архиве нет опроса с названием  '"..namepoll.."'! Напиши "..prefix..cOldPoll..", чтобы ознакомиться со списком всех опросов!"
		end
	end
	curUser:SendData(bot,oTmp)
	curUser:SendPM(bot,ooTmp)
	oTmp = nil
	ooTmp = nil
	iets = nil
	return 1
end

---------------------------------------------------------------------------------------------------
-- Clean it all up
---------------------------------------------------------------------------------------------------
function ClearActivePoll()
	teller = 0
	PollSettings = nil
	PollSettings = {}
	WriteFile(PollSettings, "PollSettings", pollsettings)
	CurrentPoll = nil
	CurrentPoll ={}
	PollText = nil
	PollVotes = nil
	PollVotes = {}
	WriteFile(PollVotes, "PollVotes", pollvotes)
	collectgarbage()
	io.flush()
end

function OldPollDel(curUser,data)
	local _,_,_,namepoll = string.find(data,"^%b<>%s+(%S+)%s+(%S+)")
	if namepoll == nil then
		curUser:SendData(bot, "Ошибка! Введи: "..prefix..cOldPollDel.." <название> для удаления конкретного опроса из архива.")
	else
		if OldPolls[namepoll] then
			OldPolls[namepoll] = nil
			WriteFile(OldPolls, "OldPolls", pollold)
			curUser:SendData(bot, "Опрос из архива  '"..namepoll.."'  был навсегда удален!")
		else
			curUser:SendData(bot, "Я не могу удалить не существующий опрос! Напиши "..prefix..cOldPoll..", чтобы ознакомиться со списком всех опросов!")
		end
	end
end

---------------------------------------------------------------------------------------------------
-- Write to file etc
---------------------------------------------------------------------------------------------------
function WriteFile(table, tablename, file)
	local handle = io.open(file, "w")
	Serialize(table, tablename, handle)
  	handle:close()
end

function Serialize(tTable, sTableName, hFile, sTab)
	sTab = sTab or "";
	hFile:write(sTab..sTableName.." = {\n" );
	for key, value in pairs(tTable) do
		local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
		if(type(value) == "table") then
			Serialize(value, sKey, hFile, sTab.."\t");
		else
			local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
			hFile:write(sTab.."\t"..sKey.." = "..sValue);
		end
		hFile:write(",\n");
	end
	hFile:write(sTab.."}");
end
---------------------------------------------------------------------------------------------------
-- Rightclicker
---------------------------------------------------------------------------------------------------
function RC(curUser)
	curUser:SendData("$UserCommand 1 3 Опросы\\Помощь$<%[mynick]> "..prefix..cPollHelp.."&#124;|")
	curUser:SendData("$UserCommand 1 3 Опросы\\Текущий опрос$<%[mynick]> "..prefix..cPoll.."&#124;|")
	curUser:SendData("$UserCommand 1 3 Опросы\\Архив опросов$<%[mynick]> "..prefix..cOldPoll.."&#124;|")
	if Profiles[curUser.iProfile] == 1 then
		curUser:SendData("$UserCommand 0 3 Опросы&#124;|")
		curUser:SendData("$UserCommand 1 3 Опросы\\Добавить опрос$<%[mynick]> "..prefix..cPollAdd.." %[line:Название опроса] %[line:Кол-во вариантов ответов] %[line:Вопрос]&#124;|")
		curUser:SendData("$UserCommand 1 3 Опросы\\Закрыть опрос$<%[mynick]> "..prefix..cPollClose.."&#124;|")
		curUser:SendData("$UserCommand 1 3 Опросы\\Удалить текущий опрос$<%[mynick]> "..prefix..cPollDel.."&#124;|")
		curUser:SendData("$UserCommand 1 3 Опросы\\Удалить опрос из архива$<%[mynick]> "..prefix..cOldPollDel.." %[line:Pollname]&#124;|")
	end
end