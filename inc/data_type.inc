[bits 64]





struc   Object_asm
    .vertices       resq    3 ; 24
    .uvs            resq    3 ; 24
    .normals        resq    3 ; 24
    .vertexbuffer   resd    1 ; 4
    .uvbuffer       resd    1 ; 4
    .Texture        resd    1 ; 4
endstruc







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
    .Texture        resd    1 ; 4

    .ad             resq    1 ; 8
endstruc







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