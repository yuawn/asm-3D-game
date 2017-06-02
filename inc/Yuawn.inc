;Yuawn

;%define DEBUG
;%define Original_Enemy_Bullet_p

%include "inc/:D.inc"
%include "inc/lazy.inc"
%include "inc/config.inc"
%include "inc/CSTD.inc"


%define   yuawn_stack_align  and rsp,  0xFFFFFFFFFFFFFFF0
%xdefine  yuawn_stack_align2 and rsp,  -16
%define   var(i) [ebp - 4 * (i)]
%define   g(x)  [rel x]

;Yuawn stupid NASM
%define   ebp rbp


;Yuawn Macro
%macro  yuawn_prologue 0
  push  rbp
  mov   rbp, rsp
  ;yuawn_stack_align
  ;sub   rsp, 0x10 * %1
%endmacro


%macro  yuawn_x64_call 1-8 7,7,7,7,7,7,7

  mov   rdi, %2
  mov   rsi, %3

  %if %4 != 7
    mov   rdx, %4
  %endif
  %if %5 != 7
    mov   rcx, %5
  %endif
  %if %6 != 7
    mov   r8,  %6
  %endif
  %if %7 != 7
    mov   r9,  %7 
  %endif
  %if %8 != 7
    yuawn_stack_align
    sub   rsp, 0x8
    push  qword %8
  %endif
  call  %1
%endmacro


%macro  LoadShaders_mac 2
jmp     %%endstr
%%vertexshader:   db  %1 , 0
%%fragmentshader: db  %2 , 0
%%endstr:
  mov   rdi, %%vertexshader
  mov   rsi, %%fragmentshader
  call  LoadShaders
%endmacro


%macro  Object_init_mac 3
jmp     %%endstr
%%obj:   db  %2 , 0
%%dds:   db  %3 , 0
%%endstr:
  lea   rdi, %1
  mov   rsi, %%obj
  mov   rdx, %%dds
  call  Object_init
%endmacro


%macro  yuawn_xmm_call 1-5 g(f0_0),g(f0_0),g(f0_0),g(f0_0)
  movq  xmm0, %2
  movq  xmm1, %3
  movq  xmm2, %4
  movq  xmm3, %5
  call  %1
%endmacro


%macro  yuawn_print 1-4 87,87,87
  jmp     %%endstr
  %ifstr  %1
    %%str: db  %1 , 10 , 0
  %endif
  %%endstr:
  mov     rdi, %%str
  %if %2 != 87
    mov     rsi,  %2
  %endif
  %if %3 != 87
    mov     rdx,  %3
  %endif
  %if %4 != 87
    mov     rcx,  %4
  %endif
  call  printf
%endmacro






;C++ Symbols
;yuawn
extern  _Z9yuawn_divii
yuawn_divii     EQU   _Z9yuawn_divii

;lib
extern  _ZN6ObjectC1Ev , _ZN5EnemyC1Ev , _ZN9EquipmentC1Ev , _Z2y1P5EnemyP6Object , _Z3abcffff , _ZN6Object4initEPKcS1_ \
, _ZN3glm5tvec3IfLNS_9precisionE0EEC1IdddEET_T0_T1_ , _ZN9Equipment4moveEN3glm5tvec3IfLNS0_9precisionE0EEE \
, _ZN9Equipment12setDirectionEN3glm5tvec3IfLNS0_9precisionE0EEE , _Z11getPositionv , _Z12getDirectionv \
, _Z11getNextStepv , _Z2y2N3glm5tvec3IfLNS_9precisionE0EEES2_ , _Z2y3v , _Z2y4N3glm5tvec3IfLNS_9precisionE0EEES2_S2_ \
, _Z2y4v , _Z2szv , _ZN6Weapon4initEN3glm5tvec3IfLNS0_9precisionE0EEES3_ , _ZN6Object11clearBufferEv \
, _Z11vec_vec3_szPNSt3__16vectorIN3glm5tvec3IfLNS1_9precisionE0EEENS_9allocatorIS4_EEEE , _Z3sqrIfET_RKS0_ \
, _ZN6Object2ggEv , _ZN6Weapon8getStateEv , _ZN6Weapon4moveEv , _ZN6Weapon11getPositionEv \
, _ZN5Enemy8isDamageEN3glm5tvec3IfLNS0_9precisionE0EEE , _ZN6Weapon4deadEv , _Z9rand_vec3v \
, _ZN6Object13moveCollisionEN3glm5tvec3IfLNS0_9precisionE0EEES3_ , _Z2y5ii \
, _ZN5Enemy4moveEN3glm5tvec3IfLNS0_9precisionE0EEE , _Z17setPositionHeightf \
, _Z25computeMatricesFromInputsb , _ZN9Equipment5aimAtEN3glm5tvec3IfLNS0_9precisionE0EEES3_ \
, _ZN5Enemy10selfRotateEf , _ZN6Object4drawEv , _Z4y4_2v , _ZN5Enemy6DamageEN3glm5tvec3IfLNS0_9precisionE0EEEl \




