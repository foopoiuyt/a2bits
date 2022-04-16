 65816 off

 org $800

 copy constants/prodos.asm
 copy constants/switches.asm
 copy constants/zp.asm

 mcopy routines/waitforkey.macros

screenapp start
 jsr vblanksetup

 ldx #$20
 ldy #$55
 jsr clearscreen
 copy routines/setupgraphics.asm

 waitforkey
 
 lda #$00
 sta $02
 lda #$40
 sta $03

p0 anop
 ldy $02
 ldx $03
 jsr clearscreen

 jsr vblank

 lda $03
 cmp #$40
 bne p2
p1 anop
 lda PAGE2ON
 lda #$20
 sta $03
 jmp p3
p2 anop
 lda PAGE2OFF
 lda #$40
 sta $03
p3 anop
 inc $02
 bne p0 

 waitforkey

 jsr cleanup ; won't return

 end

 copy routines/cleanup.asm
 copy routines/screen.asm
