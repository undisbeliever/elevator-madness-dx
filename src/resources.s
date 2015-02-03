
.include "resources.h"
.setcpu "65816"

.segment "BANK1"
	INCLUDE_BINARY backgroundMap,		"resources/background.map"
	INCLUDE_BINARY backgroundTiles,		"resources/background.4bpp"
	INCLUDE_BINARY backgroundPalette,	"resources/background.clr"

	INCLUDE_BINARY splashMap,		"resources/splash.map"
	INCLUDE_BINARY splashTiles,		"resources/splash.4bpp"
	INCLUDE_BINARY splashPalette,		"resources/splash.clr"

	INCLUDE_BINARY controlsMap,		"resources/controls.map"
	INCLUDE_BINARY controlsTiles,		"resources/controls.4bpp"
	INCLUDE_BINARY controlsPalette,		"resources/controls.clr"

	INCLUDE_BINARY interactiveTiles,	"resources/interactive-tiles.4bpp"
	INCLUDE_BINARY interactivePalette,	"resources/interactive-tiles.clr"

	INCLUDE_BINARY playerTiles,		"resources/player.4bpp"
	INCLUDE_BINARY playerPalette,		"resources/player.clr"

	INCLUDE_BINARY businessManTiles,	"resources/business-man.4bpp"
	INCLUDE_BINARY businessManPalette,	"resources/business-man.clr"

.segment "BANK2"
	.export MetaSpriteLayoutBank = .bankbyte(*)

	.include "resources/elevator.metasprite-table.inc"
	.include "resources/elevator.metasprite-data.inc"

