//
//  TextureManager.m
//  Tornado
//
//  Created by Robert Molnar 2 on 11/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextureManager.h"


@implementation TextureManager

-(TextureManager *) initManager {
	self = [super init];
	
	// Initialize.
	for (int i=0; i < MAX_TEXTURE_ARRAY; i++)
		array[i] = nil;
	
	return self;
}

-(void)dealloc {
	for (int i=0; i < MAX_TEXTURE_ARRAY; i++) {
		if (array[i] != nil)
			[array[i] release];
	}
	
	[super dealloc];
}

-(Texture2D *)texture: (int) textureId {
	if (array[textureId] == nil)
		[self _loadTexture:textureId];
	
	return array[textureId];
}

-(void)_loadTexture: (int) textureId {
	// Already loaded. 
	if (array[textureId] != nil)
		return;
	
	switch (textureId) {
		case TEXTURE_GAME_BG1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_solidbg" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAME_PIECE1:
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_04" ofType:@"png"]]];
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_red" ofType:@"png"]]];
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_1piece_red" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_PIECE2:
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_05" ofType:@"png"]]];
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_yellow" ofType:@"png"]]];
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_2piece_yellow" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_PIECE3:
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_02" ofType:@"png"]]];
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_green" ofType:@"png"]]];
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_3piece_green" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_PIECE4:
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_06" ofType:@"png"]]];
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_teal" ofType:@"png"]]];
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_4piece_teal" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_PIECE5:
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_03" ofType:@"png"]]];
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_purple" ofType:@"png"]]];
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_5piece_purple" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_PIECE6:
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_01" ofType:@"png"]]];
//			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_blue" ofType:@"png"]]];
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_6piece" ofType:@"png"]]];
			break;	
			
		case TEXTURE_GAME_BLING_PIECE1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_04" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_BLING_PIECE2:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_05" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_BLING_PIECE3:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_02" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_BLING_PIECE4:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_06" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_BLING_PIECE5:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_03" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_BLING_PIECE6:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Bling_01" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAME_NINJA_PIECE1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_red" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_NINJA_PIECE2:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_yellow" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_NINJA_PIECE3:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_green" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_NINJA_PIECE4:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_teal" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_NINJA_PIECE5:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_purple" ofType:@"png"]]];
			break;
		case TEXTURE_GAME_NINJA_PIECE6:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cog_blue" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAME_SOLID:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_solid" ofType:@"png"]]];
			break;		
		case TEXTURE_GAME_SOLIDBLACK:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"32x32_black" ofType:@"png"]]];
			break;		
			
		case TEXTURE_PARTICLE_1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"16x16_particle" ofType:@"png"]]];
			break;	
			
		case TEXTURE_MENU_LEVELS:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"png"]]];
			break;	
			
		case TEXTURE_MENU_HELP:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mm_help" ofType:@"png"]]];
			break;	
			
		case TEXTURE_MENU_MOREAPPS:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mm_moreapps" ofType:@"png"]]];
			break;	
		case TEXTURE_HELPPAGE1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_page1" ofType:@"png"]]];
			break;
		case TEXTURE_HELPPAGE2:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_page2" ofType:@"png"]]];
			break;
		case TEXTURE_HELPPAGE3:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_page3" ofType:@"png"]]];
			break;
		case TEXTURE_HELPPAGE4:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help_page4" ofType:@"png"]]];
			break;
			
		case TEXTURE_LEVELS_ALPHABET:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_alphabet" ofType:@"png"]]];
			break;
		case TEXTURE_LEVELS_MINDBENDER:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_mind-bender" ofType:@"png"]]];
			break;
		case TEXTURE_LEVELS_SYMMETRIC:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_symmetric" ofType:@"png"]]];
			break;
		case TEXTURE_LEVELS_SIMPLE:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_simple" ofType:@"png"]]];
			break;
		case TEXTURE_LEVELS_WHATEVER:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_whatever" ofType:@"png"]]];
			break;
		case TEXTURE_LEVELS_MORE:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_more" ofType:@"png"]]];
			break;
		case TEXTURE_LEVELS_MAINMENU:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lv_mainmenu" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAME_SELECT1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_select1" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAME_SELECT2:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_select2" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAME_ARROW:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x64_arrow" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAMEMENU_PREV:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x32_prev" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAMEMENU_NEXT:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"64x32_next" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAMEMENU_QUESTION:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"32x32_question" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAMEMENU_RECORDCURRENT:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"96x32_recordcurrent" ofType:@"png"]]];
			break;
			
		case TEXTURE_MES_RESTORE_GAME:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mm_restoregame" ofType:@"png"]]];
			break;			
			
		case TEXTURE_DIGITS_16PX:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"80x32_digits" ofType:@"png"]]];
			break;
			
		case TEXTURE_GAMEMENU_LEVEL:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"48x16_level" ofType:@"png"]]];
			break;
			
		case TEXTURE_INGAME_BUTTON_MENU:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ingm_menu" ofType:@"png"]]];
			break;
			
		case TEXTURE_INGAME_BUTTON_IN:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ingm_inward" ofType:@"png"]]];
			break;
			
		case TEXTURE_INGAME_BUTTON_OUT:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ingm_button" ofType:@"png"]]];
			break;
			
		case TEXTURE_MOREAPPS:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"more_apps" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_HOWD_YOU_DO_THAT:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mes_howdyoudothat" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_JUSTOK:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_justok" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_GLAD_THATS_OVER:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_gladthatsoverwith" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_WHAT_WHERE_YOU_THINKING:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_whatwereyouthinking" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_SMARTY_PANTS:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_smartypants" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_IQ1:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_iqplus1" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_GOOD_JOB:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_goodjob" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_DONT_QUIT_DAY_JOB:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_dontquityourdayjob" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_DEVELOPER_IMPRESSED:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_developerisimpressed" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_GREATJOB:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_greatjob" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_A_GENIUS_HERE:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_ageniushere" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_SKILLFULYOUARE:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_skillfulyouareindeed" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_MOVINONUP:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_movinonup" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_INCREDIBLE:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_incredible" ofType:@"png"]]];
			break;
			
		case TEXTURE_MESS_KEEPTRYING:
			array[textureId] = [[Texture2D alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"msg_keeptrying" ofType:@"png"]]];
			break;
			
		default:
			break;
	}
}

