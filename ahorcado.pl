/* this file handles the lifes of the user and the output of the hangman */

hang_the_man:-
    hangman(X),
    hangman_progress(X).

more_difficult(X):-
    X =:= 0.
more_difficult(X):-
    X \= 0,
    hang_progress,
    Y = X-1,
    more_difficult(Y).

:- dynamic hangman/1.
hangman(6).

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
    write('Te colgaron'),
    asserta(hangman(6)).

hang_progress:-
    hangman(X),
    Y is X-1,
    asserta(hangman(Y)).