//
//  GamePiece.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GamePiece.h"

#define PI 3.160484

@implementation GamePiece

@synthesize transparency;
@synthesize xCell;
@synthesize yCell;
@synthesize type;
@synthesize correctCell;
@synthesize tagAsFingerMovement;

-(id) initGamePiece: (id<GamePieceTarget>) _animationTarget type:(int)_type xCell:(int)_xCell yCell:(int)_yCell {
	self = [super init];

	animationTarget = _animationTarget;
	correctCell = false;
	transparency = 1.0;
	xCell = _xCell;
	yCell = _yCell;
	[self setCenterPositionToCell];
	rotateDegree = 0;
	animateState = kAnimationNone;
	tagAsFingerMovement = false;
	
	// Set the game piece type. If empty then randomly set it.
	type = _type;
	if (type == kGameCellDiceEmpty)
		type = rand() % 5 + 1;			
	
	// Set the texture id.
	switch(type) {
		case kGameCellDiceEmpty:
			textureId = TEXTURE_GAME_SOLIDBLACK;
			break;
		case kGameCellDie1:
			textureId = TEXTURE_GAME_PIECE1;
			break;
		case kGameCellDie2:
			textureId = TEXTURE_GAME_PIECE2;
			break;
		case kGameCellDie3:
			textureId = TEXTURE_GAME_PIECE3;
			break;
		case kGameCellDie4:
			textureId = TEXTURE_GAME_PIECE4;
			break;
		case kGameCellDie5:
			textureId = TEXTURE_GAME_PIECE5;
			break;
		case kGameCellDie6:
			textureId = TEXTURE_GAME_PIECE6;
			break;
	}
	
	animateStill = [[[AnimationVariable alloc] initAnimation:0.0 toValue:8.0 step:0.2 forever:true] retain];
	
	[self autorelease];	
	return self;
}

- (void)dealloc {
	[animateStill release];
	[super dealloc];
}

-(void) draw {
	// Piece is animated growing.
	if (animateState == kAnimationGrow) {
		glColor4f(1.0, 1.0, 1.0, 1.0);
		float pieceSize = kGamePieceSize * growSize;
		CGRect grow = CGRectMake(xCenterPosition - pieceSize/2, yCenterPosition - pieceSize/2, pieceSize, pieceSize);
		[[textureManager texture:textureId] drawInRect:&grow];		
		
	} else {
		float pieceSize = kGamePieceSize - [animateStill value];
		glColor4f(1.0, 1.0, 1.0, transparency);
		CGPoint pt = CGPointMake(xCenterPosition, yCenterPosition);
		[[textureManager texture:textureId] drawAtPoint:pt rotate:rotateDegree width:pieceSize height:pieceSize];
	}
}

-(void) update {
	[animateStill update];
	
	if (animateState == kAnimationRotate360) {
		rotateDegree += kAnimationRotateDegreeStep;
		rotationStep += kAnimationRotateDegreeStep;
		if (rotationStep >= 360)
			animateState = kAnimationNone;
	} else if (animateState == kAnimationGrow) {
		growSize += kAnimationGrowStep;
		if (growSize >= 1.0)
			animateState = kAnimationNone;
	} else if (animateState == kAnimationMovementXPos) {
		xCenterPosition += kAnimationMovementStep;
		if (xCenterPosition >= xMovementTo) {
			animateState = kAnimationNone;
			xCell = xCellTo;
			yCell = yCellTo;
			[self setCenterPositionToCell];
			[animationTarget notifyDoneAnimationMovement:self];
		}
		
		// Rotate.
		if (animateClockwise)
			rotateDegree += kAnimationRotateMovement;
		else
			rotateDegree -= kAnimationRotateMovement;
	
	} else if (animateState == kAnimationMovementXNeg) {
		xCenterPosition -= kAnimationMovementStep;
		if (xCenterPosition <= xMovementTo) {
			animateState = kAnimationNone;
			xCell = xCellTo;
			yCell = yCellTo;
			[self setCenterPositionToCell];
			[animationTarget notifyDoneAnimationMovement:self];
		}
		
		// Rotate.
		if (animateClockwise)
			rotateDegree += kAnimationRotateMovement;
		else
			rotateDegree -= kAnimationRotateMovement;
		
	} else if (animateState == kAnimationMovementYPos) {
		yCenterPosition += kAnimationMovementStep;
		if (yCenterPosition >= yMovementTo) {
			animateState = kAnimationNone;
			xCell = xCellTo;
			yCell = yCellTo;
			[self setCenterPositionToCell];
			[animationTarget notifyDoneAnimationMovement:self];
		}
		
		// Rotate.
		if (animateClockwise)
			rotateDegree += kAnimationRotateMovement;
		else
			rotateDegree -= kAnimationRotateMovement;
		
	} else if (animateState == kAnimationMovementYNeg) {
		yCenterPosition -= kAnimationMovementStep;
		if (yCenterPosition <= yMovementTo) {
			animateState = kAnimationNone;
			xCell = xCellTo;
			yCell = yCellTo;
			[self setCenterPositionToCell];
			[animationTarget notifyDoneAnimationMovement:self];
		}
		
		// Rotate.
		if (animateClockwise)
			rotateDegree += kAnimationRotateMovement;
		else
			rotateDegree -= kAnimationRotateMovement;
		
	}
}

