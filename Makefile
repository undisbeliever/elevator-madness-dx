
BINARY      = bin/Elevator_Madess_DX.sfc
API_MODULES = reset-snes block screen metasprite math random
API_DIR     = snesdev-common
CONFIG      = LOROM_1MBit_copyright

SOURCES     = $(wildcard src/*.s)
OBJECTS     = $(patsubst src/%.s,obj/%.o,$(SOURCES))
HEADERS     = $(wildcard */*.inc */*.h)
RESOURCES   = $(wildcard resources/*)

API_OBJECTS = $(patsubst %,$(API_DIR)/obj/%.o, $(API_MODULES))
CONFIG_FILE = $(API_DIR)/config/$(CONFIG).cfg

.PHONY: all
all: resources api $(BINARY)

$(BINARY): $(API_OBJECTS) $(OBJECTS)
	ld65 -vm -m $(@:.sfc=.memlog) -C $(CONFIG_FILE) -o $@ $^

obj/%.o: src/%.s $(HEADERS) $(CONFIG_FILE) $(API_OBJECTS) $(RESOURCES)
	ca65 -I . -I $(API_DIR) -o $@ $<

.PHONY: resources
resources:
	cd resources/ && $(MAKE)

.PHONY: api
api:
	cd $(API_DIR) && $(MAKE)

.PHONY: clean
clean:
	$(RM) $(OBJECTS) $(BINARY)
	cd resources/ && $(MAKE) clean

.PRECIOUS: $(OBJECTS)

