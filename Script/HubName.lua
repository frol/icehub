k=0;
s="";

function OnTimer()
 k=k+1;
 if (k>string.len(s)) then
  k=1;
 end;
 local w = string.sub(s, 1, k);
-- SendToAll(w);
 SetHubTopic(w);
end;

function Main()
 s=GetHubTopic(); 
 SetTimer(500);
 StartTimer();
end;

function OnClose()
 SetHubTopic(s);
end;


