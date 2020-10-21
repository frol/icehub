-- Версия под LUA 5.1.х by NRJ

BotName = "[Анаграммы]" -- имя бота
BotDescription="Игра Анаграммы" -- описание бота
HelpBot = "Help" -- помощь
ScriptVersion = "v1.00" -- версия бота
BotVersion = BotName.." "..ScriptVersion 

strTrivScoreFile = "Anagram//AnagramScores.txt" -- файл, в котором будут храниться очки игроков
strDefTrivFile = "Anagram//anagrams_base.txt" -- файл, в котором будут лежать вопросы
strQFile = "anagrams_base.txt"
strGSep = "*" -- значок разделения вопросов в strDefTrivFile
strCMask = "@" -- такими символами будет закодировано изначальное слово
strTrivFile = strDefTrivFile

lngDefMode = 2 -- (0 = игра в главном чате!, 1 = игра в главном чате, но вопросы видят только игроки, 2 = игра в привате бота)
lngMode = lngDefMode
lngMaxShowList = 5
lngMaxHints = 0 --кол-во подсказок, которые может запросить игрок командой !подсказка
boolHintAlwaysHitHidden = nil -- (nil = выкл, 1 = вкл)

lngMaxTime = 8 -- (Needs to be a multiple of 4   i.e. 4 / 8 / 12 / 16)
lngRestTime = 0
lngHintTime = lngMaxTime / 4

boolAutoSaveScores = 1 -- (nil = off, 1 = on)
countSaveTurns = 1 -- Через какое кол-во вопросов очки будут сохранены
boolRevealAnswer = 1 -- (nil = off, 1 = on)
boolShowGuessesInPM = 1 -- (nil = off, 1 = on)
boolAutoHint = 1 -- (nil = off, 1 = on)
boolAutoLogin = nil -- (nil = off, 1 = on)
boolAddQuestion = nil -- (nil = No, 1 = Yes)

TriggStart = "+"
JoinTrigg = TriggStart.."старт"
JoinTrigg = TriggStart.."старт"
PartTrigg = TriggStart.."стоп"
StartTrigg = TriggStart.."abstart"
StopTrigg = TriggStart.."abstop"
WordTrigg = TriggStart.."abword"
QuizTrigg = TriggStart.."слово"
RestartTrigg = TriggStart.."abrestart"
PointTrigg = TriggStart.."очки"
ScoreTrigg = TriggStart.."топ"
PlayerTrigg = TriggStart.."игроки"
QuestionsTrigg = TriggStart.."abquestions"
ReloadTrigg = TriggStart.."abreload"
HelpTrigg = TriggStart.."хелп"
ExtraHelpTrigg = TriggStart.."abhelp+"
SaveTrigg = TriggStart.."absavescores"
LoadTrigg = TriggStart.."abloadscores"
ModeTrigg = TriggStart.."abmode"
HintTrigg = TriggStart.."подсказка"
TopTrigg = TriggStart.."топ10"
Top20Trigg = TriggStart.."топ20"
Top100Trigg = TriggStart.."топ100"
AddTrigg = TriggStart.."abaddquestion"

scoreload = 0
bcount = 0
scount = 0
sQuestion = ""
sAnswer = ""
guessArray = {}
lngGuessmax = 0
playerArray = {}
pointArray = {}
lngWord = 0
lngPassed = 0
lngHinted = 0
strWord = ""
strQuestion = ""
strSolved = ""
strBanner = "Напишите '"..JoinTrigg.."' чтобы присоединиться '"..PartTrigg.."' чтобы уйти!"
strStart = "Игра Анаграммы "..ScriptVersion.." запущена! "..strBanner
strStopp = "Игра Анаграммы "..ScriptVersion.." остановлена! "..strBanner
----------------------
AllowedProfiles = { 
[0] = 1,   -- Masters
[1] = 0,   -- Operators
[4] = 0,   -- Moderator
[5] = 0,   -- NetFounder
}
----------------------
function Main()
loadfile(strTrivScoreFile) 
	if scoreload == 0 then 
		local handle = io.open(strTrivScoreFile, "r")
		if (handle) then
			local line = handle:read()
			while line do
				local arrTmp = tokenize(line, strGSep)
				if ((arrTmp[1] ~= nil) and (arrTmp[2] ~= nil)) then
					pointArray[arrTmp[1]] = tonumber(arrTmp[2])
				end
				line = handle:read()
			end
			handle:close()
		end
		scoreload =1
	end
	ReloadQuestions()
	frmHub:RegBot(BotName, 1, "[ИГРА] Отгадай загаданное слово!", "");
