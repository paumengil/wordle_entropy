% Este script es una transcripción explicada y reproducible en octave de la función
% wordle_o creada en matlab del TFG sobre entropía redactado por Paula Mena Gil en 2023 y
% tutorizado por Jose María Martín Olalla.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WORDLE_PATTERN es una función que enfrenta una palabra perteneciente a un
%% diccionario a el resto de palabras del diccionario para sacar su entropía de
%% de shannon a partir de los patrones obtenidos siguiendo las reglas del juego
%% del wordle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MP, ic, C, P, S, Patron] = wordle_pattern(diccionario, guess)

  % ENTRADAS:
  %   diccionario: cell array N x 5. Cada fila es una palabra, cada celda una
  %               letra minúscula de dicha palabra. La 'Ñ' se codifica como '-'.
  %   guess : cell array 1 x 5 con la palabra propuesta, mismo formato.
  %
  % SALIDAS:
  %   MP : matriz de patrones únicos (nPatrones x 5)
  %   ic : indice, para cada palabra del diccionario, de su fila en MP
  %   C  : nº de palabras del diccionario que producen cada patrón.
  %   P  : C/N, probabilidad de aparición de cada patrón, siendo N el número de
  %        patrones total.
  %   S  : entropía de Shannon de la palabra, en bits.
  %   Patron :patron completo palabra a palabra (N x 5), sin agrupar.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       INICIALIZACIÓN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  [uTry, uPosTry, uPatronTry] = unique(guess); %Esta función resuelve el problema de las letras repetidas en una palabra y se usará más adelante.
  base = eye(size(diccionario, 2)); %matriz unidad NxN siendo N el número de letras de cada palabra del diccionario1
  Patron = zeros(size(diccionario,1),size(diccionario,2)); %matriz de zeros de MxN siendo M el número de palabras del diccionario y N el número de letras de cada palabra

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%    BUCLE PRINCIPAL
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  for i = 1:length(uTry) % recorremos las letras NO repetidas de la palabra guess
    letra = uTry(i);
    [a,~] = ismember(diccionario,letra); % nos dice la letra dónde está en cada palabra del diccionario. Devuelve matriz Mx5
    index = find(~any(a')); % De dentro a fuera: transponemos matriz a ya que any mira por columnas y nos da la fila del vector diccionario que no tiene esa letra en ninguna posición. Any nos da un vector de ceros y unos donde se cumple la condición, find nos da un vector más corto con la posición de cada uno.
    Patron(index,uPatronTry==i) = 3; % Pone en 'gris' que en este código corresponde a 3, en las palabras de index (las que no tienen esa letra) en la posición o posiciones en las que está esa letra en la palabra guess.
    index = find(any(a')); % Localizamos la fila del diccionario de las palabras que SÍ tienen esa letra
    aparicionesEnTry = find(uPatronTry==i); % Te dice en qué posición de la palabra está esa letra, si es más de una posición te dará dos posiciones, así sabemmos si está repetida.
    for ii = 1:length(aparicionesEnTry)
      resultado = and(a(index,:),base(aparicionesEnTry(ii),:)); % esto da true si las palabras que tienen la letra coincide su posición con la posición de la letra true.
      Patron(index(any(resultado')),aparicionesEnTry(ii)) = 1; % Pone en 'verde' que este código corresponde al número 1, en la matriz de patrones en la fila donde sabemos que está esa letra, en la posición de esa letra
      Patron(index(~any(resultado')),aparicionesEnTry(ii)) = 2; % Pone en 'naranja', que en este código corresponde al número 2, en la matriz de patrones la fila donde sabemos que está esa letra, la columna de esa letra.
    endfor
% Hasta aquí si la palabra guess tiene una letra repetida dos veces y la palabra solución tiene una sola vez esa letra, se estaría coloreando la letra repetida de la palabra guess dos veces cuando la sol solo tiene una. ej: en casas las a aparecería ambas amarillas aunque la solución sea lorea. Hay que corregir eso y por eso es esste bucle.
    aparicionesEnDiccionario = sum(a'); % como a es una matriz de ceros y unos donde está la letra que queremos, si obtenemos un num mayor que 1 en la fila implica que la letra está repetida ese número de veces.
    index = find(and(aparicionesEnDiccionario,aparicionesEnDiccionario<length(aparicionesEnTry))); %palabras solución que tienen la letra y aparece menos veces repetida que en guess
    columnas = find(uPatronTry==i); % seleccionamos las columnas del guess que tienen este problema que queremos arreglar
    for ii = 1:length(index)
      [~, posicion] = sort(Patron(index(ii),columnas)','ascend'); % revisamos los valores que habíamos puesto en las palabras que tenían este probema y sacamos estos valores por orden ascendente
      cambia = posicion(aparicionesEnDiccionario(index(ii))+1:end); %cogemos de ese vector de posiciones de letras repetidas a partir de las que no tiene la palabra solución. si la palabra solución solo tiene una letra (no tiene repetidas) cogemos del vector posición 1+1 =2 : final del vector. Todos esos valores son los que tenemos que cambiar
      Patron(index(ii), columnas(cambia)) = 3; % seleccionamos las columnas que hay que cambiar de la matriz de patrones y las ponemos en gris (3)
    endfor
 endfor

 % El bucle anterior nos devuelve la matriz Patron, ahora vamos a sacar otras métricas útiles
 [MP, ~, ic] = unique(Patron, 'rows'); % nos saca los patrones de la matriz patrones sin repetir (MP) y nos díce a qué palabra de la matriz Patrones corresponde ese patron (ic)
 C = accumarray(ic, 1); % nos dice cuántas veces se repite cada patron en el orden de MP
 [nrows,~] = size(diccionario); % nos dice cuántas palabras tiene el diccionario
 P = C./nrows; % dividimos cada vez que aparece un patrón en el diccionario por el número de palabras totales para obtener la probabilidad de aparición de cada patrón.
 S=sum(P.*log2(1./P)); % calculamos la entropía de cada uno de los patrones según la formula de shannon
