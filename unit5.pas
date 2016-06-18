//------------------------------------------------------------------------------
// title      : KiCad_LIB<>CSV Converter
// revision   : 0.3.1.25
// issue date : Jun.17, 2016
// author     : Starfort, (c) 2015-2016
// e-mail     : starfort@nifty.com
//------------------------------------------------------------------------------

unit Unit5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TForm5 }

  TForm5 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.lfm}

{ TForm5 }

procedure TForm5.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

