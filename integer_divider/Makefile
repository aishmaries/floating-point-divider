.PHONY: all clean

DIV = int_divider_alt.sv
TB = tb_int_divider.sv
OUT = build/output
VCD = waveform.vcd

all: $(VCD)

$(VCD): $(OUT)
	./$(OUT)

$(OUT): $(DIV) $(TB)
	mkdir -p build
	iverilog -Wall -g2012 -o $(OUT) $(DIV) $(TB)

clean:
	rm -f $(OUT) $(VCD)