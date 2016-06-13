unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  PairSplitter, Grids, Menus, ftfont;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    PairSplitter1: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    StringGrid1: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    xPins: Integer;
    cPoint: TPoint;
    xTop, xBottom, xLeft, xRight: Integer;
    procedure InitScreen;
    procedure CreateDevice;
    procedure DrawPin(xPin: Integer);
  end;

var
  Form3: TForm3;
  xFormHeight, xFormWidth: Integer;
  //Colors
  xBackgroundColor: TColor;
  xGridLineColor: TColor;
  xCenterLineColor: TColor;
  xItemBodyColor: TColor;
  xItemPinColor: TColor;
  xItemEtypeColors: Array [1..11] of TColor;

implementation

Uses
  Unit1;

{$R *.lfm}

{ TForm3 }

procedure TForm3.InitScreen;
var
  xPoint: Array [0..1] of TPoint;
  n: Integer;
begin
  //Draw Background
    Image1.Canvas.Brush.Color := xBackgroundColor;
    Image1.Canvas.Rectangle(Image1.Left, Image1.Top, Image1.Width, Image1.Height);
  //Draw Grid
    Image1.Canvas.Pen.Color := xGridLineColor;
    Image1.Canvas.Pen.Style := psDot;
    Image1.Canvas.Pen.Width := 2;
    for n :=  0 to 100 do
    begin
      xPoint[0].x := n * 10;
      xPoint[0].y := 0;
      xPoint[1].x := n * 10;
      xPoint[1].y := 1000;
      Image1.Canvas.Polyline(xPoint);
      xPoint[0].x := 0;
      xPoint[0].y := n * 10;
      xPoint[1].x := 1000;
      xPoint[1].y := n * 10;
      Image1.Canvas.Polyline(xPoint);
    end;
  //Draw CenterLine
    Image1.Canvas.Pen.Color := xCenterLineColor;
    Image1.Canvas.Pen.Style := psSolid;
    Image1.Canvas.Pen.Width := 2;
    xPoint[0].x := cPoint.x;
    xPoint[0].y := 0;
    xPoint[1].x := cPoint.x;
    xPoint[1].y := 1000;
    Image1.Canvas.Polyline(xPoint);
    xPoint[0].x := 0;
    xPoint[0].y := cPoint.y;
    xPoint[1].x := 1000;
    xPoint[1].y := cPoint.y;
    Image1.Canvas.Polyline(xPoint);
end;

procedure TForm3.DrawPin(xPin: Integer);
var
  yPoint: Array [0..1] of TPoint;
  a, b, c, d, x, y, k, m, n, xPinLine: Integer;
begin
  xPinLine := xPins div 4;
  if xPins = 208 then
  begin
    k := 1;
    Image1.Canvas.Font.Size := 6;
  end
  else
  begin
    k := 2;
    Image1.Canvas.Font.Size := 12;
  end;
  a := k * xLeft;
  b := k * xTop;
  c := k * xRight;
  d := k * xBottom;
  m := (xPin - 1) div xPinLine;
  n := (xPin - 1) mod xPinLine + 1;
  case m of
    0: begin
         x := a + cPoint.x;
         y := cPoint.y - b;
         yPoint[0].x := x - k * 15;
         yPoint[0].y := y + k * (25 + 10 * (n - 1));
         yPoint[1].x := x;
         yPoint[1].y := y + k * (25 + 10 * (n - 1));
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x - 20, yPoint[0].y - 10, IntToStr(xPin));
       end;
    1: begin
         x := a + cPoint.x;
         y := cPoint.y - d;
         yPoint[0].x := x + k * (25 + 10 * (n - 1));
         yPoint[0].y := y + k * 15;
         yPoint[1].x := x + k * (25 + 10 * (n - 1));
         yPoint[1].y := y;
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x - 7, yPoint[0].y + 5, IntToStr(xPin));
       end;
    2: begin
         x := c + cPoint.x;
         y := cPoint.y - d;
         yPoint[0].x := x + k * 15;
         yPoint[0].y := y - k * (25 + 10 * (n - 1));
         yPoint[1].x := x;
         yPoint[1].y := y - k * (25 + 10 * (n - 1));
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x + 10, yPoint[0].y - 10, IntToStr(xPin));
       end;
    3: begin
         x := c + cPoint.x;
         y := cPoint.y - b;
         yPoint[0].x := x - k * (25 + 10 * (n - 1));
         yPoint[0].y := y - k * 15;
         yPoint[1].x := x - k * (25 + 10 * (n - 1));
         yPoint[1].y := y;
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x - 7, yPoint[0].y - 20, IntToStr(xPin));
       end;
  end;
