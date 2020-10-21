--Calculator by Phatty
--v1.21
--Added Invalid usage message
--useage: sum <nr> <by> <nr> = example : sum 1 + 1


Bot = "Calculator"

function ChatArrival(user,data)
SendToAll("GG")
--    if string.sub(data, 1, 1) == "<" then
--		data=string.sub(data,1,string.len(data)-1)
SendToAll(data)
data="<LOL> "..data;
		s,e,cmd = string.find(data,"%b<>%s+(%S+)")
SendToAll("GG"..s)
SendToAll(s..' '..e..'  '..cmd);
		if cmd == "sum" then
			s,e,cmd,nr1,what,nr2 = string.find(data,"%b<>%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")

			if nr2  == nil then
				SendToAll(Bot, "Not a valid usage please try again ;)")
				return 1
			else
				if what == "+" then
					sum = nr1 + nr2
				elseif what == "-" then
					sum = nr1 - nr2
				elseif what == "x" then
					sum = nr1 * nr2
				elseif what == "/" then
					sum = nr1 / nr2
				end
				SendToAll(Bot,"The sum: "..nr1..what..nr2.." = "..sum)
			return 1
			end
		end
--	end
end
