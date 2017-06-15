//
//  Acclaim_AppDelegate.h
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextureManager.h"
#import "SuperView.h"
#import "Global.h"
#import "Acceleration.h"

@interface Acclaim_AppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate> {
    UIWindow *window;
	SuperView *superView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

