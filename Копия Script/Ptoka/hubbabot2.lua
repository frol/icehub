-----------------------------------------------
-- HUBBABOT Hub's Big Ass Bot. Bot for DC hub PtokaX 
-- Copyright  ©  2004-2005  NoNick ( nwod@mail.ru )
-- Second Edition  
-----------------------------------------------
--This program is free software; you can redistribute it and/or
--modify it under the terms of the GNU General Public License
--as published by the Free Software Foundation; either version 2
--of the License, or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.

--You should have received a copy of the GNU General Public License
--along with this program; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-----------------------------------------------
-- This Bot was initially made as modification of bot THoR 2.0, written by NightLitch 22 May 2004.
-- Current version is expected to not contain any original code written by NightLitch. 
-- Nevertheless NoNick wants to thank NightLitch for lots of expirience got while learning his script.

-- Этот бот был изначально создан как переделка бота THoR 2.0, выпущенного  NightLitch 22 мая 2004.
-- Текущая версия не содержит оригинального кода, написанного NightLitch. 
-- Тем не менее, автор благодарит NightLitch за опыт, полученный при препарировании его скрипта.
-----------------------------------------------

-----------------------------------------------
VERSION = "2.27 RC4"
-----------------------------------------------
-- КОНСТАНТЫ
HOMEPATH = 		"HUBBABOT/"
HUBDATAPATH = 	HOMEPATH.."DATA/"
LOGSPATH = 		HOMEPATH.."LOGS/"
TEXTSPATH =  	HOMEPATH.."TEXTS/"
CFGPATH =  		HOMEPATH.."CFG/"
LANGPATH =  	HOMEPATH.."LANG/"
CLIENTSPATH = 	HOMEPATH.."CLIENTS/"
UCOtherPATH = 	HOMEPATH.."UC/"

HubBotInfo = ">>> Этот хаб работает под управлением HUB's Big Ass Bot v"..VERSION.." by NoNick 2004-2005"
--HubBotInfo = "<Hub-Security> This hub is powered by HUB's Big Ass Bot v"..VERSION.." by NoNick 2004-2005"
-- (^[^!])
--Настройки 
F_BOT 		= 			CFGPATH .. "bot.dat"
F_BAD_CHAT = 			CFGPATH .. "bad_chat.dat"
F_BAD_PARANOID_CHAT = 	CFGPATH .. "bad_paranoid_chat.dat"
F_BAD_NICK = 			CFGPATH .. "bad_nick.dat"
F_BAD_PARANOID_NICK = 	CFGPATH .. "bad_paranoid_nick.dat"
F_CMDCHECK = 			CFGPATH .. "CmdCheck.dat"
F_VERSIONS	= 			CFGPATH .. "versions.dat"
F_OWNER		= 			CFGPATH .. "owner.dat"
F_UC		= 			CFGPATH .. "UserCommands.dat"
F_ANTIADV = 			CFGPATH .. "anti_adv.dat"
F_PASSCOMMANDS = 		CFGPATH .. "pass_commands.dat"

F_NO_P_IP = 			CFGPATH .. "no_p_ip.dat"
F_NO_V_IP = 			CFGPATH .. "no_v_ip.dat"
F_ALLOW_ENTER_IP = 		CFGPATH .. "allow_enter_ip.dat"
F_NO_CHAT_IP = 			CFGPATH .. "no_chat_ip.dat"
F_CHAT_ONLY_IP = 		CFGPATH .. "chat_only_ip.dat"
F_MULTI_NICK_IP =		CFGPATH .. "multi_nick_ip.dat"

F_TCFG	= 				CFGPATH .. "tcfg.dat"

F_STATUS = 				LANGPATH .. "status.dat"
F_ROLESTATUS = 			LANGPATH .. "rolestatus.dat"
F_CMDLANG	= 			LANGPATH .. "CmdLang.dat"
F_MESSAGES = 			LANGPATH .. "messages.dat"
F_UCLang= 				LANGPATH .. "UCLang.dat"


