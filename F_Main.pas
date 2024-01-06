// Ho usato la VCL, mi trovo più a mio agio per la gestione della grafica strimizita
{
Spirituale
periodo: 53 giorni

Intuitivo
periodo: 38 giorni

Consapevolezza
periodo: 48 giorni

Estetico
periodo: 43 giorni
}

unit F_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.Generics.Collections, TypInfo,
  Vcl.Buttons;

type
  TMyPanel = Class(Tpanel)  // pannello custom
  protected
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd);
    message WM_ERASEBKGND;
  Public
    constructor Create(AOwner: TComponent); Override;
  End;

  tpGraph = (tpFisico, tpEmotivo, tpIntell, tpIntuito, tpSpirito, tpConsap, tpEstetico, tpPP);

  oRecCiclo = record
    oTipo: tpGraph;   // tipo di ciclo
    nValue: Integer;  // costante di calcolo
    oColor: TColor;   // Colore curva
    sCaption: String; // Descrizione
    nEta: Integer;
    oLabel: TLabel;
    procedure Create(Const Atipo: tpGraph; Const Aeta: Integer; Const ALabel: TLabel);
    Function SetCaption(Const AValue: Integer): String;
    Function Paint(Const ACanvas: TCanvas): Extended;
  end;


  TFMain = class(TForm)
    pMenu: TPanel;
    sbExit: TSpeedButton;
    Timer: TTimer;
    sbPrint: TSpeedButton;
    pFooter: TPanel;
    pFondo: TPanel;
    iGraph: TImage;
    Panel1: TPanel;
    lFisico: TLabel;
    lEmotivo: TLabel;
    lIntell: TLabel;
    lDataNascita: TLabel;
    lDataRif: TLabel;
    btCalc: TButton;
    dNascita: TDateTimePicker;
    dRiferimento: TDateTimePicker;
    cbAnimazione: TCheckBox;
    cbFisico: TCheckBox;
    cbEmotivo: TCheckBox;
    cbIntell: TCheckBox;
    lIntuito: TLabel;
    cbIntuito: TCheckBox;
    lSpirito: TLabel;
    lConsap: TLabel;
    cbSpirito: TCheckBox;
    cbConsap: TCheckBox;
    lEstetico: TLabel;
    cbEstetico: TCheckBox;
    Label1: TLabel;
    lPP: TLabel;
    procedure btCalcClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbExitClick(Sender: TObject);
    procedure DataChange(Sender: TObject);
    procedure AnimazioneClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure cbClick(Sender: TObject);
  private
    fnLineNascita: Integer;
    fnEtaGiorni: Integer;
    oMyPanel: TMyPanel;
    oMyCycl: TDictionary<tpGraph, oRecCiclo>;
    Procedure CreateRect(Const ACanvas: TCanvas);
    function GetnEtaGiorni: Integer;
    procedure SetnEtaGiorni(Const Value: Integer);
    procedure DrawImg(Const ACanvas: TCanvas);
    function FindLabel(AType: tpGraph): TLabel;
    { Private declarations }
  public
    { Public declarations }
    Function GetPrnDialog: TPrintDialog;
    procedure DrawLine(Const oCanvas: TCanvas; oMove, oLine: TPoint);
    Procedure DrawRect(Const oCanvas: TCanvas; Const oRect: TRect);
    procedure SetNewPage(Const oCanvas: TCanvas; nPageNumber: Integer);
    procedure SetFont(Const oCanvas: TCanvas; sName: String; nSize: Integer; nColor: TColor; oStyle: TFontStyles);
    Property nEtaGiorni: Integer read GetnEtaGiorni write SetnEtaGiorni;
  end;


CONST
  CS_nDummy   = 25;
  CS_nAumento = 23; //17;
  CS_nCalcDay = 32;
  CS_nOffset  = 200;
  CS_nSleep   = 0;  // nessun delay
  CS_PP = 12;
  CS_FISICO   = 23;
  CS_EMOTIVO  = 28;
  CS_INTELL   = 33;
  CS_INTUITO  = 38;
  CS_SPIRITO  = 53;
  CS_CONSAP   = 48;
  CS_ESTETICO = 43;
  CS_FONT     = 'Arial';
implementation

uses
  System.SysUtils, System.DateUtils, Printers;

{$R *.dfm}

procedure TFMain.DrawImg(Const ACanvas: TCanvas);
Var oRec: oRecCiclo;
    nMedia: Extended;
    nNum: Integer;
