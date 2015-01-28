; Inturrupt Handlers for Elevator Madness DX
.include "game.h"

;; Blank Handlers
ROUTINE IrqHandler
	RTI

ROUTINE CopHandler
	RTI

ROUTINE VBlank
	; Save state
	REP #$30
	PHA
	PHB
	PHD
	PHX
	PHY

	SEP #$20
.A8
.I16

	MetaSprite_VBlank
	

	; Load State
	REP	#$30
	PLY
	PLX
	PLD
	PLB
	PLA
	
	RTI