end

function OnExit()
	local handle = io.open(strTrivScoreFile, "w")
	for index, value in pairs(pointArray) do
    	handle:write(index..strGSep..value.."\r\n")
	end
	handle:close()
end
------------------------

function NewUserConnected(curUser)
	if (boolAutoLogin) then
		if (not (playerArray[curUser.sName])) then
			playerArray[curUser.sName] = 1
		else
			playerArray[curUser.sName] = nil
		end
	end
SendMenu(curUser)
end
------------------------------
function UserDisconnected(curUser)
	playerArray[curUser.sName] = nil
end
-------------------------------
function ChatArrival(curUser, data)
  local boolPlaydata = nil
  if (string.sub(data, 1, 1) == "<") then
    data = string.sub(data, 1, (string.len(data) - 1))
    if ((lngMode == 0) or (lngMode == 1)) then
      boolPlaydata = 1
    end
  elseif (string.sub(data, 1, 4) == "$To:") then
    data = string.sub(data, 1, (string.len(data) - 1))
    local _, _, whoTo = string.find(data,"$To:%s+(%S+)")
    if (whoTo == BotName) then
      data = string.sub(data, (15 + string.len(BotName) + string.len(curUser.sName)))
      if (lngMode == 2) then
        boolPlaydata = 1
	local _, _, chat = string.find(data, "%b<>%s(.+)")
	SendChatToOthers(chat, curUser)
      end
    end
  end

  local _, _, firstWord = string.find(data, "%b<>%s+(%S+)")
  
  if (firstWord ~= nil) then
    if ((string.lower(firstWord) == string.lower(HelpTrigg)) or (string.lower(firstWord) == string.lower(ExtraHelpTrigg))) then
      showHelp(curUser)
    elseif (string.lower(firstWord) == "!tbskip") then 
	lngPassed = lngMaxTime
	SendToPlayers("Вопрос был пропущен "..curUser.sName.."'ом.  Ждите следующего вопроса") 
	curUser:SendPM(BotName,"Ответ был: "..strWord)
	HoldQuiz()
	return 1
    elseif (string.lower(firstWord) == string.lower(SaveTrigg)) then
      if (curUser.bOperator) then
        SaveScores(curUser)
      end
      return 1
    elseif (string.lower(firstWord) == string.lower(LoadTrigg)) then
      if (curUser.bOperator) then
        LoadScores(curUser)
      end
      return 1
    elseif (string.lower(firstWord) == string.lower(TopTrigg)) then
	  TopTen(user)
	  return 1
	      elseif (string.lower(firstWord) == string.lower(Top20Trigg)) then
	local index = {n=0}
	for nick, score in pairs(pointArray) do table.insert(index, nick) end
	local func = function(a, b) return pointArray[a] > pointArray[b] end
	table.sort(index, func)
	y = y or 20 if y > index.n then y = index.n end
	local result = "\r\nТоп "..y.." игры Анаграммы!..\r\n Место\t Очки\t\t Ник\t\r\n"
	for i = 1, y do result = result.."\r\n "..i..".\t"..pointArray[index[i]].."\t\t"..index[i] end
	msg = result
	curUser:SendPM(BotName,msg)
	  	  return 1
		      elseif (string.lower(firstWord) == string.lower(Top100Trigg)) then
	local index = {n=0}
	for nick, score in pairs(pointArray) do table.insert(index, nick) end
	local func = function(a, b) return pointArray[a] > pointArray[b] end
	table.sort(index, func)
	z = z or 100 if z > index.n then z = index.n end
	local result = "\r\nТоп "..z.." игры Анаграммы!..\r\n Место\t Очки\t\t Ник\t\r\n"
	for i = 1, z do result = result.."\r\n "..i..".\t"..pointArray[index[i]].."\t\t"..index[i] end
	msg = result
	curUser:SendPM(BotName,msg)
	  	  return 1	    
    elseif (string.lower(firstWord) == string.lower(AddTrigg)) then
      if (boolAddQuestion) then
	s,e,sQuestion,sAnswer = string.find(data, "%b<>%s+%S+%s+(.+)#(.+)")	
	  AddQuestion(curUser,sQuestion,sAnswer)
      elseif (curUser.bOperator) then
      	s,e,sQuestion,sAnswer = string.find(data, "%b<>%s+%S+%s+(.+)#(.+)")	
	  AddQuestion(curUser,sQuestion,sAnswer)
      else
	  SendToPlayers("Извините, но сейчас вы не можете добавить вопрос")
      end
     return 1
    elseif (string.lower(firstWord) == string.lower(ModeTrigg)) then
      if (curUser.bOperator) then
        local _, _, ModeDigit = string.find(data, "%b<>%s+%S+%s+(%d+)")
        if (ModeDigit ~= nil) then
          lngMode = tonumber(ModeDigit)
          if (lngMode == 0) then
            SendToPlayers("Игра в чате!")
          elseif (lngMode == 1) then
            SendToPlayers("Игра в чате, но вопросы будут видны только игрокам ")
          elseif (lngMode == 2) then
            SendToPlayers("Игра в привате бота")
          else
            SendToPlayers("Ошибка! Такого режима нет!")
            lngMode = lngDefMode
          end
        end
      end
   	  return 1
    elseif (string.lower(firstWord) == string.lower(JoinTrigg)) then
      if (not (playerArray[curUser.sName])) then
        playerArray[curUser.sName] = 1
        SendToPlayers(curUser.sName.." теперь играет с нами!")
      else curUser:SendPM(BotName, "You are already a player and you didn't know. Possibly because you were autologged in")
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(PartTrigg)) then
      if (playerArray[curUser.sName]) then
        SendToPlayers(curUser.sName.." покинул нас!")
        playerArray[curUser.sName] = nil
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(RestartTrigg)) then 
	if (curUser.iProfile == 0) then 
		SendToPlayers("Бот был перезагружен. Все очки потеряны!") 
		SendToPlayers("If Save is used now it will overwrite the old save!") 
		pointArray = {} 
		StopQuiz(1) 
      end 
	  return 1
    elseif ((string.lower(firstWord) == string.lower(PointTrigg)) and (playerArray[curUser.sName])) then
      if (pointArray[curUser.sName]) then
        SendToPlayers(curUser.sName.." у вас "..pointArray[curUser.sName].." очков!")
      else
        SendToPlayers(curUser.sName.." у вас 0 очков!")
      end
	  return 1
    elseif ((string.lower(firstWord) == string.lower(HintTrigg)) and (playerArray[curUser.sName])) then
      if ((lngWord ~= 0) and string.find(strSolved, strCMask, 1, plain)) then
        if (lngHinted < lngMaxHints) then
  	  for nn=1,bcount do
              local lngRepChar = math.random(1, string.len(strWord))
              while 1 do
                if (boolHintAlwaysHitHidden) then
                  if (string.sub(strSolved, lngRepChar, lngRepChar) == strCMask) then
                    break
                  end
                else
                  break
                end
                lngRepChar = math.random(1, string.len(strWord))
              end
              local strTurn = ""
              for x=1, string.len(strWord) do
                if (x == lngRepChar) then
                 strTurn = strTurn..string.sub(strWord, x, x)
                else
                  strTurn = strTurn..string.sub(strSolved, x, x)
                end
	      end
              strSolved = strTurn
	  end
            lngHinted = lngHinted + 1
	    lngHintTimeCount = lngHintTimeCount + lngHintTime
            SendToPlayers("Hint: "..strSolved)
	    acount = ""
         else
            SendToPlayers("Все подсказки для этого слова уже использованы!")
       end
      else
        SendToPlayers("Подсказки не нужны!")
      end
	  return 1
    elseif ((string.lower(firstWord) == string.lower(ScoreTrigg)) and (playerArray[curUser.sName])) then
      curUser:SendPM(BotName, "ТОП:")
      curUser:SendPM(BotName, "---------------------------------------------------------")
      for index, value in pairs(pointArray) do
        curUser:SendPM(BotName, index.."'s очки: "..value)
      end
      curUser:SendPM(BotName, "---------------------------------------------------------")
	  return 1
    elseif ((string.lower(firstWord) == string.lower(PlayerTrigg)) and (playerArray[curUser.sName])) then
      curUser:SendPM(BotName, "Игроки:")
      curUser:SendPM(BotName, "---------------------------------------------------------")
      for index, value in pairs(playerArray) do
        curUser:SendPM(BotName, index)
      end
      curUser:SendPM(BotName, "---------------------------------------------------------")
	  return 1
    elseif (string.lower(firstWord) == string.lower(QuestionsTrigg)) then
      if (curUser.bOperator) then
        curUser:SendPM(BotName, "ТОП "..lngMaxShowList.." ВОПРОСЫ:")
        curUser:SendPM(BotName, "---------------------------------------------------------")
        local lngShowMax = lngMaxShowList
        for index, value in pairs(guessArray) do
          if (lngShowMax == 0) then
            break
          end
          arrTmp = tokenize(guessArray[index], strGSep)
          strTmp = arrTmp[1]
          curUser:SendPM(BotName, "["..index.."] "..strTmp)
          lngShowMax = lngShowMax - 1
        end
        curUser:SendPM(BotName, "Всего вопросов: "..lngGuessmax)
        curUser:SendPM(BotName, "---------------------------------------------------------")
        curUser:SendPM(BotName, " ")
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(StartTrigg)) then
      if (curUser.bRegistered) then
        if (lngWord == 0) then
          playerArray[curUser.sName] = 1
          SendToAll(BotName, strStart)
          if (lngMode == 2) then
            SendToPlayers(strStart)
          end
          StopQuiz(1)
        else
          SendToAll(BotName, "Игра уже началась! Напишите "..JoinTrigg.." для начала игры!")
        end
      else
	curUser:SendPM(BotName, "Только операторы могут загружать Анаграммы.")
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(StopTrigg)) then
      if (curUser.bOperator) then
        HoldQuiz()
        StopQuiz()
        SendToAll(BotName, strStopp)
        if (lngMode == 2) then
          SendToPlayers(strStopp)
        end
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(WordTrigg)) then
      if ((lngWord ~= 0) and (playerArray[curUser.sName] == "Player")) then
        SendToPlayers("Current question is: "..strSolved.." ("..string.len(strSolved)..")")
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(QuizTrigg)) then
      if ((lngWord ~= 0) and (playerArray[curUser.sName])) then
        SendToPlayers("Вопрос: "..strQuestion)
      end
	  return 1
    elseif (string.lower(firstWord) == string.lower(ReloadTrigg)) then
      if (curUser.bOperator) then
        local _, _, secondWord = string.find(data, "%b<>%s+%S+%s+(%S+)")
        if (secondWord) then
        handle = io.open(secondWord, "r")
          if (handle) then
            handle:close()
            strTrivFile = secondWord
          end
        end
        
        HoldQuiz()
        ReloadQuestions()
      end
	  return 1
    else
	if ((lngWord ~= 0) and (boolPlaydata)) then
        if (playerArray[curUser.sName]) then
          local msg = string.sub(data, (4 + string.len(curUser.sName)))
          if (string.len(msg) >= string.len(strWord)) then
            local boolDisc = nil
            
	local strTurn = "" 
		  if string.lower(msg) == string.lower(strWord) then 
		    strTurn = strWord
		    boolDisc = 1 
		  else 
		    strTurn = strSolved
		  end 
 
            
            if (boolDisc) then
              strSolved = strTurn
            end
            if (boolDisc) then
              if (string.lower(msg) ~= string.lower(strWord)) then
                SendToOthers(curUser, msg)
                SendToPlayers("Answer is now: "..strSolved)
              end
            end
            if (string.lower(msg) == string.lower(strWord)) then
              if (not (pointArray[curUser.sName])) then
                pointArray[curUser.sName] = 0
              end
		if lngHinted == 4 then pointArray[curUser.sName] = pointArray[curUser.sName] + 1
		elseif lngHinted == 3 then pointArray[curUser.sName] = pointArray[curUser.sName] + 2
		elseif lngHinted == 2 then pointArray[curUser.sName] = pointArray[curUser.sName] + 3
		elseif lngHinted == 1 then pointArray[curUser.sName] = pointArray[curUser.sName] + 4
		else pointArray[curUser.sName] = pointArray[curUser.sName] + 5
		end 
	      local worth = (5 - lngHinted)
	      SendToPlayers("  ")
	      SendToPlayers("Ответ: "..strSolved.." был дан: "..curUser.sName) 
   	      SendToPlayers("Цена вопроса : "..worth.." очков")            
              lngPassed = lngMaxTime
              SendToPlayers(curUser.sName.."'s очки: "..pointArray[curUser.sName])
              HoldQuiz()
            end
          end
        end
      end
    end
  end
