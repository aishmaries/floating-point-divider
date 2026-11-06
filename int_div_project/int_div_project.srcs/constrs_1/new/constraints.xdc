create_clock -name vclk -period 5.0

set_input_delay 0 -clock vclk [all_inputs]

set_output_delay 0 -clock vclk [all_outputs]