F_USERS = 				HUBDATAPATH .. "users.dat"
F_STATS = 				HUBDATAPATH .. "stats.dat"
F_NEWSTEXT = 			HUBDATAPATH .. "news.dat"
F_CFG	= 				HUBDATAPATH .. "cfg.dat"
F_MAIL = 				HUBDATAPATH .. "mail.dat"
F_CHATROOMS = 			HUBDATAPATH .. "chatrooms.dat"
F_SHARES 	= 			HUBDATAPATH .. "shares.dat"
--TEXTS
F_SMALLSHARETEXT =		TEXTSPATH .."smallshare.txt"
F_FAQTEXT = 			TEXTSPATH .."FAQ.txt"
F_SHARETEXT = 			TEXTSPATH .."share.txt"
F_HALLOTEXT = 			TEXTSPATH .."hallo.txt"
F_PASSIVETEXT = 		TEXTSPATH .."passive.txt"
F_SHORTRULESTEXT=		TEXTSPATH .."rulesshort.txt"
F_NOLEECHTEXT = 		TEXTSPATH .."noleech.txt"
F_SINGLEIPTEXT = 		TEXTSPATH .."singleip.txt"
F_CHATQTEXT =	 		TEXTSPATH .."ChatQ.txt"
F_NO_ENTER_TEXT = 		TEXTSPATH .."no_enter.txt"
F_NO_CHAT_TEXT = 		TEXTSPATH .."no_chat.txt"
F_CHAT_ONLY_TEXT = 		TEXTSPATH .."chat_only.txt"

F_MainLogPath = 		LOGSPATH
F_SysLogPath = 			LOGSPATH
F_ParanoidLogPath = 	LOGSPATH

Sec  = 1
Min  = 60*Sec
Hour = 60*Min
Day  = 24*Hour
byte=1
Kbyte=1024
Mbyte=Kbyte*Kbyte
Gbyte=Kbyte*Kbyte*Kbyte
Tbyte=Kbyte*Kbyte*Kbyte*Kbyte

-----------------------------------------------
-- ПЕРЕМЕННЫЕ
RusLetters={["А"]="а",["Б"]="б",["В"]="в",["Г"]="г",["Д"]="д",["Е"]="е",["Ё"]="ё",["Ж"]="ж",["З"]="з",["И"]="и",["Й"]="й",["К"]="к",["Л"]="л",["М"]="м",["Н"]="н",["О"]="о",["П"]="п",["Р"]="р",["С"]="с",["Т"]="т",["У"]="у",["Ф"]="ф",["Х"]="х",["Ц"]="ц",["Ч"]="ч",["Ш"]="ш",["Щ"]="щ",["Ъ"]="ъ",["Ы"]="ы",["Ь"]="ь",["Э"]="э",["Ю"]="ю",["Я"]="я"}
tCheck={}
STATS  = {}
STATS_U_LSVal=0;
STATS_U_LSTime=0;
STATS_S_LSVal=0;
STATS_S_LSTime=0;
TimersTable = {}
CMD = {}
txtStatus= {}
ROLESTATUS= {}
messages = {}
BOT={}
PASSCOMMANDS={}
NLT={}

FAQTEXT= 		""
SHARETEXT = 	""
HALLOTEXT = 	""
NEWSTEXT =	 	""
PASSIVETEXT = 	""
SHORTRULESTEXT= ""
NOLEECHTEXT = 	""
SMALLSHARETEXT =""
SINGLEIPTEXT =  ""
CHATQTEXT	=	""
NO_ENTER_TEXT = ""
CHAT_ONLY_TEXT =""
NO_CHAT_TEXT= 	""
mainChatLog = 	""
syslog =		""
paranoidLog = 	""
RulesShortText = ""

AVERUSERS={}

BAD_CHAT ={}
BAD_PARANOID_CHAT ={}
BAD_NICK ={}
BAD_PARANOID_NICK ={}
CFG = {
	__index = function (table, key)
		CFG[key]=0;
		return 0;
	end    
}
setmetatable(CFG,CFG)
TCFG = {
	__index = function (table, key)
		TCFG[key]=0;
		return 0;
	end    
}
setmetatable(TCFG,TCFG)

PARANOID = {
	__index = function (table, key)
		PARANOID[key]={}
		PARANOID[key].curindex=0	
		PARANOID[key].times={}
		PARANOID[key].posts={}	
		PARANOID[key].fullposts={}
		return PARANOID[key];
	end    
}
setmetatable(PARANOID,PARANOID)

NOYELL={
	__index = function (table, key)
			NOYELL[key]={} 
			NOYELL[key].curindex=0
			NOYELL[key].times={}
		return NOYELL[key];
	end    
}
setmetatable(NOYELL,NOYELL)

