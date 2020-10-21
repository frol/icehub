-- Данный скрипт базируется на викторине от chill'a

--[[ 

Сhangelog (by NRJ):

**1.06
- Исправлено меню

**1.05 
- Поддержка LUA 5.0 / 5.1

**1.04
- окончательно пофиксил проблему с чатом при игре в личке бота (наконецто ;) )
- добавил возможность выбирать вид подачи вопросов и подсказок (мое оформление или родное)

**1.03

- пофиксил проблему, в результате которой игроки в привате видели еще и общий чат
- пофиксил баг с отправкой сообщения об ошибке в вопросе

**1.02

- при игре в личке теперь можно видеть сообщения других игроков, т.е. свободно чатиться

**1.01
- добавлены отдельные топы по времени, кол-ву ответов и кол-ву страйков
- переоформил все топы, дабы цифры не прыгали из-за длинных ников
- расширена менюшка + стала более динамичной 
  (теперь меню пропуска вопросов и подсказок 
  вылезает только тогда, когда соответстующие ф-ции включены)
- вместе с подсказками теперь можно выводить стоимость вопроса (в очках)

**1.0
- весь конфиг вынесен в отдельный файл 'BUKTOPUHA\settings.dat'
- переписана часть кода, дабы научить игру читать русские команды
- полностью переведен скрипт + переведены все комментарии к конфигу
- полностью переоформлен вывод топа
- менюшка по всем командам
- возможность выбирать, будет ли бот с ключиком или нет
- всякие мелкие фиксы и дополенения

]]--

-------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
--//			!!!ЕСЛИ НЕ РАЗБИРАЕТЕСЬ, ТО НЕ СОВЕТУЮ ЗДЕСЬ ЧТО-ЛИБО МЕНЯТЬ !!!
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
TrivEx = {}
TrivEx.Data = {}
TrivEx._Sets = {}
TrivEx._Config = {}
TrivEx._Sets = {}
TrivEx._Profiles = {}
TrivEx._Scores = {}
TrivEx._MainPlayers = {}
TrivEx._PMPlayers = {}
Report = {}

TrivEx._Sets.folder = "BUKTOPUHA"

dofile(TrivEx._Sets.folder.."/settings.dat")

function Main()
	TrivEx:Main()
end

function OnExit()
	TrivEx:OnExit()
end

function ChatArrival(curUser,data)
	if TrivEx:ParseData("main",curUser,data) == 1 then
		return 1
	end
end

function ToArrival(curUser,data)
	local _,_,whoTo,mes = string.find(data,"$To:%s+(%S+)%s+From:%s+%S+%s+$(.*)$")
	if (whoTo == TrivEx._Sets.bot) then
		SendChatToOthers(mes, curUser)
		TrivEx:ParseData("pm",curUser,mes)
	end
end

function NewUserConnected(curUser)
	TrivEx:NewUserConnected(curUser)
end

OpConnected = NewUserConnected

function UserDisconnected(curUser)
	TrivEx:UserDisconnected(curUser)
end
OpDisconnected = UserDisconnected

function OnTimer()
	TrivEx:OnTimer()
end

TrivEx._Sets.breaktime = TrivEx._Sets.breaktime * 60
TrivEx._Sets.timebreak = TrivEx._Sets.timebreak * 60

TrivEx._datamode = ""

TrivEx._Questions = {n=0}

local f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.TrivConfigFile, "a+" )
f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.TrivConfigFile, "a+" )
if f then
	f:write("" ) 
	f:close()
end
dofile(TrivEx._Sets.folder.."/"..TrivEx._Sets.TrivConfigFile)

local f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.ScoresFile, "a+" )
f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.ScoresFile, "a+" )
if f then
	f:write("" ) 
	f:close()
end
dofile(TrivEx._Sets.folder.."/"..TrivEx._Sets.ScoresFile)

local f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.MainPlayersFile, "a+" )
f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.MainPlayersFile, "a+" )
if f then
	f:write("" ) 
	f:close()
end
dofile(TrivEx._Sets.folder.."/"..TrivEx._Sets.MainPlayersFile)
os.remove(TrivEx._Sets.folder.."/"..TrivEx._Sets.MainPlayersFile)

local f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.PMPlayersFile, "a+" )
f,e = io.open(TrivEx._Sets.folder.."/"..TrivEx._Sets.PMPlayersFile, "a+" )
if f then
	f:write("" ) 
	f:close()
end
dofile(TrivEx._Sets.folder.."/"..TrivEx._Sets.PMPlayersFile)
os.remove(TrivEx._Sets.folder.."/"..TrivEx._Sets.PMPlayersFile)

if loadfile(TrivEx._Sets.folder.."/ErrorReport.tbl") then dofile(TrivEx._Sets.folder.."/ErrorReport.tbl") end

---------------------------------------------------------------------------------------
--	TRIVIA FUNCTIONS
---------------------------------------------------------------------------------------

function TrivEx:Main()
	if self._Sets.tKey == 1 then frmHub:RegBot(self._Sets.bot)
		SendToAll(self._Sets.botmyinfo)
 	else frmHub:RegBot(self._Sets.bot,0,"","")
		SendToAll(self._Sets.botmyinfo)
			end
	if (self:GetPlayMode() == "pm") then
		frmHub:RegBot(self._Sets.bot)
		SendToAll(self._Sets.botmyinfo)
		for nick,_ in pairs(self._PMPlayers) do
			if not GetItemByName(nick) then
				self._PMPlayers[nick] = nil
			end
		end
	elseif (self:GetPlayMode() == "main") and not TrivEx._Sets.maintoall then
		for nick,i in pairs(self._MainPlayers) do
			if not GetItemByName(nick) then
				self._MainPlayers[nick] = nil
			end
		end
	elseif (self._Sets.regbot == 1) then
		frmHub:RegBot(self._Sets.bot)
		SendToAll(self._Sets.botmyinfo)
	elseif (self._Sets.regbot == 0) then
		frmHub:UnregBot(TrivEx._Sets.bot)
	end
	curTriv.totalques = TrivEx:GetTotalQues()
	SetTimer(1*1000)
	if (self._Sets.StartOnMain == 1) then
		StartTimer()
	end
if (self._Sets.AutoStart == 1) then
TrivEx:TrivAutoStart()
end
end

function TrivEx:GetTotalQues()
	local handle = io.open(self._Sets.folder.."/"..self._Sets.questionfile,"r")
	local count = 0
	if handle then
		local line = handle:read()
		while line do
			count = count + 1
			line = handle:read()
		end
		handle:close()
	end
	return(count)
end

function TrivEx:OnExit()
	self:WriteTable(self._Scores,"TrivEx._Scores",self._Sets.folder.."/"..TrivEx._Sets.ScoresFile)
	self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
	if (self:GetPlayMode() == "pm") then
		self:WriteTable(self._PMPlayers,"TrivEx._PMPlayers",self._Sets.folder.."/"..TrivEx._Sets.PMPlayersFile)
	elseif self:GetPlayMode() == "main" and not TrivEx._Sets.maintoall then
		self:WriteTable(self._MainPlayers,"TrivEx._MainPlayers",self._Sets.folder.."/"..TrivEx._Sets.MainPlayersFile)
	end
end

function TrivEx:ParseData(mode,curUser,data)    
	self._datamode = mode
	data = string.sub(data,1,string.len(data)-1)
	local _,_,sdata = string.find( data, "^%b<>%s(.*)$")
	local _,_,cmd = string.find( data, "^%b<>%s["..self._Sets.prefixes.."](%w+)")
	
