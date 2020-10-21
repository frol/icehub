-- Guardian by Troubadour ,[NL]-=DJ_Bert=- & [NL]MrBuitenhuizen

--Version Xenon
-- available in languages English, French, Dutch, German and Spanish
-- added all operator commands under right mouse button
-- added all user commands under right mouse button
-- another blocklist update
-- expanded hub switch network
-- added badword check and replacement (5 selectable items)
-- totally restyled the GUI (graphic user interface) for installing the script, editing the config or playing the game that comes along with it

--Version XP
-- available in languages English, French and Spanish
-- added guardian forum link in stats
-- restyled install menu
-- another blocklist update
-- rewritten some code
-- added information about IP, Client, Version, Mode when entering hub
-- also check for number of hubs and how registered there (Regular user, Registered user or Vip or Operator)
-- doesn't see master, moderator and such profiles (will count them as registered user)
-- added some rightclick functions to be sent to the operators of the hub
-- added some rightclick functions to be sent to the users of the hub

--Version SE2
-- created install menu (for options to install this script package or play the Guardian Game V1.1)
-- also added info buttons in the menu
-- fixed ops-kick part
-- updated range blocklist

--Version SE (special Edition)
-- included external blocklist (also for blocklist updates possibility)
-- created editor for the config file.
-- inserted !credits which displays a credits ansi (this one will also shown in hub at random time and can be changed)
-- created fakerinsult to let them know what we think about fakers!
-- added hubstats profile check
-- added iprange blocker (keywords of organisations that are blocked BMG, BUMA, BSA, MPAA, RIAA, MF, adsl, cable, disney, law, police, polizei, politie, guardian civil, sony, telephone, copyright, telecom)
-- added triggers to respond in the mainchat so standard questions will be answered by the bot (they are stored in the cfg file)
-- added Network Switch (to connect through the network from hub to hub)
-- included multitimer for announcements in mainchat (Thanks to Bonki)
-- Internal hubmail, also for users who are not online (will be stored in messages directorie until they have been readen by user)
-- commands are !mail <username> <message>, !checkmail and !delmail
-- added profiles Guest, Moderator and Networkmember
-- included Master, Moderator, Operator, Vip, Supervip and NetwerkMember announcement when entering and leaving the hub
-- included anti-spam and anti-advertise (replaces the adres with your own) Thanks to anti advertise by plop & anti url by Phatty. 
-- turned off showing of auto away message in opchat from users that are currently not available
-- added !writenews and !readnews (kind of a message board of the hub, only for vip and higher)
-- added description check on mldc and other clients
-- included Nickname check (created a fakers list)
-- added !away, !back and !showaway, !pig, !hideme, !unhideme, !mmop, !massmess, !myversion, !myip, !showreg
-- added fakeshare check (gives pm to OPS if found)
-- included search for badfile names
-- included /fav (dc++ command) in hubstats so people can put your hub to their favorites with one single command in mainchat
-- multiple help files

---Special Thanks---------------------------------------------------------------------
-- phatty for badword check source
--------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- Do Not Modify Below This Line
--------------------------------------------------------------------------------------

line, userKicks = nil, nil;
ignoreKicks, silentKicks, silentKickPMs = nil, nil, nil;

dofile("Guardian.cfg");  -- is used for the settings
dofile("Guardian/blocklist.txt");  -- is used for the ip blocklist

minutes = "45"

iState = 0;

sHubName = frmHub:GetHubName()
sHubDesc = frmHub:GetHubDescr()
sRedirect = frmHub:GetRedirectAddress()
sMaxUsers = frmHub:GetMaxUsers()
sMinShare = frmHub:GetMinShare()/(1024)
OpChat = frmHub:GetOpChatName()

hubsA = "!hubA" 
hubsB = "!hubB" 
hubsC = "!hubC" 
hubsD = "!hubD" 
hubsE = "!hubE" 
hubsF = "!hubF" 
hubsG = "!hubG" 
hubsH = "!hubH" 
hubsI = "!hubI"
hubsJ = "!hubJ"
cmnd = "!jump" 


NepShare = { "10000000000","5368709120","10737418240","13630010000","16106127360",
"21474836480","26843545600","27000000000","32212254720","7970010000",
"37580963840","37970010000","6599201000000","65992010000000","36772010000000",
"3677201000000","42949672960","48318382080","214266156265","53687091200",
"59055800320","1747201000000","16772010000000","147720100000000","10240000000000",
"64424509440","65719010000","69793218560","75161927680","80530636800","85899345920",
"91268055040","96636764160","102005473280","102400000000","107374182400","118648471552",
"128849018880","140301549174","161061273600","174720100000","183287729356","214748364800",
"268435456000","322122547200","375809638400","397760100000","429496729600","536870912000",
"657190100000","1024000000000","183287729357","102392020337","13625783747","174719269601",
"65712999629","26993869455","140295106724","21171699199" }

Files = {
["pre-teen"]="..line34..",
["preteen"]="..line34..",
["incest"]="..line34..",
["animalsex"]="..line35..",
["iexplorer.exe"]="..line36..", 
["notepad.exe"]="..line36..", 
["taskman.exe"]="..line36..",
["hmmapi.dll"]="..line36..",
["winipcfg.exe"]="..line36.."
}


awayArray = {}
Kicked = {} 
News = {}

function Whatfiles(data) 
	for i,v in Files do 
		if( strfind(strlower(data), i) ) then 
			return v 
		end 
	end
	return "..line37.." 
end

function Main() 
	frmHub:UnregBot(BOTName)
	frmHub:RegBot(BOTName)
	SendToAll("( >>>>  "..Version.." Started"..date(" the %A %d-%m-%Y at %X ").."  <<<< )")
	SendToAll(BOTNameInfo)
	AddProfile("Moderator", 4269273088)
	AddProfile("Guest", 2148028000)
	AddProfile("Networkmember", 2148028002)
 	iState = 4;
	SetTimer(60 * 1000);
	StartTimer();
end 

function OnTimer()
  if (iState == 1) then
    SendToAll(StrReplace(tStringTable[10]));
  elseif (iState == 2 and mod(date("%M") + Multiminutes, Multiminutes) == 0) then
    SetTimer(Multiminutes * 60 * 1000);
    iState = 1;
    SendToAll(BOTName, ""..line63..""..date("%a %d-%m-%Y %H:%M")..""..line64..""..sHubName..""..line65.."");
  elseif (iState == 3 and mod(date("%M") + Multiminutes, Multiminutes) == 0) then
    SetTimer(Multiminutes * 60 * 1000);
    iState = 2;
    SendAdMessage()
  elseif (iState == 4 and mod(date("%M") + Multiminutes, Multiminutes) == 0) then
    SetTimer(Multiminutes * 60 * 1000);
    iState = 3;
    SendToAll(BOTName, ""..welcome.."");
  elseif (iState == 5 and mod(date("%M") + Multiminutes, Multiminutes) == 0) then
    SetTimer(Multiminutes * 60 * 1000);
    iState = 4;
    end
end

