#include "include/configure.h"

// Include standard headers
#include <stdio.h>
#include <stdlib.h>
#include <vector>

// Include GLEW
#include <GL/glew.h>

// Include GLFW
#include <GLFW/glfw3.h>
GLFWwindow* window;

// Include GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtx/euler_angles.hpp>

using namespace glm;

#include "include/shader.hpp"  // for LoadShader 
#include "include/texture.hpp" // for Texture
#include "include/controls.hpp"  // for Controller
#include "include/objloader.hpp" // for loadOBJ

// ##############################  Q啥的不會用到

template<typename X> inline X sqr(const X& a) {return a * a;}

GLuint TextureID;
GLuint MatrixID;
GLuint programID;

#include "Object.cpp"
#include "Enemy.cpp"
#include "Equipment.cpp"

// ##############################  
#include "Weapon.cpp"

Enemy enemy[ENEMY_AMOUNT];
Weapon bullet[BULLET_AMOUNT];
int now_bullet = 0;

// ##############################  

int main( void )
{
	// Initialise GLFW
	glfwInit();
	glfwWindowHint(GLFW_SAMPLES, 4);  // 4x antialising, it's mean you have 4 samples in each pixel.
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3); 	// Using OpenGL3.3
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE); // To make MacOS happy; should not be needed
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);


	// Open a window and create its OpenGL context
	window = glfwCreateWindow( WINDOW_WIDTH, WINDOW_HEIGHT, "Mao OpenGL SUCCESS!!!", NULL, NULL);
	glfwMakeContextCurrent(window);


	// Initialize GLEW
    glewExperimental = true; //glewExperimental does is allow extension entry points to be loaded even if the extension isn't present in the driver's extensions string.
	glewInit();
	

    // Controller Setting
	glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);// Ensure we can capture the escape key being pressed below
    glfwPollEvents();   // Check whether any Event be triggered


    glfwSetCursorPos(window, WINDOW_WIDTH/2, WINDOW_HEIGHT/2); // Set the mouse at the center of the screen
	// Dark blue background
	glClearColor(0.0f, 0.0f, 0.4f, 0.0f);



	// Enable depth test
    // Note that : GL_DEPTH_BUFFER_BIT must to be cleared !!! 
	glEnable(GL_DEPTH_TEST); // Accept fragment if it closer to the camera than the former one
	glDepthFunc(GL_LESS); 

    // Cull triangles which normal is not towards the camera
	glEnable(GL_CULL_FACE);

	// Get a VertexArray
	GLuint VertexArrayID;
	glGenVertexArrays(1, &VertexArrayID);
	glBindVertexArray(VertexArrayID);

	//  Notice that just as buffers, shaders are not directly accessible : we just have an ID. The actual implementation is hidden inside the driver.
	programID = LoadShaders( "TransformVertexShader.vertexshader", "TextureFragmentShader.fragmentshader" );

	// Get a handle for our "MVP" uniform
	MatrixID = glGetUniformLocation(programID, "MVP");
	TextureID  = glGetUniformLocation(programID, "myTextureSampler");

	Object terrain;
	terrain.init("res/land.obj" ,"res/land.dds");

	Object skybox;
	skybox.init("res/skybox.obj", "res/skybox.dds");


// ###########  增加槍 ###################  
	Equipment gun;
	gun.init("res/gun.obj", "res/gun.dds");
	gun.move(glm::vec3(60.3,14.69,-59.9));
	gun.setDirection(vec3(13.287f,0.0f,-1.61f));
// ######################################  



	for(int i=0;i<20;i++){
		enemy[i].init("res/robot.obj","res/robot.dds");	
		
		// ############ 怪物生成範圍加大，這邊Global一下 ########
		glm::vec3 location(rand()%300+20,rand()%10+10,rand()%300-300);
		// ####################################################  

		float fix = terrain.moveCollision(location,glm::vec3(0,0,0) );
		location = glm::vec3(location.x,fix,location.z);
		enemy[i].move(location);
	}


	
	
	
	
	
	
	Object startMenu;
	startMenu.init("res/start.obj" ,"res/gamestart_none.dds");
	Object learnMode;
	learnMode.init("res/start.obj" ,"res/gamestart_learn.dds");
	Object competMode;
	competMode.init("res/start.obj" ,"res/competMode.dds");

	//glClearColor(0.0f, 0.0f, 0.4f, 0.0f);
    
	do{

		glClear( GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);
		glUseProgram(programID);
		
		glm::mat4 MVP = glm::mat4(1.0);
		glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &MVP[0][0]);


		double xpos, ypos;
		glfwGetCursorPos(window, &xpos, &ypos);
		if(xpos>180 && ypos>300 && xpos<310 && ypos<360){
			learnMode.draw();
			if (glfwGetMouseButton( window, GLFW_MOUSE_BUTTON_LEFT ) == GLFW_PRESS){
				break;
			
			}
		}else if(xpos>925 && ypos>300 && xpos<1245 && ypos<360){
			competMode.draw();
			if (glfwGetMouseButton( window, GLFW_MOUSE_BUTTON_LEFT ) == GLFW_PRESS){
				puts("Not yet");	
			}
		}else{
			startMenu.draw();
		}

		glfwSwapBuffers(window);
		glfwPollEvents();
	
    }while( glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS &&
		   glfwWindowShouldClose(window) == 0 );

