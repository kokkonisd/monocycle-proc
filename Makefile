VC = ghdl
WAVE = gtkwave
SIMTIME ?= 100ns
ASSERTLVL ?= warning
SOURCES = $(patsubst src/%.vhdl, %, $(wildcard src/*.vhdl)) $(patsubst %.vhd, %, $(wildcard src/*.vhd))
SIMS = $(wildcard simu/*.vcd)

all: $(SOURCES)

wave: $(SOURCES)
	$(WAVE) $(SIMS)

ProcessingUnit: ALU RegisterBank

%: src/%.vhdl tb/%_tb.vhdl
	@echo "\033[0;33m"
	@echo "[Compiling \`$@.vhdl\` & \`$@_tb.vhdl\` ...]"
	@echo "\033[0m"
	$(VC) -s src/$@.vhdl tb/$@_tb.vhdl
	$(VC) -a src/$@.vhdl tb/$@_tb.vhdl
	$(VC) -e $@_tb
	$(VC) -r $@_tb --vcd=simu/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME)
	@echo ""

clean:
	rm -rf *.cf simu/*.vcd
