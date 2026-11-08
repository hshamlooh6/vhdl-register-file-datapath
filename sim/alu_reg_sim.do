vlib work
vcom src/alu_if.vhd
vcom src/regfile.vhd
vcom src/ALU_REG.vhd
vsim work.alu_reg
add wave /alu_reg/Clk /alu_reg/wr_en
add wave -radix unsigned /alu_reg/A_ad /alu_reg/B_ad /alu_reg/WB_ad
add wave -radix binary /alu_reg/oper
add wave -radix binary /alu_reg/x /alu_reg/y /alu_reg/Rout
add wave -radix binary /alu_reg/U1/myreg
force Clk 0 0ns, 1 10ns -repeat 20ns
force wr_en 1
force A_ad 0
force B_ad 1
force WB_ad 2
force oper 000
run 20 ns
force A_ad 2
force B_ad 3
force WB_ad 3
force oper 001
run 20 ns
force A_ad 0
force B_ad 1
force WB_ad 1
force oper 010
run 20 ns
force A_ad 2
force B_ad 3
force WB_ad 0
force oper 011
run 20 ns
wave zoom full
