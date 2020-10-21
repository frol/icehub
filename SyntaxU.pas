unit SyntaxU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Add, Registry, ScktComp, RichEdit, DCPockets;

type
    TStyle = record
      Color: TColor;
      Styles: TFontStyles;
    end;

    TSkobki = record
      First, Last: String;
      Comment: Boolean;
      Style: TStyle;
      Stat: Boolean;
    end;

    TRezerved = record
      S: String;
      Style: TStyle;
    end;

procedure Syntax(RE: TRichEdit; Rez: array of TRezerved; Sko: array of TSkobki; TextColor: TColor; TextStyle: TFontStyles);
procedure EaseSyntax(RE: TRichEdit; Sko: array of TSkobki; TextColor: TColor; TextStyle: TFontStyles; S: String);
function Parse(S: String): String;

implementation

Const
    Rus: Array [1..32, 1..2] of Char = (('à', 'À'),('á', 'Á'),('â', 'Â'),('ã', 'Ã'),('ä', 'Ä'),('å', 'Å'),('¸', '¨'),('æ', 'Æ'),('ç', 'Ç'),('è', 'È'),('ê', 'Ê'),('ë', 'Ë'),('ì', 'Ì'),('í', 'Í'),('î', 'Î'),('ï', 'Ï'),('ð', 'Ð'),
    ('ñ', 'Ñ'),('ò', 'Ò'),('ó', 'Ó'),('ô', 'Ô'),('õ', 'Õ'),('ö', 'Ö'),('÷', '×'),('ø', 'Ø'),('ù', 'Ù'),('ü', 'Ü'),('ú', 'Ú'),('û', 'Û'),('ý', 'Ý'),('þ', 'Þ'),('ÿ', 'ß'));

Function RUpCase(Ch: Char): Char;

var
  I: Integer;

Begin
 Result:=UpCase(Ch);
 if Ch=Result then
  for I := 1 to High(Rus) do
   if Ch=Rus[I, 1] then
   Begin
    Result:=Rus[I, 2];
    Break;
   end;
end;

Function RLowCase(Ch: Char): Char;

var
  I: Integer;
  T: String;

Begin
 T:=LowerCase(Ch);
 Result:=T[1];
 if Ch=Result then
  for I := 1 to High(Rus) do
   if Ch=Rus[I, 2] then
   Begin
    Result:=Rus[I, 1];
    Break;
   end;
end;

Function RUpperCase(S: String): String;

Var I: LongInt;
    T: String;

Begin
 T:='';
 For I:=1 To Length(S) Do
  T:=T+RUpCase(S[I]);
 RUpperCase:=T;
End;

Function RLowerCase(S: String): String;

Var I: LongInt;
    T: String;

Begin
 T:='';
 For I:=1 To Length(S) Do
  T:=T+RLowCase(S[I]);
 RLowerCase:=T;
End;

Function Letter(Ch: Char): Boolean;

Begin
 If (RUpCase(Ch)=Ch)And(RLowCase(Ch)=Ch) then
  Letter:=False
 Else
  Letter:=True;
End;

Function PosAfter(Sub, S: String; num: LongInt): LongInt;

Begin
 delete(S, 1, num);
 if pos(Sub, S)<>0 then
  PosAfter:=num+Pos(Sub, S)
 Else
  PosAfter:=0;
End;

type
  TTextRange = record
    chrg: TCharRange;
    lpstrText: PAnsiChar;
  end;

procedure Syntax(RE: TRichEdit; Rez: array of TRezerved; Sko: array of TSkobki; TextColor: TColor; TextStyle: TFontStyles);

var Q, I, J, ST: LongInt;
    B: Boolean;
    Te: Array of Array [1..3] of LongInt;
    Sk: Array of Array of LongInt;
    S, T: String;
    Po: TPoint;
    TextRange: TTextRange;

Function Find(Num: LongInt): LongInt;

var I: LongInt;

begin
  for I:=Num-1 DownTo 1 Do
    if Te[I, 2]<>0 then
    begin
      Find:=Te[I, 2];
      Exit;
    end;
  Find:=1;
end;

Function InBrackets(Num: LongInt): Boolean;

var I: LongInt;

