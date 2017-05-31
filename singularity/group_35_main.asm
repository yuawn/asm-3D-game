[BITS 64]

%include "inc/Yuawn.inc"
global  Yuawn

extern  main , aaa , bullet , now_bullet \
,aplayer , adirection , anextStep \
, vec3z ;gun , terrain , skybox , enemy

section .data

    mvp                 db  'MVP' , 0
    myTextureSampler    db  'myTextureSampler' , 0
    fire                db  'Fiiiii' , 10 , 0
    s0t                 db  'SH0000000T', 10 , 0
    fw                  dq  620.0
    fh                  dq  360.0
    h10                 dq  0x10
    stt                 db  'BETA %d' , 10 , 0
    sff                 db  'SFF %f %f' , 10 , 0
    sd                  db  'SD %d' , 10 , 0
    sf                  db  'SF %f' , 10 , 0
    soo                 db  'SO %lf %lf' , 10 , 0
    sdd                 db  '%d %d' , 10 , 0
    sst                 db  '%s' , 10 , 0
    bar                 db  'Yuawn' , 10 , 0
    db_lasttime         db  'lasttime ---> %f' , 10 , 0
    nENDLINEtag         db  'Tag' , 0   
    sEXIT               db  'EXIT' , 10 , 0



section .text


Yuawn:
    yuawn_prologue

    sub     rsp, 0x10 * 500 ; :D

    %define VertexArrayID   [rbp - GLuint_s]

    %define terrain         [rbp - GLuint_s - Object_s * 1]
    %define skybox          [rbp - GLuint_s - Object_s * 2]
    %define gun             [rbp - GLuint_s - Object_s * 2 - Equipment_s]
    %define enemy           [rbp - GLuint_s - Object_s * 2 - Equipment_s - Enemy_s * 20]
    
    %define currentTime     [rbp - 0x11ec - double_s]
    %define lastTime        [rbp - 0x11ec - double_s * 2]
    %define lastFrameTime   [rbp - 0x11ec - double_s * 3]
    %define deltaTime       [rbp - 0x11ec - 0x18 - float_s * 2]
    %define cumTime         [rbp - 0x11ec - 0x18 - float_s * 4]
    %define nbFrames        [rbp - 0x1214 - 0x8]
    %define tmp_vec3        [rbp - 0x1220 - 0x10]
    %define cd              [rbp - 0x1230 - 0x8]
    %define tmp             [rbp - 0x1240]
    ; stack align :DDDDDDDDD
    %define player          [rbp - 0x1240 - 0x10]
    %define direction       [rbp - 0x1240 - 0x20]
    %define nextStep        [rbp - 0x1240 - 0x30]
    %define tmp2            [rbp - 0x1278]
    %define now             [rbp - 0x1280]
    %define now2            [rbp - 0x1288]
    %define lim             [rbp - 0x1290]
    %define lim2            [rbp - 0x1298]
    %define isCollision     [rbp - 0x12a0]


    call    glfwInit

    yuawn_x64_call  glfwWindowHint , GLFW_SAMPLES , 4
    yuawn_x64_call  glfwWindowHint , GLFW_CONTEXT_VERSION_MAJOR , 3
    yuawn_x64_call  glfwWindowHint , GLFW_CONTEXT_VERSION_MINOR , 3
    yuawn_x64_call  glfwWindowHint , GLFW_OPENGL_FORWARD_COMPAT , GL_TRUE
    yuawn_x64_call  glfwWindowHint , GLFW_OPENGL_PROFILE , GLFW_OPENGL_CORE_PROFILE
    
    yuawn_x64_call glfwCreateWindow , WINDOW_WIDTH , WINDOW_HEIGHT , bar , 0 , 0
    mov     g( window ), rax
    
    yuawn_x64_call  glfwMakeContextCurrent , g( window )

    mov     qword g( glewExperimental ), 0x1
    call    glewInit

    yuawn_x64_call  glfwSetInputMode , g( window ) , GLFW_STICKY_KEYS , GL_TRUE
    yuawn_x64_call  glfwSetInputMode , g( window ) , GLFW_CURSOR , GLFW_CURSOR_DISABLED
    call    glfwPollEvents

    %ifdef  DEBUG
        yuawn_x64_call yuawn_divii , WINDOW_HEIGHT , 2
        mov     rdi,    stt2
        mov     al,     1
        call    printf
    %endif

    yuawn_x64_call  yuawn_divii , WINDOW_HEIGHT , 2
    movq    xmm2, xmm0

    yuawn_x64_call  yuawn_divii , WINDOW_WIDTH , 2
    movq    xmm1, xmm2

    mov     rdi,  g( window )
    call    glfwSetCursorPos

    yuawn_xmm_call  glClearColor , g( f0 ) , g( f0 ) , g( f0_4 ) , g( f0 )

    yuawn_x64_call  glEnable , GL_DEPTH_TEST
    yuawn_x64_call  glDepthFunc , GL_LESS
    yuawn_x64_call  glEnable , GL_CULL_FACE

    lea     rsi, VertexArrayID
    mov     rdi, 1
    call    glGenVertexArrays
    yuawn_x64_call  glBindVertexArray , VertexArrayID


    LoadShaders_mac './src/tex/TransformVertexShader.vertexshader' , './src/tex/TextureFragmentShader.fragmentshader'
    mov     g( programID ), rax

    mov     rdi, g( programID )
    mov     rsi, mvp
    call    glGetUniformLocation
    mov     g( MatrixID ),  eax ; 4

    mov     rdi, g( programID )
    mov     rsi, myTextureSampler
    call    glGetUniformLocation
    mov     g( TextureID ), eax ; 4

    ;lea     rdi, g( terrain )  ; GLOBAL
    lea     rdi,    terrain
    call    OObject
    Object_init_mac terrain , 'src/land.obj' , 'src/land.dds'

    lea     rdi, skybox
    call    OObject
    Object_init_mac skybox , 'src/skybox.obj' , 'src/skybox.dds'
    ;;;;; TAG
    lea     rdi, gun
    call    EEquip
    Object_init_mac gun , 'src/gun.obj' , 'src/gun.dds'

    lea     rdi,        tmp_vec3
    movq    xmm0,       g( f13_287 )
    movsd   [rdi],      xmm0
    movq    xmm0,       g( f0 )
    movsd   [rdi + 4],  xmm0
    movq    xmm0,       g( f_1_61 )
    movsd   [rdi + 8],  xmm0

    lea     rdi,    gun
    movq    xmm0,   tmp_vec3
    movss   xmm1,   [rbp - 0x11ec - 0x24 - 0x8] ; tmp_vec3 + 8 :D
    call    Equip_setdir
    ;call    Equip_move
    ;;;;;;;
    %assign i 0
    %rep    20

        lea     rdi, enemy
        add     rdi, Enemy_s * i
        call    EEnemy
        lea     rdi, enemy
        add     rdi, Enemy_s * i

        Object_init_mac [rdi] , 'src/robot.obj' , 'src/robot.dds'
        
        lea     rdi, enemy
        add     rdi, Enemy_s * i
        lea     rsi, terrain
        call    y1

        %ifdef  DEBUG
            mov     rdi,    bar
            call    printf
        %endif

    %assign i i+1
    %endrep

    call    glfwGetTime
    movq    lastTime, xmm0
    movq    lastFrameTime, xmm0
    mov     dword nbFrames, 0
    xor     rax,    rax
    mov     cd,     rax

    %ifdef  DEBUG
        movq    xmm0, lastTime
        movq    xmm1, lastFrameTime
        mov     al, 2
        mov     rdi,    sff
        call    printf
    %endif

    ;jmp     DO                      ;xmm ss sd :D
    ;movq    xmm0, g( f0_1 )
    ;movq    xmm1, g( f0_2 )
    ;movq    xmm2, g( f0_3 )
    ;movq    xmm3, g( f_1_1 )
    ;call    abc
    ;yuan:
    movss   xmm0,   g( f0 )
    cvtss2sd xmm0,xmm0
    movsd   cumTime,    xmm0
