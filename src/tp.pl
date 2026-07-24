:- begin_tests(tpIntegrador, []).

%Tests punto 1
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

%Tests punto 2
test("un personaje no recuerda una hazania que todavia no conoce"):-
    not(esRecordada(destruirAlDemonioAura, lawine, 1380)).

test("un personaje recuerda una hazania que escucho mientras no hayan pasado mas de 15 anios"):-
    esRecordada(destruirAlDemonioAura, lawine, 1400).

test("un personaje ya no recuerda una hazania que escucho cuando pasaron mas de 15 anios"):-
   not(esRecordada(destruirAlDemonioAura, lawine, 1410)).    

test("un personaje recuerda una hazania que leyo cuando todavia no paso el lapso de tiempo correspondiente a sus paginas"):-
    esRecordada(destruirAlDemonioAura, voll, 1450).

test("un personaje ya no recuerda una hazania leida cuando paso el lapso de tiempo correspondiente a sus paginas"):-
    not(esRecordada(destruirAlDemonioAura, voll, 1460)).

test("un personaje recuerda una hazania que presencio siempre mientras este vivo"):-
    esRecordada(rescatarALaHermanaDeWirbel, wirbel, 1430).

test("un personaje ya no recuerda una hazania que presencio cuando no esta vivo"):-
    not(esRecordada(rescatarALaHermanaDeWirbel, wirbel, 1440)).

test("una hazania esta corroborada cuando solo se recuerda una version"):-
    estaCorroborada(rescatarALaHermanaDeWiber).

test("una hazania no esta corroborada cuando se recuerda mas de una version"):-
    not(estaCorroborada(destruirAlDemonioAura)).

test("una hazania paso al olvido cuando ya no la recuerda nadie vivo"):-
    pasoAlOlvido(destruirAlDemonioAura,1460).

test("una hazania no paso al olvido cuando todavia vive alguien que la recuerde"):-
    not(pasoAlOlvido(destruirAlDemonioAura,1440)).

:- end_tests(tpIntegrador).


%----------------------------------------------
%PARTE 1

%Punto 1: la gente
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

%Punto 2: los recuerdos
%conoceHazania(personaje, forma, anio, hazania, heroes, hugar)

conoceHazania(wirbel, presencio, 1390, rescatarALaHermanaDeWirbel, heroes(stark, fern), klares).
conoceHazania(frieren, presencio, 1390, rescatarALaHermanaDeWirbel, heroes(stark, fern), klares).
conoceHazania(lawine, escucho, 1393, destruirAlDemonioAura, heroes(frieren), weise).
conoceHazania(voll, leyo(lectura,50), 1400, destruirAlDemonioAura, heroes(denken), auberst). %otra version misma hazania
conoceHazania(serie, leyo(lectura,100), 1335, destruirAlReyDemonio, heroes(frieren, himmel, heiter, eisen), ende).
conoceHazania(kanne, presencio, 1375, recuperarAlGatoPerdido, heroes(himmel, frieren), weise).

%Queremos poder contestar sí una hazaña es recordada por alguien en cierto año, sabiendo que:
    %si una persona presenció una hazaña, la recuerda desde ese momento por el resto de su vida.
    %si una persona escuchó una canción sobre una hazaña, la recuerda por 15 años.
    %si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como páginas tenga el libro.        

%aniosPorEscucha(15). 

esRecordada(Hazania, Persona, Anio):-
    conoceHazania(Persona, presencio,AnioRecuerdo,Hazania,_,_),
    Anio >= AnioRecuerdo,
    estaVivo(Persona, Anio).
esRecordada(Hazania, Persona, Anio):-
    conoceHazania(Persona, escucho,AnioRecuerdo,Hazania,_,_),
    Anio >= AnioRecuerdo,
    Anio =< AnioRecuerdo + 15,
    estaVivo(Persona, Anio).
esRecordada(Hazania, Persona, Anio):-
    conoceHazania(Persona, leyo(lectura, CantidadLectura),AnioRecuerdo,Hazania,_,_),
    Anio >= AnioRecuerdo,
    Anio =< AnioRecuerdo + CantidadLectura,
    estaVivo(Persona, Anio).

%Queremos contestar sí una hazaña está o no corroborada.
%na hazaña está corroborada si solo hay una versión de la misma, y no lo está si hubo diferentes personas que la conocieron con distintos detalles
%(ya sea diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña)
%No importa el año o si las personas las recuerdan al mismo tiempo para esto.

estaCorroborada(Hazania):-
    not((
        conoceHazania(_, _, _, Hazania, Heroes, Lugar),
        conoceHazania(_, _, _, Hazania, OtrosHeroes, OtroLugar),
        (Heroes \= OtrosHeroes ; Lugar \= OtroLugar)
    )).
    %si alguien conoce otra version con otros heroes y/o lugar da true -> con el not devuelve false y viceversa.

%Queremos saber si en cierto año una hazaña pasó al olvido, lo cuál ocurre si ya nadie la recuerda en ese año.
pasoAlOlvido(Hazania,Anio):-
    not((persona(Persona,_,_,_) , esRecordada(Hazania, Persona, Anio))).

%----------------------------------------------

%Punto 3: conmemorando hazañas 

% A

%diaFestivo(Pueblo, Hazania, AnioInicio)
diaFestivo(weise, destruirAlReyDemonio, 1340).

%estatua(Pueblo, Material, Nombre, Hazania, AnioConstruccion)
estatua(auberst, bronce, elEquipoDeHeroes, destruirAlReyDemonio, 1370).
estatua(auberst, marmol, elHeroeDelSur, destruirASchlatElOmnisciente, 1340).

%mantenimiento(Nombre, Anio)
mantenimiento(elEquipoDeHeroes, 1400).
mantenimiento(elEquipoDeHeroes, 1450).
mantenimiento(elHeroeDelSur, 1410).