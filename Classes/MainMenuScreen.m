//
//  MainMenuScreen.m
//  Acclaim!
//
//  Created by Robert Molnar 2 on 12/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScreen.h"

#define PAGE_MAIN 1
#define PAGE_HELP 2
#define PAGE_MOREAPPS 3
#define PAGE_LEVEL 4
#define PAGE_RESTORE 5

// USed by the animateTo variable.
#define kAnimateTowardNone 0
#define kAnimateTowardLevels 1
#define kAnimateTowardHelp 2
#define kAnimateTowardMoreApps 3
#define kAnimateTowardMainFromLevels 4
#define kAnimateTowardMainFromHelp 5
#define kAnimateTowardMainFromMoreApps 6
#define kAnimateTowardMainFromRestore 7

// Level information.
#define MAX_LEVEL_PAGES 2
LevelTextureIds levelinfo[MAX_LEVEL_PAGES];

#define kAnimateToSpeed 25

// Points used to represent the Acclaim! bubbles.
CGPoint acclaimPts[] = {
{7, 171}, {8, 159}, {10, 147}, {11, 135}, {12, 124}, {13, 113}, {14, 102}, {15, 91}, {16, 80}, {17, 71}, {18, 61}, {19, 50}, {20, 40}, {21, 29}, {24, 20}, {27, 30}, {29, 41}, {30, 52}, {31, 63}, {32, 73}, {33, 85}, {34, 94}, {35, 106}, {36, 116}, 
{36, 116}, {25, 114}, {13, 113}, 
{36, 116}, {38, 126}, {39, 137}, {40, 147}, {41, 157}, {43, 168}, 
{84, 93}, {84, 82}, {83, 72}, {79, 62}, {72, 66}, {68, 76}, {65, 87}, {63, 99}, {62, 110}, {62, 121}, {62, 132}, {63, 144}, {64, 154}, {67, 165}, {73, 174}, {81, 167}, {84, 156}, {86, 146}, 
{123, 92}, {123, 81}, {122, 71}, {118, 61}, {110, 65}, {106, 75}, {104, 86}, {102, 98}, {101, 109}, {101, 120}, {101, 131}, {101, 143}, {103, 153}, {106, 164}, {112, 173}, {120, 166}, {123, 155}, {124, 145}, 
{172, 82}, {174, 70}, {177, 59}, {185, 61}, {188, 72}, {189, 84}, {190, 104}, {183, 112}, {176, 119}, {168, 128}, {167, 139}, {167, 150}, {167, 161}, {173, 173}, {183, 168}, {189, 157}, 
{189, 157}, {189, 146}, {189, 135}, {189, 125}, {189, 113}, {190, 104}, 
{189, 157}, {194, 176}, 
{144, 18}, {144, 29}, {144, 40}, {144, 50}, {144, 62}, {144, 72}, {144, 83}, {144, 93}, {144, 103}, {144, 115}, {144, 126}, {144, 137}, {144, 148}, {144, 159}, {144, 170}, 
{214, 4}, {214, 20}, 
{242, 174}, {242, 163}, {242, 153}, {242, 142}, {242, 131}, {242, 121}, {242, 110}, {242, 99}, {242, 89}, {242, 79}, 
{242, 79}, {242, 68}, {243, 56}, 
{242, 79}, {247, 69}, {253, 60}, {262, 63}, {266, 72}, 
{266, 72}, {270, 63}, {277, 57}, {282, 65}, {285, 75}, {286, 84}, {286, 95}, {286, 105}, {286, 115}, {286, 125}, {286, 135}, {286, 145}, {286, 155}, {286, 166}, {286, 175}, 
{266, 72}, {266, 83}, {266, 93}, {266, 103}, {266, 113}, {266, 123}, {266, 133}, {266, 143}, {266, 153}, {266, 164}, {266, 173}, 
{214, 63}, {214, 74}, {214, 85}, {214, 94}, {214, 104}, {214, 115}, {214, 124}, {214, 135}, {214, 145}, {214, 154}, {214, 165}, {214, 175}, 
{312, 108}, {312, 96}, {312, 86}, {312, 76}, {312, 65}, {312, 54}, {312, 44}, {312, 33}, {312, 23}, {312, 12}, 
{312, 179}, {312, 167}, {312, 157}, {311, 146}, {190, 95}};

