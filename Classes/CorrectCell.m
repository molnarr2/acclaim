//
//  CorrectPiece.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CorrectCell.h"


@implementation CorrectCell

-(id) initCorrectCell: (int)_type xCell:(int)_xCell yCell:(int)_yCell {
	self = [super init];
	
	type = _type;
	xCell = _xCell;
	yCell = _yCell;
	xPosition = xCell * kGamePieceSize;
	yPosition = yCell * kGamePieceSize + 32;

	switch (type) {	
		case kGameCellDie1:
			red = 1.0; green = 0.184; blue = 0.184;
			break;
		case kGameCellDie2:
			red = 1.0; green = 1.0; blue = 0.38;
			break;
		case kGameCellDie3:
			red = 0.0; green = 1.0; blue = 0.0;
			break;
		case kGameCellDie4:
			red = 0.451; green = 1.0; blue = 1.0;
			break;
		case kGameCellDie5:
			red = 1.0; green = 0.5; blue = 1.0;
			break;
		case kGameCellDie6:
			red = 0.124; green = 0.412; blue = 1.0;
			break;
	}	
	
	[self autorelease];	
	return self;
}

-(void) draw {
	// Don't draw empty spaces.
	if (type == kGameCellDiceEmpty)
		return;
	glColor4f(red, green, blue, 1.0);
	CGRect rect = CGRectMake(xPosition, yPosition, kGamePieceSize, kGamePieceSize);
	[[textureManager texture:TEXTURE_GAME_SOLID] drawInRect:&rect];
}

-(bool) isGamePieceCorrect: (GamePiece *)piece {
	if ([piece xCell] == xCell && [piece yCell] == yCell && [piece type] == type && [piece isMoving] == false)
		return true;
	return false;
}

-(void) setGamePiece: (GamePiece *)piece {
	if ([piece type] == type) {
		lastPiece = piece;
	}
}

-(bool) isCorrect {
	if (type == kGameCellDiceEmpty)
		return true;
	if (lastPiece != nil && [self isGamePieceCorrect:lastPiece])
		return true;
	return false;
}

@end