function SendAdMessage()
	sCurrentShare = frmHub:GetCurrentShareAmount()/(1024^3)
	sUserCount = frmHub:GetUsersCount()

	local tmp = clock() 
	local days, hours, minutes = floor(tmp/86400), floor(mod(tmp/3600, 24)), floor(mod(tmp/60, 60))
	hubstats = "\r\n\r\n"..upline.."\r\n"..
		 "      •"..line2..":    		 "..Version.."\r\n"..
		 "      •"..line3..":	  	 "..Creators.."\r\n"..
		 "      •"..line4..":	  	 "..Translator.."\r\n"..
		 "      •"..line109..":	  	 "..Forum.."\r\n"..		 "      •"..line5..": 		    	 "..sHubName.."\r\n"..
		 "      •"..line6..":   		 "..sHubDesc.."\r\n"..
		 "      •"..line7..":		   	 "..HubAdress.."\r\n"..
		 "      •"..line8..":		   	 "..HubEmail.."\r\n"..
		 "      •"..line0..":			 "..Website.."\r\n"..
		 "      •"..line9..":		 	 "..HubOwner.."\r\n"..
		 "      •"..line10..":		 "..days.." days "..hours.." hours and "..minutes.." minutes\r\n"..
		 "      •"..line11..":   		 "..sRedirect.."\r\n"..
		 "      •"..line12..":  	 	 "..sMaxUsers.."\r\n"..
		 "      •"..line13..":   	 "..sUserCount.."\r\n"..
		 "      •"..line14..":  		 "..sMinShare.." GB".."\r\n"..
		 "      •"..line15..":   		 "..sCurrentShare.." in bytes".."\r\n"..
		 "      •"..line99..":		 "..CountProfiles("Master").."\r\n"..
		 "      •"..line106..":		 "..CountProfiles("Moderator").."\r\n"..
		 "      •"..line100..":			 "..CountProfiles("Operator").."\r\n"..
		 "      •"..line101..":			 "..CountProfiles("Vip").."\r\n"..
		 "      •"..line107..":		 "..CountProfiles("Networkmember").."\r\n"..
		 "      •"..line102..":			 "..CountProfiles("Reg").."\r\n"..
		 "      •"..line108..":			 "..CountProfiles("Guest").."\r\n"..
		 "      •"..line16..":	 		 !network".."\r\n"..
		 "      •"..line17..": 	"..line19.." ".."\r\n"..
		 "      •"..line18..":    			 !rules".."\r\n"..underline.."\r\n".." "

		SendToAll(BOTName, hubstats)
	end

function DataArrival(user,data) 

	if user.iProfile == -1 or user.iProfile == 2 or user.iProfile == 3 or user.iProfile == 5 
	  and strfind(data, "http://urlcut.com",1, 1) then
		SendToNick(user.sName, "---------===============================================-----")
		SendToNick(user.sName, BOTName ..""..line58.."")
		SendToNick(user.sName, "---------===============================================-----")
		SendToAll(user.sName, ""..line60.."")
		SendToAll( BOTName, user.sName.." "..line59.."" ) 
		user:TimeBan(minutes)
		user:Disconnect()
	elseif strfind(data, "http://pornstarguru.com",1, 1) then
		SendToNick(user.sName, "---------===============================================-----")
		SendToNick(user.sName, BOTName ..""..line58.."")
		SendToNick(user.sName, "---------===============================================-----")
		SendToAll(user.sName, ""..line60.."")
		SendToAll( BOTName, user.sName..""..line59.."" ) 
		user:TimeBan(minutes)
		user:Disconnect()
	elseif strfind(data, "http://outwar.com",1, 1) then
		SendToNick(user.sName, "---------===============================================-----")
		SendToNick(user.sName, BOTName ..""..line58.."")
		SendToNick(user.sName, "---------===============================================-----")
		SendToAll(user.sName, ""..line60.."")
		SendToAll( BOTName, user.sName.." "..line59.."" ) 
		user:TimeBan(minutes)
		user:Disconnect()
		end
		if strsub(data, 1, 1) == "<" then
		local s, e, who, why = strfind(data, "^%b<> %S+ "..line67.." (%S+)")
		if s and silentKicks then return 1
		end
		elseif strsub(data, 1, 3) == "$To" then
		local s, e, who, why = strfind(data, "^%$To: (%S+) From: %S+ %$%b<> "..line68.." (.*)|$")
		if s and silentKickPMs then return 1 
		end
	 end
		if( strsub(data, 1, 3) == "$SR" ) then 
		_,_,nick = strfind( data, "\05(%S*)|$" ) 
		if( nick == BOTName and Kicked[user.sName] == nil ) then 
		Kicked[user.sName] = 1 
		Reason = Whatfiles(data)
		SendToOps(BOTName, ""..line22.." "..user.sName.."  *** "..Reason.."  "..line29.." ["..user.sIP.."]")
		user:SendData(BOTName, ""..line30.."") 
		if user.iProfile == 0 or user.iProfile == 1 or user.iProfile == 4 or user.iProfile == 6
		then Kicked[user.sName] = 0 
		end
	end
end

		if strsub(data, 1, 5) == "$Kick" then
		local s, e, who = strfind(data, "^%$Kick (%S+)|$")
		if s then
			local tmp = GetItemByName(who)
			usrKicks[who] = usrKicks[who] or 0
			usrKicks[who] = usrKicks[who] + 1
			if tmp and usrKicks[who] >= maxKicks then
				SendToAll(BOTName, ""..line32..""..who..""..line69.."")
				tmp:SendData(""..line70.."")
			user:Ban(who)
			end 	
			for i,v in ops do 
			if ((user.sName == ops[i])) then
			Unban(ops[i])
			else break
			end 
			if ignoreKicks then return 1 end
			end 
		end 
	end
		if strsub(data, 1, 4) == "$To:" then
		_,_,whoto,whofrom,message = strfind(data, "%$To:%s(%S+)%sFrom:%s(%S+)%s%$%b<>%s(.*)")
		if whoto == OpChat then
			if user.bOperator then
				local _,_,isaway = strfind(message, ".*(%b<>)|$")
				if isaway ~= nil then
					return 1
				end 
			end
		 end
	end
		if strsub(data, 1, 1) == "<" then
		data=strsub(data,1,strlen(data)-1)
		s,e,cmd = strfind(data,"%b<>%s+(%S+)")
