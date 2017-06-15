//
//  ParticleEngine.m
//  Finger
//
//  Created by Robert Molnar 2 on 11/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ParticleEngine.h"

#define kParticleDead 0
#define kParticleAlive 1
#define kMaxVelocity 25.0

@implementation ParticleEngine

/** Initalize the ParticleEngine.
 * @param maxParticles is the number of max particles the engine can handle.
 */
-(id) initParticleEngine: (int)_maxParticles {
	self = [super init];
	maxParticles = _maxParticles;
	
	// Clear the particles array.
	particles = malloc(sizeof(Particle) * _maxParticles);
	memset(particles, 0x00, sizeof(Particle) * _maxParticles);		
	
	float radian;
	for (int i=0; i < 360; i++) {
		radian = (float)i * 3.1415926 / 180.0; 
		arrDegrees[i].x = cos(radian);
		arrDegrees[i].y = sin(radian);
	}
	
	aliveParticles=0;
	
	[self autorelease];	
	return self;	
}

-(void)dealloc {
	free(particles);
	[super dealloc];
}

-(int) startParticle: (int)typeOfParticle textureId:(int)textureId ptStart:(CGPoint)ptStart {
	int indexFree = [self _getFreeParticle];
	if (indexFree == -1)
		return -1;
	
	memset((void *)&particles[indexFree], 0x00, sizeof (Particle));
	particles[indexFree].state = kParticleAlive;
	particles[indexFree].type = typeOfParticle;
	particles[indexFree].textureId = textureId;	
	particles[indexFree].x = ptStart.x;
	particles[indexFree].y = ptStart.y;
	particles[indexFree].transparency = 1.0;
	particles[indexFree].lifeBegan = CFAbsoluteTimeGetCurrent();
	particles[indexFree].lifeSpan = 3.0;
	aliveParticles++;
	
	return indexFree;
}

-(void) setColor: (int)particleId red:(float)red green:(float)green blue:(float)blue {
	particles[particleId].red = red;
	particles[particleId].blue = blue;
	particles[particleId].green = green;	
}

-(void) setColor: (int)particleId red:(float)red green:(float)green blue:(float)blue transparency: (float) transparency {
	particles[particleId].red = red;
	particles[particleId].blue = blue;
	particles[particleId].green = green;	
	particles[particleId].transparency = transparency;
}

-(void) setLifeSpan: (int)particleId lifespan:(double)lifeSpan {
	particles[particleId].lifeSpan = lifeSpan;	
}

-(void) setAcceleration: (int)particleId acceleration:(float)acceleration {
	particles[particleId].xa_step = particles[particleId].x_normal * acceleration;
	particles[particleId].ya_step = particles[particleId].y_normal * acceleration;
}

-(void) setVector: (int)particleId vector:(CGPoint) vector {
	particles[particleId].xv = vector.x;
	particles[particleId].yv = vector.y;
	
	// Normalized vector.
	if (vector.x != 0.0 || vector.y != 0.0) {
		float h = sqrt(vector.x * vector.x + vector.y * vector.y);
		particles[particleId].x_normal = particles[particleId].xv / h;
		particles[particleId].y_normal = particles[particleId].yv / h;
	}
}

-(void) setRotationSpeed: (int)particleId rotationSpeed:(float)rotationSpeed {
	particles[particleId].rotable = TRUE;
	particles[particleId].rotateStep = rotationSpeed;
	particles[particleId].rotation = 0.0;
}

-(void) setiPhoneGravity: (int)particleId multiplier:(float)multiplier {
	particles[particleId].gravity = TRUE;
	particles[particleId].gravityMultiplier = multiplier;
}

-(void)setStep: (int) particleId stepRate:(float)stepRate {
	particles[particleId].stepRate = stepRate;
}

