/* chdir('C:/Users/amgad/Desktop/3CHIF/LOAL/LOAL_GAME/game').*/

:- dynamic at/2, i_am_at/1, alive/1, boogie_bombable/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)), retractall(boogie_bombable(_)),
        retractall(looked_into_hole(_)), 
        retractall(looked_into_bus(_)), 
        retractall(wants_to_distract_emp(_)),,
        retractall(employee_is_boogy_bombed(_))
        retractall(moners_in_da_bag(_)),
        retractall(boxing_machine_looted(_)),
        retractall(face_off_looted(_)),
        retractall(arcade_looted(_)),
        retractall(whack_a_mole_looted(_)),
        retractall(over_complicated_boolean_empBombed_and_inCheckout(_)).

/* egg */

:- dynamic looked_into_hole/1.
looked_into_hole(0).

:- dynamic looked_into_bus/1.
looked_into_bus(0).

:- dynamic getting_da_bag_quest/1.
getting_da_bag_quest(0).

:- dynamic moners_in_da_bag/1.
moners_in_da_bag(0).

:- dynamic over_complicated_boolean_empBombed_and_inCheckout/1.
over_complicated_boolean_empBombed_and_inCheckout(0).
/*:- dynamic add_moners_in_da_bag/1.*/

:- dynamic boxing_machine_looted/1.
boxing_machine_looted(0).

:- dynamic face_off_looted/1.
face_off_looted(0).

:- dynamic arcade_looted/1.
arcade_looted(0).

:- dynamic whack_a_mole_looted/1.
whack_a_mole_looted(0).

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
        Temp is Money + Prev_Money,
        set_moners_in_da_bag(Temp),
        Temp >= 20,
        set_getting_da_bag_quest_finished.

set_boxing_machine_looted_true :-
        retractall(boxing_machine_looted(_)),
        assert(boxing_machine_looted(1)).

set_face_off_looted_true :-
        retractall(face_off_looted(_)),
        assert(face_off_looted(1)).

set_arcade_looted_true :-
        retractall(arcade_looted(_)),
        assert(arcade_looted(1)).

set_whack_a_mole_looted_ture :-
        retractall(whack_a_mole_looted(_)),
        assert(whack_a_mole_looted(1)).

set_wants_to_distract_emp_true :-
        retractall(wants_to_distract_emp(_)),
        assert(wants_to_distract_emp(1)).

set_employee_is_boogy_bombed_true :-
        retractall(employee_is_boogy_bombed(_)),
        assert(employee_is_boogy_bombed(1)).

set_employee_is_boogy_bombed_balled_out :-
        retractall(employee_is_boogy_bombed(_)),
        assert(employee_is_boogy_bombed(2)).

set_over_complicated_boolean_empBombed_true :-
        over_complicated_boolean_empBombed_and_inCheckout(Bool),
        Temp is Bool + 1,
        retractall(over_complicated_boolean_empBombed_and_inCheckout(_)),
        assert(over_complicated_boolean_empBombed_and_inCheckout(Temp)).

set_over_complicated_boolean_inCheckout_true :-
        over_complicated_boolean_empBombed_and_inCheckout(Bool),
        Temp is Bool + 1,
        retractall(over_complicated_boolean_empBombed_and_inCheckout(_)),
        assert(over_complicated_boolean_empBombed_and_inCheckout(Temp)).

set_over_complicated_boolean_inCheckout_false :-
        over_complicated_boolean_empBombed_and_inCheckout(Bool),
        Temp is Bool - 1,
        retractall(over_complicated_boolean_empBombed_and_inCheckout(_)),
        assert(over_complicated_boolean_empBombed_and_inCheckout(Temp)).

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
path(arcade_entrance, w, checkout) :-
        employee_is_boogy_bombed(Bool),
        Bool >= 2,
        look(checkout2),
        set_over_complicated_boolean_inCheckout_true,!.
