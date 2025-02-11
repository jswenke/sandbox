# clean

SOURCE="${BASH_SOURCE[0]}"
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
PROJECT_DIR="$( realpath $SCRIPT_DIR/../project )"
#BDSYS_DIR="$( realpath $SCRIPT_DIR/../source/bd/system )"

rm $PROJECT_DIR/* 2> /dev/null
rm -rf $PROJECT_DIR/* 2> /dev/null
rm -rf $PROJECT_DIR/.Xil 2> /dev/null

#rm -rf $BDSYS_DIR/ip/* 2> /dev/null
#rmdir $BDSYS_DIR/ip 2> /dev/null
#rm $BDSYS_DIR/*.bda 2> /dev/null
#rm $BDSYS_DIR/*.bxml 2> /dev/null

echo "Cleaned project, re-run build.sh"