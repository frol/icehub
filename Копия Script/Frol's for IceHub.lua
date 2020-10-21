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

--[[function OnTimer()
 SendToAll(BotName,"Сейчас уже "..GetCurTime()..", а дата сёдня "..GetCurDate()..".");
 SendToAll(BotName,"Посетите наш ресурс - http://l2storm.net");
 SendToAll(BotName,"Посетите цитатник РуНета!! - http://bash.org.ru если цитата вам понравилась - выложите ее суда!!! посмеёмся вместе =)");
-- SendPMToAll(BotName, "Наши друзья http://danetka.dcworld.com.ua, http://qzone.dcworld.com.ua \r\n");
end;]]--

function NewConnect(User)
 return "«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«» \r\n"..
"»»»»»» Hub info :                                                                              «» »»»»»» Your info: \r\n"..
"»»»»»»»»»»»»»»» Hub       : "..GetProgName().." "..GetProgVer().."                                    «» »»»»»»»»»»»»»»» Твой ник : "..User.sName.." \r\n"..
"»»»»»»»»»»»»»»» Название   : "..GetHubName()..GetHubTopic().."                                   «»  \r\n"..
"»»»»»»»»»»»»»»» Время   : "..GetUpTime().."                                              «» »»»»»»»»»»»»»»» Твой IP адрес  :   "..User.sIP.." \r\n"..
"»»»»»»»»»»»»»»» Пользователей : "..GetUsersCount().."                                                           «» \r\n"..
"»»»»»»»»»»»»»»» Максимальное количество пользователей на хабе: "..GetMaxUsersCount().."                                                           «» \r\n"..
"»»»»»»»»»»»»»»» IP-Адрес   : "..GetHubIP().."                                    «» »»»»»»»»»»»»»»» Твой статус : "..GetUserStatus(User.sName).." \r\n"..
"»»»»»»»»»»»»»»» Шара    : "..GetHubCurShare().."                                              «»  \r\n"..
"«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«";
--[["                                                                                           ......:::"..GetHubName().." - Hub~:::..... \r\n"..
"==========================================================================================(_ "..GetHubName().." - Hub_)========================== \r\n"..
":!: НАШИ ПРОЭКТЫ :!: \r\n"..
":!: Проект IceHub - занимается проэктом Frol \r\n"..
":!: Проект StormDC - занимается проэктом XONATIUS \r\n\r\n"..
":!: НАШИ ДРУЗЬЯ:!: \r\n"..
":!: L2Storm - http://l2storm.net лучшый прокт Украины, С++ С5 х5, скилы, 3ипрофы, геодата, зарич - всё работает!!! :!: \r\n"..
":!: QZone - http://qzone.dcworld.com.ua/ (временно недоступен)\r\n"..
":!: ДАнетКА - http://danetka.dcworld.com.ua (временно недоступен)/ \r\n"..
":!: dchub://10.102.50.158:23 - New.STOLICA (временно недоступен)\r\n"..
":!: dchub://10.102.50.158:410 - FENIX (временно недоступен)\r\n"..
"==========(_Администрация хаба _)=======================================================================================================";
]]--
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
--[[ if (User.sName=="Frol") then
  SendToAll(BotName, "ООО а вот и главный админ Фрол пришёл");
  b=1;
 end;
 if (User.sName=="XONATIUS") then
  SendToAll(BotName, "гг наконеццто падканнектился?? ЭТА АДМИН XONATIUS");
  b=1;
 end;
 if (User.sName=="gemini") then
  SendToAll(BotName, "Приветствуем Админа нашей любимой игры на нашем любимом сервере!!! - gemini");
  b=1;
 end; if b==0 then
  SendToAll(BotName,"К нам пришёл Админ, прошу любить и жаловать! ["..User.sName.."]");
 end;]]--
 SendToAll(BotName, "Администратор хаба, "..User.sName..", пришёл на хаб.");
 return 0;
end;

function OpDisconnected(User)
-- SendToAll(BotName,"Нас покинул админ")
 return 0;
end;


function Main()
 RegBot(BotName, 0, BotDesc, BotEmail);
-- Array_N = {[1] = "a", [2] = "b", [3] = "c", [4] = "d"};
-- Array_N = {{sNick="LOL"; sPassword="bolshoyLOL"; iProfile="VIP"}, {sNick="LOL1"; sPassword="bolshoyLOL3"; iProfile="VIP4"}};
-- SendToAll(Array_N[1].sNick.." "..Array_N[2].sPassword);
-- GetOnlineOperators();
-- SetTimer("1800000");
-- StartTimer();
end;