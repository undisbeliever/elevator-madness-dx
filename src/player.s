; Player

.include "game.h"
.include "player.h"

MODULE Player

.segment "SHADOW"
	UINT16	xPos
	UINT16	yPos
	SINT16	xVelocity
	SINT16	yVelocity

	BYTE	counter
	BYTE	standingIfZero

	; zero = right, non-zero = left
	BYTE	facingRightOnZero

	WORD	state

	WORD	metaSpriteFrame

.rodata
LABEL PlayerStateTable
	.addr	ContinueWalking
	.addr	ContinuePushButton
	.addr	ContinueJumping
	.addr	ContinueFalling

.code

.A8
.I16
ROUTINE Init
	LDY	#PLAYER_START_X_POS << 8
	STY	xPos
	LDY	#PLAYER_START_Y_POS << 8
	STY	yPos

	LDY	#0
	STY	xVelocity
	STY	yVelocity

	STZ	counter
	STZ	facingRightOnZero

	LDX	#PLAYER_WALKING
	STX	state

	LDX	#.loword(MetaSprite_player_standRight)
	STX	metaSpriteFrame

	RTS


.A8
.I16
ROUTINE Process
	LDX	state
	JSR	(.loword(PlayerStateTable), X)


	; Update Velocities
	REP	#$21		; also clear carry
.A16

	LDA	xPos
	ADC	xVelocity
	STA	xPos

	LDA	yPos
	CLC
	ADC	yVelocity
	STA	yPos

	SEP	#$20
.A8

	JSR	CheckWallCollision

	; Display Frame
	LDA	xPos + 1
	STA	MetaSprite__xPos
	STZ	MetaSprite__xPos + 1

	LDA	yPos + 1
	STA	MetaSprite__yPos
	STZ	MetaSprite__yPos + 1

	LDY	#0
	LDX	metaSpriteFrame
	JSR	MetaSprite__ProcessMetaSprite_Y

	RTS



.A8
.I16
ROUTINE SetWalkingState
	; state = PLAYER_FALLING
	;
	; counter = 1

	LDX	#PLAYER_WALKING
	STX	state

	LDA	#1
	STA	counter

	.assert * = ContinueWalking, lderror, "Bad Flow"

.A8
.I16
ROUTINE ContinueWalking
	; if not on ground
	;	goto SetFallingState
	;
	; if elevator buttons pressed
	;	goto SetPushButtonState
	;
	; if B pressed
	;	goto SetJumpingState
	;
	; if left pressed
	;	if facingRightOnZero == 0:
	;		metaSpriteFrame = MetaSprite_player_turnRight
	;		counter = PLAYER_TURN_ANIMATION_DELAY
	;		facingRightOnZero = true
	;	xVelocity = -PLAYER_WALK_VELOCITY
	;
	;	if --counter == 0
	;		metaSpriteFrame = metaSpriteFrame == MetaSprite_player_standLeft ? MetaSprite_player_walkLeft : MetaSprite_player_standLeft
	;		counter = PLAYER_WALK_ANIMATION_DELAY
	;	return
	;
	; if right pressed
	;	if facingRightOnZero != 0:
	;		metaSpriteFrame = MetaSprite_player_turnLeft
	;		counter = PLAYER_TURN_ANIMATION_DELAY
	;		facingRightOnZero = false
	;	xVelocity = PLAYER_WALK_VELOCITY
	;
	;	if --counter == 0
	;		metaSpriteFrame = metaSpriteFrame == MetaSprite_player_standRight ? MetaSprite_player_walkRight : MetaSprite_player_standRight
	;		counter = PLAYER_WALK_ANIMATION_DELAY
	;
	;	return
	;
	; // standing still
	; metaSpriteFrame = facingRightOnZero ? standLeft : standRight
	; xVelocity = 0

	LDA	standingIfZero
	JNE	SetFallingState

	REP	#$30
.A16

	LDA	JOY1
	BIT	#BUTTON_ELEVATOR_DOOR | BUTTON_ELEVATOR_UP | BUTTON_ELEVATOR_DOWN
	IF_NOT_ZERO
		SEP	#$20
		JMP	SetPushButtonState
	ENDIF

	BIT	#BUTTON_JUMP
	IF_NOT_ZERO
		SEP	#$20
		JMP	SetJumpingState
	ENDIF

	SEP	#$20
