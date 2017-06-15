//
//  GameScreen.h
//  Finger
//
//  Created by Robert Molnar 2 on 10/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EAGLView.h"
#import "TouchPoint.h"
#import "Game.h"

//CONSTANTS:

#define kBrushOpacity		(1.0 / 3.0)
#define kBrushPixelStep		3
#define kBrushScale			2
#define kLuminosity			0.75
#define kSaturation			1.0

// Maximum number of touches.
#define kTouchMax			5

//CLASS INTERFACES:

@interface GameScreen : EAGLView
{
	Game *game;
	TouchPoint *touchPts[kTouchMax];
	
	GLuint			    brushTexture;
	GLuint				drawingTexture;
	GLuint				drawingFramebuffer;
	CGPoint				location;
	CGPoint				previousLocation;
	Boolean				firstTouch;
}
@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;
@property(readonly) Game *game;

// Called to create the frame.
- (id) initWithFrameLoadRestore:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame setId:(int)_setId;
- (id)initWithFrame:(CGRect)frame;

// Called to erase the screen.
- (void) erase;

// This is called when a view will remove itself from this view.
- (void)willRemoveSubview:(UIView *)subview;

// This will get the game variable.
// @return the game variable.
-(Game *)game;

-(void)setBrush: (NSString *)brushName;

@end