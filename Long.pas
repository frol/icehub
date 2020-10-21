Unit Long;

interface

Uses SysUtils;

 var mmin,msum:boolean;
 procedure sum(s1,s2:string;var sres:string);
 procedure min(s1,s2:string;var mres:string);
 procedure umn(s1:string;ch:char;var ures:string);
 procedure proizv(s1,s2:string;var pres:string);
 function sravn(s1,s2:string):byte;
 procedure divlong(s1,s2:string;var dres:string);
 procedure modlong(s1,s2:string;var mres:string);
 procedure power(s1,s2:string;var mres:string);
 procedure fact(s1:string; var ans:string);
 function error(s1:string):byte;
implementation

 procedure sum(s1,s2:string;var sres:string);
 var a,b,c,d,i:byte;
     l1,l2,code:integer;
     r:string;
     label w1;
 begin
  If Length(S1)=0 then
   S1:='0';
  If Length(S2)=0 then
   S2:='0';
  Sres:='0';
  if (s1[1]='-')and(s2[1]<>'-') then begin
     delete(s1,1,1);
     if sravn(s1,s2)=1 then msum:=true;
     min(s1,s2,sres);
     goto w1;
  end;
  if (s2[1]='-')and(s1[1]<>'-') then begin
     delete(s2,1,1);
     min(s1,s2,sres);
     msum:=true;
     goto w1;
  end;
  if (s1[1]='-')and(s2[1]='-') then begin
     delete(s1,1,1);
     delete(s2,1,1);
     msum:=true;
  end;
  sres:='';
  d:=0;
  r:='';
  l1:=length(s1);
  l2:=length(s2);
  if l1>l2 then begin
     for i:=1 to l1-l2 do s2:='0'+s2;
  end else begin
     for i:=1 to l2-l1 do s1:='0'+s1;
  end;
  for i:=length(s1) downto 1 do begin
     val(s1[i],a,code);
     val(s2[i],b,code);
     c:=(a+b+d) mod 10;
     d:=(a+b+d) div 10;
     str (c,r);
     sres:=r+sres;
  end;
  if d<>0 then sres:='1'+sres;
  w1:
  if msum=true then sres:='-'+sres;
 end;

 procedure min(s1,s2:string;var mres:string);
 var a,b,c,d,i:byte;
     l1,l2,code:integer;
     r,x:string;
     label w1;
 begin
  If Length(S1)=0 then
   S1:='0';
  If Length(S2)=0 then
   S2:='0';
  Mres:='0';
  if (s1[1]='-')and(s2[1]<>'-') then begin
     delete(s1,1,1);
     sum(s1,s2,mres);
     mmin:=true;
     goto w1;
  end;
  if (s2[1]='-')and(s1[1]<>'-') then begin
     delete(s2,1,1);
     sum(s1,s2,mres);
     goto w1;
  end;
  if (s1[1]='-')and(s2[1]='-') then begin
     delete(s1,1,1);
     delete(s2,1,1);
     mmin:=true;
  end;
  if sravn(s1,s2)=2 then begin
     mmin:=true;
     x:=s1; s1:=s2; s2:=x;
  end;
  mres:='';
  d:=0;
  x:='';
  l1:=length(s1);
  l2:=length(s2);
  if l1>l2 then begin
     for i:=1 to l1-l2 do s2:='0'+s2;
  end else begin
     for i:=1 to l2-l1 do s1:='0'+s1;
  end;
  for i:=1 to length(s1)do x:=x+chr(ord('9')-ord(s1[i])+ord('0'));
  sum(s2,x,s2);
  for i:=1 to length(s1) do
  		mres:=mres+chr(ord('9')-ord(s2[i])+ord('0'));
  if (mres[1]='0')and(length(mres)>1) then delete(mres,1,1);
  w1:
  if mmin=true then mres:='-'+mres;
 end;


 procedure umn(s1:string;ch:char;var ures:string);
 var a,b,c,d,i:byte;
     l1,l2,code:integer;
     r:string;
 begin
  If Length(S1)=0 then
   S1:='0';
  If ch='' then
   ch:='0';
  ures:='';
  d:=0;
  r:='';
  l1:=length(s1);
  val(ch,b,code);
  for i:=length(s1) downto 1 do begin
     val(s1[i],a,code);
     c:=(a*b+d) mod 10;
     d:=(a*b+d) div 10;
     str (c,r);
     ures:=r+ures;
  end;
  if d<>0 then ures:=chr(d+ord('0'))+ures;
  if b=0 then ures:='0';
 end;

 procedure proizv(s1,s2:string;var pres:string);
 var k,i:byte;
     r:string;
 begin
 If Length(S1)=0 then
  S1:='0';
 If Length(S2)=0 then
  S2:='0';
 pres:='0';
 for i:=length (s2) downto 1 do begin
  r:='';
  umn(s1,s2[i],r);
  for k:=1 to (length(s2)-i) do r:=r+'0';
  sum(pres,r,pres);
 end;
 end;

 function sravn(s1,s2:string):byte;
 var k:integer;
 begin
 if length(s1)>length(s2) then sravn:=1;
 if length(s1)<length(s2) then sravn:=2;
 k:=0;
 if length(s1)=length(s2) then begin
    repeat
    inc(k);
    until (ord(s1[k])-ord(s2[k])<>0)or(k=length(s1));
    if (k=length(s1))and(k=length(s2)) then sravn:=0;
    if ord(s1[k])>ord(s2[k]) then sravn:=1;
    if ord(s1[k])<ord(s2[k]) then sravn:=2;
 end;
 end;
