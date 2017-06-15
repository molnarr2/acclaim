//
//  Game.m
//  Finger
//
//  Created by Robert Molnar 2 on 10/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

#define kGameBackgroundId @"prefBackgroundId"

#define kAnimateToNextLevelNone 0
#define kAnimateToNextLevelOut 1
#define kAnimateToNextLevelIn 2

@implementation Game

/** This will initialize the game from previously save game information.
 */
-(Game *) initGameLoadPrevious:(EAGLView *)viewFrom {
	self = [super init];
	
	// This is the particle engine.
	particleEngine = [[[ParticleEngine alloc] initParticleEngine: 512] retain];
	
	// Restore the set.
	[self loadRestoreSettings];
	
	return [self initGame:viewFrom];
}

/** Initalize the Game.
 * @param view is the EAGLView which the game will be drawing into.
 * @param modeToEnter is the mode to enter into for the game GAME_MODE_* values.
 */
-(Game *) initGame:(EAGLView *)viewFrom setId:(int)_setId {
	self = [super init];
	
	// This is the particle engine.
	particleEngine = [[[ParticleEngine alloc] initParticleEngine: 512] retain];
	
	// Load the set.
	setId = _setId;
	set = glbSets[_setId];
	[set begin];
	gameMap = [[set nextLevel:particleEngine] retain];
	[gameMap setTarget:self];
	
	return [self initGame:viewFrom];
}


-(Game *) initGame:(EAGLView *)viewFrom {
	view = viewFrom;
	
	// This is the state of the game.
	stateOfGame = GAME_STATE_RUNNING;
	
	timestampLastRun = CFAbsoluteTimeGetCurrent();	
	
	// Create the game loop timer.
	timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES] retain];
	
	rectPrev.origin.x = 0;
	rectPrev.origin.y = 0;
	rectPrev.size.width = 64;
	rectPrev.size.height = 32;
	
	rectNext.origin.x = 64;
	rectNext.origin.y = 0;
	rectNext.size.width = 64;
	rectNext.size.height = 32;
	
	rectQuestion.origin.x = 288;
	rectQuestion.origin.y = 0;
	rectQuestion.size.width = 32;
	rectQuestion.size.height = 32;
	
	rectRecordCurrent.origin.x = 128;
	rectRecordCurrent.origin.y = 0;
	rectRecordCurrent.size.width = 96;
	rectRecordCurrent.size.height = 32;
	
	rectRecordLevel.origin.x = 236;
	rectRecordLevel.origin.y = 0;
	rectRecordLevel.size.width = 48;
	rectRecordLevel.size.height = 16;
	
	touchPoint = nil;
	
	// In-progress menu.
	rectSoundOn.origin.x = 132.0 + kIngameProcessMenuPos;
	rectSoundOn.origin.y = 124.0 + kIngameProcessMenuPos;
	
	rectSoundOff.origin.x = 210.0 + kIngameProcessMenuPos;
	rectSoundOff.origin.y = 124.0 + kIngameProcessMenuPos;
	
	rectSoundOn.size.width = rectSoundOn.size.height = rectSoundOff.size.width = rectSoundOff.size.height = 52.0;
	
	rectReturn.size.width = rectMainMenu.size.width = 200;
	rectReturn.size.height = rectMainMenu.size.height = 52;
	
	rectReturn.origin.x = rectMainMenu.origin.x = 50 + kIngameProcessMenuPos;
	rectReturn.origin.y = 380 + kIngameProcessMenuPos;
	rectMainMenu.origin.y = 320 + kIngameProcessMenuPos;
	
	rectSetButton.origin.x = 104 + kIngameProcessMenuPos;
	rectSetButton.origin.y = 200 + kIngameProcessMenuPos;
	
	rectSetBling.origin.x = 104 + kIngameProcessMenuPos + kInGameSetsSize + 4;
	rectSetBling.origin.y = 200 + kIngameProcessMenuPos;
	
	rectSetNinja.origin.x = 104 + kIngameProcessMenuPos + kInGameSetsSize * 2 + 4 * 2;
	rectSetNinja.origin.y = 200 + kIngameProcessMenuPos;
	
	rectSetButton.size.width = rectSetBling.size.width = rectSetNinja.size.width = kInGameSetsSize;
	rectSetButton.size.height = rectSetBling.size.height = rectSetNinja.size.height = kInGameSetsSize;
	
	animationInGameMenu = [[[AnimationVariable alloc] initAnimation:0.0 toValue:12.0 step:0.4 forever:true] retain];
	
	// Load the texture type.
	[self loadSettings];	
	[gameMap setTextureType:setIcons];
	
	[self autorelease];	
	return self;	
}