-(void) draw {
	CGPoint pt;  
	
	for (int i=0; i < maxParticles; i++) {
		if (particles[i].state == kParticleDead)
			continue;
	
		glColor4f(particles[i].red, particles[i].green, particles[i].blue, particles[i].transparency);
		pt.x = particles[i].x;
		pt.y = particles[i].y;
		[[textureManager texture:particles[i].textureId] drawAtPoint:pt rotate:particles[i].rotation];
	}		
}

-(void) update {
	Particle *particle;
	double time = CFAbsoluteTimeGetCurrent();
	double livingSeconds;
	float xVelocity, yVelocity, xForce, yForce, ratio;	
	int step;
	
	for (int i=0; i < maxParticles; i++) {
		particle = &particles[i];	
		if (particle->state == kParticleDead)
			continue;
		
		// Kill the particle? //////////////////////////////////////////////////////////////////////////////////////////////
		
		// No bounce and at end of screen then remove.
		if (!particle->bounce && particle->type != kParticleTypeSwirlIn) {
			if (particle->x > 320.0 || particle->x < 0.0)
				particle->state = kParticleDead;
			if (particle->y > 480.0 || particle->y < 0.0)
				particle->state = kParticleDead;
		}
		
		// Does the particle die?
		livingSeconds = (time - particle->lifeBegan);
		if (livingSeconds > particle->lifeSpan)
			particle->state = kParticleDead;
		
		// Particle just died.
		if (particle->state == kParticleDead) {
			aliveParticles--;
			continue;			
		}
		
		// END Kill the particle?  ////////////////////////////////////////////////////////////////////////////////////////
		
		// Physics of the particle ////////////////////////////////////////////////////////////////////////////////////////
		
		// Calculate the force.
		xForce = yForce = 0.0;
		
		// Apply gravity force.
		if (particle->gravity) {			
			xForce += particle->gravityMultiplier * globalAccelerometer[0] * livingSeconds;
			yForce += particle->gravityMultiplier * -globalAccelerometer[1] * livingSeconds;		
		}
		
		// If bounce is enabled and reached end of screen then change initial velocity and acceleration to opposite direction.
		if (particle->bounce) {
			if (particle->x > 320.0) {
				particle->x = 320.0;
				if (particle->xv > 0)
					particle->xv *= -1;
				if (particle->xa_step > 0) {
					particle->xa_step *= -1;
					particle->xa *= -1;
				}
			}
			if (particle->x < 0.0) {
				particle->x = 0.0;
				if (particle->xv < 0)
					particle->xv *= -1;
				if (particle->xa_step < 0) {
					particle->xa_step *= -1;
					particle->xa *= -1;
				}
			}
			if (particle->y > 480.0) {
				particle->y = 480.0;
				if (particle->yv > 0) 
					particle->yv *= -1;
				if (particle->ya_step > 0) {
					particle->ya_step *= -1;
					particle->ya *= -1;
				}
			}
			if (particle->y < 0.0) {
				particle->y = 0.0;
				if (particle->yv < 0)
					particle->yv *= -1;
				if (particle->ya_step < 0) {
					particle->ya_step *= -1;
					particle->ya *= -1;
				}
			}
		}
		
		// Apply internal force for the object.
		particle->xa += particle->xa_step;
		particle->ya += particle->ya_step;
		xForce += particle->xa;
		yForce += particle->ya;
		
		// Apply special forces.
		if (particle->type == kParticleTypeCircleOut) {
			step = particle->step - 90;
			if (step < 0)
				step += 359;
			
			xForce += arrDegrees[step].x * 9;
			yForce += arrDegrees[step].y * 9;
			
			particle->step += particle->stepRate;
			if (particle->step >= 360)
				particle->step -= 360;
			
		} else if (particle->type == kParticleTypeTornado) {
			step = particle->step - 90;
			if (step < 0)
				step += 359;
			
			xForce += arrDegrees[step].x * particle->xa*3;
			yForce += arrDegrees[step].y * particle->ya*1;
			
			particle->step += particle->stepRate;
			if (particle->step >= 360)
				particle->step -= 360;			
		} else if (particle->type == kParticleTypeSinewave) {
			step = particle->step - 90;
			if (step < 0)
				step += 359;
			
			xForce += arrDegrees[step].x * livingSeconds * 7;
			yForce += arrDegrees[step].y;
			
			particle->step += particle->stepRate;
			if (particle->step >= 360)
				particle->step -= 360;			
		}
		
		// Now set the velocity based on initial velocity and current acceleration.
		xVelocity = particle->xv + xForce;
		yVelocity = particle->yv + yForce;
		
		// Limit the speed of the particle.
		if (xVelocity > kMaxVelocity) {
			ratio = kMaxVelocity / xVelocity;
			xVelocity = kMaxVelocity;
			yVelocity *= ratio;
		} else if (xVelocity < -kMaxVelocity) {
			ratio = -kMaxVelocity / xVelocity;
			xVelocity = -kMaxVelocity;
			yVelocity *= ratio;
		}
		
		// Limit the speed of the particle.
		if (yVelocity > kMaxVelocity) {
			ratio = kMaxVelocity / yVelocity;
			yVelocity = kMaxVelocity;
			xVelocity *= ratio;
		} else if (yVelocity < -kMaxVelocity) {
			ratio = -kMaxVelocity / yVelocity;
			yVelocity = -kMaxVelocity;
			xVelocity *= ratio;
		}
		
		// Particle updating.
		particle->x += xVelocity;
		particle->y += yVelocity;

		// These particle effects do not use the forces physics.
		if (particle->type == kParticleTypeSwirlIn) {
			particle->radius -= particle->radiusStep;
			if (particle->radius <= 0.0) {
				aliveParticles--;
				particle->state = kParticleDead;
			}
			particle->degree += particle->degreeStep;
			if (particle->degree >= 360)
				particle->degree -= 360;
				
			particle->x = particle->x_center + arrDegrees[particle->degree].x * particle->radius;
			particle->y = particle->y_center + arrDegrees[particle->degree].y * particle->radius;
		}
		
		// END Physics of the particle /////////////////////////////////////////////////////////////////////////////////////
		
		// Rotate the particle texture /////////////////////////////////////////////////////////////////////////////////////

		// Update the rotation of the particle.
		if (particle->rotable) {
			particle->rotation += particle->rotateStep;
			if (particle->rotation >= 360.0)
				particle->rotation = 0.0;
		}

		// END Rotate the particle /////////////////////////////////////////////////////////////////////////////////////////
	}
}

