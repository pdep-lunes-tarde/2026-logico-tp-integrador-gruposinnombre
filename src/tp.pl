
% Personas: persona(Nombre, Pueblo, AnioNacimiento, Raza)
persona(denken,  auberst, 1290, humano).
persona(voll,    ende,    1200, enano).
persona(serie,   weise,   500,  elfo).
persona(fern,    weise,   1370, humano).
persona(stark,   riegel,  1368, humano).
persona(lawine,  auberst, 1372, humano).
persona(kanne,   weise,   1365, humano).
persona(wirbel,  klares,  1350, humano).
persona(lernen,  auberst, 1315, humano).
persona(frieren, weise,   100,  elfo).
persona(eisen,   riegel,  1150, enano).

esperanzaDeVida(humano, 80).
esperanzaDeVida(enano, 350).
% No hace falta agregar para los elfos porque no mueren de viejos

estaVivo(Nombre, Anio):-
    persona(Nombre, _, AnioNacimiento, Raza),
    AnioNacimiento =< Anio,
    esperanzaDeVida(Raza, Vida),
    Anio =< AnioNacimiento + Vida.
estaVivo(Nombre, Anio) :-
    persona(Nombre, _, AnioNacimiento, elfo),
    AnioNacimiento =< Anio.


% Tests:
:- begin_tests(tpIntegrador, []).

test("una persona esta viva en un anio si nacio antes de ese anio y no supero su esperanza de vida", nondet):-
    estaVivo(kanne, 1370).

test("una persona no esta viva en un anio anterior a su nacimiento"):-
    not(estaVivo(kanne, 1300)).

test("una persona no esta viva en un anio en el que ya supero su esperanza de vida"):-
    not(estaVivo(kanne, 2000)).

test("un enano esta vivo si no pasaron mas de 350 anios desde su nacimiento", nondet):-
    estaVivo(voll, 1550).

test("un enano no esta vivo si ya pasaron mas de 350 anios desde su nacimiento"):-
    not(estaVivo(voll, 1551)).

test("un elfo esta vivo en cualquier anio posterior a su nacimiento, sin importar cuanto tiempo paso", nondet):-
    estaVivo(serie, 5000).

test("un elfo nunca muere de viejo", nondet):-
    estaVivo(frieren, 5000).

test("una persona no esta viva en el anio anterior a su nacimiento"):-
    not(estaVivo(denken, 1289)).

test("un enano esta vivo justo en el anio limite de su esperanza de vida", nondet):- % eisen: 1150+350=1500
    estaVivo(eisen, 1500).

test("un enano deja de estar vivo apenas pasa el anio limite de su esperanza de vida"):-
    not(estaVivo(eisen, 1501)).

:- end_tests(tpIntegrador).
