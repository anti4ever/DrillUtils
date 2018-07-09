unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, Menus, ComCtrls, Grids, Graphics,
  Drillformulas, Math, Controls, ExtCtrls, ValEdit, comobj;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit2: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
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
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
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
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ValueListEditor1: TValueListEditor;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit11Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);

  private

  public

  end;

var
  Form1: TForm1;

implementation

uses info_form;

{$R *.lfm}

{ TForm1 }



procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
      info_form.Form2.Show;
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var MyTextStyle: TTextStyle;
begin
  StringGrid1.RowHeights[0]:=60;
  StringGrid2.RowHeights[0]:=60;
  if (aRow=0) then
  begin
    MyTextStyle := StringGrid1.Canvas.TextStyle;
    MyTextStyle.SingleLine := false;
    MyTextStyle.Wordbreak:=true;
    StringGrid1.Canvas.TextStyle := MyTextStyle;
    StringGrid2.Canvas.TextStyle := MyTextStyle;
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
  ktr: Double;
  deltatr: Double;
begin
  //Внутренний диаметр, мм
  dv:= StrToFloat(Form1.Edit3.Text)-2*StrToFloat(Form1.Edit4.Text);
  Form1.StringGrid1.Cells[0,1]:= FloatToStr(dv);

  //Динамическое напряжение сдвига, Па
  if Form1.CheckBox3.Checked = true then
  begin
  dns:=StrToFloat(Form1.Edit5.Text);
  end
  else
  begin
  dns:=DinamNaprSdivga(StrToFloat(Form1.Edit2.Text));
  Form1.Edit5.Text:=FloatToStr(dns);
  end;

  //Пластическая вязкость, Па*с
  if Form1.CheckBox3.Checked = true then
  begin
  pv:=StrToFloat(Form1.Edit6.Text);
  end
  else
  begin
  pv:=PlastVayzkost(StrToFloat(Form1.Edit2.Text));
  Form1.Edit6.Text:=FloatToStr(pv);
  end;

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
   dp:=deltaPTurb(lambdaRe,StrToFloat(Form1.Edit2.Text),v,(dv/1000),StrToFloat(Form1.Edit7.Text))/1000000;
   Form1.StringGrid1.Cells[8,1]:= FormatFloat('0.###',dp);
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

procedure deltaPannular();
var
  dvk: Double; // Диаметр внутренний обсадной колонны, мм
  dt: Double; // Диаметр трубы, мм
  dv :Double;  //Разность диаметров труб, мм
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
  ktr: Double;
  deltatr: Double;
begin
  //Разность диаметров, мм
  if Form1.CheckBox1.Checked=true then
  begin
  dvk:= StrToFloat(Form1.Edit12.Text)-2*StrToFloat(Form1.Edit13.Text);
  dt:= StrToFloat(Form1.Edit8.Text);
  dv:= dvk-dt;
  Form1.StringGrid2.Cells[0,1]:= FloatToStr(dvk);
  Form1.StringGrid2.Cells[1,1]:= FloatToStr(dt);
  ktr:= StrToFloat('0,0003');
  end;

  if Form1.CheckBox2.Checked=true then
  begin
  dvk:= StrToFloat(Form1.Edit9.Text);
  dt:= StrToFloat(Form1.Edit8.Text);
  dv:= dvk-dt;
  Form1.StringGrid2.Cells[0,1]:= FloatToStr(dvk);
  Form1.StringGrid2.Cells[1,1]:= FloatToStr(dt);
  ktr:= StrToFloat('0,003');
  end;

  //Динамическое напряжение сдвига, Па
  if Form1.CheckBox3.Checked = true then
  begin
  dns:=StrToFloat(Form1.Edit5.Text);
  end
  else
  begin
  dns:=DinamNaprSdivga(StrToFloat(Form1.Edit2.Text));
  Form1.Edit5.Text:=FloatToStr(dns);
  end;

  //Пластическая вязкость, Па*с
  if Form1.CheckBox3.Checked = true then
  begin
  pv:=StrToFloat(Form1.Edit6.Text);
  end
  else
  begin
  pv:=PlastVayzkost(StrToFloat(Form1.Edit2.Text));
  Form1.Edit6.Text:=FloatToStr(pv);
  end;

  // Число Хендстрема
  hep:=He(StrToFloat(Form1.Edit2.Text),dns,dv,pv);
  Form1.StringGrid2.Cells[2,1]:= FloatToStr(Ceil(hep));

  //Критическое число Рейнольдса
  crre:=CRe(hep);
  Form1.StringGrid2.Cells[3,1]:= FloatToStr(Ceil(crre));

  //Средняя скорость жидксости, м/с
  s:=PloshadAnnular(dvk,dt)/1000000;
  Q:=StrToFloat(Form1.Edit1.Text)/1000;
  v:=Q/s;
  Form1.StringGrid2.Cells[4,1]:= FormatFloat('0.##',v);

  //Число Рейнольдса
  ref:=Re(StrToFloat(Form1.Edit2.Text),v,dv,pv);
  Form1.StringGrid2.Cells[6,1]:= FloatToStr(Ceil(ref));

  if ref > crre then
  begin
   Form1.StringGrid2.Cells[5,1]:= 'Турбулентный';
   Form1.StringGrid2.Cells[7,1]:= '-';
   deltatr:=StrToFloat('0,107');
   lambdaRe:=Lambda(deltatr,(dv/1000),ref,hep,ktr);
   Form1.StringGrid2.Cells[8,1]:= FormatFloat('0.####',lambdaRe);
   dp:=deltaPTurb(lambdaRe,StrToFloat(Form1.Edit2.Text),v,(dv/1000),StrToFloat(Form1.Edit10.Text))/1000000;
   Form1.StringGrid2.Cells[9,1]:= FormatFloat('0.###',dp);
  end
  else
  begin
    Form1.StringGrid2.Cells[5,1]:= 'Ламинарный';
    Form1.StringGrid2.Cells[8,1]:= '-';
    selam:=Se(dns,dv,pv,v);
    Form1.StringGrid2.Cells[7,1]:= FormatFloat('0.##',selam); //FloatToStr(selam);
    lt:=StrToFloat(Form1.Edit10.Text);
    dp:=deltaPLamin(selam,dns,lt,dv)/1000;
    Form1.StringGrid2.Cells[9,1]:= FormatFloat('0.###',dp); //FloatToStr(dp);
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  deltaPpipe;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 deltaPannular();
end;

