object FMain: TFMain
  Left = 0
  Top = 0
  Caption = 'B I O R I T M I'
  ClientHeight = 511
  ClientWidth = 743
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lFisico: TLabel
    Left = 33
    Top = 469
    Width = 48
    Height = 16
    Caption = 'Fisica: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object lEmotivo: TLabel
    Left = 216
    Top = 470
    Width = 63
    Height = 16
    Caption = 'Emotivo: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object lIntell: TLabel
    Left = 432
    Top = 469
    Width = 86
    Height = 16
    Caption = 'Intellettuale:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object lDataNascita: TLabel
    Left = 614
    Top = 54
    Width = 100
    Height = 16
    Caption = 'Data di nascita'
  end
  object lDataRif: TLabel
    Left = 614
    Top = 113
    Width = 122
    Height = 16
    Caption = 'Data di riferimento'
  end
  object iGraph: TImage
    Left = 8
    Top = 56
    Width = 600
    Height = 400
  end
  object Button1: TButton
    Left = 614
    Top = 164
    Width = 122
    Height = 25
    Caption = 'Calcola'
    TabOrder = 0
    OnClick = Button1Click
  end
  object dNascita: TDateTimePicker
    Left = 614
    Top = 76
    Width = 122
    Height = 24
    Date = 25492.421133275460000000
    Time = 25492.421133275460000000
    TabOrder = 1
  end
  object dRiferimento: TDateTimePicker
    Left = 614
    Top = 134
    Width = 122
    Height = 24
    Date = 42686.421133275460000000
    Time = 42686.421133275460000000
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 743
    Height = 41
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 3
    ExplicitWidth = 784
    object sbExit: TSpeedButton
      Left = 704
      Top = 4
      Width = 32
      Height = 33
      Hint = 'Termina programma'
      Caption = 'X'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbExitClick
    end
  end
end