startMenu.clearBuffer();
learnMode.clearBuffer();
competMode.clearBuffer();







	glfwSetInputMode(window, GLFW_CURSOR, GLFW_CURSOR_DISABLED); // Hide the mouse and enable unlimited mouvement
    





	// ###### 槍發射的CD ##### 
	double lastTime = glfwGetTime();
	double lastFrameTime = lastTime;
	float cumTime;
	int nbFrames = 0;
	
	bool cd=false;
	// ########################### 
    



	
    do{

		// Measure speed
		double currentTime = glfwGetTime();
		float deltaTime = (float)(currentTime - lastFrameTime); 
		cumTime += deltaTime;
		lastFrameTime = currentTime;
		nbFrames++;
		if ( currentTime - lastTime >= 1.0 ){ // If last prinf() was more than 1sec ago
			// printf and reset
			printf("%f ms/frame\n", 1000.0/double(nbFrames));
			nbFrames = 0;
			lastTime += 1.0;
			// ######## 
			cd = true;
			// ######## 
		}
		
		
		glClear( GL_COLOR_BUFFER_BIT  | GL_DEPTH_BUFFER_BIT);
		glUseProgram(programID);





		glm::vec3 player = getPosition();
		//###################################
		glm::vec3 direction = getDirection();
		//###################################
		glm::vec3 nextStep = getNextStep();




//      發射子彈
//##################################################################
		if (glfwGetMouseButton( window, GLFW_MOUSE_BUTTON_LEFT ) == GLFW_PRESS && cd){
			// puts("SHOOT");
			bullet[now_bullet%BULLET_AMOUNT].init(player,direction);
			now_bullet+=1;
			puts("FIRE");
			cd = false;
		}

		for(int i=0;i<BULLET_AMOUNT;i++){
			if (bullet[i].getState()){
				bullet[i].move();
				for(int j=0;j<ENEMY_AMOUNT;j++){
					glm::vec3 fff = bullet[i].getPosition();
					// printf("%f,%f,%f\n", fff.x,fff.y,fff.z);
					if (enemy[j].isDamage(bullet[i].getPosition())){
						bullet[i].dead();
						puts("YOOOOO");
						glm::vec3 location(rand()%300+20,rand()%10+10,rand()%300-300);
						float fix = terrain.moveCollision(location,glm::vec3(0,0,0) );
						location = glm::vec3(location.x,fix,location.z);
						enemy[j].move(location);
					}
				}
			}
		}

//##################################################################

		float fix_player_height = terrain.moveCollision(player,nextStep);
		bool isCollision = fix_player_height < -1000;
		if(!isCollision)setPositionHeight(fix_player_height+4);
		bool move = computeMatricesFromInputs(isCollision);


		//##########槍瞄準畫面中心###########
		gun.aimAt(player,direction);
		for(int i=0;i<20;i++){
			enemy[i].selfRotate(cumTime);
		}
		//##############################
		

		glm::mat4 MVP = getMVP();
		glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &MVP[0][0]);

		//##################################################################
		//   guns.draw(); 換到上面去 GetMVP下面的是不會動的
		//##################################################################
		terrain.draw();
		skybox.draw();




		glfwSwapBuffers(window);
		glfwPollEvents();
	
    }while( glfwGetKey(window, GLFW_KEY_ESCAPE ) != GLFW_PRESS &&
		   glfwWindowShouldClose(window) == 0 );

	terrain.clearBuffer();
	skybox.clearBuffer();
	for(int i=0;i<20;i++){
		enemy[i].clearBuffer();
	}
	gun.clearBuffer();
	glDeleteVertexArrays(1, &VertexArrayID);
	glDeleteProgram(programID);
	glDeleteTextures(1, &TextureID);
 
	glfwTerminate();

	return 0;
}

