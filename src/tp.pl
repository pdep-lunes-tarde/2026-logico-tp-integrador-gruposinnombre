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
    persona(Nombre, _, AnioNacimiento, _),
    AnioNacimiento =< Anio,
    not(murio(Nombre, Anio)).

murio(Persona, Anio):-
    persona(Persona, _, AnioNacimiento, Raza),
    esperanzaDeVida(Raza, Anios),
    Anio > AnioNacimiento + Anios.

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

%3 Para reconocer una hazaña por conmemoración.

esRecordada(Hazania, Persona, Anio) :-
    esRecordadaPorConmemoracion(Hazania, Persona, Anio).

%Queremos contestar sí una hazaña está o no corroborada.
%na hazaña está corroborada si solo hay una versión de la misma, y no lo está si hubo diferentes personas que la conocieron con distintos detalles
%(ya sea diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña)
%No importa el año o si las personas las recuerdan al mismo tiempo para esto.

estaCorroborada(Hazania):-
    %-----------------------------------------------------
    %sugerencia: corroborar primero que una hazaña exista.
    conoceHazania( _, _, _, Hazania, _, _),
    %Fin sugerencia.
    %-----------------------------------------------------
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

%Cantidad de años que una estatua permanece en buen estado
%aniosEnBuenEstado(material, años)
aniosEnBuenEstado(marmol, 30).
aniosEnBuenEstado(bronce, 15).

%Año desde el que una persona conoce la hazaña.
%Si ya había nacido cuando comenzó la conmemoración, la conoce desde el comienzo.
anioEnQueConoce(AnioInicio, AnioNacimiento, AnioInicio) :-
    AnioInicio >= AnioNacimiento.

%Si nació después, la conoce desde su nacimiento.
anioEnQueConoce(AnioInicio, AnioNacimiento, AnioNacimiento) :-
    AnioNacimiento > AnioInicio.

%Una estatua fue puesta en condiciones cuando fue construida.
puestaEnCondiciones(NombreEstatua, AnioConstruccion) :-
    estatua(_, _, NombreEstatua, _, AnioConstruccion).

%También vuelve a quedar encondiciones cuando recibe mantenimiento.
puestaEnCondiciones(NombreEstatua, AnioMantenimiento) :-
    mantenimiento(NombreEstatua, AnioMantenimiento).

%Una estatua estáen buen estado si desde su construcción o último mantenimiento no pasó más
%tiempo del permitido.
estatuaEnBuenEstado(NombreEstatua, AnioConsulta) :-
    estatua(_, Material, NombreEstatua, _, _),
    aniosEnBuenEstado(Material, CantidadAnios),
    puestaEnCondiciones(NombreEstatua, AnioPuestaEnCondiciones),
    AnioPuestaEnCondiciones =< AnioConsulta,
    AnioConsulta =< AnioPuestaEnCondiciones + CantidadAnios.

%Recuerdo por día festivo

esRecordadaPorConmemoracion(Hazania, Persona, Anio) :-
    persona(Persona, Pueblo, AnioNacimiento, _),
    diaFestivo(Pueblo, Hazania, AnioInicio),
    anioEnQueConoce(
        AnioInicio,
        AnioNacimiento,
        AnioConocimiento
    ),
    Anio >= AnioConocimiento,
    estaVivo(Persona, Anio).

% Recuerdo por estatua
esRecordadaPorConmemoracion(Hazania, Persona, Anio) :-
    persona(Persona, Pueblo, AnioNacimiento, _),
    estatua(
        Pueblo,
        _,
        NombreEstatua,
        Hazania,
        AnioConstruccion
    ),
    anioEnQueConoce(
        AnioConstruccion, 
        AnioNacimiento,
        AnioConocimiento    
    ),
    Anio >= AnioConocimiento,
    estatuaEnBuenEstado(NombreEstatua, Anio),
    estaVivo(Persona, Anio).


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

test("un ser inmortal esta vivo en cualquier anio posterior a su nacimiento, sin importar cuanto tiempo paso", nondet):-
    estaVivo(serie, 5000).

test("un ser inmortal nunca muere de viejo", nondet):-
    estaVivo(frieren, 5000).

test("una persona no esta viva en el anio anterior a su nacimiento"):-
    not(estaVivo(denken, 1289)).

test("un enano esta vivo justo en el anio limite de su esperanza de vida", nondet):- % eisen: 1150+350=1500
    estaVivo(eisen, 1500).

test("un enano deja de estar vivo apenas pasa el anio limite de su esperanza de vida"):-
    not(estaVivo(eisen, 1501)).

