# build project

set scriptsDir [file normalize [file dirname [info script]]]
set projectDir [file normalize $scriptsDir/../project]
#set projectDir [file normalize [file $scriptsDir/../project]]
file mkdir $projectDir
cd $projectDir
source $scriptsDir/project_config.tcl

puts ""
puts "scriptsDir : $scriptsDir"
puts "projectDir : $projectDir"
puts ""

createVivadoProject

addHDL

genIP

addConstraints

#runSynthesis

#runImplementationAndGenBitstream

# getBitstreamImgs


