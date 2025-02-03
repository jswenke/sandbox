# project config

set PROJECT_NAME sandbox
set PART_TYPE xc7a100tcsg324-1

set scriptsDir 		[file normalize [file dirname [info script]]]
set projectDir 		[file normalize $scriptsDir/../project]
set sourceDir  		[file normalize $projectDir/../source]
set constraintsDir 	[file normalize $sourceDir/../source/constraints]


proc createVivadoProject {} {

	global PROJECT_NAME
	global PART_TYPE
	
	create_project -part $PART_TYPE -force $PROJECT_NAME
	set_property target_language VHDL [current_project]
	set_property top ${PROJECT_NAME}_top [current_fileset]
	config_webtalk -user off
	
}

proc addHDL {} {

	global PROJECT_NAME
	global sourceDir
	
	# design sources
	read_vhdl [glob $sourceDir/rtl/*.vhd]
	set_property top ${PROJECT_NAME}_top [current_fileset]
	read_vhdl [glob $sourceDir/rtl/*/*.vhd]	
	read_vhdl [glob $sourceDir/rtl/*/*/*.vhd]	
	set_property library utils_lib [get_files [glob $sourceDir/rtl/js_ip/utils_lib/*.vhd]]

	# sim sources (tbs)
	read_vhdl [glob $sourceDir/sim/tbs/*.vhd]	
	set_property used_in_synthesis false [get_files [glob $sourceDir/sim/tbs/*.vhd]]

}

proc genIP {} {
	# no IP yet
	create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name blk_mem_dram_0 -dir $sourceDir/rtl/xil_and_3rds_ip
	set_property -dict [list CONFIG.Component_Name {blk_mem_dram_0} CONFIG.Interface_Type {Native} CONFIG.Use_AXI_ID {false} CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Assume_Synchronous_Clk {true} CONFIG.Write_Width_A {32} CONFIG.Write_Depth_A {16} CONFIG.Read_Width_A {32} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {32} CONFIG.Read_Width_B {32} CONFIG.Operating_Mode_B {READ_FIRST} CONFIG.Enable_B {Always_Enabled} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Use_RSTB_Pin {false} CONFIG.Reset_Type {SYNC} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100} CONFIG.EN_SAFETY_CKT {false}] [get_ips blk_mem_dram_0]
	generate_target {instantiation_template} [get_files $sourceDir/rtl/xil_and_3rds_ip/blk_mem_dram_0/blk_mem_dram_0.xci]
	generate_target all [get_files  $sourceDir/rtl/xil_and_3rds_ip/blk_mem_dram_0/blk_mem_dram_0.xci]
	catch { config_ip_cache -export [get_ips -all blk_mem_dram_0] }
	export_ip_user_files -of_objects [get_files $sourceDir/rtl/xil_and_3rds_ip/blk_mem_dram_0/blk_mem_dram_0.xci] -no_script -sync -force -quiet

}

proc addConstraints {} {
	
	global PROJECT_NAME
	global PART_TYPE
	global constraintsDir
	global projectDir
	
	create_fileset -constrset constr_set_${PART_TYPE}_default
	file mkdir $projectDir/${PROJECT_NAME}.srcs/constr_set_${PART_TYPE}_default
	add_files -fileset constr_set_${PART_TYPE}_default $constraintsDir/default_nexysa7100t/nexysa7_constraints.xdc
	set_property target_constrs_file $constraintsDir/default_nexysa7100t/nexysa7_constraints.xdc [get_filesets constr_set_${PART_TYPE}_default]
	
	create_fileset -constrset constr_set_others
	file mkdir $projectDir/${PROJECT_NAME}.srcs/constr_set_others
	add_files -fileset constr_set_others [glob $constraintsDir/*.xdc]
	
}

proc runSynthesis {} {

	launch_runs synth_1 -jobs 12
	wait_on_run synth_1

	if {[get_property STATUS [get_runs synth_1]] != {synth_design Complete!}} {
		puts "Synthesis failed."
		exit 1
	}
}

proc runImplementationAndGenBitstream {} {
	
	launch_runs impl_1 -to_step write_bitstream
	wait_on_run impl_1
	
	set systemTime [clock seconds]
	puts "Time now : [clock format $systemTime -format %HL:%M:%S]"
	
	if {[get_property STATUS [get_runs impl_1]] != {write_bitstream Complete!}} {
		puts "Implementation failed."
		exit 2
	}
	
}

proc getBitstreamImgs {} {
	# WIP
}