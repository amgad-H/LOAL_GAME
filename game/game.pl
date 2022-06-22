/* chdir('C:/Users/amgad/Desktop/3CHIF/LOAL/LOAL_GAME/game').*/

:- dynamic at/2, i_am_at/1, alive/1, boogie_bombable/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)), retractall(boogie_bombable(_)),
        retractall(looked_into_hole(_)), 
        retractall(looked_into_bus(_)), 
        retractall(wants_to_distract_emp(_)),
        retractall(moners_in_da_bag(_)).

/* egg */

:- dynamic looked_into_hole/1.
looked_into_hole(0).

:- dynamic looked_into_bus/1.
looked_into_bus(0).

:- dynamic getting_da_bag_quest/1.
getting_da_bag_quest(0).

:- dynamic moners_in_da_bag/1.
moners_in_da_bag(0).

:- dynamic wants_to_distract_emp/1.
wants_to_distract_emp(0).

:- dynamic employee_is_boogy_bombed/1.
employee_is_boogy_bombed(0).

set_looked_into_hole_count(NewCount) :-
        retractall(looked_into_hole(_)),
        assert(looked_into_hole(NewCount)).

set_looked_into_bus_true :-
        retractall(looked_into_bus(_)),
        assert(looked_into_bus(1)).

set_getting_da_bag_quest_true :-
        retractall(getting_da_bag_quest(_)),
        assert(getting_da_bag_quest(1)).

set_getting_da_bag_quest_finished :-
        retractall(getting_da_bag_quest(_)),
        assert(getting_da_bag_quest(2)).

set_moners_in_da_bag(Money) :-
        retractall(moners_in_da_bag(_)),
        assert(moners_in_da_bag(Money)).

add_moners_in_da_bag(Money) :-
        moners_in_da_bag(Prev_Money),
        Temp = Money + Prev_Money,
        set_moners_in_da_bag(Temp).

set_wants_to_distract_emp_true :-
        retractall(wants_to_distract_emp(_)),
        assert(wants_to_distract_emp(1)).

set_employee_is_boogy_bombed_true :-
        retractall(employee_is_boogy_bombed(_)),
        assert(employee_is_boogy_bombed(1)).

/* This defines my current location. */

i_am_at(bedroom).


/* These facts describe how the rooms are connected. */

path(bedroom, d, street).

path(street, u, bedroom).
path(street, w, arcade_entrance).
path(street, s, battle_bus).

path(battle_bus, n, street).

path(arcade_entrance, e, street).
path(arcade_entrance, n, game_room).
path(arcade_entrance, w, checkout) :- at(boogie_bomb, in_hand).
path(arcade_entrance, w, checkout) :-
        look(checkout), nl,
        !, fail.

path(game_room, s, arcade_entrance).

path(checkout, e, arcade_entrance).
path(checkout, n, emp_room) :- at(emp_room_key, in_hand).
path(checkout, n, emp_room) :- 
        write('Door is locked :('), nl,
        !, fail.

/* These facts tell where the various objects in the game
   are located. */

at(employee, checkout).
at(boogie_bomb, battle_bus).
at(emp_room_key, employee_pocket).

/* These rules describe how to pick up an object. */

take(X) :-
        at(X, in_hand),
        write('You''re already holding it!'),
        nl, !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, in_hand)),
        write('OK.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'),
        nl.

/* These rules describe how to put down an object. */

