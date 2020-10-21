Users = {};

function Main();
  Load();
end

function ChatArrival(text, curUser)
  
end

function Save()
  local handle = io.open("Users.txt", "w")
  for index = 1, pairs(Users) do
    handle:write(Users[index][1]..Users[index][2].."\r\n")
  end
  handle:close()
end

function Load()
  local handle = io.open("Users.txt", "r")
  if (handle) then
    local line = handle:read()
    while line do
      Users[pairs(Users)+1][1]=line;		
      line = handle:read()
    end
    handle:close()
  end
end