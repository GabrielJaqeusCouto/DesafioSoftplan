object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 197
  ClientWidth = 253
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object qtdThreads: TEdit
    Left = 16
    Top = 10
    Width = 121
    Height = 21
    TabOrder = 0
    TextHint = 'Quantidade Threads'
    OnKeyPress = qtdThreadsKeyPress
  end
  object tmpThreads: TEdit
    Left = 16
    Top = 50
    Width = 121
    Height = 21
    TabOrder = 1
    TextHint = 'Tempo entre Threads'
    OnKeyPress = tmpThreadsKeyPress
  end
  object btnIniciar: TBitBtn
    Left = 160
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 2
    OnClick = btnIniciarClick
  end
  object Memo: TMemo
    Left = 16
    Top = 90
    Width = 219
    Height = 89
    Enabled = False
    TabOrder = 3
  end
end
