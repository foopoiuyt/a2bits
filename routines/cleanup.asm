MLIEXIT EQU $65

cleanup anop
* invalidate reset vector
    INC $03F4
* exit
    JSR  PRODOS
    DC  i1'MLIEXIT'        ;CALL TYPE = QUIT
    DC  i'EXITPARMTABLESTART'  ;Pointer to parameter table
    BRK
 
EXITPARMTABLESTART  anop
 DC i'4'   ;Number of parameters is 4
 DC  i'0'           ;0 is the only quit type
 DC  a'0000'        ;Pointer reserved for future use
 DC  i'0'           ;Byte reserved for future use
 DC  a'0000'        ;Pointer reserved for future use
EXITPARMTABLEEND anop
