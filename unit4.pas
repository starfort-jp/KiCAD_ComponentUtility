//------------------------------------------------------------------------------
// title      : KiCad_LIB<>CSV Converter
// revision   : 0.3.1.25
// issue date : Jun.17, 2016
// author     : Starfort, (c) 2015-2016
// e-mail     : starfort@nifty.com
//------------------------------------------------------------------------------

unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Unit1, Unit3;

type
  TPinAttr = record
		StartPosX, StartPosY,	EndPosX, EndPosY : Integer;
	end;

function GetCountryString(CountryCode: String):String;
function GetCodeString(CountryString: String):String;
function GetPinPosition(PosX, PosY, xLen, xDir: String): TPinAttr;
procedure WriteHeader;
procedure WriteFooter(xLine: Integer);

implementation

function GetCountryString(CountryCode: String):String;
var
  xStr: String;
begin
  case CountryCode of
    'af': begin xStr := 'Afrikaans'; end;
    'sq': begin xStr := 'Albanian'; end;
    'am': begin xStr := 'Amharic'; end;
    'ar': begin xStr := 'Arabic'; end;
    'hy': begin xStr := 'Armenian'; end;
    'as': begin xStr := 'Assamese'; end;
    'az': begin xStr := 'Azeri'; end;
    'eu': begin xStr := 'Basque'; end;
    'be': begin xStr := 'Belarusian'; end;
    'bn': begin xStr := 'Bengali'; end;
    'bs': begin xStr := 'Bosnian'; end;
    'bg': begin xStr := 'Bulgarian'; end;
    'my': begin xStr := 'Burmese'; end;
    'ca': begin xStr := 'Catalan'; end;
    'zh': begin xStr := 'Chinese'; end;
    'hr': begin xStr := 'Croatian'; end;
    'cs': begin xStr := 'Czech'; end;
    'da': begin xStr := 'Danish'; end;
    'dv': begin xStr := 'Maldivian'; end;
    'nl': begin xStr := 'Dutch'; end;
    'en': begin xStr := 'English'; end;
    'et': begin xStr := 'Estonian'; end;
    'fo': begin xStr := 'Faroese'; end;
    'fa': begin xStr := 'Farsi'; end;
    'fi': begin xStr := 'Finnish'; end;
    'fr': begin xStr := 'French'; end;
    'mk': begin xStr := 'Macedonia'; end;
    'gd': begin xStr := 'Gaelic'; end;
    'gl': begin xStr := 'Galician'; end;
    'ka': begin xStr := 'Georgian'; end;
    'de': begin xStr := 'German'; end;
    'el': begin xStr := 'Greek'; end;
    'gn': begin xStr := 'Guarani'; end;
    'gu': begin xStr := 'Gujarati'; end;
    'he': begin xStr := 'Hebrew'; end;
    'hi': begin xStr := 'Hindi'; end;
    'hu': begin xStr := 'Hungarian'; end;
    'is': begin xStr := 'Icelandic'; end;
    'id': begin xStr := 'Indonesian'; end;
    'it': begin xStr := 'Italian'; end;
    'ja': begin xStr := 'Japanese'; end;
    'kn': begin xStr := 'Kannada'; end;
    'ks': begin xStr := 'Kashmiri'; end;
    'kk': begin xStr := 'Kazakh'; end;
    'km': begin xStr := 'Khmer'; end;
    'ko': begin xStr := 'Korean'; end;
    'lo': begin xStr := 'Lao'; end;
    'la': begin xStr := 'Latin'; end;
    'lv': begin xStr := 'Latvian'; end;
    'lt': begin xStr := 'Lithuanian'; end;
    'ms': begin xStr := 'Malay'; end;
    'ml': begin xStr := 'Malayalam'; end;
    'mt': begin xStr := 'Maltese'; end;
    'mi': begin xStr := 'Maori'; end;
    'mr': begin xStr := 'Marathi'; end;
    'mn': begin xStr := 'Mongolian'; end;
    'ne': begin xStr := 'Nepali'; end;
    'nb': begin xStr := 'Norwegian-Bokml'; end;
    'nn': begin xStr := 'Norwegian-Nynorsk'; end;
    'or': begin xStr := 'Oriya'; end;
    'pl': begin xStr := 'Polish'; end;
    'pt': begin xStr := 'Portuguese'; end;
    'pa': begin xStr := 'Punjabi'; end;
    'rm': begin xStr := 'Raeto-Romance'; end;
    'ro': begin xStr := 'Romanian'; end;
    'ru': begin xStr := 'Russian'; end;
    'sa': begin xStr := 'Sanskrit'; end;
    'sr': begin xStr := 'Serbian'; end;
    'tn': begin xStr := 'Setsuana'; end;
    'sd': begin xStr := 'Sindhi'; end;
    'si': begin xStr := 'Sinhalese'; end;
    'sk': begin xStr := 'Slovak'; end;
    'sl': begin xStr := 'Slovenian'; end;
    'so': begin xStr := 'Somali'; end;
    'sb': begin xStr := 'Sorbian'; end;
    'es': begin xStr := 'Spanish'; end;
    'sw': begin xStr := 'Swahili'; end;
    'sv': begin xStr := 'Swedish'; end;
    'tg': begin xStr := 'Tajik'; end;
    'ta': begin xStr := 'Tamil'; end;
    'tt': begin xStr := 'Tatar'; end;
    'te': begin xStr := 'Telugu'; end;
    'th': begin xStr := 'Thai'; end;
    'bo': begin xStr := 'Tibetan'; end;
    'ts': begin xStr := 'Tsonga'; end;
    'tr': begin xStr := 'Turkish'; end;
    'tk': begin xStr := 'Turkmen'; end;
    'uk': begin xStr := 'Ukrainian'; end;
    'ur': begin xStr := 'Urdu'; end;
    'uz': begin xStr := 'Uzbek'; end;
    'vi': begin xStr := 'Vietnamese'; end;
    'cy': begin xStr := 'Welsh'; end;
    'xh': begin xStr := 'Xhosa'; end;
    'yi': begin xStr := 'Yiddish'; end;
    'zu': begin xStr := 'Zulu'; end;
  end;
  Result := xStr;
