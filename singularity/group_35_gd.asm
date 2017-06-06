[BITS 64]

global  asmddaa , speed , sight , PLAYER_INITIAL_X , PLAYER_INITIAL_Y , PLAYER_INITIAL_Z , HEAD , LEN , up_rd , dn_rd


section .data

    speed               dd  160.0   ; float
    sight               dd  4000.0  ; float
    PLAYER_INITIAL_X    dd  60      ; int
    PLAYER_INITIAL_Y    dd  70      ; int
    PLAYER_INITIAL_Z    dd  -60     ; int
    HEAD                dd  40.0    ; float
    LEN                 dd  70.0    ; float
    up_rd               dd  12.0    ; float
    dn_rd               dd  16.0    ; float


    asmddaa             dq  13377
