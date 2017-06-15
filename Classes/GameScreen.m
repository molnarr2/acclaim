//
//  GameScreen.m
//  Finger
//
//  Created by Robert Molnar 2 on 10/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GameScreen.h"


@implementation GameScreen

@synthesize  location;
@synthesize  previousLocation;

@synthesize game;

- (id) initWithFrameLoadRestore:(CGRect)frame {
	[self initWithFrame: frame];
	
	// Initialize the game.
	game = [[[Game alloc] initGameLoadPrevious: self] retain];		
	
	return self;
}

- (id)initWithFrame:(CGRect)frame setId:(int)_setId {
	[self initWithFrame: frame];
	
	// Initialize the game.
	game = [[[Game alloc] initGame: self setId:_setId] retain];		
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {	
	if((self = [super initWithFrame:frame pixelFormat:GL_RGB565_OES depthFormat:0 preserveBackbuffer:YES])) {
        // Initialization code
		[self setMultipleTouchEnabled:YES];
		[self setCurrentContext];			
		
		//Make sure to start with a cleared buffer
		[self erase];		
		
		// Finger touches.
		memset (touchPts, 0, sizeof(touchPts));
		
		// Set up OpenGL.
		glDisable(GL_DITHER);
		glMatrixMode(GL_PROJECTION);
		glOrthof(0, 320, 480, 0, -1, 1);
		glMatrixMode(GL_MODELVIEW);
		
		//Initialize OpenGL states
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_TEXTURE_2D);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
		
		for (int i=0; i < kTouchMax; i++)
			touchPts[i] = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	[game draw];
}


- (void)dealloc {
	[textureManager reset];
	[game release];
    [super dealloc];
}


- (void)willRemoveSubview:(UIView *)subview {
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	
	// Find a touch that isn't being used.
	while ((touch = [enumerator nextObject])) {
		for (int i=0; i < kTouchMax; i++) {
			if (touchPts[i] == nil) {
				touchPts[i] = [[[TouchPoint alloc] initTouch:touch] retain];
				[game onFingerDown:touchPts[i]];
				break;
			}
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSEnumerator *enumerator = [touches objectEnumerator];
	UITouch *touch;
	
	// Find the touch that corresponds to the stored touch.
	while ((touch = [enumerator nextObject])) {		
		for (int i=0; i < kTouchMax; i++) {
			if (touchPts[i] != nil && [touchPts[i] isTouch:touch]) {
				[game onFingerUp:touchPts[i]];
				[touchPts[i] release];
				touchPts[i] = nil;
				break;
			}
		}
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}

-(Game *)game {
	return game;
}

// Erases the screen
- (void) erase
{
	//Clear the buffer
	glClear(GL_COLOR_BUFFER_BIT);
	
	//Display the buffer
	[self swapBuffers];
}

-(void)setBrush: (NSString *)brushName {
	CGImageRef		brushImage;
	CGContextRef	brushContext;
	GLubyte			*brushData;
	size_t			width, height;	
	// Create a texture from an image
	// First create a UIImage object from the data in a image file, and then extract the Core Graphics image
	brushImage = [UIImage imageNamed:brushName].CGImage;
	
	// Get the width and height of the image
	width = CGImageGetWidth(brushImage);
	height = CGImageGetHeight(brushImage);
	
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
	
	// Make sure the image exists
	if(brushImage) {
		// Allocate  memory needed for the bitmap context
		brushData = (GLubyte *) malloc(width * height * 4);
		// Use  the bitmatp creation function provided by the Core Graphics framework. 
		brushContext = CGBitmapContextCreate(brushData, width, width, 8, width * 4, CGImageGetColorSpace(brushImage), kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the  image to the context.
		CGContextDrawImage(brushContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), brushImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(brushContext);
		// Use OpenGL ES to generate a name for the texture.
		glGenTextures(1, &brushTexture);
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, brushTexture);
		// Specify a 2D texture image, providing the a pointer to the image data in memory
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, brushData);
		// Release  the image data; it's no longer needed
		free(brushData);		
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		
		// Enable use of the texture
		glEnable(GL_TEXTURE_2D);
		// Set a blending function to use
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		// Enable blending
		glEnable(GL_BLEND);
	}
}

@end
