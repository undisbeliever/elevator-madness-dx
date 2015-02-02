.ifndef ::_RESOURCES_H_
::_RESOURCES_H_ = 1

.include "includes/import_export.inc"

; Include Autogen by snesdev-util
.include "resources/elevator.metasprite.h"

;; Resources
IMPORT_BINARY backgroundMap
IMPORT_BINARY backgroundTiles
IMPORT_BINARY backgroundPalette
IMPORT_BINARY interactiveTiles
IMPORT_BINARY interactivePalette
IMPORT_BINARY playerTiles
IMPORT_BINARY playerPalette
IMPORT_BINARY businessManTiles
IMPORT_BINARY businessManPalette

.endif ; ::_RESOURCES_H_

; vim: set ft=asm:

