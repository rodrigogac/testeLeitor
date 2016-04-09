program testeLeitor;

uses
  Vcl.Forms,
  uLeitor in 'uLeitor.pas' {frmPrincipal},
  uDados in 'uDados.pas' {dmDados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdmDados, dmDados);
  Application.Run;
end.