if (strfind(strlower(data), strlower(hubsA))) then 
user:SendData(BOTName, ""..line71..""..hubA.."") 
user:SendData(BOTName, ""..line71..""..hubA.."|$ForceMove "..hubA.."|") 
elseif (strfind(strlower(data), strlower(hubsB))) then 
user:SendData(BOTName, ""..line71..""..hubB.."") 
user:SendData(BOTName, ""..line71..""..hubB.."|$ForceMove "..hubB.."|") 
elseif (strfind(strlower(data), strlower(hubsC))) then 
user:SendData(BOTName, ""..line71..""..hubC.."") 
user:SendData(BOTName, ""..line71..""..hubC.."|$ForceMove "..hubC.."|") 
elseif (strfind(strlower(data), strlower(hubsD))) then 
user:SendData(BOTName, ""..line71..""..hubD.."") 
user:SendData(BOTName, ""..line71..""..hubD.."|$ForceMove "..hubD.."|") 
elseif (strfind(strlower(data), strlower(hubsE))) then 
user:SendData(BOTName, ""..line71..""..hubE.."") 
user:SendData(BOTName, ""..line71..""..hubE.."|$ForceMove "..hubE.."|") 
elseif (strfind(strlower(data), strlower(hubsF))) then 
user:SendData(BOTName, ""..line71..""..hubF.."") 
user:SendData(BOTName, ""..line71..""..hubF.."|$ForceMove "..hubF.."|") 
elseif (strfind(strlower(data), strlower(hubsG))) then 
user:SendData(BOTName, ""..line71..""..hubG.."") 
user:SendData(BOTName, ""..line71..""..hubG.."|$ForceMove "..hubG.."|") 
elseif (strfind(strlower(data), strlower(hubsH))) then 
user:SendData(BOTName, ""..line71..""..hubH.."") 
user:SendData(BOTName, ""..line71..""..hubH.."|$ForceMove "..hubH.."|") 
elseif (strfind(strlower(data), strlower(hubsI))) then 
user:SendData(BOTName, ""..line71..""..hubI.."") 
user:SendData(BOTName, ""..line71..""..hubI.."|$ForceMove "..hubI.."|") 
elseif (strfind(strlower(data), strlower(hubsJ))) then 
user:SendData(BOTName, ""..line71..""..hubJ.."") 
user:SendData(BOTName, ""..line71..""..hubJ.."|$ForceMove "..hubJ.."|") 
elseif (strfind(strlower(data), strlower(cmnd))) then 
user:SendData(BOTName, "----------------------------------------------------------------------------") 
user:SendData(BOTName, ""..line72.."") 
user:SendData(BOTName, "----------------------------------------------------------------------------") 
user:SendData(BOTName, ""..line73.."") 
user:SendData(BOTName, "----------------------------------------------------------------------------") 
user:SendData(BOTName, ""..line74..""..hubA..""..line82.."") 
user:SendData(BOTName, ""..line75..""..hubB..""..line83.."") 
user:SendData(BOTName, ""..line76..""..hubC..""..line84.."") 
user:SendData(BOTName, ""..line77..""..hubD..""..line85.."") 
user:SendData(BOTName, ""..line78..""..hubE..""..line86.."") 
user:SendData(BOTName, ""..line79..""..hubF..""..line87.."") 
user:SendData(BOTName, ""..line80..""..hubG..""..line88.."") 
user:SendData(BOTName, ""..line81..""..hubH..""..line89.."") 
user:SendData(BOTName, ""..line97..""..hubI..""..line98.."") 
user:SendData(BOTName, ""..line111..""..hubJ..""..line110.."") 
user:SendData(BOTName, "----------------------------------------------------------------------------") 
end 
		end

		if (cmd=="!help") then 
		if (user.iProfile < 0) then
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		return 1
		elseif user.iProfile == 0 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		user:SendData(StrReplace(tStringTable[6]));
		user:SendData(StrReplace(tStringTable[7]));
		user:SendData(StrReplace(tStringTable[8]));
		user:SendData(StrReplace(tStringTable[9]));
		return 1
			elseif user.iProfile == 1 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		user:SendData(StrReplace(tStringTable[6]));
		user:SendData(StrReplace(tStringTable[7]));
		return 1
			elseif user.iProfile == 2 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		user:SendData(StrReplace(tStringTable[6]));
		return 1
			elseif user.iProfile == 3 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		return 1
			elseif user.iProfile == 4 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		user:SendData(StrReplace(tStringTable[6]));
		user:SendData(StrReplace(tStringTable[7]));
		user:SendData(StrReplace(tStringTable[8]));
		return 1
		elseif user.iProfile == 5 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		return 1
		elseif user.iProfile == 6 then 
		user:SendData(BOTName, StrReplace(tStringTable[5]));
		user:SendData(StrReplace(tStringTable[6]));
		return 1
			end 
		elseif (cmd =="!checkmail") then
			Mailer(user)
		elseif (cmd =="!delmail") then
			a,b=remove("messages/"..user.sName..".msg")
			user:SendPM(Mail,""..line90.."")
			return 1
		elseif (cmd=="!mail") then 
			s,e,cmd,arg,arg2 = strfind(data,"%s+(%S+)%s+(%S+)%s+(.*)")
			if arg == nil or arg2 == nil then
				user:SendData(Mail,""..line91.."")
			return 1
			else
				local handle=openfile("messages/"..arg..".msg","a")
				write(handle,"("..user.sName..") :"..arg2.."§")
				user:SendPM(Mail,""..line92.."")
				closefile(handle)
				mailing = GetItemByName(arg)
				if mailing == nil then
				else
					mailing:SendPM(Mail,""..line93.."")
				end
			end
		elseif (cmd=="!network") then 
			SendNetwork(user) 
			return 1 
		elseif (cmd=="!pig") then 
			SendPig(user) 
			return 1 
		elseif (cmd=="!faq") then 
		user:SendData(BOTName, StrReplace(tStringTable[12]));
		return 1
		elseif (cmd=="!oprules") then 
		user:SendData(BOTName, StrReplace(tStringTable[11]));
		return 1
		elseif (cmd=="!showreg") then
			showreg(user)
			return 1
		elseif (cmd=="!away") then 
			doaway(user,data)
		return 1
		elseif(cmd=="!back") then
			doback(user)
		return 1
		elseif (cmd=="!showaway") then
			doshowaway(user)
		return 1
		elseif (cmd == "!myip" ) then
			user:SendData(BOTName,""..line26.." "..user.sIP)
			return 1
		elseif (cmd == "!massmess" ) then
			_,_,cmd,message = strfind( data, "%b<>%s+(%S+)%s+(.+)" )
			if user.iProfile == 1 or user.iProfile == 0 or user.iProfile == 4 then 
			SendPmToAll(user.sName, message)
			return 1
		end
		elseif (cmd == "!mmop" ) then
			_,_,cmd,message = strfind( data, "%b<>%s+(%S+)%s+(.+)" )
			if user.iProfile == 1 or user.iProfile == 0 or user.iProfile == 4 then 
			SendPmToOps(user.sName, message)
			return 1
		end
		elseif (cmd == "!hideme") and user.iProfile == 0 then 
		frmHub:UnregBot(user.sName)		-- make yourself invisible in the hub
		elseif (cmd == "!unhideme") and user.iProfile == 0 then 
		frmHub:RegBot(user.sName)		-- make yourself visible in the hub
		elseif (cmd == "!addreguser") then 
			if user.iProfile == 1 or user.iProfile == 0 or user.iProfile == 4 then 
				return 0 
			elseif (user.iProfile < 0) then
		SendToNick(BOTName, ""..line28.."" )
			end 
		elseif (cmd == "!me") then 
			AddAChatter(user) 
			return 0 
		elseif (cmd == "!smoke" ) then
			user:SendData(user.sName,""..smoke.."")
			return 1
		elseif (cmd == "!whereami" ) then
			user:SendData(BOTName,""..welcome.."")
			return 1
		elseif (cmd == "!whydc" ) then
			user:SendData(BOTName,""..trigger3.."")
			return 1
		elseif (cmd == "?help" ) then
			user:SendData(BOTName,""..trigger2.."")
			return 1
		elseif (cmd=="!readnews") then
			donews(user,data)
			return 0
		elseif (cmd=="!writenews") then
		if (user.iProfile) == 0 or (user.iProfile) == 1 or (user.iProfile) == 2 or (user.iProfile) == 4 then
			donewswrite(user,data)
			end
		elseif (cmd == "!lol" ) then
			showfunny(user)
			return 1
		elseif (cmd == "!credits" ) then
			user:SendData(StrReplace(tStringTable[10]));
			return 1
		elseif (cmd == "!whomadeguardian" ) then
		user:SendData(BOTName, StrReplace(tStringTable[1]));
		return 1
		elseif (cmd == "!networkrules" ) then
		user:SendData(BOTName, StrReplace(tStringTable[2]));
		return 1
		elseif (cmd == "!rules" ) then
		user:SendData(BOTName, StrReplace(tStringTable[3]));
		return 1
		elseif (cmd == "!description" ) then
		user:SendData(BOTName, StrReplace(tStringTable[4]));
		return 1
		elseif (cmd == "!botversion" ) then
		user:SendData(BOTName, StrReplace(tStringTable[10]));
		return 1
		elseif (cmd == "!stat") then
			return 0 
		elseif (cmd == "!topic") then
			return 0 
		elseif (cmd == "!reloadtxt") then
			return 0 
		elseif (cmd == "!clrpermban") then
			return 0 
		elseif (cmd == "!clrtempban") then
			return 0 
		elseif (cmd == "!userinfo") then
			return 0 
		elseif (cmd == "!iprangeinfo") then
			return 0 
		elseif (cmd == "!ipinfo") then
			return 0 
		elseif (cmd == "!banip") then
			return 0 
		elseif (cmd == "!gag") then
			return 0 
		elseif (cmd == "!ungag") then
			return 0 
		elseif (cmd == "!getinfo") then
			return 0 
		elseif (cmd == "!getbanlist") then
			return 0 
		elseif (cmd == "!nickban") then
			return 0 
		elseif (cmd == "!unban") then
			return 0 
		elseif (cmd == "!ban") then
			return 0 
		elseif (cmd == "!drop") then
			return 0 
		elseif (cmd == "!op") then
			return 0 
		elseif (cmd == "!restartscripts") and user.iProfile == 0 then 
			return 0 
		elseif (cmd == "!restart") and user.iProfile == 0 then 
			return 0 
		end
	
	if( strsub(data, 1, 1) == "<" ) then
		-- get the msg only using regular expression or so called single words
		s,e,msg = strfind(data, "%b<> ([%w ]*)")

		-- look in the table of the guardian.cfg file for the trigs
		for key, value in trigs do
			if( strfind( strlower(msg), key) ) then
				answer, x = gsub(value, "%b[]", user.sName) 
				SendToAll( BOTName, answer )
				break
			end
		end
	end
	if user.iProfile == -1 or user.iProfile == 2 or user.iProfile == 3 or user.iProfile == 5
	and (strsub(data, 1, 1) == "<") then
        if not(strsub(data, 1, 4) == "$To:") then 
         data = strsub(data, 1, (strlen(data)-1))
         local s,e,msg,webadver,msg2 = strfind(data, "%b<>%s(.*)http://([^%.]+%.[^%.]+%.%S+)(.*)$")
         if webadver ~= nil then 
            local s,e,webby = strfind(webadver, "(%S+%.[^%.]+%.%a+)/.*")
            if webby == nil then webby = webadver end
            if OKSITES[webby] == nil then
               SendToAll(user.sName, msg..""..Forum..""..msg2)
               return 1
            end
         else 
            local s,e,msg,webadver,msg2 = strfind(data, "%b<>%s(.*)(www+%.[^%.]+%.%S+)(.*)$")
            if webadver ~= nil then
               local s,e,webby = strfind(webadver, "(%S+%.[^%.]+%.%a+)/.*")
               if webby == nil then webby = webadver end
               if OKSITES[webby] == nil then
                  SendToAll(user.sName, msg..""..Forum..""..msg2)
                  return 1
               end
            else
               local s,e, adver = strfind(data, "%b<>%s(%S+%.[^%.]+%.[^%.]+)")
               if adver ~= nil then 
                  local s,e,hubby = strfind(adver, "(%S+%.[^%.]+%.%a+)/.*")
                  if hubby == nil then hubby = adver end
                  if OKHUBS[hubby] == nil then
                     SendToAll(user.sName, ""..HubAdress.."")
                     return 1
                  end
               else
                  local s,e,msg,adver,msg2 = strfind(data, "%b<>%s(.*)%s([^%.]+%.[^%.]+%.%S+)(.*)$")
                  if adver ~= nil then 
                     local s,e,hubby = strfind(adver, "(%S+%.[^%.]+%.%a+)/.*")
                     if hubby == nil then hubby = adver end
                     if OKHUBS[hubby] == nil then
                        SendToAll(user.sName, msg.." "..""..HubAdress..""..msg2)
                        return 1
                     end
                  end
               end
         end
