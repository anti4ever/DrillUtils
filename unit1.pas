unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, Menus, ComCtrls, Grids, Graphics,
  Drillformulas, Math, Controls, ExtCtrls, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
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
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
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
    MenuItem3: TMenuItem;
    PageControl1: TPageControl;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure MenuItem2Click(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);



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



procedure deltaPpipe ();
var
  dv :Double;  //Внутр. диаметр труб, мм
  dns: Double;    //Динамическое напряжение сдвига, Па
  pv: Double;  //Пластическая вязкость, Па*с
  hep: Double; // Число Хендстрема
  crre: Double; //Критическое число Рейнольдса
  ref:Double; //Число Рейнольдса
  v: Double;  //Средняя скорость жидксости, м/с
  s: Double; // Площадь канала, мм2
  Q: Double; // Расход, л/с
  lambdaRe: Double; // Коэфф. гидр. сопротивления Турбулентный режим
  selam: Double;
  lt: Double;
  dp: Double;
  ktr, kpor: Double;
  deltatr: Double;
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
  Form1.StringGrid1.Cells[3,1]:= FormatFloat('0.##',v);

  //Число Рейнольдса
  ref:=Re(StrToFloat(Form1.Edit2.Text),v,dv,pv);
  Form1.StringGrid1.Cells[4,1]:= FloatToStr(Ceil(ref));

  if ref > crre then
  begin
   Form1.StringGrid1.Cells[5,1]:= 'Турбулентный';
   Form1.StringGrid1.Cells[7,1]:= '-';
   deltatr:=StrToFloat('0,1');
   ktr:= StrToFloat('0,0003');
   lambdaRe:=Lambda(deltatr,(dv/1000),ref,hep,ktr);
   Form1.StringGrid1.Cells[6,1]:= FormatFloat('0.####',lambdaRe);
   dp:=deltaPTurb(lambdaRe,StrToFloat(Form1.Edit2.Text),v,(dv/1000),StrToFloat(Form1.Edit7.Text));
   Form1.StringGrid1.Cells[8,1]:= FormatFloat('0.###',lambdaRe);

   {if Form1.CheckBox1.State=cbChecked then
   begin
   lambdaRe:=Lambda(0.1,);
   end;

   if Form1.CheckBox1.State=cbChecked then
   begin

   end;}
   end
  else
  begin
    Form1.StringGrid1.Cells[5,1]:= 'Ламинарный';
    Form1.StringGrid1.Cells[6,1]:= '-';
    selam:=Se(dns,dv,pv,v);
    Form1.StringGrid1.Cells[7,1]:= FormatFloat('0.##',selam); //FloatToStr(selam);
    lt:=StrToFloat(Form1.Edit7.Text);
    dp:=deltaPLamin(selam,dns,lt,dv)/1000;
    Form1.StringGrid1.Cells[8,1]:= FormatFloat('0.###',dp); //FloatToStr(dp);
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  deltaPpipe;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.State = cbChecked then
  Form1.CheckBox2.Checked:=False;
  Form1.Edit9.Enabled:=False;
  Form1.Edit12.Enabled:=True;
   Form1.Edit13.Enabled:=True;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
   if CheckBox2.State = cbChecked then
   Form1.CheckBox1.Checked:=False;
   Form1.Edit12.Enabled:=False;
   Form1.Edit13.Enabled:=False;
   Form1.Edit9.Enabled:=True;
end;

//Ввод только цифр и точки с запятой
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    '0'..'9', #8:;
    ',','.': if Pos(DecimalSeparator{%H-}, Form1.Edit1.Text) = 0 then
     Key := DecimalSeparator{%H-} else Key := #0;
  else
   Key := #0;
  end;
end;

end.