if (string.lower(sdata) == string.lower(HintTrigg)) then
TrivEx:TrivHelp(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivMyScore)) then
TrivEx:TrivMyScore(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivStats)) then
TrivEx:TrivStats(curUser)
return 1
elseif (string.lower(sdata) == string.lower(Login)) then
TrivEx:Login(curUser)
return 1
elseif (string.lower(sdata) == string.lower(Logout)) then
TrivEx:Logout(curUser)
return 1
elseif (string.lower(sdata) == string.lower(ShowTrivPlayers)) then
TrivEx:ShowTrivPlayers(curUser)
return 1
elseif (string.lower(sdata) == string.lower(DoTrivSkip)) then
TrivEx:DoTrivSkip(curUser)
return 1
elseif (string.lower(sdata) == string.lower(DoTrivHint)) then
TrivEx:DoTrivHint(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivStart)) then
TrivEx:TrivStart(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivStop)) then
TrivEx:TrivStop(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivScore)) then
TrivEx:TrivScore(curUser)
return 1
elseif (string.lower(sdata) == string.lower(ShortBreakSkip)) then
TrivEx:ShortBreakSkip(curUser)
return 1
elseif (string.lower(sdata) == string.lower(ConfTrivSkip)) then
TrivEx:ConfTrivSkip(curUser)
return 1
elseif (string.lower(sdata) == string.lower(ConfTrivHint)) then
TrivEx:ConfTrivHint(curUser)
return 1
elseif (string.lower(sdata) == string.lower(PlayTrivMain)) then
TrivEx:PlayTrivMain(curUser)
return 1
elseif (string.lower(sdata) == string.lower(PlayTrivPM)) then
TrivEx:PlayTrivPM(curUser)
return 1
elseif (string.lower(sdata) == string.lower(ResetScore)) then
TrivEx:ResetScore(curUser)
return 1
elseif (string.lower(sdata) == string.lower(ChangeQuesMode)) then
TrivEx:ChangeQuesMode(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivStatsTime)) then
TrivEx:TrivStatsTime(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivStatsAnswers)) then
TrivEx:TrivStatsAnswers(curUser)
return 1
elseif (string.lower(sdata) == string.lower(TrivStatsStreak)) then
TrivEx:TrivStatsStreak(curUser)
return 1
end	
	if cmd then
		cmd = string.lower(cmd)
		if self._Cmds[cmd] then
			self._Cmds[cmd](self,curUser,data)
			return 1
		end
	elseif sdata then
		local corrans = nil
		for _,v in ipairs(curTriv.ans) do
			if string.lower(sdata) == string.lower(v) then
				corrans = v
			end
		end
		if corrans and (not curTriv:GetGetQues()) then
			-- SetGetQues
			curTriv:SetGetQues(1)
			local ansTime = string.format("%.2f",(os.clock()-curTriv.start)) -- Get Answering Time in sec.
			if (TrivEx._Sets.showcorrectanswer == 1) then
				-- Show right answer
				local talked = nil
				if string.lower(sdata) == string.lower(corrans) then
					talked = corrans
				end
				if talked then
					if (self:GetPlayMode() == "pm") then
					--	self:SendToPlayers(data,curUser)
					else
						if TrivEx._Sets.maintoall then
							SendToAll(curUser.sName,corrans)
						else
							self:SendToPlayers(corrans,curUser)
						end
					end
					self:SendToPlayers("На этот вопрос правильно ответил: "..curUser.sName..", Ответ был: \""..corrans.."\". Очки: "..curTriv.points..". Время: "..ansTime.." секунд(ы).")
					-- Update Scores
					if self._Scores[curUser.sName] then
						self._Scores[curUser.sName].Score = self._Scores[curUser.sName].Score + curTriv.points
						self._Scores[curUser.sName].AvTime[1] = self._Scores[curUser.sName].AvTime[1] + ansTime
						self._Scores[curUser.sName].AvTime[2] = self._Scores[curUser.sName].AvTime[2] + 1
						self._Scores[curUser.sName].AvTime[3] = tonumber(string.format("%.2f",self._Scores[curUser.sName].AvTime[1]/self._Scores[curUser.sName].AvTime[2]))
					else
						self._Scores[curUser.sName] = {}
						self._Scores[curUser.sName].Score = curTriv.points
						self._Scores[curUser.sName].Streak = 1
						self._Scores[curUser.sName].AvTime = { tonumber(ansTime),1,tonumber(ansTime) }
					end
					if (self._Sets.showcorrectanswer == 1) then
						self:SendToPlayers(curUser.sName..": Всего очков: "..self._Scores[curUser.sName].Score..", Правильных ответов: "..self._Scores[curUser.sName].AvTime[2]..", Среднее время на ответ: "..string.format("%.2f",self._Scores[curUser.sName].AvTime[3]).." секунд(ы).")
					end
					-- Show other answeres if present
					if curTriv.availans > 1 then
						curTriv:ShowAnswer()
					end
					-- Check for Streak
					curTriv.streak:UpdStreak(curUser)
					return 1
				end
			elseif (TrivEx._Sets.showcorrectanswer == 2) then
				-- Show right answer
				local talked = nil
				if string.lower(sdata) == string.lower(corrans) then
					talked = corrans
				end
				if talked then
					if (self:GetPlayMode() == "pm") then
					--	self:SendToPlayers(data,curUser)
					else
						if TrivEx._Sets.maintoall then
							SendToAll(curUser.sName,corrans)
						else
							self:SendToPlayers(corrans,curUser)
						end
					end
					self:SendToPlayers("На этот вопрос правильно ответил: "..curUser.sName..", Ответ был: \""..corrans.."\". Очки: "..curTriv.points..".")
					-- Update Scores
					if self._Scores[curUser.sName] then
						self._Scores[curUser.sName].Score = self._Scores[curUser.sName].Score + curTriv.points
						self._Scores[curUser.sName].AvTime[1] = self._Scores[curUser.sName].AvTime[1] + ansTime
						self._Scores[curUser.sName].AvTime[2] = self._Scores[curUser.sName].AvTime[2] + 1
						self._Scores[curUser.sName].AvTime[3] = tonumber(string.format("%.2f",self._Scores[curUser.sName].AvTime[1]/self._Scores[curUser.sName].AvTime[2]))
					else
						self._Scores[curUser.sName] = {}
						self._Scores[curUser.sName].Score = curTriv.points
						self._Scores[curUser.sName].Streak = 1
						self._Scores[curUser.sName].AvTime = { tonumber(ansTime),1,tonumber(ansTime) }
					end
					if (self._Sets.showcorrectanswer == 1) then
						self:SendToPlayers(curUser.sName..": Всего очков: "..self._Scores[curUser.sName].Score..", Правильных ответов: "..self._Scores[curUser.sName].AvTime[2]..", Среднее время на ответ: "..string.format("%.2f",self._Scores[curUser.sName].AvTime[3]).." секунд(ы).")
					end
					-- Show other answeres if present
					if curTriv.availans > 1 then
						curTriv:ShowAnswer()
					end
					-- Check for Streak
					curTriv.streak:UpdStreak(curUser)
					return 1
				end
			end
		end
	end
end

function TrivEx:NewUserConnected(curUser)
if self._Sets.SendMenu == 1 then TrivEx:GetCommands(curUser) end
	if (self:GetPlayMode() == "pm") or (self._Sets.regbot == 1) then
		curUser:SendData(self._Sets.botmyinfo)
	end
end

function TrivEx:UserDisconnected(curUser)
	if (self:GetPlayMode() == "pm") and self._PMPlayers[curUser.sName] then
		self._PMPlayers[curUser.sName] = nil
	elseif (self:GetPlayMode() == "main") and self._MainPlayers[curUser.sName] and not TrivEx._Sets.maintoall then
		self._MainPlayers[curUser.sName] = nil
	end
end

