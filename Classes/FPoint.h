//
//  FPoint.h
//  Finger
//
//  Created by Robert Molnar 2 on 10/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// This is used to represent a point.
@interface FPoint : NSObject {
	
@public
	float x;
	float y;
	
}

// This will set the point with a x,y value.
-(id) initPoint: (float) fx y: (float) fy;

// This will see if the point pt is within the radius of the x,y value within this class.
// @param fx is the x value.
// @param fy is the y value.
// @param radius is the radius from the x,y value within this class.
// @return true if pt is within the radius of the x,y value within this class, else false the pt is not close enough to the x,y value.
-(bool) isHit: (float)fx y:(float)fy radius: (float) radius;

// This will get the square distance from pt to this point. The formula is (x1 - x2)^2 + (y1 - y2)^2.
// @param pt is the point.
// @return the square distance from pt to this point.
-(float) sqrDistance: (FPoint *)pt;

// This is will get the distance from pt to this point.
// @param pt is the point.
// @return the distance from pt to this point.
-(float) distance: (FPoint *)pt;

// This will sample a line between this line and to the 'ptTo' point.
// @param ptTo is the point to sample to.
// @param frequency is the number of samplings to take. The start and end points are in the sampling.
// @return a list of FPoint with the count of frequency.
-(NSMutableArray *)sampleLine:(FPoint *)ptTo frequency:(int)frequency;

@end