DO:
    call    glfwGetTime 
    movq    currentTime, xmm0        ;Fucking XMM XDDDDDD
    movq    xmm0,   currentTime
    subsd   xmm0,   lastFrameTime
    movsd   deltaTime, xmm0
    movsd   xmm0,   cumTime
    addsd   xmm0,   deltaTime
    movsd   cumTime,    xmm0

    %ifdef  DEBUG
        movsd   xmm0,   cumTime
        mov     rdi,    sf
        mov     al,     1
        call    printf
    %endif
    
    movq    xmm0,   currentTime
    movq    lastFrameTime, xmm0

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    nbFrames
        call    printf
    %endif

    mov     eax, nbFrames   ; ++   :DDDDDD
    inc     eax
    mov     nbFrames, eax

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    nbFrames
        call    printf
        ;movq    xmm0,   g( d0_7 ) ; :(
        ;mov     rdi,    sf
        ;mov     rax, 1
        ;call    printf
        ;movsd   qword currentTime, xmm0 ; xmm   :DDDDDD
        ;movsd   xmm0, qword currentTime
        ;subsd   xmm0, lastFrameTime
        ;cvtsd2ss    xmm0, xmm0
        ;movss   dword deltaTime, xmm0
        ;movss   xmm0, dword deltaTime
        ;addss   xmm0, dword cumTime
        ;movss   dword cumTime, xmm0
        ;movsd   xmm0, currentTime
        ;movsd   lastFrameTime, xmm0
    %endif

    movq    xmm0, currentTime
    subsd   xmm0, lastTime
    cvtsd2ss    xmm0, xmm0
    movss   xmm1, g( f1_0 )
    comiss  xmm0, xmm1

    jc      littlefish

    %ifdef  DEBUG
        yuawn_print 'INI'
    %endif

    %ifdef  DEBUG
        mov     rdi,    bar
        call    printf
    %endif

    mov     qword nbFrames, 0
    movq    xmm0, lastTime
    addsd   xmm0, g( d1_0 )
    movq    lastTime, xmm0

    %ifdef  DEBUG
        movq    xmm0,   lastTime
        mov     rdi,    db_lasttime
        mov     rax, 1
        call    printf
    %endif

    mov     al,   1
    mov     cd,   al

littlefish:

    %ifdef  DEBUG
        mov     rdi,    nENDLINEtag
        call    printf
        mov     rdi,    sd
        mov     rsi,    cd
        call    printf
    %endif

    mov     rdi, GL_COLOR_BUFFER_BIT
    or      rdi, GL_DEPTH_BUFFER_BIT
    call    glClear

    yuawn_x64_call  glUseProgram , g( programID )

    call    getPosition
    movq    player, xmm0
    ;movss   g( aplayer + 8), xmm1 ;GLOBAL
    movss   [rbp - 0x1240 - 0x10 + 8], xmm1

    call    getDirection
    movq    direction, xmm0
    ;movss   g( adirection + 8 ), xmm1
    movss   [rbp - 0x1240 - 0x20 + 8], xmm1

    call    getNextStep
    movq    nextStep, xmm0
    ;movss   g( anextStep + 8 ), xmm1
    movss   [rbp - 0x1240 - 0x30 + 8], xmm1

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    cd
        call    printf
    %endif

    yuawn_x64_call  glfwGetMouseButton , g( window ) , GLFW_MOUSE_BUTTON_LEFT
    mov     rbx,    GLFW_PRESS
    cmp     rax,    rbx
    jnz     OUT
    xor     eax,    eax
    mov     al,     cd
    mov     ebx,    1
    cmp     eax,    ebx
    jnz     OUT 
    ;BOOOOOOOOM
IN:
    ; y2() SH0000000T
    xor     eax,    eax
    mov     ax,     g( now_bullet )
    mov     dx,     BULLET_AMOUNT
    div     dl

    mov     qword tmp,    0
    mov     tmp,    ah
    mov     rcx,    tmp
    imul    rcx,    rcx,    Weapon_s 

    mov     tmp,    rcx

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    tmp
        call    printf
    %endif

    lea     rdi,    g( bullet )
    add     rdi,    tmp
    movq    xmm0,   player
    movsd   xmm1,   [rbp - 0x1240 - 0x10 + 8]
    movq    xmm2,   direction
    movsd   xmm3,   [rbp - 0x1240 - 0x20 + 8] 
    call    Weapon_init

    mov     eax,    g( now_bullet )
    inc     eax
    mov     g( now_bullet ), eax

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     qword tmp,    0
        mov     tmp,    ah
        mov     rsi,    tmp
        call    printf
        mov     rdi,    fire
        call    printf
    %endif

    xor     rax,    rax
    mov     cd,     rax

OUT:
    ;call    y3
    ;jmp     QQ    ; SHIT .....
    lea     rax,    g( bullet )
    mov     tmp,    rax

    mov     qword lim,    BULLET_AMOUNT
    mov     qword lim2,   ENEMY_AMOUNT
    mov     qword now,    0
  
    L1:
        mov     rdi,    tmp 
        call    weap_getstate
        mov     rbx,    1
        cmp     rax,    rbx
        jnz     BOT

        mov     rdi,    tmp
        call    weap_move

        lea     rax,    enemy
        mov     tmp2,   rax
        mov     qword now2,   0

        L2:
            %ifdef  DEBUG
                mov     rdi,    bar
                call    printf
                yuawn_x64_call  y5 , now , now2
            %endif

            mov     rdi,    tmp
            call    weap_getpos
            mov     rdi,    tmp2
            call    enemy_isdam 
            mov     rbx,    1
            cmp     rax,    rbx
            jnz     BOT2

            mov     rdi,    tmp
            call    weap_dead

            call    rand_vec3
            movq    tmp_vec3, xmm0
            movsd   [rbp - 0x1220 - 0x10 + 8], xmm1

            lea     rdi,    terrain
            movq    xmm0,   tmp_vec3
            movsd   xmm1,   [rbp - 0x1220 - 0x10 + 8]
            movq    xmm2,   g( vec3z )
            lea     rsi,    g( vec3z )
            movsd   xmm3,   [rsi + 8]

            call    Object_mvcolli

            movsd   [rbp - 0x1220 - 0x10 + 8], xmm0
            mov     rdi,    tmp2
            call    enemy_move
        BOT2:
            mov     rax,    tmp2
            add     rax,    Enemy_s 
            mov     tmp2,   rax
            mov     rax,    now2
            inc     rax
            mov     qword now2, rax
            mov     rbx,    lim2
            cmp     rax,    rbx
            jc      L2
    BOT:
        mov     rax,    tmp
        add     rax,    Weapon_s
        mov     tmp,    rax
        mov     rax,    now
        inc     rax
        mov     qword now, rax
        mov     rbx,    lim
        cmp     rax,    rbx
        jc      L1
 
    QQ:
    ;movq    xmm0,   player
    ;movq    xmm1,   [rbp - 0x1240 - 0x10 + 8]
    ;movq    xmm2,   direction
    ;movq    xmm3,   [rbp - 0x1240 - 0x20 + 8] 
    ;movq    xmm4,   nextStep
    ;movq    xmm5,   [rbp - 0x1240 - 0x30 + 8]      

    movq    xmm0,   player
    movq    xmm1,   [rbp - 0x1240 - 0x10 + 8]
    movq    xmm2,   nextStep
    movq    xmm3,   [rbp - 0x1240 - 0x30 + 8]
    lea     rdi,    terrain
    call    Object_mvcolli

    ;cvtss2sd    xmm0,xmm0

    movss   tmp,    xmm0
    movss   xmm0 , dword tmp

    movss   xmm0,   dword tmp
    movsd   xmm1,   g( f_1000_0  ) 
    cvtsd2ss    xmm1,xmm1
    comiss  xmm0,   xmm1
    jc      A

    %ifdef  DEBUG
        mov     rdi,    bar
        call    printf
    %endif

    mov     dword isCollision,    0

    movss   xmm0,   tmp
    addss   xmm0,   g( f10_0  )
    call    setPositionHeight

    yuawn_x64_call  computeMatricesFromInputs , 0

    jmp     B
    A:

    mov     dword isCollision,    1 
    yuawn_x64_call  computeMatricesFromInputs , 1

    B:
    movq    xmm0,   player
    movq    xmm1,   [rbp - 0x1240 - 0x10 + 8]
    movq    xmm2,   direction
    movq    xmm3,   [rbp - 0x1240 - 0x20 + 8]
    lea     rdi,    gun
    call    Equip_aim_at 

    %assign i 0
    %rep    20

        lea     rdi,    enemy
        add     rdi,    Enemy_s * i
        movsd   xmm0,   cumTime
        cvtsd2ss    xmm0,   xmm0   ;I LOVE cvtsd2ss :D
        call    enemy_selfro
        %ifdef  DEBUG
            movsd   xmm0,   cumTime
            mov     rdi,    sf
            mov     al,     1
            call    printf
        %endif

    %assign i i+1
    %endrep

    call    y4 ; MVP

    lea     rdi,    terrain
    call    Object_draw

    lea     rdi,    skybox
    call    Object_draw

    yuawn_x64_call  glfwSwapBuffers , g( window )
    yuawn_x64_call  glfwPollEvents

JUD:
    yuawn_x64_call  glfwGetKey , g( window ) , GLFW_KEY_ESCAPE
    mov     rbx,    1
    cmp     rax,    rbx
    jz      EXIT

    yuawn_x64_call  glfwWindowShouldClose , g( window )
    mov     rbx,    0
    cmp     rax,    rbx
    jnz      EXIT

    jmp     DO

EXIT:
    %ifdef  DEBUG
        call    sz
        lea     rdi,    terrain
        call    ogg
        ;call    main
    %endif

    %ifdef  PRINT
        yuawn_print '[Free]  terrain'
    %endif

    lea     rdi,    terrain
    call    Object_clrbuf

    %ifdef  PRINT
        yuawn_print '[Free]  skybox'
    %endif

    lea     rdi,    skybox
    call    Object_clrbuf

    %ifdef  PRINT
        yuawn_print '[Free]  gun'  
    %endif  

    lea     rdi,    gun
    call    Object_clrbuf

    %assign i 0
    %rep    20

        lea     rdi, enemy
        add     rdi, Enemy_s * i
        call    Object_clrbuf

    %assign i i+1
    %endrep

    %ifdef  PRINT
        yuawn_print '[Free]  enemy[20]' 
    %endif

    %ifdef  DEBUG
        %assign i 0
        %rep    10

            lea     rdi, g( bullet )
            add     rdi, Weapon_s  * i
            call    Object_clrbuf

        %assign i i+1
        %endrep

        yuawn_print '[Free]  bullet[10]'
        
    %endif

    mov     rdi, 1
    lea     rsi, VertexArrayID
    call    glDeleteVertexArrays

    %ifdef  PRINT
        yuawn_print '[Free]  glDeleteVertexArrays(1,&VertexArrayID)'
    %endif

    yuawn_x64_call  glDeleteProgram , g( programID )

    %ifdef  PRINT
        yuawn_print '[Free]  glDeleteProgram(programID)'
    %endif

    mov     rdi, 1
    lea     rsi, g( TextureID )
    call    glDeleteTextures

    %ifdef  PRINT
        yuawn_print '[Free]  glDeleteTextures(1,&TextureID)'
    %endif

    call    glfwTerminate

    %ifdef  PRINT
        yuawn_print '[Free]  glfwTerminate'
    %endif

    %ifdef  DEBUG
        mov     rbx,    0
        cmp     rax,    rbx
        jnz     N0
    %endif


    mov     rax,    0 ; PEACE

    %ifdef  DEBUG
        mov     rdi,    sd
        mov     rsi,    g( f0 )
        call    printf

        mov     rdi,   sEXIT
        call    printf 
        
        mov     rdi,    0
        call    exit
    %endif

N0:
    leave
    ret 
