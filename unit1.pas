unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, Grids, RichMemo, lazutf8, Unit2, Unit3, memds, CSVDocument;//DefaultTranslator, LCLTranslator;
type
  { TForm1 }
  TLineItem = (lxStrings, lxCSV, lxLIB, lxMemo);
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    Edit1: TEdit;
    MemDataset1: TMemDataset;
    OpenDialog1: TOpenDialog;
    RichMemo1: TRichMemo;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    xStringList: TStringList;
    xCSVStringList: TStringList;
    xLIBStringList: TStringList;
    xMemoStringList: TStringList;
    xBitArray: Array [0..65535] of Boolean;
    xExt: String;
    procedure MarkLines(xLineItem: TLineItem);
    procedure DisplayRichMemo(xLineItem: TLineItem);
  public
    { public declarations }
    procedure ConvertToCSV;
    procedure ConvertToLIB;
  end;

var
  Form1: TForm1;
  xLANG: String;
  xDefaultColor, xHiliteColor: TColor;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormShow(Sender: TObject);
var
  n: Integer;
begin
  StringGrid1.Visible := False;
  xStringList := TStringList.Create; //Needed when using stringlist class
  xCSVStringList := TStringList.Create;  //Needed when using stringlist class
  xLIBStringList := TStringList.Create;  //Needed when using stringlist class
  xMemoStringList := TStringList.Create;  //Needed when using stringlist class
  for n := 0 to 65535 do
  begin
    xBitArray[n] := False;
  end;
  xExt := '';
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  xStringList.Free; //Release memory used by stringlist instance
  xCSVStringList.Free;  //Release memory used by stringlist instance
  xLIBStringList.Free;  //Release memory used by stringlist instance
  xMemoStringList.Free;  //Release memory used by stringlist instance
end;

procedure TForm1.MarkLines(xLineItem: TLineItem);
var
  xLineNumber, xLp: Integer;
  xLine, xCheckString1, xCheckString2, xChr: String;
  xEnableLine, xOnException: Boolean;
begin
//Mark lines by validity check
//Initialize---
  for xLp := 0 to 65535 do
  begin
    xBitArray[xLp] := False;
  end;
  xEnableLine := False;
  xOnException := False;
  xLp := 0;
  xCheckString1 := '#';
  xCheckString2 := '$';
  case xLineItem of  //If xLineItem is 'lxMemo' then skip(Using displayed strings)
    lxStrings:
      begin
        xMemoStringList.Clear;
        xLineNumber := xStringList.Count;
        for xLp := 0 to (xLineNumber - 1) do
        begin
          xMemoStringList.Add(xStringList[xLp]);
        end;
      end;
    lxCSV:
      begin
        xMemoStringList.Clear;
        xLineNumber := xCSVStringList.Count;
        for xLp := 0 to (xLineNumber - 1) do
        begin
          xMemoStringList.Add(xCSVStringList[xLp]);
        end;
      end;
    lxLIB:
      begin
        xMemoStringList.Clear;
        xLineNumber := xLIBStringList.Count;
        for xLp := 0 to (xLineNumber - 1) do
        begin
          xMemoStringList.Add(xLIBStringList[xLp]);
        end;
      end;
  end;
//---
//Main---
  xLineNumber := xMemoStringList.Count;
  for xLp := 1 to (xLineNumber- 1) do
  begin
    xEnableLine := true;
    xLine := StringReplace(xMemoStringList[xLp], '"""', '', [rfReplaceAll, rfIgnoreCase]);
    xChr := LeftStr(xLine, 1);
    if xChr = xCheckString1 then
    begin
      xEnableLine := False;
    end
    else
    begin
      if xChr = xCheckString2 then
      begin
        xEnableLine := False;
        xOnException := not(xOnException);
      end
      else
      begin
        if xOnException = true then
        begin
          xEnableLine := False;
        end;
      end;
    end;
    xBitArray[xLp] := xEnableLine;
  end;
//---
end;

procedure TForm1.DisplayRichMemo(xLineItem: TLineItem);
var
  xLp, xLineNumber: Integer;
  a, b, c: Integer;
