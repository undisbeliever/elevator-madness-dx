; Elevator Maddness DX game.


.include "game.h"
.include "player.h"
.include "elevators.h"
.include "npcs.h"
.include "includes/sfc_header.inc"

.include "routines/screen.h"
.include "routines/block.h"
.include "routines/math.h"

.segment "SHADOW"
	WORD	interactiveBgBuffer, 32*32
	BYTE	updateBgBufferOnZero

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

	WORD	inversePrevButtons
	WORD	buttonsPressed
.code

ROUTINE Init
	REP	#$10
	SEP	#$20
.A8
.I16
	STZ	strikes
	LDY	#0
	STY	score

	MemClear	interactiveBgBuffer, .sizeof(interactiveBgBuffer)

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
	JSR	Elevators__Init
	JSR	Npcs__Init

	.assert * = GameLoop, lderror, "Bad flow"

.A8
.I16
ROUTINE GameLoop
	REPEAT
		WAI

		LDA	strikes
		CMP	#N_STRIKES
	WHILE_NE
		JSR	HandleButtons

		JSR	MetaSprite__InitLoop

		JSR	Player__Process
		JSR	Elevators__Process
		JSR	Npcs__Process

		JSR	MetaSprite__FinalizeLoop
	
		JSR	ShowScore

		STZ	updateBgBufferOnZero
	WEND

	RTS


; Populates buttonsPressed variable
ROUTINE HandleButtons
	REP	#$30
.A16
	LDA	JOY1
	AND	inversePrevButtons
	STA	buttonsPressed

	LDA	JOY1
	EOR	#$FFFF
	STA	inversePrevButtons

	SEP	#$20
.A8
	RTS


; Displays the score on the foreground
.A8
.I16
ROUTINE ShowScore
	LDY	score

	.repeat 4, i
		LDA	#10

		JSR	Math__Divide_U16Y_U8A

		TXA
		ADD	#SCORE_DIGIT_DELTA
		STA	interactiveBgBuffer + SCORE_TILE_COLUMN * 32 * 2 + (SCORE_TILE_ROW + 3 - i) * 2
	
		LDA	#SCORE_TILE_ATTR
		STA	interactiveBgBuffer + SCORE_TILE_COLUMN * 32 * 2 + (SCORE_TILE_ROW + 3 - i) * 2 + 1
	.endrepeat

	RTS



; Sets up the game screen
.A8
.I16
ROUTINE SetupScreen
	LDA	#INIDISP_FORCE
	STA	INIDISP

	LDA	#BGMODE_MODE2
	STA	BGMODE

	LDX	#0
	STX	BG1HOFS
	STX	BG1HOFS
	STX	BG2HOFS
	STX	BG2HOFS

	Screen_SetVramBaseAndSize GAME

	TransferToVramLocation	backgroundMap, GAME_BG1_MAP
	TransferToVramLocation	backgroundTiles, GAME_BG1_TILES
	TransferToCgramLocation	backgroundPalette, 0
	TransferToVramLocation	interactiveTiles, GAME_BG2_TILES
	TransferToCgramLocation	interactivePalette, 7 * 16
	TransferToVramLocation	playerTiles, GAME_OAM_TILES
	TransferToCgramLocation playerPalette, 8 * 16, 32

	TransferToVramLocation businessManTiles, GAME_OAM_TILES + (512 - 32) * 16
	TransferToCgramLocation businessManPalette, 128 + 7 * 16

	LDA	#TM_BG1 | TM_BG2 | TM_BG3 | TM_OBJ
	STA	TM

	RTS

ENDMODULE

