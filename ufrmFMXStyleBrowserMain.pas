unit ufrmFMXStyleBrowserMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.ListBox, FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Beyond.Bind.DateUtils, Beyond.Bind.Json, Beyond.Bind.StrUtils,
  System.ImageList, FMX.ImgList;

type
  TfrmFMXStyleBrowser = class(TForm)
    chkWindowsDefault: TCheckBox;
    brnRefreshStyles: TButton;
    radFolder1: TRadioButton;
    grpStyleConfig: TGroupBox;
    ProgressBar1: TProgressBar;
    lbStyleList: TListBox;
    cmbStyle: TComboBox;
    edtFolder1: TEdit;
    TrackBar1: TTrackBar;
    BindingsList1: TBindingsList;
    LinkControlToPropertyValue: TLinkControlToProperty;
    lblDescr: TLabel;
    pnlBottom: TPanel;
    radFolder2: TRadioButton;
    radFolder3: TRadioButton;
    edtFolder2: TEdit;
    edtFolder3: TEdit;
    AniIndicator: TAniIndicator;
    AStyleBook: TStyleBook;
    Label1: TLabel;
    procedure brnRefreshStylesClick(Sender: TObject);
    procedure chkWindowsDefaultChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cmbStyleChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbStyleListDblClick(Sender: TObject);
    procedure radFolder1Click(Sender: TObject);
    procedure radFolder2Click(Sender: TObject);
    procedure radFolder3Click(Sender: TObject);
  private
    const
      REG_ROOT = 'SOFTWARE\StyleBrowserFMX';
      FOLDER_ONE = 'FolderOne';
      FOLDER_TWO = 'FolderTwo';
      FOLDER_THREE = 'FolderThree';
      FOLDER_SELECTED = 'FolderSelected';
    var
      FFirstTime: Boolean;
      FAllStyleNames: TStringList;
    FReloading: Boolean;
    function CurrentStyleFolder: string;
    procedure LoadSavedSettings;
    procedure SaveSettings;
    procedure RefreshStylesInFolder(const Foldername: string);
    procedure RefreshStylesForCurrentFolder;
  end;

var
  frmFMXStyleBrowser: TfrmFMXStyleBrowser;

implementation

{$R *.fmx}

uses
  System.Win.Registry, System.IOUtils;

procedure TfrmFMXStyleBrowser.brnRefreshStylesClick(Sender: TObject);
begin
  RefreshStylesForCurrentFolder;
end;

procedure TfrmFMXStyleBrowser.chkWindowsDefaultChange(Sender: TObject);
begin
  if chkWindowsDefault.IsChecked then begin
    AStyleBook.Clear;
    Self.StyleBook := nil;
  end;
end;

procedure TfrmFMXStyleBrowser.FormCreate(Sender: TObject);
begin
  FFirstTime := True;
  FAllStyleNames := TStringList.Create;
end;

procedure TfrmFMXStyleBrowser.LoadSavedSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKeyReadOnly(REG_ROOT) then begin
      edtFolder1.Text := reg.ReadString(FOLDER_ONE);
      edtFolder2.Text := reg.ReadString(FOLDER_TWO);
      edtFolder3.Text := reg.ReadString(FOLDER_THREE);

      case reg.ReadInteger(FOLDER_SELECTED) of
        1: begin radFolder1.IsChecked := True; RefreshStylesForCurrentFolder; end;
        2: begin radFolder2.IsChecked := True; RefreshStylesForCurrentFolder; end;
        3: begin radFolder3.IsChecked := True; RefreshStylesForCurrentFolder; end;
      end;
    end;
  finally
    reg.Free;
  end;
end;

procedure TfrmFMXStyleBrowser.RefreshStylesForCurrentFolder;
begin
  if radFolder1.IsChecked then
    RefreshStylesInFolder(edtFolder1.Text)
  else if radFolder2.IsChecked then
    RefreshStylesInFolder(edtFolder2.Text)
  else
    RefreshStylesInFolder(edtFolder3.Text);