end
--------------------------------
OpConnected = NewUserConnected
OpDisconnected = UserDisconnected
ToArrival = ChatArrival
--------------------------------
function HoldQuiz()
  strWord = ""
  strQuestion = ""
  strSolved = ""
end

function StopQuiz(restart)
  lngWord = 0
  lngPassed = 0
  strWord = ""
  strQuestion = ""
  strSolved = ""
  StopTimer()
  if (restart) then
    StartQuiz()
  end
end

function StartQuiz()
  lngWord = math.random(1, lngGuessmax)
  QWarray = tokenize(guessArray[lngWord], strGSep)
  strQuestion = QWarray[1]
  strWord = QWarray[2]
  strSolved = ""
  for x=1, string.len(strWord) do
    if (string.sub(strWord, x, x) == " ") then
      strSolved = strSolved.." "
    else
      strSolved = strSolved..strCMask
    end
  end
  lngPassed = 0
  lngHinted = 0
  lngHintTimeCount = lngHintTime
  if string.len(strWord) < 4 then
	bcount = math.random(1, 2)
  elseif string.len(strWord) >= 4 and string.len(strWord) <= 9 then
	bcount = math.random(1, 3)
  elseif string.len(strWord) >= 9 and string.len(strWord) <= 20 then
	bcount = math.random(2, 4)
  else
	bcount = math.random(3, 5)
  end
  SetTimer(15000)
  StartTimer()
  SendToPlayers("Вопрос: "..strQuestion)
  SendToPlayers("Ответ: "..strSolved.." ("..string.len(strSolved)..")")
