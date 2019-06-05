VC = ghdl
WAVE = gtkwave
SIMTIME ?= 100ns
ASSERTLVL ?= warning
SOURCES = $(patsubst %.vhdl, %, $(wildcard *[!_tb].vhdl)) $(patsubst %.vhd, %, $(wildcard *[!_tb].vhd))
TBS = $(patsubst %.vhdl, %, $(wildcard *_tb.vhdl)) $(patsubst %.vhd, %, $(wildcard *_tb.vhd))
SIMS = $(patsubst %, %.vcd, $(SOURCES))

all: $(SOURCES)

wave: $(SOURCES)
	$(WAVE) $(SIMS)

%: %.vhdl %_tb.vhdl
	$(VC) -s $@.vhdl
	$(VC) -a $@.vhdl
	$(VC) -s $@_tb.vhdl
	$(VC) -a $@_tb.vhdl
	$(VC) -e $@_tb
	$(VC) -r $@_tb --vcd=$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME)

clean:
	rm -rf *.o *.cf *.vcd
