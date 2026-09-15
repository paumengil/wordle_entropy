# ¿Cuál es la mejor palabra para comenzar en el WORDLE?

Este trabajo pretende, usando la entropía de Shannon , responder esta pregunta teniendo en cuenta la probabilidad de aparición de los distintos patrones, la información que estos nos dan y la reducción del espacio de fases (las palabras que nos quedan del diccionario tras ese intento)

Este repositorio es una versión ordenada, segmentada y comentada del código original que utilicé para mi TFG, *El concepto de la entropía en la física* (Universidad de Sevilla, 2023) tutorizado por [Jose María Martín Olalla](https://github.com/martin-olalla). En el trabajo original se usó Matlab y un diccionario con todas las palabras en español de cinco letras (9571 palabras) estos cálculos llevaron días, por lo que para segmentar y testear esta versión se ha utilizado y adaptado el código para Octave y se ha testeado con un diccionario de 20 palabras de cinco letras en español.

La mejor palabra para comenzar en el wordle con el diccionario español si solo tuviéramos un intento es *Lorea*. Si tuviéramos en cuenta que tras la primera palabra luego podemos acotar más con una segunda, la mejor palabra para comenzar sería *Corle*. Este trabajo se realizó teniendo en cuenta solo dos intentos ( y no cinco como en el juego original ) debido a dos factores:

1. El tiempo de computación que requirió tener en cuenta el segundo intento fue del orden de días.
2. El objetivo del proyecto era ejemplificar y visualizar de forma práctica las propiedades de la entropía de Shannon. Con la entropía del segundo intento ya se resolvían las propiedades de la entropía conjunta *H(x,y)*.

## Contenido

* *wordle\_pattern* : Es la función principal y se encarga de enfrentar una palabra concreta *guess* frente a un diccionario cualquiera. Como salida principal, da la entropía de esa palabra (S, en bits) y, de paso, también los patrones únicos que puede producir, cuántas veces se repite cada uno y sus probabilidades.
* *entropy\_first\_guess* : Usa la función *wordle\_pattern* para obtener la entropía de cada una de las palabras del diccionario. Se obtiene cuál es la mejor palabra si solo tuviéramos un intento.
* *entropy\_second\_guess* : Para cada palabra del primer intento y cada patrón posible que puede salir, calcula con la función *wordle\_pattern* y las variables obtenidas de *entropy\_first\_guess* la entropía de todas las palabras candidatas que quedarían en juego después del primer intento. Es decir, calcula por separado la entropía de todas las jugadas posibles de segundo intento.
* *combine\_entropy* : A partir de las entropías calculadas por *entropy\_second\_guess* y *entropy\_first\_guess*, se queda en cada caso con la mejor candidata posible de segundo intento y calcula, para cada palabra de apertura, la entropía conjunta de jugar los dos intentos seguidos. Con eso genera el ranking final de mejores palabras de apertura teniendo en cuenta el segundo intento.
* *plot\_results* : Representa la mejor palabra y su mejor patrón de la misma forma que en el juego original. Además, grafica la entropía frente al número de patrones y comprueba el principio de máxima entropía. Requiere de al menos las variables obtenidas tras *entropy\_first\_guess*.

## Declaración de Uso de IA.

En el proyecto original de TFG no se usó la IA para ninguno de los scripts.
En la adaptación subida a la plataforma se ha usado la IA para decidir en qué scripts se separaba el código original, de soporte para refrescar el funcionamiento de algunas líneas y con algunos problemas de compatibilidad entre MATLAB y Octave.
Y por último, se ha usado para optimizar en la función *plot\_results* en la forma de colorear los patrones. Todas las líneas de código a excepción de esta pertenecen al proyecto original y han sido transcritas, comentadas y testeadas por mi una a una.

