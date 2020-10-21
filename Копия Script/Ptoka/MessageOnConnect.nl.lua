

--------- Random Op Msg On Entry ---------

function RandomEntryMsg(user)
	local randomSeed = random(7)
	if randomSeed == 1 then
		return "Beef van angst... "..user.sName.." stormt de hub binnen!"
	elseif randomSeed == 2 then
		return "Sorry  meneer... "..user.sName.." is er weer!!"
	elseif randomSeed == 3 then
		return user.sName.." verschijnt uit de duisternis ..."
	elseif randomSeed == 4 then
		return user.sName.." steekt zijn kop uit het zand ..."
	elseif randomSeed == 5 then
		return " Ahlan wa Sahlan"..user.sName.." "
	elseif randomSeed == 6 then
		return "De grote digerati "..user.sName.."! heeft zich aangemeld"
	elseif randomSeed == 7 then
		return "Hallo surfsmurf"..user.sName
	end
end

--------- Random VIPS Msg On Entry ---------

function RandomVIPMsgConnect(user)
	local randomSeed = random(3)
	if randomSeed == 1 then
		return user.sName.." slipt de deur uit."
	elseif randomSeed == 2 then
		return "Is het niet geweldig dat "..user.sName.." ons vereerd met zijn aanwezigheid?"
	elseif randomSeed == 3 then
		return  "“da's poot man dá” "..user.sName.." nog ff nls komt..."
	end
end

--------- Random Op Msg On Exit ---------

function RandomExitMsg(user)
	local randomSeed = random(7)
	if randomSeed == 1 then
		return user.sName.." knipt met zijn vingers en verdwijnt in een grote wolk..."
	elseif randomSeed == 2 then
		return user.sName.." verdwijnt al seen scheet in de wint..."
	elseif randomSeed == 3 then
		return user.sName.." springt op zijn harley en rijdt zo met 180 langs een flitspaal..."
	elseif randomSeed == 4 then
		return user.sName.." crtl-alt-delete zichzelf"
	elseif randomSeed == 5 then
		return "'Yeah baby yeah!', zegt "..user.sName.." en scheurt terug naar de efteling ..."
	elseif randomSeed == 6 then
		return user.sName.." gaat brontosaurussen vangen op de maan"
	elseif randomSeed == 7 then
		return user.sName.." says, ik ga een airco plaatsen in alaska"
	end
end

--------- Random VIPS Msg On Exit ---------

function RandomVIPMsgExit(user)
	local randomSeed = random(3)
	if randomSeed == 1 then
		return user.sName..", hoe durf je weg te gaan zonder mijn toestemming!"
	elseif randomSeed == 2 then
		return user.sName.." brandt af tot op zijn enkels."
	elseif randomSeed == 3 then
		return user.sName.." gaat zijn lintworm voeren"
	end
end
