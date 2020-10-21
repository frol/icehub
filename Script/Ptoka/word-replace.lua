-- word replace script by plop 
-- Troubadour got permission to use it in order with guardian package.

---- filter what? use 1 to enable, nil to disable the filter.
FilterPm = 1
FilterMain = 1

---- the words to be replaced and by what.
tBadWords = {
   ["fuck"]= "havin sex",
   ["shit"] = "bleeeeeeeeh",
   ["m8"] = "mate",
   ["g/f"] = "girlfriend",
   ["gf"] = "girlfriend",
   ["asshole"] = "(place where dirty stuff exits the body)",
   ["dick"] = "male saucage",
   ["cum"] = "body cream",
   ["fucker"] = "I love you",
   ["fuckers"] = "I love you guy's",
   ["fuckin'"] = "more dirty movements",
   ["fucking"] = "doing dirty",
   ["bastard"] = "naughty boy",
   ["hell"] = "mac donalds",
   ["whore"] = "angel",
   ["yw"] = "you're welcome",
   ["np"] = "no problem",
   ["q"] = "Question",
   ["thx"] = "thank you",
   ["laters"] = "see you later",
   ["coffee"] = "troubadour potion",
   ["beer"] = "tarot liquid"
}

tBadChar = {
   ["!"] = "",
   ["?"] = "",
   ["."] = "",
   [":"] =  "",
   ["\""] = "",
   ["'"] = "",
   ["*"] = "",
   ["("] = "",
   [")"] = "",
   ["="] = ""
}

function CheckLetter(letter)
   if tBadChar[letter] then
      store = store..letter
      return tBadChar[letter]
   else
      return letter
   end
end

function CheckWord(word)
   store = ""
   local word2 = gsub(word, "(%S)", function(letter) return CheckLetter(letter) end)
   if tBadWords[word2] then
      c = 1
      return tBadWords[word2]..store
   else
      return word
   end
end

function DataArrival(user, data) 
   c = nil
   if( strsub(data, 1, 1) == "<" ) then
      if FilterMain then
         local data = strlower(strsub(data,(strlen(user.sName)+4),strlen(data)-1))
         data=gsub(data , "(%S+)", function(word) return CheckWord(word) end)
         if c then
            local s,e, cmd = strfind(data, "%s*(%S+)")
            if cmd == "!me" then
               SendToAll("* "..user.sName.." "..strsub(data, 5, strlen(data)).."|")
               return 1
            else
               SendToAll(user.sName, data.."|")
               return 1
            end
         end
      end
   elseif(strsub(data, 1, 4) == "$To:") then
      if FilterPm then
         local data = strsub(data, 1, (strlen(data)-1))
         local s,e,whoto = strfind(data, "%S+%s*(%S+)")
         s,e,data = strfind(data, "$%b<>%s*(.*)$")
         data=gsub(data , "(%S+)", function(word) return CheckWord(word) end)
         if c then
            SendPmToNick(whoto, user.sName, data.."|")
            return 1
         end
      end
   end
end