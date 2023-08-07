:-style_check(-singleton).
:- consult('inputVal.pl').
:- consult('ahorcado.pl').
:- consult('game.pl').

%schwiergekeit %grad
category(animales, [gato, perro, cocodrilo, raton, leon, tigre, aguila, puercoespin, vaca]).
category(frutas, [freza, banana, manzana, fresa, cereza, durazno]).
category(ciudades, [cologne, berlin, duesseldorf, bonn, tangier, tokyo, seoul]).
category(profecional, [actitud, prolog, interdisciplinario, inconsecuente]).

category(all, []).
category_(E):-
    findall(List, category(_, List),L),
    flatten(L,E).

getRandomWord(List, Elt) :- 
    length(List, Len),
    Len > 0,
    random(0, Len, Rnumber),
    nth0(Rnumber, List, Elt).

getRandomWord([], _) :- !.

start_game :- 
    asserta(hangman(6)),
    ask_difficulty(Difficulty),
    more_difficult(Difficulty),
    ask_category(Guess),
    (Guess = all 
    -> category_(List);
    category(Guess, List)),

    getRandomWord(List, Elt),
    name(Elt, CList),
    code_word(CList, MysteryWord),
    write("Palabra: "), nl,
    write(MysteryWord), nl,
    write("###### Juego iniciado ######"),nl,
    write("----------------------------"),nl,
    hangman(X),
    while_game(X, Elt, MysteryWord).

while_game(N,Elt, MysteryWord) :- 
    N>0, 
    format('Tienes ~w intentos ~n', [N]), 
    write("----------------------------"),nl,
    ask_next_char(Char),
    correct_input(Elt, Char, MysteryWord, LetterInMystery, N, K),
    win(K, Elt, MysteryWord, LetterInMystery).

while_game(N,Elt, MysteryWord) :- 
    N=<0, 
    !,
    write("Perdiste!"), nl,
    write("La palabra era: "), write(Elt).

win(K, Elt, MysteryWord, LetterInMystery) :- 
    Elt = LetterInMystery,
    !,
    write("Felizades ganastes!"),nl,
    write('  (_)'), nl,
    write('  \\|/'), nl,
    write('   |'), nl,
    write('  / \\'), nl.

win(K, Elt, MysteryWord, LetterInMystery)  :-  
    while_game(K, Elt, LetterInMystery).

correct_input(MysteryWord, Letter, Lnew, LetterInMystery, M,N) :-
    not(check(MysteryWord, Letter)),
    N is M -1,
    LetterInMystery = Lnew,
    hang_the_man, nl,
    write(LetterInMystery),nl.

correct_input(MysteryWord, Letter, Lnew, LetterInMystery, M,N) :-
    check(MysteryWord, Letter),
    name(MysteryWord, L),
    char_code(Letter,X),
    word_guess_indexes(L,  X, I),
    call_replace(I, Lnew, X, List, ListA),
    name(LetterInMystery, ListA),
    N = M,
    write(LetterInMystery),nl.

code_word(CList, MysteryWord) :- 
    maplist(make_mystery, CList, MysteryWordInAscii),
    name(MysteryWord, MysteryWordInAscii).

incr(X, X1) :-
    X1 is X+1.

call_replace([], Lnew, Letter, ListA, ListA):-
    string_to_list(Lnew,ListA),
    !,nl.
   
call_replace([H|T], Lnew, Letter, List, ListA):-
    replace(H, Lnew, Letter, List),
    atom_codes(W, List),
    call_replace(T, W, Letter, List2, ListA).

replace(I, L, E, K) :-
    name(L, InAscii),
    nth0(I, InAscii, _, R),
    nth0(I, K, E, R).

word_guess_indexes(List, Letter, Indexes) :-
    findall(Index, 
            (nth0(Index, List, Element), Element = Letter),
            Indexes).

check(MysteryWord,Letter):-
    char_code(Letter, X),
    name(MysteryWord, MysteryWordInAscii),
    member(X, MysteryWordInAscii).

make_mystery(Ascii, Asterik) :-
  Asterik = 0'*.