- (void)gameLoop {

	/* FPS */
	/*
	runs++;
	double delta = CFAbsoluteTimeGetCurrent() - timestampLastRun;
	if (delta >= 1.0) {
		printf ("FPS: %f\n", (double)runs / delta);
		timestampLastRun = CFAbsoluteTimeGetCurrent();
		runs = 0;
	}
	*/

	[animationInGameMenu update];
	
	switch (stateOfGame) {
		case GAME_STATE_RUNNING:
			[self gameLoopRunning];
			break;
		case GAME_STATE_PAUSED:
			[self gameLoopPaused];
			break;
		case GAME_STATE_END:
			break;
		default:
			break;
	}
}

-(void) gameLoopRunning {	
	// Game logic.
	[self updateGameLogic];
	
	// Do not continue if game is not running.
	if (stateOfGame == GAME_STATE_END)
		return;
	
	[particleEngine update];
	[self draw];
	[view swapBuffers];		
}

-(void) gameLoopPaused {
	[self drawInGameMenu];
	[view swapBuffers];		
}

- (void)dealloc {
	[animationInGameMenu release];
	[timer release];
	[particleEngine release];
	if (gameMap != nil)
		[gameMap release];
	[super dealloc];
}

- (void)onFingerDown: (TouchPoint *)touch {
	if (stateOfGame == GAME_STATE_RUNNING)
		[gameMap onFingerDown:touch];

	// Finger already down.
	if (touchPoint != nil)
		return;
	touchPoint = touch;
}
	
- (void)onFingerUp: (TouchPoint *)touch {
	[gameMap onFingerUp:touch];
	
	// Handle the menu items.
	if (touchPoint != nil) {
		if (stateOfGame == GAME_STATE_PAUSED) {
			[self ingameMenuItemPressed];
		} else {
			[self mainMenuItemsPressed];
		}
	}
		
	if (touchPoint == touch)
		touchPoint = nil;
}

- (void) mainMenuItemsPressed {
	CGPoint ptDown, ptCurr;
	ptDown = [touchPoint getTouchPosition];
	ptCurr = [touchPoint getTouchDownPosition];
	
	// Prev level.
	if ([Utilites isPointInRect:&rectPrev point:&ptDown] && [Utilites isPointInRect:&rectPrev point:&ptCurr]) {
		[self gotoPrevMap];
	}
	
	// Next level.
	if ([Utilites isPointInRect:&rectNext point:&ptDown] && [Utilites isPointInRect:&rectNext point:&ptCurr]) {
		[self notifyGameMapCorrect];
	}
	
	// Question.
	if ([Utilites isPointInRect:&rectQuestion point:&ptDown] && [Utilites isPointInRect:&rectQuestion point:&ptCurr]) {
		stateOfGame = GAME_STATE_PAUSED;
	}
}

-(void) ingameMenuItemPressed {
	CGPoint ptDown;
	ptDown = [touchPoint getTouchPosition];
	
	// Return.
	if ([Utilites isPointInRect:&rectReturn point:&ptDown]) {
		stateOfGame = GAME_STATE_RUNNING;
	} 
	
	// Main Menu.
	if ([Utilites isPointInRect:&rectMainMenu point:&ptDown]) {
		[self endGame];
	}
	
	// Sound Off.
	if ([Utilites isPointInRect:&rectSoundOff point:&ptDown]) {
		[soundManager setSoundEnabled: false];
	}
	
	// Sound On.
	if ([Utilites isPointInRect:&rectSoundOn point:&ptDown]) {
		[soundManager setSoundEnabled: true];
	}
	
	// Change icon set.
	if ([Utilites isPointInRect:&rectSetButton point:&ptDown]) {
		setIcons = kSetIconsButtons;
		[gameMap setTextureType:setIcons];
		[self saveSettings];
	}
	if ([Utilites isPointInRect:&rectSetBling point:&ptDown]) {
		setIcons = kSetIconsBling;
		[gameMap setTextureType:setIcons];
		[self saveSettings];
	}
	if ([Utilites isPointInRect:&rectSetNinja point:&ptDown]) {
		setIcons = kSetIconsNinja;
		[gameMap setTextureType:setIcons];
		[self saveSettings];
	}
	
	
}

