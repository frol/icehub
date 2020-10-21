BotName = "<ScriptBOT>"		-- имя бота 
BotDesc = "Билл Гейтс умер"	-- описание бота
BotEmail = "killbill@microsoft.com"	-- email бота



------------------------------------

function BadINFO(What, User)
 if (What=="Shara") then 
  SendToAll(TUser.sName, BotName, "Cлишком маленькая шара. Расшарьте "..TransShare(GetMinShare()));
 end;
 if (What=="E-Mail") then 
  SendToNick(TUser, "Введите е-маил.");
 end;
 DisconnectUser(User.sName);
 return 0;
end;

function OnTimer()
 SendToAll(BotName,"Сейчас уже "..GetCurTime()..", а дата сёдня "..GetCurDate()..".");
 SendPMToAll(BotName, "Наши друзья http://danetka.dcworld.com.ua, http://qzone.dcworld.com.ua \r\n Сайт нашего проэкта ВРЕМЕННО не доступен =( \r\n ТУТА может быть ваша реклама!!!");
end;

function NewConnect(User)
 return "«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«» \r\n"..
"»»»»»» Hub info :                                                                              «» »»»»»» Your info: \r\n"..
"»»»»»»»»»»»»»»» Hub       : "..GetProgName().." "..GetProgVer().."                                    «» »»»»»»»»»»»»»»» Твой ник : "..User.sName.." \r\n"..
"»»»»»»»»»»»»»»» Название   : "..GetHubName()..GetHubTopic().."                                   «»  \r\n"..
"»»»»»»»»»»»»»»» Время   : "..GetUpTime().."                                              «» »»»»»»»»»»»»»»» Твой IP адрес  :   "..User.sIP.." \r\n"..
"»»»»»»»»»»»»»»» Юзеров: "..GetUsersCount().."                                                           «» \r\n"..
"»»»»»»»»»»»»»»» Макс юзеров на хабе: "..GetMaxUsersCount().."                                                           «» \r\n"..
"»»»»»»»»»»»»»»» Адрес   : "..GetHubIP().."                                    «» »»»»»»»»»»»»»»» Твой статус : "..GetUserStatus(User.sName).." \r\n"..
"»»»»»»»»»»»»»»» Шара    : "..GetHubCurShare().."                                              «»  \r\n"..
"«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«» \r\n"..
"                                                                                           ......:::"..GetHubName().." - Hub~:::..... \r\n"..
"==========================================================================================(_ "..GetHubName().." - Hub_)========================== \r\n"..
":!: НАШИ ПОСТОЯННЫЙ АДРЕСС (на этом адрессе он работает круглосуточно!!!) :!: \r\n"..
":!: DCHUB://QZONE.DCWORLD.COM.UA:2300 :!: \r\n"..
":!: DCHUB://QZONE.DCWORLD.COM.UA:23 :!: \r\n"..
":!: DCHUB://QZONE.DCWORLD.COM.UA:411 :!: \r\n"..
":!: DCHUB://QZONE.DCWORLD.COM.UA:7777 :!: \r\n"..
":!: DCHUB://QZONE.DCWORLD.COM.UA:5555 :!: \r\n"..
":!: НАШИ ПРОЭКТЫ :!: \r\n"..
":!: Сайт - http://qzone.dcworld.com.ua/  \r\n"..
":!: Проект IceHub - http://qzone.dcworld.com.ua/index.php?Action=Forum&Id=725 \r\n"..
":!: Проект StormDC - http://qzone.dcworld.com.ua/index.php?Action=Forum&Id=730/  \r\n\r\n"..
":!: НАШИ ДРУЗЬЯ:!: \r\n"..
":!: QZone - http://qzone.dcworld.com.ua/ \r\n"..
":!: ДАнетКА - http://danetka.dcworld.com.ua/ \r\n"..
":!: dchub://10.102.192.40:1411 -- Love.Angel.Music.Baby \r\n"..
"==========(_Администрация хаба _)=======================================================================================================";
end;

function NewUserConnected(User)
 SendToNick(User.sName, BotName, NewConnect(User));
-- SendToAll(BotName,"Юзер зашёл с ником = "..User.sName.." IP = "..User.sIP)
 return 0;
end;

function UserDisconnected(User)
-- SendToAll(BotName,"Юзер "..User.sName.." ушёл")
 return 0;
end;

function OpConnected(User)
 SendToNick(User.sName, BotName, NewConnect(User));
 b=0;
 if (User.sName=="Frol") then
  SendToAll(BotName, "ООО а вот и главный админ Фрол пришёл =)");
  b=1;
 end;
 if (User.sName=="XONATIUS") then
  SendToAll(BotName, "гг наконеццто падканнектился?? =) ЭТА АДМИН XONATIUS =)");
  b=1;
 end;
 if b==0 then
  SendToAll(BotName,"К нам пришёл неизвессный Админ, но ник сказать магу =) ("..User.sName..")")
 end;
-- SendToAll(BotName,"К нам пришёл Админ, а ник не скажу =)")
-- User:Kick("Frol", "FFFFFF");
 return 0;
end;

function OpDisconnected(User)
-- SendToAll(BotName,"Нас покинул админ")
 return 0;
end;


function Main()
 RegBot(BotName, 0, BotDesc, BotEmail);
-- Array_Nax = {[1] = "a", [2] = "b", [3] = "c", [4] = "d"};
-- Array_Nax = {{sNick="LOL"; sPassword="bolshoyLOL"; iProfile="VIP"}, {sNick="LOL1"; sPassword="bolshoyLOL3"; iProfile="VIP4"}};
-- SendToAll(Array_Nax[1].sNick.." "..Array_Nax[2].sPassword);
-- GetOnlineOperators();
 SetTimer("1800000");
 StartTimer();
end;