.A8

	; A is high byte of JOYH
	; only testing left/right, thus fixed
	XBA
	BIT	#JOYH_LEFT
	IF_NOT_ZERO
		; left pressed
		LDA	facingRightOnZero
		IF_ZERO
			; was right, now left
			LDX	#.loword(MetaSprite_player_turnRight)
			STX	metaSpriteFrame

			LDA	#1
			STA	facingRightOnZero

			LDA	#PLAYER_TURN_ANIMATION_DELAY
			STA	counter
		ENDIF

		LDY	#.loword(-PLAYER_WALK_VELOCITY)
		STY	xVelocity

		DEC counter
		IF_ZERO
			LDY	metaSpriteFrame
			CPY	#.loword(MetaSprite_player_standLeft)
			IF_EQ
				LDY	#.loword(MetaSprite_player_walkLeft)
			ELSE
				LDY	#.loword(MetaSprite_player_standLeft)
			ENDIF

			STY	metaSpriteFrame

			LDA	#PLAYER_WALK_ANIMATION_DELAY
			STA	counter
		ENDIF

		RTS
	ENDIF


	BIT	#JOYH_RIGHT
	IF_NOT_ZERO
		; right pressed
		LDA	facingRightOnZero
		IF_NOT_ZERO
			; was left, now right
			LDX	#.loword(MetaSprite_player_turnLeft)
			STX	metaSpriteFrame

			STZ	facingRightOnZero

			LDA	#PLAYER_TURN_ANIMATION_DELAY
			STA	counter
		ENDIF

		LDY	#PLAYER_WALK_VELOCITY
		STY	xVelocity

		DEC counter
		IF_ZERO
			LDY	metaSpriteFrame
			CPY	#.loword(MetaSprite_player_standRight)
			IF_EQ
				LDY	#.loword(MetaSprite_player_walkRight)
			ELSE
				LDY	#.loword(MetaSprite_player_standRight)
			ENDIF

			STY	metaSpriteFrame

			LDA	#PLAYER_WALK_ANIMATION_DELAY
			STA	counter
		ENDIF

		RTS
	ENDIF

	; Standing Still
	LDA	facingRightOnZero
	IF_NOT_ZERO
		LDX	#.loword(MetaSprite_player_standLeft)
	ELSE
		LDX	#.loword(MetaSprite_player_standRight)
	ENDIF
	STX	metaSpriteFrame

	LDY	#0
	STY	xVelocity

	RTS



.A8
.I16
ROUTINE SetPushButtonState
	; state = PLAYER_FALLING
	; xVelocity = 0
	; counter = PLAYER_BUTTON_ANIMATION_DELAY
	; metaSpriteFrame = facingRightOnZero ? jumpLeft : jumpRight
	;
	; processPushButton()
	
	LDX	#PLAYER_PUSH_BUTTON
	STX	state

	LDY	#0
	STY	xVelocity

	LDA	#PLAYER_BUTTON_ANIMATION_DELAY
	STA	counter

	LDA	facingRightOnZero
	IF_NOT_ZERO
		LDX	#.loword(MetaSprite_player_pushButtonLeft)
	ELSE
		LDX	#.loword(MetaSprite_player_pushButtonRight)
	ENDIF

	STX	metaSpriteFrame

	;; Process Push Button	

	.assert * = ContinuePushButton, lderror, "Bad Flow"

.A8
.I16
ROUTINE	ContinuePushButton
	; if --counter == 0
	;	goto SetWalkingState

	DEC	counter
	JEQ	SetWalkingState

	RTS



.A8
.I16
ROUTINE SetJumpingState
	; state = PLAYER_FALLING
	;
	; yVelocity = PLAYER_JUMP_VELOCITY
	; conter = PLAYER_JUMP_HOLD
	; standingIfZero = true
	; metaSpriteFrame = facingRightOnZero ? jumpLeft : jumpRight
	;
	; play jumping sound

	LDX	#PLAYER_JUMPING
	STX	state

	LDY	#.loword(-PLAYER_JUMP_VELOCITY)
	STY	yVelocity

	LDA	#PLAYER_JUMP_HOLD
	STA	counter
	STA	standingIfZero

	LDA	facingRightOnZero
	IF_NOT_ZERO
		LDX	#.loword(MetaSprite_player_jumpLeft)
	ELSE
		LDX	#.loword(MetaSprite_player_jumpRight)
	ENDIF

	STX	metaSpriteFrame

	; :: SOUND jump ::

	.assert * = ContinueJumping, lderror, "Bad Flow"


