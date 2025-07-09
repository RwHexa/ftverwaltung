unit UnitTable;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, UnitTeams, UnitMatches, UnitResults;

type
  TFormTable = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    btnUpdate: TButton;
    btnShowResultsrw: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnShowResultsrwClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: LongInt;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //procedure btnShowResultsrwClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure UpdateTable;
  private
    var
      FResultsForm: TFormResults;
  public
    { Public-Deklarationen }
  end;

var
  FormTable: TFormTable;

implementation

{$R *.dfm}

procedure TFormTable.FormCreate(Sender: TObject);
begin
    ShowMessage('in FormCreate-Ueberschriften');
  // Spaltenbreiten und Ausrichtung einstellen
  StringGrid1.ColWidths[0] := 50;   // Platz
  StringGrid1.ColWidths[1] := 200;  // Mannschaft
  StringGrid1.ColWidths[2] := 60;   // Spiele
  StringGrid1.ColWidths[3] := 60;   // Punkte
  StringGrid1.ColWidths[4] := 60;   // Tore+
  StringGrid1.ColWidths[5] := 60;   // Tore-

  // Spaltentitel setzen
  StringGrid1.Cells[0,0] := 'Platz';
  StringGrid1.Cells[1,0] := 'Mannschaft';
  StringGrid1.Cells[2,0] := 'Spiele';
  StringGrid1.Cells[3,0] := 'Punkte';
  StringGrid1.Cells[4,0] := 'Tore +';
  StringGrid1.Cells[5,0] := 'Tore -';

  // Grundeinstellungen
  StringGrid1.FixedRows := 1;       // Erste Zeile fixiert
  StringGrid1.RowCount := 7;        // Maximal 6 Teams +
  StringGrid1.ColCount := 6;        // 6 Spalten

  // Button hinzufügen
  btnShowResultsrw := TButton.Create(Self);
  with btnShowResultsrw do
  begin
    Parent := Panel1;
    Left := btnUpdate.Left + btnUpdate.Width + 10;
    Top := btnUpdate.Top;
    Width := 120;
    Height := btnUpdate.Height;
    Caption := 'Ergebnisse';
    OnClick := btnShowResultsrwClick;
  end;

  UpdateTable;
end;

 // ====================  Text zentrieren  ==================
  procedure TFormTable.StringGrid1DrawCell(Sender: TObject; ACol, ARow: LongInt;
  Rect: TRect; State: TGridDrawState);
    var
  S: string;
  SavedAlign: word;
  begin
     if ACol = 1 then
     begin
     S := StringGrid1.Cells[ACol, ARow];
     SavedAlign := SetTextAlign(StringGrid1.Canvas.Handle, TA_CENTER);
     StringGrid1.Canvas.TextRect(Rect,
      Rect.Left + (Rect.Right - Rect.Left) div 2, Rect.Top + 2, S);
     SetTextAlign(StringGrid1.Canvas.Handle, SavedAlign);
   end;
  end;

//====================================================
procedure TFormTable.btnShowResultsrwClick(Sender: TObject);
begin
    // Ergebnisfenster erstellen falls noch nicht vorhanden
  if not Assigned(FResultsForm) then
  begin
    FResultsForm := TFormResults.Create(Self);
    FResultsForm.FormStyle := fsStayOnTop;  // Fenster bleibt im Vordergrund
  end;

  // Position neben dem Tabellenfenster
  FResultsForm.Left := Self.Left + Self.Width + 10;
  FResultsForm.Top := Self.Top;

  // Fenster anzeigen
  FResultsForm.Show;
end;

procedure TFormTable.btnUpdateClick(Sender: TObject);
begin

     // Spaltenbreiten und Ausrichtung einstellen
  StringGrid1.ColWidths[0] := 35;   // Platz
  StringGrid1.ColWidths[1] := 145;  // Mannschaft
  StringGrid1.ColWidths[2] := 46;   // Spiele
  StringGrid1.ColWidths[3] := 50;   // Punkte
  StringGrid1.ColWidths[4] := 55;   // Tore+
  StringGrid1.ColWidths[5] := 55;   // Tore-

  // Spaltentitel setzen
  StringGrid1.Cells[0,0] := 'Pl.';
  StringGrid1.Cells[1,0] := 'Vereine';
  StringGrid1.Cells[2,0] := 'Spl.';
  StringGrid1.Cells[3,0] := 'Pkt.';
  StringGrid1.Cells[4,0] := 'Tor+';
  StringGrid1.Cells[5,0] := 'Tor-';

  // Grundeinstellungen
  StringGrid1.FixedRows := 1;       // Erste Zeile fixiert
  StringGrid1.FixedColor := clYellow;
  StringGrid1.RowCount := 7;        // Maximal 6 Teams
  StringGrid1.ColCount := 6;        // 6 Spalten

  UpdateTable;
