//
//  TouchPoint.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TouchPoint.h"


@implementation TouchPoint

-(id) initTouch: (UITouch *) _touch {
	self = [super init];
	touch = _touch;

	ptDown = [touch locationInView:nil];
	
	[self autorelease];	
	return self;	
}

-(CGPoint) getTouchDownPosition {
	return ptDown;
}

-(CGPoint) getTouchPosition {
	return [touch locationInView:nil];
}

-(bool) isTouch: (UITouch *)_touch {
	if (touch == _touch)
		return true;
	return false;
}

@end
