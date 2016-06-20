//------------------------------------------------------------------------------
// title      : KiCad_LIB<>CSV Converter
// revision   : 0.3.1.25
// issue date : Jun.17, 2016
// author     : Starfort, (c) 2015-2016
// e-mail     : starfort@nifty.com
//------------------------------------------------------------------------------

unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  PairSplitter, Grids, Menus, ftfont, LCLType, math;

type

  { TForm3 }

  TForm3 = class(TForm)
    Image1: TImage;
    MenuItem1: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
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
    StringGrid2: TStringGrid;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
    xCreated: Boolean;
    xPins: Integer;
    cPoint: TPoint;
    xTop, xBottom, xLeft, xRight: Integer;
    xLibName: string;
    procedure InitScreen;
    procedure CreateDevice;
    procedure DrawDevice;
    procedure DrawPin(xEtype:String; xPin: Integer);
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
  Unit1, Unit4, Unit6;

{$R *.lfm}

{ TForm3 }

procedure TForm3.InitScreen;
var
  xPoint: Array [0..1] of TPoint;
  n: Integer;
begin
    Image1.Canvas.Clear;
  //Draw Background
    Image1.Canvas.Brush.Color := xBackgroundColor;
    Image1.Canvas.Rectangle(Image1.Left, Image1.Top, Image1.Width, Image1.Height);
  //Draw Grid
    Image1.Canvas.Pen.Color := xGridLineColor;
    Image1.Canvas.Pen.Style := psDot;
    Image1.Canvas.Pen.Width := 1;
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

procedure TForm3.DrawDevice;
var
  xPoint: Array [0..4] of TPoint;
  k, n, z, xRow, xRowMax: Integer;
  n1, n2, n3: Integer;
  xText, yText: String;
  xStringList1, xStringList2: TStringList;
begin
  xStringList1 := TStringList.Create; //Needed when using stringlist class
  xStringList2 := TStringList.Create; //Needed when using stringlist class
  for n1 := 1 to 9 do
  begin
    xStringList2.Add(IntToStr(n1));
  end;
  for n1 := 0 to 9 do
  begin
    for n2 := 1 to 9 do
    begin
      xStringList2.Add(IntToStr(n2 * 10 + n1));
    end;
  end;
  for n1 := 0 to 9 do
  begin
    for n2 := 0 to 9 do
    begin
      for n3 := 1 to 9 do
      begin
        xStringList2.Add(IntToStr(n3 * 100 + n2 * 10 + n1));
      end;
    end;
  end;
  for n := 1 to 999 do
  begin
    if StrToInt(xStringList2[n - 1]) <= xPins then
    begin
      xStringList1.Add(xStringList2[n - 1]);
    end;
  end;
//---
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
//---
  xTop := 0;
  xBottom := 0;
  xLeft := 0;
  xRight := 0;
  xRowMax := Form1.StringGrid1.RowCount;
  if xRowMax > 0 then
  begin
    for n := 0 to xRowMax  - 1 do
    begin
      xText := Form1.StringGrid1.Cells[0, n];
      if xText = 'DRAW' then
      begin
        xRow := n + 1;
        yText := Form1.StringGrid1.Cells[0, xRow];
        if yText = 'S' then
        begin
          xTop := StrToInt(Form1.StringGrid1.Cells[1, xRow]) div 10;
          xBottom := StrToInt(Form1.StringGrid1.Cells[2, xRow]) div 10;
          xLeft := StrToInt(Form1.StringGrid1.Cells[3, xRow]) div 10;
          xRight := StrToInt(Form1.StringGrid1.Cells[4, xRow]) div 10;
        end;
      end;
    end;
  end;
  if ((xTop = 0) or (xBottom = 0) or (xLeft = 0) or (xRight = 0)) then
  begin
    xTop := -z;
    xBottom := z;
    xLeft := z;
    xRight := -z;
    Form1.StringGrid1.Clear;
    Form1.StringGrid1.RowCount := xPins + 20;
    Form1.StringGrid1.ColCount := 12;
    Unit4.WriteHeader;
    Form1.StringGrid1.Cells[0, 14] := 'DRAW';
    Form1.StringGrid1.Cells[0, 15] := 'S';
    Form1.StringGrid1.Cells[1, 15] := IntToStr(xTop * 10);
    Form1.StringGrid1.Cells[2, 15] := IntToStr(xBottom * 10);
    Form1.StringGrid1.Cells[3, 15] := IntToStr(xLeft * 10);
    Form1.StringGrid1.Cells[4, 15] := IntToStr(xRight * 10);
    Form1.StringGrid1.Cells[5, 15] := '0';
    Form1.StringGrid1.Cells[6, 15] := '1';
    Form1.StringGrid1.Cells[7, 15] := '10';
    Form1.StringGrid1.Cells[8, 15] := 'N';
    for n := 16 to xPins + 15 do
    begin
      Form1.StringGrid1.Cells[0, n] := 'X';
      Form1.StringGrid1.Cells[2, n] := xStringList1[n - 16];
      Form1.StringGrid1.Cells[7, n] := '40';
      Form1.StringGrid1.Cells[8, n] := '40';
      Form1.StringGrid1.Cells[9, n] := '1';
      Form1.StringGrid1.Cells[10, n] := '1';
    end;
    Unit4.WriteFooter(xPins + 16);
  end;
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
//---
  xStringList1.Free; //Release memory used by stringlist instance
  xStringList2.Free; //Release memory used by stringlist instance
