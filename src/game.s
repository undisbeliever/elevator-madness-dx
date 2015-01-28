; Elevator Maddness DX game.


.include "game.h"
.include "player.h"
.include "includes/sfc_header.inc"

.include "routines/screen.h"
.include "routines/block.h"


.code

;; Initialisation Routine
ROUTINE Main
	REP	#$10
	SEP	#$20
.A8
.I16

	; ::TODO Setup Sound Engine::
	MetaSprite_Init

	JSR	Game__Init

	JSR	Game__PlayGame

	REPEAT
	FOREVER



MODULE Game

.segment "SHADOW"
	BYTE	strikes
	WORD	score

.code

ROUTINE Init
	REP	#$10
	SEP	#$20
.A8
.I16
	STZ	strikes
	LDY	#0
	STY	score	

	JSR	SetupScreen

	LDA	#NMITIMEN_VBLANK_FLAG | NMITIMEN_AUTOJOY_FLAG
	STA	NMITIMEN

	LDA	#$0F
	STA	INIDISP

	RTS


.A8
.I16
ROUTINE PlayGame
	JSR	Player__Init

	.assert * = GameLoop, lderror, "Bad flow"

.A8
.I16
ROUTINE GameLoop
	REPEAT

	WHILE_NE
		JSR	MetaSprite__InitLoop

		JSR	Player__Process

		JSR	MetaSprite__FinalizeLoop

		WAI
	WEND

	RTS


; Sets up the game screen
.A8
.I16
ROUTINE SetupScreen
	LDA	#INIDISP_FORCE
	STA	INIDISP

	LDA	#BGMODE_MODE1_BG3_PRIORITY
	STA	BGMODE

	LDX	#0
	STX	BG1HOFS
	STX	BG1HOFS
	STX	BG2HOFS
	STX	BG2HOFS
	STX	BG3HOFS
	STX	BG3HOFS
	STX	BG4HOFS
	STX	BG4HOFS

	Screen_SetVramBaseAndSize GAME

	TransferToVramLocation	backgroundMap, GAME_BG2_MAP
	TransferToVramLocation	backgroundTiles, GAME_BG2_TILES
	TransferToCgramLocation	backgroundPalette, 0
	TransferToVramLocation	foregroundTiles, GAME_BG1_TILES
	TransferToCgramLocation	foregroundPalette, 7 * 16
	TransferToVramLocation	playerTiles, GAME_OAM_TILES
	TransferToCgramLocation playerPalette, 8 * 16, 32

	LDA	#TM_BG1 | TM_BG2 | TM_BG3 | TM_OBJ
	STA	TM

	RTS

ENDMODULE

