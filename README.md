# AhorcadoProlog

## Como instalar prolog windows

Para instalar Prolog en Windows, sigue estos pasos:

Descargar SWI-Prolog:

>Ve al sitio oficial de SWI-Prolog en https://www.swi-prolog.org/Download.html
Haz clic en el enlace de descarga correspondiente a tu versión de Windows (32 bits o 64 bits).
Se descargará un instalador ejecutable (por ejemplo, swipl-x.y.z-win64.exe para 64 bits).
Ejecutar el instalador:

>Haz doble clic en el archivo descargado (swipl-x.y.z-win64.exe) para ejecutar el instalador.
Si Windows muestra una advertencia de seguridad, selecciona "Ejecutar" o "Sí" para permitir la instalación.
Configurar la instalación:

>El instalador te guiará a través del proceso de instalación. Puedes aceptar las opciones predeterminadas o personalizarlas según tus preferencias.
Es posible que se te pida seleccionar la carpeta de destino para la instalación. Por lo general, es recomendable dejar la carpeta predeterminada seleccionada por el instalador.
Finalizar la instalación:

>Una vez que hayas seleccionado las opciones de instalación, haz clic en "Instalar" para comenzar la instalación.
Espera a que el proceso de instalación se complete.
Verificar la instalación:

>Después de la instalación, SWI-Prolog estará disponible en tu computadora.
Para verificar que Prolog se instaló correctamente, abre el menú Inicio y busca "SWI-Prolog". Deberías ver el programa "SWI-Prolog" en la lista de resultados de búsqueda.
Haz clic en "SWI-Prolog" para abrir el intérprete de Prolog en una ventana de consola.

Para instalar SWI-Prolog en Linux, sigue estos pasos:

1. Actualizar el sistema:
   Antes de instalar cualquier paquete, es recomendable actualizar el sistema para asegurarse de tener los últimos paquetes disponibles. Abre una terminal y ejecuta los siguientes comandos:

   ```
   sudo apt update
   sudo apt upgrade
   ```

2. Instalar SWI-Prolog:
   SWI-Prolog está disponible en los repositorios predeterminados de muchas distribuciones de Linux. Puedes instalarlo usando el gestor de paquetes de tu distribución. Por ejemplo, si estás usando Ubuntu o Debian, ejecuta el siguiente comando:

   ```
   sudo apt install swi-prolog
   ```

   Si estás usando otra distribución de Linux, busca el paquete SWI-Prolog en los repositorios o consulta la documentación de tu distribución para obtener instrucciones específicas de instalación.

3. Verificar la instalación:
   Una vez que la instalación se complete, puedes verificar si SWI-Prolog se instaló correctamente abriendo una terminal y ejecutando el siguiente comando:

   ```
   swipl
   ```

   Esto abrirá el intérprete de Prolog en la terminal y estarás listo para empezar a programar en Prolog.

¡Listo! Ahora tienes SWI-Prolog instalado en tu sistema Linux. Puedes comenzar a escribir y ejecutar programas lógicos en Prolog. ¡Disfruta programando!


## Como jugar 

en la terminal escribe
```
swipl -s mainAhorcado.pl 
```

cuando la terminal se haya inicial escribe
```
start_game.
```

recuerda que siempre que escribas en prolog pon un . al final de la palabra



