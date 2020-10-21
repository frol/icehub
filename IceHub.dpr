
program IceHub;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  DCPockets in 'DCPockets.pas',
  LuaUnit in 'LuaUnit.pas',
  About in 'About.pas' {AboutBox},
  Options in 'Options.pas' {OptionsForm},
  Add in 'Add.pas' {AddForm},
  TrayIcon in 'TrayIcon.pas',
  SyntaxU in 'SyntaxU.pas';

{$R *.res}

Var I: Integer;

begin
  try
   Application.Initialize;
   Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.CreateForm(TAddForm, AddForm);
  Application.Run;
  except
   for I:= 0 to High(Main.Servers) do
    Main.Servers[I].Open;
  end;
end.