-(int)_getFreeParticle {
	int indexFree = -1;
	for (int i=0; i < maxParticles; i++) {
		if (particles[i].state == kParticleDead) {
			indexFree = i;
			break;
		}
	}
	return indexFree;
}

-(void) enableBounce: (int)particleId {
	particles[particleId].bounce = 1;
}

-(void)setRadius: (int) particleId radiusStep:(float)radiusStep degreeStep:(float)degreeStep x_center:(float)x_center y_center:(float)y_center {
	particles[particleId].radiusStep = radiusStep;
	particles[particleId].degreeStep = degreeStep;
	particles[particleId].x_center = x_center;
	particles[particleId].y_center = y_center;
	
	float xDelta = particles[particleId].x - particles[particleId].x_center;
	float yDelta = particles[particleId].y - particles[particleId].y_center;

	particles[particleId].radius = sqrt(xDelta * xDelta + yDelta * yDelta);

	if (xDelta == 0.0) {
		if (yDelta > 0.0)
			particles[particleId].degree = 90;
		else
			particles[particleId].degree = 270;
	} else {
	
		float radian = atan(yDelta / xDelta);
		if (xDelta < 0.0)
			radian += 3.1416;
		radian = radian * 180 / 3.14159;
		
		particles[particleId].degree = radian;
		if (particles[particleId].degree > 360)
			particles[particleId].degree -= 360;
		else if (particles[particleId].degree < 0)
			particles[particleId].degree += 360;
	}
}

-(int) aliveParticles {
	return aliveParticles;
}

@end
