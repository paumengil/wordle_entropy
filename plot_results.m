%% PLOT_RESULTS
%  Reproduce las figuras del TFG a partir de los resultados guardados.
%
%    1. Patron mas probable de la mejor palabra, dibujado con los colores
%       del juego (figura 7 de la memoria).
%    2. Entropia frente al numero de patrones (figura 9).
%    3. Principio de MaxEnt: desviacion tipica de P frente a entropia
%       (figura 10).
%
%  REQUIERE: entropy_first_guess.m ejecutado.
%
%  Paula Mena Gil - TFG, Universidad de Sevilla, 2023.

clc, clear

%% CARGA DE DATOS
load(fullfile('results','first_guess.mat'), 'S','MPP','ic', 'C', 'P', 'npatrones', 'Y');
diccionario = num2cell(char(Y));
N = length(diccionario);

[biggestentropy, bestword] = max(S);

%% OBTENER PATRON DE UNA PALABRA CONCRETA: descomentar esta sección en caso de querer obtener el patrón de una palabra concreta en vez de la mejor, por ejemplo: lorea.
%[~, busca] = ismember("lorea",Y);
% bestword = busca;

%% PATRON MÁS PROBABLE DE LA MEJOR PALABRA

PatronesBW = MPP{1, bestword};
repeticionesBW = C{1,bestword};
icBW = ic{1, bestword};

[maxapariciones, bestpatron] = max(repeticionesBW);

PBW = repeticionesBW./ N; % Probabilidad de cada patrón de la mejor palabra (BW)
IpatronBW = (log2(1./PBW)); % Información de cada patrón en bits

palabrasquelocumplen = Y(icBW == bestpatron);

fprintf('Palabra:%s (H = %4f bits, %d patrones)|n', upper(Y{bestword}), biggestentropy, npatrones(bestword));
fprintf('Patron mas probable: deja %d palabras posibles, %.4f bits de informacion.\n', maxapariciones, IpatronBW(bestpatron));

%% FIGURA PATRÓN
x = [-1 1 1 -1 -1];
y = [ 0 0 1  1  0];
colores = [0.4660 0.6740 0.1880;   % 1 verde
           0.9290 0.6940 0.1250;   % 2 amarillo
           0.8500 0.8500 0.8500];  % 3 gris

for j = 1:5
  subplot (1,5,j)
  fill(x,y, colores(PatronesBW(bestpatron,j),:)) % gracias a que la matriz colores está en orden y su primer término corresponde al valor 1 en nuestro código para los patrones (verde)
  text(-0.5,0.5,upper(diccionario(bestword,j)),"FontSize",27,"FontWeight","bold")
  axis('square') % hace un cuadrado
  set(gca,'XTickLabel',[],'YTickLabel',[]) % quita los ejes
endfor

%% ENTROPÍA VR PATRONES
figure
plot(npatrones, S, '.')
title('Entropia de Shannon frente al nº de patrones', 'FontSize', 20)
xlabel('Nº Patrones', 'FontSize', 18)
ylabel('H (bits)', 'FontSize', 18)
legend('Palabras del diccionario con 5 letras', 'FontSize', 15)
grid on, grid minor

%% PRINCIPIO DE MAX ENTROPÍA
% A menor dispersion de las probabilidades (grafica mas plana), mayor entropia.
desviacion = zeros(N, 1);
for i = 1:N
    desviacion(i,1) = std(P{1,i});
end

figure
plot(desviacion, S, '.')
title('Principio de MaxEnt', 'FontSize', 20)
xlabel('Desviacion tipica de la probabilidad', 'FontSize', 18)
ylabel('H (bits)', 'FontSize', 18)
legend('Palabras del diccionario con 5 letras', 'FontSize', 15)
grid on, grid minor
