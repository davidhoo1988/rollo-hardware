onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /GF2m_mul_digit_tb/DUT/clk
add wave -noupdate /GF2m_mul_digit_tb/DUT/rst_b
add wave -noupdate /GF2m_mul_digit_tb/DUT/start
add wave -noupdate /GF2m_mul_digit_tb/DUT/op_a
add wave -noupdate /GF2m_mul_digit_tb/DUT/op_b
add wave -noupdate /GF2m_mul_digit_tb/DUT/done
add wave -noupdate -itemcolor {Orange Red} /GF2m_mul_digit_tb/DUT/op_c
add wave -noupdate /GF2m_mul_digit_tb/DUT/cx1
add wave -noupdate /GF2m_mul_digit_tb/DUT/cx
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx0
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx1
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx2
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx3
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx4
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx5
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx6
add wave -noupdate /GF2m_mul_digit_tb/DUT/bx7
add wave -noupdate /GF2m_mul_digit_tb/DUT/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/b
add wave -noupdate /GF2m_mul_digit_tb/DUT/c
add wave -noupdate /GF2m_mul_digit_tb/DUT/start_en
add wave -noupdate -color Gold -radix unsigned -radixshowbase 0 /GF2m_mul_digit_tb/DUT/cnt
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_1/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_1/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_1/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_1/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_2/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_2/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_2/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_2/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_3/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_3/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_3/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_3/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_4/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_4/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_4/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_4/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_5/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_5/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_5/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_5/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_6/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_6/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_6/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_6/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_7/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_7/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_7/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_7/px1
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_8/a
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_8/p
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_8/px
add wave -noupdate /GF2m_mul_digit_tb/DUT/shift_8/px1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {264955 ps} 0} {{Cursor 2} {1275075 ps} 0} {{Cursor 3} {2285075 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 291
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
WaveRestoreZoom {214749 ps} {315162 ps}
