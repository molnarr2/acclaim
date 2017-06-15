//
//  TextureManager.h
//  Tornado
//
//  Created by Robert Molnar 2 on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Texture2D.h"
#import "ResourceIds.h"

// The one and only.
@class TextureManager;
TextureManager *textureManager;

@interface TextureManager : NSObject {
	Texture2D *array[MAX_TEXTURE_ARRAY];
}

-(void)dealloc;

-(TextureManager *) initManager;

-(Texture2D *)texture: (int) textureId;

-(void)_loadTexture: (int) textureId;

// This will reset the TextureManager to reload the images.
-(void)reset;

// This will use the 80x32_digits bitmap to draw a number at the point pt using the height.
// @param pt is the upper-left position to start to draw the number.
// @param height is the height for the numbers to be drawn. Pass in -1 to use native value of number.
// @param number is the number to be drawn.
-(void)digits16_drawNumberAtPoint: (CGPoint)pt height:(float)height number:(int)number;

// @returns 1,10,100,1000, 10000, etc.. the largest one that can fit inside of number.
-(int)_digits16_getLargestDivide: (int) number;

// @return the texture coordinates for the digit.
-(CGRect)_digits16_textureCoordinates: (int) digit;

@end