end
      else
         --local s,e,to,text = strfind(data, "%$To: (%S+) From: %S %$(.+)$") 
                            local s,e,to,text = strfind(data,    "%$To:%s(%S+)%sFrom:%s%S+%s$(.*)$")
         if(to == nil) then return 0 end
         to = GetItemByName(to)
         if to.iProfile == -1 or to.iProfile == 3 then
            text = strsub(text, 1, (strlen(text)-1))
            local s,e,msg,webadver,msg2 = strfind(text, "%b<>%s(.*)http://([^%.]+%.[^%.]+%.%S+)(.*)$")
            if webadver ~= nil then 
               local s,e,webby = strfind(webadver, "(%S+%.[^%.]+%.%a+)/.*")
               if webby == nil then webby = webadver end
               if OKSITES[webby] == nil then
                  SendPmToNick(to.sName, user.sName, msg..""..Forum..""..msg2)
                  return 1
               end
            else 
               local s,e,msg,webadver,msg2 = strfind(text, "%b<>%s(.*)(www+%.[^%.]+%.%S+)(.*)$")
               if webadver ~= nil then
                  local s,e,webby = strfind(webadver, "(%S+%.[^%.]+%.%a+)/.*")
                  if webby == nil then webby = webadver end
                  if OKSITES[webby] == nil then
                     SendPmToNick(to.sName, user.sName, msg..""..Forum..""..msg2)
                     return 1
                  end
               else
                  local s,e, adver = strfind(text, "%b<>%s(%S+%.[^%.]+%.[^%.]+)")
                  if adver ~= nil then 
                     local s,e,hubby = strfind(adver, "(%S+%.[^%.]+%.%a+)/.*")
                     if hubby == nil then hubby = adver end
                     if OKHUBS[hubby] == nil then
                        SendPmToNick(to.sName, user.sName, ""..HubAdress.."")
                        return 1
                     end
                  else
                     local s,e,msg,adver,msg2 = strfind(text, "%b<>%s(.*)%s([^%.]+%.[^%.]+%.%S+)(.*)$")
                     if adver ~= nil then 
                        local s,e,hubby = strfind(adver, "(%S+%.[^%.]+%.%a+)/.*")
                        if hubby == nil then hubby = adver end
                        if OKHUBS[hubby] == nil then
                           SendPmToNick(to.sName, user.sName, msg.." "..""..HubAdress..""..msg2)
                           return 1
                        end 
                     end
                  end
               end
	    end
	 end
   end
