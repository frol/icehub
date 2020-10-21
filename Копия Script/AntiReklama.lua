--[[

	Версия для LUA 5.0.2 / 5.1.1 by NRJ

	Таблица trigs взята из одноименного скрипта перевода romiros'a
	Поддержка русских букв взята из NOYELL script от NoNick'a

]]--

----------------------------------------------- Конфигурация -----------------------------------------------
------------------------------------------------------------------------------------------------------------

BotName = "<Анти>"		-- имя бота 
BotDesc = "Антиреклама"	-- описание бота
BotEmail = "sprosi@u.menya"	-- email бота

ban = {
 ["dchub://"] = {" РЕКЛАМА ХАБОВ ЗАПРЕЩЕНА"},
}

Rus={["А"]="а",["Б"]="б",["В"]="в",["Г"]="г",["Д"]="д",["Е"]="е",["Ё"]="ё",["Ж"]="ж",["З"]="з",["И"]="и",["Й"]="й",
["К"]="к",["Л"]="л",["М"]="м",["Н"]="н",["О"]="о",["П"]="п",["Р"]="р",["С"]="с",["Т"]="т",["У"]="у",["Ф"]="ф",["Х"]
="х",["Ц"]="ц",["Ч"]="ч",["Ш"]="ш",["Щ"]="щ",["Ъ"]="ъ",["Ы"]="ы",["Ь"]="ь",["Э"]="э",["Ю"]="ю",["Я"]="я"}

function Main()
 TableMaxSize = table.getn;
 frmHub:RegBot(BotName, 1, BotDesc, BotEmail)
 return 0;
end

 
function DataArrival(User, data)
        if data[1]=='<' then
	  	s,e,mess = string.find(data, "^%b<>%s(.*)$")
		for key in pairs(ban) do
			data=d;
			for b,s in pairs(Rus) do
 				data=string.gsub(data , b, Rus[b]);
				if( string.find(data, key) ) then
					BlockSend();
					Break();
					User:SendData(BotName..ban[key]);
					User:Kick(BotName, ban[key]);
					return 1;
				end
			end
			mess=d;	
			if( string.find( string.lower(mess), key) ) then
				BlockSend();
				Break();
				User:SendData(BotName..ban[key]);
				User:Kick(BotName, ban[key]);
				return 1
			end
		end
	end
end


