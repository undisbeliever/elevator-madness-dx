; Initialisation code

.include "game.h"
.include "splash.h"

.include "routines/metasprite.h"


;; Initialisation Routine
ROUTINE Main
	REP	#$10
	SEP	#$20
.A8
.I16

	; ::TODO Setup Sound Engine::

	LDA	#NMITIMEN_VBLANK_FLAG | NMITIMEN_AUTOJOY_FLAG
	STA	NMITIMEN

	MetaSprite_Init

	REPEAT
		JSR	Splash__SplashScreen

		JSR	Game__PlayGame
	FOREVER


.segment "COPYRIGHT"
		;1234567890123456789012345678901
	.byte	"Elevator Madness DX            ", 10
	.byte	"(c) 2015, The Undisbeliever    ", 10
	.byte	"MIT Licensed                   ", 10
	.byte	"One Game Per Month Challange   ", 10