end;

procedure TForm3.DrawPin(xEtype:String; xPin: Integer);
var
  yPoint: Array [0..1] of TPoint;
  a, b, c, d, x, y, k, m, n, xPinLine: Integer;
  xPosX, xPosY, xLen, xDir: String;
  xPinAttr: TPinAttr;
begin
  case xEtype of
  'I': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[1];
       end;
  'O': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[2];
       end;
  'B': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[3];
       end;
  'T': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[4];
       end;
  'P': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[5];
       end;
  'U': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[6];
       end;
  'W': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[7];
       end;
  'w': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[8];
       end;
  'C': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[9];
       end;
  'E': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[10];
       end;
  'N': begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[11];
       end
  else begin
         Image1.Canvas.Pen.Color := xItemEtypeColors[6];  //Set as "Undefined"
       end;
  end;
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
  if xPinLine > 0 then
  begin
    m := (xPin - 1) div xPinLine;
    n := (xPin - 1) mod xPinLine + 1;
  end
  else
  begin
    m := -1;
    n := 0;
  end;
  xPosX := StringGrid2.Cells[1, xPin];
  xPosY := StringGrid2.Cells[2, xPin];
  xLen := StringGrid2.Cells[3, xPin];
  xDir := StringGrid2.Cells[4, xPin];
  case m of
    0: begin
         if ((xPosX <> '') and (xPosY <> '') and (xLen <> '') and(xDir <> '')) then
         begin
           xPinAttr := Unit4.GetPinPosition(xPosX, xPosY, xLen, XDir);
           yPoint[0].x := k * xPinAttr.StartPosX div 10 + cPoint.x;
           yPoint[0].y := - k * xPinAttr.StartPosY div 10 + cPoint.y;
           yPoint[1].x := k * xPinAttr.EndPosX div 10 + cPoint.x;
           yPoint[1].y := - k * xPinAttr.EndPosY div 10 + cPoint.y;
         end
         else
         begin
           x := cPoint.x - a;
           y := cPoint.y + b;
           yPoint[0].x := x - k * 15;
           yPoint[0].y := y + k * (25 + 10 * (n - 1));
           yPoint[1].x := x;
           yPoint[1].y := y + k * (25 + 10 * (n - 1));
           StringGrid2.Cells[1, xPin] := IntToStr(10 * (yPoint[0].x - cPoint.x) div k);
           StringGrid2.Cells[2, xPin] := IntToStr(10 * (cPoint.y - yPoint[0].y) div k);
           StringGrid2.Cells[3, xPin] := IntToStr(10 * (yPoint[1].x - yPoint[0].x) div k);
           StringGrid2.Cells[4, xPin] := 'R';
         end;
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x - 20, yPoint[0].y - 10, IntToStr(xPin));
       end;
    1: begin
         if ((xPosX <> '') and (xPosY <> '') and (xLen <> '') and(xDir <> '')) then
         begin
           xPinAttr := Unit4.GetPinPosition(xPosX, xPosY, xLen, XDir);
           yPoint[0].x := k * xPinAttr.StartPosX div 10 + cPoint.x;
           yPoint[0].y := - k * xPinAttr.StartPosY div 10 + cPoint.y;
           yPoint[1].x := k * xPinAttr.EndPosX div 10 + cPoint.x;
           yPoint[1].y := - k * xPinAttr.EndPosY div 10 + cPoint.y;
         end
         else
         begin
           x := cPoint.x - a;
           y := cPoint.y + d;
           yPoint[0].x := x + k * (25 + 10 * (n - 1));
           yPoint[0].y := y + k * 15;
           yPoint[1].x := x + k * (25 + 10 * (n - 1));
           yPoint[1].y := y;
           StringGrid2.Cells[1, xPin] := IntToStr(10 * (yPoint[0].x - cPoint.x) div k);
           StringGrid2.Cells[2, xPin] := IntToStr(10 * (cPoint.y - yPoint[0].y) div k);
           StringGrid2.Cells[3, xPin] := IntToStr(10 * (yPoint[0].y - yPoint[1].y) div k);
           StringGrid2.Cells[4, xPin] := 'U';
         end;
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x - 7, yPoint[0].y + 5, IntToStr(xPin));
       end;
    2: begin
         if ((xPosX <> '') and (xPosY <> '') and (xLen <> '') and(xDir <> '')) then
         begin
           xPinAttr := Unit4.GetPinPosition(xPosX, xPosY, xLen, XDir);
           yPoint[0].x := k * xPinAttr.StartPosX div 10 + cPoint.x;
           yPoint[0].y := - k * xPinAttr.StartPosY div 10 + cPoint.y;
           yPoint[1].x := k * xPinAttr.EndPosX div 10 + cPoint.x;
           yPoint[1].y := - k * xPinAttr.EndPosY div 10 + cPoint.y;
         end
         else
         begin
           x := cPoint.x - c;
           y := cPoint.y + d;
           yPoint[0].x := x + k * 15;
           yPoint[0].y := y - k * (25 + 10 * (n - 1));
           yPoint[1].x := x;
           yPoint[1].y := y - k * (25 + 10 * (n - 1));
           StringGrid2.Cells[1, xPin] := IntToStr(10 * (yPoint[0].x - cPoint.x) div k);
           StringGrid2.Cells[2, xPin] := IntToStr(10 * (cPoint.y - yPoint[0].y) div k);
           StringGrid2.Cells[3, xPin] := IntToStr(10 * (yPoint[0].x - yPoint[1].x) div k);
           StringGrid2.Cells[4, xPin] := 'L';
         end;
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x + 10, yPoint[0].y - 10, IntToStr(xPin));
       end;
    3: begin
         if ((xPosX <> '') and (xPosY <> '') and (xLen <> '') and(xDir <> '')) then
         begin
           xPinAttr := Unit4.GetPinPosition(xPosX, xPosY, xLen, XDir);
           yPoint[0].x := k * xPinAttr.StartPosX div 10 + cPoint.x;
           yPoint[0].y := - k * xPinAttr.StartPosY div 10 + cPoint.y;
           yPoint[1].x := k * xPinAttr.EndPosX div 10 + cPoint.x;
           yPoint[1].y := - k * xPinAttr.EndPosY div 10 + cPoint.y;
         end
         else
         begin
           x := cPoint.x - c;
           y := cPoint.y + b;
           yPoint[0].x := x - k * (25 + 10 * (n - 1));
           yPoint[0].y := y - k * 15;
           yPoint[1].x := x - k * (25 + 10 * (n - 1));
           yPoint[1].y := y;
           StringGrid2.Cells[1, xPin] := IntToStr(10 * (yPoint[0].x - cPoint.x) div k);
           StringGrid2.Cells[2, xPin] := IntToStr(10 * (cPoint.y - yPoint[0].y) div k);
           StringGrid2.Cells[3, xPin] := IntToStr(10 * (yPoint[1].y - yPoint[0].y) div k);
           StringGrid2.Cells[4, xPin] := 'D';
         end;
         Image1.Canvas.Polyline(yPoint);
         Image1.Canvas.TextOut(yPoint[0].x - 7, yPoint[0].y - 20, IntToStr(xPin));
       end;
  end;
