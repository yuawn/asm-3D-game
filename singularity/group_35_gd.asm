[BITS 64]

global  asmddaa , speed , sight , PLAYER_INITIAL_X , PLAYER_INITIAL_Y , PLAYER_INITIAL_Z


section .data

    speed               dd  160.0   ; float
    sight               dd  1500.0  ; float
    PLAYER_INITIAL_X    dd  60      ; int
    PLAYER_INITIAL_Y    dd  70      ; int
    PLAYER_INITIAL_Z    dd  -60     ; int


    asmddaa             dq  13377
