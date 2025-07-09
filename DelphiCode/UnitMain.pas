unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Menus, UnitTeams, UnitMatches, UnitCurrentMatches, UnitTable, UnitResults, System.IniFiles,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    mnuDatei: TMenuItem;
    mnuDateiNeu: TMenuItem;
    mnuDateiOeffnen: TMenuItem;
    mnuDateiSpeichern: TMenuItem;
    mnuDateiSpeichernUnter: TMenuItem;
    mnuDateiTrennlinie: TMenuItem;
    mnuDateiBeenden: TMenuItem;
    mnuTurnier: TMenuItem;
    mnuTurnierMannschaften: TMenuItem;
    mnuTurnierSpiele: TMenuItem;
    mnuTurnierTabelle: TMenuItem;
    mnuTurnierErgebnisse: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    mnuSpielInfo: TMenuItem;
    mnuSpielInfoAktuell: TMenuItem;
    Label1: TLabel;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure mnuDateiBeendenClick(Sender: TObject);
    procedure mnuTurnierMannschaftenClick(Sender: TObject);
    procedure mnuTurnierSpieleClick(Sender: TObject);
    procedure mnuTurnierTabelleClick(Sender: TObject);
    procedure mnuTurnierErgebnisseClick(Sender: TObject);
    procedure mnuDateiNeuClick(Sender: TObject);
    procedure mnuDateiOeffnenClick(Sender: TObject);
    procedure mnuDateiSpeichernClick(Sender: TObject);
    procedure mnuDateiSpeichernUnterClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuSpielInfoAktuellClick(Sender: TObject);
  private

  public
    { Public-Deklarationen }
  end;

var
  FormMain: TFormMain;
  FormTable: TFormTable;
  FormResults: TFormResults;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Caption := 'Fußball-Turnier';

   //SaveDialog1 := TSaveDialog.Create(Self);
   //OpenDialog1 := TOpenDialog.Create(Self);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  //SaveDialog1.Free;
  //OpenDialog1.Free;
  if Assigned(FormCurrentMatches) then
    FormCurrentMatches.Free;
  if Assigned(FormTable) then
    FormTable.Free;
  if Assigned(FormResults) then
    FormResults.Free;
end;