int acclaimPtsSize = sizeof(acclaimPts) / sizeof(CGPoint);

@implementation MainMenuScreen

@synthesize gameMode;

- (id)initWithFrame:(CGRect)frame {
	
	if((self = [super initWithFrame:frame pixelFormat:GL_RGB565_OES depthFormat:0 preserveBackbuffer:YES])) {
        // Initialization code
		[self setMultipleTouchEnabled:YES];
		[self setCurrentContext];			
		
		//Make sure to start with a cleared buffer
		[self erase];		
		
		// Set up OpenGL.
		glDisable(GL_DITHER);
		glMatrixMode(GL_PROJECTION);
		glOrthof(0, 320, 480, 0, -1, 1);
		glMatrixMode(GL_MODELVIEW);
		
		//Initialize OpenGL states
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_TEXTURE_2D);
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		// This is the particle engine.
		particleEngine = [[[ParticleEngine alloc] initParticleEngine: 512] retain];	
		[self buildParticles];
		
		// Create the game loop timer.
		timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animation) userInfo:nil repeats:YES] retain];		
		oneSecond = [[NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(buildParticlesAcclaim) userInfo:nil repeats:YES] retain];		
		animate = true;
		animateTo = kAnimateTowardNone;
		
		animationResize = [[[AnimationVariable alloc] initAnimation:0.0 toValue:10.0 step:0.5 forever:true] retain];
		[self buildParticlesAcclaim];
		
		animationFade = nil;
		performFade = false;
		
		pageState = PAGE_MAIN;
		
		// Set up the areas that are pressable on each screen.
		rectMain.levels = CGRectMake(30, 250, 259, 52);
		rectMain.help = CGRectMake(30, 325, 259, 52);
		rectMain.moreApps = CGRectMake(30, 400, 259, 52);
		rectLevels.rects[0] = CGRectMake(30, 24, 259, 52);
		rectLevels.rects[1] = CGRectMake(30, 100, 259, 52);
		rectLevels.rects[2] = CGRectMake(30, 176, 259, 52);
		rectLevels.rects[3] = CGRectMake(30, 252, 259, 52);
		rectLevels.rects[4] = CGRectMake(30, 328, 259, 52);
		rectLevels.rects[5] = CGRectMake(30, 406, 259, 52);
		
		// Populate the level texture ids.
		levelinfo[0].textureId[0] = TEXTURE_LEVELS_SIMPLE;
		levelinfo[0].textureId[1] = TEXTURE_LEVELS_ALPHABET;
		levelinfo[0].textureId[2] = TEXTURE_LEVELS_WHATEVER;
		levelinfo[0].textureId[3] = TEXTURE_LEVELS_SYMMETRIC;
		levelinfo[1].textureId[0] = TEXTURE_LEVELS_MINDBENDER;

		// The areas to press for more apps.
		moreAppsSnatcher.origin.x = 208 + 12;
		moreAppsSnatcher.origin.y = 65 + 12;
		moreAppsTornado.origin.x = 208 + 12;
		moreAppsTornado.origin.y = 156 + 12;
		moreAppsSnatcher.size.width = moreAppsTornado.size.width = 74;
		moreAppsSnatcher.size.height = moreAppsTornado.size.height = 65;
		
		restoreNo.origin.x = 42 + 10;
		restoreNo.origin.y = 102 + 150;
		
		restoreYes.origin.x = 178 + 10;
		restoreYes.origin.y = 102 + 150;
		
		restoreYes.size.width = restoreNo.size.width = 85;
		restoreYes.size.height = restoreNo.size.height = 55;
	
		bRestoreGame = false;
		
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
}

