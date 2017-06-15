//
//  GameMap.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GameMap.h"

@implementation GameMap

@synthesize movementCounter;
@synthesize recordCounter;
@synthesize level;

-(id) initGameMap:(LevelInfo *)levelInfo particleEngine:(ParticleEngine *)_particleEngine setName:(NSString *)_setName level:(int)_level {
	self = [super init];
	
	particleEngine = _particleEngine;	
	level = _level;
	setName = [[NSString stringWithString:_setName] retain];
	distanceToComplete = levelInfo->distance;
	
	// Load the two boards.
	int i=0;
	for (int y=0; y < kGameBoardMaxY; y++) {
		for (int x=0; x < kGameBoardMaxX; x++) {
			
			// Load the game piece.
			GamePiece *piece = [[[GamePiece alloc] initGamePiece:self type:levelInfo->gameboard[y][x] xCell:x yCell:y] retain];
			[piece doAnimateGrow];
			gameBoard[i] = piece;
			i++;
			
			// Load the correct piece.
			correctBoard[y][x] = [[[CorrectCell alloc] initCorrectCell:levelInfo->correct[y][x] xCell:x yCell:y] retain];
			
			// If the game piece is correct then set it correct and transparency.
			int xCell = [piece xCell];
			int yCell = [piece yCell];
			CorrectCell *cell = correctBoard[yCell][xCell];
			if ([cell isGamePieceCorrect:piece]) {
				[self setGamePieceCorrect: piece];
			}
		}
	}
	animateEndFlush = false;
	
	animateSelect = [[[AnimationVariable alloc] initAnimation:0.0 toValue:1.0 step:0.2 forever:true] retain];
	
	animateFadeIn = [[[AnimationVariable alloc] initAnimation:1.0 toValue:0.0 step:0.05 forever:false] retain];	

	touchPoint = nil;
	
	firstRenderingFrame = true;
	
	[self loveSettings];
	
	[self autorelease];	
	return self;
}

- (void)dealloc {
	int i=0;
	for (int y=0; y < kGameBoardMaxY; y++) {
		for (int x=0; x < kGameBoardMaxX; x++) {
			// Release correct cell.
			CorrectCell *cell = correctBoard[y][x];
			[cell release];
			// Release game piece.
			GamePiece *piece = gameBoard[i];
			[piece release];
			i++;
		}
	}
	
	if (animateFlush != nil)
		[animateFlush release];
	[animateSelect release];
	[super dealloc];
}

-(void) draw {
	// Draw the correct board parts.
	for (int y=0; y < kGameBoardMaxY; y++) {
		for (int x=0; x < kGameBoardMaxX; x++) {
			CorrectCell *cell = correctBoard[y][x];
			[cell draw];
		}
	}
	
	// Do not draw the game pieces as they are particles now, however, fade the correct board parts.
	if (animateEndFlush) {
		glColor4f(0.0, 0.0, 0.0, [animateFlush value]);
		CGRect rect = CGRectMake(0.0, 32.0, 320.0, 448.0);
		[[textureManager texture:TEXTURE_GAME_SOLIDBLACK] drawInRect:&rect];	
		
		
		glColor4f(1.0, 1.0, 1.0, 1.0);
		rect = CGRectMake(0,215, 320, 50);
		[[textureManager texture:textureIdForMessage] drawInRect:&rect];		
		return;
	}
	
	// Draw the game pieces.
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		[piece draw];
	}

	// Draw the fade in if active.
	if (animateFadeIn != nil) {
		glColor4f(0.0, 0.0, 0.0, [animateFadeIn value]);
		CGRect rect = CGRectMake(0.0, 32.0, 320.0, 448.0);
		[[textureManager texture:TEXTURE_GAME_SOLIDBLACK] drawInRect:&rect];
	}
	
	// Draw the selection and arrow if need be.
	[self drawSelectorArrow];
	
	// Play sound first time.
	if (firstRenderingFrame)
		[soundManager playsound:SOUND_GAME_POP_UP];	
	
	firstRenderingFrame = false;
}

