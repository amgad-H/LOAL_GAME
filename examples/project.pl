/* notas malus boss fight */
:- retractall(player_hp(_)).
:- retractall(enemy_hp(_)).
:- retractall(weapon_in_hand(_,_)).
:- retractall(saved_enemy_move(_,_)).
:- retractall(preparing_for_next_move()).
:- retractall(current_player_state(_)).
:- retractall(enemy_attack_to_execute(_,_)).
:- retractall(player_move_to_execute(_,_)).

:- dynamic saved_enemy_move/2.

:- dynamic preparing_for_next_move/0.

:- dynamic player_hp/1.
player_hp(100).

:- dynamic enemy_hp/1.
enemy_hp(200).

:- dynamic weapon_in_hand/2.
weapon_in_hand(hand, 5).

damage_per_hit() :-
    weapon_in_hand(Weapon,Dmg),
    write('Damage with '),
    write(Weapon),
    writeln(''),
    write('normal hit: '),
    writeln(Dmg),
    write('critical hit: '),
    CritHit is Dmg * 2,
    writeln(CritHit).
    
weapon_damage(mace,20).
weapon_damage(sword,30).
weapon_damage(axe,40).
weapon_damage(dagger,10).

:- initialization(
    print_start_text
).

print_start_text() :-
    writeln(''),
    writeln('This is a boss arena. you have to defeat notas malus'),
    writeln('There are 4 weapons to choose from : '),
    writeln('A chunky Mace, a sharp Sword, a huge axe and a sleek dagger - choose wisely'),
    writeln('You can get all allowed commands by typing "get_info"'),
    writeln('').

get_info :-
    writeln('You can do the following commands:'),
    writeln(''),
    writeln('get_player_hp - get your hp'),
    writeln('get_enemy_hp - get enemy hp'),
    writeln('is_alive - check if you are alive'),
    writeln('is_enemy_alive - check if enemy is alive'),
    writeln('damage_per_hit - get damage per hit/your weapon'),
    writeln('pickup - pick up a weapon'),
    writeln('get_all_moves - get all possible moves you can do'),
    writeln('do_move - select a move to do in the next fighting step'),
    writeln('next_fighting_step - fight the boss'),
    writeln('').

is_alive :- player_hp(Hp) , Hp > 0.
is_enemy_alive :- enemy_hp(Hp) , Hp > 0.

get_player_hp :- 
    player_hp(Hp),
    writeln('Your HP: '),
    writeln(Hp).
get_enemy_hp :- 
    enemy_hp(Hp),
    writeln('Enemy HP: '),
    writeln(Hp).

get_all_moves :-
    writeln(''),
    writeln('Moves:'),
    writeln(''),
    writeln('roll - roll to dodge the next attack'),
    writeln('block_attack - block the next attack'),
    writeln('attack - attack the enemy'),
    writeln('jump - jump to doge the next attack'),
    writeln('idle - just the normal state of your player'),
    writeln('-----------'),
    writeln('Note: You have to look for free attack windows in the enemy moveset, where you can hit it.'),
    writeln('Not every dodge can avoid every attack. choose wisely how you avoid damage.'),
    writeln('').

set_new_hp(NewHp) :-
    retractall(player_hp(_)),
    assert(player_hp(NewHp)).
set_new_boss_hp(NewHp) :-
    retractall(enemy_hp(_)),
    assert(enemy_hp(NewHp)).

do_damage_to_player(Dmg) :-
    player_hp(CurrHp),
    (CurrHp - Dmg) =< 0,
    set_new_hp(0),
    writeln('*-*-*-*-*'),
    writeln('You Died!'),
    writeln('*-*-*-*-*'),
    !.
do_damage_to_player(Dmg) :- 
    player_hp(OldHp),
    Temp is OldHp - Dmg,
    set_new_hp(Temp).

do_damage_to_boss(Dmg) :-
    enemy_hp(CurrHp),
    (CurrHp - Dmg) =< 0,
    set_new_boss_hp(0),
    writeln('*-*-*-*-*-*-*-*'),
    writeln('The Boss DIED!'),
    writeln('*-*-*-*-*-*-*-*'),
    !.
do_damage_to_boss(Dmg) :- 
    enemy_hp(OldHp),
    Temp is OldHp - Dmg,
    set_new_boss_hp(Temp).

give_random(X) :-
    random(1,3,X).
random_choise() :-
    give_random(Rand),
    Rand = 1.

pickup(Thing) :-
    not(weapon_damage(Thing,_)),
    write('Thats not a weapon'),
    !.
pickup(Thing) :-
    weapon_damage(Thing,Dmg),
    retractall(weapon_in_hand(_,_)),
    assert(weapon_in_hand(Thing,Dmg)),
    write('You picked up '),
    write(Thing).


/*enemy move. randomly chooses a move and executes it*/
/*just enter "get_current_enemy_move." to get a new action*/
:- dynamic enemy_attack_to_execute/2.

get_current_enemy_move():-
    saved_enemy_move(Move,Dmg),
    do_enemy_move(Move,Dmg),
    !.
get_current_enemy_move() :-
    choose_a_random_new_move_for_enemy(),
    !.

follow_up_move(bigSwingWindupStart,bigSwingWindupContinue).
follow_up_move(bigSwingWindupContinue,bigSwing).
follow_up_move(stompWindup,stomp).
follow_up_move(normalAttackWindup,normalAttack).

do_enemy_move(_,_) :-
    preparing_for_next_move(),
    retractall(preparing_for_next_move()),
    write('Enemy prepares for next move'),
    writeln(''),
    !.

