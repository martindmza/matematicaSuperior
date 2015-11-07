%interval = input('ingrese el intervalo en el que desea evaluar la funcion. ej [-4;4]: ');
%armonicas = input('ingrese la cantidad de armónicas a considerar. ej 5: ');
%printf('ingrese la funcion a trabajar. ej f(t) = t-4 in 1<t<2 and t + 4 in 2<t<3 : \n');
%functionToWork = input('  f(t)= ','s');
%w = (2*pi)/2;
clear 
clc
interval = [-10 10];
armonicas = 5;
functionToWork = ' 5 in 0<t<2 and -1 in -2<t<0  ';
w = (2*pi)/2;
syms t;

intervalA = interval(1);
intervalB = interval(2);

%separo por 'and' las funciones ingresadas y las guardo en un array
functions = strsplit(functionToWork, 'and');
cantFunctions = length(functions);

intervals = zeros(1,cantFunctions*2);
i = 1;
j = 1;
while (j <= cantFunctions)
    funAndIntervalArray = strsplit(functions{j}, 'in');
    intervalStr = strtrim(funAndIntervalArray{2});
    intervalArray = strsplit(intervalStr,'<');    
    
    intervals(i) = str2double(intervalArray{1});
    intervals(i+1) = str2double(intervalArray{3});
    
    i = i+2;
    j = j+1;
end
T = max(intervals) - min(intervals)

%un ciclo por cada función
i=1;
A0 = zeros(1,cantFunctions);
An = zeros(armonicas,cantFunctions);
Bn = zeros(armonicas,cantFunctions);
while (i <= cantFunctions)
  %obtengo la función y su intervalo, y la separo por 'in'
  funAndIntervalString = strtrim(functions{i});
  funAndIntervalArray = strsplit(funAndIntervalString, 'in');
  %el primer elemento es la función
  f = strtrim(funAndIntervalArray{1});
  %f = strcat('@(t)', f);

  %el segundo elemento es el intervalo
  intervalStr = strtrim(funAndIntervalArray{2});
  %obtengo los extremos a y b del intervalo separando por '<'
  intervalArray = strsplit(intervalStr,'<');
  a = str2double(intervalArray{1});
  b = str2double(intervalArray{3});

  %calculo a sub zero----------------
  syms x n
  F = sym(f);
  L = T/2;
  A0(i) = 1/L *(int(F,a,b));
  omega = 2*pi/T;

   %calculo los an--------------------
 
   j=1;
   while (j<=armonicas)
 
     %fa = strcat(f, '*cos(t*', num2str(omega), '*', num2str(j), ')');
     %FA = str2func(fa);
 
     An(j,i) = 1/L *(int(F*cos(t*omega*j),a,b));
     j=j+1;
   end
%   %----------------------------------
% 
% 
   %calculo los bn--------------------
   
   j=1;
   while (j<=armonicas)
 
%     fb = strcat(f, '*sin(t*', num2str(omega), '*', num2str(j), ')');
%     FB = str2func(fb);
 
     Bn(j,i) = 1/L *(int(F*sin(t*omega*j),a,b));
     j=j+1;
   end
  %----------------------------------

  i=i+1;
end
A0total = sum(A0');
Antotal = sum(An');
Bntotal = sum(Bn');

sf = strcat('@(t) ',num2str(A0total/2),'+');
for i=1:armonicas
   an = num2str(Antotal(i));
   sf = strcat(sf,an,'* cos(', num2str(i*omega),'*t) +');
   
   bn = num2str(Bntotal(i));
   sf = strcat(sf,bn,'* sin(', num2str(i*omega),'*t) +');
end
sf = strcat(sf,'0');
SF = str2func(sf);

t = linspace(intervalA,intervalB,100);

%y = @(x) ((x<=2)&(0<=x)).*(x)+((x<=0)&(-2<=x)).*(-x);
subplot(3,1,1)
plot(t, SF(t));

%%%%%%%%%% FUNCION ORIGINAL

fo = '@(t)';
for i=1:cantFunctions
   
    funAndIntervalString = strtrim(functions{i});
    funAndIntervalArray = strsplit(funAndIntervalString, 'in');
    %el primer elemento es la función
    f = strtrim(funAndIntervalArray{1});
    %f = strcat('@(t)', f);

    %el segundo elemento es el intervalo
    intervalStr = strtrim(funAndIntervalArray{2});
    %obtengo los extremos a y b del intervalo separando por '<'
    intervalArray = strsplit(intervalStr,'<');
    a = intervalArray{1};
    b = intervalArray{3};
  
    fo = strcat(fo, '((t<=',b,')&(',a,'<=t)).*(',f,')+');
end
fo = fo(1: length(fo) - 1);
FO = str2func(fo);

t = linspace(min(intervals),max(intervals));

pfx = repmat(FO(t),1,diff(interval)/T);
px = linspace(interval(1),interval(2),length(pfx));

subplot(3,1,2)
plot(px, pfx)
grid
