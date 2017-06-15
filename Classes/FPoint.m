//
//  FPoint.m
//  Finger
//
//  Created by Robert Molnar 2 on 10/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FPoint.h"


@implementation FPoint

-(id) initPoint: (float) fx y: (float) fy {
	[super init];
	
	x = fx;
	y = fy;
	
	[self autorelease];
	
	return self;
}

-(bool) isHit: (float)fx y:(float)fy radius: (float) radius {
	float diffx = fx - x;
	float diffy = fy - y;
	
	if (diffx <= radius && diffx >= -radius && diffy <= radius && diffy >= -radius)
		return TRUE;
	return FALSE;
}

-(float) sqrDistance: (FPoint *)pt {
	return (x - pt->x) * (x - pt->x) + (y - pt->y) * (y - pt->y);
}

-(float) distance: (FPoint *)pt {
	return sqrt((x - pt->x) * (x - pt->x) + (y - pt->y) * (y - pt->y));
}

-(NSMutableArray *)sampleLine:(FPoint *)ptTo frequency:(int)frequency {
	float fx, fy;
	float sampling = 1.0 / frequency;
	float deltaX = ptTo->x - x;
	float deltaY = ptTo->y - y;
	
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:(frequency+1)];
	for (float t=0; t<= 1.0; t+=sampling) {
		fx = x + deltaX * t;
		fy = y + deltaY * t;
		
		[array addObject:[[FPoint alloc] initPoint:fx y:fy]];
	}
	
	[array removeLastObject];
	[array addObject:[[FPoint alloc] initPoint:ptTo->x y:ptTo->y]];
	
	return array;
}

@end