-(void)drawInGameMenu {
	CGRect bounds;
	
	[self draw];
	
	// Fade the background.
	glColor4f(0.0, 0.0, 0.0, 0.7);
	CGRect rect = CGRectMake(0.0, 32.0, 320.0, 448.0);
	[[textureManager texture:TEXTURE_GAME_SOLIDBLACK] drawInRect:&rect];		
		
	// Draw the in-game menu.
	glColor4f(1.0, 1.0, 1.0, 1.0);
	bounds.size.width = 296;
	bounds.size.height = 456;
	bounds.origin.x = 12;
	bounds.origin.y = 12;		
	[[textureManager texture:TEXTURE_INGAME_BUTTON_MENU] drawInRect:&bounds];
	
	// Sound enablement.
	if ([soundManager isSoundEnabled]) {
		[[textureManager texture:TEXTURE_INGAME_BUTTON_OUT] drawInRect:&rectSoundOff];
		[[textureManager texture:TEXTURE_INGAME_BUTTON_IN] drawInRect:&rectSoundOn];
	} else {
		[[textureManager texture:TEXTURE_INGAME_BUTTON_IN] drawInRect:&rectSoundOff];
		[[textureManager texture:TEXTURE_INGAME_BUTTON_OUT] drawInRect:&rectSoundOn];
	}

	glColor4f(1.0, 1.0, 1.0, 1.0);

	// Draw the sets to choose from.
	if (setIcons == kSetIconsButtons) {
		float value = [animationInGameMenu value] / 2;
		CGRect rect = CGRectMake(rectSetButton.origin.x + value, rectSetButton.origin.y + value, rectSetButton.size.width - value, rectSetButton.size.height - value);
		[[textureManager texture:TEXTURE_GAME_PIECE1] drawInRect:&rect];
	} else
		[[textureManager texture:TEXTURE_GAME_PIECE1] drawInRect:&rectSetButton];
	
	if (setIcons == kSetIconsBling) {
		float value = [animationInGameMenu value] / 2;
		CGRect rect = CGRectMake(rectSetBling.origin.x + value, rectSetBling.origin.y + value, rectSetBling.size.width - value, rectSetBling.size.height - value);
		[[textureManager texture:TEXTURE_GAME_BLING_PIECE2] drawInRect:&rect];
	} else
		[[textureManager texture:TEXTURE_GAME_BLING_PIECE2] drawInRect:&rectSetBling];
	
	if (setIcons == kSetIconsNinja) {
		float value = [animationInGameMenu value] / 2;
		CGRect rect = CGRectMake(rectSetNinja.origin.x + value, rectSetNinja.origin.y + value, rectSetNinja.size.width - value, rectSetNinja.size.height - value);
		[[textureManager texture:TEXTURE_GAME_NINJA_PIECE3] drawInRect:&rect];
	} else
		[[textureManager texture:TEXTURE_GAME_NINJA_PIECE3] drawInRect:&rectSetNinja];
	
}