-(void) drawSelectorArrow {		
	// If the user has a finger down then draw selection.
	if (touchPoint == nil)
		return;
	
	CGPoint ptDown = [touchPoint getTouchDownPosition]; 
	CGPoint ptCurrent = [touchPoint getTouchPosition]; 
	
	// Get the touch's down cell.
	int xCell = ptDown.x / kGamePieceSize;
	int yCell = (ptDown.y - 32) / kGamePieceSize;
	
	// Not enough distance to determine which way, therefore draw the single selection.
	if ([Utilites distance:&ptDown pt2:&ptCurrent] < kDetermineDirection) {
		CGRect rect = CGRectMake(xCell * kGamePieceSize, yCell * kGamePieceSize + 32, kGamePieceSize, kGamePieceSize);
		
		[[self getGamePiece:xCell yCell:yCell] setGlColor: 0.5];
		if ([animateSelect value] > 0.5)
			[[textureManager texture:TEXTURE_GAME_SELECT1] drawInRect:&rect];		
		else
			[[textureManager texture:TEXTURE_GAME_SELECT2] drawInRect:&rect];		
		
		return;
	}
	
	// Next determine which quaderant the touch is going.
	int movementWise;
	float deltaX = ptCurrent.x - ptDown.x;
	float deltaY = ptCurrent.y - ptDown.y;
	int touchWay;
	if (abs(deltaX) >= abs(deltaY)) {
		// In x direction.
		if (deltaX > 0) {
			touchWay = kTouchWayPosX;
			movementWise = kClockwise;
		} else {
			touchWay = kTouchWayNegX;
			movementWise = kCounterClockwise;
		}
	} else {
		// In y direction.
		if (deltaY > 0) {
			touchWay = kTouchWayPosY;
			movementWise = kCounterClockwise;
		} else {
			touchWay = kTouchWayNegY;
			movementWise = kClockwise;
		}
	}
	
	// If trying to move piece off board then cancel movement.
	if (touchWay == kTouchWayPosX && xCell == (kGameBoardMaxX-1))
		return;
	if (touchWay == kTouchWayNegX && xCell == 0)
		return;
	if (touchWay == kTouchWayPosY && yCell == (kGameBoardMaxY-1))
		return;
	if (touchWay == kTouchWayNegY && yCell == 0)
		return;
	
	// This is the top-left cell which will be Quadarant II on a graph.
	int xPivotCell = xCell;
	int yPivotCell = yCell;
	
	// If on the positive edges then minus one to the pivot cells.
	if (xCell == (kGameBoardMaxX-1) && touchWay == kTouchWayPosY) {
		movementWise = kClockwise;
		xPivotCell--;
	}
	if (xCell == (kGameBoardMaxX-1) && touchWay == kTouchWayNegY) {
		movementWise = kCounterClockwise;
		xPivotCell--;
	}
	if (yCell == (kGameBoardMaxY-1) && touchWay == kTouchWayPosX) {
		movementWise = kCounterClockwise;
		yPivotCell--;
	}
	if (yCell == (kGameBoardMaxY-1) && touchWay == kTouchWayNegX) {
		movementWise = kClockwise;
		yPivotCell--;
	}	
	
	if (touchWay == kTouchWayNegX) {
		xPivotCell--;
	} else if (touchWay == kTouchWayNegY) {
		yPivotCell--;
	}	

	// Set the color for the selector and arrow.
	[[self getGamePiece:xCell yCell:yCell] setGlColor: 0.5];	
	
	// Draw selector starting at xPivotCell, yPivotCell.
	CGRect rect = CGRectMake(xPivotCell * kGamePieceSize, yPivotCell * kGamePieceSize + 32, kGamePieceSize*2, kGamePieceSize*2);
	
	if ([animateSelect value] > 0.5)
		[[textureManager texture:TEXTURE_GAME_SELECT1] drawInRect:&rect];		
	else
		[[textureManager texture:TEXTURE_GAME_SELECT2] drawInRect:&rect];		
	
	// Draw the arrow now.
	if (touchWay == kTouchWayPosX) {
		CGPoint pt = CGPointMake(xCell * kGamePieceSize + kGamePieceSize, 32 + yCell * kGamePieceSize + kGamePieceSize / 2);
		[[textureManager texture:TEXTURE_GAME_ARROW] drawAtPoint:pt rotate:90];
	} else if (touchWay == kTouchWayNegX) {
		CGPoint pt = CGPointMake(xCell * kGamePieceSize, 32 + yCell * kGamePieceSize + kGamePieceSize / 2);
		[[textureManager texture:TEXTURE_GAME_ARROW] drawAtPoint:pt rotate:-90];
	} else if (touchWay == kTouchWayPosY) {
		CGPoint pt = CGPointMake(xCell * kGamePieceSize + 32, 32 + yCell * kGamePieceSize + kGamePieceSize);
		[[textureManager texture:TEXTURE_GAME_ARROW] drawAtPoint:pt rotate:180];
	} else if (touchWay == kTouchWayNegY) {
		CGPoint pt = CGPointMake(xCell * kGamePieceSize + 32, 32 + yCell * kGamePieceSize);
		[[textureManager texture:TEXTURE_GAME_ARROW] drawAtPoint:pt rotate:0];
	}
}