function TrivEx:OnTimer()
	-- Load Questions if needed
	if (table.getn(self._Questions) == 0) then
		self:LoadQuestions()
	end
	-- Check if Trivia should be paused
	if (self._Sets.dobreak == 1) then
		if (not curTriv:Pause()) then
			-- Update TimeBreak
			TrivTimers.timebreak = TrivTimers.timebreak + 1
			if (TrivTimers.timebreak >= self._Sets.timebreak) and curTriv:GetGetQues() then
				curTriv:SetPause(1)
				TrivTimers.timebreak = 0
				TrivTimers.breaktime = 0
				self:SendToPlayers("Рекламная пауза! Игра продолжится через "..(self._Sets.breaktime/60).." минут.")
			end
		end
		if curTriv:Pause() then
			-- Update BreakTime
			TrivTimers.breaktime = TrivTimers.breaktime + 1
			if (TrivTimers.breaktime >= self._Sets.breaktime) then
				curTriv:SetPause(0)
				TrivTimers.timebreak = 0
				TrivTimers.breaktime = 0
				TrivTimers.showques = 0
			end
		end
	end
	-- Check if Trivia should be Autostoped
	if curTriv:GetGetQues() then
		if self._Sets.autostop and (curTriv.unansques == self._Sets.autostop) then
			StopTimer()
			curTriv:SetGetQues(1)
			self:WriteTable(self._Scores,"TrivEx._Scores",self._Sets.folder.."/"..TrivEx._Sets.ScoresFile)
			self:SendToPlayers("Игра была автоматически остановлена, так как на "..self._Sets.autostop.." вопросов подряд не был дан ни один правильный ответ.")
			return
		end
	end
	if (not curTriv:Pause()) then
		--Update ShowQuestion Time
		TrivTimers.showques = TrivTimers.showques + 1
		if (TrivTimers.showques == self._Sets.showques) then
			TrivTimers.showques = 0
			-- Check if to get new question
			if curTriv:GetNewQues() then
				curTriv:SendQuestion()
				-- Count unsanswered questions one up
				curTriv.unansques = curTriv.unansques + 1
			else
				curTriv:UpdHint()
				if curTriv:GetGetQues() then
					-- Show the Answer
					curTriv:ShowAnswer()
					-- Check for Streak
					curTriv.streak:UpdStreak()
				else
if (TrivEx._Sets.QuestionMode == 1) then 
					curTriv:SendHint()
else
curTriv:SendQuestion()
end
				end
			end
		end
	end
	if (self._Sets.savestats ~= 0) then
		TrivTimers.savestats = TrivTimers.savestats + 1
		if TrivTimers.savestats >= self._Sets.savestats then
			TrivTimers.savestats = 0
			if (curTriv.streak.write_scores == 1) then
				self:WriteTable(self._Scores,"TrivEx._Scores",self._Sets.folder.."/"..TrivEx._Sets.ScoresFile)
				curTriv.streak.write_scores = 0
			end
		end
	end
end

function TrivEx:SendToUser(curUser,data)
	if (self._datamode == "main") then
		curUser:SendData(TrivEx._Sets.bot,data)
	else
		curUser:SendPM(TrivEx._Sets.bot,data)
	end
end

function TrivEx:SendToPlayers(data,curUser)
	if (self:GetPlayMode() == "main") then
		if TrivEx._Sets.maintoall then
			SendToAll(self._Sets.bot,data)
		else
			local snick = ""
			if curUser then
				snick = curUser.sName
				data = "<"..curUser.sName.."> "..data
			else
				data = "<"..self._Sets.bot.."> "..data
			end
			for i,_ in pairs(self._MainPlayers) do
				local user = GetItemByName(i)
				if user then
					user:SendData(data)
				else
					self._MainPlayers[i] = nil
				end
			end
		end
	else
		local snick = ""
		if curUser then
			snick = curUser.sName
		else
			data = "<"..self._Sets.bot.."> "..data
		end
		for i,_ in pairs(self._PMPlayers) do
			local user = GetItemByName(i)
			if user then
				if (i ~= snick) then
					user:SendData("$To: "..i.." From: "..self._Sets.bot.." $"..data)
				end
			else
				self._PMPlayers[i] = nil
			end
		end
	end
end

function SendChatToOthers(mes, curUser) -- учим бота ретранслировать чат при игре в личке (by NRJ)
    for index, value in pairs(TrivEx._PMPlayers) do
      if (index ~= curUser.sName) then
	SendToNick(index, "$To: "..index.." From: "..TrivEx._Sets.bot.." $"..mes)
      end
  end
end

function TrivEx:AllowedProf(status,curUser)
	if self._Profiles[status] and self._Profiles[status][curUser.iProfile] then
		return 1
	end
end

function TrivEx:SetPlayMode(mode)
	if (mode == "main") then 
		self._PMPlayers = {}
		self._MainPlayers = {}
		if (self._Sets.regbot == 0) then
			frmHub:UnregBot(self._Sets.bot)
		end
		self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
		StartTimer()
		curTriv:SetGetQues(1)
		self._Config.mode = mode
	elseif (mode == "pm") then
		self._PMPlayers = {}
		self._MainPlayers = {}
		frmHub:RegBot(self._Sets.bot)
		SendToAll(self._Sets.botmyinfo)
		self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
		self._Config.mode = mode
	end
end

function TrivEx:GetPlayMode()
	return self._Config.mode
end

function TrivEx:LoadQuestions(getques)
	self._Questions = {n = 0}
	local howmany = self._Sets.memques
	if (self._Config.showquesmode == 1) and (not getques) then
		local getlines = {}
		for _ = 1,howmany do
			getlines[math.random(curTriv.totalques)] = 1
		end
		local handle = io.open(self._Sets.folder.."/"..self._Sets.questionfile,"r")
		if handle then
			local curTrivQuestions = {}
			local slinecount = 0
			local line = handle:read()
			while line do
				slinecount = slinecount + 1
				if getlines[slinecount] then
					local cat,ques,ans = self:SplitLine(line)
					if (cat and ques and ans) then
						table.insert(curTrivQuestions,{cat,ques,ans,slinecount})
					end
				end
				line = handle:read()
			end
			handle:close()
			for _ = 1,table.getn(curTrivQuestions) do
				local num = math.random(table.getn(curTrivQuestions))
				table.insert(self._Questions,curTrivQuestions[num])
				table.remove(curTrivQuestions,num)
			end					
		end
	elseif (self._Config.showquesmode == 2) or (getques) then
		self._Config.sequentialnum = self._Config.sequentialnum or 0
		local getlines = {}
		for _ = 1,howmany do
			self._Config.sequentialnum = self._Config.sequentialnum + 1
			if (self._Config.sequentialnum <= curTriv.totalques) then
				getlines[self._Config.sequentialnum] = 1
				if getques then
					break
				end
			else
				self._Config.sequentialnum = 0
			end
		end
		local handle = io.open(self._Sets.folder.."/"..self._Sets.questionfile,"r")
		if handle then
			local slinecount = 0
			local line = handle:read()
			while line do
				slinecount = slinecount + 1
				if getlines[slinecount] then
					local cat,ques,ans = self:SplitLine(line)
					if (cat and ques and ans) then
						table.insert(self._Questions,{cat,ques,ans,slinecount})
					end
				end
				line = handle:read()
			end
			handle:close()
		end
		if (not getques) then
			TrivEx:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..TrivEx._Sets.TrivConfigFile)
		end
	end	
end

function TrivEx:SplitLine(line,dividechar)
	local dividechar = dividechar or self._Sets.dividechar
	local set,cat,ques,ans = {0,1},"","",{n=0}
	for i = 1,string.len(line) do
		if (string.sub(line,i,i) == dividechar) then
			if (self._Sets.quesmode == 1) then
				if (set[1] == 0) then
					cat = string.sub(line,set[2],(i-1))
					set = { 1,(i+1) }
				elseif (set[1] == 1) then
					ques = string.sub(line,set[2],(i-1))
					ans = string.sub(line,(i+1),string.len(line))
					ans = self:SplitAnswer(ans,dividechar)
					return cat,ques,ans
				end
			elseif (self._Sets.quesmode == 2) then
				ques = string.sub(line,1,(i-1))
				ans = string.sub(line,(i+1),string.len(line))
				ans = self:SplitAnswer(ans,dividechar)
				return cat,ques,ans
			end
		end
	end