do_enemy_move(Move,Dmg) :-
    follow_up_move(Move,NextMove),
    set_saved_enemy_move(NextMove,Dmg),
    write('Enemy did '),
    write(Move),
    writeln(''),
    !.

do_enemy_move(Move,Dmg) :- 
    /*will execute attack*/
    assert(enemy_attack_to_execute(Move,Dmg)),
    retractall(saved_enemy_move(_,_)),
    assert(preparing_for_next_move()),
    !.

set_saved_enemy_move(Move,Dmg) :-
    retractall(saved_enemy_move(_,_)),
    assert(saved_enemy_move(Move,Dmg)).

choose_a_random_new_move_for_enemy() :-
    random(1,6,NextEnemyMove),
    set_enemy_windup(NextEnemyMove).

set_enemy_windup(MoveNr) :-
    MoveNr = 1,
    set_saved_enemy_move(bigSwingWindupStart,50),
    do_enemy_move(bigSwingWindupStart,50),
    
    !.

set_enemy_windup(MoveNr) :-
    (MoveNr = 2 ; MoveNr = 3),
    set_saved_enemy_move(stompWindup,20),
    do_enemy_move(stompWindup,20),
    !.

set_enemy_windup(_) :-
    set_saved_enemy_move(normalAttackWindup,10),
    do_enemy_move(normalAttackWindup,10),
    !.

/*player moves*/
:- dynamic current_player_state/1.
current_player_state(idle).
:- dynamic player_move_to_execute/2.

player_state(roll).
player_state(jump).
player_state(attack).
player_state(block_attack).
player_state(idle).

player_damage_negation(roll,stomp,10).
player_damage_negation(roll,normalAttack,100).
player_damage_negation(roll,bigSwing,100).

player_damage_negation(jump,stomp,100).
player_damage_negation(jump,normalAttack,10).
player_damage_negation(jump,bigSwing,10).

player_damage_negation(block_attack,stomp,10).
player_damage_negation(block_attack,normalAttack,100).
player_damage_negation(block_attack,bigSwing,0).

player_damage_negation(idle,stomp,0).
player_damage_negation(idle,normalAttack,0).
player_damage_negation(idle,bigSwing,0).

player_damage_negation(attack,stomp,0).
player_damage_negation(attack,normalAttack,0).
player_damage_negation(attack,bigSwing,0).

do_move(Move) :-
    retractall(player_move_to_execute(_,_)),
    set_player_state(Move),
    !.

set_player_state(State) :-
    not(player_state(State)),
    write('Invalid player state'),
    !.

set_player_state(State) :-
    retractall(current_player_state(_)),
    assert(current_player_state(State)),
    select_player_move_to_execute(State),
    !.

select_player_move_to_execute(State) :-
    State = attack,
    weapon_in_hand(_,Dmg),
    assert(player_move_to_execute(State,Dmg)),
    !.
select_player_move_to_execute(State) :-
    State = block_attack,
    assert(player_move_to_execute(State,-1)),
    !.
select_player_move_to_execute(State) :-
    State = roll,
    assert(player_move_to_execute(State,-1)),
    !.
select_player_move_to_execute(State) :-
    State = jump,
    assert(player_move_to_execute(State,-1)),
    !.
select_player_move_to_execute(State) :-
    State = idle,
    assert(player_move_to_execute(State,-1)),
    !.

/*actual fight management*/
next_fighting_step() :-
    not(is_alive),
    writeln('fighting cant happen. you are dead'),
    !.
next_fighting_step() :-
    not(is_enemy_alive),
    writeln('fighting cant happen. enemy is dead'),
    !.
next_fighting_step() :-
    not(player_move_to_execute(_,_)),
    assert(player_move_to_execute(idle,-1)),
    next_fighting_step(),
    !.
next_fighting_step() :-
    get_current_enemy_move(),
    enemy_damage_dealing(),
    retractall(enemy_attack_to_execute(_,_)).
next_fighting_step() :-
    player_damage_dealing(),
    retractall(player_move_to_execute(_,_)).
next_fighting_step() :- 
    writeln('fighting round done'),
    !.
    
enemy_damage_dealing() :-
    enemy_attack_to_execute(EnemyMove,EnemyDmg),
    player_move_to_execute(PlayerMove,_),
    player_damage_negation(PlayerMove,EnemyMove,PlayerDmgNegation),
    DmgForPlayer is EnemyDmg - (EnemyDmg*(PlayerDmgNegation/100)),
    do_damage_to_player(DmgForPlayer),
    writeln('Enemy did move: '),
    write(EnemyMove),
    writeln(''),
    write('Damage: '),
    write(DmgForPlayer),
    writeln(''),
    !.
player_damage_dealing() :-
    player_move_to_execute(PlayerMove,PlayerDmg),
    PlayerDmg > 0,
    player_get_damage(ActualDamage),
    do_damage_to_boss(ActualDamage),
    write('Player did move: '),
    write(PlayerMove),
    writeln(''),
    write('Damage: '),
    write(ActualDamage),
    writeln(''),
    !.

player_get_damage(ReturnDamage) :-
    random(1,4,DmgRoll),
    handle_player_damage_roll(DmgRoll,ReturnDamage),
    !.
handle_player_damage_roll(DmgRoll,ReturnVal) :-
    (DmgRoll == 1),
    weapon_in_hand(_,Dmg),
    ReturnVal is Dmg*2,
    writeln('Critical hit!'),
    !.
handle_player_damage_roll(_,ReturnVal) :-
    weapon_in_hand(_,Dmg),
    ReturnVal is Dmg,
    !.