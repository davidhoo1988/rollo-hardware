######################################################################
#
# File name : keccak_tb_simulate.do
# Created on: Mon Sep 21 17:53:03 +0800 2020
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.keccak_tb xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {keccak_tb_wave.do}

view wave
view structure
view signals

do {keccak_tb.udo}

run 1000ns
