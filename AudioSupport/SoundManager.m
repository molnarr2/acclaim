//
//  SoundManager.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

#define kListenerDistance			1.0  // Used for creating a realistic sound field

@implementation SoundManager

-(SoundManager *) initManager {
	self = [super init];
	
	// Is music playing? /////////////////////////////////////////////////////////////////
	
	//There must be an audio session running in order to call AudioSessionGetProperty successfully	
	UInt32 isPlaying;
	UInt32 propertySize = sizeof(isPlaying);
	OSStatus status = AudioSessionInitialize(NULL, NULL, NULL, NULL);
	
	if (status != kAudioSessionNoError) {
		NSLog(@"AudioSessionInitialize failed! %d", status);
	}
	
	status = AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &propertySize, &isPlaying);
	
	if (status != kAudioSessionNoError) {
		NSLog(@"AudioSessionGetProperty failed! %d", status);
	}
	
	if (propertySize != sizeof(isPlaying)) {
		NSLog(@"AudioSessionGetProperty returned a bad property size.");
	}
	
	if (!isPlaying)
		[self _initializedSound];
	
	// Is music playing? /////////////////////////////////////////////////////////////////
	
	
	// Initialize.
	for (int i=0; i < MAX_SOUND_ARRAY; i++)
		array[i] = -1;
	
	soundEngineInitialized = !isPlaying;
	soundEnable = soundEngineInitialized;
	
	return self;
}

-(void)dealloc {	
	[super dealloc];
}

-(void) playsound: (int) soundId {
	// Sorry... no sound.
	if (soundEnable == false)
		return;
	
	if (array[soundId] == -1)
		[self _loadSound: soundId];
	SoundEngine_StartEffect(array[soundId]);
}

-(void)_loadSound: (int) soundId {
	NSBundle *bundle = [NSBundle mainBundle];
	
	// Already loaded.
	if (array[soundId] != -1)
		return;
	
	switch (soundId) {
		case SOUND_GAME_PIECE1:
			SoundEngine_LoadEffect([[bundle pathForResource:@"coolmallet_d" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_PIECE2:
			SoundEngine_LoadEffect([[bundle pathForResource:@"coolmallet_eflat" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_PIECE3:
			SoundEngine_LoadEffect([[bundle pathForResource:@"coolmallet_e" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_PIECE4:
			SoundEngine_LoadEffect([[bundle pathForResource:@"coolmallet_f" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_PIECE5:
			SoundEngine_LoadEffect([[bundle pathForResource:@"coolmallet_gflat" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_PIECE6:
			SoundEngine_LoadEffect([[bundle pathForResource:@"coolmallet_g" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_CORRECT_PIECE1:
			SoundEngine_LoadEffect([[bundle pathForResource:@"success_light_09" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_TWIRL_IN:
			SoundEngine_LoadEffect([[bundle pathForResource:@"cinematic_tech_morph_sweep_01" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_GAME_POP_UP:
			SoundEngine_LoadEffect([[bundle pathForResource:@"boing09" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
		case SOUND_CLICK:
			SoundEngine_LoadEffect([[bundle pathForResource:@"organic_nav_01" ofType:@"wav"] UTF8String], &array[soundId]);
			break;
	}			
}

-(void) setSoundEnabled: (bool)enable {
	if (enable && soundEngineInitialized == false) {
		[self _initializedSound];
	}
	
	soundEnable = enable;
}

-(void)_initializedSound {
	// Note that each of the Sound Engine functions defined in SoundEngine.h return an OSStatus value.
	// Although the code in this application does not check for errors, you'll want to add error checking code 
	// in your own application, particularly during development.
	//Setup sound engine. Run  it at 44Khz to match the sound files
	SoundEngine_Initialize(44100);
	// Assume the listener is in the center at the start. The sound will pan as the position of the rocket changes.
	SoundEngine_SetListenerPosition(0.0, 0.0, kListenerDistance);
	soundEngineInitialized = true;
}

-(bool) isSoundEnabled {
	return soundEnable;
}

@end
