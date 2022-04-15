 65816 off
 mcopy movecode.macros

 org $2000
main start

 copy constants/prodos.asm
 copy constants/switches.asm
 copy constants/zp.asm

MAINLOC EQU $800

* copy code to new location as necessary
 movecode routines,routines_end,MAINLOC
 jmp go

* Put the initial code to relocate from $2000 here
* between routines and routines_end.
* The routines and routines labels point to
* the loaded location move moving, labels inside
* the OBJ/OBJEND pair are at the destination
* location
routines anop
 OBJ MAINLOC
 copy routines/cleanup.asm
go ANOP
 jsr cleanup
 OBJEND
routines_end ANOP
 end
