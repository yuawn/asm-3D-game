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

global  asm_asm , Damage_asm , set_now_blood_asm , set_blood_asm \
, get_now_blood_asm

section .data

    str3    db  'rdi=%d vertices=%d face=%d vertexbuffer=%d' , 10 ,0
    str3_2  db  'vertices=%d face=%d vertexbuffer=%d' , 10 ,0
    str3_3  db  'vertices=%d face=%d position=%d' , 10 ,0
    str3_4  db  'start=%d &vertices[0]=%d' , 10 , 0
    sdd     db  'int2 %d %d' , 10 , 0
    sd      db  'SD %d' , 10 , 0


section .text

asm_asm:
    %define class           [ rbp - 0x08 ]
    %define start           [ rbp - 0x10 ]
    %define attack_pos      [ rbp - 0x18 ]
    %define attack_posx     [ rbp - 0x18 ]
    %define attack_posy     [ rbp - 0x1c ]
    %define attack_posz     [ rbp - 0x20 ]

    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10 * 1
    mov     class,  rdi
    mov     start,  rsi
    movq    attack_pos, xmm0
    movsd   attack_posz, xmm1
    
    mov     rax,    class

    %ifdef  DEBUG
        mov     rdi,    str3_2
        lea     rsi,    [ rax + Enemy_asm.vertices ]
        lea     rdx,    [ rax + Enemy_asm.face ]
        lea     rcx,    [ rax + Enemy_asm.position ]
        call    printf
    %endif

    mov     rdi,    sdd
    mov     rsi,    class
    mov     rdx,    start
    call    printf    

    leave
    ret


set_now_blood_asm:
    push    rbp
    mov     rbp,    rsp

    mov     [rdi + Enemy_asm.now_blood],   rsi

    leave
    ret


get_now_blood_asm:
    push    rbp
    mov     rbp,    rsp

    mov     rax,   [rdi + Enemy_asm.now_blood]

    leave
    ret


set_blood_asm:
    push    rbp
    mov     rbp,    rsp

    mov     [rdi + Enemy_asm.blood],   rsi

    leave
    ret



Damage_asm:
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
    %define ad              [ rbp - 0x48 ]

    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10 * 7
    mov     class,  rdi
    mov     start,  rsi
    mov     ad,     rdx
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

    mov     rsi,    [ rcx + Enemy_asm.now_blood ]
    sub     rsi,    ad
    mov     [ rcx + Enemy_asm.now_blood ], rsi

    ;$$$$$$$$$$$$$$$$$$$$$print (long) new blood
    mov     rdi,    sd
    call    printf

    mov     rcx,    class
    mov     rax,    [ rcx + Enemy_asm.now_blood ]
    leave
    ret

    OUT:
    mov     rax,    lim
    mov     rbx,    now
    inc     rbx
    mov     now,    rbx
    cmp     rbx,    rax
    jc      LOOP

    mov     rax,    -1
    leave
    ret


Enemy_clearBuffer_asm:
    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10
    mov     [ rbp - 0x8 ], rdi
    ;mov     [ rbp - 0x10 ], rsi

    %ifdef  DEBUG
        mov     rdi,    sddd
        mov     rax,    [ rbp - 0x8 ]
        lea     rsi,    [ rax + Enemy_asm.vertexbuffer ]
        lea     rdx,    [ rax + Enemy_asm.uvbuffer ]
        lea     rcx,    [ rax + Enemy_asm.Texture ]
        call    printf
    %endif

    mov     rdi,    1
    mov     rax,    [ rbp - 0x8 ]
    lea     rsi,    [ rax + Enemy_asm.vertexbuffer ]
    call    glDeleteBuffers

    mov     rdi,    1
    mov     rax,    [ rbp - 0x8 ]
    lea     rsi,    [ rax + Enemy_asm.uvbuffer ]
    call    glDeleteBuffers

    %ifdef  DEBUG
        mov     rdi,    1
        mov     rax,    [ rbp - 0x8 ]
        lea     rsi,    [ rax + Enemy_asm.Texture ]
        call    glDeleteTextures
    %endif

    %ifdef  DEBUG
        mov     rdi,    str2
        call    printf
    %endif

    leave
    ret