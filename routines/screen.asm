screenroutines start

; clear a hires screen, set X to 20/40 for page 1/2
; Y to value
clearscreen entry
 stx clearscreen_in+2
 ldx #$20
 lda #$00
 sta clearscreen_in+1
 tya
clearscreen_out anop
 ldy #$00
clearscreen_in anop
 sta $2000,Y

 iny
 bne clearscreen_in
 dex
 beq clearscreen_done
 inc clearscreen_in+2
 jmp clearscreen_out
clearscreen_done anop
 rts

vblanksetup entry
 lda $FBC0 ; todo make constant
 bne vblanksetupdone

; TODO: apple2c version

; patch the vblank jump
 lda #<vblankc
 sta vblank + 1
 lda #>vblankc
 sta vblank + 2

 sta $c005 ; RAMWRTaux = $c005

 sei
 sta $c079
 sta $c05b
 sta $c078
vblanksetupdone anop
 rts

vblank entry
 jmp vblanke

vblanke anop
vbeloop1 lda $c019
 bpl vbeloop1
vbeloop lda $c019
 bmi vbeloop ;wait for beginning of VBL interval
 rts

vblflag anop
 ds 1

vblankc anop
 cli
vbcloop1 anop
 bit vblflag
 bpl vbcloop1 ;wait for vblflag = 1
 lsr vblflag ;...& set vblflag = 0

vbcloop2 anop
 bit vblflag
 bpl vbcloop2
 lsr vblflag

 sei
 rts

 end