end

	if strsub(data, 1, 1) == "<" then
		--data=strsub(data,1,strlen(data)-1)--not needed
		--s,e,cmd = strfind(data,"%b<>%s+(%S+)")--not needed

		----------------------------------
		--## BadWord Check by Phatty ## --
		----------------------------------
		if checkbadword == 1 then
			for i,v in badtable do
				if strfind(data, i) then
				return 1
				end
			end
		elseif checkbadword == 2 then
			for i,v in badtable do
			    	data=gsub(data, i, v)
				--data, x,y = gsub(data, "%b"..i, v)
			end
		elseif checkbadword == 3 then
			for i,v in badtable do
			    	data=gsub(data, i, "*censored*")
			end
		elseif checkbadword == 4 then
			for i,v in badtable do
			    	data=gsub(data, i, "")
			end
		elseif checkbadword == 5 then
			for i,v in badtable do
			    	if strfind(data,i) then
					reply = Random(user)
					user:SendData(Bot,reply..i)
					return 1
				end 
			end
		end	
		SendToAll(data)
		return 1
	end


--------- Op Connected ---------

function OpConnected(user)
	Send_Info(user)
	SendRightClick(user)
	Mailer(user)
	if (user.sName == HubOwner) 
	then SendToAll(BOTName, "[OWNER] "..HubOwner..", "..line.." ") 
	elseif (user.sName == HeadMaster) 
	then SendToAll(BOTName, "[HEADMASTER] "..HeadMaster..", "..line.." ") 
	elseif (user.sName == Master1) 
	then SendToAll(BOTName, "[MASTER] "..Master1..", "..line.." ") 
	elseif (user.sName == Master2) 
	then SendToAll(BOTName, "[MASTER] "..Master2..", "..line.." ") 
	elseif (user.sName == Master3) 
	then SendToAll(BOTName, "[MASTER] "..Master3..", "..line.." ") 
	elseif (user.sName == Master4) 
	then SendToAll(BOTName, "[MASTER] "..Master4..", "..line.." ") 
	elseif (user.sName == Master5) 
	then SendToAll(BOTName, "[MASTER] "..Master5..", "..line.." ") 
	elseif (user.sName == Moderator) 
	then SendToAll(BOTName, "[MODERATOR] "..Moderator..", "..line.." ") 
	elseif (user.sName == Moderator2) 
	then SendToAll(BOTName, "[MODERATOR] "..Moderator2..", "..line.." ") 
	elseif (user.sName == "[Operator]") 
	then SendPmToNick(BOTName, "[Operator] "..Operator.." , "..line.." ") 
	else
	SendToAll(BOTName, "[OPS] "..user.sName..", "..line.." ") 
	end
	end
			
--------- Op Disconnected ---------

function OpDisconnected(user)
	if (user.sName == HubOwner) 
	then SendToAll(BOTName, "[OWNER] "..HubOwner..", "..line1.." ")  
	elseif (user.sName == HeadMaster) 
	then SendToAll(BOTName, "[HEADMASTER] "..HeadMaster..", "..line1.." ")  
	elseif (user.sName == Master1) 
	then SendToAll(BOTName, "[MASTER] "..Master1..", "..line1.." ")  
	elseif (user.sName == Master2) 
	then SendToAll(BOTName, "[MASTER] "..Master2..", "..line1.." ")  
	elseif (user.sName == Master3) 
	then SendToAll(BOTName, "[MASTER] "..Master3..", "..line1.." ")  
	elseif (user.sName == Master4) 
	then SendToAll(BOTName, "[MASTER] "..Master4..", "..line1.." ") 
	elseif (user.sName == Master5) 
	then SendToAll(BOTName, "[MASTER] "..Master5..", "..line1.." ") 
	elseif (user.sName == Moderator) 
	then SendToAll(BOTName, "[MODERATOR] "..Moderator..", "..line1.." ") 
	elseif (user.sName == Moderator2) 
	then SendToAll(BOTName, "[MODERATOR] "..Moderator2..", "..line1.." ") 
	elseif (user.sName == "[Operator]") 
	then SendPmToNick(BOTName, "[Operator] "..Operator..", "..line1.." ")  
	elseif user.iProfile == 1 then
	SendToAll(BOTName, "[OPS] "..user.sName..", "..line1.." ")  
	end
end

--------- Vip Disconnected ---------

function UserDisconnected(user)
	if (user.sName == NetworkMember1) 
	then SendToAll(BOTName, "[NETWORKMEMBER] "..NetworkMember1..", "..line1.." ")  
	elseif (user.sName == NetworkMember2) 
	then SendToAll(BOTName, "[NETWORKMEMBER] "..NetworkMember2..", "..line1.." ")  
	elseif (user.sName == NetworkMember3) 
	then SendToAll(BOTName, "[NETWORKMEMBER] "..NetworkMember3..", "..line1.." ")  
	elseif (user.sName == SuperVipLady) 
	then SendToAll(BOTName, "[SUPERVIP] "..SuperVipLady..", "..line1.." ")  
	elseif (user.sName == SuperVip) 
	then SendToAll(BOTName, "[SUPERVIP] "..SuperVip..", "..line1.." ")  
	elseif (user.sName == HubGorgieus) 
	then SendToAll(BOTName, "[HUBGORGIEUS] "..HubGorgieus..", "..line1.." ")  
	elseif user.iProfile == 2 then
	SendToAll(BOTName, "[VIP] "..user.sName..", "..line1.." ")  
	end
end

---------------- Vip Connected -----------------
function NewUserConnected(user)
	a,b,c,sMode,ver,sClient = Client_Check(user)
	Mailer(user)
	if (user.sName == NetworkMember1) 
	then SendToAll(BOTName, "[NETWORKMEMBER] "..NetworkMember1..", "..line.." ")  
	elseif (user.sName == NetworkMember2) 
	then SendToAll(BOTName, "[NETWORKMEMBER] "..NetworkMember2..", "..line.." ")  
	elseif (user.sName == NetworkMember3) 
	then SendToAll(BOTName, "[NETWORKMEMBER] "..NetworkMember3..", "..line.." ")  
	elseif (user.sName == SuperVipLady) 
	then SendToAll(BOTName, "[SUPERVIP] "..SuperVipLady..", "..line25.." ")  
	elseif (user.sName == SuperVip) 
	then SendToAll(BOTName, "[SUPERVIP] "..SuperVip..", "..line.." ")  
	elseif (user.sName == HubGorgieus) 
	then SendToAll(BOTName, "[HUBGORGIEUS] "..HubGorgieus..", "..line25.." ")  
	elseif user.iProfile == 2 then
	SendToAll(BOTName, "[VIP] "..user.sName..", "..line.." ")  
	elseif user.iProfile == nil then
	SendToNick(BOTName, ""..line24.."" )
	end
	Send_Info(user)
	SendLeftClick(user)
	if (user.iProfile < 0) then
	for key,checkWord in forbiddenWords do 
	if strfind(user.sMyInfoString, checkWord, 1, 1) then 
	SendToNick(BOTName, ""..line54.."") 
	user:Disconnect() 
	end
	end
