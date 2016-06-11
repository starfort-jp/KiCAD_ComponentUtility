unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ColorBox, Buttons, IniFiles;
type
  { TForm2 }
  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ColorListBox1: TColorListBox;
    ColorListBox2: TColorListBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
   private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  Unit1;

{$R *.lfm}

const
  xINIT_SECTION = 'Preset-Info';

{ TForm2 }
procedure TForm2.FormShow(Sender: TObject);
begin
//Initialize---
  //Set language
  if Unit1.xLANG = 'ja' then
  begin
    ComboBox1.ItemIndex := 1;
  end;
  if Unit1.xLANG = 'en' then
  begin
    ComboBox1.ItemIndex := 0;
  end;
  //Set Default Text Color
  ColorListBox1.Selected := Unit1.xDefaultColor;
  //Set Highlight Text Color
  ColorListBox2.Selected := Unit1.xHiliteColor;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  ComboBox1.ItemIndex := 1;
  ColorListBox1.Selected := clBlack;
  ColorListBox2.Selected := clRed;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.BitBtn3Click(Sender: TObject);
var
  xIni: TINIFile;
  Language, DefaultColor, HiliteColor: String;
  xDir: String;
begin
//Set Internal Values
  //Set language
  if ComboBox1.ItemIndex = 1 then
  begin
    Unit1.xLANG := 'ja';
  end;
  if ComboBox1.ItemIndex = 0 then
  begin
    Unit1.xLANG := 'en';
  end;
  //Set Default Text Color
  Unit1.xDefaultColor := ColorListBox1.Selected;
  //Set Highlight Text Color
  Unit1.xHiliteColor := ColorListBox2.Selected;
  //Write to INI file
  xDir := ExtractFilePath(Application.ExeName);
  xIni := TINIFile.Create(xDir + 'Preset.ini');  //Create object, specifying the ini file
  try  //Put writing INI file inside try/finally block to prevent memory leaks
    Language := Unit1.xLANG;
    DefaultColor := ColorToString(Unit1.xDefaultColor);
    HiliteColor := ColorToString(Unit1.xHiliteColor);
    //Write values to INI file
    xIni.WriteString(xINIT_SECTION, 'Language', Language);
    xIni.WriteString(xINIT_SECTION, 'DefaultColor', DefaultColor);
    xIni.WriteString(xINIT_SECTION, 'HiliteColor', HiliteColor);
    //Set parameter from read values
  finally
    xIni.Free;  // After INI file was used, must release to prevent memory leaks
  end;
//---
  Close;
end;

end.

