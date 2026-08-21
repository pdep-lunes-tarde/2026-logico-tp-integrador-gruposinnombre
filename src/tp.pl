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
%conoceHazania(personaje, forma(cantidadPaginas), anio, hazania (Hazania, heroes, hugar))

conoceHazania(wirbel, presencio, 1390, hazania(rescatarALaHermanaDeWirbel, [stark, fern], klares)).
conoceHazania(frieren, presencio, 1390, hazania(rescatarALaHermanaDeWirbel, [stark, fern], klares)).
conoceHazania(lawine, escucho, 1393, hazania(destruirAlDemonioAura, [frieren], weise)).
conoceHazania(voll, leyo(50), 1400, hazania(destruirAlDemonioAura, [denken], auberst)).
conoceHazania(serie, leyo(100), 1335, hazania(destruirAlReyDemonio, [frieren, himmel, heiter, eisen], ende)).
conoceHazania(kanne, presencio, 1375, hazania(recuperarAlGatoPerdido, [himmel, frieren], weise)).

%Queremos poder contestar sí una hazaña es recordada por alguien en cierto año, sabiendo que:
    %si una persona presenció una hazaña, la recuerda desde ese momento por el resto de su vida.
    %si una persona escuchó una canción sobre una hazaña, la recuerda por 15 años.
    %si una persona leyó un libro sobre una hazaña, la recuerda por tantos años como páginas tenga el libro.        

aniosPorEscucha(15). 

calculoLimiteRecuerdo(presencio, _, inf).
calculoLimiteRecuerdo(escucho, AnioRecuerdo, AnioLimite):-
    aniosPorEscucha(CantidadAnios),
    AnioLimite is AnioRecuerdo + CantidadAnios.
calculoLimiteRecuerdo(leyo(Paginas), AnioRecuerdo, AnioLimite):-
    AnioLimite is AnioRecuerdo + Paginas.

esRecordada(Hazania, Persona, Anio):-
    conoceHazania(Persona, Modo, AnioRecuerdo, hazania(Hazania, _, _)),
    calculoLimiteRecuerdo(Modo, AnioRecuerdo, AnioLimite),
    Anio >= AnioRecuerdo,
    Anio =< AnioLimite,
    estaVivo(Persona, Anio).

% Queremos contestar sí una hazaña está o no corroborada.
% Una hazaña está corroborada si solo hay una versión de la misma, y no lo está si hubo diferentes personas que la conocieron con distintos detalles
% (ya sea diferentes personas que la llevaron a cabo o diferente lugar en el que ocurrió la hazaña)
% No importa el año o si las personas las recuerdan al mismo tiempo para esto.

estaCorroborada(Hazania):-
    conoceHazania( _, _, _, hazania(Hazania, Heroes, Lugar)),
    forall(
        conoceHazania( _, _, _, hazania(Hazania, OtrosHeroes, OtroLugar)),
        (Heroes == OtrosHeroes, Lugar == OtroLugar)
        ).

%Queremos saber si en cierto año una hazaña pasó al olvido, lo cuál ocurre si ya nadie la recuerda en ese año.
pasoAlOlvido(Hazania,Anio):-
    conoceHazania( _, _, _, hazania(Hazania, _, _)),
    not(
        (persona(Persona,_,_,_), 
        esRecordada(Hazania, Persona, Anio))
        ).

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

conmemoracion(Pueblo, Hazania, diaFestivo(AnioInicio)) :-
    diaFestivo(Pueblo, Hazania, AnioInicio).

conmemoracion(Pueblo, Hazania, estatua(NombreEstatua, Material, AnioConstruccion)) :-
    estatua(Pueblo, Material, NombreEstatua, Hazania, AnioConstruccion).

%Año desde el que una persona conoce la hazaña.
%Si ya había nacido cuando comenzó la conmemoración, la conoce desde el comienzo.
max(Anio, OtroAnio, Anio) :-
    Anio >= OtroAnio.

%Si nació después, la conoce desde su nacimiento.
max(Anio, OtroAnio, Anio) :-
    OtroAnio > Anio.

anioEnQueConoce(AnioInicio, AnioNacimiento, AnioConocimiento) :-
    max(AnioInicio, AnioNacimiento, AnioConocimiento).

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
:- discontiguous esRecordada/3. 
esRecordada(Hazania, Persona, Anio) :-
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
esRecordada(Hazania, Persona, Anio) :-
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

% Parte 2
% Punto 4: los pueblos

