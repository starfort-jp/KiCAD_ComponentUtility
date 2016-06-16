//------------------------------------------------------------------------------
// title      : KiCad_LIB<>CSV Converter
// revision   : 0.3.1.25
// issue date : Jun.17, 2016
// author     : Starfort, (c) 2015-2016
// e-mail     : starfort@nifty.com
//------------------------------------------------------------------------------

program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, classes, sysutils, IniFiles, Graphics, LCLTranslator,
  csvdocument_package, lazcontrols, memdslaz, Unit2, Unit3, Unit4, Unit5, Unit6
  { you can add units after this };

{$R *.res}

const
  xINIT_SECTION = 'Preset-Info';

var
  xDir: String;
  xIni: TINIFile;
  xLanguage, xDefaultColor, xHiliteColor: String;
  xBackgroundColor, xGridLineColor, xCenterLineColor: String;
  xItemBodyColor: String;
  xItemPinColor: String;
  xItemEtypeColors: Array [1..11] of String;

begin
//Read INI File---
  xDir := ExtractFilePath(Application.ExeName);
  xIni := TINIFile.Create(xDir + 'Preset.ini');  //Create object, specifying the ini file
  try  //Put reading INI file inside try/finally block to prevent memory leaks
    //Read values from INI file
    xLanguage     := xIni.ReadString(xINIT_SECTION, 'Language', 'ja');
    xDefaultColor := xIni.ReadString(xINIT_SECTION, 'DefaultColor', 'clBlack');
    xHiliteColor  := xIni.ReadString(xINIT_SECTION, 'HiliteColor', 'clRed');
    xBackgroundColor := xIni.ReadString(xINIT_SECTION, 'BackgroundColor', 'clWhite');
    xGridLineColor := xIni.ReadString(xINIT_SECTION, 'GridLineColor', 'clNavy');
    xCenterLineColor := xIni.ReadString(xINIT_SECTION, 'CenterLineColor', 'clBlue');
    xItemBodyColor := xIni.ReadString(xINIT_SECTION, 'ItemBodyColor', 'clBlack');
    xItemPinColor := xIni.ReadString(xINIT_SECTION, 'ItemPinColor', 'clBlack');
    xItemEtypeColors[1] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors1', 'clAqua');
    xItemEtypeColors[2] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors2', 'clLime');
    xItemEtypeColors[3] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors3', 'clYellow');
    xItemEtypeColors[4] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors4', 'clGreen');
    xItemEtypeColors[5] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors5', 'clBlack');
    xItemEtypeColors[6] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors6', 'clGray');
    xItemEtypeColors[7] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors7', 'clRed');
    xItemEtypeColors[8] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors8', 'clFuchsia');
    xItemEtypeColors[9] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors9', 'clTeal');
    xItemEtypeColors[10] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors10', 'clOlive');
    xItemEtypeColors[11] := xIni.ReadString(xINIT_SECTION, 'ItemEtypeColors11', 'clSilver');
    //Set parameter from read values
    Unit1.xLANG := xLanguage;
    Unit1.xDefaultColor := StringToColor(xDefaultColor);
    Unit1.xHiliteColor := StringToColor(xHiliteColor);
    Unit3.xBackgroundColor := StringToColor(xBackgroundColor);
    Unit3.xGridLineColor := StringToColor(xGridLineColor);
    Unit3.xCenterLineColor := StringToColor(xCenterLineColor);
    Unit3.xItemBodyColor := StringToColor(xItemBodyColor);
    Unit3.xItemPinColor := StringToColor(xItemPinColor);
    Unit3.xItemEtypeColors[1] := StringToColor(xItemEtypeColors[1]);
    Unit3.xItemEtypeColors[2] := StringToColor(xItemEtypeColors[2]);
    Unit3.xItemEtypeColors[3] := StringToColor(xItemEtypeColors[3]);
    Unit3.xItemEtypeColors[4] := StringToColor(xItemEtypeColors[4]);
    Unit3.xItemEtypeColors[5] := StringToColor(xItemEtypeColors[5]);
    Unit3.xItemEtypeColors[6] := StringToColor(xItemEtypeColors[6]);
    Unit3.xItemEtypeColors[7] := StringToColor(xItemEtypeColors[7]);
    Unit3.xItemEtypeColors[8] := StringToColor(xItemEtypeColors[8]);
    Unit3.xItemEtypeColors[9] := StringToColor(xItemEtypeColors[9]);
    Unit3.xItemEtypeColors[10] := StringToColor(xItemEtypeColors[10]);
    Unit3.xItemEtypeColors[11] := StringToColor(xItemEtypeColors[11]);
  finally
    xIni.Free;  // After INI file was used, must release to prevent memory leaks
  end;
//---
  Application.Title:='KiCad_Lib<>CSV Converter';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  SetDefaultLang('', '', false);
  SetDefaultLang(Unit1.xLANG);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.