-(void) update {
	// No pieces are to be updated when flushing down.
	if (animateEndFlush) {
		[animateFlush update];
		
		// Animation is finished, the level message will show and now create a timer to view the message. Once the
		// timer goes off then notify level has been completed.
		if (!timerCreated && ![particleEngine aliveParticles]) {
			[self saveSettings];
			timerCreated = true;
			[NSTimer scheduledTimerWithTimeInterval:1.5 target:target selector:@selector(notifyGameMapCorrect) userInfo:nil repeats:0];
		}
		return;
	}
		
	// Update each game piece.
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		[piece update];
	}
	
	// Update the selection value.
	[animateSelect update];
	
	// Update the fade in value animation.
	if (animateFadeIn != nil) {
		[animateFadeIn update];
		if ([animateFadeIn isDone]) {
			[animateFadeIn release];
			animateFadeIn = nil;
		}
	}
}

-(bool) animateLevel {
	return false;
}

-(int) movementCount {
	return movementCounter;
}

- (void)onFingerDown: (TouchPoint *)touch {
	// No pieces are to be updated when flushing down.
	if (animateEndFlush)
		return;
	
	// Finger already down.
	if (touchPoint != nil)
		return;
	
	touchPoint = touch;
}

- (void)onFingerUp: (TouchPoint *)touch {
	// No long track the finger movement.
	if (touchPoint != nil) {
		if (touchPoint == touch)
			touchPoint = nil;
		else
			return; // Handle just one.
	}
	
	// No pieces are to be updated when flushing down.
	if (animateEndFlush)
		return;
	
	// See if movement is needed of the game pieces.
	[self doMovement: [touch getTouchDownPosition] ptTouchUp:[touch getTouchPosition]];
}

- (void) doMovement: (CGPoint) ptTouchDown ptTouchUp:(CGPoint) ptTouchUp {
	// Can't determine until more distance is covered by the touch.
	if ([Utilites distance:&ptTouchDown pt2:&ptTouchUp] < kDetermineDirection)
		return;
	
	// Get the touch's down cell.
	int xCell = ptTouchDown.x / kGamePieceSize;
	int yCell = (ptTouchDown.y - 32) / kGamePieceSize;
	
	// Next determine which quaderant the touch is going.
	int movementWise;
	float deltaX = ptTouchUp.x - ptTouchDown.x;
	float deltaY = ptTouchUp.y - ptTouchDown.y;
	int touchWay;
	if (abs(deltaX) >= abs(deltaY)) {
		// In x direction.
		if (deltaX > 0) {
			touchWay = kTouchWayPosX;
			movementWise = kClockwise;
		} else {
			touchWay = kTouchWayNegX;
			movementWise = kCounterClockwise;
		}
	} else {
		// In y direction.
		if (deltaY > 0) {
			touchWay = kTouchWayPosY;
			movementWise = kCounterClockwise;
		} else {
			touchWay = kTouchWayNegY;
			movementWise = kClockwise;
		}
	}
	
	// If trying to move piece off board then cancel movement.
	if (touchWay == kTouchWayPosX && xCell == (kGameBoardMaxX-1))
		return;
	if (touchWay == kTouchWayNegX && xCell == 0)
		return;
	if (touchWay == kTouchWayPosY && yCell == (kGameBoardMaxY-1))
		return;
	if (touchWay == kTouchWayNegY && yCell == 0)
		return;
	
	// This is the top-left cell which will be Quadarant II on a graph.
	int xPivotCell = xCell;
	int yPivotCell = yCell;
	
	// If on the positive edges then minus one to the pivot cells.
	if (xCell == (kGameBoardMaxX-1) && touchWay == kTouchWayPosY) {
		movementWise = kClockwise;
		xPivotCell--;
	}
	if (xCell == (kGameBoardMaxX-1) && touchWay == kTouchWayNegY) {
		movementWise = kCounterClockwise;
		xPivotCell--;
	}
	if (yCell == (kGameBoardMaxY-1) && touchWay == kTouchWayPosX) {
		movementWise = kCounterClockwise;
		yPivotCell--;
	}
	if (yCell == (kGameBoardMaxY-1) && touchWay == kTouchWayNegX) {
		movementWise = kClockwise;
		yPivotCell--;
	}
	
	
	if (touchWay == kTouchWayNegX) {
		xPivotCell--;
	} else if (touchWay == kTouchWayNegY) {
		yPivotCell--;
	}
	
	// Game pieces that will be moved.
	GamePiece *piece1 = [self getGamePiece:xPivotCell yCell:yPivotCell];
	GamePiece *piece2 = [self getGamePiece:(xPivotCell+1) yCell:yPivotCell];
	GamePiece *piece3 = [self getGamePiece:(xPivotCell+1) yCell:(yPivotCell+1)];
	GamePiece *piece4 = [self getGamePiece:xPivotCell yCell:(yPivotCell+1)];
	
	// Verify pieces are currently not being moved.
	if ([piece1 isMoving] || [piece2 isMoving] || [piece3 isMoving] || [piece4 isMoving])
		return;	
	
	// Perform movement of pieces.
	if (movementWise == kClockwise)
		[piece1 doAnimateMovement:kAnimationMovementXPos animateClockwise:true];
	else 
		[piece1 doAnimateMovement:kAnimationMovementYPos animateClockwise:false];
	
	if (movementWise == kClockwise)
		[piece2 doAnimateMovement:kAnimationMovementYPos animateClockwise:true];
	else 
		[piece2 doAnimateMovement:kAnimationMovementXNeg animateClockwise:false];
	
	if (movementWise == kClockwise)
		[piece3 doAnimateMovement:kAnimationMovementXNeg animateClockwise:true];
	else 
		[piece3 doAnimateMovement:kAnimationMovementYNeg animateClockwise:false];
	
	if (movementWise == kClockwise)
		[piece4 doAnimateMovement:kAnimationMovementYNeg animateClockwise:true];
	else 
		[piece4 doAnimateMovement:kAnimationMovementXPos animateClockwise:false];
	
	// Tag this piece as the finger movement one.
	[[self getGamePiece:xCell yCell:yCell] setTagAsFingerMovement:true];
	
	
	// User moved!
	movementCounter++;	
}

