//
//  MainMenuScreen.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAGLView.h"
#import "ParticleEngine.h"
#import "TextureManager.h"
#import "AnimationVariable.h"
#import "Utilites.h"
#import "Global.h"

struct MainMenuItems {
	CGRect levels;
	CGRect help;
	CGRect moreApps;
};
typedef struct MainMenuItems MainMenuItems;

struct LevelItems {
	CGRect rects[6];
};
typedef struct LevelItems LevelItems;

struct LevelTextureIds {
	int textureId[4];
};
typedef struct LevelTextureIds LevelTextureIds;

@interface MainMenuScreen : EAGLView {
	// Timer used for the game loop.
	NSTimer *timer;	
	NSTimer *oneSecond;
	bool animate;
	
	// Used to animate toward another screen.
	int animateTo;
	AnimationVariable *animateToward;
	
	AnimationVariable *animationResize;
	AnimationVariable *animationFade;
	bool performFade;
	
	// Particle Engine.
	ParticleEngine *particleEngine;
	
	// pressable areas.
	MainMenuItems rectMain;
	LevelItems rectLevels;
	CGRect moreAppsSnatcher;
	CGRect moreAppsTornado;
	CGRect restoreYes;
	CGRect restoreNo;
	
	// This is the index for the level pages.
	int levelPageIndex;
	
	// This is the gameMode to enter. Its also the texture id of the level.
	int gameMode;
	
	int pageState;
	int helpPage;
	
	// True if should restore game.
	bool bRestoreGame;
}

@property (readonly) int gameMode;

- (void)dealloc;

// Called to create the frame.
- (id)initWithFrame:(CGRect)frame;

// Called to erase the screen.
- (void) erase;

// This is the game loop which is called by the timer.
- (void)animation;
// Used to draw the various menu buttons.
// @param x_offset is the offset to add to the menu positions.
-(void)animationMain: (float) x_offset;
-(void)animationHelp: (float) x_offset;
-(void)animationLevels: (float) x_offset;
-(void)animationMoreApps: (float) x_offset;
-(void)animationRestore: (float) x_offset;
	
// This will create the particles for the menu.
-(void)buildParticles;

// This will create the Acclaim! for the menu.
-(void)buildParticlesAcclaim;

-(bool) touchMain: (CGPoint)pt;
-(bool) touchLevel: (CGPoint)pt;
-(bool) touchMoreApps: (CGPoint)pt;
-(bool) touchHelp: (CGPoint)pt;
-(bool) touchRestore: (CGPoint)pt;

-(void) doRestoreMessage;
-(bool) restoreGame;

@end

