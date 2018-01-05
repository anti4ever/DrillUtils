unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, Menus, ComCtrls, Grids, Graphics,
  Drillformulas, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PageControl1: TPageControl;
    StringGrid1: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
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
  dv :Real;  //Внутр. диаметр, мм
  dns: Real;    //Динамическое напряжение сдвига, Па
  pv: Real;  //Пластическая вязкость, Па*с
  hep: Real; // Число Хендстрема
  crre: Real; //Критическое число Рейнольдса
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
  Form1.StringGrid1.Cells[2,1]:= FloatToStr(Ceil(crre));;


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  deltaPpipe;
end;


end.