end

function TrivEx:SplitAnswer(ans,dividechar)
	local set1,anst = 1,{n=0}
	for i = 1,string.len(ans) do
		if (string.sub(ans,i,i) == dividechar) then
			table.insert(anst,string.sub(ans,set1,(i-1)))
			set1 = (i+1)
		elseif i == string.len(ans) then
			table.insert(anst,string.sub(ans,set1,string.len(ans)))
		end
	end
	return anst
end

function TrivEx:WriteTable(table,tablename,file)
	local hFile = io.open(file,"w+")
	self:Serialize(table,tablename,hFile);
	hFile:close()
end

function TrivEx:Serialize(tTable,sTableName,hFile,sTab)
	sTab = sTab or "";
	hFile:write(sTab..sTableName.." = {\n");
	for key,value in pairs(tTable) do
		if (type(value) ~= "function") then
			local sKey = (type(key) == "string") and string.format("[%q]",key) or string.format("[%d]",key);
			if(type(value) == "table") then
				self:Serialize(value,sKey,hFile,sTab.."\t");
			else
				local sValue = (type(value) == "string") and string.format("%q",value) or tostring(value);
				hFile:write(sTab.."\t"..sKey.." = "..sValue);
			end
			hFile:write(",\n");
		end
	end
	hFile:write(sTab.."}");
end

function TrivEx:ErrorReport(curUser,data)
	if self:AllowedProf("Normal",curUser) then
		local s,e,nr,report = string.find(data,"%b<>%s+%S+%s+(%d+)%s+(.*)") 
		if nr and report then
			table.insert(Report,{nr,report,curUser.sName}) TrivEx:WriteTable(Report,"Report","BUKTOPUHA//ErrorReport.tbl")
			self:SendToUser(curUser,"Ваше сообщение о неправильном ответе отправлено.")
		else
			self:SendToUser(curUser,"*** Ошибка: Введите !trivreport <номер вопроса> <ответ>")
		end
	end
end

function TrivEx:ShowReport(curUser,data)
	if self:AllowedProf("Config+",curUser) then
		local msg = "\r\n"..
"\t\t «»«»«» Таблица не правильных ответов на вопросы «»«»«»\r\n\r\n"..
"\t\tВопрос\t\tКто сообщил\t\tПравильный ответ\r\n\t"..string.rep("-", 200).."\r\n"
		for i = 1, table.getn(Report) do
			msg = msg.."\t\t"..Report[i][1]..".\t\t"..Report[i][3].."\t\t\t"..Report[i][2].."\r\n"
		end
		msg = msg.."\t"..string.rep("-", 200)
		self:SendToUser(curUser,msg)
	end
end

function TrivEx:ShortBreakSkip(curUser) 
	if self:AllowedProf("Config+",curUser) then 
		if curTriv:Pause() then 
			curTriv:SetPause(0) 
			TrivTimers.timebreak = 0 
			TrivTimers.breaktime = 0 
			TrivTimers.showques = TrivEx._Sets.showques - 1 
			self:SendToPlayers("Перерыв был пропущен. Игра продолжается!") 
		end
	end
end 

function TrivEx:TrivHelp(curUser)
	if (self:AllowedProf("Config+",curUser)) then
		self:SendToUser(curUser,TrivEx.Data["HelpConfig+"])
	elseif self:AllowedProf("Config",curUser) then
		self:SendToUser(curUser,TrivEx.Data.HelpConfig)
	elseif self:AllowedProf("Normal",curUser) then
		self:SendToUser(curUser,TrivEx.Data.HelpNormal)
	end
end

function TrivEx:TrivScore(curUser)
	if self:AllowedProf("Normal",curUser) then
		local TCopy = {}
		for i,v in pairs(self._Scores) do table.insert(TCopy, {i,v}) end
		table.sort(TCopy,function(a,b) return(a[2].Score>b[2].Score) end)
		local msg = "\r\n\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t\tТоп "..self._Sets.displscorers.." по очкам.\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,TrivEx._Sets.displscorers do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].Score.."\r\n"
			end
		end
		self:SendToUser(curUser,msg)
	end
end

function TrivEx:TrivMyScore(curUser)
	if self:AllowedProf("Normal",curUser) then
		if self._Scores[curUser.sName] then
			local TCopy = {}
			for i,v in pairs(self._Scores) do table.insert(TCopy, {i,v}) end
			table.sort(TCopy,function(a,b) return(a[2].Score>b[2].Score) end)
			for i = 1,table.getn(TCopy) do
				if TCopy[i][1] == curUser.sName then
					local msg = ""
					if TCopy[(i+1)] and TCopy[(i-1)] then
						msg = "\r\n\r\n\t\t№ "..(i-1).." - "..TCopy[(i-1)][1]..",  Очки: "..TCopy[(i-1)][2].Score..".  Разница = "..(TCopy[(i-1)][2].Score-TCopy[i][2].Score).."."..
						"\r\n\t---->\t№ "..i.." - "..TCopy[i][1]..",  Очки: "..TCopy[i][2].Score.."."..
						"\r\n\t\t№ "..(i+1).." - "..TCopy[(i+1)][1]..",  Очки: "..TCopy[(i+1)][2].Score..".  Разница = "..(TCopy[(i+1)][2].Score-TCopy[i][2].Score).."."
					elseif TCopy[(i-1)] then
						msg = "\r\n\r\n\t\t№ "..(i-1).." - "..TCopy[(i-1)][1]..",  Очки: "..TCopy[(i-1)][2].Score..".  Разница = "..(TCopy[(i-1)][2].Score-TCopy[i][2].Score).."."..
						"\r\n\t--->\t№ "..i.." - "..TCopy[i][1]..",  Очки: "..TCopy[i][2].Score.."."
					elseif TCopy[(i+1)] then
						msg = "\r\n\r\n\t--->\t№ "..i.." - "..TCopy[i][1]..",  Очки: "..TCopy[i][2].Score.."."..
						"\r\n\t\t№ "..(i+1).." - "..TCopy[(i+1)][1]..",  Очки: "..TCopy[(i+1)][2].Score..".  Разница = "..(TCopy[(i+1)][2].Score-TCopy[i][2].Score).."."
					end
					self:SendToUser(curUser,"\r\n\r\n"..
					"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
					"\t\tПерсональная статистика "..curUser.sName..". Всего игроков: "..table.getn(TCopy)..".\r\n".. 
					"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
					"\t"..msg.."\r\n\r\n"..
					"\t\tРекорд правильных ответов подряд: "..TCopy[i][2].Streak..".\r\n"..
					"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n\r\n")
				end
			end
		else
			self:SendToUser(curUser,"У тебя 0 очков.")
		end
	end
end
		 
function TrivEx:TrivStats(curUser)
	if self:AllowedProf("Normal",curUser) then
		local TCopy = {}
		for i,v in pairs(self._Scores) do table.insert(TCopy, {i,v}) end
		table.sort(TCopy,function(a,b) return(a[2].Score>b[2].Score) end)
		local msg = "\r\n\r\n"..