end;

procedure TForm3.CreateDevice;
var
  n: Integer;
begin
  xCreated := False;
  Form3.Height := xFormHeight;
  Form3.Width := xFormWidth;
  xLibName := '~';
//Prepare SpreadSheet
  StringGrid1.Clear;
  StringGrid2.Clear;
  StringGrid1.RowCount := xPins + 1;
  StringGrid2.RowCount := xPins + 1;
  for n := 1 to xPins do
  begin
    StringGrid1.Cells[0, n] := IntToStr(n);
    StringGrid1.Cells[1, n] := '~';
    StringGrid1.Cells[2, n] := 'U';
  end;
//---
  Form1.StringGrid1.Clear;
  InitScreen;
//---Device
  DrawDevice;
//---Pin
  Image1.Canvas.Pen.Color := xItemPinColor;
  Image1.Canvas.Pen.Style := psSolid;
  Image1.Canvas.Pen.Width := 4;
  for n := 1 to xPins do
  begin
    DrawPin('', n);
  end;
  Form6.Show;
  xCreated := True;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  xLibName := '~';
  if (Form1.StringGrid1.RowCount > 1) and (Form1.StringGrid1.ColCount > 5) then
  begin
    xLibName := Form1.StringGrid1.Cells[1, 5];
  end;
  xFormHeight := 1002;
  xFormWidth := 1279;
  Form3.Height := xFormHeight;
  Form3.Width := xFormWidth;
  cPoint.x := 500;
  cPoint.y := 500;
  xTop := 0;
  xBottom := 0;
  xLeft := 0;
  xRight := 0;
  xPins := 0;
  InitScreen;
  xCreated := True;
