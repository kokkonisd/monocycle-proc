VC = ghdl
WAVE = gtkwave
SIMTIME ?= 100ns
ASSERTLVL ?= warning
SOURCES = $(patsubst src/%.vhdl, %, $(wildcard src/*.vhdl)) $(patsubst %.vhd, %, $(wildcard src/*.vhd))

all: $(SOURCES)

ProcessingUnit: ALU RegisterBank

%: src/%.vhdl tb/%_tb.vhdl
	@echo ""
	@echo "\033[0;33m[Compiling \`$@.vhdl\` & \`$@_tb.vhdl\` ...]\033[0m"
	$(VC) -s src/$@.vhdl tb/$@_tb.vhdl
	$(VC) -a src/$@.vhdl tb/$@_tb.vhdl
	$(VC) -e $@_tb
	@echo "\033[0;33m[Running simulation of \`$@_tb\` ...]\033[0m"
	$(VC) -r $@_tb --vcd=simu/$@.vcd --assert-level=$(ASSERTLVL) --stop-time=$(SIMTIME) || (echo "\033[0;31m[\`$@\` FAIL]\033[0m"; exit 1)
	@echo "\033[0;32m[\`$@\` PASS]\033[0m"
	@echo ""

clean:
	rm -rf *.cf simu/*.vcd *_tb *.o
