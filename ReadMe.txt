Начнём с конфигурационных файлов =)

Settings\config.ini : ОСНОВНОЙ конфигурационный файл (много полей - не буду обяснять, в принципи при знании начального уровня английского языка и обладания фоть какойто логикой - можно всё понять!!!)

Settings\OpList.txt :
    синтаксис - <Ник>;#<Права (в цифрах) от 0 до 10>
Settings\RegUsersList.txt :
    синтаксис - <Ник>;#<Пароль>
Settings\BanIP.txt :
    синтаксис - <IP>;#<дата>;#<время> (оч не советую добавлять в бан таким образом!!!)
Settings\BanName.txt :
    синтаксис - <Ник>;#<дата>;#<время> (оч не советую добавлять в бан таким образом!!!)
Settings\MsgIP.txt :
    синтаксис - <IP>;#<дата>;#<время> (оч не советую добавлять в бан таким образом!!!)
Settings\MsgName.txt :
    синтаксис - <Ник>;#<дата>;#<время> (оч не советую добавлять в бан таким образом!!!)
Settings\FAQ.txt : содержит факу

Settings\Hello.txt : содержит приветственное сообщение (можно реализовывать через скрипты)

Settings\Menu.txt : содержит менюшку хаба (можно реализовывать через скрипты)
    синтаксис - $UserCommand 1(0 - разделитель, 1 - комманда) 2(1 - на закладке, 2 - на юзерах, 3 - везде) Меню Хаба\Регистрация\Удалить зарегистрированного пользоватля (путь) $<%[mynick]> !DelReg %[nick]&#124; (после $ - то что пошлётся на сервер)|

Settings\CoolNames.txt : сервер поддерживает функцию переименования людей (пока работает норм но скачивать с этих людей нельзя)
    синтаксис - <изначальный ник>|<на что поменять>

Script\files.cfg : в начале - колво скриптов, потом пути (через ентер)

Всё остальное в папке Script - шо хатите


Доступные команды скритов:

 SendToAll(MyNick, Data) - послать всм от ника 
 SendToAll(Data) - полсать всем
 SendToNick(ToNick, MyNick, Data) - послать ToNickу от MyNick 
 SendPMToAll(Nick, Data) - всем в личку от ника
 SendPMToNick(ToNick, MyNick, Data) - послать личку ToNickу от MyNick 
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

Доступные команды протокола : все мне известные

Доступные команды Юзеров и Опов :
 !help - выдаёт помощь (права=юзер)
 !reg - зарегить ник (права=юзер)
 !DelReg - удалить зарегиный ник (права=юзер - удаляет только ся; 5 - удаляет любую регистрацию)
 +ReKlAmA <текст> - посылает всем в личку текст (права=5)
 +AddOp - добавляет Опа (права=10)
 -DelOp - удаляет Опа (права=10)
 +BanIP - бан по ИП (права=9)
 +BanName - бан по Нику (права=9)
 -BanIP - разбанить по ИП (права=9)
 -BanName - разбанить по Нику (права=9)
 !BannedUsers - показать всех забаненых (права=юзер)
 +msgip - сообщение в оффлайн по ИП (права=юзер)
 +msgname - сообщение в оффлайн по Нику (права=юзер)
 +rules - правила
 +faq - факу
 +myip - показывает твой ИП
 +myinfo - показывает твой инфо
 !GetCurTime - время на ХАБЕ
 !GetCurDate - дата на ХАБЕ
 !AntiSpam - включает функцию антиспам (индивидуально для каждого юзера)


Если чтолибо нуждается в доработке пишите в личку в ДС - Frol или BlackDragon (e-mail - frolvladv@pochta.ru, ilblackdragon@gmail.com)