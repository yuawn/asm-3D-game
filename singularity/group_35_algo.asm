[BITS 64]

%include "inc/Yuawn.inc"

struc   Object_asm
    .vertices       resq    3 ; 24
    .uvs            resq    3 ; 24
    .normals        resq    3 ; 24
    .vertexbuffer   resd    1 ; 4
    .uvbuffer       resd    1 ; 4
    .Texture        resd    1 ; 4
endstruc

global  Cama_Coli

section .data
    sd      db  'NEW int: %d' , 10 , 0
    sf      db  'y = %f' , 10 , 0
    xyz     db  '( %f , %f , %f )' , 10 , 0
    xyz2    db  'base( %f , %f , %f )' , 10 , 0
    xyz3    db  'base2( %f , %f , %f )' , 10 , 0
    xyz4    db  'cooo( %f , %f , %f )' , 10 , 0


section .text

Cama_Coli:
    %define class   [ rbp - 0x08 ]
    %define lim     [ rbp - 0x10 ]
    %define now     [ rbp - 0x18 ]
    %define pos     [ rbp - 0x28 ]
    %define posx    [ rbp - 0x28 ]
    %define posy    [ rbp - 0x24 ]
    %define posz    [ rbp - 0x20 ]
    %define tmp     [ rbp - 0x30 ]
    %define tmp2    [ rbp - 0x38 ]
    %define start   [ rbp - 0x40 ]
    %define fixh    [ rbp - 0x48 ]

    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10 * 7
    mov     class,  rdi
    mov     start,  rsi
    movq    pos,    xmm0
    movsd   [ rbp - 0x20 ], xmm1
    movss   xmm2,   dword g( f0 )
    movss   fixh,   xmm2

    mov     rax,    class
    lea     rdi,    [ rax + Object_asm.vertices ]
    call    vec_vec3_sz
    mov     lim,    rax
    mov     qword now,    0          ; cvtss2sd is my friend :D

    LOOP:
    ;mov     rdi,    sd ;;;@@@@@@@@@@@
    ;mov     rsi,    now
    ;call    printf

    mov     rbx,    now
    imul    rbx,    rbx,    vec3_s 
    mov     rax,    start
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
    subss   xmm0,   dword posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0


    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]
    subss   xmm0,   dword posy

    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2

    lea     rdi,    g( up_rd  )
    call    sqr
    comiss  xmm0,   xmm1                      ; FUCKING SS :P
xy: jc      OUT

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
    subss   xmm0,   dword posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 8 ]
    subss   xmm0,   dword posz
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( up_rd  )
    call    sqr
    comiss  xmm0,   xmm1
xz: jc      OUT

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]
    subss   xmm0,   dword posy
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 8 ]
    subss   xmm0,   dword posz
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( up_rd  )
    call    sqr
    comiss  xmm0,   xmm1
yz: jc      OUT

    %ifdef  DEBUG  
        ; @@@@@@@@@@@@@@@@@@@@ print coli point
        mov     rdi,    xyz4
        movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
        movss   xmm1,   dword [ rax + Object_asm.vertices + rbx + 4 ]
        movss   xmm2,   dword [ rax + Object_asm.vertices + rbx + 8 ]
        cvtss2sd    xmm0,xmm0
        cvtss2sd    xmm1,xmm1
        cvtss2sd    xmm2,xmm2
        mov     al,     3
        call    printf
    %endif

    movss   xmm0,   g( f200_0 )
    leave
    ret
    ;yuawn_print 'NEW in!!!'
    OUT:
    mov     rax,    lim
    mov     rbx,    now
    inc     rbx
    mov     now,    rbx
    cmp     rbx,    rax
    jc      LOOP

    ;@@@@@@@@@@@@@@@@@@@@

    mov     qword now,    0

    movss   xmm0,   dword posy
    subss   xmm0,   dword g( LEN )
    movss   posy,   xmm0


LOOP2:
    mov     rbx,    now
    imul    rbx,    rbx,    vec3_s 
    mov     rax,    start

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
    subss   xmm0,   dword posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]
    subss   xmm0,   dword posy
    ;subss   xmm0,   dword g( f20_0 ) ; bot cir
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( dn_rd  )
    call    sqr
    comiss  xmm0,   xmm1
xy2: jc     OUT2

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
    subss   xmm0,   dword posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 8 ]
    subss   xmm0,   dword posz
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( dn_rd  )
    call    sqr
    comiss  xmm0,   xmm1
xz2: jc     OUT2

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]
    subss   xmm0,   dword posy
    ;subss   xmm0,   dword g( f20_0 ) ; bot cir
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 8 ]
    subss   xmm0,   dword posz
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0
    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2
    lea     rdi,    g( dn_rd  )
    call    sqr
    comiss  xmm0,   xmm1
yz2: jc     OUT2

final: ;CTF
    ;yuawn_print 'BOT cir (coli)'


    mov     rbx,    now
    imul    rbx,    rbx,    vec3_s 
    mov     rax,    start

    %ifdef  DEBUG
        ;@@@@@@@@@@@@@@@@@@@@@@@ print new height point
        mov     rdi,    xyz
        movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
        movss   xmm1,   dword [ rax + Object_asm.vertices + rbx + 4 ]
        movss   xmm2,   dword [ rax + Object_asm.vertices + rbx + 8 ]
        cvtss2sd    xmm0,xmm0
        cvtss2sd    xmm1,xmm1
        cvtss2sd    xmm2,xmm2
        mov     al,     3
        call    printf
    %endif

    ;movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]
    ;cvtss2sd    xmm0,   xmm0
    ;mov     rdi,    sf
    ;mov     al,     1
    ;call    printf

    mov     rbx,    now
    imul    rbx,    rbx,    vec3_s 
    mov     rax,    start

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]   
    movss   xmm1,   dword fixh
    comiss  xmm0,   xmm1
    jc      OUT2
    movss   fixh,   xmm0

    OUT2:
    mov     rax,    lim
    mov     rbx,    now
    inc     rbx
    mov     now,    rbx
    cmp     rbx,    rax
    jc      LOOP2

    movss   xmm0,   fixh
    leave
    ret