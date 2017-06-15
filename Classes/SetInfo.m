//
//  SetInfo.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SetInfo.h"


@implementation SetInfo

@synthesize level;

+(void)buildSets {	
	glbSets[TEXTURE_LEVELS_SIMPLE - 100] = [[[SetInfo alloc] initSetInfo:[[NSBundle mainBundle] pathForResource:@"easy" ofType:@"txt"]] retain];	
	glbSets[TEXTURE_LEVELS_SYMMETRIC - 100] = [[[SetInfo alloc] initSetInfo:[[NSBundle mainBundle] pathForResource:@"symmetric" ofType:@"txt"]] retain];	
	glbSets[TEXTURE_LEVELS_ALPHABET - 100] = [[[SetInfo alloc] initSetInfo:[[NSBundle mainBundle] pathForResource:@"alphabet" ofType:@"txt"]] retain];	
	glbSets[TEXTURE_LEVELS_WHATEVER - 100] = [[[SetInfo alloc] initSetInfo:[[NSBundle mainBundle] pathForResource:@"whatever" ofType:@"txt"]] retain];	
	glbSets[TEXTURE_LEVELS_MINDBENDER - 100] = [[[SetInfo alloc] initSetInfo:[[NSBundle mainBundle] pathForResource:@"mindbender" ofType:@"txt"]] retain];	
}

-(id) initSetInfo: (NSString *)fileName {
	self = [super init];
	
	totalLevels = 0;
	[self _loadFile: fileName];
	
	[self autorelease];	
	return self;
}

- (void)dealloc {
	[name release];
	[super dealloc];
}

-(void)begin {
	level = 0;
}

-(GameMap *)nextLevel: (ParticleEngine *)_particleEngine {
	GameMap *map = [[GameMap alloc] initGameMap:&levels[level] particleEngine:_particleEngine setName:name level:level];
	level++;
	return map;
}

-(GameMap *)prevLevel: (ParticleEngine *)_particleEngine {
	level-=2;
	if (level < 0)
		level = 0;
	return [self nextLevel:_particleEngine];
}

-(bool)hasNext {
	return (level < totalLevels);
}

-(int)getLevelCount {
	return totalLevels;
}

-(NSString *)getName {
	return name;
}

-(void)addLevel: (LevelInfo *)levelInfo {
	for (int y=0; y < kGameBoardMaxY; y++) {
		for (int x=0; x < kGameBoardMaxX; x++) {
			levels[totalLevels].gameboard[y][x] = levelInfo->gameboard[y][x];
			levels[totalLevels].correct[y][x] = levelInfo->correct[y][x];
		}
	}
	totalLevels++;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Private functions. //////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)_loadFile: (NSString *)fileName {
	
	// Load in the file into a string.
	NSError *error;	
	NSString *rawData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:&error];
	if (rawData == nil) {
		return;
	}
	
	NSArray *arrLines = [rawData componentsSeparatedByString:@"\n"];
	
	// Get the name of set.
	name = [[NSString stringWithString:[arrLines objectAtIndex:0]] retain];
	
	int count = [arrLines count];
	int state = 1;
	for (int i=1; i < count;i++) {
		NSString *line = [arrLines objectAtIndex:i];
		
		// Comment 
		if ([line length] == 0 || [line characterAtIndex:0] == '#')
			continue;
		
		// Then this is the start of a game board map.
		if (state == 1) {
			// Get the distance.
			NSArray *arrDistance = [line componentsSeparatedByString:@"="];
			levels[totalLevels].distance = [[arrDistance objectAtIndex:1] intValue];
			// Next get the board map.
			state = 2;
			
		} else if (state == 2) {
			// This first line is the distance.
			
			for (int y=0; y < kGameBoardMaxY; ) {
				 NSArray *arrNumbers = [line componentsSeparatedByString:@","];
				
				// Load in the values.
				for (int x=0; x < kGameBoardMaxX; x++) {
					levels[totalLevels].gameboard[y][x] = [[arrNumbers objectAtIndex:x] intValue];
				}
				
				// Next row.
				y++;
				if (y < kGameBoardMaxY) {
					i++;
					line = [arrLines objectAtIndex:i];
				}
			}	
			// Next map is the correct board.
			state = 3;
			
		} else { // Then this is the start of a correct board map.
			for (int y=0; y < kGameBoardMaxY;) {
				NSArray *arrNumbers = [line componentsSeparatedByString:@","];
				
				// Load in the values.
				for (int x=0; x < kGameBoardMaxX; x++) {
					levels[totalLevels].correct[y][x] = [[arrNumbers objectAtIndex:x] intValue];
				}
				
				// Next row.
				y++;
				if (y < kGameBoardMaxY) {
					i++;
					line = [arrLines objectAtIndex:i];
				}
			}	
			// Next map is the correct board.
			state = 1;
			totalLevels++;
			
		}
	}		
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