"\t\t\t ### ТОП "..self._Sets.displtoptrivs.." ИГРОКОВ ###\r\n\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t\tТоп "..self._Sets.displtoptrivs.." по очкам.\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displtoptrivs do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].Score.."\r\n"
			end
		end
		table.sort(TCopy,function(a,b) return(a[2].Streak>b[2].Streak) end)
		local msg = msg.."\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\tТоп "..self._Sets.displtoptrivs.." по кол-ву правильных ответов подряд.\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displtoptrivs do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].Streak.."\r\n"
			end
		end
		table.sort(TCopy,function(a,b) return(a[2].AvTime[3]<b[2].AvTime[3]) end)
		local msg = msg.."\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\tТоп "..self._Sets.displtoptrivs.." средней затраты времени на вопрос\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displtoptrivs do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].AvTime[3].." сек\r\n"
			end
		end
		table.sort(TCopy,function(a,b) return(a[2].AvTime[2]>b[2].AvTime[2]) end)
		local msg = msg.."\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\tТоп "..self._Sets.displtoptrivs.." по кол-ву правильных ответов.\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displtoptrivs do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].AvTime[2].."\r\n"
			end
		end
		self:SendToUser(curUser,msg)
	end
end

function TrivEx:TrivStatsTime(curUser)
	if self:AllowedProf("Normal",curUser) then
		local TCopy = {}
		for i,v in pairs(self._Scores) do table.insert(TCopy, {i,v}) end
		table.sort(TCopy,function(a,b) return(a[2].Score>b[2].Score) end)
		local msg = "\r\n\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\tТоп "..self._Sets.displscorers.." по средней затраты времени на вопрос\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displscorers do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].AvTime[3].." сек\r\n"
			end
end
self:SendToUser(curUser,msg)
		end
end

function TrivEx:TrivStatsAnswers(curUser)
	if self:AllowedProf("Normal",curUser) then
		local TCopy = {}
		for i,v in pairs(self._Scores) do table.insert(TCopy, {i,v}) end
		table.sort(TCopy,function(a,b) return(a[2].Score>b[2].Score) end)
		local msg = "\r\n\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\tТоп "..self._Sets.displscorers.." по кол-ву правильных ответов.\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displscorers do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].AvTime[2].."\r\n"
			end
end
self:SendToUser(curUser,msg)
		end
end

function TrivEx:TrivStatsStreak(curUser)
	if self:AllowedProf("Normal",curUser) then
		local TCopy = {}
		for i,v in pairs(self._Scores) do table.insert(TCopy, {i,v}) end
		table.sort(TCopy,function(a,b) return(a[2].Score>b[2].Score) end)
		local msg = "\r\n\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\tТоп "..self._Sets.displscorers.." по кол-ву правильных ответов подряд.\r\n"..
"\t«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»\r\n"..
"\t\t№\tНик\r\n"
		for i = 1,self._Sets.displscorers do
			if TCopy[i] then
				msg = msg.."\t\t"..i.."\t"..TCopy[i][1].." - "..TCopy[i][2].Streak.."\r\n"
			end
end
self:SendToUser(curUser,msg)
		end
end

function TrivEx:Login(curUser)
	if self:AllowedProf("Normal",curUser) then
		if (self:GetPlayMode() == "pm") then
			if not self._PMPlayers[curUser.sName] then
				self._PMPlayers[curUser.sName] = 1
				self:SendToPlayers("\""..curUser.sName.."\" присоединился к игре.")
			else
				self:SendToUser(curUser,"Ты уже играешь!")
			end
		elseif (self:GetPlayMode() == "main") and not TrivEx._Sets.maintoall then
			if not self._MainPlayers[curUser.sName] then
				self._MainPlayers[curUser.sName] = 1
				self:SendToPlayers("\""..curUser.sName.."\" присоединился к игре.")
			else
				self:SendToUser(curUser,"Ты уже играешь!")
			end
		else
			self:SendToUser(curUser,"Викторина проводится в главном чате. Не нужно авторизироваться в игре.")
		end
	end
end

function TrivEx:Logout(curUser)
	if self:AllowedProf("Normal",curUser) then
		if (self:GetPlayMode() == "pm") then
			if self._PMPlayers[curUser.sName] then
				self:SendToPlayers("\""..curUser.sName.."\" покинул игру..")
				self._PMPlayers[curUser.sName] = nil
			else
				self:SendToUser(curUser,mode,"Чтобы покинуть игру, сначала нужно в нее зайти.")
			end
		elseif (self:GetPlayMode() == "main") and not TrivEx._Sets.maintoall then
			if self._MainPlayers[curUser.sName] then
				self:SendToPlayers("\""..curUser.sName.."\" покинул игру..")
				self._MainPlayers[curUser.sName] = nil
			else
				self:SendToUser(curUser,mode,"Чтобы покинуть игру, сначала нужно в нее зайти.")
			end
		else
			self:SendToUser(curUser,"Викторина проводится в главном чате. Не нужно авторизироваться в игре.")
		end
	end
end

function TrivEx:ShowTrivPlayers(curUser)
	if self:AllowedProf("Normal",curUser) then
		if (self:GetPlayMode() == "pm") then
			local players = ""
			for i,_ in pairs(self._PMPlayers) do
				players = players.."\r\n\t-  "..i
			end
			self:SendToUser(curUser,"Сейчас в игре:\r\n"..players.."\r\n")
		elseif (self:GetPlayMode() == "main") and not TrivEx._Sets.maintoall then
			local players = ""
			for i,_ in pairs(self._MainPlayers) do
				players = players.."\r\n\t-  "..i
			end
			self:SendToUser(curUser,"Сейчас в игре:\r\n"..players.."\r\n")
		else
			self:SendToUser(curUser,"Игра в главном чате! Все могут играть!")
		end
	end
end

function TrivEx:DoTrivSkip(curUser)
	if self:AllowedProf("Normal",curUser) then
		if (self._Config.trivskip == 1) then
			if not curTriv:GetGetQues() then
				self:SendToPlayers("\""..curUser.sName.."\" пропустил текущий вопрос.")
				curTriv:SetGetQues(1)
			else
				self:SendToUser(curUser,"Нет вопросов для пропуска")
			end
		else
			self:SendToUser(curUser,"Вопросы пропускать нельзя.")
		end
	end
end

function TrivEx:DoTrivHint(curUser)
	if self:AllowedProf("Normal",curUser) then
		if (self._Config.trivhint == 1) then
			if not curTriv:GetGetQues() then
				self:SendToPlayers("\""..curUser.sName.."\" нуждается в подсказке... Не отказать же ему!")
				curTriv:UpdHint()
				if curTriv:GetGetQues() then
					curTriv:ShowAnswer()
				else
if (TrivEx._Sets.QuestionMode == 1) then 
					curTriv:SendHint()
else
curTriv:SendQuestion()
end
				end
			else
				self:SendToUser(curUser,"Еще нет ни одного текущего вопроса, чтобы брать подсказку")
			end
		else
			self:SendToUser(curUser,"Подсказки отключены.")
		end
	end
end

function TrivEx:TrivStart(curUser)
	if self:AllowedProf("Config",curUser) then
		curTriv.unansques = 0
		curTriv:SetGetQues(1)
		StartTimer()
		self:SendToUser(curUser,"Игра Викторина запущена!")
		self:SendToPlayers("Игра Викторина была запушена! Запустил: "..curUser.sName)
	end
end

function TrivEx:TrivAutoStart()
		curTriv.unansques = 0
		curTriv:SetGetQues(1)
		StartTimer()
end

function TrivEx:TrivStop(curUser)
	if self:AllowedProf("Config",curUser) then
		StopTimer()
		curTriv:SetGetQues(1)
		self:WriteTable(self._Scores,"TrivEx._Scores",self._Sets.folder.."/"..self._Sets.ScoresFile)
		self:SendToUser(curUser,"Игра Викторина остановлена. Видимо, игре пора передохнУть ))")
		self:SendToPlayers("Игра Викторина была остановлена. Остановил: "..curUser.sName)
	end
end

