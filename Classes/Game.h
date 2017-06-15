//
//  Game.h
//  Finger
//
//  Created by Robert Molnar 2 on 10/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "FPoint.h"
#import "TouchPoint.h"
#import "ResourceIds.h"
#import "TextureManager.h"
#import "GameMap.h"
#import "ParticleEngine.h"
#import "SetInfo.h"
#import "Types.h"
#import "Global.h"
#import "SoundEngine.h"
#import "AnimationVariable.h"

// Maximum number of fingers that can be processed at a time.
#define MAX_FINGER_USE 4

// Indicates the game is running.
#define GAME_STATE_RUNNING 1
// Indicates the game is paused.
#define GAME_STATE_PAUSED 2
// Indicates the game has finished. Do not process the game loop then.
#define GAME_STATE_END 3

// This is the menu position.
#define kIngameProcessMenuPos 12

// Used with the 'setIcons' variable. Used to indicate which set of icons are being used.
#define kSetIconsButtons 1
#define kSetIconsNinja 2
#define kSetIconsBling 3

// The key used to store the 'setIcons' variable. 
#define kKeySetIcons @"key_seticons"
// Keys used to store the setId and current level position.
#define kKeySetId @"key_setId"
#define kKeyCurrentLevel @"key_currentLevel"

// This is the size of the ingame sets to choose from.
#define kInGameSetsSize 48

@interface Game : NSObject <GameMapTarget> {
	// State of the game.
	int stateOfGame;
	// This is the timestamp when the game begins.
	double timestampGameBegins;
	// This is the view with the game will be drawing into.
	EAGLView *view;
	// Timer used for the game loop.
	NSTimer *timer;	

	// The particle engine.
	ParticleEngine *particleEngine;

	// FPS.
	// The last time the game loop was ran in milliseconds.
	double timestampLastRun;
	// This is the number of runs per second.
	int runs;
	
	// Texture of background.
	int backgroundId;
	
	// This is the game map support.
	GameMap *gameMap;
	
	// Contains the set information to play.
	SetInfo *set;
	int setId;
	
	CGRect rectPrev;
	CGRect rectNext;
	CGRect rectQuestion;
	CGRect rectRecordCurrent;
	CGRect rectRecordLevel;
	
	TouchPoint *touchPoint;
	
	// In-Progress menu.
	CGRect rectSoundOn;
	CGRect rectSoundOff;
	CGRect rectReturn;
	CGRect rectMainMenu;
	CGRect rectSetButton;
	CGRect rectSetBling;
	CGRect rectSetNinja;
	
	// set icons used for the map.
	int setIcons;
	AnimationVariable *animationInGameMenu;
	
}

/** Initalize the Game.
 * @param view is the EAGLView which the game will be drawing into.
 */
-(Game *) initGame:(EAGLView *)viewFrom setId:(int)_setId;
-(Game *) initGameLoadPrevious:(EAGLView *)viewFrom;
-(Game *) initGame:(EAGLView *)viewFrom;

// This is the game loop which is called by the timer. 20 FPS target time.
- (void)gameLoop;

// Called when shutting down.
- (void)dealloc;

// These are the touch finger functions. 
- (void)onFingerDown: (TouchPoint *)touch;
- (void)onFingerUp: (TouchPoint *)touch;

// This is the drawing function that is called when the drawRect function is called in the view.
-(void)draw;
-(void)drawInGameMenu;

// ------------------------------------------------------------------------------------------------------------------------------------------

-(void) gameLoopRunning;

-(void) gameLoopPaused;

// USed to detect if main menu items have been pressed.
- (void) mainMenuItemsPressed;
-(void) ingameMenuItemPressed;

// This will update the game logic.
- (void)updateGameLogic;

- (void)applicationWillTerminate;

- (void)saveRestoreSettings;

- (void)loadRestoreSettings;

- (void)saveSettings;

- (void)loadSettings;

- (void) gotoPrevMap;

// Call this to end the game.
-(void) endGame;

// Protocol GameMapTarget ///////////////////////////////////////////////////////////////////////////////////////////////

-(void) notifyGameMapCorrect;

// END Protocol GameMapTarget ///////////////////////////////////////////////////////////////////////////////////////////

@end