NOADV={
	__index = function (table, key)
			NOADV[key]={} 
			NOADV[key].curindex=0
			NOADV[key].times={}
		return NOADV[key];
	end    
}
setmetatable(NOADV,NOADV)

NOFLOOD = {
	__index = function (table, key)
			NOFLOOD[key]={} 
			NOFLOOD[key].curindex=0
			NOFLOOD[key].times={}
		return NOFLOOD[key];
	end    
}
setmetatable(NOFLOOD,NOFLOOD)


VERSIONS = {}
OWNER={}
CMDLANG={}
UCLang={}
UC = {}
UserCommands = {}
UCOther={}
NLCHECK={}
IPCHECKS={}

-----------------------------------------------
-- Include files
-----------------------------------------------
	require (HOMEPATH.."io.lu")
	-----------------------------------------------
	--Data files
	-----------------------------------------------
	US	=	{}

	MAIL={}	
	MAIL.NICK={}
	MAIL.IP={}
	SHARES ={}

	require (HOMEPATH.."Serialize.lu")
	require (HOMEPATH.."timer.lu")
	require (HOMEPATH.."interface.lu")
	require (HOMEPATH.."dialog.lu")
	require (HOMEPATH.."mail.lu")
	require (HOMEPATH.."functions.lu")
	require (HOMEPATH.."advisory.lu")
	require (HOMEPATH.."us.lu")
