--Calculator by Phatty
--v1.21
--Added Invalid usage message
--useage: sum <nr> <by> <nr> = example : sum 1 + 1


Bot = "Calculator"

function DataArrival(user,data)
	if strsub(data, 1, 1) == "<" then
		data=strsub(data,1,strlen(data)-1)
		s,e,cmd = strfind(data,"%b<>%s+(%S+)")

		if cmd == "sum" then
			s,e,cmd,nr1,what,nr2 = strfind(data,"%b<>%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")

			if nr2  == nil then
				user:SendData(Bot, "Not a valid usage please try again ;)")
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
				user:SendData(Bot,"The sum: "..nr1..what..nr2.." = "..sum)
			return 1
			end
		end
	end
end
