/* SPIDER -- a sample adventure game, by David Matuszek.
   Consult this file and issue the command:   start.  */

:- dynamic at/2, i_am_at/1, alive/1, boogieBombed/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)), retractall(boogieBombed(_)).

/* This defines my current location. */

i_am_at(bedroom).


/* These facts describe how the rooms are connected. */

path(bedroom, d, street).

path(street, u, bedroom).
path(street, w, arcade_entrance).
path(street, s, battle_bus).

path(arcade_entrance, e, street).
path(arcade_entrance, n, game_room).
path(arcade_entrance, w, checkout) :- at(boogie_bomb, in_hand).
path(arcade_entrance, w, checkout) :-
        write('There seems to be an employee blocking your way, maybe you could distract him somehow...'), nl,
        !, fail.

path(checkout, e, arcade_entrance).
path(checkout, n, emp_room) :- at(emp_room_key, in_hand).
path(checkout, n, emp_room) :- 
        write('Door is locked :('), nl,
        !, fail.

/* These facts tell where the various objects in the game
   are located. */

at(boogie_bomb, battle_bus).
at(emp_room_key, employee_pocket).

/* This fact specifies that the employee is boogie bombed. */

boogieBombed(employee).