end
-----------------------------------------
function OnTimer()
  lngPassed = lngPassed + 1
  if (lngPassed == lngMaxTime) then
    scount = scount + 1
    if scount == countSaveTurns then
	   local handle = io.open(strTrivScoreFile, "w")
	    	for index, value in pairs(pointArray) do
   	   	handle:write(index..strGSep..value.."\r\n")
 	   end
   	   handle:close()
    scount = 0
    end
    if (boolRevealAnswer) then
      SendToPlayers("Ответ был '"..strWord.."' никто не отгадал!")
    else
      SendToPlayers("Никто не ответил!")
    end
    SendToPlayers("Ждите следующего вопроса!")
    HoldQuiz()
  elseif (lngPassed >= (lngRestTime + lngMaxTime)) then
    StopQuiz(1)
  elseif (lngPassed == lngHintTimeCount) then
    if (boolAutoHint) then
	for nn=1,bcount do
            local lngRepChar = math.random(1, string.len(strWord))
            while 1 do
              if (boolHintAlwaysHitHidden) then
                if (string.sub(strSolved, lngRepChar, lngRepChar) == strCMask) then
                  break
                end
              else
                break
              end
              lngRepChar = math.random(1, string.len(strWord))
            end
            local strTurn = ""
            for x=1, string.len(strWord) do
              if (x == lngRepChar) then
               strTurn = strTurn..string.sub(strWord, x, x)
              else
                strTurn = strTurn..string.sub(strSolved, x, x)
              end
	    end
            strSolved = strTurn
	end
            lngHinted = lngHinted + 1
	    lngHintTimeCount = lngHintTimeCount + lngHintTime
            SendToPlayers("Подсказка: "..strSolved)
	end  
  end
  collectgarbage(); io.flush()