-(void) erase {
	//Clear the buffer
	glClear(GL_COLOR_BUFFER_BIT);
	
	//Display the buffer
	[self swapBuffers];	
}

- (void)dealloc {
	[textureManager reset];
	[particleEngine release];
	[animationResize release];
	if (timer != nil)
		[timer release];
	if (oneSecond != nil)
		[oneSecond release];
	if (animationFade != nil)
		[animationFade release];
	if (animateToward != nil)
		[animateToward release];

    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint pt = [touch locationInView:self];
	bool touched = false;
	switch (pageState) {
		case PAGE_MAIN:
			touched = [self touchMain:pt];
			break; 
		case PAGE_HELP:
			touched = [self touchHelp:pt];
			break; 
		case PAGE_LEVEL:
			touched = [self touchLevel:pt];
			break; 
		case PAGE_MOREAPPS:
			touched = [self touchMoreApps:pt];
			break;
		case PAGE_RESTORE:
			touched = [self touchRestore:pt];
			break;
	}
}

-(bool) touchMain: (CGPoint) pt {
	if ([Utilites isPointInRect:&rectMain.levels point:&pt]) {
		float toValue = 320 - rectMain.levels.origin.x;
		animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
		animateTo = kAnimateTowardLevels;
		pageState = PAGE_LEVEL;
		levelPageIndex = 0;
		return true;
	} else if ([Utilites isPointInRect:&rectMain.help point:&pt]) {
		float toValue = 320 - rectMain.levels.origin.x;
		animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
		pageState = PAGE_HELP;
		animateTo = kAnimateTowardHelp;
		helpPage = 1;
		return true;
	} else if ([Utilites isPointInRect:&rectMain.moreApps point:&pt]) {
		float toValue = 320 - rectMain.levels.origin.x;
		animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
		pageState = PAGE_MOREAPPS;
		animateTo = kAnimateTowardMoreApps;
		return true;
	}
	
	return false;
}

-(bool) touchHelp: (CGPoint) pt {
	if (helpPage == 1)
		helpPage = 2;
	else if (helpPage == 2)
		helpPage = 3;
	else if (helpPage == 3)
		helpPage = 4;
	else {
		float toValue = 320 - rectMain.levels.origin.x;
		animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
		animateTo = kAnimateTowardMainFromHelp;
		pageState = PAGE_MAIN;
		return true;
	}
	
	return true;
}

-(bool) touchLevel: (CGPoint) pt {		
	// The 4 level buttons.
	for (int i=0; i < 4; i++) {
		// Not a level button.
		if (![Utilites isPointInRect:&rectLevels.rects[i] point:&pt])
			continue;
		
		// User wants to enter game. Fade.
		performFade = true;
		animationFade = [[[AnimationVariable alloc] initAnimation:0.0 toValue:1.0 step:0.05 forever:false] retain];	
		gameMode = levelinfo[levelPageIndex].textureId[i] - 100;
		return true;
	}
	
	// More button.
	if ([Utilites isPointInRect:&rectLevels.rects[4] point:&pt]) {
		levelPageIndex++;
		
		if (levelPageIndex == MAX_LEVEL_PAGES)
			levelPageIndex = 0;
		return true;
	}
	
	// Main Menu.
	if ([Utilites isPointInRect:&rectLevels.rects[5] point:&pt]) {
		float toValue = 320 - rectMain.levels.origin.x;
		animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
		animateTo = kAnimateTowardMainFromLevels;
		pageState = PAGE_MAIN;
		return true;
	}

	return false;
}

