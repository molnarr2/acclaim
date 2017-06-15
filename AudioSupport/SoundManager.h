//
//  SoundManager.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundEngine.h"
#import "ResourceIds.h"

// The one and only.
@class SoundManager;
SoundManager *soundManager;

@interface SoundManager : NSObject {
	bool soundEngineInitialized;
	bool soundEnable;
	
	UInt32 array[MAX_SOUND_ARRAY];
}

-(void)dealloc;

// @param initialized is true if the sound is to be initialized.
-(SoundManager *) initManager;

// This will play the sound with the soundId found in ResourceIds.h.
// Will load the sound if not loaded yet.
-(void) playsound: (int) soundId;

// This will load the sound with the soundId found in ResourceIds.h
-(void)_loadSound: (int) soundId;

// @return true if sound is on.
-(bool) isSoundEnabled;

// @param enable is true if sound is to be enabled, else false do not play sound.
-(void) setSoundEnabled: (bool)enable;

// This will start up the sound engine.
-(void)_initializedSound;

@end

