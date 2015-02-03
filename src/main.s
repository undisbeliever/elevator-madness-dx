; Initialisation code

.include "game.h"
.include "splash.h"
.include "includes/sfc_header.inc"


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

		JSR	Game__Init

		JSR	Game__PlayGame
	FOREVER