path(arcade_entrance, w, checkout) :- 
        employee_is_boogy_bombed(Bool),
        Bool = 1,
        look(checkout2),
        set_employee_is_boogy_bombed_balled_out,
        set_over_complicated_boolean_inCheckout_true,!.
path(arcade_entrance, w, checkout) :-
        employee_is_boogy_bombed(Bool),
        Bool = 0,
        look(checkout), nl,
        !, fail.

path(game_room, s, arcade_entrance).

path(checkout, e, arcade_entrance) :-
        set_over_complicated_boolean_inCheckout_false.
path(checkout, n, emp_room) :- 
        at(emp_room_key, in_hand),
        set_over_complicated_boolean_inCheckout_false.
path(checkout, n, emp_room) :- 
        write('Door is locked :('), nl,
        !, fail.

/* These facts tell where the various objects in the game
   are located. */

at(employee, checkout).
at(boogie_bomb, battle_bus).
at(emp_room_key, employee_pocket).

/* These facts tell what machines can be seached to find money*/
/*boxing machine
 face-off dance battle game, 
 arcade machine, 
 whack a mole */
is_searchable_game(boxing_machine).
is_searchable_game(face_off).
is_searchable_game(arcade).
is_searchable_game(whack_a_mole).

/* These rules add coins to the players inventory */

search(Game) :-
        is_searchable_game(Game),
        game_searched(Game).


game_searched(boxing_machine) :-
        boxing_machine_looted(Bool),
        Bool = 0,
        write('You try to see if any money is left in the machine, but then the punching bag'), nl,
        write('releases and hits you in the face. As you fall back, you hold on the punching bag'), nl,
        write('and cause the whole machine to fall with you.'), nl,
        write('9 coins fall out'),
        add_moners_in_da_bag(9),
        set_boxing_machine_looted_true,
        !.

game_searched(boxing_machine) :-
        boxing_machine_looted(Bool),
        Bool >= 1,
        write('The machine lays on the ground infront of you...'),nl,
        write('Better get going'),!.

game_searched(face_off) :-
        face_off_looted(Bool),
        Bool = 0,
        write('As you search the dance-off machine, it suddenly turns on and you simply had to dance,'), nl,
        write('After a good face-off session, you hear the cling noise of coins falling out of the machine'), nl,
        write('Jackpot, 21 dabloons (coins)'),
        add_moners_in_da_bag(21),
        set_face_off_looted_true,
        !.

game_searched(face_off) :-
        face_off_looted(Bool),
        Bool >= 1,
        write('You are still sweating from your last face-off session, perhaps its enough for today.'),!.

game_searched(arcade) :-
        arcade_looted(Bool),
        Bool = 0,
        write('Someone seems to have left street fighter running on it, they have even placed a bet too!'), nl,
        write('After defeating the enemy (by that winning the bet that the previous player has set) you feel proud of yourself'), nl,
        write('Nice, you just earned yourself 12 coins!'),
        add_moners_in_da_bag(12),
        set_arcade_looted_true,
        !.

game_searched(arcade) :-
        arcade_looted(Bool),
        Bool >= 1,
        write('You are not much of a gambler yourself, you dont want to stick any of your money into this machine.'),!.

game_searched(whack_a_mole) :-
        whack_a_mole_looted(Bool),
        Bool = 0,
        write('As you inspect the machine the annoying moles keep popping up and go back into their hidey hole.'), nl,
        write('It begins to frustrate you so you take the hammer and take stopping them into your own hand.'), nl,
        write('After smashing your frustration away at the machine, 5 coind pop out.'),
        add_moners_in_da_bag(5),
        set_whack_a_mole_looted_ture,
        !.

game_searched(whack_a_mole) :-
        whack_a_mole_looted(Bool),
        Bool >= 1,
        write('The machine is barely standing, sparks flying out of it in every direction.'),nl,
        write('You moonslide away...').

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
        over_complicated_boolean_empBombed_and_inCheckout(Bool),
        Bool =< 1,
        describe(Place), nl,
        notice_objects_at(Place),
        nl,!.