-(void) doAnimate360rotate {
	animateState = kAnimationRotate360;
	rotationStep = 0;
}

-(void) doAnimateGrow {
	animateState = kAnimationGrow;
	growSize = 0.0;
}

-(void) doAnimateMovement: (int) animateMovement animateClockwise:(bool)_animateClockwise{
	animateClockwise = _animateClockwise;
	animateState = animateMovement;
	xCellTo = xCell;
	yCellTo = yCell;
	
	if (animateState == kAnimationMovementXPos) {
		xCellTo = xCell + 1;
	} else if (animateState == kAnimationMovementXNeg) {
		xCellTo = xCell - 1;
	} else if (animateState == kAnimationMovementYPos) {
		yCellTo = yCell + 1;
	} else if (animateState == kAnimationMovementYNeg) {
		yCellTo = yCell - 1;
	}
	
	// Set the movement to positions.
	CGPoint ptTo;
	[GamePiece cellToCenterPosition:xCellTo yCell:yCellTo ptOut:&ptTo];	
	xMovementTo = ptTo.x;
	yMovementTo = ptTo.y;
	
	// Reset transparency and on correct cell.
	transparency = 1.0;
	correctCell = false;
}

- (bool) isCell: (int)_xCell yCell:(int)_yCell {
	if (xCell == _xCell && yCell == _yCell)
		return true;
	return false;
}

-(bool) isMoving {
	if (animateState == kAnimationMovementYNeg || animateState == kAnimationMovementYPos || animateState == kAnimationMovementXPos || animateState == kAnimationMovementXNeg)
		return true;
	return false;
}

-(void) createParticleEffect: (ParticleEngine *)particleEngine {	
	// Set position.
	CGPoint currPt = CGPointMake(xCenterPosition, yCenterPosition);
	
	// Create a circular effect.
	float radianStep = 0.017453 * 36; // 10 degrees.
	for (float radian=0.0; radian < PI * 2; radian += radianStep) {
		int particleId = [particleEngine startParticle:kParticleTypeStraight textureId:TEXTURE_PARTICLE_1 ptStart:currPt]; 
		
		// Set the vector.
		CGPoint vector;
		vector.x = cos(radian) * 3;
		vector.y = sin(radian) * 3;
		[particleEngine setVector:particleId vector:vector];
		
		// Set rotation speed.
		[particleEngine setRotationSpeed:particleId rotationSpeed:15];
		
		// Set life span.
		[particleEngine setLifeSpan:particleId lifespan:0.7];
		
		// Set the color.
		switch (type) {
			case kGameCellDie1:
				[particleEngine setColor:particleId red:1.0 green:0.184 blue:0.184 transparency:0.3];
				break;
			case kGameCellDie2:
				[particleEngine setColor:particleId red:1.0 green:1.0 blue:0.38 transparency:0.3];
				break;
			case kGameCellDie3:
				[particleEngine setColor:particleId red:0.0 green:1.0 blue:0.0 transparency:0.3];
				break;
			case kGameCellDie4:
				[particleEngine setColor:particleId red:0.396 green:0.882 blue:0.882 transparency:0.3];
				break;
			case kGameCellDie5:
				[particleEngine setColor:particleId red:1.0 green:0.5 blue:1.0 transparency:0.3];
				break;
			case kGameCellDie6:
				[particleEngine setColor:particleId red:0.124 green:0.412 blue:1.0 transparency:0.3];
				break;
		}
	}	
}

