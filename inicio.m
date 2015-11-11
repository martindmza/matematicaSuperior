clear 
clc

%interval = input('ingrese el intervalo en el que desea evaluar la funcion. ej [-4;4]: ');
%armonicas = input('ingrese la cantidad de armonicas a considerar. ej 5: ');

%fprintf('ingrese la funcion a trabajar. ej f(t) = t-4 in 1<t<2 and t + 4 in 2<t<3 : \n');
%functionToWork = input('  f(t)= ', 's');

functionToWork = ' t in 0<t<2 and -t in -2<t<0  ';
interval = [-10 10];
armonicas = 5;

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

%%%%%%%%%% CALCULO DE INTEGRALES DE LA SF

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
     An(j,i) = 1/L *(int(F*cos(t*omega*j),a,b));
     j=j+1;
   end
   %----------------------------------
 
   %calculo los bn--------------------
   
   j=1;
   while (j<=armonicas)
     Bn(j,i) = 1/L *(int(F*sin(t*omega*j),a,b));
     j=j+1;
   end
  %----------------------------------

  i=i+1;
end

%%%%%%%%%% FUNCION DE FOURIER

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

subplot(3,1,1)
plot(t, SF(t));

%%%%%%%%%% FUNCION ORIGINAL

fo = '@(t)';
for i=1:cantFunctions
   
    funAndIntervalString = strtrim(functions{i});
    funAndIntervalArray = strsplit(funAndIntervalString, 'in');

    f = strtrim(funAndIntervalArray{1});
 
    intervalStr = strtrim(funAndIntervalArray{2});
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

%%%%%%%%%% COEFICIENTES

subplot(3,1,3)
x = 1:armonicas;
y = Bntotal;
stem(x, y); hold on;

x = 1:armonicas;
y = Antotal;
stem(x, y); hold off;

syms t;

%%%%%%%%%% ERROR

An = zeros(5000,cantFunctions);
Bn = zeros(5000,cantFunctions);
sf= '';
n = 1;
while 1
		
    i = 1;   
    while (i <= cantFunctions)

        funAndIntervalString = strtrim(functions{i});
        funAndIntervalArray = strsplit(funAndIntervalString, 'in');
        f = strtrim(funAndIntervalArray{1});
        F = sym(f);
        L = T/2;
      
        omega = 2*pi/T;

        intervalStr = strtrim(funAndIntervalArray{2});
        intervalArray = strsplit(intervalStr,'<');
        a = str2double(intervalArray{1});
        b = str2double(intervalArray{3});

        An(n,i) = 1/L *(int(F*cos(t*omega*n),a,b));
        Bn(n,i) = 1/L *(int(F*sin(t*omega*n),a,b));
       
        i = i + 1;
    end
		Antotal = sum(An');
		Bntotal = sum(Bn');
  
  	sf = strcat(sf,num2str(Antotal(n)),'* cos(', num2str(i*omega),'*t) +');
    sf = strcat(sf,num2str(Bntotal(n)),'* sin(', num2str(i*omega),'*t) +');
    sf = strcat(sf, '0');	
    fs = strcat('@(t) abs(', sf, ')');
    FN = str2func(fs);

    NA = integral(FN, a, b) ;
  
  	i = 1;
    A = 0;
  	while (i <= cantFunctions)
       
        funAndIntervalString = strtrim(functions{i});
        funAndIntervalArray = strsplit(funAndIntervalString, 'in');
        f = strtrim(funAndIntervalArray{1});
        
        intervalStr = strtrim(funAndIntervalArray{2});
        intervalArray = strsplit(intervalStr,'<');
        a = str2double(intervalArray{1});
        b = str2double(intervalArray{3});
  		

      	F = sym(abs(str2double(f))); %%%%%%%%% Pensar como hacer para diferenciar constante de funcion.
        %f = strcat('@(t) abs(', f, ')');
        %F = str2func(f);
  		A = A + int(F, a, b);
        
        i = i + 1;
    end
  
    error = (double(A) - NA ) / double(A);

    if abs(error) < 0.05 || 20 < n 
        break;
  	end
    
    n = n + 1;
end
    fprintf(strcat(num2str(n),'\n'));
    fprintf(num2str(error));