look(battle_bus) :-
        describe(battle_bus),
        nl.

look_inside :-
        i_am_at(battle_bus),
        set_looked_into_bus_true,
        wants_to_distract_emp(Bool),
        Bool = 0,
        write('A hand reaches out and blocks you from looking into the bus.'), nl,
        write('"Didnt ya parents teach ya not to poke yer nose around other peoples stuff, brat?"'), nl,!.

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
        write('"Nuthin ere is free, bring me 20 coins and it be yers"'), nl,!.

look_inside :-
        i_am_at(battle_bus),
        looked_into_bus(Times),
        Times >= 1,
        wants_to_distract_emp(Bool),
        Bool >= 1,
        getting_da_bag_quest(Started),
        Started = 1,
        write('"Nuthin ere is free, bring me 20 coins and it be yers..."'), nl,!.

look_inside :-
        i_am_at(battle_bus),
        looked_into_bus(Times),
        Times >= 1,
        wants_to_distract_emp(Bool),
        Bool >= 1,
        getting_da_bag_quest(Started),
        Started = 1,
        write('"Nuthin ere is free, bring me 20 coins and it be yers..."'), nl,!.

look_inside :-
        i_am_at(battle_bus),
        looked_into_bus(Times),
        Times >= 1,
        wants_to_distract_emp(Bool),
        Bool >= 1,
        getting_da_bag_quest(Ended),
        Ended = 2,
        write('"Oooooh, i can smell the COINS from in here."'), nl,
        write('"Here ya go, yer bomb"'),nl,
        write('Boogie-Bomb added to you inventory, write "throwBomb" when near the employee'),
        take(boogie_bomb),!.


/* This is also to look, but for easter egg*/

stare_into_hole :-
        i_am_at(bedroom),
        looked_into_hole(Count),
        Count = 3,
        Temp is Count + 1,
        set_looked_into_hole_count(Temp),
        write("Wait, i think i just saw something slither away... :("),!.


stare_into_hole :-
        i_am_at(bedroom),
        looked_into_hole(Count),
        Count < 3,
        Temp is Count + 1,
        set_looked_into_hole_count(Temp),
        write("Nothing to see"), nl,
        write(Temp), nl.
        /*Temp > 3,
        write("black people be like").*/

stare_into_hole :-
        i_am_at(bedroom),
        looked_into_hole(Count),
        Count > 3,
        Temp is Count + 1,
        set_looked_into_hole_count(Temp),
        write("Meh, probably nothing"),!.

/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).

/* These rules tell how to handle killing the lion and the spider. */

throwBomb :-
        i_am_at(arcade_entrance),
        at(boogie_bomb, in_hand),
        set_employee_is_boogy_bombed_true,
        set_over_complicated_boolean_empBombed_true,
        write('You boogie bombed the employee, now he is dancing and he cant get in your way anymore!'), nl, 
        !.

throwBomb :-
        i_am_at(arcade_entrance),
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

describe(checkout2) :-
        employee_is_boogy_bombed(Bool),
        Bool >= 1,
        write('The checkout looks disgusting from the inside, you cant believe that the kids would'),nl,
        write('really stick the vampire teeth, that have been exposed to all this filth, into their mouths'),nl,
        write('Anyway, back to your original plan, finding the secret held behind the employees door.'),!.

describe(cave) :-
        write('Yecch!  There is a giant spider here, twitching.'), nl.

describe(spider) :-
        alive(spider),
        write('You are on top of a giant spider, standing in a rough'), nl,
        write('mat of coarse hair.  The smell is awful.'), nl.

describe(battle_bus) :-
        write('You stand before the tinted window of the bus, listening closely you hear breathing coming form within'), nl,
        write('Look inside?'), nl.