procedure TFormMain.mnuDateiNeuClick(Sender: TObject);
begin
  if MessageDlg('Möchten Sie wirklich ein neues Turnier beginnen?' + #13 +
                'Alle aktuellen Daten gehen verloren!', 
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    // Hier Code für Zurücksetzen aller Daten
    GlobalTeamCount := 0;
    SetLength(GlobalMatches, 0);
  end;
end;

procedure TFormMain.mnuDateiOeffnenClick(Sender: TObject);
var
  IniFile: TIniFile;
  i, Count: Integer;
begin
  OpenDialog1.Filter := 'Turnier Dateien (*.trn)|*.trn';
  OpenDialog1.DefaultExt := 'trn';
  
  if OpenDialog1.Execute then
  begin
    if MessageDlg('Möchten Sie das aktuelle Turnier laden?' + #13 +
                  'Alle nicht gespeicherten Daten gehen verloren!',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      IniFile := TIniFile.Create(OpenDialog1.FileName);
      try
        // Teams laden
        GlobalTeamCount := IniFile.ReadInteger('Teams', 'Count', 0);
        for i := 1 to GlobalTeamCount do
        begin
          GlobalTeams[i].Name := IniFile.ReadString('Team_' + IntToStr(i), 'Name', '');
          GlobalTeams[i].Points := IniFile.ReadInteger('Team_' + IntToStr(i), 'Points', 0);
          GlobalTeams[i].GoalsScored := IniFile.ReadInteger('Team_' + IntToStr(i), 'GoalsScored', 0);
          GlobalTeams[i].GoalsConceded := IniFile.ReadInteger('Team_' + IntToStr(i), 'GoalsConceded', 0);
        end;

        // Spiele laden
        Count := IniFile.ReadInteger('Matches', 'Count', 0);
        SetLength(GlobalMatches, Count);
        for i := 0 to Count - 1 do
        begin
          GlobalMatches[i].Team1 := IniFile.ReadString('Match_' + IntToStr(i), 'Team1', '');
          GlobalMatches[i].Team2 := IniFile.ReadString('Match_' + IntToStr(i), 'Team2', '');
          GlobalMatches[i].Goals1 := IniFile.ReadInteger('Match_' + IntToStr(i), 'Goals1', 0);
          GlobalMatches[i].Goals2 := IniFile.ReadInteger('Match_' + IntToStr(i), 'Goals2', 0);
        end;

        SaveDialog1.FileName := OpenDialog1.FileName;
        ShowMessage('Turnierdaten wurden geladen.');
      finally
        IniFile.Free;
      end;
    end;
  end;
end;

procedure TFormMain.mnuDateiSpeichernClick(Sender: TObject);
begin
  if SaveDialog1.FileName = '' then
    mnuDateiSpeichernUnterClick(Sender)
  else
    mnuDateiSpeichernUnterClick(Sender);
end;

procedure TFormMain.mnuDateiSpeichernUnterClick(Sender: TObject);
var
  IniFile: TIniFile;
  i: Integer;
begin
  SaveDialog1.Filter := 'Turnier Dateien (*.trn)|*.trn';
  SaveDialog1.DefaultExt := 'trn';
  
  if SaveDialog1.Execute then
  begin
    IniFile := TIniFile.Create(SaveDialog1.FileName);
    try
      // Teams speichern
      IniFile.WriteInteger('Teams', 'Count', GlobalTeamCount);
      for i := 1 to GlobalTeamCount do
      begin
        IniFile.WriteString('Team_' + IntToStr(i), 'Name', GlobalTeams[i].Name);
        IniFile.WriteInteger('Team_' + IntToStr(i), 'Points', GlobalTeams[i].Points);
        IniFile.WriteInteger('Team_' + IntToStr(i), 'GoalsScored', GlobalTeams[i].GoalsScored);
        IniFile.WriteInteger('Team_' + IntToStr(i), 'GoalsConceded', GlobalTeams[i].GoalsConceded);
      end;

      // Spiele speichern
      IniFile.WriteInteger('Matches', 'Count', Length(GlobalMatches));
      for i := 0 to High(GlobalMatches) do
      begin
        IniFile.WriteString('Match_' + IntToStr(i), 'Team1', GlobalMatches[i].Team1);
        IniFile.WriteString('Match_' + IntToStr(i), 'Team2', GlobalMatches[i].Team2);
        IniFile.WriteInteger('Match_' + IntToStr(i), 'Goals1', GlobalMatches[i].Goals1);
        IniFile.WriteInteger('Match_' + IntToStr(i), 'Goals2', GlobalMatches[i].Goals2);
      end;
      
      ShowMessage('Turnierdaten wurden gespeichert.');
    finally
      IniFile.Free;
    end;
  end;
end;

procedure TFormMain.mnuSpielInfoAktuellClick(Sender: TObject);
begin
  if FormCurrentMatches = nil then
  begin
    FormCurrentMatches := TFormCurrentMatches.Create(Application);
    FormCurrentMatches.Show;  // Nicht-modal anzeigen
  end
  else
    FormCurrentMatches.Show;  // Falls bereits erstellt, nur anzeigen
end;

procedure TFormMain.mnuDateiBeendenClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.mnuTurnierMannschaftenClick(Sender: TObject);
begin
  FormTeams := TFormTeams.Create(Application);
  try
    FormTeams.ShowModal;
  finally
    FormTeams.Free;
  end;
end;

procedure TFormMain.mnuTurnierSpieleClick(Sender: TObject);
begin
  FormMatches := TFormMatches.Create(Application);
  try
    FormMatches.ShowModal;
  finally
    FormMatches.Free;
  end;
end;

procedure TFormMain.mnuTurnierTabelleClick(Sender: TObject);
begin
  if FormTable = nil then
  begin
    FormTable := TFormTable.Create(Application);
    FormTable.Show;  // Nicht-modal
  end
  else
    FormTable.Show;
end;

procedure TFormMain.mnuTurnierErgebnisseClick(Sender: TObject);
begin
  if FormResults = nil then
  begin
    FormResults := TFormResults.Create(Application);
    FormResults.Show;  // Nicht-modal
  end
  else
    FormResults.Show;
end;

end.
