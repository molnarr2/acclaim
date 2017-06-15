//
//  GamePiece.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundManager.h"
#import "TextureManager.h"
#import "ParticleEngine.h"
#import "AnimationVariable.h"

// Game piece types.
#define kGameCellDiceEmpty 0
#define kGameCellDie1 1
#define kGameCellDie2 2
#define kGameCellDie3 3
#define kGameCellDie4 4
#define kGameCellDie5 5
#define kGameCellDie6 6

// Animation used for the GameCell.
#define kAnimationNone 1
#define kAnimationRotate360 2
#define kAnimationGrow 3
#define kAnimationMovementXPos 4
#define kAnimationMovementXNeg 5
#define kAnimationMovementYPos 6
#define kAnimationMovementYNeg 7

// This is the animation degree rotation step for movement.
#define kAnimationRotateMovement 10
// This is the animation degree rotation step for correct.
#define kAnimationRotateDegreeStep 10
// This is the animation step for growing the piece.
#define kAnimationGrowStep 0.05
// This is the movement step for moving pieces.
#define kAnimationMovementStep 10.0

// Size of each game piece.
#define kGamePieceSize 64 

@class GamePiece;

// Used to notify another class that animation is done.
@protocol GamePieceTarget

// Called to notify another class that this game piece has ended movement.
-(void) notifyDoneAnimationMovement: (GamePiece *)piece;

@end


@interface GamePiece : NSObject {
	int type; // kGameCellDie type.
	int xCell, yCell; // The positions within the game board.
	float xCenterPosition, yCenterPosition; // The position within the view a.k.a. pixels of the view. This is the center position of the piece.
	int textureId; // Current texture id to draw.
	float rotateDegree; // This is the current rotation degree.
	bool correctCell; // True if on a correct cell.
	bool tagAsFingerMovement; // True if this is a game piece the finger is directly moving.
	
	// Used to animate the game piece.
	id<GamePieceTarget> animationTarget;
	float growSize;
    float rotationStep;
	int animateState;
	float xMovementTo;
	float yMovementTo;
	int xCellTo;
	int yCellTo;
	bool animateClockwise;
	
	// This is the transparency level for the item.
	float transparency;
	
	AnimationVariable *animateStill;
}

@property(readwrite) float transparency;
@property(readonly) int xCell;
@property(readonly) int yCell;
@property(readonly) int type;
@property(readwrite) bool correctCell;
@property(readwrite) bool tagAsFingerMovement;

// Create the game piece.
// @param type is the kGameCellDie type.
-(id) initGamePiece: (id<GamePieceTarget>)_animationTarget type:(int)_type xCell:(int)_xCell yCell:(int)_yCell;

// Called when shutting down.
- (void)dealloc;

// Draw the game piece.
-(void) draw;

// Used to update interval variables per frame.
-(void) update;

// This will perform a 360 rotatation of the game piece.
-(void) doAnimate360rotate;

// This will grow the game piece from zero to size of game piece.
-(void) doAnimateGrow;

// This will move the game piece. Use kAnimationMovement* to move the piece.
-(void) doAnimateMovement: (int) animateMovement animateClockwise:(bool)_animateClockwise;

// This will update the xCenterPosition, yCenterPosition to the xCell, yCell center position of that cell.
-(void) setCenterPositionToCell;

// @return true if this cell matches the _xCell, _yCell values.
-(bool) isCell: (int)_xCell yCell:(int)_yCell;

// @return true if piece is currently in movement.
-(bool) isMoving;

// This will create a particle effect at the center of this piece.
-(void) createParticleEffect: (ParticleEngine *)particleEngine;

// This will play the sound of this piece.
-(void) playSound;

// This will create a particle as a swirl to the center of the game board.
-(void) toParticleSwirl: (ParticleEngine *)particleEngine;

// This will call the glColorf() with the color of the game piece and the paramete transparency.
-(void) setGlColor: (float)_transparency;

// This will set the texture type being used for the game piece.
// @param textureType 1: Buttons, 2: Ninja cogs, 3: Bling.
-(void) setTextureType: (int)textureType;

// @param index is the index into the GameMap array of each piece.
- (void)saveSettings: (int)index;
- (void)loveSettings: (int)index textureType:(int)textureType;

// This will convert a cell's position on the game board to x,y center position of that cell.
// @param _xCell is the game board x position.
// @param _yCell is the game board y position.
// @param ptOut is the x,y center posiiton of that cell.
+(void) cellToCenterPosition: (int)_xCell yCell:(int)_yCell ptOut:(CGPoint *)ptOut;

@end
