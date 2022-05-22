#!/bin/bash
SCRIPT_NAME=${0##*/}

BOARD_FOLDER=$1
FW_TYPE=$2
TARGET=$3
IP=$4
TARGET_FOLDER=ddr_release
OUTPUT_DIR=/lib/firmware

case $BOARD_FOLDER in
	dart_mx8mp* )
		;;
	som_mx8mp* )
		;;
	dart_mx8mm* )
		;;
	som_mx8mn* )
		;;
	dart_mx8mq* )
		;;
	* )
		echo "E: Invalid board folder: <" $BOARD_FOLDER ">"
		echo "Usage: ./${SCRIPT_NAME} <dart_mx8mp|som_mx8mp|dart_mx8mp-tc|som_mx8mp-tc> <elf|bin> <tcm|ddr> <target IP>"
		exit 1
		;;
	esac

case $TARGET in
	tcm )
		TARGET_FOLDER=release
		;;
	ddr )
		TARGET_FOLDER=ddr_release
		;;
	* )
		echo "E: Invalid target: <" $TARGET ">"
		echo "Usage: ./${SCRIPT_NAME} <dart_mx8mp|som_mx8mp|dart_mx8mp-tc|som_mx8mp-tc> <elf|bin> <tcm|ddr> <target IP>"
		exit 1
		;;
	esac

case $IP in
	"" )
		echo "E: Invalid ip: <" $IP ">"
		echo "Usage: ./${SCRIPT_NAME} <dart_mx8mp|som_mx8mp|dart_mx8mp-tc|som_mx8mp-tc> <elf|bin> <tcm|ddr> <target IP>"
		exit 1
		;;
	esac

case $FW_TYPE in
	elf )
		OUTPUT_DIR=/lib/firmware
		;;
	bin )
		OUTPUT_DIR=/boot
		;;
	* )
		echo "E: Invalid firmware type: <" $FW_TYPE ">"
		echo "Usage: ./${SCRIPT_NAME} <dart_mx8mp|som_mx8mp|dart_mx8mp-tc|som_mx8mp-tc> <elf|bin> <tcm|ddr> <target IP>"
		exit 1
		;;
	esac

for i in $(find boards/$BOARD_FOLDER -name armgcc)
do
	cd $i/$TARGET_FOLDER
	for y in *.$FW_TYPE
	do
		#echo "found file :" $y
		scp $y root@$IP:$OUTPUT_DIR/$y.$TARGET
	done
	cd - > /dev/null
done
exit
