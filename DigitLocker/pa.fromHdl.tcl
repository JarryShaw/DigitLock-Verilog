
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name DigitLocker -dir "C:/Xilinx/DigitLocker/planAhead_run_2" -part xc3s100ecp132-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "locker_top.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {DigitLocker.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top locker_top $srcset
add_files [list {locker_top.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s100ecp132-5
