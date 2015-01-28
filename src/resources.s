
.include "resources.h"
.setcpu "65816"

.segment "BANK1"
	INCLUDE_BINARY backgroundMap,		"resources/background.map"
	INCLUDE_BINARY backgroundTiles,		"resources/background.4bpp"
	INCLUDE_BINARY backgroundPalette,	"resources/background.clr"
	INCLUDE_BINARY foregroundTiles,		"resources/foreground-tiles.4bpp"
	INCLUDE_BINARY foregroundPalette,	"resources/foreground-tiles.clr"
	INCLUDE_BINARY playerTiles,		"resources/player-tiles.4bpp"
	INCLUDE_BINARY playerPalette,		"resources/player-tiles.clr"


.segment "BANK2"
	.export MetaSpriteLayoutBank = .bankbyte(*)

	.include "resources/elevator.metasprite-table.inc"
	.include "resources/elevator.metasprite-data.inc"

