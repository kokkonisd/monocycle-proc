VC = ghdl
WAVE = gtkwave
SIMTIME ?= 100ns
ASSERTLVL ?= warning
SOURCES = $(patsubst src/%.vhdl, %, $(wildcard src/*[!_tb].vhdl)) $(patsubst %.vhd, %, $(wildcard src/*[!_tb].vhd))
TBS = $(patsubst %.vhdl, %, $(wildcard src/*_tb.vhdl)) $(patsubst %.vhd, %, $(wildcard src/*_tb.vhd))
SIMS = $(wildcard simu/*.vcd)

all: $(SOURCES)

wave: $(SOURCES)
	$(WAVE) $(SIMS)

%: src/%.vhdl src/%_tb.vhdl
	$(VC) -s src/$@.vhdl
	$(VC) -a src/$@.vhdl
	$(VC) -s src/$@_tb.vhdl
	$(VC) -a src/$@_tb.vhdl
	$(VC) -e $@_tb
	$(VC) -r $@_tb --vcd=simu/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME)

clean:
	rm -rf *.cf simu/*.vcd
