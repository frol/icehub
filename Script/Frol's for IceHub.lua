BotName = "<ScriptBOT>"		-- ��� ���� 
BotDesc = "���� ����� ����"	-- �������� ����
BotEmail = "killbill@microsoft.com"	-- email ����



------------------------------------

function BadINFO(What, User)
 if (What=="Shara") then 
  SendToAll(TUser.sName, BotName, "C������ ��������� ����. ��������� "..TransShare(GetMinShare()));
 end;
 if (What=="E-Mail") then 
  SendToNick(TUser, "������� �-����.");
 end;
 DisconnectUser(User.sName);
 return 0;
end;

--[[function OnTimer()
 SendToAll(BotName,"������ ��� "..GetCurTime()..", � ���� ���� "..GetCurDate()..".");
 SendToAll(BotName,"�������� ��� ������ - http://l2storm.net");
 SendToAll(BotName,"�������� �������� ������!! - http://bash.org.ru ���� ������ ��� ����������� - �������� �� ����!!! �������� ������ =)");
-- SendPMToAll(BotName, "���� ������ http://danetka.dcworld.com.ua, http://qzone.dcworld.com.ua \r\n");
end;]]--

function NewConnect(User)
 return "�������������������������������������������������������������������������������������������������������������������������������������� \r\n"..
"������ Hub info :                                                                              �� ������ Your info: \r\n"..
"��������������� Hub       : "..GetProgName().." "..GetProgVer().."                                    �� ��������������� ���� ��� : "..User.sName.." \r\n"..
"��������������� ��������   : "..GetHubName()..GetHubTopic().."                                   ��  \r\n"..
"��������������� �����   : "..GetUpTime().."                                              �� ��������������� ���� IP �����  :   "..User.sIP.." \r\n"..
"��������������� ������������� : "..GetUsersCount().."                                                           �� \r\n"..
"��������������� ������������ ���������� ������������� �� ����: "..GetMaxUsersCount().."                                                           �� \r\n"..
"��������������� IP-�����   : "..GetHubIP().."                                    �� ��������������� ���� ������ : "..GetUserStatus(User.sName).." \r\n"..
"��������������� ����    : "..GetHubCurShare().."                                              ��  \r\n"..
"�������������������������������������������������������������������������������������������������������������������������������������";
--[["                                                                                           ......:::"..GetHubName().."�-�Hub~:::..... \r\n"..
"==========================================================================================(_ "..GetHubName().."�-�Hub_)========================== \r\n"..
":!: ���� ������� :!: \r\n"..
":!: ������ IceHub - ���������� �������� Frol \r\n"..
":!: ������ StormDC - ���������� �������� XONATIUS \r\n\r\n"..
":!: ���� ������:!: \r\n"..
":!: L2Storm - http://l2storm.net ������ ����� �������, �++ �5 �5, �����, 3������, �������, ����� - �� ��������!!! :!: \r\n"..
":!: QZone - http://qzone.dcworld.com.ua/ (�������� ����������)\r\n"..
":!: ������� - http://danetka.dcworld.com.ua (�������� ����������)/ \r\n"..
":!: dchub://10.102.50.158:23 - New.STOLICA (�������� ����������)\r\n"..
":!: dchub://10.102.50.158:410 - FENIX (�������� ����������)\r\n"..
"==========(_������������� ���� _)=======================================================================================================";
]]--
end;

function NewUserConnected(User)
 SendToNick(User.sName, BotName, NewConnect(User));
-- SendToAll(BotName,"���� ����� � ����� = "..User.sName.." IP = "..User.sIP)
 return 0;
end;

function UserDisconnected(User)
-- SendToAll(BotName,"���� "..User.sName.." ����")
 return 0;
end;

function OpConnected(User)
 SendToNick(User.sName, BotName, NewConnect(User));
 b=0;
--[[ if (User.sName=="Frol") then
  SendToAll(BotName, "��� � ��� � ������� ����� ���� ������");
  b=1;
 end;
 if (User.sName=="XONATIUS") then
  SendToAll(BotName, "�� ���������� ��������������?? ��� ����� XONATIUS");
  b=1;
 end;
 if (User.sName=="gemini") then
  SendToAll(BotName, "������������ ������ ����� ������� ���� �� ����� ������� �������!!! - gemini");
  b=1;
 end; if b==0 then
  SendToAll(BotName,"� ��� ������ �����, ����� ������ � ��������! ["..User.sName.."]");
 end;]]--
 SendToAll(BotName, "������������� ����, "..User.sName..", ������ �� ���.");
 return 0;
end;

function OpDisconnected(User)
-- SendToAll(BotName,"��� ������� �����")
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