//
//  Utilites.h
//  ColorSeek
//
//  Created by Robert Molnar 2 on 9/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

struct Range {
    int start;
    int end;
};
typedef struct Range Range;

Range RangeMake(int, int);


@interface Utilites : NSObject {

}

/** This will see if the point is inside the rectangle.
 * @param rect is the rectangle to see if the point is inside.
 * @param pt is the point to see if it is in the rectangle.
 * @return TRUE if pt is inside rect, else false it is not.
 */
+(BOOL)isPointInRect:(CGRect *)rect point:(CGPoint *)pt;

/** This will get the distance between two points.
 * @return the distance between the two points.
 */
+(float)distance:(CGPoint *)pt1 pt2:(CGPoint *)pt2;

/** This will get the distance between two points.
 * @return the distance between the two points.
 */
+(float)distance:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;

@end