function TrivEx:LoadQuestion(curUser,data)
	if self:AllowedProf("Config",curUser) then
		local _,_,arg1 = string.find(data,"^%b<>%s+%S+%s+(%d+)")
		local num = tonumber(arg1) or 1
		self._Config.sequentialnum = num-1
		self:LoadQuestions(1)
		curTriv:SetGetQues(1)
		self:SendToUser(curUser,"Загрузка вопроса №"..num)
	end
end	

function TrivEx:AddQuestion(curUser,data)
	if self:AllowedProf("Config",curUser) then
		local _,_,newquestion = string.find(data,"^%b<>%s+%S+%s+(.*)")
		if newquestion then
			local Cat,Ques,tAns = self:SplitLine(newquestion,"/")
			if Ques and Ques ~= "" then
				local handle = io.open(self._Sets.folder.."/"..self._Sets.addquestionfile,"a")
				if (self._Sets.quesmode == 1) then
					local msg = ""
					msg = msg.."Категория: "..Cat..", Вопрос: "..Ques..", Ответ: "
					handle:write(Cat..self._Sets.dividechar..Ques)
					for i = 1,table.getn(tAns) do
						msg = msg..tAns[i]..", "
						handle:write(self._Sets.dividechar..tAns[i])
					end
					handle:write("\n")
					self:SendToUser(curUser,"Добавлен следующий вопрос: "..msg)
				elseif (self._Sets.quesmode == 2) then
					local msg = ""
					local handle = io.open(self._Sets.folder.."/"..self._Sets.addquestionfile,"a")
					msg = msg.."Вопрос: "..Ques..", Ответ: "
					handle:write(Ques)
					for i = 1,table.getn(tAns) do
						msg = msg..tAns[i]..", "
						handle:write(self._Sets.dividechar..tAns[i])
					end
					handle:write("\n")
					self:SendToUser(curUser,"Добавлен следующий вопрос: "..msg)
				end
				handle:close()
			else
				self:SendToUser(curUser,"Не правильно задан вопрос: "..newquestion)
			end
		else
			self:SendToUser(curUser,"Команда - командой, но нужно и сам вопрос написать!")
		end
	end
end

function TrivEx:ConfTrivSkip(curUser)
	if self:AllowedProf("Config+",curUser) then
		if (self._Config.trivskip == 1) then
			self._Config.trivskip = 0
			self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
			self:SendToUser(curUser,"Теперь вопросы пропускать нельзя.")
		elseif (self._Config.trivskip == 0) then
			self._Config.trivskip = 1
			self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
			self:SendToUser(curUser,"Теперь можно пропускать вопросы.")
		end
	end
end

function TrivEx:ConfTrivHint(curUser)
	if self:AllowedProf("Config+",curUser) then
		if (self._Config.trivhint == 1) then
			self._Config.trivhint = 0
			self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
			self:SendToUser(curUser,"Подсказки выключены.")
		elseif (self._Config.trivhint == 0) then
			self._Config.trivhint = 1
			self:WriteTable(self._Config,"TrivEx._Config",self._Sets.folder.."/"..self._Sets.TrivConfigFile)
			self:SendToUser(curUser,"Подсказки включены.")
		end
	end
end

function TrivEx:PlayTrivMain(curUser)
	if self:AllowedProf("Config+",curUser) then
		self:SetPlayMode("main")
		self:SendToUser(curUser,"Теперь игра ведется в главном чате.")
	end
end

function TrivEx:PlayTrivPM(curUser)
	if self:AllowedProf("Config+",curUser) then
		self:SetPlayMode("pm")
		self:SendToUser(curUser,"Теперь игра ведется в личке бота.")
	end
end

function TrivEx:ResetScore(curUser)
	if self:AllowedProf("Config+",curUser) then
		self._Scores = {}
		self:WriteTable(self._Scores,"TrivEx._Scores",self._Sets.folder.."/"..self._Sets.ScoresFile)
		self:SendToUser(curUser,"Очки обнулены.")
	end
end

function TrivEx:ChangeQuesMode(curUser)
	if self:AllowedProf("Config+",curUser) then
		if (self._Config.showquesmode == 1) then
			self._Config.showquesmode = 2
			self:LoadQuestions()
			self:SendToUser(curUser,"Теперь вопросы идут подряд.")
		elseif (self._Config.showquesmode == 2) then
			self._Config.showquesmode = 1
			self:LoadQuestions()
			self:SendToUser(curUser,"Теперь вопросы задаются случайным образом.")
		end
		self:WriteTable(self._Scores,"TrivEx._Scores",self._Sets.folder.."/"..self._Sets.ScoresFile)
	end
end

---------------------------------------------------------------------------------------
--	TRIVIA GAME
---------------------------------------------------------------------------------------

TrivTimers = {}
TrivTimers.timebreak = 0
TrivTimers.breaktime = 0
TrivTimers.showques = 0
TrivTimers.savestats = 0
UnRevealed = {}
FirstLetters = {}
curTriv = {}
curTriv.unansques = 0
curTriv.totalques = 0
curTriv.pause = 0
curTriv.getques = 1
curTriv.quesnum = 0
curTriv.cat = ""
curTriv.ques = ""
curTriv.ans = {}
curTriv.availans = 0
curTriv.points = 0
curTriv.hint = ""
curTriv.unrevealed = {}
curTriv.unrevealed.fl = {n = 0}
curTriv.unrevealed.ol = {n = 0}
curTriv.revealnum = 0
curTriv.streak = {}
curTriv.streak.nick = ""
curTriv.streak.streak = 0
curTriv.streak.write_scores = 0

-------------------------------------

-- funcs curTriv.streak

curTriv.streak.UpdStreak = function(self,curUser)

	if curUser then
		-- Write Scores by next saving
		curTriv.streak.write_scores = 1
		-- Set Unanswered Questions to zero
		curTriv.unansques = 0
		local nick = curUser.sName
		if (self.nick == nick) then
			self.streak = self.streak + 1
			if (self.streak > TrivEx._Scores[curUser.sName].Streak)  then
		--		if TrivEx._Sets.showstreak then TrivEx:SendToPlayers(nick..", ты правильно ответил на "..TrivEx._Scores[curUser.sName].Streak.." вопросов подряд.") end
				TrivEx._Scores[curUser.sName].Streak = self.streak
			end
			if TrivEx._Sets.showstreak then
				if (self.streak >= 16) then
					TrivEx:SendToPlayers("Правильных ответов подряд: "..self.streak..".")
				elseif (self.streak == 15) then
					TrivEx:SendToPlayers(nick.." ты действительно крут! ;) Ты правильно ответил на "..self.streak.." вопросов подряд. Удивительно!")
				elseif (self.streak == 10) then
					TrivEx:SendToPlayers(nick.." уже "..self.streak.." правильных ответов подряд! Может быть пора остановиться?! Возьми еще спирта =)")
				elseif (self.streak == 5) then
					TrivEx:SendToPlayers(nick.."'у вручается бутылка медицинского спирта за "..self.streak.." правильно отгаданных вопросов! (брать у Синяка :) )")
				elseif (self.streak == 3) then
					TrivEx:SendToPlayers(nick..", получает в башню за "..self.streak.." правильно отгаданных вопроса подряд!")
				end
			end
		else
			if TrivEx._Sets.showstreak then
				if (self.streak >= 15) then
					TrivEx:SendToPlayers(nick.." оборвал цепочку "..self.nick.." из "..self.streak.." отгаданных вопросов подряд! А ведь он шел на рекорд!")
				elseif (self.streak >= 10) then
					TrivEx:SendToPlayers(self.nick..": 'Похоже, пора сделать паузу. А тебе, "..nick..", я припомню, как ты оборвал мою цепочку из "..self.streak.." ответов подряд!'")
				elseif (self.streak >= 5) then
					TrivEx:SendToPlayers("Чйорд, "..self.nick.."! "..nick.." разрушил твою цепочку, состоящую из "..self.streak.." ответов подряд.")
				elseif (self.streak >= 3) then
					TrivEx:SendToPlayers("Ты прервал цепочку "..self.nick.."'a, состоящую из "..self.streak.." отгаданных вопросов подряд!")
				end
			end
			self.nick = nick
			self.streak = 1
		end
	else
		if (TrivEx._Sets.keepstreak ~= 1) then
			if (self.nick ~= "") and TrivEx._Sets.showstreak then
				if (self.streak >= 15) then
					TrivEx:SendToPlayers("Мы так и знали, что на этом вопросе оборвется  цепочка "..self.nick.."'a из "..self.streak.." ответов ;)")
				elseif (self.streak >= 10) then
					TrivEx:SendToPlayers(self.nick.." скажи 'пока' твоей цепочке из "..self.streak.." отгаданных вопросов подряд.")
				elseif (self.streak >= 3) then
					  TrivEx:SendToPlayers("Цепочка правильно отгаданных вопросов "..self.nick.." прервалась на "..self.streak.." вопросе")
				end
			end
			self.nick = ""
			self.streak = 0
		end
	end
