object FormMatchEntry: TFormMatchEntry
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  BorderWidth = 3
  Caption = 'Spielinfo'
  ClientHeight = 263
  ClientWidth = 658
  Color = clActiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 25
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 166
    Height = 32
    Caption = 'aktuelles Spiel : '
    Color = clCream
    Font.Charset = BALTIC_CHARSET
    Font.Color = clWindow
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = [fsItalic]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 296
    Top = 59
    Width = 40
    Height = 25
    Caption = '-----'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cmbTeam1: TComboBox
    Left = 88
    Top = 56
    Width = 185
    Height = 33
    Style = csDropDownList
    Color = clKhaki
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object cmbTeam2: TComboBox
    Left = 360
    Top = 56
    Width = 177
    Height = 33
    Style = csDropDownList
    Color = clKhaki
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object spnGoals1: TSpinEdit
    Left = 144
    Top = 112
    Width = 65
    Height = 42
    Color = clLightgreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 2
    Value = 0
  end
  object spnGoals2: TSpinEdit
    Left = 416
    Top = 112
    Width = 57
    Height = 42
    Color = clLightgreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 3
    Value = 0
  end
  object btnSave: TButton
    Left = 208
    Top = 202
    Width = 97
    Height = 33
    Caption = 'Apply'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 376
    Top = 203
    Width = 89
    Height = 30
    Caption = 'cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btnCancelClick
  end
end
