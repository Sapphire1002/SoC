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
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {H:/SoC/SoC_HW 2017/SoC_pingpong/SoC_pingpong.cache/wt} [current_project]
set_property parent.project_path {H:/SoC/SoC_HW 2017/SoC_pingpong/SoC_pingpong.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo {h:/SoC/SoC_HW 2017/SoC_pingpong/SoC_pingpong.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib H:/SoC/SoC_pingpong_speed_v1.vhd
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc H:/SoC/SoC_pingpong_vivado.xdc
set_property used_in_implementation false [get_files H:/SoC/SoC_pingpong_vivado.xdc]


synth_design -top SoC_pingpong_v3 -part xc7z020clg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef SoC_pingpong_v3.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file SoC_pingpong_v3_utilization_synth.rpt -pb SoC_pingpong_v3_utilization_synth.pb"