end;

procedure TForm3.CreateDevice;
var
  xPoint: Array [0..4] of TPoint;
  yPoint: TPoint;
  k, n, z: Integer;
  xFont: TFreeTypeFont;
begin
  InitScreen;
  k := 2;
  if not((xPins = 44) or
         (xPins = 48) or
         (xPins = 64) or
         (xPins = 80) or
         (xPins = 100) or
         (xPins = 144) or
         (xPins = 208)) then
  begin
    xPins := 0;
    z := 0;
  end
  else
  begin
    z := (20 * ((xPins div 4) - 1) + 100) div 4;
    if xPins = 208 then
    begin
      k := 1;
    end;
  end;
  xTop := z;
  xBottom := -z;
  xLeft := -z;
  xRight := z;
//Draw Device
//---Body
  Image1.Canvas.Pen.Color := xItemBodyColor;
  Image1.Canvas.Pen.Style := psSolid;
  Image1.Canvas.Pen.Width := 4;
  xPoint[0].x := k * xLeft + cPoint.x;
  xPoint[0].y := k * xTop + cPoint.y;
  xPoint[1].x := k * xLeft + cPoint.x;
  xPoint[1].y := k * xBottom + cPoint.y;
  xPoint[2].x := k * xRight + cPoint.x;
  xPoint[2].y := k * xBottom + cPoint.y;
  xPoint[3].x := k * xRight + cPoint.x;
  xPoint[3].y := k * xTop + cPoint.y;
  xPoint[4].x := k * xLeft + cPoint.x;
  xPoint[4].y := k * xTop + cPoint.y;
  Image1.Canvas.Polyline(xPoint);
//---Pin
  Image1.Canvas.Pen.Color := xItemPinColor;
  Image1.Canvas.Pen.Style := psSolid;
  Image1.Canvas.Pen.Width := 4;
  for n := 1 to xPins do
  begin
    DrawPin(n);
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  xFormHeight := Form3.Height;
  xFormWidth := Form3.Width;
  cPoint.x := 500;
  cPoint.y := 500;
  xTop := 0;
  xBottom := 0;
  xLeft := 0;
  xRight := 0;
  xPins := 0;
  InitScreen;
end;

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Form1.StringGrid1.Visible := False;
end;

procedure TForm3.MenuItem1Click(Sender: TObject);
begin
  Form3.Height := xFormHeight;
  Form3.Width := xFormWidth;
end;

procedure TForm3.MenuItem4Click(Sender: TObject);
begin
  xPins := 44;
  CreateDevice;
end;

procedure TForm3.MenuItem5Click(Sender: TObject);
begin
  xPins := 48;
  CreateDevice;
end;

procedure TForm3.MenuItem6Click(Sender: TObject);
begin
  xPins := 64;
  CreateDevice;
end;

procedure TForm3.MenuItem7Click(Sender: TObject);
begin
  xPins := 80;
  CreateDevice;
end;

procedure TForm3.MenuItem8Click(Sender: TObject);
begin
  xPins := 100;
  CreateDevice;
end;

procedure TForm3.MenuItem9Click(Sender: TObject);
begin
  xPins := 144;
  CreateDevice;
end;

procedure TForm3.MenuItem10Click(Sender: TObject);
begin
  xPins := 208;
  CreateDevice;
end;

end.

