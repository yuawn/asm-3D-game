[BITS 64]

%include "inc/Yuawn.inc"


struc   Weapon_asm
    .vertices       resq    3 ; 24
    .uvs            resq    3 ; 24
    .normals        resq    3 ; 24

    .chunk          resd    3 ; 12

    .position       resb    vec3_s ; 12
    .direction      resb    vec3_s ; 12
    .fire           resd    1 ; 4

    .vertexbuffer   resd    1 ; 4
    .uvbuffer       resd    1 ; 4
    .Texture        resd    2 ; 4
endstruc


global  init_asm , weapon_move_asm , weapon_dead_asm , weapon_getPosition_asm

section .data



section .text

init_asm:
    push    rbp
    mov     rbp,    rsp
    
    movq    [ rdi + Weapon_asm.position ], xmm0
    movsd   [ rdi + Weapon_asm.position + 8 ], xmm1

    movq    [ rdi + Weapon_asm.direction ], xmm2
    movsd   [ rdi + Weapon_asm.direction + 8 ], xmm3

    mov     dword [ rdi + Weapon_asm.fire ], 1

    leave
    ret


weapon_move_asm:
    %define obj [rbp - 0x8]
    
    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10
    mov     obj,    rdi

    movss   xmm0,   dword   [rdi + Weapon_asm.direction]  
    mulss   xmm0,   g( WEAPON_SPEED )   
    addss   xmm0,   dword   [rdi + Weapon_asm.position]
    movss   [rdi + Weapon_asm.position], xmm0

    movss   xmm0,   dword   [rdi + Weapon_asm.direction + 4]  
    mulss   xmm0,   g( WEAPON_SPEED )   
    addss   xmm0,   dword   [rdi + Weapon_asm.position + 4]
    movss   [rdi + Weapon_asm.position + 4], xmm0

    movss   xmm0,   dword   [rdi + Weapon_asm.direction + 8]  
    mulss   xmm0,   g( WEAPON_SPEED )   
    addss   xmm0,   dword   [rdi + Weapon_asm.position + 8]
    movss   [rdi + Weapon_asm.position + 8], xmm0

    leave
    ret


weapon_dead_asm:
    push    rbp
    mov     rbp,    rsp

    mov     dword [rdi + Weapon_asm.fire], 0

    mov     qword [rdi + Weapon_asm.position], 0
    mov     qword [rdi + Weapon_asm.position + 8], 0
    mov     qword [rdi + Weapon_asm.position + 16], 0

    leave
    ret


weapon_getPosition_asm:
    push    rbp
    mov     rbp,    rsp

    movq    xmm0,   [rdi + Weapon_asm.position]
    movsd   xmm1,   [rdi + Weapon_asm.position + 8]

    leave
    ret
