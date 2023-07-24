ask_difficulty(Difficulty):-  
    write('Elige la dificultad (Escribe el numero ejmp= 0.)'),nl,
    write('0: facil'), nl,
    write('1: normal'), nl,
    write('2: dificil'), nl,
    read(TempDifficulty),
    (   between(0,2,TempDifficulty)
        ->  Difficulty = TempDifficulty,
            write('!!!Dificultad elegida¡¡¡.'), nl
        ;   write('Valor incorrecto. ingresa un numero valido'), nl,
            ask_difficulty(Difficulty)
    ).

ask_category(Category):-  
    write('De que categoria quieres que sea la palabra (Escribe la categoria)'),
    write(' animales '), write('o ciudades'), write(' o frutas'),write(' o profecional'), write(' o all'), nl,
    read(TempCategory),
    (   category(TempCategory,_)
        ->  Category = TempCategory
        ;   write('valor incorrecto, ingresa una categoria valida.'), nl,
            ask_category(Category)
    ).

ask_next_char(Char):-  
    write("##### Enter a Character : #####"),nl,
    read(TempChar),
    (   atom_length(TempChar, 1)
        ->
            (char_type(TempChar, alpha)
            ->  Char = TempChar
            ;   writeln('Valor incorrecto, por favor ingrese un char.'), 
            ask_next_char(Char))
        ;   writeln('Valor incorrecto, por favor ingrese un char'), 
            ask_next_char(Char)
    ).