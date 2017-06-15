//
//  SuperView.h
//  Finger
//
//  Created by Robert Molnar 2 on 10/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScreen.h"
#import "MainMenuScreen.h"
#import "Game.h"
#import "SoundManager.h"

// Used to store the last setId and level position when the game exits.

// The key used to indicate if player needs to restore their game.
#define kKeyRestoreGame @"key_restoreGame"

@interface SuperView : UIView {
    Game *game;
	
	// True if there was a game previously running.
	int restoreGame;
}

- (void)applicationWillTerminate;

- (void)saveSettings;

- (void)loveSettings;

@end
