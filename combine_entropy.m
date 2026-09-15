% combina la entropia del
%primer intento (S) con la del segundo (S2) para obtener la entropia
%conjunta H(x,y) y el ranking final de mejores aperturas.
%
%Requiere tener ya calculadas y cargadas estas variables:
%  diccionario, Y  -> el diccionario de palabras
%  S               -> entropia de cada palabra a un intento (de entropy_first_guess)
%  C, P            -> recuento y probabilidad de cada patron (de entropy_first_guess)
%  S2              -> entropia de cada candidata de segundo intento, por
%                      patron y por palabra (de entropy_second_guess)
%

%% CALCULO DE LA ENTROPÍA DEL SEGUNDO INTENTO
load(fullfile('results', 'first_guess.mat'), 'C', 'S', 'Y', 'P');
load(fullfile('results', 'second_guess.mat'), 'S2');
diccionario = num2cell(char(Y));
N = length(diccionario);
S12 = zeros(N);
S2C = zeros(N);

for i = 1:N
  for ii = 1:length(C{1,i})
    maxS2 = max(S2{ii,i});
    pp = P{1,i};
    S2C(ii,i) = pp(ii,1)*maxS2;
  endfor
  S12(1,i)=sum(S2C(:,i));
 endfor

 entropia = S' + S12;
 [A, B] = sort(entropia, 'descend');
fprintf('\nMejor palabra: %s  H(X/Y) = %.4f bits', upper(Y{B(1)}), A(1));