begin
  CreateRect(ACanvas);
  nMedia := 0;
  nNum := 0;
  for var oGraph in oMyCycl.Keys do
  begin
    if oMyCycl.TryGetValue(oGraph, orec) then
    begin
      oRec.nEta := nEtaGiorni;
      nMedia := nMedia + oRec.Paint(ACanvas);
      inc(nNum);
    end
    else
      raise Exception.Create('Ciclo non inserito nel dizionario');
  end;
  label1.Caption := 'Media: ' + Round(nMedia / nNUm).ToString;
end;

procedure TFMain.TimerTimer(Sender: TObject);
begin
  dRiferimento.Date := dRiferimento.Date + 1;
  nEtaGiorni := 0;
  DrawImg(iGraph.Canvas);
end;

procedure TFMain.btCalcClick(Sender: TObject);
begin
  DrawImg(iGraph.Canvas);
end;

procedure TFMain.btPrintClick(Sender: TObject);
Var oPrn: TPrintDialog;
    sReportHeader: String;
    oImage: TImage;
begin
  oPrn := GetPrnDialog;
  oImage := TImage.Create(nil);
  oImage.Height := 400;
  oImage.Width  := 800;
  DrawImg(oImage.Canvas);
  Try
    if oPrn.Execute then
    begin
      with Printer do
      begin
        Screen.Cursor := crHourGlass;
        BeginDoc;
        try
          SetFont(Canvas, CS_FONT, 15, clred, [fsBold]);
          sReportHeader := 'B I O R I T M I';
          Canvas.TextOut((Printer.PageWidth-Canvas.TextWidth(sReportHeader)) div 2, 150, sReportHeader);
          SetNewPage(Canvas, PageNumber);
          SetFont(Canvas, CS_FONT, 15, clBlack, []);
          Canvas.TextOut(200, 500, 'Data di nascita: ' + DateToStr(dNascita.Date));
          Canvas.TextOut(200, 700, 'Data di riferimento: ' + DateToStr(dRiferimento.Date));
          Canvas.StretchDraw(Rect(200, 1000, Printer.PageWidth-200, 3500), oimage.Picture.Bitmap);
          SetFont(Canvas, CS_FONT, 15, clBlue, []);
          Canvas.TextOut(200, 3700, lFisico.caption);
          SetFont(Canvas, CS_FONT, 15, clred, []);
          Canvas.TextOut(200, 3900, lEmotivo.caption);
          SetFont(Canvas, CS_FONT, 15, clGreen, []);
          Canvas.TextOut(200, 4100, lIntell.caption);
          SetFont(Canvas, CS_FONT, 15, clFuchsia, []);
          Canvas.TextOut(200, 4300, lIntuito.caption);
          SetFont(Canvas, CS_FONT, 15, clAqua, []);
          Canvas.TextOut(200, 4500, lSpirito.caption);
          SetFont(Canvas, CS_FONT, 15, clPurple, []);
          Canvas.TextOut(200, 4700, lConsap.caption);
          SetFont(Canvas, CS_FONT, 15, clMaroon, []);
          Canvas.TextOut(200, 4900, lEstetico.caption);
        finally
          EndDoc;
          Screen.Cursor := crDefault;
        end;
      end;
    end;
  Finally
    FreeAndNil(oPrn);
    FreeAndNil(oImage);
  End;
end;

procedure TFMain.cbClick(Sender: TObject);
var oMyRec: oRecCiclo;
    oMyType: tpGraph;
begin
  oMyType := tpGraph(TCheckBox(Sender).Tag);
  if TCheckBox(Sender).Checked then
  begin
    oMyRec.Create(oMyType, 0, FindLabel(oMyType));
    oMyCycl.Add(oMyType, oMyRec)
  end
  else
    oMyCycl.Remove(oMyType);
end;

procedure TFMain.AnimazioneClick(Sender: TObject);
begin
  timer.Enabled := cbAnimazione.Checked;;
end;

procedure TFMain.CreateRect(Const ACanvas: TCanvas);
var
  nLinea: Integer;
  oData: TDate;
  nS: String;
