
MAPS      = $(patsubst %.pcx,%.map,$(wildcard images4bpp/*.pcx))
TILES    += $(patsubst %.pcx,%.4bpp,$(wildcard images4bpp/*.pcx))
TILES    += $(patsubst %.pcx,%.4bpp,$(wildcard tiles4bpp/*.pcx))
TILES    += $(patsubst %.pcx,%.2bpp,$(wildcard tiles2bpp/*.pcx))
PALETTES  = $(patsubst %.4bpp,%.clr,$(patsubst %.2bpp,%.clr,$(TILES)))

.PHONY: ALL

ALL: metasprites $(MAPS) $(TILES) $(PALETTES)

tiles2bpp/%.2bpp tiles2bpp/%.clr: tiles2bpp/%.pcx
	pcx2snes -n -s8 -c4 -o4 $(basename $<)
	mv $(basename $<).pic $(basename $<).2bpp

tiles4bpp/%.4bpp tiles4bpp/%.clr: tiles4bpp/%.pcx
	pcx2snes -n -s8 -c16 -o16 $(basename $<)
	mv $(basename $<).pic $(basename $<).4bpp

images4bpp/%.map images4bpp/%.4bpp images4bpp/%.clr: images4bpp/%.pcx
	pcx2snes -r -s8 -c16 -screen $(basename $<)
	mv $(basename $<).pic $(basename $<).4bpp


.PHONY: metasprites
metasprites:
	cd metasprites/ && $(MAKE)


.PHONY: clean
clean:
	$(RM) $(MAPS) $(TILES) $(PALETTES)
	cd metasprites/ && $(MAKE) clean

.PRECIOUS: $(PALETTES)