(*
 procedure divlong(s1,s2:string;var dres:string);
 var d,s,a1,q1,q2:string;
     k,i,t:integer;
{     f:boolean;}
     label w1;
 begin
 dres:='';
 q1:=s1;
 q2:=s2;
{ 10001121456
 1024}
 if sravn(s1,s2)=2 then dres:='0';
 if sravn(s1,s2)=0 then dres:='1';
 if sravn(s1,s2)=1 then begin

 End;
 End;*)

 procedure divlong(s1,s2:string;var dres:string);
 var d,s,a1,q1,q2:string;
     k,i,t:integer;
     label w1;
 begin
 If Length(S1)=0 then
  S1:='0';
 If Length(S2)=0 then
  S2:='0';
 dres:='0';
 q1:=s1;
 q2:=s2;
 if sravn(s1,s2)=2 then dres:='0';
 if sravn(s1,s2)=0 then dres:='1';
 if sravn(s1,s2)=1 then begin
 repeat
       a1:=copy(s1,1,length(s2));
       if sravn(s2,a1)=1 then
          if length(a1)<length(s1) then
             a1:=copy(s1,1,length(s2)+1)
          else
             goto w1;
       k:=0;
       repeat
             inc(k);
             proizv(s2,IntToStr(K),d);
       until (sravn(a1,d)=2)or(sravn(a1,d)=0);
       if sravn(a1,d)=2 then begin
		  dec(k);
		  min(d,s2,d);
		 end;
       s:=chr(k+ord('0'));
       for k:=1 to (length(s1)-length(a1)) do begin d:=d+'0'; s:=s+'0'; end;
       min(s1,d,s1);
//       dres:=dres+s;
       sum(dres, s, dres);
       t:=0;
       for k:=1 to length(s1) do if s1[k]='0' then inc(t);
       if t=length(s1) then s1:='0';
       if s1 <> '0' then
       begin
        while (s1[1] = '0') and (length(s1) > 1) do
         delete(s1, 1, 1);
       end;
 until (sravn(s1,s2)=2)or(sravn(s1,s2)=0)or(s1='0');
 proizv(q2,dres,s2);
{ if (length(q1)>length(q2))and(sravn(q1,s2)=1) then dres:=dres+'0';
} end;
 w1:
 end;

 procedure modlong(s1,s2:string;var mres:string);
 var q1,q:string;
     i:integer;
 begin
 If Length(S1)=0 then
  S1:='0';
 If Length(S2)=0 then
  S2:='0';
 Mres:='0';
 q1:=s1;
 divlong(s1,s2,q);
 if q<>'0' then begin
  proizv(s2,q,q);
  min(q1,q,mres);
{  if length(mres)>1 then
     for i:=1 to length(mres)-1 do
         if mres[i]='0' then delete(mres,1,1);}
 end else mres:=q;
 end;

 procedure power(s1,s2:string;var mres:string);
 var i,f:longint;
     a:string;
     code:integer;
 begin
  If Length(S1)=0 then
   S1:='0';
  If Length(S2)=0 then
   S2:='0';
  Mres:='0';
  a:='1';
  val(s2,f,code);
  for i:=1 to f do
   proizv(a,s1,a);
  mres:=a;
 end;

 procedure fact(s1:string; var ans:string);
 var i,fa:longint;
 	  code:integer;
     a,j:string;
 begin
  If Length(S1)=0 then
   S1:='0';
  a:='1';
  val(s1,fa,code);
  for i:=2 to fa do begin
   str(i,j);
   proizv(a,j,a);
  end;
  ans:=a;
 end;


 function error(s1:string):byte;
 begin
 writeln('…Õ  …Õª  …Õª  …Õª  …Õª');
 writeln('ÃÕ  ÃÕº  ÃÕº  ∫ ∫  ÃÕº');
 writeln('»Õ  – –  – –  »Õº  – –');
 end;

begin
end.

