-(bool) touchMoreApps: (CGPoint) pt {

	// Snatcher
	if ([Utilites isPointInRect:&moreAppsSnatcher point:&pt]) {
		[glb_Application openURL:[[NSURL alloc] initWithString:@"itms://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=293070868&mt=8"]];
		return false;
	}
	
	// Tornado
	if ([Utilites isPointInRect:&moreAppsTornado point:&pt]) {
		[glb_Application openURL:[[NSURL alloc] initWithString:@"itms://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=298541035&mt=8"]];
		return false;
	}

	// Return to main menu.
	float toValue = 320 - rectMain.levels.origin.x;
	animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
	animateTo = kAnimateTowardMainFromMoreApps;
	pageState = PAGE_MAIN;
	return true;
}

-(bool) touchRestore: (CGPoint)pt {	
	// No
	if ([Utilites isPointInRect:&restoreNo point:&pt]) {
		float toValue = 320 - rectMain.levels.origin.x;
		animateToward = [[[AnimationVariable alloc] initAnimation:0.0 toValue:toValue step:kAnimateToSpeed forever:false] retain];
		animateTo = kAnimateTowardMainFromRestore;
		pageState = PAGE_MAIN;
		return true;
	}
	
	// Yes
	if ([Utilites isPointInRect:&restoreYes point:&pt]) {
		performFade = true;
		animationFade = [[[AnimationVariable alloc] initAnimation:0.0 toValue:1.0 step:0.05 forever:false] retain];	
		bRestoreGame = true;
		return true;
	}
	
	return false;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)animation {
	CGRect bounds;
	
	// No more animation of the menu system.
	if (animate == false)
		return;

	
	// Perform the fade into the game.
	if (performFade && [animationFade isDone]) {		
			animate = false;
			[timer invalidate];
			[oneSecond invalidate];
			[self removeFromSuperview];
			return;
		}
		
	// Update the animation variables.	
	[animationResize update];
	if (animationFade != nil)
		[animationFade update];
	if (animateToward != nil)
		[animateToward update];
	
	// Background.
	glDisable(GL_BLEND);
	glColor4f(0.0, 0.0, 0.0, 1);
	bounds.size.width = 320;
	bounds.size.height = 480;
	bounds.origin.x = 0;
	bounds.origin.y = 0;
	[[textureManager texture:TEXTURE_GAME_SOLIDBLACK] drawInRect:&bounds];
	
	// Particle System.
	glEnable(GL_BLEND);
	[particleEngine update];
	[particleEngine draw];

	// Perform animation of switching between screens.
	// Done animating.
	if (animateToward != nil && [animateToward isDone]) {
		animateTo = kAnimateTowardNone;
		[animateToward release];
		animateToward = nil;
	}
	
	// Perform animation of switching between screens.
	if (animateTo != kAnimateTowardNone) {
		switch (animateTo) {
			case kAnimateTowardHelp:
				[self animationMain: [animateToward value]];
				[self animationHelp: [animateToward value]-290];
				break;
			case kAnimateTowardMoreApps:
				[self animationMain: [animateToward value]];
				[self animationMoreApps: [animateToward value]-290];
				break;
			case kAnimateTowardLevels:
				[self animationMain: [animateToward value]];
				[self animationLevels: [animateToward value]-290];
				break;
			case kAnimateTowardMainFromLevels:
				[self animationLevels: [animateToward value]];
				[self animationMain: [animateToward value]-290];
				break;
			case kAnimateTowardMainFromHelp:
				[self animationHelp: [animateToward value]];
				[self animationMain: [animateToward value]-290];
				break;
			case kAnimateTowardMainFromMoreApps:
				[self animationMoreApps: [animateToward value]];
				[self animationMain: [animateToward value]-290];
				break;
			case kAnimateTowardMainFromRestore:
				[self animationRestore: [animateToward value]];
				[self animationMain: [animateToward value]-290];
				break;
		}				
	} else {
		// Place the menu items now.
		switch (pageState) {
			case PAGE_MAIN:
				[self animationMain: 0];
				break;
			case PAGE_HELP:
				[self animationHelp: 0];
				break;
			case PAGE_LEVEL:
				[self animationLevels: 0];
				break;
			case PAGE_MOREAPPS:
				[self animationMoreApps: 0];
				break;
			case PAGE_RESTORE:
				[self animationRestore: 0];
				break;
			default:
				break;
		}
	}
	
	// Perform the fade into the game.
	if (performFade) {		
		glColor4f(0.0, 0.0, 0.0, [animationFade value]);
		bounds.size.width = 320;
		bounds.size.height = 480;
		bounds.origin.x = 0;
		bounds.origin.y = 0;
		[[textureManager texture:TEXTURE_GAME_SOLIDBLACK] drawInRect:&bounds];
	}
	
	[self swapBuffers];
}