end
function curTriv:Pause()
	if (self.pause == 1) then
		return 1
	end
end

function curTriv:SetPause(arg)
	self.pause = arg
end

function curTriv:GetNewQues()
	if (self.getques == 1) then
		self:GetQuestion()
		return 1
	end
end

function curTriv:GetQuestion()
	self.quesnum = TrivEx._Questions[1][4]
	self.cat = TrivEx._Questions[1][1]
	self.ques = TrivEx._Questions[1][2]
	self.ans = TrivEx._Questions[1][3]
	self.availans = table.getn(self.ans)
	table.remove(TrivEx._Questions,1)
	self.points = 0
	self.hint = string.gsub(self.ans[1],"(%S)",function (w)  self.points = self.points + 1 return(TrivEx._Sets.revealchar) end)
	self.unrevealed.fl = {n = 0}
	self.unrevealed.ol = {n = 0}
	for i = 1,string.len(self.hint) do
		if (string.sub(self.hint,i,i) == TrivEx._Sets.revealchar) then
			if (TrivEx._Sets.revealques == 2) and ((i == 1) or (string.sub(self.hint,(i-1),(i-1)) == " ")) then
				table.insert(self.unrevealed.fl,i)
			else
				table.insert(self.unrevealed.ol,i)
			end
		end
	end
	if (TrivEx._Sets.trivshowhint == 2) then
		if ((self.points/TrivEx._Sets.shownhints - math.floor(self.points/TrivEx._Sets.shownhints)) >= 0.5) then
			self.revealnum = math.floor(self.points/TrivEx._Sets.shownhints) + 1
		elseif (math.floor(self.points/TrivEx._Sets.shownhints) == 0) then
			self.revealnum = 1
		else
			self.revealnum = math.floor(self.points/TrivEx._Sets.shownhints)
		end
	else
		self.revealnum = TrivEx._Sets.revealedchars
	end
	self.start = os.clock()
	self:SetGetQues(0)
end

function curTriv:SetGetQues(arg)
	TrivTimers.showques = 0
	self.getques = arg
end

function curTriv:GetGetQues()
	if (self.getques == 1) then	
		return 1
	end
end

function curTriv:SendQuestion()
if (TrivEx._Sets.QuestionMode == 1) then
	if (TrivEx._Sets.showquestion == 1) then
		TrivEx:SendToPlayers("Категория: "..self.cat)
		TrivEx:SendToPlayers(self.quesnum..". "..self:doSplitQuestion("Вопрос: "..self.ques))
		TrivEx:SendToPlayers("Подсказка:  "..self.hint.."  "..self.points.." букв(ы)")

	elseif (TrivEx._Sets.showquestion == 2) then
		TrivEx:SendToPlayers(self.quesnum..". "..self:doSplitQuestion("Вопрос: "..self.ques))
		TrivEx:SendToPlayers("Подсказка:  "..self.hint.."  "..self.points.." букв(ы)")
		
	elseif (TrivEx._Sets.showquestion == 3) then
		TrivEx:SendToPlayers(self.quesnum..". "..self:doSplitQuestion("Вопрос: "..self.ques))
		TrivEx:SendToPlayers("Подсказка:  "..self.hint.."  "..self.points.." букв(ы)")
	end
end
if (TrivEx._Sets.QuestionMode == 0) then
	if (TrivEx._Sets.showquestion == 1) then
		TrivEx:SendToPlayers("Вопрос № "..self.quesnum.." из "..self.totalques..".\r\n"..
		"\t"..string.rep("-", 70).."\r\n"..
		"\t> Категория: "..self.cat.." - Очки: "..self.points.." - Варианты ответов: "..self.availans.."\r\n"..
		"\t"..self:doSplitQuestion("Вопрос: "..self.ques).."\r\n"..
		"\tПодсказка:  "..self.hint.."\r\n"..
		"\t"..string.rep("-", 70))
	elseif (TrivEx._Sets.showquestion == 2) then
		TrivEx:SendToPlayers("Вопрос № "..self.quesnum.." из "..self.totalques..".\r\n"..
		"\t"..string.rep("-", 70).."\r\n"..
		"\t> Очки: "..self.points.." - Варианты ответов: "..self.availans.."\r\n"..
		"\t"..self:doSplitQuestion("Вопрос: "..self.ques).."\r\n"..
		"\tПодсказка:  "..self.hint.."\r\n"..
		"\t"..string.rep("-", 70))
	elseif (TrivEx._Sets.showquestion == 3) then
		TrivEx:SendToPlayers("\r\n"..
		"\r\n"..
		"\t"..self:doSplitQuestion("Вопрос: "..self.ques).."\r\n"..
		"\tПодсказка:  "..self.hint.."\r\n"..
		"")
	end
end
end

function curTriv:SendHint()
if (TrivEx._Sets.shownhintscore == 1) then
		TrivEx:SendToPlayers("Подсказка:  "..self.hint)
		TrivEx:SendToPlayers("Стоимость вопроса: " ..self.points..".")
else
		TrivEx:SendToPlayers("Подсказка:  "..self.hint)
end
end

function curTriv:doSplitQuestion(sQues)
	for i = TrivEx._Sets.splitques,string.len(sQues) do
		if (string.sub(sQues,i,i) == " ") then
			local srest = string.sub(sQues,(i+1),string.len(sQues))
			srest = self:doSplitQuestion(srest)
			return (string.sub(sQues,1,(i-1)).."\r\n\t "..srest)
		end
	end
	return(sQues)
end

function curTriv:UpdHint()
	local thint = self:toTable(self.hint)
	if (TrivEx._Sets.revealques == 1) then
		for _ = 1,curTriv.revealnum do
			if (table.getn(curTriv.unrevealed.ol) ~= 0) then
				local rannum = math.random(table.getn(curTriv.unrevealed.ol))
				local strnum = curTriv.unrevealed.ol[rannum]
				thint[strnum] = string.sub(self.ans[1],strnum,strnum)
				curTriv.points = curTriv.points - 1
				table.remove(curTriv.unrevealed.ol,rannum)
			end
		end
	elseif(TrivEx._Sets.revealques == 2) then
		for _ = 1,curTriv.revealnum do
			if (table.getn(curTriv.unrevealed.fl) ~= 0) then
				local rannum = math.random(table.getn(curTriv.unrevealed.fl))
				local strnum = curTriv.unrevealed.fl[rannum]
				thint[strnum] = string.sub(self.ans[1],strnum,strnum)
				curTriv.points = curTriv.points - 1
				table.remove(curTriv.unrevealed.fl,rannum)
			elseif (table.getn(curTriv.unrevealed.ol) ~= 0) then
				local rannum = math.random(table.getn(curTriv.unrevealed.ol))
				local strnum = curTriv.unrevealed.ol[rannum]
				thint[strnum] = string.sub(self.ans[1],strnum,strnum)
				curTriv.points = curTriv.points - 1
				table.remove(curTriv.unrevealed.ol,rannum)
			end
		end
	end
	self.hint = self:toString(thint)
	if ((table.getn(curTriv.unrevealed.fl)+table.getn(curTriv.unrevealed.ol)) < TrivEx._Sets.solveques) then
		self.hint = self.ans[1]
		self:SetGetQues(1)
	end
