//
//  Maps.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/5/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Maps : NSObject {
	NSMutableArray *sets;
}

// @return array of SetInfo.
-(NSMutableArray *)getSets;

@end
