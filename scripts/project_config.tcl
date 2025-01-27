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
	
	# sim sources (tbs)
	read_vhdl [glob $sourceDir/sim/tbs/*.vhd]	
	set_property used_in_synthesis false [get_files [glob $sourceDir/sim/tbs/*.vhd]]

}

proc genIP {} {
	# no IP yet
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