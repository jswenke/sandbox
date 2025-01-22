# project config

set PROJECT_NAME sandbox
set PART_TYPE xc7a100tcsg324-1

set scriptsDir 		[file normalize [file dirname [info script]]]
set projectDir 		[file normalize $scriptsDir/..]
set sourceDir  		[file normalize $projectDir/source]
set constraintsDir 	[file normalize $sourceDir/constraints]


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
	global PART_TYPE
	global sourceDir
	
	read_vhdl [glob $sourceDir/rtl/*.vhd]
	read_vhdl [glob $sourceDir/rtl/*/*.vhd]
	
	read_vhdl [glob $sourceDir/sim/tbs/*.vhd]
	# doublecheck syntax
	#set_property used_in_synthesis false 

}

proc genIP {} {
	# no IP yet
}

proc addConstraints {} {
	
}

proc doSynthesis {} {
	# WIP
}

proc doImplementation {} {
	# WIP
}

proc genBitstream {} {
	# WIP
}