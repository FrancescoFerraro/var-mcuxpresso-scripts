#!/bin/bash

# -e  Exit immediately if a command exits with a non-zero status.
set -e

function make_som_mx8mp()
{

	#remove audio example
	rm -r boards/som_mx8mp/driver_examples/sai
	rm -r boards/som_mx8mp/driver_examples/asrc
	rm -r boards/som_mx8mp/driver_examples/pdm
	rm -r boards/som_mx8mp/demo_apps/sai_low_power_audio

	# The changes in the clock_config.c files are need to avoid the M7 stuck after Power up the audiomix domain by M7 core.
	# This happen when loading M7 binaries from linux user space using remoteproc framework.
	# Disabling Audio Clock Initialization is not relevant for variscite boards because the audio is not supported
	#
	echo "Disable Audio Clock Initialization due to Variscite SDK doesn't support Audio"
	for i in $(find boards/som_mx8mp -name "clock_config.c"); do
	  # Insert a line after match found
	  sed -i '/fsl_audiomix.h.*/a #undef  SUPPORT_RPMSG_AUDIO\n' "$i"
	  # Insert a line before match found
	  sed -i '/CLOCK_InitAudioPll1.*/i #ifdef SUPPORT_RPMSG_AUDIO' "$i"
	  # Insert a line after match found
	  sed -i '/CLOCK_InitAudioPll2.*/a #endif' "$i"
	  # Insert a line before match found
	  sed -i '/CLOCK_EnableClock(kCLOCK_Audio.*/i #ifdef SUPPORT_RPMSG_AUDIO' "$i"
	  # Insert a line after match found
	  sed -i '/CLOCK_EnableClock(kCLOCK_Audio.*/a #endif' "$i"
	  # Insert a line before match found
	  sed -i '/Power up the audiomix domain by M7 core.*/i #ifdef SUPPORT_RPMSG_AUDIO' "$i"
	  # Insert a line after match found
	  sed -i '/AUDIOMIX_InitAudioPll.*/a #endif' "$i"
	done

	for i in $(find boards/som_mx8mp -name "clock_config.c"); do
	  sed -i '/#undef  SUPPORT_RPMSG_AUDIO/{x;p;x;}' "$i"
	done

	echo "Replace I2C3 with I2C4"
	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_I2C3_SCL_I2C3_SCL/IOMUXC_I2C4_SCL_I2C4_SCL/g' "$i"
	  sed -i 's/IOMUXC_I2C3_SDA_I2C3_SDA/IOMUXC_I2C4_SDA_I2C4_SDA/g' "$i"
	  sed -i 's/IOMUXC_I2C3_SCL_GPIO5_IO18/IOMUXC_I2C4_SCL_GPIO5_IO20/g' "$i"
	  sed -i 's/IOMUXC_I2C3_SDA_GPIO5_IO19/IOMUXC_I2C4_SDA_GPIO5_IO21/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "*i2c*.c"); do
	  sed -i 's/I2C3/I2C4/g' "$i"
	  sed -i 's/kCLOCK_RootI2c3/kCLOCK_RootI2c4/g' "$i"
	  sed -i 's/Driver_I2C3/Driver_I2C4/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "pin_mux.h"); do
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "RTE_Device.h"); do
	  sed -i 's/RTE_I2C3/RTE_I2C4/g' "$i"
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  sed -i 's/pin_num: AJ7, peripheral: I2C3, signal: i2c_scl, pin_signal: I2C3_SCL/pin_num: AF8, peripheral: I2C4, signal: i2c_scl, pin_signal: I2C4_SCL/g' "$i"
	  sed -i 's/pin_num: AJ6, peripheral: I2C3, signal: i2c_sda, pin_signal: I2C3_SDA/pin_num: AD8, peripheral: I2C4, signal: i2c_sda, pin_signal: I2C4_SDA/g' "$i"
	  sed -i "s/pin_num: AJ7, peripheral: GPIO5, signal: 'gpio_io, 18', pin_signal: I2C3_SCL/pin_num: AF8, peripheral: GPIO5, signal: 'gpio_io, 20', pin_signal: I2C4_SCL/g" "$i"
	  sed -i "s/pin_num: AJ6, peripheral: GPIO5, signal: 'gpio_io, 19', pin_signal: I2C3_SDA/pin_num: AD8, peripheral: GPIO5, signal: 'gpio_io, 21', pin_signal: I2C4_SDA/g" "$i"
	done

	echo "Replace PWM4 with PWM2"
	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_SAI5_RXFS_PWM4_OUT/IOMUXC_GPIO1_IO11_PWM2_OUT/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "pwm.c"); do
	  sed -i 's/PWM4/PWM2/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  sed -i 's/pin_num: AC14, peripheral: PWM4, signal: pwm_out, pin_signal: SAI5_RXFS/pin_num: AE18, peripheral: PWM2, signal: pwm_out, pin_signal: GPIO1_IO11/g' "$i"
	done

	echo "Replace FLEXCAN1 with FLEXCAN2"
	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i "/{pin_num: AC18, peripheral: GPIO5, signal:/,0d" "$i"
	  sed -i '/IOMUXC_SPDIF_EXT_CLK_GPIO5_IO05/,+4d' "$i"
	  sed -i 's/IOMUXC_SPDIF_RX_CAN1_RX/IOMUXC_UART3_TXD_CAN2_RX/g' "$i"
	  sed -i 's/IOMUXC_SPDIF_TX_CAN1_TX/IOMUXC_UART3_RXD_CAN2_TX/g' "$i"
	  sed -i 's/pin_num: AD18, peripheral: FLEXCAN1, signal: can_rx, pin_signal: SPDIF_RX/pin_num: AJ4, peripheral: FLEXCAN2, signal: can_rx, pin_signal: UART3_TXD/g' "$i"
	  sed -i 's/pin_num: AE18, peripheral: FLEXCAN1, signal: can_tx, pin_signal: SPDIF_TX/pin_num: AE6, peripheral: FLEXCAN2, signal: can_tx, pin_signal: UART3_RXD/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "flexcan*.c"); do
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i '/GPIO5_IO05 is used to control CAN1_STBY/,+3d' "$i"
	  sed -i 's/FLEXCAN1/FLEXCAN2/g' "$i"
	  sed -i 's/CAN_FD1_IRQn/CAN_FD2_IRQn/g' "$i"
	  sed -i 's/CAN_FD1_IRQHandler/CAN_FD2_IRQHandler/g' "$i"
	  sed -i 's/kCLOCK_RootFlexCan1/kCLOCK_RootFlexCan2/g' "$i"
	  sed -i 's/Set FLEXCAN1 source to SYSTEM PLL1 800MHZ/Set FLEXCAN2 source to SYSTEM PLL1 800MHZ/g' "$i"
	done

	echo "Adjust Led output"
	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_NAND_READY_B_GPIO3_IO16/IOMUXC_NAND_DQS_GPIO3_IO14/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "gpio_led_output.c"); do
	  sed -i 's/16U/14U/g' "$i"
	done

	for i in $(find boards/som_mx8mp -name "pin_mux.c"); do
	  sed -i "s/pin_num: T28, peripheral: GPIO3, signal: 'gpio_io, 16', pin_signal: NAND_READY_B/pin_num: R26, peripheral: GPIO3, signal: 'gpio_io, 14', pin_signal: NAND_DQS/g" "$i"
	done

	echo "Replace dts reference name"
	for i in $(find boards/som_mx8mp -name "board.c"); do
	  sed -i "s/imx8mp-evk-rpmsg.dts/imx8mp-var-common-m7.dtsi/g" "$i"
	done

	echo "Adjust VDEV0_VRING_BASE"
	for i in $(find boards/som_mx8mp -name "board.h"); do
	  sed -i 's/(0x55000000U)/(0x40000000U)/g' "$i"
	done

	echo "Adjust BOARD_NAME and  MANUFACTURER_NAME"
	for i in $(find boards/som_mx8mp -name "board.h"); do
	  sed -i 's/"MIMX8MP-EVK"/"VAR-SOM-MX8MQ-PLUS"/g' "$i"
	  sed -i 's/"NXP"/"Variscite"/g' "$i"
	done

	echo "Adjust *.xml files"
	for i in $(find boards/som_mx8mp -name "*.xml"); do
	  sed -i "s/evkmimx8mp/som_mx8mp/g" "$i"
	done

	echo "Adjust readme.txt files"
	for i in $(find boards/som_mx8mp -name "readme.txt"); do
	  sed -i "s/EVK-MIMX8M Plus board/VAR-SOM-MX8MQ-PLUS SoM/g" "$i"
	  sed -i "s/Connect 12V power supply and J-Link Debug Probe to the board, switch SW3 to power on the board/Connect proper power supply and J-Link Debug Probe to the board, switch SW8 to power on the board/g" "$i"
	  sed -i "s/CAN1 instance (J19)/CAN2 instance (J16)/g" "$i"
	  sed -i "s/Connect a USB cable between the host PC and the J23 USB port on the target board/Connect a proper cable between the host PC and the J18 header (pins UART4 TX, RX and GND) on the target board./g" "$i"
	  sed -i 's/I2C3 pins/I2C4 pins/g' "$i"
	  sed -i "s/I2C3_SCL       J21-5         I2C3_SCL      J21-5/I2C4_SCL       J16-13         I2C4_SCL      J16-13/g" "$i"
	  sed -i "s/I2C3_SDA       J21-3         I2C3_SDA      J21-3/I2C4_SDA       J16-15         I2C4_SDA      J16-15/g" "$i"
	  sed -i "s/GND            J21-9         GND           J21-9/GND            J16-19         GND           J16-19/g" "$i"
	  sed -i 's/Connect input signal to the resistance R191 which is around the codec WM8960/Connect input signal to the Test Point/g' "$i"
	  sed -i "s/MISO        J21 - 21                     MISO      J21 - 21/MISO        J16 - 6                     MISO      J16 - 6/g" "$i"
	  sed -i "s/MOSI        J21 - 19                     MOSI      J21 - 19/MOSI        J16 - 8                     MOSI      J16 - 8/g" "$i"
	  sed -i "s/SCK         J21 - 23                     SCK       J21 - 23/SCK         J16 - 2                     SCK       J16 - 2/g" "$i"
	  sed -i "s/SS0         J21 - 24                     SS0       J21 - 24/SS0         J16 - 4                     SS0       J16 - 4/g" "$i"
	  sed -i "s/GND         J21 - 6                      GND       J21 - 6/GND         J16 - 19                      GND       J16 - 19/g" "$i"
	done

	echo "Adjust clean.sh files"
	for i in $(find boards/som_mx8mp -name "clean.sh"); do
	  echo "rm -rf output.map" >> $i
	done

	echo "Remove evkmimx8mp.png file"
	rm boards/som_mx8mp/evkmimx8mp.png

	if [ ! -f SOM-MIMX8MP_manifest_v3_9.xml ]; then
		cp EVK-MIMX8MP_manifest_v3_9.xml SOM-MIMX8MP_manifest_v3_9.xml
		sed -i "s/evkmimx8mp/som_mx8mp/g" "SOM-MIMX8MP_manifest_v3_9.xml"
		sed -i "s/EVK-MIMX8MP/VAR-SOM-MX8M-PLUS/g" "SOM-MIMX8MP_manifest_v3_9.xml"
		sed -i "s/https:\/\/www.nxp.com\/pip\/8MPLUSLPD4-EVK/https:\/\/www.variscite.com\/product\/system-on-module-som\/cortex-a53-krait\/var-som-mx8m-plus-nxp-i-mx-8m-plus/g" "SOM-MIMX8MP_manifest_v3_9.xml"

		#Remove picture
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/image[@path=\"boards/som_mx8mp\"]" SOM-MIMX8MP_manifest_v3_9.xml

		#Remove SAI examples
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_sai_interrupt_transfer\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_sai_low_power_audio\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_sai_sdma_transfer\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_sai_interrupt_record_playback\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_sai_sdma_record_playback\"]" SOM-MIMX8MP_manifest_v3_9.xml

		#Remove PDM examples
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_pdm_hwvad\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_pdm_interrupt\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_pdm_sai_interrupt\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_pdm_sai_interrupt_transfer\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_pdm_sai_sdma\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_pdm_sdma_transfer\"]" SOM-MIMX8MP_manifest_v3_9.xml

		#Remove ASRC examples
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_asrc_m2m_polling\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_asrc_m2m_sdma\"]" SOM-MIMX8MP_manifest_v3_9.xml
		xmlstarlet ed -L -d "//ksdk:manifest/boards/board[@id=\"som_mx8mp\"]/examples/example[@id=\"som_mx8mp_asrc_p2p_out_sdma\"]" SOM-MIMX8MP_manifest_v3_9.xml
	fi

	echo "automated porting completed"
}