-(void)animationMain: (float) x_offset {
	CGRect bounds;
	
	// Draw the menu items.
	float resizeAnimation = [animationResize value];
	if (x_offset)
		resizeAnimation = 0;
	
	bounds.size.width = rectMain.levels.size.width - resizeAnimation;
	bounds.size.height = rectMain.levels.size.height;
	bounds.origin.x = x_offset + rectMain.levels.origin.x + resizeAnimation / 2;
	bounds.origin.y = rectMain.levels.origin.y;
	glColor4f(1.0, 1.0, 1.0, 0.8);
	[[textureManager texture:TEXTURE_MENU_LEVELS] drawInRect:&bounds];
	bounds.origin.y = rectMain.help.origin.y;
	[[textureManager texture:TEXTURE_MENU_HELP] drawInRect:&bounds];
	bounds.origin.y = rectMain.moreApps.origin.y;
	[[textureManager texture:TEXTURE_MENU_MOREAPPS] drawInRect:&bounds];
}
		
-(void)animationHelp: (float) x_offset {
	CGRect bounds;
	
	// Background.
	glColor4f(1.0, 1.0, 1.0, 0.9);
	bounds.size.width = 296;
	bounds.size.height = 456;
	bounds.origin.x = x_offset + 12;
	bounds.origin.y = 12;
	
	if (helpPage == 1)
		[[textureManager texture:TEXTURE_HELPPAGE1] drawInRect:&bounds];
	if (helpPage == 2)
		[[textureManager texture:TEXTURE_HELPPAGE2] drawInRect:&bounds];
	if (helpPage == 3)
		[[textureManager texture:TEXTURE_HELPPAGE3] drawInRect:&bounds];
	if (helpPage == 4)
		[[textureManager texture:TEXTURE_HELPPAGE4] drawInRect:&bounds];
	
}

-(void)animationLevels: (float) x_offset {
	CGRect bounds;
	
	// Draw the menu items.
	float resizeAnimation = [animationResize value];
	if (x_offset)
		resizeAnimation = 0;
	
	bounds.size.width = rectLevels.rects[0].size.width - resizeAnimation;
	bounds.size.height = rectLevels.rects[0].size.height;
	bounds.origin.x = x_offset + rectLevels.rects[0].origin.x + resizeAnimation / 2;
	bounds.origin.y = rectLevels.rects[0].origin.y;
	
	if (levelinfo[levelPageIndex].textureId[0] != -1) {
		glColor4f(1.0, 1.0, 1.0, 0.8);
		bounds.origin.y = rectLevels.rects[0].origin.y;
		[[textureManager texture:levelinfo[levelPageIndex].textureId[0]] drawInRect:&bounds];
	}
	
	if (levelinfo[levelPageIndex].textureId[1] != -1) {
		glColor4f(1.0, 1.0, 1.0, 0.8);
		bounds.origin.y = rectLevels.rects[1].origin.y;
		[[textureManager texture:levelinfo[levelPageIndex].textureId[1]] drawInRect:&bounds];
	}
	
	if (levelinfo[levelPageIndex].textureId[2] != -1) {
		glColor4f(1.0, 1.0, 1.0, 0.8);
		bounds.origin.y = rectLevels.rects[2].origin.y;
		[[textureManager texture:levelinfo[levelPageIndex].textureId[2]] drawInRect:&bounds];
	}
	
	if (levelinfo[levelPageIndex].textureId[3] != -1) {
		glColor4f(1.0, 1.0, 1.0, 0.8);
		bounds.origin.y = rectLevels.rects[3].origin.y;
		[[textureManager texture:levelinfo[levelPageIndex].textureId[3]] drawInRect:&bounds];
	}
	
	bounds.origin.y = rectLevels.rects[4].origin.y;
	glColor4f(1.0, 1.0, 1.0, 0.8);
	[[textureManager texture:TEXTURE_LEVELS_MORE] drawInRect:&bounds];
	
	bounds.origin.y = rectLevels.rects[5].origin.y;
	glColor4f(1.0, 1.0, 1.0, 0.8);
	[[textureManager texture:TEXTURE_LEVELS_MAINMENU] drawInRect:&bounds];
		
}

