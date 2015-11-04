#interval = input('ingrese el intervalo en el que desea evaluar la funcion. ej [-4;4]: ');
#armonicas = input('ingrese la cantidad de armónicas a considerar. ej 5: ');
#printf("ingrese la funcion a trabajar. ej f(t) = t-4 in 1<t<2 and t + 4 in 2<t<3 : \n");
#functionToWork = input('  f(t)= ',"s");
#printf('ingrese la perioricidad de la funcion: ej f(t) = f(t+4)');
#T = input (' f(t) = f(t+',"s");
#w = (2*pi)/2;

interval = [-4;4];
armonicas = 10;
functionToWork = "  t-4 in 0<t<2 and t + 4 in 2<t<4  ";
T=4;
w = (2*pi)/2;

#separo por 'and' las funciones ingresadas y las guardo en un array
functions = strsplit(functionToWork, "and");
cantFunctions = columns(functions);

#un ciclo por cada función
i=1;
while (i <= cantFunctions)
  #obtengo la función y su intervalo, y la separo por 'in'
  funAndIntervalString = strtrim(functions{i});
  funAndIntervalArray = strsplit(funAndIntervalString, "in");
  #el primer elemento es la función
  f = strtrim(funAndIntervalArray{1});
  
  #el segundo elemento es el intervalo
  intervalStr = strtrim(funAndIntervalArray{2});
  #obtengo los extremos a y b del intervalo separando por '<'
  intervalArray = strsplit(intervalStr,"<");  
  a = intervalArray{1};
  b = intervalArray{3};
  
  #calculo a sub zero
  
  
  #calculo los an--------------------
  an=[1:armonicas];
  j=0;
  while (j<armonicas)
  
  j++;
  endwhile
  #----------------------------------
  
  
  #calculo los bn--------------------
  bn=[1:armonicas];
  j=0;
  while (j<armonicas)
  
  j++;
  endwhile
  #----------------------------------
  
  
  
  i++;
endwhile



