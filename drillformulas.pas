unit drillformulas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
// Диаметр скважины (Диаметр долота; Коэффициент кавернозности), м (мм)
function DiameterWell(DiameterBit: real; K_kavern: real):real;

// Площадь круга (Диаметре,м^2 (мм^2)), м^2 (мм^2)
function PloshadKruga (Diameter: real):real;

//Площадь кольцевого пространства (Диаметре1,м^2 (мм^2), Диаметре2,м^2 (мм^2)), м^2 (мм^2)
function PloshadAnnular (Diameter1, Diameter2:real):real;


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
function Re (Plotnost,SrednScorostGidkost,Diameter,PlastVayzkost:real):real;

//Коэффициент гидравлических потерь (Лямбда). delta для труб 0,1; для кольцевого
//пространства 0,107. K для труб 0,0003; для кольцевого пространства 0,003.
function Lambda (delta, Diameter, Re, He, K :double):double;

//Скорость потока, м/с (Расход, м^3/c; Площадь, м^2)
function SrednScorostGidkost (Raschod, Ploshad:real):real;

//Число Сенванана для случая ламинарного течения (Se)
function Se (DinamNaprSdviga,Diameter,PlastVayzkost,SredScorostGidkost:real):real;

//Перепад давления при ламинарном течении, Па
function deltaPLamin (Sen,DinamNaprSdivga, L, Diameter:real):real;

//Перепад давления при турбулентном режиме, Па (Лябда, Плотность, кг/м3;
//Средняя скорость жидксти, м/с; Диаметер, м)
function deltaPTurb (Lambda, Plotnost, SredScorostGidkost , Diameter,L:real):real;

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

//Площадь кольцевого пространства (Диаметре1,м^2 (мм^2), Диаметре2,м^2 (мм^2)), м^2 (мм^2)
function PloshadAnnular (Diameter1, Diameter2:real):real;
begin
   Result:=Pi*(exp(2*ln(Diameter1))-exp(2*ln(Diameter2)))/4
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
        Result:=(Plotnost*DinamNaprSdviga*exp(2*ln(Diameter)))/exp(2*ln(PlastVayzkost));
end;

//Кретическое число Рейнольдса (CRe)(Число Хендсрема)
function CRe (He:real):real;
begin
        Result:=2100+7.3*exp(0.58*ln(He));
end;


//Число Рейнольдса (Re)(Плтность, кг/м3; Средняя скорость жидкости, м/с;
//Диаметер, м; Пластическая вязкость,Па*с)
function Re (Plotnost,SrednScorostGidkost,Diameter,PlastVayzkost:real):real;
begin
       Result:=Plotnost*SrednScorostGidkost*Diameter/PlastVayzkost;
end;

//Коэффициент гидравлических потерь (Лямбда). delta для труб 0,1; для кольцевого
//пространства 0,107. K для труб 0,0003; для кольцевого пространства 0,003.
// (дельта; диаметер, м; Re; He; K)
function Lambda (delta, Diameter, Re, He, K :Double):double;
begin
     Result:= delta * exp(0.25*ln(1.46*K/Diameter+100/Re+6.72*He/exp(4*ln(Re))));
end;

//Скорость потока, м/с (Расход, м^3/c; Площадь, м^2);
function SrednScorostGidkost (Raschod, Ploshad:real):real;
begin
     Result:=Raschod/Ploshad;
end;

//Перепад давления при турбулентном режиме, Па (Лябда, Плотность, кг/м3;
//Средняя скорость жидксти, м/с; Диаметер, м)
function deltaPTurb (Lambda, Plotnost, SredScorostGidkost , Diameter,L:real):real;
begin
     Result:= Lambda*Plotnost*exp(2*ln(SredScorostGidkost))*L/(2*Diameter);
end;

//Число Сенванана для случая ламинарного течения (Se)
function Se (DinamNaprSdviga,Diameter,PlastVayzkost,SredScorostGidkost:real):real;
begin
     Result:=(DinamNaprSdviga*Diameter)/(PlastVayzkost*SredScorostGidkost);
end;

//Перепад давления при ламинарном течении, Па
function deltaPLamin (Sen,DinamNaprSdivga, L, Diameter:real):real;
var beta:real;
 begin
      if Sen >= 10 then
      beta:= 1-(4*(sqrt(1.2+0.5*Sen)-1))/Sen
      else
      beta:=Sen/(12+1.3*Sen);
      Result:=4*DinamNaprSdivga*L/(beta*Diameter);
 end;

end.