end
---------------------------------------
function tokenize (inString,token)
  _WORDS = {}
  local matcher = "([^"..token.."]+)"
  string.gsub(inString, matcher, function (w) table.insert(_WORDS,w) end)
  return _WORDS
end
----------------------------------------
function ReloadQuestions()
  guessArray = {}
  lngGuessmax = 0
  local boolRestart = nil
  if (lngWord ~= 0) then
    SendToPlayers("Перезагрузка вопросов, игра прекращается!")
    StopQuiz()
    boolRestart = 1
  end
  handle = io.open(strTrivFile, "r")
  if (handle) then
    local line = handle:read()
    
    while line do
      if ((line ~= "") and (string.find(line, strGSep, 1, plain))) then
        table.insert(guessArray, line)
        lngGuessmax = lngGuessmax + 1
      end
      line = handle:read()
    end
  handle:close()
  end
  if (lngGuessmax < 1) then
  guessArray = {
    "The finest car there is?"..strGSep.."Honda CRX del Sol",}
  lngGuessmax = 2
  end
  if (boolRestart) then
    SendToPlayers("Перезагрузка вопросов, игра будет прекращена! Всего вопросов: "..lngGuessmax)
    StartQuiz()
  end
  strTrivFile = strDefTrivFile
end
----------------------------------------
function SaveScores(curUser)
  local handle = io.open(strTrivScoreFile, "w")
  for index, value in pairs(pointArray) do
    handle:write(index..strGSep..value.."\r\n")
  end
  curUser:SendData(BotName,"Очки успешно сохранены!")
  handle:close()
