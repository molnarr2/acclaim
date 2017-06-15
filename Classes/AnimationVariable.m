//
//  AnimationVariable.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AnimationVariable.h"


@implementation AnimationVariable


-(id) initAnimation: (float)_fromValue toValue:(float)_toValue step:(float)_step forever:(bool)forever {
	self = [super init];
	fromValue = _fromValue;
	toValue = _toValue;
	step = _step;
	if (forever)
		cycles = -1;
	else
		cycles = 1;
	value = _fromValue;
	done = false;
	direction = true;
	
	if (_fromValue > _toValue) {
		float tmp = _toValue;
		toValue = _fromValue;
		fromValue = tmp;
		value = toValue;
		direction = false;
	}
	
	[self autorelease];	
	return self;
}	

-(void) update {
	if (done)
		return;
	if (direction) {
		value += step;
		if (value >= toValue) {
			if (cycles != -1) {
				cycles--;
				if (cycles == 0) {
					value = toValue;
					done = true;
				}
			}
			direction = false;
		}
	} else {
		value -= step;
		if (value <= fromValue) {
			if (cycles != -1) {
				cycles--;
				if (cycles == 0) {
					value = toValue;
					done = true;
				}
			}
			direction = true;
		}
	}
}

- (void)dealloc {
	[super dealloc];
}

- (float) value {
	return value;
}

- (bool) isDone {
	return done;
}

@end
