unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, Menus, ComCtrls, Grids, Graphics,
  Drillformulas, Math, Types, Controls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PageControl1: TPageControl;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    //procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure MenuItem2Click(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);


  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var MyTextStyle: TTextStyle;
begin
  StringGrid1.RowHeights[0]:=50;

  if (aRow=0) then
  begin
    MyTextStyle := StringGrid1.Canvas.TextStyle;
    MyTextStyle.SingleLine := false;
    MyTextStyle.Wordbreak:=true;
    StringGrid1.Canvas.TextStyle := MyTextStyle;
  end;
end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure deltaPpipe ();
var
  dv :Real;  //Внутр. диаметр, мм
  dns: Real;    //Динамическое напряжение сдвига, Па
  pv: Real;  //Пластическая вязкость, Па*с
  hep: Real; // Число Хендстрема
  crre: Real; //Критическое число Рейнольдса
  ref:Real; //Число Рейнольдса
  v: Real;  //Средняя скорость жидксости, м/с
  s: Real; // Площадь канала, мм2
  Q: Real; // Расход, л/с
begin
  //Внутренний диаметр, мм
  dv:= StrToFloat(Form1.Edit3.Text)-2*StrToFloat(Form1.Edit4.Text);
  Form1.StringGrid1.Cells[0,1]:= FloatToStr(dv);

  //Динамическое напряжение сдвига, Па
  dns:=DinamNaprSdivga(StrToFloat(Form1.Edit2.Text));
  Form1.Edit5.Text:=FloatToStr(dns);

  //Пластическая вязкость, Па*с
  pv:=PlastVayzkost(StrToFloat(Form1.Edit2.Text));
  Form1.Edit6.Text:=FloatToStr(pv);

  // Число Хендстрема
  hep:=He(StrToFloat(Form1.Edit2.Text),dns,dv,pv);
  Form1.StringGrid1.Cells[1,1]:= FloatToStr(Ceil(hep));

  //Критическое число Рейнольдса
  crre:=CRe(hep);
  Form1.StringGrid1.Cells[2,1]:= FloatToStr(Ceil(crre));

  //Средняя скорость жидксости, м/с
  s:=PloshadKruga(dv)/1000000;
  Q:=StrToFloat(Form1.Edit1.Text)/1000;
  v:=Q/s;
  Form1.StringGrid1.Cells[3,1]:= FormatFloat('#.##',v);

  //Число Рейнольдса
  ref:=Re(StrToFloat(Form1.Edit2.Text),v,dv,pv);
  Form1.StringGrid1.Cells[4,1]:= FloatToStr(Ceil(ref));

  if ref > crre then
  begin
   Form1.StringGrid1.Cells[5,1]:= 'Турбулентный';
   Form1.StringGrid1.Cells[7,1]:= '-';

  end;


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  deltaPpipe;
end;


//Ввод только цифр и точки с запятой
{procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    '0'..'9', #8:;
    ',','.': if Pos(DecimalSeparator, Form1.Edit1.Text) = 0 then
     Key := DecimalSeparator else Key := #0;
  else
   Key := #0;
  end;
end;}






end.