begin
  oData := dRiferimento.Date;
  nLinea := CS_nDummy;
  ACanvas.Pen.Color := clCream;
  ACanvas.Brush.Color := clCream;
  ACanvas.Rectangle(0, 0, ACanvas.ClipRect.Right,  ACanvas.ClipRect.Bottom);
  ACanvas.Pen.Color := clBlack;
  ACanvas.Brush.Color := clWhite;
  ACanvas.Rectangle(CS_nDummy, CS_nDummy, 762,  375);
  ACanvas.Moveto(CS_nDummy, CS_nOffset);
  ACanvas.LineTo(762, CS_nOffset);
  fnLineNascita := CS_nDummy + (CS_nCalcDay DIV 2) * CS_nAumento;
  for var i := 0 to CS_nCalcDay do
  begin
    ACanvas.Pen.Color := clBlack;
    if nLinea = fnLineNascita then
    begin
      Acanvas.Pen.Color := clFuchsia;
      ACanvas.Moveto(nLinea, CS_nDummy);
      ACanvas.LineTo(nLinea, 375);
      nS := DayOf(oData - ((CS_nCalcDay DIV 2)) + i).ToString;
      nS := nS.PadLeft(2, '0');
      ACanvas.TextOut(nlinea - 5, 205,  nS);
    end
    else
    begin
      ACanvas.Moveto(nLinea, 195);
      ACanvas.LineTo(nLinea, 205);
      if (i > 0)  and (i < CS_nCalcDay) then
        ACanvas.TextOut(nlinea - 5, 205, DayOf(oData - ((CS_nCalcDay DIV 2) ) + i).ToString.PadLeft(2, '0'));
    end;
    nLinea := nLinea + CS_nAumento;
  end;
end;

procedure TFMain.DataChange(Sender: TObject);
begin
  nEtaGiorni := 0;
end;

Function TFMain.FindLabel(AType: tpGraph): TLabel;
begin
  Result := Nil;
  for var x := 0 to Panel1.ControlCount - 1 do
  begin
    Var oComp := Panel1.Controls[x];
    if (oComp is TLabel) and (oComp.Tag = ord(AType)) then
    begin
      Result := (oComp as TLabel);
      Break;
    end;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
var oMyRec: oRecCiclo;

begin
  dRiferimento.Date := now;  // Setto data odierna
  oMyPanel := TMyPanel.Create(Self);  // Creo un pannello custom con DBuffer e nessun messaggio
  oMyPanel.BevelInner := bvLowered;
  oMyPanel.Parent := pFondo;
  oMyPanel.Align := alClient;
  oMyCycl := TDictionary<tpGraph, oRecCiclo>.Create;
  iGraph.Parent := oMyPanel;
  iGraph.Align := alClient;
  // creazione dei cicli default
  for var x := Low(tpGraph) to High(tpGraph) do
  begin
    Var oLabel := FindLabel(x);
    if Assigned(oLabel) then
    begin
      oMyRec.Create(x, 0, oLabel);
      oMyCycl.Add(x, oMyRec);
    end
    else
      raise Exception.Create('Label non trovata');
  end;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(oMyPanel);
  FreeAndNil(oMyCycl);
end;

procedure TFMain.FormShow(Sender: TObject);
begin
  CreateRect(iGraph.Canvas);  // inizializzo griglia
end;

function TFMain.GetnEtaGiorni: Integer;
begin
  Result := fnEtaGiorni;
end;

function TFMain.GetPrnDialog: TPrintDialog;
begin
  Result := TPrintDialog.Create(Nil);
end;

procedure TFMain.DrawLine(const oCanvas: TCanvas; oMove, oLine: TPoint);
begin
  oCanvas.MoveTo(oMove.X, oMove.Y);
  oCanvas.LineTo(oLine.X, oLine.y);
end;

procedure TFMain.DrawRect(const oCanvas: TCanvas; const oRect: TRect);
Var TopRight: TPoint;
    BottomLeft: TPoint;
begin
  oCanvas.Pen.Width := 5;
  TopRight   := TPoint.Create(oRect.Right, oRect.Top);
  BottomLeft := TPoint.Create(oRect.Left, oRect.Bottom);
  DrawLine(oCanvas, oRect.TopLeft, TopRight);
  DrawLine(oCanvas, TopRight, oRect.BottomRight);
  DrawLine(oCanvas, BottomLeft, oRect.BottomRight);
  DrawLine(oCanvas, oRect.TopLeft, BottomLeft);
end;

