%Base de conocimientos
herramientasRequeridas(ordenarCuarto, [reemplazables([aspiradora(100), escoba]), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

cazaFantasma(peter).
cazaFantasma(egon).
cazaFantasma(winston).
cazaFantasma(ray).

%Punto 1:
tieneHerramienta(egon, aspiradora(200)).
tieneHerramienta(egon, trapeador).
tieneHerramienta(peter, trapeador).
tieneHerramienta(winston, varitaDeNeutrones).
tieneHerramienta(egon, bordedadora).

%Punto 2: Es inversible respecto de todas las herramientas que no sean aspiradoras (pq puede haber infinitas).
satisfaceNecesidadDeHerramienta(Integrante, Herramienta):-
    tieneHerramienta(Integrante, Herramienta).
satisfaceNecesidadDeHerramienta(Integrante, aspiradora(Potencia)):-
    tieneHerramienta(Integrante, aspiradora(UnaPotencia)),
    UnaPotencia >= Potencia. %Se puede hacer con between para que sea inversible y trabajar con un conjunto acotado.
satisfaceNecesidadDeHerramienta(Integrante, reemplazables(Herramientas)):-
    member(Herramienta,Herramientas),
    satisfaceNecesidadDeHerramienta(Integrante, Herramienta).

%Punto 3:
puedeRealizarTarea(Persona, Tarea):-
    tieneHerramienta(Persona, varitaDeNeutrones),
    herramientasRequeridas(Tarea,_).
puedeRealizarTarea(Persona, Tarea):-
    tieneHerramienta(Persona,_),
    herramientasRequeridas(Tarea, Herramientas),
    forall(member(Herramienta, Herramientas), tieneHerramienta(Persona, Herramienta)).

%Punto 4:
tareaPedida(unCliente,ordenarCuarto, 50).
tareaPedida(unCliente,limpiarBanio, 10).
precio(ordenarCuarto, 50).
precio(limpiarBanio, 10).

precioPedido(Cliente, PrecioTotal):-
    tareaPedida(Cliente,_,_),
    findall(PrecioTarea, precioPorTarea(Cliente, _, PrecioTarea), Precios),
    sum_list(Precios, PrecioTotal).

precioPorTarea(Cliente, Tarea, PrecioTarea):-
    tareaPedida(Cliente, Tarea, MetrosCuadrados),
    precio(Tarea, UnPrecio),
    PrecioTarea is UnPrecio * MetrosCuadrados.

%Punto 5:

aceptaPedido(Integrante, Cliente):-
    cazaFantasma(Integrante),
    tareaPedida(Cliente,_,_),
    forall(tareaPedida(Cliente, Tarea,_), puedeRealizarTarea(Integrante, Tarea)),
    dispuestoAAceptarPedido(Integrante, Cliente).

dispuestoAAceptarPedido(peter,_).
dispuestoAAceptarPedido(ray, Cliente):-
    not(tareaPedida(Cliente, limpiarTecho,_)).
dispuestoAAceptarPedido(winston, Cliente):-
    precioPedido(Cliente, PrecioPedido),
    PrecioPedido > 500.
dispuestoAAceptarPedido(egon, Cliente):-
    not(tieneTareaCompleja(Cliente)).

tieneTareaCompleja(Cliente):-
    tareaPedida(Cliente, Tarea,_),
    esCompleja(Tarea).

esCompleja(limpiarTecho).
esCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.