end;

procedure TfrmFMXStyleBrowser.RefreshStylesInFolder(const Foldername: string);
begin
  FReloading := True;
  try
    lbStyleList.Items.Clear;

    if not FolderName.IsEmpty then begin
      if TDirectory.Exists(Foldername) then begin
        AniIndicator.Visible := True;
        AniIndicator.Enabled := True;
        try
          var StyleFiles := TDirectory.GetFiles(Foldername, '*.style');
          for var sf in StyleFiles do begin
            FAllStyleNames.Add(ExtractFilename(sf));
            lbStyleList.Items.Add(ExtractFilename(sf));
            Application.ProcessMessages;
            Sleep(100);
          end;
          cmbStyle.ItemIndex := 0;
        finally
          AniIndicator.Enabled := False;
          AniIndicator.Visible := False;
        end;
      end;
    end;
  finally
    FReloading := False;
  end;
end;

procedure TfrmFMXStyleBrowser.radFolder1Click(Sender: TObject);
begin
  if not radFolder1.IsChecked then begin
    radFolder1.IsChecked := True;
    RefreshStylesForCurrentFolder;
  end;
end;

procedure TfrmFMXStyleBrowser.radFolder2Click(Sender: TObject);
begin
  if not radFolder2.IsChecked then begin
    radFolder2.IsChecked := True;
    RefreshStylesForCurrentFolder;
  end;
end;

procedure TfrmFMXStyleBrowser.radFolder3Click(Sender: TObject);
begin
  if not radFolder3.IsChecked then begin
    radFolder3.IsChecked := True;
    RefreshStylesForCurrentFolder;
  end;
end;

procedure TfrmFMXStyleBrowser.SaveSettings;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    if reg.OpenKey(REG_ROOT, True) then begin
      reg.WriteString(FOLDER_ONE, edtFolder1.Text);
      reg.WriteString(FOLDER_TWO, edtFolder2.Text);
      reg.WriteString(FOLDER_THREE, edtFolder3.Text);

      reg.WriteInteger(FOLDER_SELECTED, if radFolder1.IsChecked then 1 else if radfolder2.IsChecked then 2 else 3);
    end;
  finally
    reg.Free;
  end;
end;

procedure TfrmFMXStyleBrowser.cmbStyleChange(Sender: TObject);
begin
  if not FReloading then begin
    lbStyleList.Items.Clear;

    case cmbStyle.ItemIndex of
      0: lbStyleList.Items := FAllStyleNames;
      1: for var s in FAllStyleNames do if s.Contains('dark', True) then lbStyleList.Items.Add(s);
      2: for var s in FAllStyleNames do if s.Contains('light', True) then lbStyleList.Items.Add(s);
    end;
  end;
end;

function TfrmFMXStyleBrowser.CurrentStyleFolder: string;
begin
  if radFolder1.IsChecked then
    Result := edtFolder1.Text
  else if radFolder2.IsChecked then
    Result := edtFolder2.Text
  else if radFolder3.IsChecked then
    Result := edtFolder3.Text;
end;

procedure TfrmFMXStyleBrowser.FormActivate(Sender: TObject);
begin
  if FFirstTime then begin
    FFirstTime := False;
    FReloading := False;
    LoadSavedSettings;
  end;
end;

procedure TfrmFMXStyleBrowser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
  FAllStyleNames.Free;
end;

procedure TfrmFMXStyleBrowser.lbStyleListDblClick(Sender: TObject);
begin
  chkWindowsDefault.IsChecked := False;

  AStyleBook.Clear;
  Self.StyleBook := nil;
  Application.ProcessMessages;

  AStyleBook.LoadFromFile(TPath.Combine(CurrentStyleFolder, lbStyleList.Items[lbStyleList.ItemIndex]));
  Self.StyleBook := AStyleBook;
end;

end.
