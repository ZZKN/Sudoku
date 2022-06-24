%%  first_column/3 (+Matrix, ?List, ?Rest)

first_column([], [], []):- !.
first_column([[A|As]|Ass], [A|Acc], [As|Rest]) :-
    first_column(Ass, Acc, Rest).

%%  transpose/3 (+Matrix, +Accumulator, ?Transpose)

transpose([], _, []):- !.
transpose([_|As], Rest, [At|Ats]) :-
    first_column(Rest, At, NewRest),
    transpose(As, NewRest, Ats).

%%  transpose/2 (+Matrix, ?Transpose)
%
%   Uses transpose/3 and first_column/3 with an accumulator.

transpose([A|As], At) :-
    transpose(A, [A|As], At).

%%  build_subgrid/5 (+Rows, +SubgridSize, +Buffer, -Stack, -Rest)
%
%   Cuts off first(leftmost) N elements from the first N rows all stored in the buffer which is emptied out into the resulting list

build_subgrid([],_,Buffer,[Buffer],[]):- !.

build_subgrid(Rows,N,Buffer,[Buffer|Rest],RowsRest) :-
    SubgridSize is N*N,
    length(Buffer,SubgridSize),
    build_subgrid(Rows,N,[],Rest,RowsRest),!. % content in the buffer reached desired size, no other solutions is needed/possible

build_subgrid([FirstRow|T],N,Buffer,Subgrids,[FirstRowRest|RowsRest]) :-
    length(Cut, N),
    append(Cut,FirstRowRest,FirstRow),
    append(Cut,Buffer,NewBuffer),
    build_subgrid(T,N,NewBuffer,Subgrids,RowsRest).

%%  get_subgrids/3 (+Sudoku, +SquareSize, -Subgrids)
%
%   Recursively "cuts out" subgrids from the Sudoku grid

get_subgrids([],_,[]):- !.
get_subgrids([[]|_],_,[]):- !.

get_subgrids(Sudoku, N, Out) :-
    build_subgrid(Sudoku,N,[],Stack,Rest),
    append(Stack,Subgrids,Out),
    get_subgrids(Rest,N,Subgrids).

%%  perfect_square/2 (+M, -N)
%
%   Returns square root of M as second argument if M is a perfect square

perfect_square(M,N):-
    N is rationalize(sqrt(M)),
    integer(N).

%%  validate/3 (+SubgridSize,+Rows)
%
%   Confirms the dimentions of input

validate([H|T],SubgridSize) :-
    length([H|T], GridSize),
    length(H, GridSize),
    GridSize \= 0,
    perfect_square(GridSize, SubgridSize).

%%  remove_list/3 (+Numerals,+ToBeRemoved,-Result)
%
%   Removes the contens of the second argument from the first argument

remove_list([],_,[]):- !.
remove_list(D,[],D):- !.
remove_list(Numerals,[H|T],Res) :-
    nonvar(H),
    select(H,Numerals,NewNums),
    remove_list(NewNums,T,Res),!.
remove_list(Numerals,[H|T],Res) :- var(H), remove_list(Numerals,T, Res).

inequal(X,Y) :- X \== Y.

%%  all_distinct/1 (+List)
%
%   Predicate succeeds if list contains only unique values

all_distinct([]):- !.
all_distinct([H|T]) :- maplist(inequal(H), T), all_distinct(T).

%%  partial_solve/3 (+Variables, +Numerals, +Sudoku)
%
%   Recursively assigns values to variables and proceeds to checks its authenticity

partial_solve([],_,_):- !.
partial_solve([H|T],Numerals,Sudoku) :-
    nonvar(H),
    partial_solve(T,Numerals,Sudoku).

partial_solve([H|T],Numerals,Sudoku) :-
    select(H,Numerals,NewNums),

    maplist(all_distinct,Sudoku),
    partial_solve(T,NewNums,Sudoku).

%%   solve/2 (+Sudoku, +Numerals)
%
%    Sudoku is represented as two dimentional list (rows, columns,squares) and Numerals is a list of all posible digits
%    Adjusts Numerals list for each section (row, column, subgrid) and recursively fills out variables while adiding by the rules

solve([],_):- !.
solve([H|T],Numerals) :-
    remove_list(Numerals,H,NewNums),
    partial_solve(H,NewNums,[H|T]),
    solve(T,Numerals).

%%  print_line/2 (+SubgridSize, +Row)
%   Writes out fomated line

print_line(_,[]) :- writeln('|').

print_line(SubgridSize, [H|T]) :-
    (
        (length([H|T],Rest),
        Mod is Rest mod SubgridSize,
        Mod = 0,
        write('|'));
        true
    ),
    format('~|~` t~d~2+', H),
    write(' '),
    print_line(SubgridSize, T),!.

%%  printf/2 (+SubgridSize, +Rows).
%
%   Writes out formated sudoku grid

printf(_,[]):- !.

printf(N,[Row|Rest]) :-
    (
        (length([Row|Rest], RowRest),
        Mod is RowRest mod N,
        Mod = 0,
        writeln(''));
        true
    ),
    print_line(N, Row),
    printf(N,Rest), !.

%%  sudoku/2 (+Rows)
%
%   Given sudoku represented as list of rows, predicate validates the input, solves the sudoku and prints all solutions

sudoku(Rows) :-
    validate(Rows,N),
    maplist(all_distinct,Rows),
    transpose(Rows,Cols),
    get_subgrids(Rows,N,Subgrids),
    append(Rows,Cols,Temp),
    append(Temp,Subgrids,Sudoku),
    High is N*N,
    numlist(1,High,Numerals),
    solve(Sudoku,Numerals),
    writeln('---------------------------------------------'),
    printf(N,Rows).
