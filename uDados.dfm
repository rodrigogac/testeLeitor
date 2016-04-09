object dmDados: TdmDados
  OldCreateOrder = False
  Height = 230
  Width = 341
  object dbCom: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=root123;Persist Security Info=True;U' +
      'ser ID=root;Data Source=DB;Initial Catalog=teste'
    Provider = 'MSDASQL.1'
    Left = 8
    Top = 8
  end
  object dbQuery: TADOQuery
    Connection = dbCom
    Parameters = <>
    Left = 72
    Top = 24
  end
end
