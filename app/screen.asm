 65816 off

 org $800

 copy constants/prodos.asm
 copy constants/switches.asm
 copy constants/zp.asm

 mcopy routines/waitforkey.macros

screenapp start
 jsr vblanksetup

 ldx #$20
 ldy #$00
 jsr clearscreen
 ldx #$40
 ldy #$00
 jsr clearscreen
 copy routines/setupgraphics.asm

 waitforkey

 lda #$40
 sta $10
 lda #$0A
 sta $11
 lda #$3C
 sta $14
 lda #0
 sta $12
 sta $15
 lda #$40
 sta $13
 lda #$15
 sta $16
 jsr bline

 lda #$3C
 sta $11
 lda #$6E
 sta $14
 lda #0
 sta $12
 sta $15
 lda #$15
 sta $13
 lda #$40
 sta $16
 jsr bline

 lda #$6E
 sta $11
 lda #$3C
 sta $14
 lda #0
 sta $12
 sta $15
 lda #$40
 sta $13
 lda #$6D
 sta $16
 jsr bline

 lda #$3C
 sta $11
 lda #$0A
 sta $14
 lda #0
 sta $12
 sta $15
 lda #$6D
 sta $13
 lda #$40
 sta $16
 jsr bline

 lda #$01
 sta $11
 lda #$0A
 sta $14
 lda #$01
 sta $12
 sta $15
 lda #$0D
 sta $13
 lda #$80
 sta $16
 jsr bline

 jsr vblank
 lda PAGE2ON

 waitforkey 

 jsr cleanup ; won't return
 
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