end;

function GetCodeString(CountryString: String): String;
var
  xStr: String;
begin
  case CountryString of
    'Afrikaans': begin xStr := 'af'; end;
    'Albanian': begin xStr := 'sq'; end;
    'Amharic': begin xStr := 'am'; end;
    'Arabic': begin xStr := 'ar'; end;
    'Armenian': begin xStr := 'hy'; end;
    'Assamese': begin xStr := 'as'; end;
    'Azeri': begin xStr := 'az'; end;
    'Basque': begin xStr := 'eu'; end;
    'Belarusian': begin xStr := 'be'; end;
    'Bengali': begin xStr := 'bn'; end;
    'Bosnian': begin xStr := 'bs'; end;
    'Bulgarian': begin xStr := 'bg'; end;
    'Burmese': begin xStr := 'my'; end;
    'Catalan': begin xStr := 'ca'; end;
    'Chinese': begin xStr := 'zh'; end;
    'Croatian': begin xStr := 'hr'; end;
    'Czech': begin xStr := 'cs'; end;
    'Danish': begin xStr := 'da'; end;
    'Maldivian': begin xStr := 'dv'; end;
    'Dutch': begin xStr := 'nl'; end;
    'English': begin xStr := 'en'; end;
    'Estonian': begin xStr := 'et'; end;
    'Faroese': begin xStr := 'fo'; end;
    'Farsi': begin xStr := 'fa'; end;
    'Finnish': begin xStr := 'fi'; end;
    'French': begin xStr := 'fr'; end;
    'Macedonia': begin xStr := 'mk'; end;
    'Gaelic': begin xStr := 'gd'; end;
    'Galician': begin xStr := 'gl'; end;
    'Georgian': begin xStr := 'ka'; end;
    'German': begin xStr := 'de'; end;
    'Greek': begin xStr := 'el'; end;
    'Guarani': begin xStr := 'gn'; end;
    'Gujarati': begin xStr := 'gu'; end;
    'Hebrew': begin xStr := 'he'; end;
    'Hindi': begin xStr := 'hi'; end;
    'Hungarian': begin xStr := 'hu'; end;
    'Icelandic': begin xStr := 'is'; end;
    'Indonesian': begin xStr := 'id'; end;
    'Italian': begin xStr := 'it'; end;
    'Japanese': begin xStr := 'ja'; end;
    'Kannada': begin xStr := 'kn'; end;
    'Kashmiri': begin xStr := 'ks'; end;
    'Kazakh': begin xStr := 'kk'; end;
    'Khmer': begin xStr := 'km'; end;
    'Korean': begin xStr := 'ko'; end;
    'Lao': begin xStr := 'lo'; end;
    'Latin': begin xStr := 'la'; end;
    'Latvian': begin xStr := 'lv'; end;
    'Lithuanian': begin xStr := 'lt'; end;
    'Malay': begin xStr := 'ms'; end;
    'Malayalam': begin xStr := 'ml'; end;
    'Maltese': begin xStr := 'mt'; end;
    'Maori': begin xStr := 'mi'; end;
    'Marathi': begin xStr := 'mr'; end;
    'Mongolian': begin xStr := 'mn'; end;
    'Nepali': begin xStr := 'ne'; end;
    'Norwegian-Bokml': begin xStr := 'nb'; end;
    'Norwegian-Nynorsk': begin xStr := 'nn'; end;
    'Oriya': begin xStr := 'or'; end;
    'Polish': begin xStr := 'pl'; end;
    'Portuguese': begin xStr := 'pt'; end;
    'Punjabi': begin xStr := 'pa'; end;
    'Raeto-Romance': begin xStr := 'rm'; end;
    'Romanian': begin xStr := 'ro'; end;
    'Russian': begin xStr := 'ru'; end;
    'Sanskrit': begin xStr := 'sa'; end;
    'Serbian': begin xStr := 'sr'; end;
    'Setsuana': begin xStr := 'tn'; end;
    'Sindhi': begin xStr := 'sd'; end;
    'Sinhalese  ': begin xStr := 'si'; end;
    'Slovak': begin xStr := 'sk'; end;
    'Slovenian': begin xStr := 'sl'; end;
    'Somali': begin xStr := 'so'; end;
    'Sorbian': begin xStr := 'sb'; end;
    'Spanish': begin xStr := 'es'; end;
    'Swahili': begin xStr := 'sw'; end;
    'Swedish': begin xStr := 'sv'; end;
    'Tajik': begin xStr := 'tg'; end;
    'Tamil': begin xStr := 'ta'; end;
    'Tatar': begin xStr := 'tt'; end;
    'Telugu': begin xStr := 'te'; end;
    'Thai': begin xStr := 'th'; end;
    'Tibetan': begin xStr := 'bo'; end;
    'Tsonga': begin xStr := 'ts'; end;
    'Turkish': begin xStr := 'tr'; end;
    'Turkmen': begin xStr := 'tk'; end;
    'Ukrainian': begin xStr := 'uk'; end;
    'Urdu': begin xStr := 'ur'; end;
    'Uzbek': begin xStr := 'uz'; end;
    'Vietnamese': begin xStr := 'vi'; end;
    'Welsh': begin xStr := 'cy'; end;
    'Xhosa': begin xStr := 'xh'; end;
    'Yiddish': begin xStr := 'yi'; end;
    'Zulu': begin xStr := 'zu'; end;
  end;
  Result := xStr;