end
-----------------------------------------
function LoadScores(curUser)
	local handle = io.open(strTrivScoreFile, "r")
	if (handle) then
		local line = handle:read()
		while line do
			local arrTmp = tokenize(line, strGSep)
			if ((arrTmp[1] ~= nil) and (arrTmp[2] ~= nil)) then
				pointArray[arrTmp[1]] = tonumber(arrTmp[2])
			end
			line = handle:read()
		end
	curUser:SendData(BotName,"Очки загружены!")
	handle:close()
	end
end
---------------------------------------------------
function AddQuestion(curUser, sQuestion, sAnswer)
  local handle = io.open(strQFile, "a")
  handle:write("Submitted by <"..curUser.sName.."> "..sQuestion..strGSep..sAnswer.."\r\n")
  SendToPlayers(curUser.sName.." Has added the question "..sQuestion)
  curUser:SendPM(BotName,curUser.sName.." you gave the answer as "..sAnswer)
  handle:close()
end
--------------------------------------------
function SendToPlayers(msg)
  if ((lngMode > 2) or (lngMode < 0)) then
    lngMode = lngDefMode
  end
  
  if (lngMode == 0) then
    SendToAll(BotName, msg)
  elseif (lngMode == 1) then
    for index, value in pairs(playerArray) do
      SendToNick(index, "<"..BotName.."> "..msg)
    end
  elseif (lngMode == 2) then
    for index, value in pairs(playerArray) do
      SendPmToNick(index, BotName, msg)
    end
  end
end
---------------------------------------------
function SendToOthers(msg, curUser)
  if ((lngMode == 2) and (boolShowGuessesInPM)) then
    for index, value in pairs(playerArray) do
      if (index ~= curUser.sName) then
        SendPmToNick(index, BotName, "<"..curUser.sName.."> "..msg)
      end
    end
  end
end
-----------------------------------------------
function SendChatToOthers(chat, curUser)
  if (lngMode == 2) then
    for index, value in pairs(playerArray) do
      if (index ~= curUser.sName) then
	SendToNick(index, "$To: "..index.." From: "..BotName.." $<"..curUser.sName.."> "..chat)
      end
    end
  end
