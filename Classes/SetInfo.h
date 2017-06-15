//
//  SetInfo.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticleEngine.h"
#import "GameMap.h"
#import "Types.h"

// This is Sets.
#define kMaxSets 32
@class SetInfo;
SetInfo *glbSets[kMaxSets];

@interface SetInfo : NSObject {
	// Name of the set.
	NSString *name;
	// The current level to get.
	int level;
	// The list of levels. LevelInfo.
	LevelInfo levels[50];
	// The number of levels in this set.
	int totalLevels;
}

@property(readwrite) int level;

// Call this once to populate the sets (glbSets).
+(void)buildSets;

/** Initalize the SetInfo with a loaded file.
 */
-(id) initSetInfo: (NSString *)fileName;

// Called when shutting down.
- (void)dealloc;

// This will restart at the first level.
-(void)begin;

// This will get the next level.
// @return a GameMap set up and ready for the next level.
-(GameMap *)nextLevel: (ParticleEngine *)_particleEngine;

// This will get the prev level.
// @return a GameMap set up and ready for the next level.
-(GameMap *)prevLevel: (ParticleEngine *)_particleEngine;

// @return true if more levels.
-(bool)hasNext;

// @return the number of levels.
-(int)getLevelCount;

// @return the name of the set.
-(NSString *)getName;

// This will add the level into this Set.
-(void)addLevel: (LevelInfo *)levelInfo;

// This will laod the file.
-(void)_loadFile: (NSString *)fileName;

@end