procedure TForm1.Button3Click(Sender: TObject);
var i: Integer;
begin
  i:=Form1.ValueListEditor1.RowCount;
  Form1.ValueListEditor1.Strings.Add(Form1.ComboBox1.Text);
  Form1.ValueListEditor1.Keys[i]:=IntToStr(i);
end;

procedure TForm1.Button4Click(Sender: TObject);
var i: Integer; s,uq,dp,mu,q,pl:real; a:string;
begin
  i:=Form1.ValueListEditor1.RowCount;
  s:=0;
 while i>1 do
       begin
       a:=Form1.ValueListEditor1.Values[IntToStr(i-1)];
       s:=s+PloshadKruga(StrToFloat(a));
       i:=i-1;
       end;
   Form1.Edit17.Text:=FormatFloat('0.###',s/100);
   uq:=StrToFloat(Form1.Edit11.Text)/(PloshadKruga(StrToFloat(Form1.Edit15.Text))/100);
   Form1.Edit18.Text:=FormatFloat('0.###',uq);
   mu:= StrToFloat(Form1.Edit16.Text);
   q:= StrToFloat(Form1.Edit11.Text)/1000;
   pl:= StrToFloat(Form1.Edit14.Text);
   dp:=deltaPdoloto(mu,q,(s/1000000),pl)/1000000;
   Form1.Edit19.Text:=FormatFloat('0.##',dp);
   Form1.Edit20.Text:=FormatFloat('0.##',(q/(s/1000000)));
end;

procedure TForm1.Button5Click(Sender: TObject);
var i: Integer;
begin
  i:=Form1.ValueListEditor1.RowCount;
  if i>2 then
  Form1.ValueListEditor1.DeleteRow(i-1);
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  MSWord,t: OleVariant;
  s: String;
begin
  MsWord := CreateOleObject('Word.Application');
  MsWord.Documents.Open('d:\Lazarus\DrillUtils\test.docx');
   MsWord.Visible := True;
  //t:= UTF8Decode('123');
  //f:= UTF8Decode('test');
  //s := UTF8Decode('Привет, мир! test');
  //MsWord.Selection.TypeText(WideString(s));
  t:= 'привет';

  //f:= UTF8Decode('test');
  MsWord.Selection.Find.ClearFormatting;
  MsWord.Selection.Find.Replacement.ClearFormatting;
  MsWord.Selection.Find.Text:='test';
  //MsWord.Selection.GoTo(-1,,,f);
  MsWord.Selection.Find.Replacement.Text := t;
  MsWord.Selection.Find.Forward:=True;
  MsWord.Selection.Find.Execute (Replace := 2);
  //MsWord.Selection.TypeText(t);
  Form1.Edit21.Text:=ExtractFilePath(paramStr(0)); //Дирректория программы


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

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
   if CheckBox3.State = cbChecked then
   begin
   Form1.Edit5.Enabled:=True;
   Form1.Edit6.Enabled:=True;
   end
   else
   begin
    Form1.Edit5.Enabled:=False;
   Form1.Edit6.Enabled:=False;
   end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm1.Edit11Change(Sender: TObject);
begin

end;

//Ввод только цифр и точки с запятой
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
   case Key of
    '0'..'9', #8:;
    ',','.': if Pos(DecimalSeparator{%H-},TEdit(Sender).Text) = 0 then
     Key := DecimalSeparator{%H-} else Key := #0;
  else
   Key := #0;
  end;
end;

end.

