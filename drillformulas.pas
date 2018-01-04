unit drillformulas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
// Диаметр скважины (Диаметр долота; Коэффициент кавернозности), м (мм)
function DiameterWell(DiameterBit: real; K_kavern: real):real;

// Площадь круга (Диаметре,м^2 (мм^2)), м^2 (мм^2)
function PloshadKruga (Diameter: real):real;


//ГИДРАВЛИКА--------------------------------------------------------------------

//Динамическое напряжение сдвига промывочной жидкости (Плотность, кг/м3), Па
function DinamNaprSdivga (Plotnost: real):real;

//Пластическая вязкость промывочной жидкости (Плотность, кг/м3), Па*с
function PlastVayzkost (Plotnost: real):real;

//Число Хендсрема (He)
function He (Plotnost, DinamNaprSdviga, Diameter, PlastVayzkost: real): real;

//Кретическое число Рейнольдса (CRe)
function CRe (He:real):real;

//Число Рейнольдса (Re)
function Re (Lambda, Plotnost, SredScorostGidkost , Diameter, L:real):real;

//Коэффициент гидравлических потерь (Лямбда). delta для труб 0,1; для кольцевого
//пространства 0,107. K для труб 0,03; для кольцевого пространства 0,003.
function Lambda (delta, Diameter, Re, He, K :real):real;

//Скорость восходящего потока, м/с (Расход, м^3/c; Площадь, м^2)
function SkorostVoschPotoka (Raschod, Ploshad:real):real;

//------------------------------------------------------------------------------



implementation
// Диаметр скважины (Диаметр долота; Коэффициент кавернозности), м (мм)
function DiameterWell(DiameterBit: real; K_kavern: real):real;
  begin
       Result:= DiameterBit*sqrt(K_kavern);
  end;

// Площадь круга (Диаметре,м^2 (мм^2)), м^2 (мм^2)
function PloshadKruga (Diameter: real):real;
begin
     Result:=Pi*exp(2*ln(Diameter))/4;
end;

//ГИДРАВЛИКА

//Динамическое напряжение сдвига промывочной жидкости (Плотность, кг/м3), Па
  function DinamNaprSdivga (Plotnost: real):real;
begin
     Result:=8.5*Plotnost*0.001-7;
end;

//Пластическая вязкость промывочной жидкости (Плотность, кг/м3), Па*с
function PlastVayzkost (Plotnost: real):real;
begin
     Result:=33*Plotnost*0.001-22;
end;

//Число Хендсрема (He)(Плотность, Динамическое напряжение сдвига, Пластическая вязкость)
function He (Plotnost, DinamNaprSdviga, Diameter, PlastVayzkost: real): real;
begin
        Result:=(Plotnost*DinamNaprSdviga*exp(2*ln(Diameter)))/PlastVayzkost;
end;

//Кретическое число Рейнольдса (CRe)(Число Хендсрема)
function CRe (He:real):real;
begin
        Result:=2100+7.3*exp(0.58*ln(He));
end;


//Число Рейнольдса (Re)
function Re (Lambda, Plotnost, SredScorostGidkost , Diameter,L:real):real;
begin
     Result:= Lambda*Plotnost*exp(2*ln(SredScorostGidkost))*L/(2*Diameter);
end;

//Коэффициент гидравлических потерь (Лямбда). delta для труб 0,1; для кольцевого
//пространства 0,107. K для труб 0,03; для кольцевого пространства 0,003.
function Lambda (delta, Diameter, Re, He, K :real):real;
begin
     Result:= delta * exp(0.25*ln(1.46*K/Diameter+100/Re+6.72*He/exp(4*ln(Re))));
end;

//Скорость восходящего потока, м/с (Расход, м^3/c; Площадь, м^2)
function SkorostVoschPotoka (Raschod, Ploshad:real):real;
begin
     Result:=Raschod/Ploshad;
end;



end.

