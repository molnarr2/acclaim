//
//  CorrectPiece.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamePiece.h"
#import "Types.h"
#import "TextureManager.h"

@interface CorrectCell : NSObject {
	// kGameCellDie type.
	int type; 
	
	// Color type of the correct cell.
	float red, green, blue;	
	
	// Cell position.
	int xCell;
	int yCell;
	float xPosition;
	float yPosition;
	
	// Last correct piece on this cell. (might not be on there anymore.)
	GamePiece *lastPiece;
}

// @param _type is the kGameCellDie* type. If kGameCellDiceEmpty then its not used.
-(id) initCorrectCell: (int)_type xCell:(int)_xCell yCell:(int)_yCell;

-(void) draw;

// This will see if the game piece matches this correct cell.
-(bool) isGamePieceCorrect: (GamePiece *)piece;

// This will associate the game piece with this cell, but only if it matches the type.
-(void) setGamePiece: (GamePiece *)piece;

// @return true if the last piece is still on this correct cell and it is the correct type. If type is kGameCellDieEmpty then always returns true.
-(bool) isCorrect;

@end
