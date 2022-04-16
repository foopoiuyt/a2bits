loadbinroutines start

; load a binary file to its expected address
; Inputs: X,Y -> address of filename
; Outputs: C -> error
;          If C is set, $02 contains error code, $03 contains command
;           (or $FF/$FF if the file being loaded is not of correct type)
loadbin entry

; Get the file info for the requested command
; Set the number of parameters for GET_INFO MLI command (10)
 lda #$0A
 sta LOADBINPARAMS
; Set the filename
 stx LOADBINPARAMS+1
 sty LOADBINPARAMS+2
; call get file info
 jsr prodos
inst1 anop
 DC  i1'MLIGETINFO'
 DC  i'LOADBINPARAMS'  ;Pointer to parameter table
; if there is an error, put the instruction into X and jump to exit
 bcc noerr1
 ldx inst1
 jmp loadbinerror

noerr1 anop
; check that the file is okay to load
; first check that read permission is set on the file
 lda #$01
 and LOADBINPARAMS+3
 bne cmp2 ; Note: may be too far to directly branch to loadbinerroracctype
 jmp loadbinerroracctype
cmp2 anop
; then check that the file is of type BIN
 lda #$06
 cmp LOADBINPARAMS+4
 beq cmpdone
 jmp loadbinerroracctype

cmpdone anop
; We want the destination location of the BIN file later
; but LOADBINPARAMS+5/6 can get overwritten, so save the
; values over the file time that we aren't going to use
 lda LOADBINPARAMS+5
 sta LOADBINPARAMS+$10
 lda LOADBINPARAMS+6
 sta LOADBINPARAMS+$11

; Open the file
; The filename is already in place from the GET_INFO
; Set the number of parameters for OPEN (3)
 lda #$03
 sta LOADBINPARAMS
; Set the file buffer to $A600
 lda #$00
 sta LOADBINPARAMS+3
 lda #$A6
 sta LOADBINPARAMS+4
; call open
 jsr prodos
inst2 anop
 DC  i1'MLIOPEN'        
 DC  i'LOADBINPARAMS'  ;Pointer to parameter table

; if there's an error load the command into X and jump to error
 bcc noerr2
 ldx inst2
 jmp loadbinerror

noerr2 anop
; Get the file length to read
; Set the number of parameters for GET_EOF (2)
 lda #$02
 sta LOADBINPARAMS
; Set the reference number for the open file
;(copying from the open output)
 lda LOADBINPARAMS+5
 sta LOADBINPARAMS+1

; call get eof
 jsr prodos
inst3 anop
 DC  i1'MLIGETEOF'       
 DC  i'LOADBINPARAMS'  ;Pointer to parameter table

; If there's an error, put the command in X and go to error routine
; that will try to close the file
 bcc noerr3
 ldx inst3
 jmp loadbinerrorclose

noerr3 anop 
; Read the entire file into its desired destination location
; Note: the open file reference number is already in place
; Set the number of parameters for READ (4)
 lda #$04
 sta LOADBINPARAMS

; Set the size to read from GET_EOF
; Note: this does not copy the high byte of file size since
; we're doing this for loading an entire bin file into memory
; for use currently.
 lda LOADBINPARAMS+2
 sta lOADBINPARAMS+4
 lda LOADBINPARAMS+3
 sta lOADBINPARAMS+5

; Set the destination location for the data copying from where
; we stashed that info on the GET_INFO call.
 lda LOADBINPARAMS+$10
 sta LOADBINPARAMS+2
 lda LOADBINPARAMS+$11
 sta LOADBINPARAMS+3

; call read file
 jsr prodos
inst4 anop
 DC  i1'MLIREAD'
 DC  i'LOADBINPARAMS'  ;Pointer to parameter table

; If there's an error, load the command into X and jump to error routine
; that tries to close the file
 bcc noerr4
 ldx inst4
 jmp loadbinerrorclose

noerr4 anop
; Close the file for auccess case
; Note: the reference number is already in place
; Set the number of parameters for CLOSE (1)
 lda #$01
 sta LOADBINPARAMS
; call close file
 jsr prodos
 DC  i1'MLICLOSE'
 DC  i'LOADBINPARAMS'  ;Pointer to parameter table

; what do we do if the close fails?!?
; For now, ignore close errors
 clc

 rts

; If we got an error on access or type, set the
; error code and command to $FF
loadbinerroracctype anop
 lda #$ff
 ldx #$ff
 sec

loadbinerror anop
 sta ZPLOADBINERRORCODESTORE
 stx ZPLOADBINERRORCMDSTORE
 rts

; Error handling routine for after open has succeeded
; Trying to close the open file
loadbinerrorclose anop
; Save off the error code and command to zero page
 sta ZPLOADBINERRORCODESTORE
 stx ZPLOADBINERRORCMDSTORE
; Try to close the file (assumes reference number in place)
 lda #$01
 sta LOADBINPARAMS
 jsr prodos
 DC  i1'MLICLOSE'
 DC  i'LOADBINPARAMS'  ;Pointer to parameter table
; as above, not sure to handle failure

; Force carry on to signify the error (even if
; the close succeeds)
 sec
 rts

; Buffer for the MLI parameters
LOADBINPARAMS  anop
 DS 18

 end