% Queremos saber en cierto año:
% si en un pueblo se recuerda una hazaña. 
puebloRecuerdaEn(Anio, Hazania, Pueblo):-
    persona(Persona, Pueblo, _, _),
    esRecordada(Hazania, Persona, Anio).

% cuántas páginas se leyeron en un pueblo. 
% Esto es el total de hojas leídas por habitantes de ese pueblo en ese año.
leidoPorElPuebloEn(Anio, Pueblo, Cantidad):-
    findall(Pagina, (conoceHazania(Persona, leyo(Pagina), Anio, _), persona(Persona, Pueblo, _, _)), Paginas),
    sum_list(Paginas, Cantidad).  

% Cual es el pueblo mas lector.
puebloMasLectorEn(Anio, Pueblo):-
    persona(_, Pueblo, _, _),
    leidoPorElPuebloEn(Anio, Pueblo, Cantidad),
    forall(
        persona(_, OtroPueblo, _, _),
        (leidoPorElPuebloEn(Anio, OtroPueblo, OtraCantidad), Cantidad >= OtraCantidad)
        ).
% funciona provisoriamente, en caso de que hubiesen mas pueblos que hayan leido en el mismo año habria que cambiar la logica, no es escalable.

% si un pueblo es musical, que se cumple si la mayoría de las hazañas que se recuerdan en un pueblo se recuerdan a través de canciones 
% (si se recuerdan por canciones, pero también de otras maneras, sigue siendo musical).
% Hago una lista con todas las hazañas que recuerda el pueblo, luego una lista de todas las hazañas que recuerda el pueblo CON CANCION y calculo si la segunda es mayor o igual a la mitad de la primera
esMusicalEn(Anio, Pueblo) :-
    findall(
        Hazania,
        puebloRecuerdaEn(Anio, Hazania, Pueblo),
        ListaHazanias
    ),
    sort(ListaHazanias, Hazanias), % sort elimina elementos repetidos de la lista (Sugerencia de Claude cuando le mostre lo que habia armado, sino nunca se me hubiese ocurrido que podian repetirse)
    findall(
        Hazania,
        (
            puebloRecuerdaEn(Anio, Hazania, Pueblo),
            conoceHazania(_, escucho, _, hazania(Hazania, _, _))
        ),
        ListaConCancion
    ),
    sort(ListaConCancion, HazaniasConCancion),
    length(Hazanias, Total),
    length(HazaniasConCancion, ConCancion),

    Total > 0,
    ConCancion * 2 > Total.

% si un pueblo es chismoso, que ocurre cuando ninguna de las hazañas que se recuerdan en ese pueblo está corroborada.
esChismosoEn(Anio, Pueblo):-
    puebloRecuerdaEn(Anio, _, Pueblo),
    forall(
        puebloRecuerdaEn(Anio, Hazania, Pueblo),
        not(estaCorroborada(Hazania))
    ).

% si una hazaña es importante para un pueblo. Esto ocurre cuando todos los habitantes de ese pueblo que viven en ese año la recuerdan.
esImportanteEn(Anio, Pueblo, Hazania):-
    puebloRecuerdaEn(Anio, Hazania, Pueblo), % <--- GENERADOR: Primero buscamos qué hazaña recuerda el pueblo
    forall(
        (persona(Persona, Pueblo, _, _), estaVivo(Persona, Anio)),
        esRecordada(Hazania, Persona, Anio)
    ).

% si un pueblo está viviendo tiempos sin precedentes,
% se cumple si todas las hazañas importantes que se recuerdan en un pueblo se recuerdan porque alguien del pueblo las presenció.
viviendoSinPrecedentes(Anio, Pueblo):-
    esImportanteEn(Anio, Pueblo, _), % <--- EXISTENCIA: Aseguramos que el pueblo tenga al menos una hazaña importante
    forall(
        esImportanteEn(Anio, Pueblo, Hazania),
        (persona(Persona, Pueblo, _, _),
        conoceHazania(Persona, presencio, _, hazania(Hazania, _, _)))
    ).

% Punto 5

/* esUnHeroe(Persona) :- 
    conoceHazania(_, _, _, hazania(_, Heroes, _)), 
    estaEntreLosHeroes(Persona, Heroes).

estaEntreLosHeroes(P, heroes(P)).
estaEntreLosHeroes(P, heroes(P, _)).
estaEntreLosHeroes(P, heroes(_, P)).
estaEntreLosHeroes(P, heroes(P, _, _, _)).
estaEntreLosHeroes(P, heroes(_, P, _, _)).
estaEntreLosHeroes(P, heroes(_, _, P, _)).
estaEntreLosHeroes(P, heroes(_, _, _, P)). */