-----------------------------------------------
function Main()

	USMTV = {
		__index = 	function (tbl, key)
			if key=="bancount" then 
				tbl[key]=0
			elseif key=="nick" then 
				tbl[key]="";
			elseif key=="status" then 
				tbl[key]=0;
			elseif key=="forwhat" then 
				tbl[key]=0;
			elseif key=="whenexpires" then 
				tbl[key]="";
			elseif key=="when" then 
				tbl[key]="";
			elseif key=="by" then 
				tbl[key]="";
			elseif key=="context" then 
				tbl[key]="";
			elseif key=="lastonline" then 
				tbl[key]="";
			elseif key=="noleech" then 
				tbl[key]=0;
			elseif key=="maxnoleech" then 
				tbl[key]=0;
			elseif key=="noleech" then 
				tbl[key]=0;
			elseif key=="locknick" then 
				tbl[key]="";
			elseif key=="sharesize" then 
				tbl[key]=0;
			elseif key=="ip" then 
				tbl[key]=key;
			elseif key=="fl" then 
				tbl[key]=os.time();
			end
			return tbl[key] 
		end	
	}

	local res=loadfile (F_USERS)
	
	if res~=nil then 
		res() 
		for i,v in US do
			setmetatable(US[i],USMTV)
		end	
	end
	
	USMT={
		__index = 	function (tbl, key)
			US[key]={}
			setmetatable(US[key],USMTV)
			US[key].ip=key;
			return US[key]
		end    
	}
	setmetatable(US,USMT)

	local res=loadfile (F_MAIL)
	if res~=nil then res() end
	local res=loadfile (F_SHARES)
	if res~=nil then res() end

	BOT = readArray (F_BOT)
	sHubName = frmHub:GetHubName()
	if BOT.BOTNAME== nil then
		return
	end
	BOTNAME=BOT.BOTNAME
	
	frmHub:RegBot(BOTNAME)
	BOTNAME = BOT.BOTNAME
	Tag   = "<HUBBABOT V:"..VERSION..",M:S,H:0,S:0 >"
	BIToSend = "$MyINFO $ALL "..BOTNAME.." HUB's Big Ass Bot by NoNick 2004-2005"..Tag.."$ $BOT"..string.char( 1 ).."$$0$"
	
	
	CFG = 				readArray (F_CFG,CFG)
	OWNER = 			readArray (F_OWNER)
	BAD_CHAT = 			readWords (F_BAD_CHAT)
	BAD_PARANOID_CHAT =	readWords (F_BAD_PARANOID_CHAT)
	BAD_NICK = 			readWords (F_BAD_NICK)
	BAD_PARANOID_NICK =	readWords (F_BAD_PARANOID_NICK)
	ANTIADV	=			readWords (F_ANTIADV)
	PASSCOMMANDS = 		loadchecklist (F_PASSCOMMANDS)
	
	IPCHECKS.NO_P=			readIPs(F_NO_P_IP)
	IPCHECKS.NO_V=			readIPs(F_NO_V_IP)
	IPCHECKS.ALLOW_ENTER =	readIPs(F_ALLOW_ENTER_IP)
	IPCHECKS.NO_CHAT =		readIPs(F_NO_CHAT_IP)
	IPCHECKS.CHAT_ONLY=		readIPs(F_CHAT_ONLY_IP)
	IPCHECKS.MULTI_NICK = 	readIPs(F_MULTI_NICK_IP)
	
	CMDLANG  = 			readArray (F_CMDLANG)
	UC		=			readArray (F_UC)
	STATS =				readArray (F_STATS)
	
	if STATS.MaxUsers==nil then STATS.MaxUsers=0 end
	if STATS.MaxShare==nil then STATS.MaxShare=0 end
	if STATS.MaxUsersDate==nil then STATS.MaxUsersDate="" end
	if STATS.MaxShareDate==nil then STATS.MaxShareDate="" end
	
	VERSIONS	=  	readVersions(F_VERSIONS)
	FAQTEXT= 		loadtext(F_FAQTEXT)
	SHARETEXT = 	loadtext(F_SHARETEXT)
	HALLOTEXT = 	loadtext(F_HALLOTEXT)
	NEWSTEXT =	 	loadtext(F_NEWSTEXT)
	PASSIVETEXT = 	loadtext(F_PASSIVETEXT)
	SHORTRULESTEXT= loadtext(F_SHORTRULESTEXT)
	NOLEECHTEXT = 	loadtext(F_NOLEECHTEXT)
	SMALLSHARETEXT =loadtext(F_SMALLSHARETEXT)
	SINGLEIPTEXT =	loadtext(F_SINGLEIPTEXT)
	CHATQTEXT	=	loadtext(F_CHATQTEXT)
	NO_ENTER_TEXT = loadtext(F_NO_ENTER_TEXT)
	CHAT_ONLY_TEXT =loadtext(F_CHAT_ONLY_TEXT)
	NO_CHAT_TEXT=	loadtext(F_NO_CHAT_TEXT)
	LoadCommands(F_CMDCHECK)
	assert(require (HOMEPATH.."CmdLine.lu"), "CmdLine.lu not found")
	assert(require (HOMEPATH.."Commands.lu"), "Commands.lu not found")
	assert(require (HOMEPATH.."HBUC.lu"), "HBUC.lu not found")

	for i=1,5,1 do
		UCOther[i]=loadlist(UCOtherPATH..i..".dat")
	end
		
	messages = readArray(F_MESSAGES)
	txtStatus = readArray(F_STATUS)

	UCLang = readArray(F_UCLang)
	prepareUserCommands()


	ROLESTATUS = readArray(F_ROLESTATUS);
	tCheck[0]=	{5,ROLESTATUS[5]}
	tCheck[1]=	{4,ROLESTATUS[4]}
	tCheck[2]=	{3,ROLESTATUS[3]}
	tCheck[3]=	{2,ROLESTATUS[2]}
	tCheck[-1]=	{1,ROLESTATUS[1]}
	
	SetTimer(1000)
	StartTimer()

	local res=loadfile (F_TCFG)
	if res~=nil then res() end

	FREEMEMTIME=FREEMEMTIME or 0
	MOTTIME=MOTTIME or 0
	SHARETIME=SHARETIME or 0
	LOGTIME=LOGTIME or 0
	SAVEUSTIME=SAVEUSTIME or 0
	ARCHUSTIME=ARCHUSTIME or 0
	NEWSTIME=NEWSTIME or 0

	TimerReg(Timer_ClearMem, FREEMEMTIME)
	TimerReg(Timer_MomentOfTruth, MOTTIME)
	TimerReg(Timer_Share, SHARETIME)
	TimerReg(Timer_Logs, LOGTIME)
	TimerReg(timer_save_US, SAVEUSTIME)
	TimerReg(timer_arch_US, ARCHUSTIME)
	TimerReg(Timer_ShowNews,NEWSTIME)
	
	--[[
	TimerReg(timer_adv_rating, 10)
	AVERUSERS.numUsers=0
	AVERUSERS.count=0
	]]--
	--[[
	for indx in US do
		US[indx].paranoid=nil 
		US[indx].password=nil 
	end
	]]--
	saveUSExpress()
	AddSysLog(messages[83])
