object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1057#1077#1088#1074#1077#1088' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103' IceHub'
  ClientHeight = 141
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 89
    Height = 13
    Caption = #1058#1077#1085#1082#1091#1097#1072#1103' '#1074#1077#1088#1089#1080#1103
  end
  object Label2: TLabel
    Left = 16
    Top = 80
    Width = 82
    Height = 13
    Caption = #1040#1090#1082#1091#1076#1072' '#1089#1082#1072#1095#1072#1090#1100
  end
  object Edit1: TEdit
    Left = 16
    Top = 48
    Width = 161
    Height = 21
    TabOrder = 0
    Text = '7.3.1 beta'
  end
  object Edit2: TEdit
    Left = 16
    Top = 104
    Width = 241
    Height = 21
    TabOrder = 1
    Text = 'http://qzone.dcworld.com.ua/IceHub.rar'
  end
  object Button1: TButton
    Left = 182
    Top = 8
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object UpSocket: TServerSocket
    Active = True
    Port = 7887
    ServerType = stNonBlocking
    OnClientRead = UpSocketClientWrite
    Left = 144
    Top = 8
  end
end
