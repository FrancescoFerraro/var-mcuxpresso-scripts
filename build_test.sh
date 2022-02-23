#!/bin/sh

SCRIPT_NAME=${0##*/}

# -e  Exit immediately if a command exits with a non-zero status.
set -e

reset

BOARD_DIR=$1

case $BOARD_DIR in
	dart_mx8mm )
		;;
	dart_mx8mp )
		;;
	som_mx8mp )
		;;
	dart_mx8mq )
		;;
	evkmimx8mn )
		;;
	som_mx8mn )
		;;
	som_mx8qm )
		;;
	som_mx8qx )
		;;
	* )
		echo "Usage: <${SCRIPT_NAME}> dart_mx8mm|dart_mx8mp|som_mx8mp|dart_mx8mq|som_mx8mn|som_mx8qm|som_mx8qx"
		exit 1
		;;
	esac


for i in $(find boards/$BOARD_DIR -name armgcc)
do
    cd $i
    ./clean.sh
    if [ -f build_release.sh ]; then
        ./build_release.sh > /dev/null 2>&1
        echo $i: $(ls release)
    fi
    if [ -f build_ddr_release.sh ]; then
        ./build_ddr_release.sh > /dev/null 2>&1
        echo $i: $(ls ddr_release)
    fi
    cd - > /dev/null
done
