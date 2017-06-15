//
//  ParticleEngine.h
//  Finger
//
//  Created by Robert Molnar 2 on 11/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Utilites.h"
#import "Texture2D.h"
#import "TextureManager.h"
#import "Acceleration.h"

#define kParticleTypeStraight 1
#define kParticleTypeTornado 2
#define kParticleTypeSinewave 3
#define kParticleTypeCircleOut 4 
// This will swirl inward to a center point. The setRadius must be called. Also, if the pieces move off the screen they do not
// die. Only when they reach the center point do the die.
#define kParticleTypeSwirlIn 5

#define kParticleColorRed 1
#define kParticleColorBlue 2
#define kParticleColorGreen 3

// Used to represent a Particle.
struct Particle {
	int state;		// state of the particle.
	int type;		// type of particle effect.
	float x, y;		// world position of particle.
	
	float xv, yv; // Current velocity.
	float x_normal, y_normal; // this is the normalized vector.
	
	float xa, ya;	// Current acceleration.
	float xa_step, ya_step; // Step added each frame to acceleration.
	
	float red, green, blue; // the current rending color of the particle.
	double lifeBegan;	// The time the particle began life.
	double lifeSpan;		// This is the number of seconds the particle is alive.
	int textureId;		// This is the id of the texture for this particle.
	
	// For rotation.
	BOOL rotable;	// TRUE; rotate particle.
	float rotateStep;	// The step of the rotate.
	float rotation;	// The current position of the rotation.
	
	// For gravity.
	BOOL gravity;	// TRUE; if gravity is enabled.
	float gravityMultiplier; // The force of the gravity from the cell phone to multiple it against.
	
	float transparency;
	float amplitude; // Used by the sinewave. this is the radius of the sinewave.
	int step; // degree step. (0-359)
	int stepRate; // degree step rate.
	
	// Used for various special effects.
	int radius;     // The radius from the center point.
	int radiusStep; // The value the radius is updated.
	float x_center;	  // The x position used by the radius for the center point.
	float y_center;   // The y position used by the radius for the center point.
	int degree;     // Then radian from the center point.
	int degreeStep; // The step rate of the radian change.
	
	BOOL bounce;	// TRUE if bounce is enabled.
};
typedef struct Particle Particle;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ParticleEngine : NSObject {
	int maxParticles;
	Particle *particles;
	int aliveParticles;
	// With a radius of 1, these are the values for each degree.
	CGPoint arrDegrees[360];
}

/** Initalize the ParticleEngine.
 * @param maxParticles is the number of max particles the engine can handle.
 */
-(id) initParticleEngine: (int)_maxParticles;

// @return the number of particles that are currently alive in the engine.
-(int) aliveParticles;

// This will create the particle with the basic information.
// @param typeOfParticle is the type of particle. kParticleType*.
// @param textureId is the id of the texture to use.
// @param ptStart is the starting position.
// @return the particle that was made, or minus one if not made.
-(int) startParticle: (int)typeOfParticle textureId:(int)textureId ptStart:(CGPoint)ptStart;

// This is the color of the particle.
-(void) setColor: (int)particleId red:(float)red green:(float)green blue:(float)blue;
-(void) setColor: (int)particleId red:(float)red green:(float)green blue:(float)blue transparency: (float) transparency;

// This is the life span of the particle.
-(void) setLifeSpan: (int)particleId lifespan:(double)lifeSpan;

// The acceleration applied each frame. Therefore the value is multipled 30 time per second (ideally).
-(void) setAcceleration: (int)particleId acceleration:(float)acceleration;

// The vector of the direction to go to.
-(void) setVector: (int)particleId vector:(CGPoint) vector;

// @param rotationSpeed in degrees applied per frame.
-(void) setRotationSpeed: (int)particleId rotationSpeed:(float)rotationSpeed;

// This will enable gravity checking by looking at the acceleration of the iPhone that value is then
// multiplied by the multiplier per frame.
-(void) setiPhoneGravity: (int)particleId multiplier:(float)multiplier;

// This will enable bounce.
-(void) enableBounce: (int)particleId;

-(void) draw;

-(void) update;

// @return a free particle index or -1 if not found.
-(int)_getFreeParticle;

// This will set the step rate of the particle used by various particle functions.
-(void)setStep: (int) particleId stepRate:(float)stepRate;

// This will set the radius for varius particle effects.
-(void)setRadius: (int) particleId radiusStep:(float)radiusStep degreeStep:(float)degreeStep x_center:(float)x_center y_center:(float)y_center;

@end

