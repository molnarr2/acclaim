/*
 *  ResourceIds.h
 *  Tornado
 *
 *  Created by Robert Molnar 2 on 11/12/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ids of sounds. Must be unique and must be in the range of 0 to MAX_SOUND_ARRAY-1.

#define SOUND_GAME_PIECE1 1
#define SOUND_GAME_PIECE2 2
#define SOUND_GAME_PIECE3 3
#define SOUND_GAME_PIECE4 4
#define SOUND_GAME_PIECE5 5
#define SOUND_GAME_PIECE6 6
#define SOUND_CORRECT_PIECE1 7

#define SOUND_GAME_TWIRL_IN 8
#define SOUND_GAME_POP_UP 9
#define SOUND_CLICK 10

#define MAX_SOUND_ARRAY 64

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ids of textures. Must be unique and must be in the range of 0 to MAX_TEXTURE_ARRAY-1.

#define TEXTURE_GAME_BG1 1

#define TEXTURE_GAME_PIECE1 2
#define TEXTURE_GAME_PIECE2 3
#define TEXTURE_GAME_PIECE3 4
#define TEXTURE_GAME_PIECE4 5
#define TEXTURE_GAME_PIECE5 6
#define TEXTURE_GAME_PIECE6 7

#define TEXTURE_GAME_BLING_PIECE1 120
#define TEXTURE_GAME_BLING_PIECE2 121
#define TEXTURE_GAME_BLING_PIECE3 122
#define TEXTURE_GAME_BLING_PIECE4 123
#define TEXTURE_GAME_BLING_PIECE5 124
#define TEXTURE_GAME_BLING_PIECE6 125

#define TEXTURE_GAME_NINJA_PIECE1 126
#define TEXTURE_GAME_NINJA_PIECE2 127
#define TEXTURE_GAME_NINJA_PIECE3 128
#define TEXTURE_GAME_NINJA_PIECE4 129
#define TEXTURE_GAME_NINJA_PIECE5 130
#define TEXTURE_GAME_NINJA_PIECE6 131

#define TEXTURE_GAME_SOLID 8
#define TEXTURE_GAME_SOLIDBLACK 9

#define TEXTURE_GAME_SELECT1 10
#define TEXTURE_GAME_SELECT2 11
#define TEXTURE_GAME_ARROW 12

#define TEXTURE_PARTICLE_1 100

#define TEXTURE_MENU_LEVELS 102
#define TEXTURE_MENU_HELP 103
#define TEXTURE_MENU_MOREAPPS 104
#define TEXTURE_HELPPAGE1 105
#define TEXTURE_LEVELS_ALPHABET 106
#define TEXTURE_LEVELS_MINDBENDER 107
#define TEXTURE_LEVELS_SYMMETRIC 108
#define TEXTURE_LEVELS_SIMPLE 109
#define TEXTURE_LEVELS_WHATEVER 110
#define TEXTURE_LEVELS_MORE 111
#define TEXTURE_LEVELS_MAINMENU 112
#define TEXTURE_HELPPAGE2 113
#define TEXTURE_HELPPAGE3 114
#define TEXTURE_HELPPAGE4 115
#define TEXTURE_MOREAPPS 116
#define TEXTURE_MES_RESTORE_GAME 180

#define TEXTURE_GAMEMENU_NEXT 50
#define TEXTURE_GAMEMENU_PREV 51
#define TEXTURE_GAMEMENU_RECORDCURRENT 52
#define TEXTURE_GAMEMENU_QUESTION 53
#define TEXTURE_GAMEMENU_LEVEL 54

#define TEXTURE_INGAME_BUTTON_MENU 60
#define TEXTURE_INGAME_BUTTON_IN 61
#define TEXTURE_INGAME_BUTTON_OUT 62

#define TEXTURE_MESS_HOWD_YOU_DO_THAT 150
#define TEXTURE_MESS_JUSTOK 151
#define TEXTURE_MESS_GLAD_THATS_OVER 152
#define TEXTURE_MESS_WHAT_WHERE_YOU_THINKING 153
#define TEXTURE_MESS_SMARTY_PANTS 154
#define TEXTURE_MESS_IQ1 155
#define TEXTURE_MESS_GOOD_JOB 156
#define TEXTURE_MESS_DONT_QUIT_DAY_JOB 157
#define TEXTURE_MESS_DEVELOPER_IMPRESSED 158
#define TEXTURE_MESS_GREATJOB 159
#define TEXTURE_MESS_A_GENIUS_HERE 160
#define TEXTURE_MESS_SKILLFULYOUARE 161
#define TEXTURE_MESS_MOVINONUP 162
#define TEXTURE_MESS_INCREDIBLE 163
#define TEXTURE_MESS_KEEPTRYING 164

#define TEXTURE_DIGITS_16PX 250


// The largest unique id of the textures.
#define MAX_TEXTURE_ARRAY 256

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Unique Id of each button on the menu.

// Root menu buttons.
#define MENUROOT_BUTTON_COLOR 1
#define MENUROOT_BUTTON_PARTICES_FUNTIONS 2
#define MENUROOT_BUTTON_PARTICES 3
#define MENUROOT_BUTTON_FUNCTIONS 4
#define MENUROOT_BUTTON_PRESETS 5

// Color menu buttons.
#define MENUCOLOR_BUTTON_RED 100
#define MENUCOLOR_BUTTON_BLUE 101
#define MENUCOLOR_BUTTON_GREEN 102
#define MENUCOLOR_BUTTON_PINK 103
#define MENUCOLOR_BUTTON_ORANGE 104
#define MENUCOLOR_BUTTON_TEAL 105
#define MENUCOLOR_BUTTON_YELLOW 106
#define MENUCOLOR_BUTTON_RANDOM 107
#define MENUCOLOR_BUTTON_OFF 108

// Particle functions.
// partices come from 8 directions away.
#define MENUPARTICLE_FUNC_8WAY 201
// Trail of particles.
#define MENUPARTICLE_FUNC_TRAIL 202
// Produces a tornado of particles.
#define MENUPARTICLE_FUNC_TORNADO 203
// Produces a sine wave.
#define MENUPARTICLE_FUNC_SINEWAVE 204
// Start in the center and begin to cirlce out.
#define MENUPARTICLE_FUNC_CIRLCEOUT	205
// One particle forward.
#define MENUPARTICLE_FUNC_FORWARD 206

// Current finger preset to modify.
#define MENUPRESET_FINGER1 301
#define MENUPRESET_FINGER2 302
#define MENUPRESET_FINGER3 303
#define MENUPRESET_FINGER4 304

// For the particle/background menu.
#define MENU_PARTBG_PART 401
#define MENU_PARTBG_BG 402

// For the particle menu.
#define MENU_PART_1 501
#define MENU_PART_2 502
#define MENU_PART_3 503
#define MENU_PART_4 504
#define MENU_PART_5 505
#define MENU_PART_6 506
#define MENU_PART_7 507
#define MENU_PART_8 508
#define MENU_PART_9 509
#define MENU_PART_10 510
#define MENU_PART_11 511
#define MENU_PART_12 512
#define MENU_PART_13 513
#define MENU_PART_14 514
#define MENU_PART_15 515
#define MENU_PART_16 516
#define MENU_PART_17 517
#define MENU_PART_18 518
#define MENU_PART_19 519
#define MENU_PART_20 520
#define MENU_PART_21 521
#define MENU_PART_22 522
#define MENU_PART_23 523
#define MENU_PART_24 524
#define MENU_PART_25 525

// Settings menu.
#define MENU_SETTINGS_ROTATE 601
#define MENU_SETTINGS_GRAVITY 602
#define MENU_SETTINGS_BOUNCE 603
#define MENU_SETTINGS_LIFESPAN 604

// Settings rotate menu.
#define MENU_ROTATE_OFF 701
#define MENU_ROTATE_LO 702
#define MENU_ROTATE_MED 703
#define MENU_ROTATE_HI 704

// Settings gravity menu.
#define MENU_GRAVITY_OFF 801
#define MENU_GRAVITY_LO 802
#define MENU_GRAVITY_MED 803
#define MENU_GRAVITY_HI 804

// Settings lifespan menu.
#define MENU_LIFESPAN_LO 1001
#define MENU_LIFESPAN_MED 1002
#define MENU_LIFESPAN_HI 1003

// Background menus.
#define MENU_BG_1 1101
#define MENU_BG_2 1102
#define MENU_BG_3 1103
#define MENU_BG_4 1104