end
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
function NewUserConnected(sUser)
	
	sUser:SendData(BIToSend) 
	sUser:SendData(HubBotInfo)

	if not inDiap(sUser.sIP,IPCHECKS.ALLOW_ENTER) then 
		local tRulesText= NO_ENTER_TEXT;
		tRulesText = string.gsub(tRulesText, "%[IP%]", sUser.sIP)
		tRulesText = string.gsub(tRulesText, "%[HUBOWNER%]", OWNER.Nick)
		tRulesText = string.gsub(tRulesText, "%[OWNERCONTACT%]", OWNER.Contact)
		BotSayToUser(sUser, tRulesText)
		sUser:Disconnect();
		return 1
	end
	
	if CFG.LRLevel>0 then -- редирект хаба.
		if tCheck[sUser.iProfile][1] <= CFG.LRLevel then
			if CFG.LRAddress==0 or CFG.LRAddress=="" then
				BotSayToUser(sUser, CFG.LRReason)
				sUser:Disconnect();
				return 1
			else
				local msg=messages[157];
				msg=string.gsub(msg,"%[WHO%]",sUser.sName.." ["..sUser.sIP.."] (".. tCheck[sUser.iProfile][2]..")");
				msg=string.gsub(msg,"%[WHERE%]",CFG.LRAddress);
				msg=string.gsub(msg,"%[REASON%]",CFG.LRReason);
				AddSysLog("<"..BOTNAME.. "> "..msg);		
				sUser:Redirect(CFG.LRAddress, CFG.LRReason)
				return 1
			end
		end
	end

	-----------------------------------------------------------
	-- глобальное ограничение на вход на хаб
	if checkMinimumShare(sUser, sData) then 
		return 1 
	end
	
	-----------------------------------------------------------
	-- запрет входа нескольким юзерам с одного ip
	if CFG.SingleIp==1 then 
		if not inDiap(sUser.sIP,IPCHECKS.MULTI_NICK) then 
			if checkSingleIp(sUser)==1 then 
				return 1 
			end
		end	
	end

	-----------------------------------------------------------
	--проверка банов
	if (checkBan(sUser)==1) then 
		sUser:Disconnect();
		return 1 
	end
	US[sUser.sIP].nick=sUser.sName;

	-----------------------------------------------------------
	-- Защита от псевдоботов
	if (chekBotName(sUser)==1) then return 1 end

	-----------------------------------------------------------
	--проверка ника и описания ресурсов на матершину.	
	if (checkNickDescr(sUser) ==1) then return 1 end
	
--[[	
	if CFG.NoAdvCheck==1 then
		local isbadword = 0
		local badword, pos, context;
		isbadword, badword, pos, context = isbad2(sUser.sName,ANTIADV)
		if (isbadword==1)
		end
	end	
	--]]
	-----------------------------------------------------------
	--Юзер может зайти, показываем прветственное сообщение
	showHalloMessage(sUser)

	-----------------------------------------------------------
	--проверки на пассивный режим, версию клиента, запись служ. инфы
	checkTags(sUser)

	-----------------------------------------------------------
	--Посылаем UserCommands
	sendUserCommands(sUser)
	
	US[sUser.sIP].lastonline = os.date("%Y/%m/%d %H:%M:%S");
	US[sUser.sIP].nick=sUser.sName;
	LogStats();
	
	--[[
	AVERUSERS.numUsers=AVERUSERS.numUsers+frmHub:GetUsersCount();
	AVERUSERS.count=AVERUSERS.count+1;
	--]]
end
--------------------------------------------------------------------------------------------------------------------------------------------
function OpConnected(sUser)
	NewUserConnected(sUser)	
end
--------------------------------------------------------------------------------------------------------------------------------------------
function UserDisconnected(sUser)
	if sUser.bConnected==1 then -- уходит пользователь, который был залогинен.
		--[[
		AVERUSERS.numUsers=AVERUSERS.numUsers+frmHub:GetUsersCount();
		AVERUSERS.count=AVERUSERS.count+1;
		]]--
		AddSysLog(messages[121]..sUser.sName);		
		PARANOID[sUser.sIP]=nil
		NLCHECK[sUser.sIP]=nil;
		NLT[sUser.sName]=nil;
		US[sUser.sIP].lastonline = os.date("%Y/%m/%d %H:%M:%S");
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function OpDisconnected(sUser)
	UserDisconnected(sUser)
