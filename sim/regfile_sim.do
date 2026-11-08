vlib work
vcom src/regfile.vhd
vsim work.regfile
add wave /regfile/clk /regfile/wr_en
add wave -radix unsigned /regfile/WB_add
add wave -radix binary /regfile/WB
add wave -radix unsigned /regfile/A_add /regfile/B_add
add wave -radix binary /regfile/A /regfile/B
add wave -radix binary /regfile/myreg
force clk 0 0ns, 1 10ns -repeat 20ns
force wr_en 1
force A_add 0
force B_add 1
force WB_add 0
force WB 00000000
run 20 ns
force WB_add 1
force WB 00000001
run 20 ns
force WB_add 2
force WB 00000010
run 20 ns
force WB_add 3
force WB 00000011
run 20 ns
force wr_en 0
force A_add 0
force B_add 1
run 20 ns
force A_add 2
force B_add 3
run 20 ns
wave zoom full
