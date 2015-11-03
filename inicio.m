interval = input('ingrese el intervalo en el que desea evaluar la funcion. ej [-4;4]: ');
armonica = input('ingrese la cantidad de armónicas a considerar. ej 5: ');
printf("ingrese la funcion a trabajar. ej f(t) = t-4 in 1<t<2 and t + 4 in 2<t<3 : \n");
functionToWork = input('  f(t)= ',"s");
printf('ingrese la perioricidad de la funcion: ej f(t) = f(t+4)');
T = input (' f(t) = f(t ',"s");

functions = strsplit(functionToWork, "and");
cantFunctions = columns(functions);

i=1;
while (i <= cantFunctions)
  funAndIntervalString = strtrim(functions{i});
  funAndIntervalArray = strsplit(funAndIntervalString, "in");
  fun = strtrim(funAndIntervalArray{1});

  intervalStr = strtrim(funAndIntervalArray{2});
  intervalArray = strsplit(intervalStr,"<");  
  intervala = intervalArray{1};
  intervalb = intervalArray{3};
  

  
  i++;
endwhile
