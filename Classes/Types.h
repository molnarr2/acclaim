/*
 *  Types.h
 *  Acclaim!
 *
 *  Created by Robert Molnar 2 on 12/5/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

// Game board size.
#define kGameBoardMaxX 5
#define kGameBoardMaxY 7
#define kGameBoardPieces 35

struct LevelInfo {
	int distance;
	int gameboard[kGameBoardMaxY][kGameBoardMaxX];
	int correct[kGameBoardMaxY][kGameBoardMaxX];
};
typedef struct LevelInfo LevelInfo;
