#!/bin/bash

# -e  Exit immediately if a command exits with a non-zero status.
set -e

SCRIPT_NAME=${0##*/}

### usage ###
function usage()
{
	echo "This script make porting from NXP SDK to Variscite boards"
	echo
	echo "SDK_2_10_0 Usage:"
	echo " 0. from http://mcuxpresso.nxp.com build project for proper EVK board"
	echo " 1. download SDK_2_10_0_EVK-MIMX8xx.tar.gz and uncompress it"
	echo " 2. download SDK_2_10_0_EVK-MIMX8xx_doc.tar.gz and uncompress it"
	echo " Note: download SDK_2_10_0_EVK-MIMX8xx and SDK_2_10_0_EVK-MIMX8xx_doc must have the same root dir"
	echo "---------------------------------------------------------------------------------------------------------------"
	echo " a. git clone https://github.com/varigit/freertos-variscite.git"
	echo " b. cd freertos-variscite"
	echo " c. git checkout --orphan mcuxpresso_sdk_2.10.x-var01"
	echo " d. git rm -rf ."
	echo " e. cp <specific som>-porting-freertos.sh freertos-variscite/"
	echo " f. cp ./${SCRIPT_NAME} freertos-variscite/"
	echo " g. ./${SCRIPT_NAME} SDK_2_10_0_EVK-MIMX8xx_PATH cmd"
	echo "---------------------------------------------------------------------------------------------------------------"
	echo " To test demos:"
	echo " a. create a copy of freertos-variscite (ex: freertos-variscite-test)"
	echo " b. cp build_test.sh clean_all.sh* xxxx-scp-binary-examples.sh  freertos-variscite-test/"
	echo " c. compile demos running: ./build_test.sh dart_mx8mp|som_mx8mp|dart_mx8mq|dart_mx8mm|som_mx8mn"
	echo " d. copy binary demos on target running:  ./xxxx-scp-binary-examples.sh dart_mx8mp|som_mx8mp|dart_mx8mq|dart_mx8mm|som_mx8mn elf|bin tcm|ddr <target IP address>"
	echo " e. copy xxxx-run-all-examples-m7.sh into target /lib/firmware folder"
	echo " f. run ./mx8mp-run-all-examples-m7|m4.sh from target /lib/firmware folder"
	echo "---------------------------------------------------------------------------------------------------------------"
	echo "Porting: example of use:"
	echo "  merge_nxp_sdk:                     ./${SCRIPT_NAME} SDK_PATH merge"
	echo "  make_dart_board                    ./${SCRIPT_NAME} SDK_PATH dart_mx8mp"
	echo "  make_som_board                     ./${SCRIPT_NAME} SDK_PATH som_mx8mp"
}

case $1 in
	*EVK-MIMX8MM* )
		# check for valid SDK folder
		if [ ! -d $1/boards/evkmimx8mm ]; then
			echo "Invalid SDK folder: <" $1 ">"
			exit 1
		fi
		readonly DART_BOARD_NAME="dart_mx8mm"
		readonly EVK_BOARD_NAME="evkmimx8mm"
		;;

	*EVK-MIMX8MN* )
		# check for valid SDK folder
		if [ ! -d $1/boards/evkmimx8mn ]; then
			echo "Invalid SDK folder: <" $1 ">"
			exit 1
		fi
		readonly SOM_BOARD_NAME="som_mx8mn"
		readonly EVK_BOARD_NAME="evkmimx8mn"
		;;

	*EVK-MIMX8MP* )
		# check for valid SDK folder
		if [ ! -d $1/boards/evkmimx8mp ]; then
			echo "Invalid SDK folder: <" $1 ">"
			exit 1
		fi
		readonly DART_BOARD_NAME="dart_mx8mp"
		readonly SOM_BOARD_NAME="som_mx8mp"
		readonly EVK_BOARD_NAME="evkmimx8mp"
		;;

	*EVK-MIMX8MQ* )
		# check for valid SDK folder
		if [ ! -d $1/boards/evkmimx8mq ]; then
			echo "Invalid SDK folder: <" $1 ">"
			exit 1
		fi
		readonly DART_BOARD_NAME="dart_mx8mq"
		readonly EVK_BOARD_NAME="evkmimx8mq"
		;;

	"" )
		usage
		exit 1
		;;

	* )
		echo "Invalid SDK folder: <" $1 ">"
		exit 1
		;;
	esac

# Merge with NXP SDK folders
# $1 - SDK_PATH
function merge_nxp_sdk()
{
	echo "I: merge_nxp_sdk"
	rsync -avP $1/. .
	rsync -avP $1_doc/docs/. ./docs/.
}

# Generate Variscite board ${DART_BOARD_NAME} starting from evk and apply changes
function make_dart_board()
{
	if [ -d boards/${DART_BOARD_NAME} ]; then
		echo "E: <${DART_BOARD_NAME}> already exist, remove it to continue !"
		usage
		exit 1
	fi

	#check if EVK board exist
	if [ ! -d boards/${EVK_BOARD_NAME} ]; then
		echo "merge SDK folder is need before generate ${DART_BOARD_NAME} board: <./${SCRIPT_NAME} SDK_PATH merge>"
		usage
		exit 1
	fi

	echo "I: generate ${DART_BOARD_NAME} board"
	#  Generate $DART_BOARD_NAME starting from $EVK_BOARD_NAME
	cp -r boards/${EVK_BOARD_NAME} boards/${DART_BOARD_NAME}

	case $DART_BOARD_NAME in
		dart_mx8mm )
			source mx8mm-dart-porting-freertos.sh
			make_dart_mx8mm
			;;
		dart_mx8mp )
			source mx8mp-dart-porting-freertos.sh
			make_dart_mx8mp
			;;
		dart_mx8mq )
			source mx8mq-dart-porting-freertos.sh
			make_dart_mx8mq
			;;
		* )
			echo "E: <${DART_BOARD_NAME}> is invalid !"
			exit 1
			;;
		esac

}

# Create Variscite board ${SOM_BOARD_NAME} from evk and apply changes
function make_som_board()
{
	if [ -d boards/${SOM_BOARD_NAME} ]; then
		echo "E: <${SOM_BOARD_NAME}> already exist, remove it to continue !"
		usage
		exit 1
	fi

	echo "I: create ${SOM_BOARD_NAME} board"
	#check if EVK board exist
	if [ ! -d boards/${EVK_BOARD_NAME} ]; then
		echo "E: merge SDK folder is need before create ${DART_BOARD_NAME} board: <./${SCRIPT_NAME} SDK_PATH merge>"
		usage
		exit 1
	fi

	# create $SOM_BOARD_NAME from $EVK_BOARD_NAME
	cp -r boards/${EVK_BOARD_NAME} boards/${SOM_BOARD_NAME}

	case $SOM_BOARD_NAME in
		som_mx8mn )
			source mx8mn-som-porting-freertos.sh
			make_som_mx8mn
			;;
		som_mx8mp )
			source mx8mp-som-porting-freertos.sh
			make_som_mx8mp
			;;
		* )
			echo "E: <${SOM_BOARD_NAME}> is invalid !"
			exit 1
			;;
		esac

}

case $2 in
	merge )
		merge_nxp_sdk $1
		;;
	$DART_BOARD_NAME )
		make_dart_board $1
		;;
	$SOM_BOARD_NAME )
		make_som_board $1
		;;
	* )
		usage
		exit 1
		;;
	esac

echo "porting completed"
exit
