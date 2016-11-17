unit F_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons;

type
  tpGraph = (tpFisico, tpEmotivo, tpIntell);
  TFMain = class(TForm)
    Button1: TButton;
    dNascita: TDateTimePicker;
    dRiferimento: TDateTimePicker;
    lFisico: TLabel;
    lEmotivo: TLabel;
    lIntell: TLabel;
    lDataNascita: TLabel;
    lDataRif: TLabel;
    iGraph: TImage;
    Panel1: TPanel;
    sbExit: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbExitClick(Sender: TObject);
  private
    fnLineNascita: Integer;
    Procedure CreateRect;
    Procedure DrawGraph(nDelta: Integer; GraphType:tpGraph);
    Procedure WriteCaption(GraphType:tpGraph; sValue: String);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;
CONST
  CS_nDummy = 25;
  CS_nAumento = 17;
  CS_nCalcDay = 32;
  CS_nOffset = 200;
  CS_nSleep = 0;
  CS_FISICO  = 23;
  CS_EMOTIVO = 28;
  CS_INTELL  = 33;
implementation

{$R *.dfm}

procedure TFMain.Button1Click(Sender: TObject);
var
  i: Integer;
  ndayNasc: Integer;
  nday: Integer;
  ndelta: Integer;
  nLinea: Integer;

begin
  ndayNasc := Trunc(dNascita.Date);
  nday     := Trunc(dRiferimento.Date);
  ndelta := nday - ndayNasc;
  with iGraph do
  begin
    // reticolato
    CreateRect;
    DrawGraph(ndelta, tpFisico);
    DrawGraph(ndelta, tpEmotivo);
    DrawGraph(ndelta, tpIntell);
  end;
end;

procedure TFMain.CreateRect;
var
  nLinea: Integer;
  i: Integer;
begin
  with iGraph do
  begin
    // reticolato
    nLinea := CS_nDummy;
    Canvas.Pen.Color:=clBlack;
    canvas.Rectangle(CS_nDummy, CS_nDummy, 570,  375);
    Canvas.Moveto(CS_nDummy, CS_nOffset);
    Canvas.LineTo(570, CS_nOffset);
    fnLineNascita := CS_nDummy + (CS_nCalcDay DIV 2) * CS_nAumento;
    for i := 1 to CS_nCalcDay do
    begin
      canvas.Pen.Color := clBlack;
      if nLinea = fnLineNascita then
      begin
        canvas.Pen.Color := clFuchsia;
        Canvas.Moveto(nLinea, CS_nDummy);
        Canvas.LineTo(nLinea, 375);
      end
      else
      begin
        Canvas.Moveto(nLinea, 195);
        Canvas.LineTo(nLinea, 205);
      end;
      nLinea:= nLinea + CS_nAumento;
    end;
  end;
end;

procedure TFMain.DrawGraph(nDelta: Integer; GraphType: tpGraph);
var
  i,x,y: Integer;
  value: extended;
  oColor: Tcolor;
  nVar: Integer;
  sCaption: string;
begin
  nvar := 0;
  oColor := clblack;
  case GraphType of
   tpFisico: begin
               nVar := CS_FISICO;
               sCaption := 'Fisico: ';
               oColor := clBlue;
             end;
   tpEmotivo:begin
               nVar := CS_EMOTIVO;
               sCaption := 'Emotivo: ';
               oColor := clRed;
             end;
   tpIntell: begin
               nVar := CS_INTELL;
               sCaption := 'Intellettuale: ';
               oColor := clGreen;
             end;
  end;
  with iGraph do
  begin
    Canvas.Moveto(CS_nDummy, CS_nOffset);
    x := CS_nDummy;
    for i:=ndelta - (CS_nCalcDay div 2) to ndelta + (CS_nCalcDay div 2) do
    begin
      canvas.Pen.Color := oColor;
      value := (sin(2  *pi * (i / nVar)) * 100);
      if x = fnLineNascita then
        WriteCaption(GraphType, Round(value).ToString);
      y := round(value * -1) + CS_nOffset;
      Canvas.LineTo(x, y);
      x := x + CS_nAumento;
      sleep(CS_nSleep);
    end;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  dRiferimento.Date := now;
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  CreateRect;
end;

procedure TFMain.sbExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFMain.WriteCaption(GraphType:tpGraph; sValue: String);
Var oLabel: TLabel;
    sCaption: string;
begin
  oLabel := nil;
  case GraphType of
   tpFisico: begin
               oLabel := lFisico;
               sCaption := 'Fisico: ' + sValue + ' %';
             end;
   tpEmotivo:begin
               oLabel := lEmotivo;
               sCaption := 'Emotivo: ' + sValue + ' %';
             end;
   tpIntell: begin
               oLabel := lIntell;
               sCaption := 'Intellettuale: ' + sValue + ' %';
             end;
  end;
  oLabel.Caption := sCaption;
  oLabel.Refresh;

end;

end.
