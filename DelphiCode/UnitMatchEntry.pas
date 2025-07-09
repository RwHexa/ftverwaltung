unit UnitMatchEntry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, UnitTeams, UnitTypes;


type
  TFormMatchEntry = class(TForm)
    cmbTeam1: TComboBox;
    cmbTeam2: TComboBox;
    spnGoals1: TSpinEdit;
    spnGoals2: TSpinEdit;
    btnSave: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  private
    { Private-Deklarationen }
      //procedure UpdateTeamLists;
  public
    { Public-Deklarationen }
     procedure UpdateTeamLists;
  function ShowMatch(var Team1, Team2: string; var Goals1, Goals2: Integer): Boolean;
  end;

var
  FormMatchEntry: TFormMatchEntry;

implementation

{$R *.dfm}

uses UnitMatches;

 // =======================================================
procedure TFormMatchEntry.FormCreate(Sender: TObject);
begin
 //ShowMessage('In Create MatchEntry');

  // Initialisierung der Komponenten prüfen
  if not Assigned(cmbTeam1) then
   // ShowMessage('WARNUNG: cmbTeam1 nicht gefunden!')
  else
    cmbTeam1.Clear;

  if not Assigned(cmbTeam2) then
   // ShowMessage('WARNUNG: cmbTeam2 nicht gefunden!')
  else
    cmbTeam2.Clear;

  // Erst nach der Initialisierung Teams laden
  UpdateTeamLists;
end;
 // =========================================================
procedure TFormMatchEntry.UpdateTeamLists;

 begin
  //ShowMessage('1. Start UpdateTeamLists');

  // FormTeams aus der globalen Variable verwenden
  if not Assigned(FormTeams) then
  begin
    //ShowMessage('2. Suche existierendes FormTeams');
    FormTeams := TFormTeams(Application.FindComponent('FormTeams'));

    if not Assigned(FormTeams) then
    begin
      //ShowMessage('3. FormTeams nicht gefunden - erstelle neu');
      Application.CreateForm(TFormTeams, FormTeams);
    //  FormTeams.LoadTeams;
    end;
  end;

  //ShowMessage('4. FormTeams gefunden - Teams: ' + IntToStr(FormTeams.ListBox1.Items.Count));

  // Prüfen ob ComboBoxen existieren
  if not Assigned(cmbTeam1) then
  begin
    //ShowMessage('FEHLER: cmbTeam1 nicht gefunden!');
    Exit;
  end;

  if not Assigned(cmbTeam2) then
  begin
   // ShowMessage('FEHLER: cmbTeam2 nicht gefunden!');
    Exit;
  end;

   // ComboBoxen leeren
  cmbTeam1.Clear;
  cmbTeam2.Clear;

  // Teams aus FormTeams übernehmen
  if FormTeams.ListBox1.Items.Count > 0 then
  begin
    // Debug: Teams anzeigen
    //ShowMessage('Vorhandene Teams:'#13#10 + FormTeams.ListBox1.Items.Text);

    cmbTeam1.Items.AddStrings(FormTeams.ListBox1.Items);
    cmbTeam2.Items.AddStrings(FormTeams.ListBox1.Items);
   // ShowMessage('5. Teams in ComboBoxen geladen: ' + IntToStr(cmbTeam1.Items.Count));
  end
  else
    //ShowMessage('FEHLER: Keine Teams zum Laden verfügbar!');
end;

 // =================================================
  function TFormMatchEntry.ShowMatch(var Team1, Team2: string;
  var Goals1, Goals2: Integer): Boolean;
  begin
     // ShowMessage('In ShowMatch');  // Test
  // Teams vorauswählen wenn übergeben
  if Team1 <> '' then
    cmbTeam1.ItemIndex := cmbTeam1.Items.IndexOf(Team1);
  if Team2 <> '' then
    cmbTeam2.ItemIndex := cmbTeam2.Items.IndexOf(Team2);

  // Tore setzen
  spnGoals1.Value := Goals1;
  spnGoals2.Value := Goals2;

  // Modal anzeigen
  Result := (ShowModal = mrOk);

  if Result then
  begin
    // Werte zurückgeben
    Team1 := cmbTeam1.Text;
    Team2 := cmbTeam2.Text;
    Goals1 := spnGoals1.Value;
    Goals2 := spnGoals2.Value;
  end;
  end;

  // ==========================================================
 procedure TFormMatchEntry.btnCancelClick(Sender: TObject);
 begin
  ModalResult := mrCancel;
 end;
  // =====================================================
 procedure TFormMatchEntry.btnSaveClick(Sender: TObject);
 var
  MatchData: TMatchData;
begin
  ShowMessage('=== Save Button Start ===');

  // Eingaben prüfen
  if (cmbTeam1.ItemIndex = -1) or (cmbTeam2.ItemIndex = -1) then
  begin
    //ShowMessage('Bitte beide Teams auswaehlen!');
    Exit;
  end;

  if cmbTeam1.ItemIndex = cmbTeam2.ItemIndex then
  begin
   // ShowMessage('Eine Mannschaft kann nicht gegen sich selbst spielen!');
    Exit;
  end;

  // Daten in MatchData speichern
  MatchData.Team1 := cmbTeam1.Text;
  MatchData.Team2 := cmbTeam2.Text;
  MatchData.Goals1 := spnGoals1.Value;
  MatchData.Goals2 := spnGoals2.Value;

  ShowMessage('Spiel erfasst: ' + MatchData.Team1 + ' ' +
             IntToStr(MatchData.Goals1) + ':' +
             IntToStr(MatchData.Goals2) + ' ' +
             MatchData.Team2);

  // An FormMatches uebergeben
  if Assigned(FormMatches) then
  begin
   // ShowMessage('Uebergebe an FormMatches');
   // FormMatches.AddMatch(MatchData);
   // ShowMessage('Spiel wurde uebergeben');
  end
  else
   // ShowMessage('FEHLER: FormMatches nicht gefunden!');

  Close;
 end;

end.
