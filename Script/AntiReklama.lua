--[[

	������ ��� LUA 5.0.2 / 5.1.1 by NRJ

	������� trigs ����� �� ������������ ������� �������� romiros'a
	��������� ������� ���� ����� �� NOYELL script �� NoNick'a

]]--

----------------------------------------------- ������������ -----------------------------------------------
------------------------------------------------------------------------------------------------------------

BotName = "<����>"		-- ��� ���� 
BotDesc = "�����������"	-- �������� ����
BotEmail = "sprosi@u.menya"	-- email ����

ban = {
 ["dchub://"] = {" ������� ����� ���������"},
}

Rus={["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",
["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]
="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�",["�"]="�"}

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


