# build script

SOURCE="${BASH_SOURCE[0]}"
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
PROJECT_DIR="$( realpath $SCRIPT_DIR/../project )"

if [ ! $(command -v vivado >/dev/null 2>&1)]; then

	echo ""
	echo "Trying to use \$XILINX_VIVADO"
	
	if [ -z $XILINX_VIVADO ] ; then
		echo "The XILINX_VIVADO variable has not been set." 
		echo "Perform the following command:"
		echo "export XILINX_VIVADO=/path/to/vivado/2019.1"
		
		if [ ! -e $XILINX_VIVADO/bin/vivado ]; then
			echo "Couldn't find a candidate Vivado installation."
			exit 1
		fi
		echo "Using $XILINX_VIVADO..."
	else
		echo "Found Vivado at $XILINX_VIVADO"
	fi
fi	



# do export XILINX_VIVADO = <path/to/vivado>
# EX: /c/Xilinx/Vivado/2019.1
$XILINX_VIVADO/bin/vivado.bat -mode batch -source $SCRIPT_DIR/build_project.tcl

rm $SCRIPT_DIR/../*.jou
rm $SCRIPT_DIR/../*.log

echo ""
echo "-----------------------------------"
echo "Project located in : " $PROJECT_DIR
echo "-----------------------------------"
echo "" 	