######################################################################
#
# File name : comb_SA_simulate.do
# Created on: Wed Mar 11 11:03:56 +0800 2020
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.comb_SA xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {comb_SA_wave.do}

view wave
view structure
view signals

do {comb_SA.udo}

run 1000ns
