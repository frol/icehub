---Artbot Version 2.0
---made by [NL]MrBuitenhuizen
---used code from ![AscIIArtBot]!™ v:1.0 made by [ES]Latinmusic
---added some functions
---added some art
---added cfg file
---thnx Troubadour for the support with the GUI

--Artbot 1.0 made by: [NL]MrBuitenhuizen
--Artbot has most of the scripting lines from > :
-->ShowInfo v1.0 by latinmusic == poweroperator 18/04/2003
-->Based on TrickerBot 2 by ¿Ptaczek? 
-->Based on a few lines of DirtyBot made by Dirty Finger)
--nov 2003 = start empty rule idea by Plop 
--thnx to the people who made the Art txt files

----===Don't change under this line if you don't know what you're doing
---====Settings are done in the ArtbotSettings cfg file inside Artbot-data 

assert(dofile("Artbot-data/ArtbotSettings.cfg"),"settings file error")

DirArray = {"Artbot-data"}
file = "Artbot-data/ArtList.txt"
filelist = file
ErrorMsg = "You do not have enough privileges to execute this command."
scriptInfo = "Artbot V:2.0 by [NL]MrBuitenhuizen"


function Main()
	execute("dir Artbot-art > Artbot-data/ArtList.txt /B")
	MakeArray(curUser)
	local version = scriptInfo.." "
	SendToAll(botName, "Script restarted.\r\n  "..version..date(" launched at day: %d/%m/%Y. Local Hub Time: %X."))
	SendToAll(botName, "The 'Art files list' has been generated.")
end

function DataArrival(curUser, data)
	if strsub(data, 1, 1) ~= "<" then return end
	local s, e, cmd, args = strfind(data, "^%b<> %!(%a+)%s*(.*)%|$")
	if not s then return end
	cmd = strlower(cmd)
	if cmd == "showart" then
		if CommandStatus == 1 then
			variable = DirArray[random(1,getn(DirArray))] 
			local result = Show(TheFile)
			curUser:SendData(botName,result)
		else
			curUser:SendData(botName,"The command '!showart' is temporarily deactivated.")
		end

		return 1
	elseif cmd == "reloadart" then
		if (curUser.iProfile ~= 0) then curUser:SendData(botName,ErrorMsg) return 1 end
		execute("dir Artbot-art > Artbot-data/ArtList.txt /B")
		MakeArray(curUser)
		SendToAll(botName,"The 'Art files list' has been updated.\r\n")
		return 1
	elseif cmd == "showhelp" then
		curUser:SendData
		(botName,"List of the commands available for "..botName.."\r\n\r\n-=======<>Artbot Commands<>=======-\r\n !reloadart		-	Reload the Art files\r\n !startimer <min>	-	Start the timer with time set in minutes\r\n !stoptimer	-	Stop the timer\r\n !showart		- 	Display Art files ramdomly on user request\r\n !showhelp	-	Display this help\r\n !showartlist	-	show list of art avaible\r\n")
	elseif cmd == "starttimer" then
		if not curUser.bOperator then curUser:SendData(botName,ErrorMsg) return 1 end
		if TimerStatus == 0 then
			local s,e,_,minutes = strfind( data, "%b<>%s+(%S+)%s+(%S+)%|$")
			if not s then curUser:SendData(botName,"Syntax: !starttimer <TimeInMinutes>") return 1 end
			TimerStatus = 1
			CommandStatus = 0
			SetTimer(minutes*60000)
			StartTimer()
			curUser:SendData(botName,"The 'Timer' function have been activated. First 'Art File' will be displayed in "..minutes.." minute(s) from now.")
			SendToAll(botName,"The command '!showart' have been temporarily deactivated.")
		else
			curUser:SendData(botName,"The 'Timer' function is already active.")
		end
		return 1
	elseif cmd == "stoptimer" then
		if not curUser.bOperator then curUser:SendData(botName,ErrorMsg) return 1 end
		if TimerStatus == 1 then
			TimerStatus = 0
			CommandStatus = 1
			StopTimer()
			curUser:SendData(botName,"The 'Timer' function have been deactivated.")
			SendToAll(botName,"The command '!showart' have been activated.")
		else
			curUser:SendData(botName,"The 'Timer' function is already deactivated.")
		end
		elseif cmd == "showartlist" then 
		OpenFile(curUser, file, botName) 
return 1 
		
end
end


function MakeArray(curUser)
	readfrom(file,"r")
	while 1 do
		local line = read()
		if line == nil or line == "" then break
		else
			tinsert(DirArray, line)
		end
	end
	readfrom()
	return DirArray
end
function Show(TheFile)
	readfrom("Artbot-art/"..variable,"r")
	local art = ""
	while 1 do
		local line = read()
		if line == nil then break
		else
			art = art..line.."\r\n"
		end
	end
	readfrom()
	return art
end
function OnTimer()
	variable = DirArray[random(1,getn(DirArray))]
	local result = Show(TheFile)
	SendToAll(botName,result)
end

function OpenFile(curUser, file, bot) 
local msgfromtxt ="\r\n" 
readfrom(file) 
while 1 do 
local line = read() 
if (line == nil) then 
break 
else 
msgfromtxt = msgfromtxt.." "..line.."\r\n" 
end 
end 
curUser:SendData(bot,"\r\n\--<> List of all the art files that are avaible <> type the name of the file to display <>--")
curUser:SendData(msgfromtxt) readfrom() 
end 