end;

function GetPinPosition(PosX, PosY, xLen, xDir: String): TPinAttr;
var
  yLen: Integer;
  StartPosX, StartPosY,	EndPosX, EndPosY : Integer;
begin
  StartPosX := StrToInt(PosX);
  StartPosY := StrToInt(PosY);
  EndPosX := StartPosX;
  EndPosY := StartPosY;
  yLen := StrToInt(xLen);
  case xDir of
    'U': begin
           EndPosX := StartPosX;
           EndPosY := StartPosY + yLen;
         end;
    'D': begin
           EndPosX := StartPosX;
           EndPosY := StartPosY - yLen;
         end;
    'R': begin
           EndPosX := StartPosX + yLen;
           EndPosY := StartPosY;
         end;
    'L': begin
           EndPosX := StartPosX - yLen;
           EndPosY := StartPosY;
         end;
  end;
  Result.StartPosX := StartPosX;
  Result.StartPosY := StartPosY;
  Result.EndPosX := EndPosX;
  Result.EndPosY := EndPosY;
end;

procedure WriteHeader;
begin
  Form1.StringGrid1.Cells[0, 0] := '"EESchema-LIBRARY Version 2.3"';
  Form1.StringGrid1.Cells[0, 1] := '"#encoding utf-8"';
  Form1.StringGrid1.Cells[0, 2] := '"#"';
  Form1.StringGrid1.Cells[0, 3] := '"# ' + Form3.xLibName + '"';
  Form1.StringGrid1.Cells[0, 4] := '"#"';