drop(X) :-
        at(X, in_hand),
        i_am_at(Place),
        retract(at(X, in_hand)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'),
        nl.

/* These rules define the six direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d).

/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look, !.

go(_) :-
        write('You can''t go that way.').

get_behind_counter :-
        employee_is_boogy_bombed(Bool),
        Bool = 0,
        write('oh no, it seems like you annoyed the employee... '), nl,
        die.

/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        look(Place).

look(Place) :-
        Place \= battle_bus,
        describe(Place), nl,
        notice_objects_at(Place),
        nl.

look(battle_bus) :-
        describe(battle_bus),
        nl.

look_inside :-
        i_am_at(battle_bus),
        set_looked_into_bus_true,
        wants_to_distract_emp(Bool),
        Bool = 0,
        write('A hand reaches out and blocks you from looking into the bus.'), nl,
        write('"Didnt ya parents teach ya not to poke yer nose around other peoples stuff, brat?"'), nl.

look_inside :-
        i_am_at(battle_bus),
        looked_into_bus(Times),
        Times >= 1,
        wants_to_distract_emp(Bool),
        Bool >= 1,
        getting_da_bag_quest(Started),
        Started = 0,
        set_getting_da_bag_quest_true,
        write('"Didnt ya parents teach ya not to poke yer nose around other peoples stuff, bra-"'), nl,
        write('You interrupt him asking if he has somethin to distract someone.'), nl,
        write('The man grunts, thinking.'), nl,
        write('"Hmmm, something to distract someone, ya say? Well"'), nl,
        write('You hear him shuffeling his stuff around'), nl,
        write('"AHA, i got the right thing for ya, ere a boogie bomb!"'), nl,
        write('You take a step back in shock'), nl,
        write('"Dont soil yer pants, youngin, this not a real bomb, it only forces people to BOOGIE DOWN, HA HA HA"'), nl,
        write('He shows you the bomb, but doesnt give it to you'), nl,
        write('"Nuthin ere is free, bring me 20 coins and it be yers"'), nl.

look_inside :-
        i_am_at(battle_bus),
        looked_into_bus(Times),
        Times >= 1,
        wants_to_distract_emp(Bool),
        Bool >= 1,
        getting_da_bag_quest(Started),
        Started = 1,
        write('"Nuthin ere is free, bring me 20 coins and it be yers..."'), nl.

look_inside :-
        i_am_at(battle_bus),
        looked_into_bus(Times),
        Times >= 1,
        wants_to_distract_emp(Bool),
        Bool >= 1,
        getting_da_bag_quest(Started),
        Started = 1,
        write('"Nuthin ere is free, bring me 20 coins and it be yers..."'), nl.


/* This is also to look, but for easter egg*/

stare_into_hole :-
        i_am_at(bedroom),
        looked_into_hole(Count),
        Count >= 3,
        Temp is Count + 1,
        set_looked_into_hole_count(Temp),
        write(Temp),nl,
        write("black people be like"),!.


stare_into_hole :-
        i_am_at(bedroom),
        looked_into_hole(Count),
        Count < 3,
        Temp is Count + 1,
        set_looked_into_hole_count(Temp),
        write("hmm sus"), nl,
        write(Temp), nl.
        /*Temp > 3,
        write("black people be like").*/


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* These rules tell how to handle killing the lion and the spider. */

throwBomb :-
        i_am_at(checkout),
        at(boogie_bomb, in_hand),
        retract(boogie_bombable(employee)),
        write('You boogie bombed the employee'), nl, 
        !.

throwBomb :-
        i_am_at(checkout),
        write('Cant throw something you dont have, man'), nl, 
        !.

throwBomb :-
        write('Noone to throw it at here...'), nl.

/* This rule tells how to die. */

die :-
        !, finish.

/* Under UNIX, the   halt.  command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final  halt.  */

finish :-
        nl,
        write('The game is over. Please enter the   halt.   command.'),
        nl, !.

/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                   -- to start the game.'), nl,
        write('n.  s.  e.  w.  u.  d.   -- to go in that direction.'), nl,
        write('take(Object).            -- to pick up an object.'), nl,
        write('drop(Object).            -- to put down an object.'), nl,
        write('throwBomb.               -- to attack an enemy.'), nl,
        write('look.                    -- to look around you again.'), nl,
        write('instructions.            -- to see this message again.'), nl,
        write('halt.                    -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.

/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(meadow) :-
        at(ruby, in_hand),
        write('Congratulations!!  You have recovered the ruby'), nl,
        write('and won the game.'), nl,
        finish, !.

describe(bedroom) :-
        write('You are in your bedroom. Nothing interesting for the time being'), nl,
        write('You can go down to get to the street, or spend your day here'), nl,
        write('STARING at a hole in the wall.'), nl.

describe(street) :-
        looked_into_bus(Times),
        Times < 1,
        write('The street you walked along side of for every school day, on the other side'), nl,
        write('(w) there is a newly opened Arcade, which you planned to meet up with your'), nl,
        write('friends in.'), nl,
        write('To the south you see a strange little ominous blue bus with one window creaked down slightly'), nl,
        write('Maybe its worth investigating?'), nl.

describe(street) :-
        looked_into_bus(Times),
        Times >= 1,
        write('The street you walked along side of for every school day, on the other side'), nl,
        write('(w) there is a newly opened Arcade, which you planned to meet up with your'), nl,
        write('friends in.'), nl,
        write('To the south you see the strange little ominous blue bus with the weird guy inside of it'), nl,
        write('Maybe he would be helpful later on.'), nl.

describe(arcade_entrance) :-
        write('You stand at the entrance of the arcade, RGB lights shimmer everywhere.'), nl,
        write('You see a sign "Game Room" that is pointing on a room filled with various arcade games'), nl,
        write('West of you is a checkout counter.'), nl.

/*describe(checkout) :-
        write('The checkout has all kind of winables like plastic vampire teeth and such'), nl,
        write(''), nl.*/

describe(game_room) :-
        write('The so called Game Room features many games, like a boxing machine'), nl,
        write('a face-off dance battle game, arcade machine, whack a mole and many more games'), nl.

describe(cave) :-
        alive(spider),
        at(ruby, in_hand),
        write('The spider sees you with the ruby and attacks!!!'), nl,
        write('    ...it is over in seconds....'), nl,
        die.

describe(checkout) :-
        employee_is_boogy_bombed(Bool),
        Bool = 0,
        write('An employee stands at the checkout, almost like guarding something.'), nl,
        write('You cant blame him, seeing all the expensive prizes at the back top shelf,'), nl,
        write('like a golden plastic vampire teeth.'), nl,
        write('Behind the counter, you see a door labeled "Employees Only" which seems very intriguing'), nl, 
        write('Try to get behind the counter? (get_behind_counter)'), nl,
        set_wants_to_distract_emp_true, !.

describe(cave) :-
        write('Yecch!  There is a giant spider here, twitching.'), nl.

describe(spider) :-
        alive(spider),
        write('You are on top of a giant spider, standing in a rough'), nl,
        write('mat of coarse hair.  The smell is awful.'), nl.

describe(battle_bus) :-
        write('You stand before the tinted window of the bus, listening closely you hear breathing coming form within'), nl,
        write('Look inside?'), nl.