- (GamePiece *) getGamePiece: (int) xCell yCell:(int)yCell {	
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		if ([piece isCell: xCell yCell:yCell])
			return piece;
	}		
	return nil;
}

-(void) gamePiecesToParticles {
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		[piece toParticleSwirl:particleEngine];
	}
}

-(void) setAllPiecesInvisible {
}

-(void)setTarget:(id<GameMapTarget>)_target {
	target = _target;
}

-(bool)boardComplete {
	for (int y=0; y < kGameBoardMaxY; y++) {
		for (int x=0; x < kGameBoardMaxX; x++) {
			CorrectCell *cell = correctBoard[y][x];
			if (![cell isCorrect])
				return false;
		}
	}
	
	return true;
}

-(void) setTextureType: (int)textureType {
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		[piece setTextureType:textureType];
	}
}

-(void) setGamePieceCorrect: (GamePiece *)piece {
	int xCell = [piece xCell];
	int yCell = [piece yCell];
	CorrectCell *cell = correctBoard[yCell][xCell];
	if ([cell isGamePieceCorrect:piece]) {
		[piece setTransparency:0.2];
		[piece setCorrectCell:true];
		[piece createParticleEffect:particleEngine];
		[piece doAnimate360rotate];	
		
		// Notify correct cell about game piece.
		[cell setGamePiece:piece];
	}
}

// Protocol GamePieceTarget ///////////////////////////////////////////////////////////////////////////////////////////////

-(void) notifyDoneAnimationMovement: (GamePiece *)piece {
	bool tagPiece = [piece tagAsFingerMovement];
	[piece setTagAsFingerMovement:false];
	if (tagPiece)
		[piece playSound];
	
	// Check to see if game piece is at correct place.
	int xCell = [piece xCell];
	int yCell = [piece yCell];
	CorrectCell *cell = correctBoard[yCell][xCell];
	if (![cell isGamePieceCorrect:piece])
		return;
	
	// Since piece is in correct place, perform animations, particle effects, and changes in the game piece.
	[self setGamePieceCorrect: piece];
	
	// check for a board complete and if so then begin flush animation.
	if ([self boardComplete]) {
		animateEndFlush = true;
		[self determineMessageForPlayer];	
		animateFlush = [[[AnimationVariable alloc] initAnimation:0.0 toValue:1.0 step:.05 forever:false] retain];
		[self gamePiecesToParticles];		
		[soundManager playsound:SOUND_GAME_TWIRL_IN];	
	}
}

