object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Teste de Leitor'
  ClientHeight = 304
  ClientWidth = 572
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
  object bCadastra: TButton
    Left = 184
    Top = 32
    Width = 193
    Height = 57
    Caption = 'Cadastrar Nova Digital'
    TabOrder = 0
    OnClick = bCadastraClick
  end
  object bConsulta: TButton
    Left = 184
    Top = 136
    Width = 193
    Height = 57
    Caption = 'Pocurar por Digital'
    TabOrder = 1
    OnClick = bConsultaClick
  end
end
