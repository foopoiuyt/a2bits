 65816 off

 org $2000

 copy constants/prodos.asm
 copy constants/switches.asm
 copy constants/zp.asm

 mcopy routines/waitforkey.macros
 mcopy routines/debugtext.macros

main start
 using load

 ldx #<FNAME
 ldy #>FNAME
 jsr loadbin
 bcs showerr
 jmp $800

showerr anop
 lda TEXTON

 cleartextscreen $A0

; Line 1: filename label and filename
 writedebugstringline $400,ERRSTRFNAME,FNAME

 writedebughexline $480,ERRSTRECODE,ZPLOADBINERRORCODESTORE,ERRSTRHEX
 writedebughexline $500,ERRSTRECMD,ZPLOADBINERRORCMDSTORE,ERRSTRHEX

 waitforkey

 jsr cleanup

 MSB ON
ERRSTRFNAME anop
 DC i1'9'
 DC C'FILENAME '

ERRSTRECODE anop
 DC i1'11'
 DC C'ERROR CODE '

ERRSTRECMD anop
 DC i1'8'
 DC C'COMMAND '

ERRSTRHEX anop
 DC C'0123456789ABCDEF'

 MSB OFF

 end

 copy routines/cleanup.asm
 copy routines/loadbin.asm