-(void) determineMessageForPlayer {
	// 5 good messages.
	// 3 ok messages. just ok, great job, good job. 
	// 3 bad messages.
	int delta = 1;
	
	if (distanceToComplete < 20)
		delta = 1;
	else if (distanceToComplete < 50)
		delta = 4;
	else if (distanceToComplete < 100)
		delta = 6;
	else if (distanceToComplete < 150)
		delta = 7;
	else if (distanceToComplete < 200) {
		distanceToComplete = 150;
		delta = 7;
	}
	
	// There are 4 levels.
	int levelPicked = 0;
	
	if (movementCounter < (distanceToComplete - (delta * 5)))
		levelPicked = 4;
	else if (movementCounter <= (distanceToComplete - delta))
		levelPicked = 3;
	else if (movementCounter < (distanceToComplete + delta * 4))
		levelPicked = 2;
	else 
		levelPicked = 1;

	if (levelPicked == 4) {
		if ((movementCounter % 2) == 0)
			textureIdForMessage = TEXTURE_MESS_DEVELOPER_IMPRESSED;
		else
			textureIdForMessage = TEXTURE_MESS_HOWD_YOU_DO_THAT;
	} else if (levelPicked == 3) {
		int choose = movementCounter % 4;
		if (choose == 0)
			textureIdForMessage = TEXTURE_MESS_SMARTY_PANTS;
		else if (choose == 1)
			textureIdForMessage = TEXTURE_MESS_INCREDIBLE;
		else if (choose == 2)
			textureIdForMessage = TEXTURE_MESS_A_GENIUS_HERE;
		else if (choose == 3)
			textureIdForMessage = TEXTURE_MESS_IQ1;
	} else if (levelPicked == 2) {
		int choose = movementCounter % 3;
		if (choose == 0)
			textureIdForMessage = TEXTURE_MESS_SKILLFULYOUARE;
		else if (choose == 1)
			textureIdForMessage = TEXTURE_MESS_GOOD_JOB;
		else if (choose == 2)
			textureIdForMessage = TEXTURE_MESS_MOVINONUP;
	} else {
		int choose = movementCounter % 3;
		if (choose == 0)
			textureIdForMessage = TEXTURE_MESS_WHAT_WHERE_YOU_THINKING;
		else if (choose == 1)
			textureIdForMessage = TEXTURE_MESS_KEEPTRYING;
		else if (choose == 2)
			textureIdForMessage = TEXTURE_MESS_DONT_QUIT_DAY_JOB;
	}
}

// END Protocol GamePieceTarget ///////////////////////////////////////////////////////////////////////////////////////////


- (void)saveSettings {
	if (movementCounter > recordCounter && recordCounter != 0)
		return;
	
	NSString *key = [NSString stringWithFormat:@"%@%d", setName, level];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:movementCounter]] forKey:key];
}

- (void)loveSettings {
	
	NSString *key = [NSString stringWithFormat:@"%@%d", setName, level];
	
	// Create the dictionary with default values.
	NSMutableDictionary *resourceDict = [[NSMutableDictionary dictionaryWithCapacity:0] init];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:0]] forKey:key];
	 
	// Register the defaults if they don't exist.
	[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	 
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	recordCounter = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:key]] intValue]; 	 
}

- (void)saveSettingsGamePieces {
	// Save each game piece position and type.
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		[piece saveSettings:i];
	}
	
	// Save the movement counter.	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:movementCounter]] forKey:kKeyMovementCounter];
}

- (void)loadSettingsGamePieces: (int)setIcon {
	for (int i=0; i < kGameBoardPieces; i++) {
		GamePiece *piece = gameBoard[i];
		[piece loveSettings:i textureType:setIcon];
		
		int xCell = [piece xCell];
		int yCell = [piece yCell];
		CorrectCell *cell = correctBoard[yCell][xCell];
		if ([cell isGamePieceCorrect:piece]) {
			[self setGamePieceCorrect: piece];
		}		
	}

	// Restore the movement counter.
	
	// Create the dictionary with default values.
	NSMutableDictionary *resourceDict = [[NSMutableDictionary dictionaryWithCapacity:0] init];
	[resourceDict setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInt:777]] forKey:kKeyMovementCounter];
	
	// Register the defaults if they don't exist.
	[[NSUserDefaults standardUserDefaults] registerDefaults:resourceDict];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	movementCounter = [[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:kKeyMovementCounter]] intValue];
}

@end