end;

procedure TForm3.MenuItem11Click(Sender: TObject);
begin

end;

procedure TForm3.MenuItem12Click(Sender: TObject);
begin
  Form6.Show;
end;

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  n, m, xMaxRow, xStart, xEnd: Integer;
  xText, xString: String;
//  xMemoryStream: TMemoryStream;
  xFilePath: String;
begin
//Write back to Form1.StringGrid1
  xStart := 0;
  xEnd := 0;
  for n := 0 to Form1.StringGrid1.RowCount  - 1 do
  begin
    xText := Form1.StringGrid1.Cells[0, n];
    if xText = 'DRAW' then
    begin
      xStart := n;
    end;
    if xText = 'ENDDRAW' then
    begin
      xEnd := n;
    end;
  end;
  xMaxRow := xEnd - xStart - 2;
  for n := 1 to xMaxRow do
  begin
    m := StrToInt(Form1.StringGrid1.Cells[2, xStart + 1 + n]);
    xString := StringReplace(StringGrid1.Cells[1, m], '"', '', [rfReplaceAll, rfIgnoreCase]);
    Form1.StringGrid1.Cells[1, xStart + 1 + n] := Trim(xString);
//    Form1.StringGrid1.Cells[1, xStart + 1 + n] := StringGrid1.Cells[1, m];
    Form1.StringGrid1.Cells[Form1.StringGrid1.ColCount - 1, xStart + 1 + n] := StringGrid1.Cells[2, m];
    Form1.StringGrid1.Cells[3, xStart + 1 + n] := StringGrid2.Cells[1, m];
    Form1.StringGrid1.Cells[4, xStart + 1 + n] := StringGrid2.Cells[2, m];
    Form1.StringGrid1.Cells[5, xStart + 1 + n] := StringGrid2.Cells[3, m];
    Form1.StringGrid1.Cells[6, xStart + 1 + n] := StringGrid2.Cells[4, m];
  end;
//---
{
  xMemoryStream := TMemoryStream.Create;
  try
    Form1.StringGrid1.SaveToCSVStream(xMemoryStream);
    Form1.xStringList.LoadFromStream(xMemoryStream);
  finally
    xMemoryStream.Free;
  end;
}
  Form1.StringGrid1.SaveToCSVFile('_temp.csv');
  Form1.xStringList.LoadFromFile('_temp.csv');
  DeleteFile('_temp.csv');
  Form1.StringGrid1.Visible := False;
  Form1.MarkLines(lxStrings);
  Form1.DisplayRichMemo(lxStrings);
  Form1.ConvertToLIB;
  xFilePath := ExtractFilePath(Form1.Edit1.Text);
  Form1.Edit1.Text := xFilePath + xLibName + '.lib';
  xLibName := '';
  xCreated := False;
end;

procedure TForm3.FormResize(Sender: TObject);
var
  xWidth, xHeight: Integer;
begin
if xCreated = True then
  begin
    xWidth  := Form3.Width - 277;
    xHeight := Form3.Height;
    if xWidth > xHeight then
    begin
      Form3.Width := xHeight + 277;
    end
    else
    begin
      Form3.Height := xWidth;
    end;
  end;
end;

procedure TForm3.MenuItem1Click(Sender: TObject);
begin
  xCreated := False;
  Form3.Height := xFormHeight;
  Form3.Width := xFormWidth;
  xCreated := True;
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

procedure TForm3.StringGrid1KeyPress(Sender: TObject; var Key: char);
var
  xText: String;
  n: Integer;
begin
  if Key = Char(VK_RETURN) then
  begin
    n := StringGrid1.Row;
    xText := StringGrid1.Cells[2, n];
    if not ((xText = 'I') or (xText = 'O') or (xText = 'B') or (xText = 'T') or
            (xText = 'P') or (xText = 'U') or (xText = 'W') or (xText = 'w') or
            (xText = 'C') or (xText = 'E') or (xText = 'N')) then
    begin
      xText := 'U';
      StringGrid1.Cells[2, n] := xText;
    end;
    DrawPin(xText, n);
  end;
end;

end.