begin
//Draw RichMemo
//Initialize---
  case xLineItem of  //If xLineItem is 'lxMemo' then skip(for Redraw)
    lxStrings:
      begin
        xMemoStringList.Clear;
        xLineNumber := xStringList.Count;
        for xLp := 0 to (xLineNumber - 1) do
        begin
          xMemoStringList.Add(xStringList[xLp]);
        end;
      end;
    lxCSV:
      begin
        xMemoStringList.Clear;
        xLineNumber := xCSVStringList.Count;
        for xLp := 0 to (xLineNumber - 1) do
        begin
          xMemoStringList.Add(xCSVStringList[xLp]);
        end;
      end;
    lxLIB:
      begin
        xMemoStringList.Clear;
        xLineNumber := xLIBStringList.Count;
        for xLp := 0 to (xLineNumber - 1) do
        begin
          xMemoStringList.Add(xLIBStringList[xLp]);
        end;
      end;
  end;
//---
//Main---
  RichMemo1.Clear;
  RichMemo1.Font.Color := xDefaultColor;
  xLineNumber := xMemoStringList.Count;
  for xLp := 0 to (xLineNumber - 1) do
  begin
    RichMemo1.Lines.Add(xMemoStringList[xLp]);
    a := Length(RichMemo1.Lines.Text);
    b := Length(xMemoStringList[xLp]);
    c := (a - b) - 1;
    if xBitArray[xLp] = False then
    begin
      RichMemo1.SetRangeColor(c, b, xHiliteColor);
    end;
  end;
//---
end;

procedure TForm1.ConvertToCSV;
var
  xLineNumber, xLp, xChNumber, xCp: Integer;
  xOldString, xNewString, xString, xCh, xPre, xSuf: String;
  xException: Boolean;