end
--------------------------------------------------------------------------------------------------------------------------------------------
function MyINFOArrival(sUser, sData)
	if sUser.bConnected then 
		if (checkNickDescr(sUser) ==1) then return 1 end
	end	
	LogStats();
	if sUser.bConnected then 
		if checkMinimumShare(sUser, sData) then 
			return 1 
		end
	end
	US[sUser.sIP].sharesize=sUser.iShareSize

	if CFG.ShareTopOn==1 then
		storeSharetop(sUser)
	end
	
	if CFG.NoLeechOn==1 then
		if sUser.bConnected then 
			checkShare(sUser,sData)
		end	
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ToArrival(sUser, sData)
	local s,e,whoTo,from,arg = string.find(sData,"%$To:%s+(%S+)%s+From:%s+(%S+)%s+%$(.*)")
	if whoTo==BOTNAME then
		if ParseCommand(sUser,sData,sData)==1 then return 1 end
	end

	local vUser = GetItemByName(whoTo)
	if vUser~= nil then
		if US[sUser.sIP].status==1 or US[sUser.sIP].status==2 then --отправителю запрещено юзать PM
			if vUser~= nil then 
				if tCheck[vUser.iProfile][1] < 4 then 
					BotSayToUser(sUser, getBanInfo(sUser.sIP))
					return 1
				end
			else
				BotSayToUser(sUser, getBanInfo(sUser.sIP))
				return 1
			end
		else
			local st=US[vUser.sIP].status
			if st==1 or st==2 then --получателю запрещено юзать PM
				if tCheck[sUser.iProfile][1] < 4 then 
					SendToNick(sUser.sName, "$To: "..sUser.sName.." From: "..whoTo.." $<"..BOTNAME.."> "..whoTo.."["..vUser.sIP.."] ".. txtStatus[st])
					return 1
				end
			end
		end
	end	
