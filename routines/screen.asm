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

; Draw a point
; $18 - Page (page 1 == $20 / page 2 == $40)
; $19/$1a - X, $1b - Y
; uses $60-$62 for locals
plot anop
plotPAGE EQU $18
plotXL EQU $19
plotXH EQU $1a
plotY EQU $1b
plotBIT EQU $60
plotTMPL EQU $61
plotTMPH EQU $62

; divide X by 7 to get the byte
; and take the remainder for bit

; TODO: figure out how to divide "properly"

; We know X goes up to 280, so we can cheat
; a little since we know only the lowest
; bit of XH will be set.
 ldy #$00
 lda plotXL
 sec
divloop1 anop
 sbc #$07
 iny
 bcs divloop1
 dec plotXH
 bmi divdone
 sec
 jmp divloop1
divdone anop
; at this point Y has 1 more than X/7 and
; A has one additional subtraction of 7
 dey
 adc #$07

 tax
 lda #$01
 dex
 bmi maskdone
bmask anop
 asl a
 dex
 bpl bmask
maskdone anop
 sta plotBIT

 ldx plotY
 lda lineTableL,X
 sta plotTMPL 
 lda lineTableH,X
 ora plotPAGE
 sta plotTMPH
 lda (plotTMPL),Y
 ora plotBIT
 sta (plotTMPL),Y

 rts

;TODO: fill out line table not including page position
lineTableL anop
 DC h'00 00 00 00 00 00 00 00'
 DC h'80 80 80 80 80 80 80 80'
 DC h'00 00 00 00 00 00 00 00'
 DC h'80 80 80 80 80 80 80 80'
 DC h'00 00 00 00 00 00 00 00'
 DC h'80 80 80 80 80 80 80 80'
 DC h'00 00 00 00 00 00 00 00'
 DC h'80 80 80 80 80 80 80 80'
 DC h'28 28 28 28 28 28 28 28'
 DC h'a8 a8 a8 a8 a8 a8 a8 a8'
 DC h'28 28 28 28 28 28 28 28'
 DC h'a8 a8 a8 a8 a8 a8 a8 a8'
 DC h'28 28 28 28 28 28 28 28'
 DC h'a8 a8 a8 a8 a8 a8 a8 a8'
 DC h'28 28 28 28 28 28 28 28'
 DC h'a8 a8 a8 a8 a8 a8 a8 a8'
 DC h'50 50 50 50 50 50 50 50'
 DC h'd0 d0 d0 d0 d0 d0 d0 d0'
 DC h'50 50 50 50 50 50 50 50'
 DC h'd0 d0 d0 d0 d0 d0 d0 d0'
 DC h'50 50 50 50 50 50 50 50'
 DC h'd0 d0 d0 d0 d0 d0 d0 d0'
 DC h'50 50 50 50 50 50 50 50'
 DC h'd0 d0 d0 d0 d0 d0 d0 d0'

lineTableH anop
 DC h'00 04 08 0c 10 14 18 1c'
 DC h'00 04 08 0c 10 14 18 1c'
 DC h'01 05 09 0d 11 15 19 1d'
 DC h'01 05 09 0d 11 15 19 1d'
 DC h'02 06 0a 0e 12 16 1a 1e'
 DC h'02 06 0a 0e 12 16 1a 1e'
 DC h'03 07 0b 0f 13 17 1b 1f'
 DC h'03 07 0b 0f 13 17 1b 1f'
 DC h'00 04 08 0c 10 14 18 1c'
 DC h'00 04 08 0c 10 14 18 1c'
 DC h'01 05 09 0d 11 15 19 1d'
 DC h'01 05 09 0d 11 15 19 1d'
 DC h'02 06 0a 0e 12 16 1a 1e'
 DC h'02 06 0a 0e 12 16 1a 1e'
 DC h'03 07 0b 0f 13 17 1b 1f'
 DC h'03 07 0b 0f 13 17 1b 1f'
 DC h'00 04 08 0c 10 14 18 1c'
 DC h'00 04 08 0c 10 14 18 1c'
 DC h'01 05 09 0d 11 15 19 1d'
 DC h'01 05 09 0d 11 15 19 1d'
 DC h'02 06 0a 0e 12 16 1a 1e'
 DC h'02 06 0a 0e 12 16 1a 1e'
 DC h'03 07 0b 0f 13 17 1b 1f'
 DC h'03 07 0b 0f 13 17 1b 1f'

