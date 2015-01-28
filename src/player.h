.ifndef ::_PLAYER_H_
::_PLAYER_H_ = 1

.include "game.h"
.setcpu "65816"

; Common includes
.include "includes/import_export.inc"
.include "includes/synthetic.inc"
.include "includes/registers.inc"
.include "includes/structure.inc"
.include "routines/metasprite.h"

PLAYER_START_X_POS = 128
PLAYER_START_Y_POS = 199

PLAYER_LEFT_LIMIT = 100
PLAYER_RIGHT_LIMIT = 156

TOP_RAFTER = 55
BOTTOM_RAFTER = 199
RAFTER_SPACING = 6			; in 4 pixel blocks.

RAFTER_LEFT_POS = 120
RAFTER_RIGHT_POS = 140
RAFTER_CENTER_LEFT = 112
RAFTER_CENTER_RIGHT = 146

PLAYER_WALK_VELOCITY = 191		; Walking speed in 1/256 pixels / frame
PLAYER_AIR_WALK_VELOCITY = 125		; Velocity while in the air (1/256 pixels/frame).

PLAYER_JUMP_VELOCITY = 445		; Jumping velocity in 1/256 pixels / frame
PLAYER_JUMP_HOLD = 20			; Number of frames to hold the jump for
GRAVITY_PER_FRAME = 31			; Acceleration due to gravity in 1/256 pixels per frame per frame

PLAYER_WALK_ANIMATION_DELAY = 10	; Number of frames inbetween walking frames.
PLAYER_TURN_ANIMATION_DELAY = 7		; Number of frames inbetween turning frames.
PLAYER_BUTTON_ANIMATION_DELAY = 10	; Number of frames to show the players hand presseing that button.

BUTTON_JUMP		= JOY_B
BUTTON_ELEVATOR_DOOR	= JOY_Y
BUTTON_ELEVATOR_UP	= JOY_UP | JOY_X
BUTTON_ELEVATOR_DOWN	= JOY_DOWN | JOY_A

.enum
	PLAYER_WALKING		=  0
	PLAYER_PUSH_BUTTON	=  2
	PLAYER_JUMPING		=  4
	PLAYER_FALLING		=  6
.endenum

IMPORT_MODULE Player

	;; Initialises the player's variables
	;;
	;; REQUIRE: 8 bit A, 16 bit Index
	ROUTINE Init

	;; Processes the player for a single frame.
	ROUTINE Process
	
ENDMODULE

.endif ; ::_PLAYER_H_

; vim: set ft=asm:

