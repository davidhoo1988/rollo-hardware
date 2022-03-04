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
set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a200tsbg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/ROLLO-I-Decrypt.cache/wt} [current_project]
set_property parent.project_path {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/ROLLO-I-Decrypt.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/ROLLO-I-Decrypt.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib {
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/S1S2_gen.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/gf2m_mul.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/clog2.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/mul_ctrl.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/gf2mz_top.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/mem_dp.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/define.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/decrypt_top.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/ctrl_top.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/mem_sp.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/gs_elim_ctrl-fat.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/comb_SA.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/gs_elim_top.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/node.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/padder.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/keccak.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/padder1.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/rconst.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/round.v}
  {C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/Verilog/f_permutation.v}
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/ROLLO-I-Decrypt.srcs/constrs_1/new/usr_constrain.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/David/Dropbox/LRPC Code/hardware/ROLLO Decrypt/ROLLO-I-Decrypt/ROLLO-I-Decrypt.srcs/constrs_1/new/usr_constrain.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top decrypt_top -part xc7a200tsbg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef decrypt_top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file decrypt_top_utilization_synth.rpt -pb decrypt_top_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
