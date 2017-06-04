





fo( BULLET_AMOUNT ){
			if( !bullet[i].getState() ) continue;
			bullet[i].move();
			foj( ENEMY_AMOUNT ){
				if( enemy[j].Damege( bullet[i].getPosition() , bullet[i].ad() ) > -1 ) {
					bullet[i].dead();
					if( !enemy[j].blood() ){
						vec3 location(rand()%300+20,rand()%10+10,rand()%300-300);
						float fix = terrain.moveCollision(location,vec3(0,0,0) );
						enemy[j].move( vec3(location.x,fix,location.z) );
						enemy[j].set_blood( 500 );
					}
				}
			}
		}


		#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtx/euler_angles.hpp>
using namespace std;
using namespace glm;
#define pb push_back
#define MAX_depth 4
 
 
struct OcNode{
 
    vector<vec3> vecs;
    float xl , xr , yl , yr , zl , zr;
    OcNode *oct0 , *oct1 , *oct2 , *oct3 , *oct4 , *oct5 , *oct6 , *oct7;
 
    OcNode(){ oct0 = oct1 = oct2 = oct3 = oct4 = oct5 = oct6 = oct7 = NULL; }
};
 
OcNode* build( int dep ){
    OcNode *node = new OcNode();
    if( dep == MAX_depth ) return node;
    node->oct0 = build( dep + 1 );
    node->oct1 = build( dep + 1 );
    node->oct2 = build( dep + 1 );
    node->oct3 = build( dep + 1 );
    node->oct4 = build( dep + 1 );
    node->oct5 = build( dep + 1 );
    node->oct6 = build( dep + 1 );
    node->oct7 = build( dep + 1 );
    return node;
}
 
void oct_insert( OcNode* node , vec3 v , float xl , float xr , float yl , float yr , float zl , float zr , int dep ){
    if( dep == MAX_depth ) {
        node->vecs.pb( v );
        return;
    }
    float midx = ( xl + xr ) / 2. , midy = ( yl + yr ) / 2. , midz = ( zl + zr ) / 2.;
    if( v.x < midx )
        if( v.y < midy )
            if( v.z < midz ) oct_insert( node->oct0 , v , xl , midx , yl , midy , zl , midz , dep + 1 );
            else             oct_insert( node->oct1 , v , xl , midx , yl , midy , midz , zr , dep + 1 );
        else
            if( v.z < midz ) oct_insert( node->oct2 , v , xl , midx , midy , yr , zl , midz , dep + 1 );
            else             oct_insert( node->oct3 , v , xl , midx , midy , yr , midz , zr , dep + 1 );
    else
        if( v.y < midy )
            if( v.z < midz ) oct_insert( node->oct4 , v , midx , xr , yl , midy , zl , midz , dep + 1 );
            else             oct_insert( node->oct5 , v , midx , xr , yl , midy , midz , zr , dep + 1 );
        else
            if( v.z < midz ) oct_insert( node->oct6 , v , midx , xr , midy , yr , zl , midz , dep + 1 );
            else             oct_insert( node->oct7 , v , midx , xr , midy , yr , midz , zr , dep + 1 );
    return;
}
 
void oct_insert2( OcNode* node , float xl , float xr , float yl , float yr , float zl , float zr , int dep ){
    if( dep == MAX_depth ) {
        node->xl = xl , node->xr = xr , node->yl = yl , node->yr = yr , node->zl = zl , node->zr = zr;
        return;
    }
    float midx = ( xl + xr ) / 2. , midy = ( yl + yr ) / 2. , midz = ( zl + zr ) / 2.;
    oct_insert2( node->oct0 , xl , midx , yl , midy , zl , midz , dep + 1 );
    oct_insert2( node->oct1 , xl , midx , yl , midy , midz , zr , dep + 1 );
    oct_insert2( node->oct2 , xl , midx , midy , yr , zl , midz , dep + 1 );
    oct_insert2( node->oct3 , xl , midx , midy , yr , midz , zr , dep + 1 );
    oct_insert2( node->oct4 , midx , xr , yl , midy , zl , midz , dep + 1 );
    oct_insert2( node->oct5 , midx , xr , yl , midy , midz , zr , dep + 1 );
    oct_insert2( node->oct6 , midx , xr , midy , yr , zl , midz , dep + 1 );
    oct_insert2( node->oct7 , midx , xr , midy , yr , midz , zr , dep + 1 );
    return;
}
 
 
void oct_print( OcNode* node , int max){
    if( !node->oct0 ) {
        printf( "OcTree Node ( %f - %f , %f - %f , %f - %f )\n" , node->xl , node->xr , node->yl , node->yr , node->zl , node->zr );
        int i = 0;
        for( auto v : node->vecs ){
            if( i++ == max ) break;
            printf( "( %f , %f , %f )\n" , v.x , v.y , v.z );
        }
        return;
    }
    oct_print( node->oct0 , max );
    oct_print( node->oct1 , max );
    oct_print( node->oct2 , max );
    oct_print( node->oct3 , max );
    oct_print( node->oct4 , max );
    oct_print( node->oct5 , max );
    oct_print( node->oct6 , max );
    oct_print( node->oct7 , max );
}
 
 
 
void octree( vector<vec3> vecs ){
 
    float XL = -1500.0 , XR = 1500.0 , YL = -1500.0 , YR = 1500.0 , ZL = -1500.0 , ZR = 1500.0;
 
    OcNode* root = build( 0 );
 
    for( auto v : vecs ) oct_insert( root , v , XL , XR , YL , YR , ZL , ZR , 0 );
 
 
}
 
int debug(){
    vector<vec3> vecs;
    vecs.pb( vec3(1500,-1,-878) );
 
    float XL = -1500.0 , XR = 1500.0 , YL = -1500.0 , YR = 1500.0 , ZL = -1500.0 , ZR = 1500.0;
    OcNode* root = build( 0 );
    oct_insert2( root ,  XL , XR , YL , YR , ZL , ZR , 0 );
 
    for( auto v : vecs ) oct_insert( root , v , XL , XR , YL , YR , ZL , ZR , 0 );
 
    oct_print( root , 10 );
 
    return 0;
}