end
--------------------------------------------
function showHelp(curUser)
  curUser:SendData("<Help> ")
  curUser:SendData("<Help> "..BotVersion.." команды:")
  curUser:SendData("<Help> ")
  if (lngMode == 0) then
    curUser:SendData("<Help>    "..BotVersion.." Играть в анаграмы в главном чате")
  elseif (lngMode == 1) then
    curUser:SendData("<Help>    "..BotVersion.." играть в главном чате, но скрытом режиме")
  else
    curUser:SendData("<Help>    "..BotVersion.." играть в личке")
  end
  curUser:SendData("<Help>    "..HelpTrigg.." - Помощь")
  curUser:SendData("<Help>    "..JoinTrigg.." - Начать игру")
  curUser:SendData("<Help>    "..PartTrigg.." - Закончить игру")
  curUser:SendData("<Help>    "..QuizTrigg.." - Показать текущий вопрос")
  curUser:SendData("<Help>    "..PlayerTrigg.." - Список текущих игроков")
  curUser:SendData("<Help>    "..TopTrigg.." - Лучшая 10-ка")
  curUser:SendData("<Help>    "..Top20Trigg.." - Лучшая 20-ка")
  curUser:SendData("<Help>    "..Top100Trigg.." - Топ 100 участников")
  curUser:SendData("<Help>    "..PointTrigg.." - Показать сколько у вас очков")
  if (curUser.bOperator) then
    curUser:SendData("<Help> ")
    curUser:SendData("<Help>    "..BotVersion.." Команды операторов хаба:")
    curUser:SendData("<Help>    "..LoadTrigg.." - Загрузить очки из "..strTrivScoreFile)
    curUser:SendData("<Help>    "..StartTrigg.." - Включить Анаграмы и начать игру!")
    curUser:SendData("<Help>    "..SaveTrigg.." - Сохранить очки в  "..strTrivScoreFile)
    curUser:SendData("<Help>    "..StopTrigg.." - Остановить бота")
    curUser:SendData("<Help>    "..ModeTrigg.." - Поменять режим игры (0-2)!")
    curUser:SendData("<Help>    "..RestartTrigg.." - Перезагрузить бота и обнулить очки!")
    curUser:SendData("<Help>    "..QuestionsTrigg.." - Показывает топ5 вопросов в игре и их общее кол-во")
    curUser:SendData("<Help>    "..ReloadTrigg.." (<filename>) - Перезагрузить очки из файла "..strDefTrivFile)
    curUser:SendData("<Help>    "..AddTrigg.." - Добавить вопрос (ф-ция доступна и обычным игрокам)")
    curUser:SendData("<Help>    ПРИМЕР : tbaddquestion Как быстро летают птицы?#Не знаю")

    curUser:SendData("<Help> ")
    curUser:SendData("<Help>    "..BotVersion.." Режим игры:")
    curUser:SendData("<Help>    ".."0 = Играть в главном чате!")
    curUser:SendData("<Help>    ".."1 = Играть в главном чате, но вопросы будут видны только для игроков")
    curUser:SendData("<Help>    ".."2 = Играть в привате бота")
  end
end
----------------------------------------------
function TopTen(user)
	local index = {n=0}
	for nick, score in pairs(pointArray) do table.insert(index, nick) end
	local func = function(a, b) return pointArray[a] > pointArray[b] end
	table.sort(index, func)
	x = x or 10 if x > index.n then x = index.n end
	local result = "\r\nТоп "..x.." игры Анаграммы!..\r\n Место\t Очки\t\t Ник\t\r\n"
	for i = 1, x do result = result.."\r\n "..i..".\t"..pointArray[index[i]].."\t\t"..index[i] end
	msg = result
	SendToPlayers(msg)
end

function SendMenu(curUser)
curUser:SendData("$UserCommand 1 3 Анаграммы\\Старт!$<%[mynick]> +старт&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\Стоп!$<%[mynick]> +стоп&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\тек.слово$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +слово&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\Кто играет?$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +игроки&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\TOP's\\ Топ10$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +топ10&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\TOP's\\ Топ20$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +топ20&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\TOP's\\ Топ100$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +топ100&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\Мои очки$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +очки&#124;")
curUser:SendData("$UserCommand 1 3 Анаграммы\\помощь$$To: -.::Игры::.\\Анаграммы From: %[mynick] $<%[mynick]> +хелп&#124;")
end