.A8
.I16
ROUTINE ContinueJumping
	; If release B
	;	counter = 0
	;
	; if counter != 0:
	;	counter--;
	; 	yVelocity = -PLAYER_JUMP_VELOCITY
	; else
	; 	yVelocity += GRAVITY_PER_FRAME
	;
	; 	if yVelocity >= 0
	;		goto	SetFallingState
	;
	;	if left pressed
	;		xVelocity = -PLAYER_AIR_WALK_VELOCITY
	;		metaSpriteFrame = MetaSprite_player_jumpLeft
	;	else if right pressed
	;		xVelocity = PLAYER_AIR_WALK_VELOCITY
	;		metaSpriteFrame = MetaSprite_player_jumpRight
	;

	REP	#$20
.A16
	LDA	JOY1
	AND	#BUTTON_JUMP
	SEP	#$20
.A8

	IF_ZERO
		; B released
		STZ	counter
		BRA	ContinueJumping_Skip
	ENDIF

	LDA	counter
	IF_NOT_ZERO
		DEC	counter

	ELSE
ContinueJumping_Skip:
		REP	#$20
.A16

		LDA	yVelocity
		ADD	#GRAVITY_PER_FRAME
		STA	yVelocity

		SEP	#$20
.A8

		BPL	SetFallingState
	ENDIF

	LDA	JOY1H
	BIT	#JOYH_LEFT
	IF_NOT_ZERO
		; left pressed
		LDY	#.loword(-PLAYER_AIR_WALK_VELOCITY)
		STY	xVelocity

		LDY	#.loword(MetaSprite_player_jumpLeft)
		STY	metaSpriteFrame

		RTS
	ENDIF

	BIT	#JOYH_RIGHT
	IF_NOT_ZERO
		; right pressed
		LDY	#PLAYER_AIR_WALK_VELOCITY
		STY	xVelocity

		LDY	#.loword(MetaSprite_player_jumpRight)
		STY	metaSpriteFrame
	ENDIF

	RTS



.A8
.I16
ROUTINE SetFallingState
	; state = PLAYER_FALLING
	; metaSpriteFrame = facingRightOnZero ? fallingLeft : fallingRight

	LDX	#PLAYER_FALLING
	STX	state

	LDA	facingRightOnZero
	IF_NOT_ZERO
		LDX	#.loword(MetaSprite_player_fallLeft)
	ELSE
		LDX	#.loword(MetaSprite_player_fallRight)
	ENDIF

	STX	metaSpriteFrame

	.assert * = ContinueFalling, lderror, "Bad Flow"

.A8
.I16
ROUTINE ContinueFalling
	; if standing
	;	play landing sound
	;	goto SetWalkingState
	; else
	;	yVelocity += GRAVITY_PER_FRAME
	;	if left pressed
	;		xVelocity = -PLAYER_AIR_WALK_VELOCITY
	;		metaSpriteFrame = MetaSprite_player_fallLeft
	;	else if right pressed
	;		xVelocity = PLAYER_AIR_WALK_VELOCITY
	;		metaSpriteFrame = MetaSprite_player_fallRight

	LDA	standingIfZero
	IF_ZERO
		; :: SOUND land ::
		JMP SetWalkingState
	ENDIF

	REP	#$20
.A16

	LDA	yVelocity
	ADD	#GRAVITY_PER_FRAME
	STA	yVelocity

	SEP	#$20
.A8

	LDA	JOY1H
	BIT	#JOYH_LEFT
	IF_NOT_ZERO
		; left pressed
		LDY	#.loword(-PLAYER_AIR_WALK_VELOCITY)
		STY	xVelocity

		LDY	#.loword(MetaSprite_player_fallLeft)
		STY	metaSpriteFrame

		RTS
	ENDIF

	BIT	#JOYH_RIGHT
	IF_NOT_ZERO
		; right pressed
		LDY	#PLAYER_AIR_WALK_VELOCITY
		STY	xVelocity

		LDY	#.loword(MetaSprite_player_fallRight)
		STY	metaSpriteFrame
	ENDIF

	RTS





