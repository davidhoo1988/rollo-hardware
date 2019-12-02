onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /GF2m_mul_tb/DUT/clk
add wave -noupdate /GF2m_mul_tb/DUT/rst_b
add wave -noupdate /GF2m_mul_tb/DUT/start
add wave -noupdate /GF2m_mul_tb/DUT/done
add wave -noupdate /GF2m_mul_tb/DUT/op_a
add wave -noupdate /GF2m_mul_tb/DUT/op_b
add wave -noupdate /GF2m_mul_tb/DUT/op_c
add wave -noupdate /GF2m_mul_tb/DUT/cx1
add wave -noupdate /GF2m_mul_tb/DUT/cx
add wave -noupdate /GF2m_mul_tb/DUT/a
add wave -noupdate /GF2m_mul_tb/DUT/b
add wave -noupdate /GF2m_mul_tb/DUT/c
add wave -noupdate /GF2m_mul_tb/DUT/start_en
add wave -noupdate -color Gold -radix unsigned -radixshowbase 0 /GF2m_mul_tb/DUT/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {955058 ps} 0} {{Cursor 2} {1965228 ps} 0} {{Cursor 3} {2975965 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 395
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2934008 ps} {3042552 ps}
bookmark add wave bookmark0 {{999194 ps} {1000043 ps}} 0