%Tests punto 2
test("una persona no recuerda una hazania que todavia no conoce"):-
    not(esRecordada(destruirAlDemonioAura, lawine, 1380)).

test("una persona recuerda una hazania que escucho mientras no hayan pasado mas de 15 anios"):-
    esRecordada(destruirAlDemonioAura, lawine, 1400).

test("una persona ya no recuerda una hazania que escucho cuando pasaron mas de 15 anios"):-
    not(esRecordada(destruirAlDemonioAura, lawine, 1410)).    

test("una persona recuerda una hazania que leyo cuando todavia no paso el lapso de tiempo correspondiente a sus paginas"):-
    esRecordada(destruirAlDemonioAura, voll, 1450).

test("una persona ya no recuerda una hazania leida cuando paso el lapso de tiempo correspondiente a sus paginas"):-
    not(esRecordada(destruirAlDemonioAura, voll, 1460)).

test("una persona recuerda una hazania que presencio siempre mientras este vivo"):-
    esRecordada(rescatarALaHermanaDeWirbel, wirbel, 1430).

test("una persona ya no recuerda una hazania que presencio cuando no esta vivo"):-
    not(esRecordada(rescatarALaHermanaDeWirbel, wirbel, 1440)).

test("una hazania esta corroborada cuando solo se recuerda una version"):-
    estaCorroborada(rescatarALaHermanaDeWirbel).

test("una hazania no esta corroborada cuando se recuerda mas de una version"):-
    not(estaCorroborada(destruirAlDemonioAura)).

test("una hazania paso al olvido cuando ya no la recuerda nadie vivo"):-
    pasoAlOlvido(destruirAlDemonioAura,1460).

test("una hazania no paso al olvido cuando todavia vive alguien que la recuerde"):-
    not(pasoAlOlvido(destruirAlDemonioAura,1440)).

% Tests Punto 3
%A

test("un pueblo puede conmemorar una hazania mediante un dia festivo", nondet):-
    diaFestivo(weise, destruirAlReyDemonio, 1340).

test("un pueblo puede conmemorar una hazania mediante una estatua de bronce", nondet):-
    estatua(auberst, bronce, elEquipoDeHeroes, destruirAlReyDemonio, 1370).

test("un pueblo puede conmemorar una hazania mediante una estatua de marmol", nondet):-
    estatua(auberst, marmol, elHeroeDelSur, destruirASchlatElOmnisciente, 1340).

test("una estatua puede recibir mantenimiento en distintos anios", nondet):-
    mantenimiento(elEquipoDeHeroes, 1400),
    mantenimiento(elEquipoDeHeroes, 1450).

test("una estatua de marmol puede recibir mantenimiento", nondet):-
    mantenimiento(elHeroeDelSur, 1410).

%B
test("Una persona recuerda una hazaña conmemorada por una estatua de su pueblo si la estatua está en buen estado", nondet) :-
    esRecordada(destruirAlReyDemonio, lawine, 1400).

test("Una persona no recuerda una hazaña conmemorada por una estatua de su pueblo si la estatua no está en buen estadp"):-
    not(esRecordada(destruirAlReyDemonio, lawine, 1390)).

test("Una persona recuerda una hazaña conmemorada con un día festivoen el pueblo donde vive", nondet):-
    esRecordada(destruirAlReyDemonio, fern, 1400).

test("si una conmemoracion comenzo antes de que naciera una persona, la conoce desde el anio de su nacimiento", nondet):-
    esRecordada(destruirAlReyDemonio, fern, 1370).

test("una persona no recuerda una hazania conmemorada antes de haber nacido"):-
    not(esRecordada(destruirAlReyDemonio, fern, 1369)).

test("una estatua de bronce sigue en buen estado hasta 15 anios despues de su construccion", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1385).

test("una estatua de bronce deja de estar en buen estado cuando pasan mas de 15 anios desde su construccion"):-
    not(estatuaEnBuenEstado(elEquipoDeHeroes, 1386)).

test("una estatua vuelve a estar en buen estado cuando recibe mantenimiento", nondet):-
    estatuaEnBuenEstado(elEquipoDeHeroes, 1400).

test("un mantenimiento futuro no permite considerar que una estatua esta en buen estado"):-
    not(estatuaEnBuenEstado(elEquipoDeHeroes, 1390)).

test("una estatua de marmol sigue en buen estado hasta 30 anios despues de su mantenimiento", nondet):-
    estatuaEnBuenEstado(elHeroeDelSur, 1440).

test("una estatua de marmol deja de estar en buen estado cuando pasan mas de 30 anios desde su mantenimiento"):-
    not(estatuaEnBuenEstado(elHeroeDelSur, 1441)).

:- end_tests(tpIntegrador).