end
	if (user.iProfile < 0) then
			for i,v in Fakers do 
			if ((user.sName == Fakers[i])) then
				SendToNick(BOTName, " "..line47.." "..user.sName..", "..line48.."")
				SendToNick(BOTName, ""..line49.."")
				SendToOps(BOTName, ""..user.sName.." "..line50.."")
			user:Disconnect()
			else break
			end
		end
end
	if checkFake(user)then 
	SendToOps(BOTName,""..line22.." "..user.sName.." "..line21.." ["..user.sIP.."]")
	user:SendData(BOTName, ""..line20.."")
	user:SendData(BOTName, StrReplace(tStringTable[13]));
	user:Disconnect() 
	end

	if BlockedIp(user.sIP) == 1 then 
	user:SendPM(BOTName, ""..line94.."") 
	user:SendPM(BOTName, ""..line48.."") 
	SendPmToOps(BOTName, ""..line32.." "..user.sName.." "..line95.." "..user.sIP.." "..line96.." "..BOTName.."!") 
	user:Ban() 
	end
end

function checkFake(user)
	local s, e, shared = strfind(user.sMyInfoString, "$ALL %S+ .-$ $.+.$.-$(%d+)")
	return foreachi(NepShare, function(id, value) if value == %shared then return id end end)
	end
end

function MyInfoString(data)
s,e,description,speed,email,share = strfind(data, "$MyINFO $ALL ([^$]+)$ $([^$]*)$([^$]*)$([^$]+)")
speed = strsub(speed,1,strlen(speed)-1) 
return description,speed,email,share
end

function Mailer(user)
	handle2=openfile("messages/"..user.sName..".msg","r")
	if (handle2==nil) then 
	else
		line = read(handle2,"*a") 
		line=strsub(line,1,strlen(line)-1) 
		linearray=tokenize(line,"§")
		for i=1,linearray.n do
			user:SendPM(Mail,linearray[i]) 
		end
		closefile(handle2)
	end
end

function Send_Info(user)
a,b,c,sMode,ver,sClient = Client_Check(user)
Vanalles = " \r\n\r\n"..
	"Welcome "..user.sName.." To "..frmHub:GetHubName().."\r\n"..
	" \r\n"..underline.."\r\n"..
	"Information about you :\r\n"..
	"Your IP		•		"..user.sIP.."\r\n"..
	"Your Client	•		"..sClient.."\r\n"..
	"Version		•		"..ver.."\r\n"..
	"Mode		•		"..sMode.."\r\n"..
	" \r\n"..
	"You are in "..a.." Hub(s) as a Regular user\r\n"..
	"You are in "..b.." Hub(s) as a Registered user or Vip\r\n"..
	"You are in "..c.." Hub(s) as a Operator\r\n"..
	" \r\n"..underline.."\r\n".." "
	user:SendData(BOTName, Vanalles)
end

function DoRead(user)
	while 1 do 
		pline = read() 
		if pline == nil then break end
			user:SendPM(BOTName, pline)
		end 
	readfrom() 
end

function tokenize (inString,token)  
     _WORDS = {}  
     local matcher = "([^§"..token.."]+)"  
     gsub(inString, matcher, function (w) tinsert(_WORDS,w) end)  
     return _WORDS  
end

function Client_Check(user)
--Ver,Client
	if user.sMyInfoString ~= nil then
		local s,e,ver,sMode = strfind(user.sMyInfoString,"V:(%S+),M:(%S),H")
		local s,e,a,b,c = strfind(user.sMyInfoString,"H:(%d+)/(%d+)/(%d+)")
		if ver == nil then
			ver = "(N/A)"
		end

		if a == nil then a = "(N/A)" end
		if b == nil then b = "(N/A)" end
		if c == nil then c = "(N/A)" end

		if sMode == "A" then sMode = "Active"
		elseif sMode == "P" then sMode = "Passive"
		else sMode = "(N/A)"
		end

		if strfind(user.sMyInfoString,"<++") then
			sClient = "DC++"
		elseif strfind(user.sMyInfoString,"<o") then
			sClient = "Opera DC"
		elseif strfind(user.sMyInfoString,"<oDC") then
			sClient = "Opera DC"
		elseif strfind(user.sMyInfoString,"<DCGUI") then
			sClient = "DC-GUI"
		elseif strfind(user.sMyInfoString,"http://dc.ketelhot.de") then
			sClient = "DC-GUI"
		elseif strfind(user.sMyInfoString,"<DC:PRO") then
			sClient = "DC:PRO"
		elseif strfind(user.sMyInfoString,"<.P>") then
			sClient = "Phantom DC"
		elseif strfind(user.sMyInfoString,"<DC%s") then
			sClient = "NeoModus Direct Connect"
		else
			sClient = "(N/A)"
		end
		return a,b,c,sMode,ver,sClient
	end
end

function showreg(user)
	user:SendPM(BOTName, ""..line23.."")
	user:SendPM(BOTName, "_______________________________")
	user:SendPM(BOTName, "••• Level\t==> Nick")
	user:SendPM(BOTName, "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯")
	local allprofiles = GetProfiles()
	local index, profile, index2, username, n
	for index, profile in allprofiles do
		if strlower(profile) ~= strlower("reg") then
			n = 0
			message = "••• "..profile.."\t==> "
			local users = GetUsersByProfile(profile)
			for index2, username in users do
				if not username or username == "" then
					message = nil
				elseif n < 3 then
					message = message..username.."\t"
					n = n + 1
				else
					user:SendPM(BOTName, message)
					message = "••• \t\t==> "..username.."\t"
					n = 1
				end
			end
			if message == "••• "..profile.."\t==> " then
				message = nil
			end
			user:SendPM(BOTName, message)
		end
	end
end

function SendNetwork(user) 
	readfrom("Guardian/network.txt") 
	DoRead(user) 
end

function SendPig(user) 
	local pig =" \r\n"
	readfrom("Guardian/pig.txt")
	while 1 do
		local line = read()
		if (line == nil) then
			break
		else
			pig = pig..line.."\r\n"
		end
	end
	SendPmToNick(user.sName, BOTName,  "\r\n"..pig)
	readfrom()
end

function StrReplace(sString)
	sString = gsub(sString, "%$(%w+)", function (w)
						if(strsub(w,1,1) == "$") then
							return strsub(w,2,-1);
						else
							return getglobal(w) or "nil";
						end
					end);
	return sString;
end

function GetArgs1(data)
local s,w, arg1 = strfind(data,"%a+%S+%a+(.+)")
return arg1
end

function GetArgs2(data)
local s,w, arg1,arg2 = strfind(data,"%s+%S+%s+(%S+)%s+(.+)")
return arg1,arg2
end

