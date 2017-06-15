//
//  SuperView.m
//  Finger
//
//  Created by Robert Molnar 2 on 10/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SuperView.h"


@implementation SuperView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		
		// Initialize sound.
		soundManager = [[[SoundManager alloc] initManager] retain];
		
		// Initialize levels.
		[SetInfo buildSets];
		
		[self loveSettings];
		if (restoreGame) {			
			// Clear the flag.
			restoreGame = 0;
			[self saveSettings];
			
			MainMenuScreen *view = [[MainMenuScreen alloc] initWithFrame:[self frame]];
			[view doRestoreMessage];
			[self addSubview:view];
			[view release];
		}else {
			MainMenuScreen *view = [[MainMenuScreen alloc] initWithFrame:[self frame]];
			[self addSubview:view];
			[view release];
		}
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
	
}



- (void)dealloc {
    [super dealloc];
}

- (void)willRemoveSubview:(UIView *)subview {
	if ([subview isMemberOfClass:[MainMenuScreen class]] == TRUE) {
		MainMenuScreen *screen = (MainMenuScreen *)subview;
		
		if ([screen restoreGame]) {
			GameScreen *view = [[GameScreen alloc] initWithFrameLoadRestore:[self frame]];
			[self addSubview:view];
			[view release];
			game = [view game];	
			return;
		} else {
			GameScreen *view = [[GameScreen alloc] initWithFrame:[self frame] setId:[screen gameMode]];
			[self addSubview:view];
			[view release];
			game = [view game];
		}
		
	} else if ([subview isMemberOfClass:[GameScreen class]] == TRUE) {
		MainMenuScreen *view = [[MainMenuScreen alloc] initWithFrame:[self frame]];
		[self addSubview:view];
		[view release];
		game = nil;
	}

}

- (void)applicationWillTerminate {	
	// No saving needs to be done.
	if (game == nil)
		return;

	// Since game is not nil therefore there must be a level in progress.
	restoreGame = 1;
	[self saveSettings];
	
	// Notify game that it will terminate and to save its settings.
	[game applicationWillTerminate];
}


- (void)saveSettings {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:restoreGame]] forKey:kKeyRestoreGame];
}

- (void)loveSettings {
	// Create the dictionary with default values.
	NSMutableDictionary *resourceDict = [[NSMutableDictionary dictionaryWithCapacity:10] init];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:kKeyRestoreGame];
	
	// Register the defaults if they don't exist.
	[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	restoreGame = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kKeyRestoreGame]] intValue];
}


@end