;; Checks to see if the player collided with the walls.
;;
;; This routine uses hard coded values.
.A8
.I16
ROUTINE CheckWallCollision
	; if xPos < PLAYER_LEFT_LIMIT
	;	xPos = PLAYER_LEFT_LIMIT
	;	xVelocity = 0
 	; else if xPos >= PLAYER_RIGHT_LIMIT
	;	xPos = PLAYER_RIGHT_LIMIT
	;	xVelocity = 0
	;
	; if yPos < TOP_RAFTER
	;	standing = false
	; else if yPos > BOTTOM_RAFTER
	;	yPos = BOTTOM_RAFTER
	;	yVelocity = 0
	;	standing = true
	; else
	;	if state != jumping:
	;		yrow = (yPos - TOP_RAFTER) / 4
	;		if table[yrow] == 0
	;			standing = false
	;		if table[yrow] == 1
	;			standing = xPos < RAFTER_LEFT_POS || xPos >= RAFTER_RIGHT_POS
	;		else
	;			standing = xPos >= RAFTER_CERTER_LEFT && xPos < RAFTER_CENTER_RIGHT
	;		if standing:
	;			yVelocity = 0
	;			yPos = yrow * 4 + TOP_RAFTER

	LDA	xPos + 1
	CMP	#PLAYER_LEFT_LIMIT
	IF_LT
		LDY	#PLAYER_LEFT_LIMIT << 8
		STY	xPos
		LDY	#0
		STY	xVelocity
	ELSE
		CMP	#PLAYER_RIGHT_LIMIT
		IF_GE
			LDY	#PLAYER_RIGHT_LIMIT << 8
			STY	xPos
			LDY	#0
			STY	xVelocity
		ENDIF
	ENDIF

	LDA	yPos + 1
	CMP	#BOTTOM_RAFTER
	IF_GE
		LDY	#BOTTOM_RAFTER << 8
		STY	yPos
		LDY	#0
		STY	yVelocity

		STZ	standingIfZero

		RTS
	ENDIF

	; A = yPos + 1
	CMP	#TOP_RAFTER
	IF_LT
		LDA	#1
		STA	standingIfZero
		RTS
	ENDIF

	LDX	state
	CPX	#PLAYER_JUMPING
	IF_NE
		; A = yPos + 1
		SUB	#TOP_RAFTER
		LSR
		LSR

		SEP	#$30
.I8
		TAY
		TAX

		LDA	RafterTable, X

		REP	#$10
.I16

		IF_ZERO
			LDA	#1
			STA standingIfZero
		ELSE

			CMP	#1
			IF_EQ
				LDA	xPos + 1
				CMP	#RAFTER_LEFT_POS
				BLT	CheckWallCollision_OnRafter
				CMP	#RAFTER_RIGHT_POS
				BGE	CheckWallCollision_OnRafter

				; not on rafter.
				; A is non-zero

				STA	standingIfZero
				RTS

			ELSE
				LDA	xPos + 1
				CMP	#RAFTER_CENTER_LEFT
				BLT	CheckWallCollision_CenterFalling
				CMP	#RAFTER_CENTER_RIGHT
				BGE	CheckWallCollision_CenterFalling

				BRA	CheckWallCollision_OnRafter

CheckWallCollision_CenterFalling:
				LDA	#1
				STA	standingIfZero
				RTS
			ENDIF

CheckWallCollision_OnRafter:
			; because of the RTS you can only be here is on a rafter.
			STZ	standingIfZero

			TYA
			ASL
			ASL
			ADD	#TOP_RAFTER
			STA	yPos + 1
			STZ	yPos

			LDY	#0
			STY	yVelocity
		ENDIF
	ENDIF

	RTS
	
.rodata

;; A Row table for the rafter.
;; Each byte represents a 4 pixel row.
;; 	* 0 = no rafters
;;	* 1 = left & right rafters with center hole
;;	* 2 = center rafter with left & right holes
LABEL RafterTable
	.repeat 6
		.byte 1
		.repeat RAFTER_SPACING - 1
			.byte 0
		.endrepeat
		.byte 2
		.repeat RAFTER_SPACING - 1
			.byte 0
		.endrepeat
	.endrepeat

ENDMODULE

