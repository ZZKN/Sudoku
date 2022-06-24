## Sudoku solver in Prolog

Na vstupu dostane hrací desku s libovolným počtem předvyplněných buněk. Úkolem je vyplnit Sudoku, pokud řešení existuje.

Minimální požadavky:
Načíst a interně zareprezentovat sudoku.
Najít alespoň jedno řešení (existuje-li) libovolně zadaného sudoku 9x9.

Extra body: Velikost hrací desky není omezená {n^2 * n^2| n≥1}. 

## Example usage

### Reprezentácia Sudoku
Sudoku je možné zadať ako zoznam zoznamov, ktoré reprezentujú riadky v sudoku.
Interne je sudoku reprezentované ako zoznam zoznamov, ktorý je abstraktne rozdelený do troch častí: zoznamy reprezentujúce riadky, stĺpce a štvorce.

### Riešenie Sudoku
Sudoku solver je schopný riešiť ľubovoľné sudoku korektnej veľkosti ale počet nevyplnených hodnôt odzrkadľuje dĺžku behu programu práve kvôli brute froce spôsobu hľadania vyplnenia sudoku.
Program postupne nájde správne riešenie každej "oblasti" (riadok, stĺpec, štvorec), zlyhá ak neexistuje riešenie pre nejakú oblasť. 
Riešenie v jednej oblasti hľadá rekurzívnym vyplnením každej cell, ktorá ešte nemá hodnotu bez porušenia pravidiel. 

### Sudoku 9x9

```prolog
?- sudoku([ [_,_,_,_,_,_,5,6,4],
            [4,5,_,_,_,_,_,_,_],
            [3,7,_,4,_,_,1,2,8],
            [_,1,2,3,_,_,_,5,_],
            [_,_,_,_,_,2,3,_,9],
            [_,_,7,6,_,_,8,_,2],
            [2,8,1,9,_,7,_,4,_],
            [_,6,_,_,_,_,9,_,_],
            [7,9,_,5,6,4,_,8,1]]).

|  1  2  8 |  7  9  3 |  5  6  4 |
|  4  5  6 |  1  2  8 |  7  9  3 |
|  3  7  9 |  4  5  6 |  1  2  8 |

|  8  1  2 |  3  7  9 |  4  5  6 |
|  6  4  5 |  8  1  2 |  3  7  9 |
|  9  3  7 |  6  4  5 |  8  1  2 |

|  2  8  1 |  9  3  7 |  6  4  5 |
|  5  6  4 |  2  8  1 |  9  3  7 |
|  7  9  3 |  5  6  4 |  2  8  1 |
true ;

|  1  2  8 |  7  9  3 |  5  6  4 |
|  4  5  6 |  2  1  8 |  7  9  3 |
|  3  7  9 |  4  5  6 |  1  2  8 |

|  8  1  2 |  3  7  9 |  4  5  6 |
|  6  4  5 |  1  8  2 |  3  7  9 |
|  9  3  7 |  6  4  5 |  8  1  2 |

|  2  8  1 |  9  3  7 |  6  4  5 |
|  5  6  4 |  8  2  1 |  9  3  7 |
|  7  9  3 |  5  6  4 |  2  8  1 |
true ;

|  1  2  8 |  7  9  3 |  5  6  4 |
|  4  5  6 |  2  8  1 |  7  9  3 |
|  3  7  9 |  4  5  6 |  1  2  8 |

|  8  1  2 |  3  7  9 |  4  5  6 |
|  6  4  5 |  8  1  2 |  3  7  9 |
|  9  3  7 |  6  4  5 |  8  1  2 |

|  2  8  1 |  9  3  7 |  6  4  5 |
|  5  6  4 |  1  2  8 |  9  3  7 |
|  7  9  3 |  5  6  4 |  2  8  1 |
true ;

|  1  2  8 |  7  9  3 |  5  6  4 |
|  4  5  6 |  8  2  1 |  7  9  3 |
|  3  7  9 |  4  5  6 |  1  2  8 |

|  8  1  2 |  3  7  9 |  4  5  6 |
|  6  4  5 |  1  8  2 |  3  7  9 |
|  9  3  7 |  6  4  5 |  8  1  2 |

|  2  8  1 |  9  3  7 |  6  4  5 |
|  5  6  4 |  2  1  8 |  9  3  7 |
|  7  9  3 |  5  6  4 |  2  8  1 |
true ;
false.
```
### Sudoku 16x16
```prolog
sudoku([    [3,_,4,6,_,8,10,_,2,12,_,14,5,7,_,11],
            [_,5,9,_,15,2,1,_,6,_,8,3,12,_,10,13],
            [1,8,10,_,_,4,_,14,11,7,9,5,_,_,_,6],
            [_,_,7,12,_,3,6,_,1,10,4,_,14,_,_,9],
            [6,7,_,10,2,12,_,_,3,_,_,4,15,1,14,_],
            [12,_,15,_,10,16,4,_,7,_,1,_,6,9,11,_],
            [_,1,5,_,9,_,_,3,_,6,14,11,16,_,_,4],
            [9,_,11,_,1,6,_,_,15,13,10,_,_,5,7,12],
            [_,3,14,_,7,15,5,2,_,1,6,12,8,_,16,10],
            [5,16,_,7,4,13,3,12,_,15,_,_,1,6,9,_],
            [10,_,1,2,11,_,9,_,4,_,3,13,_,_,_,15],
            [_,12,_,_,6,_,8,_,5,_,16,7,4,11,_,2],
            [8,_,3,5,_,10,16,6,_,4,2,1,_,_,15,7],
            [16,_,2,15,_,_,7,_,14,_,12,_,13,_,6,1],
            [4,_,_,1,14,5,_,15,_,11,_,9,10,_,12,16],
            [_,_,12,_,8,11,_,_,16,_,15,6,9,_,_,5]]).

|  3 15  4  6 | 16  8 10  9 |  2 12 13 14 |  5  7  1 11 |
| 14  5  9 11 | 15  2  1  7 |  6 16  8  3 | 12  4 10 13 |
|  1  8 10 16 | 13  4 12 14 | 11  7  9  5 |  3 15  2  6 |
| 13  2  7 12 |  5  3  6 11 |  1 10  4 15 | 14 16  8  9 |

|  6  7 16 10 |  2 12 11 13 |  3  9  5  4 | 15  1 14  8 |
| 12 14 15 13 | 10 16  4  5 |  7  2  1  8 |  6  9 11  3 |
|  2  1  5  8 |  9  7 15  3 | 12  6 14 11 | 16 10 13  4 |
|  9  4 11  3 |  1  6 14  8 | 15 13 10 16 |  2  5  7 12 |

| 11  3 14  4 |  7 15  5  2 |  9  1  6 12 |  8 13 16 10 |
|  5 16  8  7 |  4 13  3 12 | 10 15 11  2 |  1  6  9 14 |
| 10  6  1  2 | 11 14  9 16 |  4  8  3 13 |  7 12  5 15 |
| 15 12 13  9 |  6  1  8 10 |  5 14 16  7 |  4 11  3  2 |

|  8  9  3  5 | 12 10 16  6 | 13  4  2  1 | 11 14 15  7 |
| 16 11  2 15 |  3  9  7  4 | 14  5 12 10 | 13  8  6  1 |
|  4 13  6  1 | 14  5  2 15 |  8 11  7  9 | 10  3 12 16 |
|  7 10 12 14 |  8 11 13  1 | 16  3 15  6 |  9  2  4  5 |
true ;
false.
```
