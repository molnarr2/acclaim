//
//  Utilites.m
//  ColorSeek
//
//  Created by Robert Molnar 2 on 9/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Utilites.h"

Range RangeMake(int start, int end) {
	Range r;
	r.start = start;
	r.end = end;
	return r;
}

@implementation Utilites

+(BOOL)isPointInRect:(CGRect *)rect point:(CGPoint *)pt {
	if ((pt->x >= rect->origin.x && pt->x < (rect->origin.x + rect->size.width))
		&& (pt->y >= rect->origin.y && pt->y < (rect->origin.y + rect->size.height)))
		return TRUE;
	return FALSE;
}

+(float)distance:(CGPoint *)pt1 pt2:(CGPoint *)pt2 {
	return sqrt((pt1->x - pt2->x) * (pt1->x - pt2->x) + (pt1->y - pt2->y) * (pt1->y - pt2->y));
}

+(float)distance:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 {
	return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}

@end
