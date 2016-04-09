unit uDados;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB,Vcl.Dialogs;

type
  TdmDados = class(TDataModule)
    dbCom: TADOConnection;
    dbQuery: TADOQuery;
    function conectaDB() : Integer;
    function inseriDB(digital, criadoEm, morador : string ) : Integer;
    function consultaDigitaisDB(tabela, campoDig, campoUsr : string) : TStringList;

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  dmDados: TdmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

//****************************************************************************//
  function TdmDados.conectaDB() : Integer;
  begin
      if dbCom.Connected = false then
      begin
          dbCom.ConnectionString := 'Provider=MSDASQL.1;Password=root123;Persist ' +
                'Security Info=True;User ID=root;Data Source=DB;Initial Catalog=teste';
          dbCom.Connected := true;
          Result := 0;
      end
      else
        Result := 1;
  end;

//****************************************************************************//
  function TdmDados.inseriDB(digital, criadoEm, morador : string) : Integer;
  var
    comando: string;
  begin

    comando := 'INSERT INTO stringcods (digital,morador,criadoEm) VALUES("'
                + digital + '","' + morador + '","' + criadoEm + '");';
    dbQuery.Connection := dbCom;
    dbQuery.SQL.Text := comando;

    try
    dbQuery.ExecSQL();
    except
        on e : EADOError do
        begin
          MessageDlg('Error while doing query', mtError,
                  [mbOK], 0);
          Result :=1;
        end;

    end;
        Result := 0;
  end;

// ******************************************************************************//
 function TdmDados.consultaDigitaisDB(tabela, campoDig,campoUsr :string) : TStringList;
  var
    comando: string;
    digitais : TStringList;
  begin

    comando := 'SELECT * FROM ' + tabela;
    dbQuery.Connection := dbCom;
    dbQuery.SQL.Text := comando;

    try
    dbQuery.Open();
    except
        on e : EADOError do
        begin
          MessageDlg('Error while doing query', mtError,
                  [mbOK], 0);
          Result := digitais;
        end;
    end;


   digitais := TStringList.Create();
   while not dbQuery.Eof do
    begin
        digitais.Add(dbQuery.FieldByName(campoDig).AsString) ;
        dbQuery.Next;
    end;

    Result := digitais;
 end;
//****************************************************************************//
end.
