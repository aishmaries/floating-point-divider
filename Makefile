.PHONY: all clean waveform.vcd		#runs these rules regardless of changes to dependencies

DIV = fp_divider.sv
OUT = build/output


all: build/waveform.vcd

waveform.vcd: output
	./$(OUT)

output: $(DIV)
	iverilog -Wall -g2012 -o $(OUT) $(DIV)

clean:
	rm $(OUT) build/waveform.vcd