function GetArgs3(data) 
local s,w, arg1,arg2,arg3 = strfind(data,"%s+%S+%s+(%S+)%s+(%S+)%s+(.+)")
return arg1,arg2,arg3
end

function doaway(user,data)
	s,e,cmd,arg = strfind( data, "%b<>%s+(%S+)%s+(.*)" ) 
		if (not (arg)) then
		arg = ""..line39..""
		end
	SendPmToNick(user.sName, BOTName, ""..line40.."")
	SendToAll(BOTName,date(user.sName..""..line41.."")..arg.." ;)") 
	awayArray[user.sName]=arg
end

function doback(user)
	if (awayArray[user.sName]==nil) then
	else
	SendPmToNick(user.sName, BOTName, ""..line42.."")
	SendToAll(BOTName,date(user.sName..""..line43..""))
	awayArray[user.sName]=nil
	end
end

function doshowaway(user)
	SendPmToNick(user.sName, BOTName,""..line44.."")
	for index, value in awayArray do
	user:SendPM(BOTName," »  "..index..""..line45..""..value..".|")
	end
end

function donewswrite(user,data)
	s,e,arg,wie = strfind( data, "%b<>%s+%S+%s+(.+)" )
	if arg == nil then
		arg = ""..line51..""
		user:SendData(BOTName, arg)
		return 1
	end
	local handle=openfile("Guardian/news.txt","a")
	write(handle,user.sName, " On the "..date("%d").."."..date("%m").."."..date("%y").." - "..date("%H")..":"..date("%M").." - wrote : " ,  arg.. "\r\n")
	SendToAll(BOTName, ""..line52.." "..user.sName.."")
	SendPmToNick(user.sName, BOTName, ""..line53.."")
	closefile(handle)
end

function donews(user)
	local news =" \r\n"
	readfrom("Guardian/news.txt")
	while 1 do
		local line = read()
		if (line == nil) then
			break
		else
			news = news..line.."\r\n"
		end
	end
	SendPmToNick(user.sName, BOTName,  "\r\n"..news)
	readfrom()
end

function Random(user)
	test = random(5)
		x1 = user.sName.." your a "
		x2 = user.sName.." you "
		x3 = user.sName.." haha you "
		x4 = user.sName.." is a "
		x5 = user.sName.." bwhahaha you stupid, "
		dostring("ret=x"..test)
	return ret
end

function CountProfiles(profile) 
local t,c = GetUsersByProfile(profile),0 
for i,user in t do 
if GetItemByName(user) then 
c = c + 1 
end 
end 
return c 
end 

-- operator rightclick commands
function SendRightClick(user) 
	local text = "|$UserCommand 255 7|$UserCommand 0 7|$UserCommand 1 2 Show the "..sHubName.." Help file$<%[mynick]> "..help.."&#124;|$UserCommand 1 2 Show Hub Rules$<%[mynick]> "..rules.." &#124;|$UserCommand 1 2 Show Hub Operator Rules$<%[mynick]> "..oprules.." &#124;|$UserCommand 1 2 Show the Guardian Forum url$<%[mynick]> "..Forum.."&#124;|$UserCommand 1 2 Show the hubs script version$<%[mynick]> "..botversion.."&#124;|$UserCommand 1 2 Explaining the users Description$<%[mynick]> "..description.."&#124;|$UserCommand 1 2 Show where you are$<%[mynick]> "..whereami.."&#124;|$UserCommand 1 2 Show why dc is developed$<%[mynick]> "..whydc.."&#124;|$UserCommand 1 2 Show who made Guardian$<%[mynick]> "..whomade.."&#124;|$UserCommand 1 2 Show the networkrules$<%[mynick]> "..nrules.."&#124;|$UserCommand 1 2 Get your IP$<%[mynick]> "..myip.." %[nick]&#124;|$UserCommand 1 2 Show the Faq$<%[mynick]> "..faq.."&#124;|$UserCommand 1 2 Show the smoking ansi$<%[mynick]> "..smoking.."&#124;|$UserCommand 1 2 Show the LOL ansi$<%[mynick]> "..lol.."&#124;|$UserCommand 0 2|$UserCommand 1 2 Show the hub switch$<%[mynick]> "..jump.."&#124;|$UserCommand 1 2 Mass Message to Ops$<%[mynick]> "..mmop.." %[nick] %[line:message]&#124;|$UserCommand 1 2 Mass Message to Users$<%[mynick]> "..massmess.." %[nick] %[line:message]&#124;|$UserCommand 1 2 Set yourself in Away Mode$<%[mynick]> "..away.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 Set yourself in Back Mode$<%[mynick]> "..back.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 Show all away user$<%[mynick]> "..showaway.."&#124;|$UserCommand 1 2 Read the news section$<%[mynick]> "..readnews.."&#124;|$UserCommand 1 2 Write to the news section$<%[mynick]> "..writenews.." %[nick] %[line:message]&#124;|$UserCommand 1 2 Send a hub mail to a User$<%[mynick]> "..mail.." %[nick] %[line:username to send to] %[line:message to send]&#124;|$UserCommand 1 2 Check your hub mail$<%[mynick]> "..checkmail.." %[nick]&#124;|$UserCommand 1 2 Delete your hub mail$<%[mynick]> "..delmail.." %[nick]&#124;|$UserCommand 1 2 Kick User$<%[mynick]> "..kick.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 Silent Kick User$<%[mynick]> "..drop.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 Timeban User$<%[mynick]> "..timeban.." %[nick] %[line:Hours] %[line:Reason]&#124;|$UserCommand 1 2 Ban User$<%[mynick]> "..ban.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 UnBan User$<%[mynick]> "..unban.." %[nick] %[line:Name or IP]&#124;|$UserCommand 1 2 Kick Fake User$<%[mynick]> "..kick.." %[nick] Faker, Have a nice day! %[line:Extra Reason]&#124;|$UserCommand 1 2 Ban Fake User $<%[mynick]> "..ban.." %[nick] Faker, Have a nice day! %[line:Extra Reason]&#124;|$UserCommand 1 2 Get the banlist$<%[mynick]> "..getbanlist.."&#124;|$UserCommand 1 2 Clear tempban list$<%[mynick]> "..clrtempban.."&#124;|$UserCommand 1 2 Userinfo User$<%[mynick]> "..userinfo.." %[nick]&#124;|$UserCommand 1 2 Nickban User$<%[mynick]> "..nickban.." %[nick]&#124;|$UserCommand 1 2 GetIP from User$<%[mynick]> "..getip.." %[nick]&#124;|$UserCommand 1 2 Ban IP$<%[mynick]> "..banip.." %[line:IP]&#124;|$UserCommand 1 2 Gag User$<%[mynick]> "..gag.." %[nick]&#124;|$UserCommand 1 2 UnGag User$<%[mynick]> "..ungag.." %[nick]&#124;|$UserCommand 1 2 Register User$<%[mynick]> "..reg.." %[nick] %[line:Password] %[line:Profile (Reg, VIP etc)]&#124;|$UserCommand 1 2 Kick User for KaZaA Files$<%[mynick]> "..kick.." %[nick] Dont share Incomplete KaZaA files (%[file])&#124;|$UserCommand 1 2 Kick User for _INCOMPLETE_ Files$<%[mynick]> "..kick.." %[nick] Don't Share __INCOMPLETE__ files (%[file])&#124;|$UserCommand 1 2 Kick User for Forbidden Files$<%[mynick]> "..kick.." %[nick] Forbidden Files: %[file]&#124;|$UserCommand 0 2|$UserCommand 1 2 Show your hubtime$<%[mynick]> "..mytime.."&#124;|$UserCommand 1 2 Show the topchatters$<%[mynick]> "..topchatter.."&#124;|$UserCommand 1 2 Show the toponliners$<%[mynick]> "..toponliner.."&#124;|$UserCommand 1 2 Show the topkickers$<%[mynick]> "..topkicker.."&#124;|$UserCommand 1 2 Show the topbanners$<%[mynick]> "..topbanner.."&#124;|"
	user:SendData(BOTName, "Sending you the rightclick Guardian Xenon Operator Hub Commands.")
	user:SendData(text.."|") 
