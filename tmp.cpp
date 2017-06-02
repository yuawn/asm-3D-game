





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