//---
  Form1.StringGrid1.Cells[0, 5] := 'DEF';
  Form1.StringGrid1.Cells[1, 5] := Form3.xLibName;
  Form1.StringGrid1.Cells[2, 5] := 'IC';
  Form1.StringGrid1.Cells[3, 5] := '0';
  Form1.StringGrid1.Cells[4, 5] := '40';
  Form1.StringGrid1.Cells[5, 5] := 'Y';
  Form1.StringGrid1.Cells[6, 5] := 'Y';
  Form1.StringGrid1.Cells[7, 5] := '1';
  Form1.StringGrid1.Cells[8, 5] := 'F';
  Form1.StringGrid1.Cells[9, 5] := 'N';
//---
  Form1.StringGrid1.Cells[0, 6] := 'F0';
  Form1.StringGrid1.Cells[1, 6] := '"IC"';
  Form1.StringGrid1.Cells[2, 6] := '-200';
  Form1.StringGrid1.Cells[3, 6] := '200';
  Form1.StringGrid1.Cells[4, 6] := '60';
  Form1.StringGrid1.Cells[5, 6] := 'H';
  Form1.StringGrid1.Cells[6, 6] := 'V';
  Form1.StringGrid1.Cells[7, 6] := 'C';
  Form1.StringGrid1.Cells[8, 6] := 'CNN';
//---
  Form1.StringGrid1.Cells[0, 7] := 'F1';
  Form1.StringGrid1.Cells[1, 7] := '"' + Form3.xLibName + '"';
  Form1.StringGrid1.Cells[2, 7] := '0';
  Form1.StringGrid1.Cells[3, 7] := '0';
  Form1.StringGrid1.Cells[4, 7] := '60';
  Form1.StringGrid1.Cells[5, 7] := 'H';
  Form1.StringGrid1.Cells[6, 7] := 'V';
  Form1.StringGrid1.Cells[7, 7] := 'C';
  Form1.StringGrid1.Cells[8, 7] := 'CNN';
//---
  Form1.StringGrid1.Cells[0, 8] := 'F2';
  Form1.StringGrid1.Cells[1, 8] := '""';
  Form1.StringGrid1.Cells[2, 8] := '0';
  Form1.StringGrid1.Cells[3, 8] := '0';
  Form1.StringGrid1.Cells[4, 8] := '50';
  Form1.StringGrid1.Cells[5, 8] := 'H';
  Form1.StringGrid1.Cells[6, 8] := 'V';
  Form1.StringGrid1.Cells[7, 8] := 'C';
  Form1.StringGrid1.Cells[8, 8] := 'CNN';
//---
  Form1.StringGrid1.Cells[0, 9] := 'F3';
  Form1.StringGrid1.Cells[1, 9] := '""';
  Form1.StringGrid1.Cells[2, 9] := '0';
  Form1.StringGrid1.Cells[3, 9] := '0';
  Form1.StringGrid1.Cells[4, 9] := '50';
  Form1.StringGrid1.Cells[5, 9] := 'H';
  Form1.StringGrid1.Cells[6, 9] := 'V';
  Form1.StringGrid1.Cells[7, 9] := 'C';
  Form1.StringGrid1.Cells[8, 9] := 'CNN';
//---
  Form1.StringGrid1.Cells[0, 10] := 'F4';
  Form1.StringGrid1.Cells[1, 10] := '""';
  Form1.StringGrid1.Cells[2, 10] := '0';
  Form1.StringGrid1.Cells[3, 10] := '0';
  Form1.StringGrid1.Cells[4, 10] := '50';
  Form1.StringGrid1.Cells[5, 10] := 'H';
  Form1.StringGrid1.Cells[6, 10] := 'V';
  Form1.StringGrid1.Cells[7, 10] := 'C';
  Form1.StringGrid1.Cells[8, 10] := 'CNN';
  Form1.StringGrid1.Cells[9, 10] := '"Part Number"';
//---
  Form1.StringGrid1.Cells[0, 11] := '"$FPLIST"';
  Form1.StringGrid1.Cells[0, 12] := '" ?"';
  Form1.StringGrid1.Cells[0, 13] := '"$ENDFPLIST"';
end;

procedure WriteFooter(xLine: Integer);
begin
  Form1.StringGrid1.Cells[0, xLine] := 'ENDDRAW';
  Form1.StringGrid1.Cells[0, xLine + 1] := 'ENDDEF';
  Form1.StringGrid1.Cells[0, xLine + 2] := '"#"';
  Form1.StringGrid1.Cells[0, xLine + 3] := '"#End Library"';
end;

end.

