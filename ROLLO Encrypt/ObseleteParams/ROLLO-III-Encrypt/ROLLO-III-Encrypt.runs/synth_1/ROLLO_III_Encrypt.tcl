# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param simulator.modelsimInstallPath F:/modelsim64_10.1c/win64
create_project -in_memory -part xc7a200tsbv484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/ROLLO-III-Encrypt.cache/wt} [current_project]
set_property parent.project_path {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/ROLLO-III-Encrypt.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/ROLLO-III-Encrypt.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/define.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/clog2.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/K_Gen_Ctrl.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/RegFiles.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/c_Gen_Ctrl.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/Gaussian Elimination/comb_SA.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/encrypt_top.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/encrypt_top_tb.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/f_permutation.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/RNG/f_permutation_200.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/GF2mZ Arithmetic/gf2m_mul.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/GF2mZ Arithmetic/gf2mz_top.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/keccak.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/keccak_tb.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/mem_dp.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/mem_sp.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/GF2mZ Arithmetic/mul_ctrl.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/Gaussian Elimination/node.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/padder.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/padder1.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/RNG/prng.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/rconst.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/RNG/rconst_200.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/SHA3/round.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/Verilog/RNG/round_200.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/ROLLO-III-Encrypt.srcs/constrs_1/new/usr_constrain.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Encrypt/ROLLO-III-Encrypt/ROLLO-III-Encrypt.srcs/constrs_1/new/usr_constrain.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top ROLLO_III_Encrypt -part xc7a200tsbv484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef ROLLO_III_Encrypt.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file ROLLO_III_Encrypt_utilization_synth.rpt -pb ROLLO_III_Encrypt_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
