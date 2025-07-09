unit UnitResults;

{$R *.dfm}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, UnitMatches, System.Types;

type
  TFormResults = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    btnUpdate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    procedure SetupGridColumns;
    procedure UpdateResults;
  public
    { Public-Deklarationen }
  end;

var
  FormResults: TFormResults;

implementation

procedure TFormResults.SetupGridColumns;
var
  i: Integer;
begin
  with StringGrid1 do begin
    // Spaltenbreiten und Ausrichtung
    ColWidths[0] := 50;   // Nr.
    ColWidths[1] := 150;  // Heim
    ColWidths[2] := 80;   // Ergebnis
    ColWidths[3] := 150;  // Gast
    
    // Für jede Spalte die Ausrichtung setzen
    for i := 0 to ColCount-1 do begin
      Canvas.Font.Style := [fsBold];  // Für Breitenberechnung
      ColWidths[i] := ColWidths[i] + 10;  // Etwas Zusatzbreite
    end;
  end;
end;

procedure TFormResults.FormCreate(Sender: TObject);
begin
  BorderStyle := bsSizeable;  // Fenster kann in der Größe verändert werden
  FormStyle := fsStayOnTop;   // Bleibt im Vordergrund
  Position := poDesigned;     // Verwendet die Position, die wir setzen
  
  with StringGrid1 do begin
    // Grundeinstellungen
    ColCount := 4;
    RowCount := 1;
    FixedRows := 1;
    FixedCols := 0;
    DefaultDrawing := False;  // Wichtig: Muss False sein!
    DrawingStyle := gdsClassic;
    Options := Options + [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
    
    // Formatierung
    FixedColor := clYellow;
    Font.Style := [];  // Normal für Daten
    
    // Event-Handler
    OnDrawCell := StringGrid1DrawCell;
  end;
  
  SetupGridColumns;  // Spalten einrichten
  UpdateResults;
  
  // Event-Handler explizit zuweisen
  StringGrid1.OnDrawCell := StringGrid1DrawCell;
end;

procedure TFormResults.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  //ShowMessage('DrawCell wird aufgerufen!');  // Zum Testen
  
  with StringGrid1.Canvas do begin
    // Hintergrund
    if ARow = 0 then begin
      Brush.Color := clYellow;
      Font.Style := [fsBold];
    end else begin
      Font.Style := [];
      if Odd(ARow) then
        Brush.Color := clWhite
      else
        Brush.Color := RGB(240,240,240);  // Hellgrau
    end;
    
    // Hintergrund zeichnen
    FillRect(Rect);
    
    // Text holen und zentrieren
    if StringGrid1.Cells[ACol, ARow] <> '' then begin
      SetTextAlign(Handle, TA_CENTER);
      try
        TextRect(Rect, 
                Rect.Left + (Rect.Right - Rect.Left) div 2,
                Rect.Top + 2,
                StringGrid1.Cells[ACol, ARow]);
      finally
        SetTextAlign(Handle, 0);  // Zurücksetzen auf Standard
      end;
    end;
  end;
end;

procedure TFormResults.btnUpdateClick(Sender: TObject);
begin
  with StringGrid1 do begin
    // Überschriften
    Cells[0,0] := 'Nr.';
    Cells[1,0] := 'Heim';
    Cells[2,0] := '---';
    Cells[3,0] := 'Gast';
  end;
  
  UpdateResults;
  StringGrid1.Invalidate;  // Grid neu zeichnen
end;

procedure TFormResults.UpdateResults;
var
  i: Integer;
begin
  StringGrid1.RowCount := Length(GlobalMatches) + 1;
  
  for i := 0 to High(GlobalMatches) do
  begin
    StringGrid1.Cells[0, i + 1] := IntToStr(i + 1);
    StringGrid1.Cells[1, i + 1] := GlobalMatches[i].Team1;
    StringGrid1.Cells[2, i + 1] := Format('%d:%d', 
      [GlobalMatches[i].Goals1, GlobalMatches[i].Goals2]);
    StringGrid1.Cells[3, i + 1] := GlobalMatches[i].Team2;
  end;
end;

end.