end

-- regular user rightclick commands
function SendLeftClick(user)
	local text = "|$UserCommand 255 7|$UserCommand 0 7|$UserCommand 1 2 Show the "..sHubName.." Help file$<%[mynick]> "..help.."&#124;|$UserCommand 1 2 Show Hub Rules$<%[mynick]> "..rules.." &#124;|$UserCommand 1 2 Show the Guardian Forum url$<%[mynick]> "..Forum.."&#124;|$UserCommand 1 2 Show the hubs script version$<%[mynick]> "..botversion.."&#124;|$UserCommand 1 2 Explaining the users Description$<%[mynick]> "..description.."&#124;|$UserCommand 1 2 Show the Faq$<%[mynick]> "..faq.."&#124;|$UserCommand 1 2 Show where you are$<%[mynick]> "..whereami.."&#124;|$UserCommand 1 2 Show who made Guardian$<%[mynick]> "..whomade.."&#124;|$UserCommand 1 2 Show why dc is developed$<%[mynick]> "..whydc.."&#124;|$UserCommand 1 2 Show the networkrules$<%[mynick]> "..nrules.."&#124;|$UserCommand 1 2 Show the smoking ansi$<%[mynick]> "..smoking.."&#124;|$UserCommand 1 2 Show the LOL ansi$<%[mynick]> "..lol.."&#124;|$UserCommand 0 2|$UserCommand 1 2 Set yourself in Away Mode$<%[mynick]> "..away.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 Set yourself in Back Mode$<%[mynick]> "..back.." %[nick] %[line:Reason]&#124;|$UserCommand 1 2 Show all away user$<%[mynick]> "..showaway.."&#124;|$UserCommand 1 2 Show the hub switch$<%[mynick]> "..jump.."&#124;|$UserCommand 1 2 Get your IP$<%[mynick]> "..myip.." %[nick]&#124;|$UserCommand 1 2 Read the news section$<%[mynick]> "..readnews.."&#124;|$UserCommand 1 2 Write to the news section$<%[mynick]> "..writenews.." %[nick] %[line:message]&#124;|$UserCommand 1 2 Send a hub mail to a User$<%[mynick]> "..mail.." %[nick] %[line:username to send to] %[line:message to send]&#124;|$UserCommand 1 2 Check your hub mail$<%[mynick]> "..checkmail.." %[nick]&#124;|$UserCommand 1 2 Delete your hub mail$<%[mynick]> "..delmail.." %[nick]&#124;|$UserCommand 1 2 Show your hubtime$<%[mynick]> "..mytime.."&#124;|$UserCommand 1 2 Show the topchatters$<%[mynick]> "..topchatter.."&#124;|$UserCommand 1 2 Show the toponliners$<%[mynick]> "..toponliner.."&#124;|"
	user:SendData(BOTName, "Sending you the rightclick Guardian Xenon user Hub Commands.")
	user:SendData(text.."|") 
end

function showfunny(user)
	funny = "\r\n\r\n"..


"  ,.·^*''l'\            .·^*'´¯¯¯''*^·,.  ,/l''*^·-,\r\n"..
" 'l       'l::\       ,·'     ,.·:*:·,     ''i::; 'l       l\r\n"..
" 'l       'l:::      ;       ':,:::,:·       ';:::'l       l' \r\n"..
" 'l       l::;i - ·;i' :,      ¯¯       ,·´l::::'l       l \r\n"..
" 'l       '´       'l'i::: *: ·.–· ^*'´: :'l::,.::I       '''*· ,\r\n"..
" 'l        ,.-:^:':'\:' :;:: :: : : : :: ::; ·'i:::l':´·.,      ''i\r\n"..
" 'l  ,.:'':::::::::::'\  ' *^ ·:–:· ^*'´  'l/::::::::''::^:., /\r\n"..
"  '´:;:::::::::;:-·^*'                         '*^·:;--:;·'  \r\n".." "
user:SendData(BOTName, funny)
end


-- This function checks to see if users ip should be blocked from entering the hub 

function BlockedIp(tmpip) 

local r1,g1,a1,b1,c1,d1 = strfind(tmpip, "(%d*).(%d*).(%d*).(%d*)") 

for s,e in blockedips do 

local r2,g2,a2,b2,c2,d2 = strfind(s, "(%d*).(%d*).(%d*).(%d*)") 

local r3,g3,a3,b3,c3,d3 = strfind(e, "(%d*).(%d*).(%d*).(%d*)") 

if a1 > a2 and a1 < a3 then 

return 1 

elseif a1==a2 and a1==a3 then 

if b1 > b2 and b1 < b3 then 

return 1 

elseif b1==b2 and b1==b3 then 

if c1 > c2 and c2 < c3 then 

return 1 

elseif c1==c2 and c1==c3 then 

if d1 > d2 and d1 < d3 then 

return 1 

else 

return 0 

end 

elseif c1==c2 then 

if d1 >d2 then 

return 1 

else 

return 0 

end 

elseif c1==c3 then 

if d1 <d3 then 

return 1 

else 

return 0 

end 

else 

return 0 

end 

elseif b1==b2 then 

if c1>c2 then 

return 1 

elseif c1==c2 then 

if d1 > d2 then 

return 1 

else 

return 0 

end 

else 

return 0 

end 

elseif b1==b3 then 

if c1<c3 then 

return 1 

elseif c1==c3 then 

if d1<d3 then 

return 1 

else 

return 0 

end 

else 

return 0 

end 

else 

return 0 

end 

elseif a1==a2 then 

if b1>b2 then 

return 1 

elseif b1==b2 then 

if c1>c2 then 

return 1 

elseif c1==c2 then 

if d1>c2 then 

return 1 

else 

return 0 

end 

else 

return 0 

end 

else 

return 0 

end 

elseif a1==a3 then 

if b1<b3 then 

return 1 

elseif b1==b3 then 

if c1<c3 then 

return 1 

elseif c1==c3 then 

if d1<d3 then 

return 1 

else 

return 0 

end 

else 

return 0 

end 

else 

return 0 

end 

else 

return 0 

end 

end 

end 