end;
   //===================================================


procedure TFormTable.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Ergebnisfenster mit schließen
  if Assigned(FResultsForm) then
  begin
    FResultsForm.Close;
    FResultsForm.Free;
    FResultsForm := nil;
  end;
end;

procedure TFormTable.UpdateTable;
var
  i, j: Integer;
  TeamStats: array of record
    Name: string;
    Games: Integer;
    Points: Integer;
    GoalsScored: Integer;
    GoalsConceded: Integer;
  end;
begin
  // Initialize team stats
  SetLength(TeamStats, FormTeams.GetTeamCount);
 // ShowMessage('Anzahl Teams: ' + IntToStr(GlobalTeamCount));
  for i := 0 to High(TeamStats) do
  begin
    TeamStats[i].Name := FormTeams.GetTeamName(i + 1);
    TeamStats[i].Games := 0;
    TeamStats[i].Points := 0;
    TeamStats[i].GoalsScored := 0;
    TeamStats[i].GoalsConceded := 0;
  end;
  // Process matches
  for i := 0 to High(GlobalMatches) do
  begin
    for j := 0 to High(TeamStats) do
    begin

      if TeamStats[j].Name = GlobalMatches[i].Team1 then
      begin
        Inc(TeamStats[j].Games);
        TeamStats[j].GoalsScored := TeamStats[j].GoalsScored + GlobalMatches[i].Goals1;
        TeamStats[j].GoalsConceded := TeamStats[j].GoalsConceded + GlobalMatches[i].Goals2;
        if GlobalMatches[i].Goals1 > GlobalMatches[i].Goals2 then
          TeamStats[j].Points := TeamStats[j].Points + 3
        else if GlobalMatches[i].Goals1 = GlobalMatches[i].Goals2 then
          TeamStats[j].Points := TeamStats[j].Points + 1;
      end
      else if TeamStats[j].Name = GlobalMatches[i].Team2 then
      begin
        Inc(TeamStats[j].Games);
        TeamStats[j].GoalsScored := TeamStats[j].GoalsScored + GlobalMatches[i].Goals2;
        TeamStats[j].GoalsConceded := TeamStats[j].GoalsConceded + GlobalMatches[i].Goals1;
        if GlobalMatches[i].Goals2 > GlobalMatches[i].Goals1 then
          TeamStats[j].Points := TeamStats[j].Points + 3
        else if GlobalMatches[i].Goals1 = GlobalMatches[i].Goals2 then
          TeamStats[j].Points := TeamStats[j].Points + 1;
      end;
    end;
  end;

  // Sort teams by points and goal difference
  for i := 0 to High(TeamStats) - 1 do
    for j := i + 1 to High(TeamStats) do
      if (TeamStats[j].Points > TeamStats[i].Points) or
         ((TeamStats[j].Points = TeamStats[i].Points) and
          ((TeamStats[j].GoalsScored - TeamStats[j].GoalsConceded) >
           (TeamStats[i].GoalsScored - TeamStats[i].GoalsConceded))) then
      begin
        var Temp := TeamStats[i];
        TeamStats[i] := TeamStats[j];
        TeamStats[j] := Temp;
      end;

  // Update grid
  for i := 0 to High(TeamStats) do
  begin

    StringGrid1.Cells[0, i + 1] := IntToStr(i + 1);
    StringGrid1.Cells[1, i + 1] := TeamStats[i].Name;
    StringGrid1.Cells[2, i + 1] := IntToStr(TeamStats[i].Games);
    StringGrid1.Cells[3, i + 1] := IntToStr(TeamStats[i].Points);
    StringGrid1.Cells[4, i + 1] := IntToStr(TeamStats[i].GoalsScored);
    StringGrid1.Cells[5, i + 1] := IntToStr(TeamStats[i].GoalsConceded);
  end;
end;

end.