## mainAhorcado
<pre>
```prolog
% Importaciones y configuraciones
:-style_check(-singleton).
:- consult('inputVal.pl').
:- consult('ahorcado.pl').

% Diccionario de palabras en diferentes categorías y dificultades
category(animales, [gato, perro, cocodrilo, raton, leon, tigre, aguila, puercoespín, vaca]).
category(frutas, [piña, banana, manzana, fresa, cereza, durazno]).
category(ciudades, [cologne, berlin, duesseldorf, bonn, tangier, tokyo, seoul]).
category(profecional, [actitud, prolog, interdisciplinario, inconsecuente]).
category(all, []).

% Predicado para obtener una lista con todas las palabras de todas las categorías
category_(E) :-
    findall(List, category(_, List), L),
    flatten(L, E).

% Predicado para obtener una palabra aleatoria de una lista no vacía
getRandomWord(List, Elt) :- 
    length(List, Len),
    Len > 0,
    random(0, Len, Rnumber),
    nth0(Rnumber, List, Elt).

% Predicado para obtener una palabra aleatoria según la categoría y dificultad seleccionadas
start_game :- 
    asserta(hangman(6)), % Establecer el número de intentos iniciales
    ask_difficulty(Difficulty), % Preguntar la dificultad
    more_difficult(Difficulty), % Establecer una dificultad mayor (si el jugador lo elige)
    ask_category(Guess), % Preguntar la categoría
    (Guess = all 
    -> category_(List); % Obtener todas las palabras si la categoría seleccionada es "all"
    category(Guess, List)), % Obtener las palabras de la categoría seleccionada
    getRandomWord(List, Elt), % Obtener una palabra aleatoria de la lista seleccionada
    name(Elt, CList),
    code_word(CList, MysteryWord), % Convertir la palabra en una versión con asteriscos (misterio)
    write("Palabra: "), nl,
    write(MysteryWord), nl,
    write("###### Juego iniciado ######"),nl,
    write("----------------------------"),nl,
    hangman(X),
    while_game(X, Elt, MysteryWord).

% Ciclo principal del juego
while_game(N, Elt, MysteryWord) :- 
    N > 0, % Verificar que haya intentos disponibles
    format('Tienes ~w intentos ~n', [N]), 
    write("----------------------------"),nl,
    ask_next_char(Char),
    correct_input(Elt, Char, MysteryWord, LetterInMystery, N, K), % Verificar si la letra ingresada es correcta
    win(K, Elt, MysteryWord, LetterInMystery). % Verificar si se ha ganado el juego

while_game(N, Elt, MysteryWord) :- 
    N =< 0, % No hay más intentos
    !,
    write("Perdiste!"), nl,
    write("La palabra era: "), write(Elt).

% Predicado para verificar si se ha ganado el juego
win(K, Elt, MysteryWord, LetterInMystery) :- 
    Elt = LetterInMystery, % Se adivinó la palabra completa
    !,
    write("Congratulation, you won!"),nl,
    write('  (_)'), nl,
    write('  \\|/'), nl,
    write('   |'), nl,
    write('  / \\'), nl.

win(K, Elt, MysteryWord, LetterInMystery)  :-  
    while_game(K, Elt, LetterInMystery). % Continuar el juego

% Predicado para verificar si una letra ingresada es correcta o incorrecta
correct_input(MysteryWord, Letter, Lnew, LetterInMystery, M, N) :-
    not(check(MysteryWord, Letter)), % Verificar si la letra no está en la palabra
    N is M - 1, % Decrementar el contador de intentos
    LetterInMystery = Lnew, % Mantener la palabra "misterio" sin cambios
    hang_the_man, nl, % Dibujar parte del "ahorcado"
    write(LetterInMystery), nl.

correct_input(MysteryWord, Letter, Lnew, LetterInMystery, M, N) :-
    check(MysteryWord, Letter), % Verificar si la letra está en la palabra
    name(MysteryWord, L), % Convertir la palabra en una lista de códigos ASCII
    char_code(Letter, X), % Obtener el código ASCII de la letra ingresada
    word_guess_indexes(L, X, I), % Obtener las posiciones donde está la letra en la palabra
    call_replace(I, Lnew, X, List, ListA), % Reemplazar los asteriscos en las posiciones correctas con la letra ingresada
    name(LetterInMystery, ListA), % Convertir la lista de códigos ASCII en una palabra
    N = M, % Mantener el contador de intentos
    write(LetterInMystery), nl.

% Predicado para convertir una palabra en una versión "misterio" con asteriscos
code_word(CList, MysteryWord) :- 
    maplist(make_mystery, CList, MysteryWordInAscii),
    name(MysteryWord, MysteryWordInAscii).

% Predicado para incrementar una variable
incr(X, X1) :-
    X1 is X + 1.

% Predicado para reemplazar un elemento en una lista en una posición dada
replace(I, L, E, K) :-
    name(L, InAscii),
    nth0(I, InAscii, _, R),
    nth0(I, K, E, R).

% Predicado para obtener las posiciones de una letra en una palabra
word_guess_indexes(List, Letter, Indexes) :-
    findall(Index, 
            (nth0(Index, List, Element), Element = Letter),
            Indexes).

% Predicado para verificar si una letra está en una palabra
check(MysteryWord, Letter) :-
    char_code(Letter, X),
    name(MysteryWord, MysteryWordInAscii),
    member(X, MysteryWordInAscii).

% Predicado para convertir una letra en un asterisco
make_mystery(Ascii, Asterik) :-
    Asterik = 0'*.    

```
</pre>

## inputVal

<pre>
´´´prolog

