.ifndef ::_GAME_H_
::_GAME_H_ = 1

.define VERSION 1
.define REGION NTSC
.define ROM_NAME "ELEVATOR MADNESS DX"

.setcpu "65816"

; Common includes
.include "includes/import_export.inc"
.include "includes/synthetic.inc"
.include "includes/registers.inc"
.include "includes/structure.inc"
.include "routines/metasprite.h"

.include "resources.h"

.if .xmatch(REGION, NTSC)
	FPS = 60
.else
	FPS = 50
.endif


;; VRAM Map
;; WORD ADDRESSES
GAME_BG1_MAP	= $0000
GAME_BG2_MAP	= $0400
GAME_BG3_MAP	= $0800
GAME_BG1_TILES	= $5000
GAME_BG2_TILES	= $1000
GAME_BG3_TILES	= $4000
GAME_OAM_TILES	= $6000

GAME_BG1_SIZE	= BGXSC_SIZE_32X32
GAME_BG2_SIZE	= BGXSC_SIZE_32X32
GAME_BG3_SIZE	= BGXSC_SIZE_32X32

GAME_OAM_SIZE	= OBSEL_SIZE_8_16
GAME_OAM_NAME	= 0


IMPORT_MODULE Game
	BYTE	strikes
	WORD	score


	;; Initializes the game.
	ROUTINE Init

	;; Builds and processes the game.
	ROUTINE PlayGame

	;; Sets up the Screen Registers and loads VRAM
	;;
	;; REQUIRES: 8 bit A, 16 bit Index
	ROUTINE SetupScreen
	
ENDMODULE

.endif ; ::_GAME_H_

; vim: set ft=asm:

