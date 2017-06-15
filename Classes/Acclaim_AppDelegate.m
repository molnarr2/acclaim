//
//  Acclaim_AppDelegate.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/2/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Acclaim_AppDelegate.h"
#import "Acceleration.h"

#define kFilteringFactor			0.1 // For filtering out gravitational affects
#define kAccelerometerFrequency		30 // Hz

@implementation Acclaim_AppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	//Create a full-screen window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setBackgroundColor:[UIColor blackColor]];
	
	//Configure and start accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];	
	
	// Get a handle on the application.
	glb_Application = application;
	
	// Setup the texture manager.
	textureManager = [[[TextureManager alloc] initManager] retain];
	
	// Start up the SuperView.
	superView = [[SuperView alloc] initWithFrame:[window frame]];
	[window addSubview:superView];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[superView applicationWillTerminate];
}

- (void)dealloc {
    [window release];
    [super dealloc];
	[superView release];	
}

// Implement this method to get the lastest data from the accelerometer 
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	//Use a basic low-pass filter to only keep the gravity in the accelerometer values
	globalAccelerometer[0] = acceleration.x * kFilteringFactor + globalAccelerometer[0] * (1.0 - kFilteringFactor);
	globalAccelerometer[1] = acceleration.y * kFilteringFactor + globalAccelerometer[1] * (1.0 - kFilteringFactor);
	globalAccelerometer[2] = acceleration.z * kFilteringFactor + globalAccelerometer[2] * (1.0 - kFilteringFactor);	
}

@end
