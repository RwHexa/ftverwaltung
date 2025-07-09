unit UnitMatches;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UnitTeams;

type
  TMatch = record
    Team1: string;
    Team2: string;
    Goals1: Integer;
    Goals2: Integer;
  end;

  TFormMatches = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cmbTeam1: TComboBox;
    cmbTeam2: TComboBox;
    edtGoals1: TEdit;
    edtGoals2: TEdit;
    btnAddMatch: TButton;
    ListBox1: TListBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAddMatchClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure UpdateTeamComboBoxes;
    procedure UpdateListBox;
    procedure SaveMatches;
    procedure LoadMatches;
  public
    { Public-Deklarationen }
  end;

var
  FormMatches: TFormMatches;
  GlobalMatches: array of TMatch;

implementation

{$R *.dfm}

procedure TFormMatches.SaveMatches;
var
  F: TextFile;
  i: Integer;
begin
  AssignFile(F, 'matches.dat');
  try
    Rewrite(F);
    // Anzahl der Spiele speichern
    Writeln(F, Length(GlobalMatches));
    // Alle Spiele speichern
    for i := 0 to High(GlobalMatches) do
      with GlobalMatches[i] do
        Writeln(F, Format('%s|%s|%d|%d', [Team1, Team2, Goals1, Goals2]));
  finally
    CloseFile(F);
  end;
end;

procedure TFormMatches.LoadMatches;
var
  F: TextFile;
  Count, i: Integer;
  S: string;
  SL: TStringList;
begin
  if not FileExists('matches.dat') then Exit;
  
  SL := TStringList.Create;
  try
    AssignFile(F, 'matches.dat');
    Reset(F);
    try
      // Anzahl der Spiele lesen
      Readln(F, S);
      Count := StrToIntDef(S, 0);
      SetLength(GlobalMatches, Count);
      
      // Alle Spiele laden
      for i := 0 to Count-1 do
      begin
        Readln(F, S);
        SL.Clear;
        SL.Delimiter := '|';
        SL.DelimitedText := S;
        if SL.Count >= 4 then
        with GlobalMatches[i] do
        begin
          Team1 := SL[0];
          Team2 := SL[1];
          Goals1 := StrToIntDef(SL[2], 0);
          Goals2 := StrToIntDef(SL[3], 0);
        end;
      end;
    finally
      CloseFile(F);
    end;
  finally
    SL.Free;
  end;
  
  UpdateListBox;
end;

procedure TFormMatches.FormShow(Sender: TObject);
begin
  LoadMatches;  // Bestehende Spiele laden
  UpdateTeamComboBoxes;
end;

procedure TFormMatches.FormCreate(Sender: TObject);
begin
  SetLength(GlobalMatches, 0);
  LoadMatches;  // Bestehende Spiele laden
  UpdateTeamComboBoxes;
end;

procedure TFormMatches.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveMatches;  // Spiele beim Schließen speichern
end;

procedure TFormMatches.UpdateTeamComboBoxes;
var
  i: Integer;
begin
  cmbTeam1.Clear;
  cmbTeam2.Clear;
  for i := 1 to FormTeams.GetTeamCount do
  begin
    cmbTeam1.Items.Add(FormTeams.GetTeamName(i));
    cmbTeam2.Items.Add(FormTeams.GetTeamName(i));
  end;
end;

procedure TFormMatches.UpdateListBox;
var
  i: Integer;
begin
  ListBox1.Clear;
  for i := 0 to High(GlobalMatches) do
    ListBox1.Items.Add(Format('%s %d:%d %s', 
      [GlobalMatches[i].Team1, GlobalMatches[i].Goals1, GlobalMatches[i].Goals2, GlobalMatches[i].Team2]));
end;

procedure TFormMatches.btnAddMatchClick(Sender: TObject);
var
  Goals1, Goals2: Integer;
begin
  if (cmbTeam1.ItemIndex = -1) or (cmbTeam2.ItemIndex = -1) then
  begin
    ShowMessage('Bitte wählen Sie beide Mannschaften aus!');
    Exit;
  end;

  if cmbTeam1.ItemIndex = cmbTeam2.ItemIndex then
  begin
    ShowMessage('Eine Mannschaft kann nicht gegen sich selbst spielen!');
    Exit;
  end;

  if not TryStrToInt(edtGoals1.Text, Goals1) or not TryStrToInt(edtGoals2.Text, Goals2) then
  begin
    ShowMessage('Bitte geben Sie gültige Tore ein!');
    Exit;
  end;

  SetLength(GlobalMatches, Length(GlobalMatches) + 1);
  GlobalMatches[High(GlobalMatches)].Team1 := cmbTeam1.Text;
  GlobalMatches[High(GlobalMatches)].Team2 := cmbTeam2.Text;
  GlobalMatches[High(GlobalMatches)].Goals1 := Goals1;
  GlobalMatches[High(GlobalMatches)].Goals2 := Goals2;


  UpdateListBox;
end;

end.