end

function curTriv:toTable(String)
	local Table = {n = 0}
	for i = 1,string.len(String) do
		table.insert(Table,string.sub(String,i,i))
	end
	return Table
end

function curTriv:toString(Table)
	local String = ""
	for i = 1,table.getn(Table) do
		String = String..Table[i]
	end
	return(String)
end

function curTriv:ShowAnswer()
	TrivEx:SendToPlayers("Правильный ответ:  \""..curTriv.ans[1].."\".")
	if curTriv.availans > 1 then
		local msg = ""
		for i = 2,curTriv.availans do
			msg = msg.."\""..curTriv.ans[i].."\", "
		end
		msg = string.sub(msg,1,string.len(msg)-2)
		TrivEx:SendToPlayers("Еще правильные ответы: "..msg..".")
	end
end

-- Помощь в игре

TrivEx.Data.HelpNormal = "\r\n\r\n"..
"\t«»«»«» Викторина V."..TrivEx._Sets.Version.." от NRJ «»«»«»\r\n"..
	"\t"..string.rep("-", 95).."\r\n"..
	"\t"..HintTrigg.."\t\t- Помощь по игре\r\n"..
	"\t"..string.rep("-", 95).."\r\n"..
	"\t"..Login.."\t\t- Начать игру\r\n"..
	"\t"..Logout.."\t\t- Выйти из игры\r\n"..
	"\t"..ShowTrivPlayers.."\t\t- Кто сейчас играет\r\n"..
	"\t"..TrivMyScore.."\t\t- Посмотреть свою статистику\r\n"..
	"\t"..DoTrivSkip.."\t- Пропустить вопрос\r\n"..
	"\t"..DoTrivHint.."\t- Подсказка\r\n"..
	"\t!trivreport\t\t- Сообщить об ошибке\r\n"..
	"\t"..string.rep("-", 95).."\r\n"..
	"\t"..TrivStats.."\t\t- Показать топ"..TrivEx._Sets.displtoptrivs.." \r\n"..
	"\t"..TrivScore.."\t- Топ "..TrivEx._Sets.displscorers.." по очкам\r\n"..
	"\t"..TrivStatsAnswers.."\t- Топ "..TrivEx._Sets.displscorers.." по кол-ву верных ответов\r\n"..
	"\t"..TrivStatsTime.."\t- Топ "..TrivEx._Sets.displscorers.." по среднему времени на ответ\r\n"..
	"\t"..TrivStatsStreak.."\t- Топ "..TrivEx._Sets.displscorers.." по кол-ву страйков\r\n"..
	"\t"..string.rep("-", 95).."\r\n"

TrivEx.Data.HelpConfig = TrivEx.Data.HelpNormal..
	"\t"..TrivStart.."\t- Включить Викторину\r\n"..
	"\t"..TrivStop.."\t- Выключить Викторину\r\n"..
	"\t!trivquestion\t- Начать игру с № вопроса\r\n"..
	"\t!trivaddquestion\t- Добавить вопрос\r\n"..
	"\t"..string.rep("-", 95).."\r\n"

TrivEx.Data["HelpConfig+"] = TrivEx.Data.HelpConfig..
	"\t"..ConfTrivSkip.."\t\t- Включить/Выключить пропуск вопросов\r\n"..
	"\t"..ConfTrivHint.."\t\t- Включить/Выключить подсказки\r\n"..
	"\t"..PlayTrivMain.."\t\t- Играть в главном чате\r\n"..
	"\t"..PlayTrivPM.."\t\t- Играть в личке бота\r\n"..
	"\t"..ResetScore.."\t- Сбросить все очки\r\n"..
	"\t"..ChangeQuesMode.."\t- Вопросы подаются случайным образом или подряд\r\n"..
	"\t!showreport\t- Показать отчет об ошибках\r\n"..
	"\t"..ShortBreakSkip.."\t- Пропустить паузу в игре\r\n\r\n"..
	"\tПо желанию администатора та или ина команда может быть отключена\r\n"..
	"\t"..string.rep("-", 95).."\r\n"

function TrivEx:GetCommands(curUser)
if (self:AllowedProf("Config",curUser)) then
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Включить$<%[mynick]> "..TrivStart.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Выключить$<%[mynick]> "..TrivStop.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Добавить вопрос$<%[mynick]> !trivaddquestion %[line:Введите вопрос] %[line:Введите ответ]&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Начать с № вопроса$<%[mynick]> !trivquestion %[line:Введите номер вопроса]&#124;")
end
if (self:AllowedProf("Config+",curUser)) then
curUser:SendData("$UserCommand 0 3")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Вкл/Выкл пропуск вопросов$<%[mynick]> "..ConfTrivSkip.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Вкл/Выкл подсказки$<%[mynick]> "..ConfTrivHint.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Игра в главном чате$<%[mynick]> "..PlayTrivMain.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Игра в личке бота$<%[mynick]> "..PlayTrivPM.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Сбросить очки$<%[mynick]> "..ResetScore.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Вид подачи вопросов$<%[mynick]> "..ChangeQuesMode.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Просмотреть ошибки$<%[mynick]> !showreport&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Управление\\Пропустить паузу в игре$<%[mynick]> "..ShortBreakSkip.."&#124;")
end
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Старт$<%[mynick]> "..Login.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Стоп$<%[mynick]> "..Logout.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Топы\\Топ "..self._Sets.displtoptrivs.." лучших$<%[mynick]> "..TrivStats.."&#124;")
curUser:SendData("$UserCommand 0 3")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Топы\\Топ "..self._Sets.displscorers.." по очкам$<%[mynick]> "..TrivScore.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Топы\\Топ "..self._Sets.displscorers.." по кол-ву ответов$<%[mynick]> "..TrivStatsAnswers.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Топы\\Топ "..self._Sets.displscorers.." по кол-ву страйков$<%[mynick]> "..TrivStatsStreak.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Топы\\Топ "..self._Sets.displscorers.." по времени$<%[mynick]> "..TrivStatsTime.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Игроки$<%[mynick]> "..ShowTrivPlayers.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Твои очки$<%[mynick]> "..TrivMyScore.."&#124;")
if (self._Config.trivhint == 1) then
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Подсказка$<%[mynick]> "..DoTrivHint.."&#124;")
end
if (self._Config.trivskip == 1) then
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Пропустить$<%[mynick]> "..DoTrivSkip.."&#124;")
end
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Помощь$<%[mynick]> "..HintTrigg.."&#124;")
curUser:SendData("$UserCommand 1 3 "..self._Sets.MenuName.."\\Сообщить об ошибке$<%[mynick]> !trivreport %[line:Номер вопроса] %[line:Правильный ответ]&#124;")
end

TrivEx._Cmds = {}

-- Данные команды менять не следует
TrivEx._Sets.prefixes = "!"
TrivEx._Cmds.showreport = TrivEx.ShowReport		-- Просмотреть отчет об ошибках в вопросах 
TrivEx._Cmds.trivreport = TrivEx.ErrorReport		-- Сообщить об ошибке
TrivEx._Cmds.trivquestion = TrivEx.LoadQuestion		-- Начать с нужного номера вопроса
TrivEx._Cmds.trivaddquestion = TrivEx.AddQuestion	-- Добавить вопрос