OObject             EQU   _ZN6ObjectC1Ev
EEnemy              EQU   _ZN5EnemyC1Ev 
EEquip              EQU   _ZN9EquipmentC1Ev
Equip_move          EQU   _ZN9Equipment4moveEN3glm5tvec3IfLNS0_9precisionE0EEE
Equip_setdir        EQU   _ZN9Equipment12setDirectionEN3glm5tvec3IfLNS0_9precisionE0EEE
Equip_aim_at        EQU   _ZN9Equipment5aimAtEN3glm5tvec3IfLNS0_9precisionE0EEES3_

Object_init         EQU   _ZN6Object4initEPKcS1_
Object_clrbuf       EQU   _ZN6Object11clearBufferEv
Object_mvcolli      EQU   _ZN6Object13moveCollisionEN3glm5tvec3IfLNS0_9precisionE0EEES3_
Object_draw         EQU   _ZN6Object4drawEv
Weapon_init         EQU   _ZN6Weapon4initEN3glm5tvec3IfLNS0_9precisionE0EEES3_
weap_getstate       EQU   _ZN6Weapon8getStateEv
weap_move           EQU   _ZN6Weapon4moveEv
weap_getpos         EQU   _ZN6Weapon11getPositionEv
weap_dead           EQU   _ZN6Weapon4deadEv
enemy_dama          EQU   _ZN5Enemy6DamageEN3glm5tvec3IfLNS0_9precisionE0EEEl
enemy_isdam         EQU   _ZN5Enemy8isDamageEN3glm5tvec3IfLNS0_9precisionE0EEE
enemy_move          EQU   _ZN5Enemy4moveEN3glm5tvec3IfLNS0_9precisionE0EEE
enemy_selfro        EQU   _ZN5Enemy10selfRotateEf

getPosition         EQU   _Z11getPositionv
getDirection        EQU   _Z12getDirectionv
getNextStep         EQU   _Z11getNextStepv
setPositionHeight   EQU   _Z17setPositionHeightf
computeMatricesFromInputs  EQU   _Z25computeMatricesFromInputsb


;namespace glm :O
vec3                EQU   _ZN3glm5tvec3IfLNS_9precisionE0EEC1IdddEET_T0_T1_

rand_vec3           EQU   _Z9rand_vec3v
sz                  EQU   _Z2szv
vec_vec3_sz         EQU   _Z11vec_vec3_szPNSt3__16vectorIN3glm5tvec3IfLNS1_9precisionE0EEENS_9allocatorIS4_EEEE
sqr                 EQU   _Z3sqrIfET_RKS0_
y1                  EQU   _Z2y1P5EnemyP6Object
y2                  EQU   _Z2y2N3glm5tvec3IfLNS_9precisionE0EEES2_
y3                  EQU   _Z2y3v
y4                  EQU   _Z2y4N3glm5tvec3IfLNS_9precisionE0EEES2_S2_
y4_2                EQU   _Z4y4_2v
y5                  EQU   _Z2y5ii
vy4                 EQU   _Z2y4v
abc                 EQU   _Z3abcffff
ogg                 EQU   _ZN6Object2ggEv

;GLOBAL vars
;extern  gRenderer
;SCREEN_WIDTH          EQU   1280
;SCREEN_HEIGHT         EQU   720
;PLAYER_SPEED          EQU   5




