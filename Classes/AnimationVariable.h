//
//  AnimationVariable.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// This is used to animate a variable.
@interface AnimationVariable : NSObject {
	float value;
	float fromValue;
	float toValue;
	float step;
	float cycles;
	bool done;
	// This is the direction. true if going from 'from' to 'to', else false if going from 'to' to 'from'.
	bool direction;
}

/** Initalize Resize Animation back and forth.
  * @param _fromValue is the starting value.
  * @param _toValue is the ending value.
  * @param _step is the step value added when update is called.
  * @param forever is true if the value should go from 'from' to 'to' forever.
 */
-(id) initAnimation: (float)_fromValue toValue:(float)_toValue step:(float)_step forever:(bool)forever;

// Called each frame to up.
-(void) update;

// Called when shutting down.
- (void)dealloc;

// @return the current animation value.
- (float) value;

// @return true if animation is done.
- (bool) isDone;

@end