procedure TFMain.SetNewPage(Const oCanvas: TCanvas; nPageNumber: Integer);
begin
  SetFont(oCanvas, CS_FONT, 10, clBlack, []);
  DrawLine(oCanvas, TPoint.Create(200, 400), TPoint.Create(Printer.PageWidth-200, 400));
 // DrawLine(oCanvas, TPoint.Create(200, 800), TPoint.Create(Printer.PageWidth-200, 800));
  DrawLine(oCanvas, TPoint.Create(200, 6630), TPoint.Create(Printer.PageWidth-200, 6630));
  oCanvas.TextOut((Printer.PageWidth-oCanvas.TextWidth(DateToStr(Now))) div 2, 6680, DateToStr(Now)+' - Pagina:'+IntToStr(nPageNumber));
  SetFont(oCanvas, CS_FONT, 12, clBlue, [fsBold]);
  oCanvas.TextOut(400, 600, '');
  SetFont(oCanvas, CS_FONT, 10, clBlack, []);
end;

procedure TFMain.SetFont(Const oCanvas: TCanvas; sName: String; nSize: Integer;
  nColor: TColor; oStyle: TFontStyles);
begin
  oCanvas.Font.Name := sName;
  oCanvas.Font.Size := nSize;
  oCanvas.Font.Color := nColor;
  oCanvas.Font.Style := oStyle;
end;

procedure TFMain.SetnEtaGiorni(const Value: Integer);
begin
  if (dNascita.Date > 0) and (dRiferimento.Date > 0) then
  begin
    Var ndayNasc := Trunc(dNascita.Date);
    Var nday     := Trunc(dRiferimento.Date);
    fnEtaGiorni := nday - ndayNasc;  // età in giorni
  end
  else
    fnEtaGiorni := Value;
end;

procedure TFMain.sbExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

{ oRecCiclo }

procedure oRecCiclo.Create(Const Atipo: tpGraph; Const AEta: Integer; Const ALabel: TLabel);
begin
// in base al tipo inizializzo le costanti di calcolo
  oTipo := Atipo;
  nEta := AEta;
  oLabel := Alabel;
  case ATipo of
    tpFisico: begin
                nValue := CS_FISICO;
                sCaption := 'Fisico: ';
                oColor := clBlue;
              end;
    tpEmotivo:begin
                nValue := CS_EMOTIVO;
                sCaption := 'Emotivo: ';
                oColor := clRed;
              end;
    tpIntell: begin
                nValue := CS_INTELL;
                sCaption := 'Intellettuale: ';
                oColor := clGreen;
              end;
    tpIntuito:begin
                nValue := CS_INTUITO;
                sCaption := 'Intuito: ';
                oColor := clFuchsia;
              end;
    tpSpirito: begin
                nValue := CS_SPIRITO;
                sCaption := 'Spirituale: ';
                oColor := clAqua;
               end;
    tpConsap:  begin
                nValue := CS_CONSAP;
                sCaption := 'Consapevolezza: ';
                oColor := clPurple;
               end;
    tpEstetico:begin
                nValue := CS_ESTETICO;
                sCaption := 'Estetico: ';
                oColor := clMaroon;
               end;
    tpPP:begin
                nValue := CS_PP;
                sCaption := 'Personale: ';
                oColor := clBlack;
               end;
  end;
end;


Function oRecCiclo.Paint(Const ACanvas: TCanvas): Extended;
var
  x, i, y: Integer;
  nCalc: Extended;
  nLineDay: Integer;
begin
  x := CS_nDummy;
  nLineDay := CS_nDummy + (CS_nCalcDay DIV 2) * CS_nAumento;
  for i:= nEta - (CS_nCalcDay div 2) to nEta + (CS_nCalcDay div 2) do
  begin
    ACanvas.Pen.Color := oColor;
    nCalc := (sin(2 * pi * (i / nValue)) * 100);
    if x = nLineDay then
    begin
      oLabel.caption := SetCaption(Round(nCalc));
      Result := Round(nCalc);
    end;
    y := round(nCalc * -1.73) + CS_nOffset;
    if i = nEta - (CS_nCalcDay div 2) then
      ACanvas.Moveto(x, y);
    ACanvas.LineTo(x, y);
    x := x + CS_nAumento;
    Sleep(CS_nSleep);
  end;
end;

Function oRecCiclo.SetCaption(const AValue: Integer): String;
begin
  Result := sCaption + AValue.ToString + '%';
end;

{ TMyPanel }

constructor TMyPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
end;

procedure TMyPanel.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result:=0;
end;

end.