; Bresenham line drawing
; $10 - page (page 1 == $20, page 2 == $40)
; $11/$12 - X1 $13 - Y1
; $14/$15 - X2 $16 - Y2
; Uses $70-$78 for locals
; Modifies the X1 and Y1 arguments
bline entry
; parameters (x1, y1, x2, y2)
blinePAGE EQU $10
blineX1L EQU $11
blineX1H EQU $12
blineY1 EQU $13
blineX2L EQU $14
blineX2H EQU $15
blineY2 EQU $16
; locals
blineDXL EQU $70
blineDXH EQU $71
blineDY EQU $72 
blineSX EQU $73
blineSY EQU $74
blineERRL EQU $75
blineERRH EQU $76
blineE2L EQU $77
blineE2H EQU $78

 lda blinePAGE
 sta plotPAGE

; dx = abs(x2 - x1); sx = (x1 < x2) ? 1 : -1
 sec
 lda blineX1L
 sbc blineX2L
 sta blineDXL
 lda blineX1H
 sbc blineX2H
 sta blineDXH
 lda #$FF
 sta blineSX
 bcs dyhandle
 lda blineDXL
 eor #$FF
 sta blineDXL
 inc blineDXL
 lda blineDXH
 eor #$FF
 sta blineDXH
 lda #$01
 sta blineSX
dyhandle anop
; dy = abs(y2 - y1); sy = (y1 < y2) ? 1 : -1
 sec
 lda #$FF
 sta blineSY
 lda blineY1
 sbc blineY2
 sta blineDY
 bcs errorcalc
 eor #$FF
 sta blineDY
 inc blineDY
 lda #$01
 sta blineSY
errorcalc anop
; error = dx - dy
 sec
 lda blineDXL
 sbc blineDY
 sta blineERRL
 lda blineDXH
 sbc #$00
 sta blineERRH
blineloop1 anop
 lda blineX1L
 sta plotXL
 lda blineX1H
 sta plotXH
 lda blineY1
 sta plotY
 jsr plot  

 lda blineX1L
 sta plotXL
 inc plotXL
 lda blineX1H
 sta plotXH
 lda blineY1
 sta plotY
 jsr plot  

; if x0 == x1 and y0 == y1 break
 lda blineX1L
 cmp blineX2L
 bne n0
 lda blineX1H
 cmp blineX2H
 bne n0
 lda blineY1
 cmp blineY2
 bne n0
 jmp blinedone

n0 anop
; e2 = error *2
 lda blineERRL
 asl a
 sta blineE2L
 lda blineERRH
 rol a
 sta blineE2H

; if e2 >= -dy
 lda blineE2H
 bpl e2gtdy ; if e2's high byte doesn't have the high bit set, it must be >0, and therefore >=-dy
; if e2's high high bit is set but e2's high is not FF, it must be less than -255, and therefore cannot be >= -dy
 cmp #$FF
 bne e2dxcmp
 clc
 lda blineE2L
 adc blineDY
 bmi e2dxcmp

e2gtdy anop
; if x0 == x1 break
 lda blineX1L
 cmp blineX2L
 bne n2
 lda blineX1H
 cmp blineX2H
 beq blinedone

n2 anop
; error = error - dy
 sec
 lda blineERRL
 sbc blineDY
 sta blineERRL
 lda blineERRH
 sbc #$00
 sta blineERRH

; x0 = x0 + sx
 lda blineSX
 bmi aa
 inc blineX1L
 bne e2dxcmp
 inc blineX1H
 jmp e2dxcmp
aa anop
 lda blineX1L
 bne bb
 dec blineX1H
bb anop
 dec blineX1L

e2dxcmp anop
; if e2 <= dx
 lda blineE2H
 bmi e2dxcmp3 ; if e2 < 0, then e2 must be <= dx
 cmp blineDXH
 beq e2dxcmp2
 bmi e2dxcmp2
 jmp blineloop1

e2dxcmp2  anop
 lda blineDXL
 cmp blineE2L
 bpl e2dxcmp3
 jmp blineloop1

e2dxcmp3 anop
;            if y0 == y1 break
 lda blineY1
 cmp blineY2
 beq blinedone
;            error = error + dx
 clc
 lda blineERRL
 adc blineDXL
 sta blineERRL
 lda blineERRH
 adc blineDXH
 sta blineERRH
;            y0 = y0 + sy
 lda blineSY
 bmi cc
 inc blineY1
 jmp blineloop1
cc anop
 dec blineY1
 jmp blineloop1

 jmp blineloop1
 
blinedone anop
 rts

 end