participaEn(Persona, Hazania) :-
    conoceHazania(_, _, _, hazania(Hazania, Heroes, _)),
    member(Persona, Heroes).

esUnHeroe(Persona) :-
    participaEn(Persona, _).

% Definimos las 3 formas en las que alguien pudo CONOCER una hazaña
% 1 - Porque la presenció, leyó o escuchó
conocioHazania(Persona, Hazania, Heroes) :-
    conoceHazania(Persona, _, _, hazania(Hazania, Heroes, _)).

% 2 - Porque hay un día festivo en su pueblo
conocioHazania(Persona, Hazania, Heroes) :-
    persona(Persona, Pueblo, _, _),
    diaFestivo(Pueblo, Hazania, _),
    conoceHazania(_, _, _, hazania(Hazania, Heroes, _)).

% 3 - Porque hay una estatua en su pueblo
conocioHazania(Persona, Hazania, Heroes) :-
    persona(Persona, Pueblo, _, _),
    estatua(Pueblo, _, _, Hazania, _),
    conoceHazania(_, _, _, hazania(Hazania, Heroes, _)).

inspiro(Inspirador, Inspirado):-
    conocioHazania(Inspirado, _, Heroes),
    member(Inspirador, Heroes),
    Inspirador \= Inspirado.

% cadena de inspiración
cadenaDeInspiracion(Inicial, Cadena) :-
    cadenaDesde(Inicial, [Inicial], Cadena).

% caso base: un solo salto
cadenaDesde(Actual, Visitados, [Actual, Siguiente]) :-
    inspiro(Actual, Siguiente), 
    not(member(Siguiente, Visitados)).

% caso recursivo: un salto y seguimos desde el siguiente 
cadenaDesde(Actual, Visitados, [Actual | Resto]) :-
    inspiro(Actual, Siguiente), 
    not(member(Siguiente, Visitados)),
    cadenaDesde(Siguiente, [Siguiente | Visitados], Resto).

% Punto 6

% Un héroe A es antecesor de B si existe una cadena de inspiración que empieza en A y termina en B.
antecesor(Antecesor, Heroe) :-
    cadenaDeInspiracion(Antecesor, Cadena),
    last(Cadena, Heroe), % last saca el último elemento de la lista
    Antecesor \= Heroe.

dreamTeam(Heroe, Equipo) :-
    esUnHeroe(Heroe),
    findall(Ant, antecesor(Ant, Heroe), AntecesoresBrutos),
    sinRepetidos(AntecesoresBrutos, Antecesores), 
    subconjunto(Antecesores, Subconjunto),
    Subconjunto \= [],
    permutar([Heroe | Subconjunto], Equipo).

% PREDICADOS AUXILIARES

% 1 - Eliminamos elementos duplicados de una lista.
sinRepetidos([], []).
% Si el elemento está más adelante en la cola, lo ignoramos ahora
sinRepetidos([Cabezal | Cola], Resultado) :-
    member(Cabezal, Cola),
    sinRepetidos(Cola, Resultado).
% Si el elemento no está en la cola, lo dejamos.
sinRepetidos([Cabezal | Cola], [Cabezal | Resultado]) :-
    not(member(Cabezal, Cola)),
    sinRepetidos(Cola, Resultado).

% 2 - Generamos subconjuntos
subconjunto([], []).
subconjunto([X | Resto], [X | Sub]) :- subconjunto(Resto, Sub).
subconjunto([_ | Resto], Sub) :- subconjunto(Resto, Sub).

% 3 - Generamos todas las combinaciones de orden posibles
permutar([], []).
permutar(Lista, [Elemento | RestoPermutado]) :-
    nth1(_, Lista, Elemento, RestoLista), 
    permutar(RestoLista, RestoPermutado).

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

test("una persona recuerda una hazania que escucho mientras no hayan pasado mas de 15 anios", nondet):-
    esRecordada(destruirAlDemonioAura, lawine, 1400).

test("una persona ya no recuerda una hazania que escucho cuando pasaron mas de 15 anios"):-
    not(esRecordada(destruirAlDemonioAura, lawine, 1410)).    

test("una persona recuerda una hazania que leyo cuando todavia no paso el lapso de tiempo correspondiente a sus paginas", nondet):-
    esRecordada(destruirAlDemonioAura, voll, 1450).

test("una persona ya no recuerda una hazania leida cuando paso el lapso de tiempo correspondiente a sus paginas"):-
    not(esRecordada(destruirAlDemonioAura, voll, 1460)).

test("una persona recuerda una hazania que presencio siempre mientras este vivo", nondet):-
    esRecordada(rescatarALaHermanaDeWirbel, wirbel, 1430).

