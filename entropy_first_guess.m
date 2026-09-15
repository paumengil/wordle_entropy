%  %% ENTROPY_FIRST_GUESS
%  Calcula la entropia de Shannon de las 9571 palabras del diccionario
%  considerando unicamente el primer intento, y guarda una grafica de
%  distribucion de patrones por palabra.
%
%  Resultado esperado: la palabra de mayor entropia es LOREA (6.1792 bits,
%  187 patrones distintos).
%
%  SALIDA
%    results/first_guess.mat  ->  S, MPP, ic, C, P, npatrones, Y
%    results/graficas/figN.png  (una por palabra; ~9571 archivos, ~250 MB)
%
%  Tiempo de ejecucion: del orden de horas en un portatil.
%
%  Paula Mena Gil - TFG "El Concepto de Entropia en la Fisica"
%  Universidad de Sevilla, 2023.

clc, clear

%% CARGA DE DICCIONARIO

X = importdata('palabras_mini.txt'); % importamos el diccionario, en este caso, reducido
Y = unique(X); % quitamos las palabras repetidas
diccionario = num2cell(char(Y)); % Convertimos la lista de palabras en una matriz donde cada fila es una palabra y cada columna una letra
N = length(diccionario);
%% INICIALIZACIÓN

MPP = cell(1, N); % matrices de patrones únicos por palabra
S = zeros(N, 1); % entropia de cada palabra, en bits
Patron = cell(1, N); % patrones completos
ic = cell(1,N); % indices de agrupación
P = cell(1, N); % probabilidad de cada patrón
C = cell(1, N); % nº de palabras por patrón

%% CARPETA DE SALIDA DE GRÁFICAS

outdir = fullfile('results', 'graficas'); % Creamos una carpeta resultados/graficas donde ejecutamos el código

if ~ exist(outdir, 'dir') % la crea solo si no existe
  mkdir(outdir);
endif


T = strrep(Y,'-','ñ'); % Esta línea se utiliza para sustituir en el título de las palabras del dicchionario (por eso usamos Y y no diccionario) los caracteres '-' por 'ñ'. Las eñes son substituidas en el diccionario original por - ya que no existen en el teclado inglés.
set(0, 'DefaultFigureVisible', 'off'); % Desactiva que por defecto se muestren todas las gráficas que se pintan en pantalla para que no salgan las gráficas de cada palabra del diccionario en pop up

%% BUCLE PRINCIPAL
for i = 1: N
  [MPP{i}, ic{i}, C{i}, P{i}, S(i,1), Patron{i}] = wordle_pattern(diccionario, diccionario(i,:));

 % Creamos, por palabra, una gráfica con la probabilidad de aparición de cada uno de sus patrones.

  f = bar(1:1:length(MPP{i}),P{i},'b');
  xlabel('Patrones');
  ylabel('Probabilidad de que aparezcan');
  titulo = [upper(T{i}), '   S = ', num2str(S(i,1)), ' bits'];
  title(titulo);
  saveas(f,fullfile(outdir,['fig',num2str(i),'.png']));

  % Creamos un aviso cada 100 palabras para saber cómo va el bucle.
  if mod(i,100) == 0

    fprintf('Procesadas %d/%d palabras. %s\n', i, N, datestr(now));

  endif
endfor
set(0, 'DefaultFigureVisible', 'on');

%% Numero de patrones distintos por palabra
npatrones = cellfun(@(m) size(m, 1), MPP)';

%% Mejor y peor palabra del primer intento
[biggestentropy, bestword]  = max(S);
[minentropy,     worstword] = min(S);

fprintf('\nMejor palabra: %s  H = %.4f bits (%d patrones)\n', upper(Y{bestword}), biggestentropy, npatrones(bestword));
fprintf('Peor  palabra: %s  H = %.4f bits (%d patrones)\n', upper(Y{worstword}), minentropy, npatrones(worstword));

%% Guardado
save(fullfile( 'results', 'first_guess.mat'), 'S', 'MPP', 'ic', 'C', 'P', 'npatrones', 'Y');