begin
  Result:=False;
  if Sko[Num].Comment then
    Num:=-1;
  for I:=0 to High(Sk) do
  begin
    if (Sk[I, 0]<>0)And(Num<>I) then
    begin
      Result:=True;
      Break;
    end;
  end;
end;

Function Comment: Boolean;

var I: LongInt;

begin
  Comment:=False;
  for I := 0 to High(Sko) do
    if (Sko[I].Comment)And(Sk[I, 0]>0) then
    begin
      Comment:=True;
      Break;
    end;
end;

procedure DelFromAll(Num: LongInt);

var I, J: LongInt;

begin
  I:=0;
  While I<=High(Sk) do
  begin
    J:=Sk[I, 0];
    while J>= 1 do
    begin
      if Sk[I, J]>Num then
      begin
        Dec(Sk[I, 0]);
        SetLength(Sk[I], High(Sk[I]));
      end else
        Break;
      Dec(J);
    end;
    Inc(I);
  end;
end;

begin
//  Ti:=Time;
  Po:=Re.CaretPos;
  S:=Re.Text;
  SetLength(Sk, Length(Sko));
  for I := 0 to High(Sk) do
    SetLength(Sk[I], 1);
  SetLength(Te, 0);
  Q:=-1;
  I:=1;
  S:=RUpperCase(S);
  while I<=Length(S) do
  begin
    B:=False;
    for J:=0 to High(Rez) do
    begin
      T:=Copy(S, I, length(Rez[J].S));
      if (T=Rez[J].S)
         And(Not Letter(S[I-1]))And(Not Letter(S[I+Length(Rez[J].S)]))And(not InBrackets(-1)) then
      begin
        inc(Q);
        SetLength(Te, High(Te)+2);
        Te[Q, 1]:=I-1;
        inc(I, Length(Rez[J].S)-1);
        Te[Q, 2]:=I;
        Te[Q, 3]:=J;
        B:=True;
        Break;
      end;
    end;

    if not B then
    begin
      for J:=0 to High(Sko) do
      begin
        T:=Copy(S, I, length(Sko[J].Last));
        if (T=Sko[J].Last)And(Sk[J, 0]>0)And((not Comment){And((not InBrackets(J))}Or(Sko[J].Comment)) then
        begin
          Dec(Sk[J, 0]);
          Te[Sk[J, Sk[J, 0]+1], 2]:=I-1;
          DelFromAll(Sk[J, Sk[J, 0]+1]);
          B:=True;
          SetLength(Sk[J], High(Sk[J]));
          inc(I, Length(Sko[J].Last)-1);
          Break;
        end;
      end;
    end;

    if Not B then
    begin
      for J:=0 to High(Sko) do
      begin
        T:=Copy(S, I, length(Sko[J].First));
        if (T=Sko[J].First)And(Not Comment){And(Not InBrackets(J))} then
        begin
          Inc(Sk[J, 0]);
          inc(Q);
          SetLength(Sk[J], High(Sk[J])+2);
          SetLength(Te, High(Te)+2);
          Sk[J, Sk[J, 0]]:=Q;
          Te[Q, 1]:=I+Length(Sko[J].First)-1;
          Te[Q, 3]:=J+Length(Rez);
          Inc(I, Length(Sko[J].First)-1);
          Break;
        end;
      end;
    end;

    inc(I);
  end;
  RE.Lines.BeginUpdate;
  RE.Perform(EM_SETSEL, 0, Length(RE.Text));
  RE.SelAttributes.Color:=TextColor;
  RE.SelAttributes.Style:=TextStyle;
  for I:=0 to Q do
  begin
    if Te[I, 2]<>0 then
    begin
//      St:=Find(I);
      RE.Perform(EM_SETSEL, Te[I, 1], Te[I, 2]);
      if Te[I, 3]>=Length(Rez) then
      begin
        RE.SelAttributes.Color:=Sko[Te[I, 3]-Length(Rez)].Style.Color;
        RE.SelAttributes.Style:=Sko[Te[I, 3]-Length(Rez)].Style.Styles;
      end else
      begin
        RE.SelAttributes.Color:=Rez[Te[I, 3]].Style.Color;
        RE.SelAttributes.Style:=Rez[Te[I, 3]].Style.Styles;
      end;
    end;
  end;
  RE.Lines.EndUpdate;
  Re.CaretPos:=Po;
end;

Function GetWord(RE: TRichEdit; var Be, Len: LongInt): String;

var I, N: LongInt;

begin
  N:=0;
  for I:=1 to RE.CaretPos.Y do
    Inc(N, Length(RE.Lines[I])+2);
  for I:=N downto 1 do
  begin
    if Not Letter(RE.Text[I]) then
    begin
      Be:=I;
      Break;
    end;
  end;
  for I:=N to Length(RE.Text) do
  begin
    if Not Letter(RE.Text[I]) then
    begin
      Len:=I-Be;
      Break;
    end;
  end;
end;



Function CheckWord(RE: TRichEdit; Rez: array of TRezerved): Boolean;

var T: String;
    J: LongInt;

begin
  T:=RUpperCase(RE.Text);
  for J:=0 to High(Rez) do
  begin
    if (T=Rez[J].S) then
    begin
{      RE.Perform(EM_SETSEL, 0, Length(RE.Text));
      RE.SelAttributes.Color:=Rez[J].Style.Color;
      RE.SelAttributes.Style:=Rez[J].Style.Styles;}
      Break;
    end;
  end;
end;


procedure EaseSyntax(RE: TRichEdit; Sko: array of TSkobki; TextColor: TColor; TextStyle: TFontStyles; S: String);

var I, J, C, Con: Longint;
    T: String;
    B: Boolean;
    Mark: array of record
      S, E: LongInt;
      Num: LongInt;
    end;

function FindLast(N: LongInt): LongInt;

var I, J: LongInt;

begin
  FindLast:=-1;
  for I := High(Mark) downto 0 do
  begin
    if Mark[I].Num=N then
    begin
      FindLast:=I;
      Break;
    end;
  end;
end;

begin
  I:=1;
  while I<=Length(S) do
  begin
    for J:=0 to High(Sko) do
    begin
      B:=False;
      T:=Copy(S, I, length(Sko[J].First));
      if (RUpperCase(T)=Sko[J].First) then
      begin
        SetLength(Mark, High(Mark)+2);
        Mark[High(Mark)].S:=I;
        Mark[High(Mark)].Num:=J;
        delete(S, I, length(Sko[J].First));
        dec(I);
        B:=True;
        Break;
      end;
    end;
    if Not B then
    begin
      for J:=0 to High(Sko) do
      begin
        T:=Copy(S, I, length(Sko[J].Last));
        if (RUpperCase(T)=Sko[J].Last) then
        begin
          C:=FindLast(J);
          if C<>-1 then
          begin
            Mark[C].E:=I;
            delete(S, I, length(Sko[J].Last));
            dec(I);
          end;
          Break;
        end;
      end;
    end;
    inc(I);
  end;
  Con:=Length(S);
{  if High(Mark)>-1 then
  begin
    Con:=0;
    for I := 0 to RE.Lines.Count - 1 do
    begin
      inc(Con, Length(RE.Lines.Strings[I]));
      inc(Con, 2);
    end;
  end;}
  RE.Lines.Add(S);
  for I := 0 to High(Mark) do
  begin
{    if not Mark[I].Visit then
    begin
      Test(Mark[I].S, Mark[I].E, Sko[Mark[I].Num].Style);
      for J := 0 to High(Mas) do
      begin
}
    RE.Perform(EM_SETSEL, Length(RE.Lines.Text)-Con+Mark[I].S-3, Length(RE.Lines.Text)-Con+Mark[I].E-3);
    if Sko[Mark[I].Num].Stat then
      RE.SelAttributes.Color:=Sko[Mark[I].Num].Style.Color
    else
      RE.SelAttributes.Style:=Sko[Mark[I].Num].Style.Styles;
//      end;
//    end;
  end;
end;

function Parse(S: String): String;

var T: String;

begin
  if S[1]='<' then
  begin
    T:=copy(S, 2, pos('>', S)-2);
    if IsOP(T)=-1 then
    begin
      Insert('[/blue][/b]', S, pos('>', S));
      Insert('[b][blue]', S, 2);
    end
    else
    begin
      Insert('[/red][/b]', S, pos('>', S));
      Insert('[b][red]', S, 2);
    end;
  end;
  Parse:=S;
end;

end.