-(void)reset {
	// Initialize.
	for (int i=0; i < MAX_TEXTURE_ARRAY; i++)
		array[i] = nil;
	
}

-(void)digits16_drawNumberAtPoint: (CGPoint)pt height:(float)height number:(int)number {
	CGRect rectTexture;
	
	// Default height is 12.
	if (height == -1)
		height = 12;
	
	// 10x12 characters. width proportion is .83333
	
	float width = .8333333 * height;
	
	// Coordinates to draw the number on the screen.
	CGRect rectDraw;
	rectDraw.size.width = width;
//	rectDraw.size.width = 192;
	rectDraw.size.height = height;
//	rectDraw.size.height = 32;
	rectDraw.origin.x = pt.x;
	rectDraw.origin.y = pt.y;
	
	// The divide is the largests 1x value to fit in the number.
	int divide = [self _digits16_getLargestDivide:number];
	float xOffset = 0;
	
	// Draw the first number.
	int numberToDraw = number / divide;
	rectTexture = [self _digits16_textureCoordinates:numberToDraw];
	[[self texture: TEXTURE_DIGITS_16PX] drawInRect:&rectDraw rectTexture:&rectTexture];
//	[[self texture: TEXTURE_DIGITS_16PX] drawInRect:&rectDraw];
	
	// Remove the digit drawn.
	number -= divide * numberToDraw;
	xOffset += 12;
	
	if (divide == 1)
		divide = 0;
	
	// Now draw the rest of the digits.
	while (divide) {
		// Get the next digit to draw.
		divide /= 10;
		numberToDraw = number / divide;
		rectTexture = [self _digits16_textureCoordinates:numberToDraw];
		
		// Draw next digit.
		rectDraw.origin.x = pt.x + xOffset;		
		[[self texture: TEXTURE_DIGITS_16PX] drawInRect:&rectDraw rectTexture:&rectTexture];		
		
		number -= divide * numberToDraw;
		xOffset += width;
		
		if (divide == 1)
			divide = 0;
	}
}

-(int)_digits16_getLargestDivide: (int) number {
	if (number >= 1000000000)
		return 1000000000;
	if (number >= 100000000)
		return 100000000;
	if (number >= 10000000)
		return 10000000;
	if (number >= 1000000)
		return 1000000;
	if (number >= 100000)
		return 100000;
	if (number >= 10000)
		return 10000;
	if (number >= 1000)
		return 1000;
	if (number >= 100)
		return 100;
	if (number >= 10)
		return 10;
	if (number >= 0)
		return 1;
	
	return 1000000000;
}

-(CGRect)_digits16_textureCoordinates: (int) digit {
	if (digit == 0)
		return CGRectMake(0, 0, 10, 13);
	else if (digit == 1)
		return CGRectMake(16, 0, 10, 13);
	else if (digit == 2)
		return CGRectMake(32, 0, 10, 13);
	else if (digit == 3)
		return CGRectMake(48, 0, 10, 13);
	else if (digit == 4)
		return CGRectMake(64, 0, 10, 13);
	else if (digit == 5)
		return CGRectMake(0, 16, 10, 13);
	else if (digit == 6)
		return CGRectMake(16, 16, 10, 13);
	else if (digit == 7)
		return CGRectMake(32, 16, 10, 13);
	else if (digit == 8)
		return CGRectMake(48, 16, 10, 13);
	else if (digit == 9)
		return CGRectMake(64, 16, 10, 13);
	
	return CGRectMake(0, 0, 1, 1);	
}

@end
