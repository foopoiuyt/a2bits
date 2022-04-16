 65816 off

 org $2000

 copy constants/prodos.asm
 copy constants/switches.asm
 copy constants/zp.asm

 mcopy routines/waitforkey.macros

main start

 ldx #<FNAME
 ldy #>FNAME
 jsr loadbin
 bcs showerr
 jmp $800

showerr anop
 lda TEXTON

; Clear the text screen
 ldx #$04
 lda #$A0
eclol anop
 ldy #$00
eclil anop
 sta $400,Y
 iny
 bne eclil
 inc eclil+2
 dex
 bne eclol

; Line 1: filename label and filename
 ldy ERRSTRFNAME
 ldx $00
efl anop
 lda ERRSTRFNAME+1,X
 sta $400,X
 inx
 dey
 bne efl

; Move the position for the filename forward by the 
; number of characters for label
 txa
 adc efnp+1
 sta efnp+1

 ldy FNAME
 ldx $00
efnl anop
 lda FNAME+1,X
efnp anop
 sta $400,X ; Note: the lower byte here will be modified above
 inx
 dey
 bne efnl

; Line 2 error code label and code
 ldy ERRSTRECODE
 ldx $00
ecl anop
 lda ERRSTRECODE+1,X
 sta $480,X
 inx
 dey
 bne ecl

 lda ZPLOADBINERRORCODESTORE
 lsr A
 lsr A
 lsr A
 lsr A
 tay
 lda ERRSTRHEX,Y
 sta $480,X
 inx

 lda ZPLOADBINERRORCODESTORE
 and #$0F
 tay
 lda ERRSTRHEX,Y
 sta $480,X

; Line 3 Error command (mli command that failed)
 ldy ERRSTRECMD
 ldx $00
ecml anop
 lda ERRSTRECMD+1,X
 sta $500,X
 inx
 dey
 bne ecml

 lda ZPLOADBINERRORCMDSTORE
 lsr A
 lsr A
 lsr A
 lsr A
 tay
 lda ERRSTRHEX,Y
 sta $500,X
 inx

 lda ZPLOADBINERRORCMDSTORE
 and #$0F
 tay
 lda ERRSTRHEX,Y
 sta $500,X

 waitforkey

 jsr cleanup

FNAME anop
 DC i1'6'
 DC C'SCREEN'

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

