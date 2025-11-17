# ==== Build Makefile (actual compile/sim lives here) ====
TOP        := top_general
TESTBENCH  := ../sim/top_general_tb.sv
SRC_DIR    := ../design
SIM_DIR    := ../sim
BUILD_DIR  := .

SRC        := $(wildcard $(SRC_DIR)/*.sv) $(wildcard $(SRC_DIR)/*/*.sv)
INC        := -I$(SRC_DIR) -I$(SIM_DIR)

IVERILOG   ?= iverilog
VVP        ?= vvp
GTKWAVE    ?= gtkwave
IVERILOG_FLAGS := -DSIMULATION

$(SIMVVP): $(TESTBENCH) $(SRC)
	$(IVERILOG) -g2012 $(IVERILOG_FLAGS) $(INC) -o "$(SIMVVP)" $(TESTBENCH) $(SRC)

VCD        := $(BUILD_DIR)/module_top_general_tb.vcd
SIMVVP     := $(BUILD_DIR)/sim.vvp

.PHONY: all sim waves clean help synth prog

all: sim

sim: $(SIMVVP)
	$(VVP) "$(SIMVVP)"

$(SIMVVP): $(TESTBENCH) $(SRC)
	$(IVERILOG) -g2012 $(INC) -o "$(SIMVVP)" $(TESTBENCH) $(SRC)

waves:
	$(GTKWAVE) "$(VCD)" &

clean:
	@echo Cleaning...
	@rm -f "$(SIMVVP)" "$(VCD)"

synth:
	@echo "Síntesis: usa Gowin IDE o Yosys/nextpnr-gowin."

prog:
	@echo "Programación: usa Gowin Programmer u openFPGALoader."

help:
	@echo "Targets: sim, waves, clean, synth, prog"