-(void) playSound {
	int soundId;
	switch (type) {
		case kGameCellDie1:
			soundId = SOUND_GAME_PIECE1;
			break;
		case kGameCellDie2:
			soundId = SOUND_GAME_PIECE2;
			break;
		case kGameCellDie3:
			soundId = SOUND_GAME_PIECE3;
			break;
		case kGameCellDie4:
			soundId = SOUND_GAME_PIECE4;
			break;
		case kGameCellDie5:
			soundId = SOUND_GAME_PIECE5;
			break;
		case kGameCellDie6:
			soundId = SOUND_GAME_PIECE6;
			break;
	}
	[soundManager playsound:soundId];
}

- (void) setCenterPositionToCell {
	xCenterPosition = xCell * kGamePieceSize + kGamePieceSize / 2;
	yCenterPosition = 32 + yCell * kGamePieceSize + kGamePieceSize / 2;
}

-(void) toParticleSwirl: (ParticleEngine *)particleEngine {
	CGPoint position = CGPointMake(xCenterPosition, yCenterPosition);
	int particleId = [particleEngine startParticle:kParticleTypeSwirlIn textureId:textureId ptStart:position];
	if (particleId < 0)
		return;
	
	[particleEngine setRadius:particleId radiusStep:8.0 degreeStep:15 x_center:160 y_center:224];
	[particleEngine setLifeSpan:particleId lifespan:100];		
	[particleEngine setColor:particleId red:1.0 green:1.0 blue:1.0 transparency:1.0];
}

-(void) setGlColor: (float)_transparency {
	switch (type) {
		case kGameCellDie1:
			glColor4f(1.0, 0.184, 0.184, _transparency);
			break;
		case kGameCellDie2:
			glColor4f(1.0, 1.0, 0.38, _transparency);
			break;
		case kGameCellDie3:
			glColor4f(0.0, 1.0, 0.0, _transparency);
			break;
		case kGameCellDie4:
			glColor4f(0.396, 0.882, 0.882, _transparency);
			break;
		case kGameCellDie5:
			glColor4f(1.0, 0.5, 1.0, _transparency);
			break;
		case kGameCellDie6:
			glColor4f(0.124, 0.412, 1.0, _transparency);
			break;
	}
}

-(void) setTextureType: (int)textureType {
	// Do nothing for empty textures.
	if (type == 0)
		return;
	
	// Calculate the texture id mathematically.
	// @param textureType 1: Buttons, 2: Ninja cogs, 3: Bling.
	int textureOffset = 1;
	if (textureType == 1) // buttons.
		textureOffset = 2;
	else if (textureType == 2) // Ninja cogs.
		textureOffset = 126;
	else if (textureType == 3) // Bling.
		textureOffset = 120;

	textureId = textureOffset + type - 1;
}

- (void)saveSettings: (int)index {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *keyType = [NSString stringWithFormat:@"key_pieces_%d_type", index];
	NSString *keyX = [NSString stringWithFormat:@"key_pieces_%d_x", index];
	NSString *keyY = [NSString stringWithFormat:@"key_pieces_%d_y", index];
	
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:type]] forKey:keyType];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:xCell]] forKey:keyX];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:yCell]] forKey:keyY];
}

- (void)loveSettings: (int)index textureType:(int)textureType {
	
	// The save settings must be called first, or else this will not make much sense.
	NSString *keyType = [NSString stringWithFormat:@"key_pieces_%d_type", index];
	NSString *keyX = [NSString stringWithFormat:@"key_pieces_%d_x", index];
	NSString *keyY = [NSString stringWithFormat:@"key_pieces_%d_y", index];
	
	// Create the dictionary with default values.
	NSMutableDictionary *resourceDict = [[NSMutableDictionary dictionaryWithCapacity:0] init];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:keyType];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:keyX];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:keyY];
	
	// Register the defaults if they don't exist.
	[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	type = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:keyType]] intValue]; 	
	xCell = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:keyX]] intValue]; 	 
	yCell = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:keyY]] intValue]; 	 	
	
	[self setTextureType:textureType];
	[self setCenterPositionToCell];
}
		
+ (void) cellToCenterPosition: (int)_xCell yCell:(int)_yCell ptOut:(CGPoint *)ptOut {
	ptOut->x = _xCell * kGamePieceSize + kGamePieceSize / 2;
	ptOut->y = 32 + _yCell * kGamePieceSize + kGamePieceSize / 2;
}

@end
