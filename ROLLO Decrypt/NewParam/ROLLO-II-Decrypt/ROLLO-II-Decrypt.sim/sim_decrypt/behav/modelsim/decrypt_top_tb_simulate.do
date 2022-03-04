######################################################################
#
# File name : decrypt_top_tb_simulate.do
# Created on: Tue Apr 13 13:56:34 +0800 2021
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.decrypt_top_tb xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {decrypt_top_tb_wave.do}

view wave
view structure
view signals

do {decrypt_top_tb.udo}

run 1000ns
