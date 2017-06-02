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



global  asmgg , bindGPU_asm , clearBuffer_asm , moveCollision_asm , draw_asm


section .data

    agg     db  'ASMGG!!!!' , 10 , 0
    sd      db  'int: %d' , 10 , 0
    sdd     db  'int2: %d %d' , 10 , 0
    sddd    db  'int3: %d %d %d' , 10 , 0
    sf      db  'float: %f' , 10 , 0
    str2    db  'clearBuffer_asm' , 10 , 0
    str3    db  'IN!!!!!!!' , 10 , 0


section .text

bindGPU_asm:
    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10 * 7
    mov     [ rbp - 0x10], rdi
    mov     rdi,    1
    mov     rax,    [ rbp - 0x10]
    lea     rsi,    [ rax + Object_asm.vertexbuffer]
    call    glGenBuffers

    mov     rdi,    GL_ARRAY_BUFFER
    mov     rax,    [ rbp - 0x10]
    mov     rsi,    [ rax + Object_asm.vertexbuffer]
    call    glBindBuffer

    mov     rdi,    GL_ARRAY_BUFFER
    mov     rsi,    24
    call    glBindBuffer

    leave
    ret


moveCollision_asm:
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
    movsd   [ rbp - 0x20], xmm1
    movss   xmm2,   dword g( f0 )
    movss   fixh,   xmm2

    mov     rax,    class
    lea     rdi,    [ rax + Object_asm.vertices ]
    call    vec_vec3_sz
    mov     lim,    rax

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    lim
        call    printf
    %endif

    mov     qword now,    0          ; cvtss2sd is my friend :D

    %ifdef  DEBUG
        movss   xmm0,   dword posz
        subss   xmm0,   dword posx
        cvtss2sd    xmm0, xmm0
        mov     rdi,    sf
        mov     al,     1
        call    printf
    %endif

    LOOP:
    mov     rbx,    now
    imul    rbx,    rbx,    vec3_s 
    mov     rax,    start
    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx ]
    
    %ifdef  DEBUG
        cvtss2sd    xmm0, xmm0
        mov     rdi,    sf
        mov     al,     1
        call    printf
    %endif

    subss   xmm0,   dword posx
    movss   tmp,    xmm0     
    lea     rdi,    tmp  
    call    sqr
    movss   tmp,    xmm0

    %ifdef  DEBUG
        cvtss2sd    xmm0, xmm0
        mov     rdi,    sf
        mov     al,     1
        call    printf
    %endif

    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]
    subss   xmm0,   dword posy
    movss   tmp2,   xmm0     
    lea     rdi,    tmp2  
    call    sqr
    movss   tmp2,   xmm0

    movss   xmm1,   dword tmp
    addss   xmm1,   dword tmp2

    lea     rdi,    g( ot_rd  )
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
    lea     rdi,    g( ot_rd  )
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
    lea     rdi,    g( ot_rd  )
    call    sqr
    comiss  xmm0,   xmm1
yz: jc      OUT


    movss   xmm0,   dword [ rax + Object_asm.vertices + rbx + 4 ]   
    movss   xmm1,   dword fixh
    comiss  xmm1,   xmm0
    jnc     inn 
    movss   fixh,   xmm0
inn:
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
    lea     rdi,    g( in_rd  )
    call    sqr
    comiss  xmm0,   xmm1
xy2: jc      OUT

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
    lea     rdi,    g( in_rd  )
    call    sqr
    comiss  xmm0,   xmm1
xz2: jc      OUT

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
    lea     rdi,    g( in_rd  )
    call    sqr
    comiss  xmm0,   xmm1
yz2: jc      OUT

final: ;CTF
    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    now
        call    printf
  
        mov     rdi,    str3
        call    printf
    %endif

    movss   xmm0,   g( f_10000_0 )
    leave
    ret

    OUT:
    mov     rax,    lim
    mov     rbx,    now
    inc     rbx
    mov     now,    rbx
    cmp     rbx,    rax
    jc      LOOP

    movss   xmm0,   fixh
    leave
    ret


draw_asm:
    %define OBJ     [rbp - 0x08]
    %define size    [rbp - 0x10]
    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10
    mov     OBJ,    rdi
    mov     size,   rsi
    
    yuawn_x64_call  glEnableVertexAttribArray , 0
    mov     rdi,    GL_ARRAY_BUFFER
    mov     rax,    OBJ
    mov     rsi,    [ rax + Object_asm.vertexbuffer ]
    call    glBindBuffer
    yuawn_x64_call  glVertexAttribPointer , 0 , 3 , GL_FLOAT , GL_FALSE , 0 , 0

    yuawn_x64_call  glEnableVertexAttribArray , 1
    mov     rdi,    GL_ARRAY_BUFFER
    mov     rax,    OBJ
    mov     rsi,    [ rax + Object_asm.uvbuffer ]
    call    glBindBuffer
    yuawn_x64_call  glVertexAttribPointer , 1 , 2 , GL_FLOAT , GL_FALSE , 0 , 0

    yuawn_x64_call  glActiveTexture , GL_TEXTURE0
    mov     rdi,    GL_TEXTURE_2D
    mov     rax,    OBJ
    mov     rsi,    [ rax + Object_asm.Texture ]
    call    glBindTexture

    mov     rsi,    0
    mov     rax,    OBJ
    mov     rdi,    g( TextureID )
    call    glUniform1i

    mov     rdi,    GL_TRIANGLES
    mov     rsi,    0
    mov     rdx,    size
    call    glDrawArrays

    yuawn_x64_call  glDisableVertexAttribArray , 0
    yuawn_x64_call  glDisableVertexAttribArray , 1

    leave
    ret


clearBuffer_asm:;TAG
    push    rbp
    mov     rbp,    rsp
    sub     rsp,    0x10
    mov     [ rbp - 0x8 ], rdi
    ;mov     [ rbp - 0x10 ], rsi

    %ifdef  DEBUG
        mov     rdi,    sddd
        mov     rax,    [ rbp - 0x8 ]
        lea     rsi,    [ rax + Object_asm.vertexbuffer ]
        lea     rdx,    [ rax + Object_asm.uvbuffer ]
        lea     rcx,    [ rax + Object_asm.Texture ]
        call    printf
    %endif

    mov     rdi,    1
    mov     rax,    [ rbp - 0x8 ]
    lea     rsi,    [ rax + Object_asm.vertexbuffer ]
    call    glDeleteBuffers

    mov     rdi,    1
    mov     rax,    [ rbp - 0x8 ]
    lea     rsi,    [ rax + Object_asm.uvbuffer ]
    call    glDeleteBuffers

    %ifdef  DEBUG
        mov     rdi,    1
        mov     rax,    [ rbp - 0x8 ]
        lea     rsi,    [ rax + Object_asm.Texture ]
        call    glDeleteTextures
    %endif

    %ifdef  DEBUG
        mov     rdi,    str2
        call    printf
    %endif

    leave
    ret
    

asmgg:
    yuawn_prologue
    mov rdi, agg
    call    printf
    leave
    ret