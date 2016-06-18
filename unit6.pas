//------------------------------------------------------------------------------
// title      : KiCad_LIB<>CSV Converter
// revision   : 0.3.1.25
// issue date : Jun.17, 2016
// author     : Starfort, (c) 2015-2016
// e-mail     : starfort@nifty.com
//------------------------------------------------------------------------------

unit Unit6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Unit1, Unit3;

type

  { TForm6 }

  TForm6 = class(TForm)
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form6: TForm6;

resourcestring
    Caption61 = 'Please enter component name (= lib file name.)';

implementation

{$R *.lfm}

{ TForm6 }

procedure TForm6.FormShow(Sender: TObject);
begin
  Edit1.Text := Form3.xLibName;
  Label1.Caption := Caption61;
end;

procedure TForm6.BitBtn1Click(Sender: TObject);
begin
  If Edit1.Text = '' then
  begin
    Edit1.Text := '~';
  end;
  Form3.xLibName := Edit1.Text;
  Form1.StringGrid1.Cells[0, 3] := '"# ' + Form3.xLibName + '"';
  Form1.StringGrid1.Cells[1, 5] := Form3.xLibName;
  Form1.StringGrid1.Cells[1, 7] := '"' + Form3.xLibName + '"';
  Close;
end;

end.

