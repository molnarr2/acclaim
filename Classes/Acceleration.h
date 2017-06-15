/*
 *  Acceleration.h
 *  Finger
 *
 *  Created by Robert Molnar 2 on 11/10/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

// This contains real time data of the accelerometer. It is updated by the FingerAppDelegate. X,Y,Z values.
// The values look to be between -2.0 to 2.0. A 1.0 is stationary in that direction, although in my testing it seems 1.1 or 1.2 could be.
float globalAccelerometer[3];