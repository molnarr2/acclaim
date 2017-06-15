//
//  GameMap.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextureManager.h"
#import "Utilites.h"
#import "TouchPoint.h"
#import "ParticleEngine.h"
#import "SoundManager.h"
#import "Types.h"
#import "GamePiece.h"
#import "CorrectCell.h"
#import "AnimationVariable.h"

// Used by the doMovement function.
#define kTouchWayNegX 1
#define kTouchWayPosX 2
#define kTouchWayNegY 3
#define kTouchWayPosY 4
#define kClockwise 1
#define kCounterClockwise 2

#define kMaxTouches 4

// This is the distance before determining the direction of movement.
#define kDetermineDirection 16.0

// This is the key used to save/load the movement counter when saving the game pieces.
#define kKeyMovementCounter @"key_movementCounter"

// Used to notify another class when the Game Map meets certain criterias.
@protocol GameMapTarget

// Called when game map is correct (animation going out is done too.)
-(void)notifyGameMapCorrect;

@end


@interface GameMap : NSObject <GamePieceTarget> {
	// Used to for GameMap notifications.
	id<GameMapTarget> target;
	
	// The two game boards.
	GamePiece *gameBoard[kGameBoardPieces]; // These pieces track their movement.
	CorrectCell *correctBoard[kGameBoardMaxY][kGameBoardMaxX];
	
	// The particle engine.
	ParticleEngine *particleEngine;
	
	// Movement counter.
	int movementCounter;
	// The record counter.
	int recordCounter;
	
	// If gameboard is finished and animating the piece going flush!
	bool animateEndFlush;
	AnimationVariable *animateFlush;
	
	// This is the current touch that the user has touched.
	TouchPoint *touchPoint;
	
	// Used for selection animation.
	AnimationVariable *animateSelect;
	
	// Fade in the board when starting it up.
	AnimationVariable *animateFadeIn;
	
	// Timer for to view the message.
	NSTimer *timerViewMessage;
	bool timerCreated;
	
	// The Set map and level.
	int level;
	NSString *setName;
	
	// True if first rending frame.
	bool firstRenderingFrame;
	
	// True if map is done, done even after the message to the user.
	bool bCompletelyDone;
	
	// This is a calculated distance that is kind of optimal to solving the map.
	int distanceToComplete;
	
	// This is the texture for the message.
	int textureIdForMessage;
}

@property (readonly) int movementCounter;
@property (readonly) int recordCounter;
@property (readonly) int level;

/** Initalize the Game Map.
 */
-(id) initGameMap:(LevelInfo *)levelInfo particleEngine:(ParticleEngine *)_particleEngine setName:(NSString *)_setName level:(int)_level;

// Called each frame to up.
-(void) update;

// Called when shutting down.
- (void)dealloc;

// This will draw the game board.
- (void)draw;

// These are the touch finger functions. 
- (void)onFingerDown: (TouchPoint *)touch;
- (void)onFingerUp: (TouchPoint *)touch;

// This will determine if a piece can move and then performs the movement if possible.
- (void) doMovement: (CGPoint) ptTouchDown ptTouchUp:(CGPoint) ptTouchUp;

// @return the number of movements it took to complete the map.
-(int) movementCount;

// @return true if the level is being animated to come to life, else level is already alive.
-(bool) animateLevel;

// Gets the game piece at the xCell, yCell position in the game board.
- (GamePiece *) getGamePiece: (int) xCell yCell:(int)yCell;

// This will convert game pieces to partices.
-(void) gamePiecesToParticles;

// Don't draw game pieces.
-(void) setAllPiecesInvisible;

// This will set the target for GameMap updates.
-(void)setTarget:(id<GameMapTarget>)_target;

// @return true if board map is completed.
-(bool)boardComplete;

// This will draw the selector and arrow if need be.
-(void) drawSelectorArrow;

// This will calculate the message to show the player.
-(void) determineMessageForPlayer;

// This will set the texture type being used for the game piece.
// @param textureType 1: Buttons, 2: Ninja cogs, 3: Bling.
-(void) setTextureType: (int)textureType;

// This will update the game piece settings to correct and set the correct cell to correct.
-(void) setGamePieceCorrect: (GamePiece *)piece;

// Protocol GamePieceTarget ///////////////////////////////////////////////////////////////////////////////////////////////

-(void) notifyDoneAnimationMovement: (GamePiece *)piece;

// END Protocol GamePieceTarget ///////////////////////////////////////////////////////////////////////////////////////////

- (void)saveSettings;
- (void)loveSettings;
- (void)saveSettingsGamePieces;
// @param setIcon is the type of icon the game pieces should be.
- (void)loadSettingsGamePieces: (int)setIcon;

@end