begin
//Convert To CSV
  MarkLines(lxMemo);  //Mark keeping displayed lines as 'False'
  xCSVStringList.Clear;
  xLineNumber := xMemoStringList.Count;
  for xLp := 0 to (xLineNumber - 1) do
  begin
    xNewString := xMemoStringList[xLp];
    if xBitArray[xLp] = True then
    begin
      xOldString := StringReplace(xNewString, '"""', '"', [rfReplaceAll, rfIgnoreCase]);
      xString := StringReplace(xOldString, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
      xException := false;
      xChNumber := Length(xString);
      for xCp := 0 to (xChNumber - 1) do
      begin
        xCh := Copy(xString, xCp, 1);
        if xCh = '"' then
        begin
          xException := not(xException);
        end;
        if (xCh = ' ') and (xException = False) then
        begin
          Delete(xString, xCp, 1);
          Insert(',', xString, xCp);
        end;
      end;
      xNewString := StringReplace(xString, '"', '"""' ,[rfReplaceAll, rfIgnoreCase]);
    end
    else
    begin
      xPre := LeftStr(xNewString, 3);
      xSuf := RightStr(xNewString, 3);
      if not((xPre = '"""') and (xSuf = '"""')) then
      begin
        xNewString := '"""' + xNewString + '"""';
      end;
    end;
    xCSVStringList.Add(xNewString);
  end;
  xExt := '.csv';
  DisplayRichMemo(lxCSV);  //Display CSV strings
end;

procedure TForm1.ConvertToLIB;
var
  xLineNumber, xLp, xChNumber, xCp: Integer;
  xOldString, xNewString, xString, xCh: String;
  xException: Boolean;
begin
//Convert To KiCAD LIB
  MarkLines(lxMemo);  //Mark keeping displayed lines as 'False'
  xLIBStringList.Clear;
  xLineNumber := xMemoStringList.Count;
  for xLp := 0 to (xLineNumber - 1) do
  begin
    xString := xMemoStringList[xLp];
    xOldString := StringReplace(xString, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
    xException := False;
    xChNumber := Length(xOldString);
    for xCp := xChNumber downto 0 do
    begin
      xCh := Copy(xOldString, xCp, 1);
      if xCh <> ',' then
      begin
        xException := True;
      end;
      if (xCh = ',') and (xException = False) then
      begin
        Delete(xOldString, xCp, 1);
      end;
    end;
    if xBitArray[xLp] = True then
    begin
      xNewString := StringReplace(xOldString, '"""', '"', [rfReplaceAll, rfIgnoreCase]);
      xException := False;
      xChNumber := Length(xNewString);
      for xCp := 0 to (xChNumber - 1) do
      begin
        xCh := Copy(xNewString, xCp, 1);
        if xCh = '"' then
        begin
          xException := not(xException);
        end;
        if (xCh = ',') and (xException = False) then
        begin
          Delete(xNewString, xCp, 1);
          Insert(' ', xNewString, xCp);
        end;
      end;
    end
    else
    begin
      xNewString := StringReplace(xOldString, '"""', '', [rfReplaceAll, rfIgnoreCase]);
    end;
    xLIBStringList.Add(xNewString);
  end;
  xExt := '.lib';
  DisplayRichMemo(lxLIB);  //Display LIB strings
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
//Load from file
  if FileExists(Edit1.Text) then
  begin
    OpenDialog1.FileName := Edit1.Text;
    OpenDialog1.InitialDir := ExtractFilePath(Edit1.Text);
    OpenDialog1.DefaultExt := ExtractFileExt(Edit1.Text);
    xExt := ExtractFileExt(Edit1.Text);
  end
  else
  begin
    OpenDialog1.InitialDir := GetCurrentDir;
    xExt := '';
  end;
  if OpenDialog1.Execute then
  begin
    Edit1.Text := OpenDialog1.FileName;
    xExt := ExtractFileExt(Edit1.Text);
    if FileExists(Edit1.Text) then
    begin
      xStringList.Clear;
      try  // Embed block to handle errors gracefully
        xStringList.LoadFromFile(Edit1.Text);  // Load the contents of the textfile completely in memory
      except  // If error, show message with reason
        on xErrorIO: EInOutError do
        begin
          ShowMessage('File handling error occurred. Details: '+ xErrorIO.Message);
        end;
      end;
      MarkLines(lxStrings);  //Mark keeping read lines as 'False'
      DisplayRichMemo(lxStrings);  //Display read strings
    end;
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  xLineNumber: Integer;
  xFileName, yExt: String;
begin
//Save to file
  xLineNumber := xMemoStringList.Count;
  if xLineNumber > 0 then
  begin
    xFileName := ChangeFileExt(Edit1.Text, xExt);
    SaveDialog1.FileName := xFileName;
    if SaveDialog1.Execute then
    begin
      Edit1.Text := SaveDialog1.FileName;
      yExt := ExtractFileExt(Edit1.Text);
      if yExt = '.csv' then
      begin
        ConvertToCSV;
      end;
      if yExt = '.lib' then
      begin
        ConvertToLIB;
      end;
      try  // Embed block to handle errors gracefully
        xMemoStringList.SaveToFile(Edit1.Text);  // Save displayed contents to disk
      except  // If error, show message with reason
        on xErrorIO: EInOutError do
        begin
          ShowMessage('File handling error occurred. Details: '+ xErrorIO.Message);
        end;
      end;
    end;
  end
  else
  begin
    ShowMessage('Warning: Nothing to save.');
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  xLineNumber, xLp, xChNumber, xCp: Integer;
  xOldString, xNewString, xString, xCh, xPre, xSuf: String;
  xException: Boolean;
begin
  ConvertToCSV;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  xLineNumber, xLp, xChNumber, xCp: Integer;
  xOldString, xNewString, xString, xCh: String;
  xException: Boolean;
begin
  ConvertToLIB;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  xStringList.Clear;
  MarkLines(lxStrings);  //Mark keeping read lines as 'False'
  DisplayRichMemo(lxStrings);  //Display read strings
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
var
  n, m, xMaxRow, xStart, xEnd: Integer;
  xText: String;
  xEnable: Boolean;
  xParser: TCSVParser;
  xRowOffset: Integer;
  xMemoryStream: TMemoryStream;
begin
  ConvertToCSV;
//---Fill StringGrid using CSV Parser
  StringGrid1.Visible := True;
  StringGrid1.BeginUpdate;
  StringGrid1.Clear;  // Reset the grid:
  xMemoryStream := TMemoryStream.Create;
  xParser := TCSVParser.Create;
  xMemoStringList.SaveToStream(xMemoryStream);
  try
    xParser.Delimiter := ',';
    xParser.SetSource(xMemoryStream);
    while xParser.ParseNextCell do
    begin
     if StringGrid1.Columns.Enabled then
      begin
        if StringGrid1.Columns.VisibleCount < xParser.CurrentCol + 1 then
        begin
          StringGrid1.Columns.Add;
        end;
      end
      else
      begin
        if StringGrid1.ColCount < xParser.CurrentCol + 1 then
        begin
          StringGrid1.ColCount := xParser.CurrentCol + 1;
        end;
      end;
       if StringGrid1.RowCount < xParser.CurrentRow + 1 then
      begin
        StringGrid1.RowCount := xParser.CurrentRow + 1;
      end;
      StringGrid1.Cells[xParser.CurrentCol, xParser.CurrentRow] := xParser.CurrentCellText; // Actual data import into grid cell, minding fixed rows and header
    end;
    if StringGrid1.Columns.Enabled then      // Now we know the widest row in the import, we can snip the grid's columns if necessary.
    begin
      while StringGrid1.Columns.VisibleCount > xParser.MaxColCount do
      begin
        StringGrid1.Columns.Delete(StringGrid1.Columns.Count - 1);
      end;
    end
    else
    begin
      if StringGrid1.ColCount > xParser.MaxColCount then
      begin
        StringGrid1.ColCount := xParser.MaxColCount;
      end;
    end;
  finally
    xParser.Free;
    xMemoryStream.Free;
    StringGrid1.EndUpdate;
  end;
//---Fill Form3 StringGrid
  xStart := 0;
  xEnd := 0;
  for n := 0 to StringGrid1.RowCount  - 1 do
  begin
    xText := StringGrid1.Cells[0, n];
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
  if xMaxRow < 0 then
  begin
    xMaxRow := 0;
  end;
  Form3.Show;
  Form3.StringGrid1.AutoSizeColumns;
  Form3.StringGrid1.Update;
  Form3.StringGrid1.Clear;
  Form3.StringGrid1.RowCount := xMaxRow + 1;
  Form3.StringGrid1.Cells[0, 0] := 'No.';
  Form3.StringGrid1.Cells[1, 0] := 'Name';
  Form3.StringGrid1.Cells[2, 0] := 'Type';
  for n := 1 to xMaxRow do
  begin
    Form3.StringGrid1.Cells[0, n] := IntToStr(n);
    m := StrToInt(StringGrid1.Cells[2, xStart + 1 + n]);
    Form3.StringGrid1.Cells[1, m] := StringGrid1.Cells[1, xStart + 1 + n];
    Form3.StringGrid1.Cells[2, m] := StringGrid1.Cells[StringGrid1.ColCount - 1, xStart + 1 + n];
  end;
//---Draw Test
  Form3.xPins := xMaxRow;
  Form3.CreateDevice;
  //---Pin
  Form3.Image1.Canvas.Pen.Color := clBlack;
  Form3.Image1.Canvas.Pen.Style := psSolid;
  Form3.Image1.Canvas.Pen.Width := 4;
  for n := 1 to xMaxRow do
  begin
    xText := Form3.StringGrid1.Cells[2, n];
    case xText of
    'I': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[1];
         end;
    'O': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[2];
         end;
    'B': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[3];
         end;
    'T': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[4];
         end;
    'P': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[5];
         end;
    'U': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[6];
         end;
    'W': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[7];
         end;
    'w': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[8];
         end;
    'C': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[9];
         end;
    'E': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[10];
         end;
    'N': begin
           Form3.Image1.Canvas.Pen.Color := Unit3.xItemEtypeColors[11];
         end;
    end;
    Form3.DrawPin(n);
  end;
end;

end.

