����� � ���������������� ������ =)

Settings\config.ini : �������� ���������������� ���� (����� ����� - �� ���� ��������, � �������� ��� ������ ���������� ������ ����������� ����� � ��������� ���� ������� ������� - ����� �� ������!!!)

Settings\OpList.txt :
    ��������� - <���>;#<����� (� ������) �� 0 �� 10>
Settings\RegUsersList.txt :
    ��������� - <���>;#<������>
Settings\BanIP.txt :
    ��������� - <IP>;#<����>;#<�����> (�� �� ������� ��������� � ��� ����� �������!!!)
Settings\BanName.txt :
    ��������� - <���>;#<����>;#<�����> (�� �� ������� ��������� � ��� ����� �������!!!)
Settings\MsgIP.txt :
    ��������� - <IP>;#<����>;#<�����> (�� �� ������� ��������� � ��� ����� �������!!!)
Settings\MsgName.txt :
    ��������� - <���>;#<����>;#<�����> (�� �� ������� ��������� � ��� ����� �������!!!)
Settings\FAQ.txt : �������� ����

Settings\Hello.txt : �������� �������������� ��������� (����� ������������� ����� �������)

Settings\Menu.txt : �������� ������� ���� (����� ������������� ����� �������)
    ��������� - $UserCommand 1(0 - �����������, 1 - ��������) 2(1 - �� ��������, 2 - �� ������, 3 - �����) ���� ����\�����������\������� ������������������� ����������� (����) $<%[mynick]> !DelReg %[nick]&#124; (����� $ - �� ��� ������� �� ������)|

Settings\CoolNames.txt : ������ ������������ ������� �������������� ����� (���� �������� ���� �� ��������� � ���� ����� ������)
    ��������� - <����������� ���>|<�� ��� ��������>

Script\files.cfg : � ������ - ����� ��������, ����� ���� (����� �����)

�� ��������� � ����� Script - �� ������


��������� ������� �������:

 SendToAll(MyNick, Data) - ������� ��� �� ���� 
 SendToAll(Data) - ������� ����
 SendToNick(ToNick, MyNick, Data) - ������� ToNick� �� MyNick 
 SendPMToAll(Nick, Data) - ���� � ����� �� ����
 SendPMToNick(ToNick, MyNick, Data) - ������� ����� ToNick� �� MyNick 
 UnregBot(Nick)
 RegBot(Nick, 0, Description, E-Mail)
 GetHubIP()
 GetHubAddress()
 GetHubPort()
 GetHubName()
 SetHubName(Name)
 GetHubTopic()
 SetHubTopic(Name)
 GetMinShare()
 SetMinshare(Size in bytes)
 GetMinSlots()
 SetMinSlots(Count)
 GetMaxSlots()
 SetMaxSlots(Count)
 GetMaxHubs()
 GetHubBotName()
 SetHubBotName(Nick)
 Restart()
 GetUserPassword(Nick)
 GetIceLocation()
 GetUpTime()
 isNickRegged(Nick) - return 1 or 0
-- GetOnlineOperators()
-- GetOnlineNonOperators()
-- GetOnlineRegUsers()
-- GetTempBanList()
 SetTimer(time miliseconds),
 StartTimer()
 StopTimer()
 DisconnectUser(Nick)

 Main()
 OnExit()
 OnTimer()
 NewUserConnected(User)
 UserDisconnected(User)
 OpConnected(User)
 OpDisconnected(User)
 OnError(ErrorMsg)
 SupportsArrival(User, Data)			- Incoming supports from user.
 ChatArrival(User, Data)				- Incoming chat message from user.  If script return 1 hub don't process data.
 KeyArrival(User, Data)				- Incoming key from user.
 ValidateNickArrival(User, Data)		- Incoming validate nick from user.
 PasswordArrival(User, Data)			- Incoming password from user.
 GetNickListArrival(User, Data)			- Incoming get nick list request from user.
 MyINFOArrival(User, Data)			- Incoming user myinfo.
 GetINFOArrival(User, Data)			- Incoming get info request from user.
 SearchArrival(User, Data)			- Incoming search request from user. If s  cript return 1 hub don't process data.
 ToArrival(User, Data)				- Incoming private message from user. If  script return 1 hub don't process data.
 ConnectToMeArrival(User, Data)			- Incoming active connection request from  user. If script return 1 hub don't process data.
 RevConnectToMeArrival(User, Data)		- Incoming pasive connection request from  user. If script return 1 hub don't process data.
 SRArrival(User, Data)				- Incoming search reply from user. If script  return 1 hub don't process data. 
 KickArrival(User, Data)			- Incoming kick command from user.  If script return 1 hub don't process data.

��������� ������� ��������� : ��� ��� ���������

��������� ������� ������ � ���� :
 !help - ����� ������ (�����=����)
 !reg - �������� ��� (�����=����)
 !DelReg - ������� ��������� ��� (�����=���� - ������� ������ ��; 5 - ������� ����� �����������)
 +ReKlAmA <�����> - �������� ���� � ����� ����� (�����=5)
 +AddOp - ��������� ��� (�����=10)
 -DelOp - ������� ��� (�����=10)
 +BanIP - ��� �� �� (�����=9)
 +BanName - ��� �� ���� (�����=9)
 -BanIP - ��������� �� �� (�����=9)
 -BanName - ��������� �� ���� (�����=9)
 !BannedUsers - �������� ���� ��������� (�����=����)
 +msgip - ��������� � ������� �� �� (�����=����)
 +msgname - ��������� � ������� �� ���� (�����=����)
 +rules - �������
 +faq - ����
 +myip - ���������� ���� ��
 +myinfo - ���������� ���� ����
 !GetCurTime - ����� �� ����
 !GetCurDate - ���� �� ����
 !AntiSpam - �������� ������� �������� (������������� ��� ������� �����)


���� ������� ��������� � ��������� ������ � ����� � �� - Frol ��� BlackDragon (e-mail - frolvladv@pochta.ru, ilblackdragon@gmail.com)