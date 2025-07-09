unit UnitTeams;


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TTeam = record
    Name: string;
    Points: Integer;
    GoalsScored: Integer;
    GoalsConceded: Integer;
  end;

  TFormTeams = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtTeamName: TEdit;
    btnAddTeam: TButton;
    ListBox1: TListBox;
    btnDeleteTeam: TButton;
    procedure btnAddTeamClick(Sender: TObject);
    procedure btnDeleteTeamClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    //Teams: array[1..6] of TTeam;
    //TeamCount: Integer;
    procedure UpdateListBox;
  public
    { Public-Deklarationen }
    function GetTeamCount: Integer;
    function GetTeamName(Index: Integer): string;
  end;


var
  FormTeams: TFormTeams;
  GlobalTeams: array[1..6] of TTeam;
  GlobalTeamCount: Integer;

implementation

{$R *.dfm}


procedure TFormTeams.FormCreate(Sender: TObject);
begin
 showmessage('in Create');
  GlobalTeamCount := 0;
end;

procedure TFormTeams.btnAddTeamClick(Sender: TObject);
begin
 // ShowMessage('Button wurde geklickt: ' + edtTeamName.Text);
  if GlobalTeamCount < 6 then
  begin
    if Trim(edtTeamName.Text) <> '' then
    begin
      Inc(GlobalTeamCount);
      GlobalTeams[GlobalTeamCount].Name := edtTeamName.Text;
      GlobalTeams[GlobalTeamCount].Points := 0;
      GlobalTeams[GlobalTeamCount].GoalsScored := 0;
      GlobalTeams[GlobalTeamCount].GoalsConceded := 0;
      edtTeamName.Clear;
      UpdateListBox;
    end
    else
      ShowMessage('Bitte geben Sie einen Mannschaftsnamen ein!');
  end
  else
    ShowMessage('Maximale Anzahl von Mannschaften erreicht!');
end;

procedure TFormTeams.btnDeleteTeamClick(Sender: TObject);
var
  i: Integer;
begin
  showmessage('in loeschen');
  if ListBox1.ItemIndex >= 0 then
  begin
    for i := ListBox1.ItemIndex + 1 to GlobalTeamCount do
      GlobalTeams[i-1] := GlobalTeams[i];
    Dec(GlobalTeamCount);
    UpdateListBox;
  end;
end;

procedure TFormTeams.UpdateListBox;
var
  i: Integer;
begin
  ListBox1.Clear;
  for i := 1 to GlobalTeamCount do
    ListBox1.Items.Add(GlobalTeams[i].Name);
end;

function TFormTeams.GetTeamCount: Integer;
begin
   Result := GlobalTeamCount;
end;

function TFormTeams.GetTeamName(Index: Integer): string;
begin
  if (Index >= 1) and (Index <= GlobalTeamCount) then
    Result := GlobalTeams[Index].Name
  else
    Result := '';
end;

end. 