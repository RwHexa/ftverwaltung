program FussballTurnier;

uses
  Vcl.Forms,
  System.SysUtils,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitTeams in 'UnitTeams.pas' {FormTeams},
  UnitMatches in 'UnitMatches.pas' {FormMatches},
  UnitTable in 'UnitTable.pas' {FormTable},
  UnitResults in 'UnitResults.pas' {FormResults},
  UnitMatchEntry in 'UnitMatchEntry.pas' {FormMatchEntry},
  UnitTypes in 'UnitTypes.pas',
  UnitCurrentMatches in 'UnitCurrentMatches.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormMatchEntry, FormMatchEntry);
  //Application.CreateForm(TForm1, Form1);
  Application.Run;
end. 