test("una persona ya no recuerda una hazania que presencio cuando no esta vivo"):-
    not(esRecordada(rescatarALaHermanaDeWirbel, wirbel, 1440)).

test("una hazania esta corroborada cuando solo se recuerda una version", nondet):-
    estaCorroborada(rescatarALaHermanaDeWirbel).

test("una hazania no esta corroborada cuando se recuerda mas de una version"):-
    not(estaCorroborada(destruirAlDemonioAura)).

test("una hazania paso al olvido cuando ya no la recuerda nadie vivo", nondet):-
    pasoAlOlvido(destruirAlDemonioAura,1460).

test("una hazania no paso al olvido cuando todavia vive alguien que la recuerde"):-
    not(pasoAlOlvido(destruirAlDemonioAura,1440)).

% Tests Punto 3

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

%Tests punto 4
test("Hay pueblos que recuerdan Hazanias", nondet):-
    puebloRecuerdaEn(1400, destruirAlReyDemonio, weise).

test("Hay pueblos que recuerdan Hazanias", nondet):-
    puebloRecuerdaEn(1395, rescatarALaHermanaDeWirbel, klares).

test("Hay pueblos que ya no recuerdan Hazanias"):-
    not(puebloRecuerdaEn(1395, destruirAlReyDemonio, klares)).

test("Hay pueblos que leyeron durante algun anio"):-
    leidoPorElPuebloEn(1335, weise, 100).

test("Hay pueblos que no leyeron durante algun anio"):-
    leidoPorElPuebloEn(1336, weise, 0).

test("Hay anios que los pueblos son musicales"):-
    esMusicalEn(1395, auberst). 

test("Hay anios que los pueblos no son musicales"):-
    not(esMusicalEn(1400, weise)).

test("Hay anios que algunos pueblos son chismosos", nondet):-
    esChismosoEn(1420, ende).

test("Hay anios que algunos pueblos NO son chismosos"):-
    not(esChismosoEn(1400, weise)).

test("Hay anios que un pueblo considera hazanias importantes", nondet):-
    esImportanteEn(1400, weise, destruirAlReyDemonio).

test("Hay anios que un pueblo no considera hazanias importantes"):-
    not(esImportanteEn(1400, weise, recuperarAlGatoPerdido)).

test("Hay pueblos que estan viviendo tiempos sin precedentes", nondet):-
    viviendoSinPrecedentes(1395, klares).

test("Hay pueblos que no estan viviendo tiempos sin precedentes"):-
    not(viviendoSinPrecedentes(1400, weise)).

% test Punto 5
test("un heroe es alguien que participo en al menos una hazania conocida", nondet):-
    esUnHeroe(frieren).

test("alguien que no participo en ninguna hazania no es un heroe"):-
    not(esUnHeroe(wirbel)).

test("alguien inspiro a otro si este conocio una hazania en la que el primero participo", nondet):-
    inspiro(frieren, fern).

test("un heroe puede inspirar a otro heroe que aparecio despues", nondet):-
    inspiro(stark, frieren).

test("nadie inspiro a alguien que no conoce ninguna hazania con otros participantes"):-
    not(inspiro(_, eisen)).

test("una cadena de inspiracion valida es una secuencia donde cada uno inspiro al siguiente", nondet):-
    cadenaDeInspiracion(himmel, [himmel, fern, frieren, denken]).

test("no es una cadena valida si el primero no inspiro al segundo"):-
    not(cadenaDeInspiracion(denken, [denken, frieren])).

test("no es una cadena valida si se repite un heroe en el camino"):-
    not(cadenaDeInspiracion(frieren, [frieren, fern, frieren])).

% Tests Punto 6: Dream Team

test("un dream team valido incluye al heroe junto con al menos un antecesor suyo", nondet) :-
    dreamTeam(fern, Equipo),
    member(himmel, Equipo),
    member(fern, Equipo).

test("el orden de los integrantes no altera la validez de un dream team", nondet) :-
    dreamTeam(fern, [himmel, fern]),
    dreamTeam(fern, [fern, himmel]).

test("un dream team no es valido si solo incluye al heroe sin ningun antecesor") :-
    not(dreamTeam(fern, [fern])).

test("un dream team no es valido si no incluye al propio heroe") :-
    not(dreamTeam(fern, [frieren])).

test("el predicado de dream team es inversible: se puede consultar de quien es un equipo dado", nondet) :-
    dreamTeam(Heroe, [himmel, fern]),
    Heroe == fern.

:- end_tests(tpIntegrador).

