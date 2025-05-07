# build script

USER_ID=1
SOURCE="${BASH_SOURCE[0]}"
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
PROJECT_DIR="$( realpath $SCRIPT_DIR/../project )"

#if [ "$USER_ID" -eq 1 ]; then
#	XILINX_VIVADO=/z/Xilinx/Vivado/2019.1
	
#else

source $SCRIPT_DIR/env.sh

	if [ ! $(command -v vivado >/dev/null 2>&1)]; then

		echo ""
		echo "Trying to use \$XILINX_VIVADO"
		
		if [ -z $XILINX_VIVADO ] ; then
			echo "The XILINX_VIVADO variable has not been set." 
			echo ""
			echo "Perform the following command:"
			echo "export XILINX_VIVADO=/path/to/vivado/2019.1"
			echo ""
			echo "EX: export XILINX_VIVADO=/z/Xilinx/Vivado/2019.1"
			
			if [ ! -e $XILINX_VIVADO/bin/vivado ]; then
				echo "Couldn't find a candidate Vivado installation."
				exit 1
			fi
			echo "Using $XILINX_VIVADO..."
		else
			echo "Found Vivado at $XILINX_VIVADO"
		fi
	fi	
#fi	





# do export XILINX_VIVADO = <path/to/vivado>
# EX: /c/Xilinx/Vivado/2019.1
$XILINX_VIVADO/bin/vivado -mode batch -source $SCRIPT_DIR/build_project.tcl

rm $SCRIPT_DIR/*.jou 2> /dev/null
rm $SCRIPT_DIR/*.log 2> /dev/null
rm $SCRIPT_DIR/../*.jou 2> /dev/null
rm $SCRIPT_DIR/../*.log 2> /dev/null

echo ""
echo "Project located in : " $PROJECT_DIR
echo "" 	
