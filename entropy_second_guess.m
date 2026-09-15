%% ENTROPY_SECOND_GUESS
%  Calcula la entropia condicional del segundo intento, H(y|x).
%
%  Para cada palabra x del primer intento y cada uno de sus patrones i, se
%  construye un sub-diccionario con las palabras compatibles con ese patron
%  y se calcula la entropia de cada una de ellas dentro de ese sub-espacio.
%  Ese conjunto de entropias es el termino sum_j p(j|i) log p(j|i) de la
%  entropia condicional.
%
%  ATENCION: este es el calculo caro del trabajo. Son ~9571 x nPatrones
%  llamadas anidadas a wordle_pattern. En el TFG original tardo dias.
%  Por eso guarda su progreso en disco cada iteracion y puede reanudarse:
%  si el script se interrumpe, basta con volver a lanzarlo.
%
%  REQUIERE: haber ejecutado antes entropy_first_guess.m
%  SALIDA:   results/second_guess.mat -> S2 (cell 9571 x 9571), iniciaI
%
%  Paula Mena Gil - TFG, Universidad de Sevilla, 2023.

clc, clear

%% Carga de los resultados del primer intento
load(fullfile('results', 'first_guess.mat'), 'C', 'ic', 'Y');
diccionario = num2cell(char(Y));
N = length(diccionario);

%% Creamos un checkpoint en caso de que queramos parar el c´odigo que siga por donde iba.
checkpoint = fullfile('results','second_guess.mat');
if exist(checkpoint, 'file')
  load(checkpoint, 'inicial', 'S2');
  fprintf('Reanudando desde la palabra %d de %d.\n', inicial, N);
endif

if ~exist('inicial', 'var')
  inicial = 1;
  S2 = cell(N,N);
endif

%% BUCLE PRINCIPAL

for i = inicial:N
  for ii = 1:length(C{1,i})
    % sub-diccionario: palabras compatibles con el patron ii de la palabra i
    nuevodiccionario = diccionario((ic{1,i} == ii), :); % miramos en ic, para la celda de una palabra, qu´e palabras tienen el valor ii, es decir, el mismo patr´on.
    [nrows, ~] = size(nuevodiccionario);

    S2pre = zeros(nrows,1);
    for iii = 1:nrows
      [~,~,~,~,S2pre(iii,1),~] = wordle_pattern(nuevodiccionario,nuevodiccionario(iii,:));
    endfor
    S2{ii,i} = S2pre;
  endfor

  inicial = i+1;
  fprintf('Terminado el indice %d de %d. Son las %s.\n', i,N, datestr(now));
  save (checkpoint,'inicial','S2');
 endfor
