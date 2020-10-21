BotName="<Commander>";
BotDesc = "Билл Гейтс умер"
BotEmail = "killbill@microsoft.com"
max=0
min=0

function UserMenu(User) -- Меню обычного пользователя
 SendToNick(User.sName, "$UserCommand 1 2 Меню Хаба\\Регистрация\\Регистрация$<%[mynick]> !reg %[nick];#%[line:Пароль]&#124;|"..
"$UserCommand 1 2 Меню Хаба\\Регистрация\\Удалить зарегистрированного пользоватля$<%[mynick]> !DelReg %[nick]&#124;|"..
"$UserCommand 1 1 Меню Хаба\\Регистрация\\Регистрация $<%[mynick]> !reg %[line:Ник];#%[line:Пароль]&#124;|"..
"$UserCommand 1 1 Меню Хаба\\Регистрация\\Удалить зарегистрированного пользоватля$<%[mynick]> !DelReg %[line:Ник]&#124;|"..
"$UserCommand 1 3 Меню Хаба\\Просмотр забаненых пользователей$<%[mynick]> !BannedUsers&#124;|"..
"$UserCommand 1 3 Меню Хаба\\Правила хаба$<%[mynick]> +rules&#124;|"..
"$UserCommand 1 3 Меню Хаба\\Вопрос-ответ FAQ $<%[mynick]> +faq&#124;|"..
"$UserCommand 1 2 Меню Хаба\\Сообщение в оффлайн по Нику$<%[mynick]> +msgname %[nick];#%[mynick];# %[line:Сообщение]&#124;|"..
"$UserCommand 1 1 Меню Хаба\\Сообщение в оффлайн по Нику$<%[mynick]> +msgname %[line:Получатель (ник)];#%[mynick];# %[line:Сообщение]&#124;|"..
"$UserCommand 1 2 Меню Хаба\\Сообщение в оффлайн по ИПшнику$<%[mynick]> +msgip %[line:Получатель (IP)];#%[mynick];# %[line:Сообщение]&#124;|"..
"$UserCommand 1 1 Меню Хаба\\Сообщение в оффлайн по ИПшнику$<%[mynick]> +msgip %[line:Получатель (IP)];#%[mynick];# %[line:Сообщение]&#124;|"..
"$UserCommand 1 3 Меню Хаба\\Информация\\Мой IP$<%[mynick]> +myip&#124;|"..
"$UserCommand 1 3 Меню Хаба\\Информация\\Мое Info$<%[mynick]> +myinfo&#124;|", "");
end;

function OpMenu(User) -- Меню Админа
 SendToNick(User.sName, "$UserCommand 1 2 Меню Операторов\\Кикнуть $$Kick %[nick]&#124;|"..
"$UserCommand 1 2 Меню Операторов\\Забанить по Нику$<%[mynick]> +BanName %[nick];#%[line:До когда]&#124;|"..
"$UserCommand 1 2 Меню Операторов\\Забанить по ИПшнику$<%[mynick]> +BanIP %[line:ИП];#%[line:До когда]&#124;|"..
"$UserCommand 1 2 Меню Операторов\\Разбанить по Нику$<%[mynick]> -BanName %[nick]&#124;|"..
"$UserCommand 1 2 Меню Операторов\\Разбанить по ИПшнику$<%[mynick]> -BanIP %[line:ИП]&#124;|"..
"$UserCommand 1 2 Меню Операторов\\Добавить ОПа$<%[mynick]> +AddOp %[nick];#%[line:Права]&#124;|"..
"$UserCommand 1 2 Меню Операторов\\Удалить ОПа$<%[mynick]> -DelOp %[nick]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Кикнуть$$Kick %[line:Ник]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Забанить по Нику$<%[mynick]> +BanName %[line:Ник];#%[line:До когда]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Забанить по ИПшнику$<%[mynick]> +BanIP %[line:ИП];#%[line:До когда]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Разбанить по Нику$<%[mynick]> -BanName %[line:Ник]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Разбанить по ИПшнику$<%[mynick]> -BanIP %[line:ИП]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Добавить ОПа$<%[mynick]> +AddOp %[line:Ник];#%[line:Права]&#124;|"..
"$UserCommand 1 1 Меню Операторов\\Удалить ОПа$<%[mynick]> -DelOp %[line:Ник]&#124;|"..
"$UserCommand 1 3 Меню Операторов\\Реклама$<%[mynick]> +ReKlAmA  %[line:Текст]&#124;|", "");

end;

function Maxim(s)
 fr = string.find(s,">")+1;
 t=string.sub(s, 1, fr-1);
 for i=fr, string.len(s) do
  ch=UpCase(string.sub(s, i, i));
  t=t..ch;
 end;
 return t;
end;

function Minim(s)
 fr = string.find(s,">")+1;
 t=string.sub(s, 1, fr-1);
 for i=fr, string.len(s) do
  ch=LowCase(string.sub(s, i, i));
  t=t..ch;
 end;
 return t;
end;

function DataArrival(User, Data)
-- Обработчик команд из ДС
 if string.sub(Data,1,1)=="<" then
  s = string.find(Data,">");
  IsCom=0;
  if (s>0) then
   cmd=string.sub(Data, s+2, string.len(Data));
   if (cmd=="!online") then
    User:SendData(BotName.." Хаб работает "..GetUpTime());
    BlockSend();
    IsCom=1;
   end;
 
   if (cmd=="+maximaze") then
    SendToAll(BotName.." Пользователь "..User.sName.." включил MAXIMAZE!!!", "");
    max=1;
    BlockSend();
    IsCom=1;
   end;
   if (cmd=="-maximaze") then
    SendToAll(BotName.." Пользователь "..User.sName.." отключил MAXIMAZE!!!", "");
    max=0;
    BlockSend();
    IsCom=1;
   end; 

   if (cmd=="+minimaze") then
    SendToAll(BotName.." Пользователь "..User.sName.." включил MINIMAZE!!!", "");
    min=1;
    BlockSend();
    IsCom=1;
   end;
   if (cmd=="-minimaze") then
    SendToAll(BotName.." Пользователь "..User.sName.." отключил MINIMAZE!!!", "");
    min=0;
    BlockSend();
    IsCom=1;
   end; 

   if IsCom==0 then
    if (max==1)and(IsCom==0) then
     t=Maxim(Data);
     SendToAll(t, "");
     BlockSend();
     IsCom=1;
    end;
    if (min==1)and(IsCom==0) then
     t=Minim(Data);
     SendToAll(t, "");
     BlockSend();
     IsCom=1;
    end;
   end;
  end;
 end;
end;

function NewUserConnected(User)
 UserMenu(User);
end;

function OpConnected(User)
 UserMenu(User);
 OpMenu(User);
end;

function Main()
 RegBot(BotName, 0, BotDesc, BotEmail);
end;