-(void)draw {
	CGRect bounds;
	
	// Background.
	glDisable(GL_BLEND);
	
	// board map.
	glColor4f(0.276, 0.18, 0.102, 1);
	bounds.size.width = 64;
	bounds.size.height = 64;
	
	for (int y=0; y < kGameBoardMaxY; y++) {
		for (int x=0; x <kGameBoardMaxX; x++) {
			bounds.origin.x = x * 64;
			bounds.origin.y = y * 64 + 32;
			[[textureManager texture:TEXTURE_GAME_BG1] drawInRect:&bounds];
		}
	}
	glEnable(GL_BLEND);
	
	// Draw game pieces.
	[gameMap draw];

	[particleEngine draw];
	
	// Draw the menu.
	
	// top part black.
	glColor4f(0.0, 0.0, 0.0, 1);
	bounds.size.width = 320;
	bounds.size.height = 32;
	bounds.origin.x = 0;
	bounds.origin.y = 0;
	[[textureManager texture:TEXTURE_GAME_SOLIDBLACK] drawInRect:&bounds];
	
	glColor4f(1.0, 1.0, 1.0, 1.0);
	[[textureManager texture:TEXTURE_GAMEMENU_PREV] drawInRect:&rectPrev];
	[[textureManager texture:TEXTURE_GAMEMENU_NEXT] drawInRect:&rectNext];
	[[textureManager texture:TEXTURE_GAMEMENU_RECORDCURRENT] drawInRect:&rectRecordCurrent];
	[[textureManager texture:TEXTURE_GAMEMENU_QUESTION] drawInRect:&rectQuestion];
	[[textureManager texture:TEXTURE_GAMEMENU_LEVEL] drawInRect:&rectRecordLevel];	
	
	glColor4f(1.0, 1.0, 1.0, 1.0);
	[textureManager digits16_drawNumberAtPoint:CGPointMake(194, 2) height:-1 number:[gameMap recordCounter]];
	[textureManager digits16_drawNumberAtPoint:CGPointMake(194, 18) height:-1 number:[gameMap movementCounter]];
	[textureManager digits16_drawNumberAtPoint:CGPointMake(252, 18) height:-1 number:[gameMap level]+1];		
}

// ------------------------------------------------------------------------------------------------------------------------------------------

- (void)updateGameLogic {
	// Update the gameMap.
	[gameMap update];
}

 
- (void)applicationWillTerminate {
	[self saveRestoreSettings];
}

- (void)saveSettings {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:setIcons]] forKey:kKeySetIcons];
}

- (void)loadSettings {
	// Create the dictionary with default values.		
	NSMutableDictionary *resourceDict = [[NSMutableDictionary dictionaryWithCapacity:10] init];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:kSetIconsNinja]] forKey:kKeySetIcons];
	
	// Register the defaults if they don't exist.
	[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	setIcons = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kKeySetIcons]] intValue]; 
}
	
- (void)saveRestoreSettings {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Need to save the set id, and level position.
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:setId]] forKey:kKeySetId];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:[set level]-1]] forKey:kKeyCurrentLevel];
	
	// Need to save where the game pieces are currently at.
	[gameMap saveSettingsGamePieces];
}
	
- (void)loadRestoreSettings {
	// The defaults don't make much sense unless a saveRestoreSettings() was preformed first.
	
	// Create the dictionary with default values.		
	NSMutableDictionary *resourceDict = [[NSMutableDictionary dictionaryWithCapacity:10] init];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:kKeySetId];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:kKeyCurrentLevel];
	
	// Register the defaults if they don't exist.
	[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	
	// Load in the restored settings.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	setId = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kKeySetId]] intValue];
	int currentLevelId = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kKeyCurrentLevel]] intValue];
	
	// Now need to setup the set and level information.
	set = glbSets[setId];
	[set setLevel:currentLevelId];
	gameMap = [[set nextLevel:particleEngine] retain];
	[gameMap setTarget:self];
	
	// Reload the game map pieces.
	[gameMap loadSettingsGamePieces: setIcons];	
}
	
- (void) gotoPrevMap {
	if ([gameMap level] == 0)
		return;
	
	[gameMap release];
	gameMap = [[set prevLevel:particleEngine] retain];
	[gameMap setTextureType:setIcons];
	[gameMap setTarget:self];	
}

-(void) endGame {
	[timer invalidate];
	[gameMap release];
	gameMap = nil;
	stateOfGame = GAME_STATE_END;
	[textureManager reset];
	[view removeFromSuperview];
}

// Protocol GameMapTarget ///////////////////////////////////////////////////////////////////////////////////////////////

-(void) notifyGameMapCorrect {
	// Move onto next level or exit out of game.
	if ([set hasNext]) {
		[gameMap release];
		gameMap = [[set nextLevel:particleEngine] retain];
		[gameMap setTextureType:setIcons];
		[gameMap setTarget:self];	
	} else {
		[self endGame];
	}
}

// END Protocol GameMapTarget ///////////////////////////////////////////////////////////////////////////////////////////

@end