end
--------------------------------------------------------------------------------------------------------------------------------------------
OnExit = function()
	saveUSExpress()
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ChatArrival(sUser, sData)
	
	local retValue=0
	local retparce=ParseCommand(sUser,sData,sData)
	if retparce==1 then 
		return 1 
	elseif retparce ==2 then
		AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
		return 0 
	end
	
	local sData = string.sub(sData,(string.len(sUser.sName)+4),string.len(sData)-1)

        sData = ""
	
	if tCheck[sUser.iProfile][1] ~= 5 then 
	-----------------------------------------------------------
		--проверка: основной чат выключен
		if (CFG.MainChatOff==1) then
			BotSayToUser(sUser,messages[112])
			return 1
		end	
	-----------------------------------------------------------
		--проверка: диапазон ip адресов с отключенным чатом
		if inDiap(sUser.sIP,IPCHECKS.NO_CHAT) then 
			local tRulesText= NO_CHAT_TEXT;
			tRulesText = string.gsub(tRulesText, "%[IP%]", sUser.sIP)
			tRulesText = string.gsub(tRulesText, "%[HUBOWNER%]", OWNER.Nick)
			tRulesText = string.gsub(tRulesText, "%[OWNERCONTACT%]", OWNER.Contact)
			BotSayToUser(sUser, tRulesText)
			return 1
		end
		-----------------------------------------------------------
		--проверка: лоченый ник
		if (US[sUser.sIP].locknick~="") then
			if 	(US[sUser.sIP].locknick~=sUser.sName) then
				BotSayToUser(sUser,messages[108])
				return 1
			end	
		end

	-----------------------------------------------------------
		--проверка: бан
		st=US[sUser.sIP].status
		if st==4 or st==6 or st==1 or st== 2 then
			BotSayToUser(sUser,getBanInfo (sUser.sIP))
			return 1
		end

	-----------------------------------------------------------
		--проверка пустых строк, защита от бага oDC
		if CFG.FixOdcBug==1 then
			local emptystr=0;
			for i = 1, string.len (sData) do
				if (string.byte(sData,i) ~= 32)  then
					emptystr = 0;
					break
				end
			end
			if emptystr==1 then return 1 end
		end	
		
	-----------------------------------------------------------
		--проверка ценза по шаре
		if CFG.ChatQMode==1 and sUser.iShareSize < CFG.ChatQValue then
			if os.time()-US[sUser.sIP].fl > CFG.ChatQTime then
					local ttext=string.gsub(CHATQTEXT,"%[MINSHARE%]",getNormalShare(avShare));
					ttext=string.gsub(ttext,"%[CURSHARE%]",getNormalShare(sUser.iShareSize));
					BotSayToUser(sUser, ttext)
				return 1
			end
		elseif CFG.ChatQMode==2 then 
			local avShare=frmHub:GetCurrentShareAmount()/(frmHub:GetUsersCount()*CFG.ChatQRatio);
			if sUser.iShareSize < avShare then
				if os.time()-US[sUser.sIP].fl > CFG.ChatQTime then
					local ttext=string.gsub(CHATQTEXT,"%[MINSHARE%]",getNormalShare(avShare));
					ttext=string.gsub(ttext,"%[CURSHARE%]",getNormalShare(sUser.iShareSize));
					BotSayToUser(sUser, ttext)
					return 1
				end
			end
		end
	-----------------------------------------------------------
		--проверка чата на ругань
		if CFG.ChatCheck==1 then
			local isbadword = 0
			local badword, pos, context;
			isbadword, badword, pos, context = isbad2(sData,BAD_CHAT)
			if isbadword == 1 then
				checkName(sUser)
				ChangeStatus(sUser.sIP,4,1,BOTNAME,context)
				BotSayToAll(genBanMessage(sUser.sIP).." ."..messages[170])
				alertByIP(sUser.sIP,getBanInfo(sUser.sIP),false)
				local msg=messages[97];
				msg=string.gsub(msg,"%[PATTERN%]",badword);
				msg=string.gsub(msg,"%[WORDS%]",sData);

				AddSysLog("<"..BOTNAME.. "> ".. getSysLogBanMsg(sUser,nil).." ".. msg);		
				return 1
			end
		end	

	-----------------------------------------------------------
		--параноидальная провека чата
		if CFG.ParanoidChatCheck==1 then
			paranoidCheck(sUser,sData)
			--SaveFile(PARANOID,"PARANOID","PARANOID");
		end

	-----------------------------------------------------------
		--проверка анти-рекламы
		if CFG.NoAdvCheck==1 then
			local res=NOADVCheck(sUser,sData);
			if res==1 then
				checkName(sUser)
				if retValue==0 then
					SendToAll("<"..sUser.sName.. "> " .. sData );
					AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
				end	
				sUser:SendData("<"..BOTNAME.. "> " .. string.gsub(messages[176],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"))
				AddSysLog("<"..BOTNAME.. "> ".. string.gsub(messages[177],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"));	
				retValue=1
			elseif res==2 then
				checkName(sUser)
				if retValue==0 then
					SendToAll("<"..sUser.sName.. "> " .. sData );
					AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
				end	
				ChangeStatus(sUser.sIP,4,5,BOTNAME,messages[175])
				alertByIP(sUser.sIP,getBanInfo(sUser.sIP),false)
				BotSayToAll(genBanMessage(sUser.sIP))
				AddSysLog("<"..BOTNAME.. "> ".. getSysLogBanMsg(sUser,nil));		
				retValue=1
			end
		end

	-----------------------------------------------------------
		--проверка ора
		if CFG.NoYellMode==1 then 
			local res=YELLCheck(sUser,sData);
			if res==2 then 
				checkName(sUser)
				if retValue==0 then
					AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
					SendToAll("<"..sUser.sName.. "> " .. sData );
				end	
				ChangeStatus(sUser.sIP,4,2,BOTNAME,messages[171])
				alertByIP(sUser.sIP,getBanInfo(sUser.sIP),false)
				BotSayToAll(genBanMessage(sUser.sIP))
				AddSysLog("<"..BOTNAME.. "> ".. getSysLogBanMsg(sUser,nil));		
				retValue=1
			elseif res==1 then 
				if retValue==0 then
					SendToAll("<"..sUser.sName.. "> " .. sData );
				end	
				sUser:SendData("<"..BOTNAME.. "> " .. string.gsub(messages[172],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"))
				AddSysLog("<"..BOTNAME.. "> ".. string.gsub(messages[173],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"));	
				retValue=1
			end
		elseif CFG.NoYellMode==2 then 
			if isYELL(sData) then
				checkName(sUser)
				if retValue==0 then
					AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)

					sData =ToLowerCase(sData);
					SendToAll("<"..sUser.sName.. "> " .. sData );
				end	
				sUser:SendData("<"..BOTNAME.. "> " .. string.gsub(messages[172],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"))
				AddSysLog("<"..BOTNAME.. "> ".. string.gsub(messages[173],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"));	
				retValue=1
			end
		end
		
	-----------------------------------------------------------
		--проверка флуда
		if CFG.FloodCheck==1 then
			local res=NOFLOODCheck(sUser,sData);
			if res==1 then
				checkName(sUser)
				if retValue==0 then
					SendToAll("<"..sUser.sName.. "> " .. sData );
					AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
				end	
				sUser:SendData("<"..BOTNAME.. "> " .. string.gsub(messages[23],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"))
				AddSysLog("<"..BOTNAME.. "> ".. string.gsub(messages[42],"%[WHO%]",sUser.sName.." ("..sUser.sIP ..")"));	
				retValue=1
			elseif res==2 then
				checkName(sUser)
				if retValue==0 then
					SendToAll("<"..sUser.sName.. "> " .. sData );
					AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
				end	
				ChangeStatus(sUser.sIP,4,2,BOTNAME,messages[73])
				alertByIP(sUser.sIP,getBanInfo(sUser.sIP),false)
				BotSayToAll(genBanMessage(sUser.sIP))
				AddSysLog("<"..BOTNAME.. "> ".. getSysLogBanMsg(sUser,nil));		
				retValue=1
			end
		end
	-----------------------------------------------------------
		if retValue==1 then
			return 1
		end	
	-----------------------------------------------------------
		--антипорно фильтр
		if CFG.AntiPornoFilter==1 then
			local s1 = string.find(sData, "[npPпПрР][оОoO0][рРpPrR][nNhHнН]")
			local s2 = string.find(sData, "[npPпПрР][оОoO0][рРpPrR][EeеЕ][вВB]")
			if s1 == nil and s2 == nil then
			else
				sData = string.gsub(sData , "[npPпПрР][оОoO0][рРpPrR][nNhHнН]", "UObH")
				sData = string.gsub(sData , "[npPпПрР][оОoO0][рРpPrR][EeеЕ][вВB]", "UObEB")
				SendToAll("<"..sUser.sName.. "> " .. sData );
				AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData )
				return 1
			end
		end	
	-----------------------------------------------------------
	end	
	AddMainChatLog("<"..sUser.sName..">("..sUser.sIP ..") "..sData)
	return 0
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ConnectToMeArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then 
		local tRulesText= CHAT_ONLY_TEXT;
		tRulesText = string.gsub(tRulesText, "%[IP%]", sUser.sIP)
		tRulesText = string.gsub(tRulesText, "%[HUBOWNER%]", OWNER.Nick)
		tRulesText = string.gsub(tRulesText, "%[OWNERCONTACT%]", OWNER.Contact)
		BotSayToUser(sUser, tRulesText)
		return 1 
	end
	
	local _,_,towho = string.find(sData, "$ConnectToMe%s+(%S+)%s+.*|")
	return checkDL(sUser,towho);
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RevConnectToMeArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then 
		local tRulesText= CHAT_ONLY_TEXT;
		tRulesText = string.gsub(tRulesText, "%[IP%]", sUser.sIP)
		tRulesText = string.gsub(tRulesText, "%[HUBOWNER%]", OWNER.Nick)
		tRulesText = string.gsub(tRulesText, "%[OWNERCONTACT%]", OWNER.Contact)
		BotSayToUser(sUser, tRulesText)
		return 1 
	end
	
	local _,_,towho = string.find(sData, "$RevConnectToMe%s+%S+%s+(%S+)|")
	return checkDLP(sUser,towho);
end
--------------------------------------------------------------------------------------------------------------------------------------------
function SearchArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then return 1 end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function MultiConnectToMeArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then return 1 end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function SRArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then return 1 end
end
--------------------------------------------------------------------------------------------------------------------------------------------
--[[
function UserIPArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then return 1 end
end
--]]
--------------------------------------------------------------------------------------------------------------------------------------------
function KickArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then return 1 end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function OpForceMoveArrival(sUser, sData)
	if sUser.iProfile == 0 then return 0 end
	if inDiap(sUser.sIP,IPCHECKS.CHAT_ONLY) then return 1 end
end



