% ÁRBOL ES UN "ARRAY" QUE TENDRÁ UNA PREGUNTA Y UNA SIGUIENTE PREGUNTA A ELLA O UNA SIGUIENTE CONJETURA A ELLA
:- dynamic tree_y/2. % IF ANSWER == si
:- dynamic tree_n/2. % IF ANSWER == NO
% GUESS ES UN "ARRAY" QUE TENDRÁ UNA PREGUNTA Y UNA CONJETURA PARA ESA PREGUNTA
:- dynamic guess_y/2. % IF ANSWER == si
:- dynamic guess_n/2. % IF ANSWER == NO



% Función try_guessing
% imprimirá las preguntas y el seguimiento correspondiente a la pregunta actual
try_guessing(Tree, Guess) :- 
    write(Tree), write(" (si./no.) "),      % Pregunta sobre impresiones y posibles respuestas
    nl, read(Input), nl,        % Leer input
    (
    (Input=si, tree_y(Tree, NewTree), try_guessing(NewTree, Guess), !);
    (Input=si, not(tree_y(Tree, _)), guess_y(Tree, Guess), !);
    (Input=no, tree_n(Tree, NewTree), try_guessing(NewTree, Guess), !);
    (Input=no, not(tree_n(Tree, _)), guess_n(Tree, Guess), !)
        ).
    

% check_guess_fuction
% comprobará si la suposición del ordenador es correcta
check_guess(Guess, Input) :-
    write("Su animal es "),
    write(Guess), write(" (si./no.) "),      % Adivina el animal y el jugador debe confirmar si acierta o falla
    nl, read(Input), nl,        % Leer input
    (
      (Input=si, write("¡Lo sabía!"), nl);  
      (Input=no, write("¡Oh, no! Adiviné mal."), nl)  
        ).


% función actualizar_animales
% actualizará el fichero de texto con un nuevo animal y una pregunta que lleva a él
update_animals(Guess) :-
    write("¿En qué animal has pensado? "),
    nl, read(PlayerAnimal),     % Leer animal del jugado

    write("¿Qué pregunta debo hacer para adivinar su animal?"),
    nl, read(NewQuestion),      % Leer la pregunta del jugador

    write("¿Cuál es la respuesta a esa pregunta según su animal? "),
    nl, write(NewQuestion), write(" (si./no.) "),
    nl, read(Answer),

    (
        (
            guess_y(OldTree, Guess),                    % Cambia la guess a un árbol, así podemos tener una nueva pregunta
            retract(guess_y(OldTree, Guess)),           % Remover guess
            assertz(tree_y(OldTree, NewQuestion))       % Crear arbol
            );
        
        (
            guess_n(OldTree, Guess),                    % Cambia la guess a un árbol, así podemos tener una nueva pregunta
            retract(guess_n(OldTree, Guess)),           % Remover guess
            assertz(tree_n(OldTree, NewQuestion))       % Crear arbol
            )
        ),
    (
        (
            Answer=si,
            assertz(guess_y(NewQuestion,PlayerAnimal)), % configura un array de conjeturas con el nuevo animal si la respuesta es si
            assertz(guess_n(NewQuestion, Guess))        % configurar el antiguo animal con la nueva pregunta si la respuesta es no
            );
        (
            Answer=no,
            assertz(guess_n(NewQuestion,PlayerAnimal)),% si la respuesta es no, crea una matriz de conjeturas con el nuevo animal
            assertz(guess_y(NewQuestion, Guess))   % configurar el antiguo animal con la nueva pregunta si la respuesta es si
            )
        ).


% función de actualización
% leer el archivo y actualizar el juego con el nuevo contenido añadido
update :-
    tell('animals.txt'),
    listing(start_pos),
    listing(tree_y),
    listing(tree_n),
    listing(guess_y),
    listing(guess_n),
    told.

% función jugar
% ejecutarla para jugar
play :-
    consult('animals.txt'),
    write("¡Hola! Soy una inteligencia informática hecha para adivinar el animal en el que estás pensando."),
    nl, write("¡Piensa en cualquier animal y no me digas!"),
    nl, write("Responde a mis preguntas con un sí o un no, y no olvides añadir un ."),
    nl, write(" al final de cada respuesta, y proporcionar nuevas preguntas/animales"),
    nl, write(" ¡entre comillas!"),
    nl, nl, nl,
    start_pos(FirstQuestion), try_guessing(FirstQuestion, Answer), check_guess(Answer, GameOver),
    (
        (GameOver=si, write("¡Te dije que adivinaría tu animal!"), nl);
        (GameOver=no, update_animals(Answer), write("¡Lo adivinaré la próxima vez!"), nl)
    ),
    update,
    write("¿Quieres volver a jugar?"), 
    nl, read(Restart),
    (   
        (Restart=si, nl, play, !, fail);
        (Restart=no, write("Gracias por jugar."), nl, !, fail)
    ).