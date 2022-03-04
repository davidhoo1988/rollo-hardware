onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/clk
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/start
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/rst_b
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/done
add wave -noupdate -radix binary /encrypt_top_tb/DUT/K_Gen_Ctrl/rng_data
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/rng_finish
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/rng_start
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/rng_seed
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/rng_in_mod
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_data_in
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_rw
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_ctrl_w
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_addr
add wave -noupdate -radix binary /encrypt_top_tb/DUT/K_Gen_Ctrl/E_data_out
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_finish
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_full_rank
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_data_in
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_mode
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_start
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_data_out
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_rref_data_in
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_rref_rw
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_rref_addr
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_rref_data_out
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/sha3_finish
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/sha3_mem_addr
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/sha3_mem_rw
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/sha3_mem_dout
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/sha3_start
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/c_gen_start
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_done
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_done
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_rref_done
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/SHA3_done
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/GS_start_tmp
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/E_addr_tmp
add wave -noupdate -color Gold -radix unsigned -radixshowbase 0 /encrypt_top_tb/DUT/K_Gen_Ctrl/state
add wave -noupdate /encrypt_top_tb/DUT/K_Gen_Ctrl/next_state
add wave -noupdate /encrypt_top_tb/DUT/E/clk
add wave -noupdate /encrypt_top_tb/DUT/E/rst_b
add wave -noupdate /encrypt_top_tb/DUT/E/rw
add wave -noupdate /encrypt_top_tb/DUT/E/ctrl_w
add wave -noupdate /encrypt_top_tb/DUT/E/addr
add wave -noupdate /encrypt_top_tb/DUT/E/data_in
add wave -noupdate /encrypt_top_tb/DUT/E/data_out
add wave -noupdate /encrypt_top_tb/DUT/E/acc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {164896 ps} 0} {{Cursor 2} {3084896 ps} 0} {{Cursor 3} {5004913 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 328
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
WaveRestoreZoom {4921693 ps} {5109385 ps}
