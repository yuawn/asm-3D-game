[BITS 64]

%include "inc/Yuawn.inc"

struc   Enemy_asm
    .vertices       resq    3 ; 24
    .uvs            resq    3 ; 24
    .normals        resq    3 ; 24

    .chunk          resd    3 ; 12

    .face           resd    1 ; 4
    .position       resb    vec3_s ; 12
    .direction      resb    vec3_s ; 12

    .vertexbuffer   resd    1 ; 4
    .uvbuffer       resd    1 ; 4
    .Texture        resd    1 ; 4

    .blood          resq    1 ; 8
    .now_blood      resq    1 ; 8

endstruc


global  isDamage_asm


section .text

isDamage_asm:
    %define class           [ rbp - 0x08 ]
    %define start           [ rbp - 0x10 ]
    %define attack_pos      [ rbp - 0x20 ]
    %define attack_posx     [ rbp - 0x20 ]
    %define attack_posy     [ rbp - 0x1c ]
    %define attack_posz     [ rbp - 0x18 ]
    %define lim             [ rbp - 0x28 ]
    %define now             [ rbp - 0x30 ]
    %define tmp             [ rbp - 0x38 ]
    %define tmp2            [ rbp - 0x40 ]

    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10 * 7
    mov     class,  rdi
    mov     start,  rsi
    movq    attack_pos, xmm0
    movsd   attack_posz, xmm1

    mov     rdi,    class
    call    vec_vec3_sz
    mov     lim,    rax

    mov     qword now,    0

    LOOP:
    mov     rbx,    now
    imul    rbx,    rbx,    vec3_s 
    mov     rax,    start
    mov     rcx,    class

    movss   xmm0,   dword [ rax + Enemy_asm.vertices + rbx ]
    addss   xmm0,   dword [ rcx + Enemy_asm.position ]
    subss   xmm0,   dword attack_posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Enemy_asm.vertices + rbx + 4 ]
    addss   xmm0,   dword [ rcx + Enemy_asm.position + 4 ]
    subss   xmm0,   dword attack_posy
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( WEAPON_RADIUS )
    call    sqr
    comiss  xmm0,   xmm1
xy: jc      OUT

    movss   xmm0,   dword [ rax + Enemy_asm.vertices + rbx ]
    addss   xmm0,   dword [ rcx + Enemy_asm.position ]
    subss   xmm0,   dword attack_posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Enemy_asm.vertices + rbx + 8 ]
    addss   xmm0,   dword [ rcx + Enemy_asm.position + 8 ]
    subss   xmm0,   dword attack_posz
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( WEAPON_RADIUS)
    call    sqr
    comiss  xmm0,   xmm1
xz: jc      OUT

    movss   xmm0,   dword [ rax + Enemy_asm.vertices + rbx + 4 ]
    addss   xmm0,   dword [ rcx + Enemy_asm.position + 4 ]
    subss   xmm0,   dword attack_posy
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Enemy_asm.vertices + rbx + 8 ]
    addss   xmm0,   dword [ rcx + Enemy_asm.position + 8 ]
    subss   xmm0,   dword attack_posz
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( WEAPON_RADIUS )
    call    sqr
    comiss  xmm0,   xmm1
yz: jc      OUT

    mov     rax,    1
    leave
    ret

    OUT:
    mov     rax,    lim
    mov     rbx,    now
    inc     rbx
    mov     now,    rbx
    cmp     rbx,    rax
    jc      LOOP

    mov     rax,    0
    leave
    ret