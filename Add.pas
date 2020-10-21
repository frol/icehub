unit Add;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAddForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddForm: TAddForm;
  Ed1, Ed2: String;

implementation

{$R *.dfm}

Uses Options;

procedure TAddForm.Button1Click(Sender: TObject);
begin
 Ed1:='';
 Ed2:='';
 AddForm.Close;
end;

procedure TAddForm.Button2Click(Sender: TObject);
begin
 Ed1:=Edit1.Text;
 Ed2:=Edit2.Text;
 AddForm.Close;
end;

procedure TAddForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  Edit2.SetFocus;
end;

procedure TAddForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
  Button2Click(Nil);
end;

end.