% Predicado para preguntar al usuario la dificultad del juego
ask_difficulty(Difficulty):-  
    write('Elige la dificultad'),nl,
    write('0: facil'), nl,
    write('1: normal'), nl,
    write('2: dificil'), nl,
    read(TempDifficulty), % Leer la entrada del usuario y almacenarla en TempDifficulty
    (   between(0,2,TempDifficulty) % Verificar si la entrada está entre 0 y 2
        ->  Difficulty = TempDifficulty, % Asignar la dificultad elegida a la variable Difficulty
            write('!!!Dificultad elegida¡¡¡.'), nl
        ;   write('Valor incorrecto. ingresa un numero valido'), nl,
            ask_difficulty(Difficulty) % Si la entrada no es válida, volver a preguntar la dificultad
    ).

% Predicado para preguntar al usuario la categoría de la palabra a adivinar
ask_category(Category):-  
    write('De que categoria quieres que sea la palabra'),
    write(' animales '), write('o ciudades'), write(' o frutas'),write(' o profecional'), write(' o all'), nl,
    read(TempCategory), % Leer la entrada del usuario y almacenarla en TempCategory
    (   category(TempCategory, _) % Verificar si la categoría ingresada es válida (existe en la base de conocimientos)
        ->  Category = TempCategory % Asignar la categoría elegida a la variable Category
        ;   write('valor incorrecto, ingresa una categoria valida.'), nl,
            ask_category(Category) % Si la categoría no es válida, volver a preguntar
    ).

% Predicado para preguntar al usuario el siguiente caracter a adivinar
ask_next_char(Char):-  
    write("##### Enter a Character : #####"),nl,
    read(TempChar), % Leer la entrada del usuario y almacenarla en TempChar
    (   atom_length(TempChar, 1) % Verificar si la entrada tiene longitud 1 (es un solo caracter)
        ->  (char_type(TempChar, alpha) % Verificar si es un caracter alfabético
            ->  Char = TempChar % Asignar el caracter ingresado a la variable Char
            ;   writeln('Valor incorrecto, por favor ingrese un char.'), 
                ask_next_char(Char)) % Si el caracter no es válido, volver a preguntar
        ;   writeln('Valor incorrecto, por favor ingrese un char'), 
            ask_next_char(Char) % Si la entrada no es válida, volver a preguntar
    ).

´´´
</pre>

## ahorcado
<pre>
```prolog
% Predicado para dibujar la progresión del ahorcado según el número de vidas restantes
hang_the_man:-
    hangman(X),
    hangman_progress(X).

% Predicado para hacer el juego más difícil reduciendo el número de vidas restantes
more_difficult(X):-
    X =:= 0. % Si ya no hay vidas restantes, el juego se mantiene igual (no más difícil)
more_difficult(X):-
    X \= 0, % Si hay vidas restantes
    hang_progress, % Reducir el número de vidas restantes
    Y is X - 1, % Calcular el número de vidas restantes después de reducir una vida
    more_difficult(Y). % Continuar haciendo el juego más difícil

% Definir una variable dinámica para el número de vidas restantes (hangman/1) con un valor inicial de 6
:- dynamic hangman/1.
hangman(6).

% Predicado para dibujar la progresión del ahorcado según el número de vidas restantes (X)
hangman_progress(X):-
    X =:= 6,
    write('__|__'), nl,
    hang_progress.
hangman_progress(X):-
    X =:= 5,
    write('  |'), nl,
    write('  |'), nl,
    write('__|__'), nl,
    hang_progress.
hangman_progress(X):-
    X =:= 4,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('__|__'), nl,
    hang_progress.
hangman_progress(X):-
    X =:= 3,
    write('  |/'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('__|__'), nl,
    hang_progress.
hangman_progress(X):-
    X =:= 2,
    write('  ________'), nl,
    write('  |/     |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('  |'), nl,
    write('__|__'), nl,
    hang_progress.
hangman_progress(X):-
    X =:= 1,
    write('  ________'), nl,
    write('  |/     |'), nl,
    write('  |     (_)'), nl,
    write('  |     \\|/'), nl,
    write('  |      |'), nl,
    write('  |     / \\'), nl,
    write('  |'), nl,
    write('__|__'), nl, nl,
    write('Te colgaron'), % Mensaje mostrado cuando se acaban las vidas
    asserta(hangman(6)). % Restaurar el número de vidas iniciales al juego

% Predicado para reducir el número de vidas restantes (X) después de un error
hang_progress:-
    hangman(X),
    Y is X - 1,
    asserta(hangman(Y)). % Actualizar el número de vidas restantes en la variable dinámica

```
</pre>