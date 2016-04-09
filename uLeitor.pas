unit uLeitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UCBioBSPCOMLib_TLB, ComObj;

type
  TfrmPrincipal = class(TForm)
    bCadastra: TButton;
    bConsulta: TButton;

    procedure setUp();
    procedure cadastrarDigital();
    procedure verificaDigital();
    function coletaDigital(proposito : Integer) : string;
    procedure FormCreate(Sender: TObject);
    procedure bCadastraClick(Sender: TObject);
    procedure bConsultaClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    //Declarações do UCBio
    objUCBioBSP: Variant;
    objDevice: Variant;
    objFPData: Variant;
    objExtraction:Variant;
    objMatching: Variant;
    objFPImage: Variant;
    objSmartCard: Variant;
    objFastSearch: Variant;
    objAddedFpInfo: Variant;
  end;

const
    AUTO_DETEC = 255;
    MAX_FINGER = 10;
    ENROLL = 3;
    IDENTIFY = 2;
    VERIFY = 1;
    TABELA_DIGITAIS = 'stringcods';
    CAMPO_DIG = 'digital';
    CAMPO_USR = 'codigo';
var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uDados;
//**********************************************************************//
  procedure TfrmPrincipal.setUp();
    // Configurar terminal biometrico
    begin
      objUCBioBSP:= CreateOleObject('UCBioBSPCOM.UCBioBSP');
      objDevice:= objUCBioBSP.Device;
      objFPData:= objUCBioBSP.FPData;
      objExtraction:= objUCBioBSP.Extraction;
      objMatching:= objUCBioBSP.Matching;
      objFPImage:= objUCBioBSP.FPImage;
      objSmartCard := objUCBioBSP.SmartCard;
      objFastSearch := objUCBioBSP.FastSearch;
      objUCBioBSP.MaxFingersForEnroll := MAX_FINGER;
      objUCBioBSP.SetSkinResource('C:\Program Files (x86)\UnionCommunity\UCBioBSP SDK\Skin\UCBioBSPSkin_Portuguese.dll');
      if objUCBioBSP.ErrorCode <> 0 then
        ShowMessage('Troca de lingua não efetuada!');
    end;
//********************************************************************//
procedure TfrmPrincipal.cadastrarDigital();
  var
    dig1, criadoEm: string;
  begin
    if dmDados.conectaDB <> 0 then
    begin
      ShowMessage('Não Foi possivel se conectar ao banco de dados!');
      Exit;
    end;
    objDevice.Open(AUTO_DETEC);
    if objUCBioBSP.ErrorCode <> 0 then
    begin
      ShowMessage('Problema ao abrir dispositivo');
      Exit;
    end;
    DateTimeToString(criadoEm,'YYYY-MM-DD HH:MM:SS',now);

    objExtraction.Enroll(null,null);
    dig1 := objExtraction.TextFIR;
    ShowMessage(dig1.Length.ToString());
    if objUCBioBSP.ErrorCode = 0 then
    begin
      if dmDados.inseriDB(dig1,criadoEm,'1') = 0 then
      begin
        ShowMessage('Digital cadastrada com sucesso!');
        Exit
      end
      else
      begin
        ShowMessage('Falha ao cadastrar digital!');
        Exit;
      end;
    end
    else
    begin
        ShowMessage('Erro na captura da Digital');
    end;

     objDevice.Close(AUTO_DETEC);
  end;

//********************************************************************//
  procedure TfrmPrincipal.verificaDigital();
  var
    digitais : TStringList;
    count : Integer;
    digFIR : string;
  begin
    digFIR :=self.coletaDigital(IDENTIFY);
    digitais := dmDados.consultaDigitaisDB(TABELA_DIGITAIS, CAMPO_DIG, CAMPO_USR);

     for count := 0 to digitais.Count-1 do
     begin
       objMatching.VerifyMatch(digFIR,digitais.Strings[count]);
       if objUCBioBSP.ErrorCode = 0 then
       begin
        if objMatching.MatchingResult then
        begin
             ShowMessage('OK!');
             Exit;
        end;
       end;
     end;
     ShowMessage('você não está cadastrado(a)');

    objFastSearch.MaxSearchTime := 5 * 1000;
    objDevice.Open(AUTO_DETEC);
    if objUCBioBSP.ErrorCode <> 0 then
    begin
      ShowMessage(objUCBioBSP.ErrorDescription + ' [' + objUCBioBSP.ErrorCode + ']');
      Exit;
    end;
  end;
//********************************************************************//
  procedure TfrmPrincipal.FormCreate(Sender: TObject);
  begin
    Self.setUp();
  end;

//**********************************************************************//
  procedure TfrmPrincipal.bCadastraClick(Sender: TObject);
  begin
    Self.cadastrarDigital();
  end;
 //**********************************************************************//
  procedure TfrmPrincipal.bConsultaClick(Sender: TObject);
  begin
    Self.verificaDigital();
  end;
//**********************************************************************//
function TfrmPrincipal.coletaDigital(proposito: Integer) : string;
 var
    dig1 : string;
  begin

    objDevice.Open(AUTO_DETEC);
    if objUCBioBSP.ErrorCode <> 0 then
    begin
      ShowMessage('Problema ao abrir dispositivo');
      Exit;
    end;

    objExtraction.Capture(proposito);
    Result := objExtraction.TextFIR;

end;
  end.
