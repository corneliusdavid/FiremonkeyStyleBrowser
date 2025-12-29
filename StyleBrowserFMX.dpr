program StyleBrowserFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufrmFMXStyleBrowserMain in 'ufrmFMXStyleBrowserMain.pas' {frmFMXStyleBrowser};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFMXStyleBrowser, frmFMXStyleBrowser);
  Application.Run;
end.