-(void)animationMoreApps: (float) x_offset {
	CGRect bounds;
	
	// Background.
	glColor4f(1.0, 1.0, 1.0, 0.9);
	bounds.size.width = 296;
	bounds.size.height = 456;
	bounds.origin.x = x_offset + 12;
	bounds.origin.y = 12;
	
	[[textureManager texture:TEXTURE_MOREAPPS] drawInRect:&bounds];
}

-(void)animationRestore: (float) x_offset {
	CGRect bounds;
	
	// Background.
	glColor4f(1.0, 1.0, 1.0, 0.9);
	bounds.size.width = 300;
	bounds.size.height = 180;
	bounds.origin.x = x_offset + 10;
	bounds.origin.y = 150;
	
	[[textureManager texture:TEXTURE_MES_RESTORE_GAME] drawInRect:&bounds];
}


-(void)buildParticles {
	
	for (int i=0; i < 100; i++) {
		// Create the particle.
		CGPoint position = CGPointMake(rand() % 300 + 10, rand() % 270 + 200);
		int particleId = [particleEngine startParticle:kParticleTypeTornado textureId:TEXTURE_PARTICLE_1 ptStart:position];
		if (particleId < 0)
			return;
	
		// Set the vector.
		CGPoint vector;
		vector.x = cos((float)i / 3.0);
		vector.y = sin((float)i / 3.0);
		[particleEngine setVector:particleId vector:vector];
		
		// Set life span.
		[particleEngine setLifeSpan:particleId lifespan:10000000];		
		
		float red = .1 + (float)(rand() % 90) / 90;
		float green = .1 + (float)(rand() % 90) / 90;
		float blue = .1 + (float)(rand() % 90) / 90;
		
		[particleEngine setColor:particleId red:red green:green blue:blue transparency:0.3];
		[particleEngine enableBounce:particleId];
 
	}
}

-(void)buildParticlesAcclaim {
	for (int i=0; i < acclaimPtsSize; i++) {		
		CGPoint position = CGPointMake(acclaimPts[i].x+2, acclaimPts[i].y+10);
		int particleId = [particleEngine startParticle:kParticleTypeTornado textureId:TEXTURE_PARTICLE_1 ptStart:position];
		if (particleId < 0)
			return;
		
		// Set the vector.
		CGPoint vector;
		vector.x = cos((float)i / 3.0) * 0.25;
		vector.y = sin((float)i / 3.0) * 0.25;
//		[particleEngine setVector:particleId vector:vector];
//		
		// Set life span.
		[particleEngine setLifeSpan:particleId lifespan:4];		
		
		float red = .5 + (float)(rand() % 50) / 50;
		float green = .5 + (float)(rand() % 50) / 50;
		float blue = .5 + (float)(rand() % 50) / 50;
		
		[particleEngine setColor:particleId red:red green:green blue:blue transparency:1.0];
		[particleEngine enableBounce:particleId];
	}	
}

-(void) doRestoreMessage {
	pageState = PAGE_RESTORE;
}

-(bool) restoreGame {
	return bRestoreGame;
}

@end
