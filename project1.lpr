program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, classes, sysutils, IniFiles, Graphics, LCLTranslator, Unit2
  { you can add units after this };

{$R *.res}

const
  xINIT_SECTION = 'Preset-Info';

var
  xIni: TINIFile;
  Language, DefaultColor, HiliteColor: String;
  xDir: String;
begin
//Read INI File---
  xDir := ExtractFilePath(Application.ExeName);
  xIni := TINIFile.Create(xDir + 'Preset.ini');  //Create object, specifying the ini file
  try  //Put reading INI file inside try/finally block to prevent memory leaks
    //Read values from INI file
    Language     := xIni.ReadString(xINIT_SECTION, 'Language', 'ja');
    DefaultColor := xIni.ReadString(xINIT_SECTION, 'DefaultColor', 'clBlack');
    HiliteColor  := xIni.ReadString(xINIT_SECTION, 'HiliteColor', 'clRed');
    //Set parameter from read values
    Unit1.xLANG := Language;
    Unit1.xDefaultColor := StringToColor(DefaultColor);
    Unit1.xHiliteColor := StringToColor(HiliteColor);
  finally
    xIni.Free;  // After INI file was used, must release to prevent memory leaks
  end;
//---
  Application.Title:='KiCAD_Lib<>CSV Converter';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  SetDefaultLang('', '', false);
  SetDefaultLang(Unit1.xLANG);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.

