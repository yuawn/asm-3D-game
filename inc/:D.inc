;Fucking Object-Oiented (foo) in ASM :D
Object_s                          EQU   88
GLuint_s                          EQU   4
Enemy_s                           EQU   144
Equipment_s                       EQU   200
Weapon_s                          EQU   208
vector_vec2_s                     EQU   24
vector_vec3_s                     EQU   24
vec2_s                            EQU   8
vec3_s                            EQU   12
mat4_s                            EQU   64
float_s                           EQU   4
double_s                          EQU   8

;ASM sym
EXTERN  _Z11LoadShadersPKcS0_
LoadShaders EQU _Z11LoadShadersPKcS0_


;Define GLFW :D
GLFW_SAMPLES                      EQU   0x0002100D
GLFW_CONTEXT_VERSION_MAJOR        EQU   0x00022002
GLFW_CONTEXT_VERSION_MINOR        EQU   0x00022003
GLFW_OPENGL_FORWARD_COMPAT        EQU   0x00022006
GLFW_OPENGL_PROFILE               EQU   0x00022008
GLFW_OPENGL_CORE_PROFILE          EQU   0x00032001
GLFW_STICKY_KEYS                  EQU   0x00033002
GLFW_CURSOR                       EQU   0x00033001
GLFW_CURSOR_DISABLED              EQU   0x00034003
GLFW_PRESS                        EQU   1
GLFW_MOUSE_BUTTON_LEFT            EQU   0 ;GLFW_MOUSE_BUTTON_1
GLFW_KEY_ESCAPE                   EQU   256

;sym
EXTERN  glfwInit , glfwWindowHint , glfwCreateWindow , glfwMakeContextCurrent , glfwSetInputMode , glfwPollEvents\
, glfwSetCursorPos , glfwGetTime , glfwGetMouseButton , glfwGetKey , glfwSwapBuffers , glfwWindowShouldClose \
, glfwGetCursorPos


EXTERN  glewInit

EXTERN  glClearColor , glEnable , glDepthFunc , glGenVertexArrays , glBindVertexArray , glGetUniformLocation\
, glClear , glUseProgram , glDeleteProgram , glDeleteTextures , glfwTerminate , glGenBuffers , glBindBuffer\
, glBufferData , glDeleteBuffers , glDeleteVertexArrays , glEnableVertexAttribArray , glVertexAttribPointer \
, glActiveTexture , glBindTexture , glUniform1i , glDrawArrays , glDisableVertexAttribArray 




;Define GL GLEW :P
GL_TRUE                           EQU   1
GL_FALSE                          EQU   0
GL_DEPTH_TEST                     EQU   0x0B71
GL_LESS                           EQU   0x0201
GL_CULL_FACE                      EQU   0x0B44
GL_COLOR_BUFFER_BIT               EQU   0x00004000
GL_DEPTH_BUFFER_BIT               EQU   0x00000100
GL_ARRAY_BUFFER                   EQU   0x8892
GL_STATIC_DRAW                    EQU   0x88E4
GL_TEXTURE0                       EQU   0x84C0
GL_TEXTURE_2D                     EQU   0x0DE1
GL_TRIANGLES                      EQU   0x0004
GL_FLOAT                          EQU   0x1406


               




