
META = elevator.metasprite.h elevator.metasprite-table.inc elevator.metasprite-data.inc
MAPS = background.map controls.map splash.map
TILES = background.4bpp controls.4bpp splash.4bpp 
TILES += interactive-tiles.4bpp strike-animations.4bpp
TILES += player.4bpp business-man.4bpp
PALETTES =  $(patsubst %.2bpp,%.clr,$(patsubst %.4bpp,%.clr,$(SOURCES)))

.PHONY: ALL

ALL: $(TILES) $(PALETTES) $(MAPS) $(META)

%.2bpp %.clr: %.pcx
	pcx2snes -n -s8 -c4 -o4 $*
	mv $*.pic $*.2bpp

%.4bpp %.clr: %.pcx
	pcx2snes -n -s8 -c16 -o16 $*
	mv $*.pic $*.4bpp

%.map %.4bpp %.clr: %.pcx
	pcx2snes -r -s8 -c16 -screen $*
	mv $*.pic $*.4bpp

%.metasprite.h %.metasprite-table.inc %.metasprite-data.inc: %.xml
	metasprite-gen $< 


.PHONY: clean
clean:
	$(RM) $(MAPS) $(TILES) $(PALETTES) $(META)

.PRECIOUS: $(PALETTES)

