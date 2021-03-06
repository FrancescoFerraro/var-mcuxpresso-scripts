#!/bin/bash

# -e  Exit immediately if a command exits with a non-zero status.
set -e

function make_dart_mx8mp()
{
	#remove audio example
	rm -r boards/dart_mx8mp/driver_examples/sai
	rm -r boards/dart_mx8mp/driver_examples/asrc
	rm -r boards/dart_mx8mp/driver_examples/pdm
	rm -r boards/dart_mx8mp/demo_apps/sai_low_power_audio

	echo "Port UART4 console to UART3"
	for i in $(find boards/dart_mx8mp -name "board.h"); do
	  sed -i 's/UART4_BASE/UART3_BASE/g' "$i"
	  sed -i 's/(4U)/(3U)/g' "$i"
	  sed -i 's/kCLOCK_RootUart4/kCLOCK_RootUart3/g' "$i"
	  sed -i 's/UART4_IRQn/UART3_IRQn/g' "$i"
	  sed -i 's/UART4_IRQHandler/UART3_IRQHandler/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "clock_config.c"); do
	  sed -i 's/kCLOCK_RootUart4/kCLOCK_RootUart3/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_UART4_RXD_UART4_RX/IOMUXC_UART3_RXD_UART3_RX/g' "$i"
	  sed -i 's/IOMUXC_UART4_TXD_UART4_TX/IOMUXC_UART3_TXD_UART3_TX/g' "$i"
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	  sed -i 's/IOMUXC_UART4_RXD_GPIO5_IO28/IOMUXC_UART3_RXD_GPIO5_IO26/g' "$i"
	  sed -i 's/IOMUXC_UART4_TXD_GPIO5_IO29/IOMUXC_UART3_TXD_GPIO5_IO27/g' "$i"
	#fix nxp bug regarding cmsis_driver_examples where was been used different UART pads
	  sed -i 's/IOMUXC_UART4_RXD_UART4_TX/IOMUXC_UART3_RXD_UART3_RX/g' "$i"
	  sed -i 's/IOMUXC_UART4_TXD_UART4_RX/IOMUXC_UART3_TXD_UART3_TX/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "*uart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "uart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "*usart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	  sed -i 's/USART4/USART3/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "uart*sdma*.c"); do
	  sed -i 's/(28)/(26)/g' "$i"
	  sed -i 's/(29)/(27)/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.h"); do
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "RTE_Device.h"); do
	  sed -i 's/USART4/USART3/g' "$i"
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	  sed -i 's/RTE_USART3_SDMA_TX_REQUEST  (29)/RTE_USART3_SDMA_TX_REQUEST  (27)/g' "$i"
	  sed -i 's/RTE_USART3_SDMA_RX_REQUEST  (28)/RTE_USART3_SDMA_RX_REQUEST  (26)/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/pin_num: AJ5, peripheral: UART4, signal: uart_rx, pin_signal: UART4_RXD/pin_num: AE6, peripheral: UART3, signal: uart_rx, pin_signal: UART3_RXD/g' "$i"
	  sed -i 's/pin_num: AH5, peripheral: UART4, signal: uart_tx, pin_signal: UART4_TXD/pin_num: AJ4, peripheral: UART3, signal: uart_tx, pin_signal: UART3_TXD/g' "$i"
	  sed -i "s/pin_num: AJ5, peripheral: GPIO5, signal: 'gpio_io, 28', pin_signal: UART4_RXD/pin_num: AE6, peripheral: GPIO5, signal: 'gpio_io, 26', pin_signal: UART3_RXD/g" "$i"
	  sed -i "s/pin_num: AH5, peripheral: GPIO5, signal: 'gpio_io, 29', pin_signal: UART4_TXD/pin_num: AJ4, peripheral: GPIO5, signal: 'gpio_io, 27', pin_signal: UART3_TXD/g" "$i"
	#fix nxp bug regarding cmsis_driver_examples where was been used different UART pads
	  sed -i 's/pin_num: AJ5, peripheral: UART4, signal: uart_tx, pin_signal: UART4_RXD/pin_num: AE6, peripheral: UART3, signal: uart_rx, pin_signal: UART3_RXD/g' "$i"
	  sed -i 's/pin_num: AH5, peripheral: UART4, signal: uart_rx, pin_signal: UART4_TXD/pin_num: AJ4, peripheral: UART3, signal: uart_tx, pin_signal: UART3_TXD/g' "$i"
	done


	echo "Port ECSPI2 to ECSPI1"
	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK/IOMUXC_ECSPI1_SCLK_ECSPI1_SCLK/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI/IOMUXC_ECSPI1_MOSI_ECSPI1_MOSI/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_MISO_ECSPI2_MISO/IOMUXC_ECSPI1_MISO_ECSPI1_MISO/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_SS0_ECSPI2_SS0/IOMUXC_ECSPI1_SS0_ECSPI1_SS0/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_MISO_GPIO5_IO12/IOMUXC_ECSPI1_MISO_GPIO5_IO08/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_MOSI_GPIO5_IO11/IOMUXC_ECSPI1_MOSI_GPIO5_IO07/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_SCLK_GPIO5_IO10/IOMUXC_ECSPI1_SCLK_GPIO5_IO06/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_SS0_GPIO5_IO13/IOMUXC_ECSPI1_SS0_GPIO5_IO09/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "*ecspi*.c"); do
	  sed -i 's/ECSPI2/ECSPI1/g' "$i"
	  sed -i 's/kCLOCK_RootEcspi2/kCLOCK_RootEcspi1/g' "$i"
	  sed -i 's/Driver_SPI2/Driver_SPI1/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.h"); do
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "RTE_Device.h"); do
	  sed -i 's/RTE_SPI2/RTE_SPI1/g' "$i"
	  sed -i 's/DMA_TX_CH_REQUEST  (3U)/DMA_TX_CH_REQUEST  (1U)/g' "$i"
	  sed -i 's/DMA_RX_CH_REQUEST  (2U)/DMA_RX_CH_REQUEST  (0U)/g' "$i"
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/pin_num: AH20, peripheral: ECSPI2, signal: ecspi_miso, pin_signal: ECSPI2_MISO/pin_num: AD20, peripheral: ECSPI1, signal: ecspi_miso, pin_signal: ECSPI1_MISO/g' "$i"
	  sed -i 's/pin_num: AJ21, peripheral: ECSPI2, signal: ecspi_mosi, pin_signal: ECSPI2_MOSI/pin_num: AC20, peripheral: ECSPI1, signal: ecspi_mosi, pin_signal: ECSPI1_MOSI/g' "$i"
	  sed -i 's/pin_num: AH21, peripheral: ECSPI2, signal: ecspi_sclk, pin_signal: ECSPI2_SCLK/pin_num: AF20, peripheral: ECSPI1, signal: ecspi_sclk, pin_signal: ECSPI1_SCLK/g' "$i"
	  sed -i "s/pin_num: AJ22, peripheral: ECSPI2, signal: 'ecspi_ss, 0', pin_signal: ECSPI2_SS0/pin_num: AE20, peripheral: ECSPI1, signal: 'ecspi_ss, 0', pin_signal: ECSPI1_SS0/g" "$i"
	  sed -i "s/pin_num: AH21, peripheral: GPIO5, signal: 'gpio_io, 10', pin_signal: ECSPI2_SCLK/pin_num: AF20, peripheral: GPIO5, signal: 'gpio_io, 6', pin_signal: ECSPI1_SCLK/g" "$i"
	  sed -i "s/pin_num: AJ21, peripheral: GPIO5, signal: 'gpio_io, 11', pin_signal: ECSPI2_MOSI/pin_num: AC20, peripheral: GPIO5, signal: 'gpio_io, 7', pin_signal: ECSPI1_MOSI/g" "$i"
	  sed -i "s/pin_num: AH20, peripheral: GPIO5, signal: 'gpio_io, 12', pin_signal: ECSPI2_MISO/pin_num: AD20, peripheral: GPIO5, signal: 'gpio_io, 8', pin_signal: ECSPI1_MISO/g" "$i"
	  sed -i "s/pin_num: AJ22, peripheral: GPIO5, signal: 'gpio_io, 13', pin_signal: ECSPI2_SS0/pin_num: AE20, peripheral: GPIO5, signal: 'gpio_io, 9', pin_signal: ECSPI1_SS0/g" "$i"
	done


	echo "Port PWM4 to PWM3"
	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_SAI5_RXFS_PWM4_OUT/IOMUXC_SPDIF_TX_PWM3_OUT/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pwm.c"); do
	  sed -i 's/PWM4/PWM3/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/pin_num: AC14, peripheral: PWM4, signal: pwm_out, pin_signal: SAI5_RXFS/pin_num: AE18, peripheral: PWM3, signal: pwm_out, pin_signal: SPDIF_TX/g' "$i"
	done


	echo "Port GPIO3,16 to GPIO4,3"
	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_NAND_READY_B_GPIO3_IO16/IOMUXC_SAI1_RXD1_GPIO4_IO03/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "gpio_led_output.c"); do
	  sed -i 's/GPIO3/GPIO4/g' "$i"
	  sed -i 's/16U/3U/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  sed -i "s/pin_num: T28, peripheral: GPIO3, signal: 'gpio_io, 16', pin_signal: NAND_READY_B/pin_num: AF10, peripheral: GPIO4, signal: 'gpio_io, 3', pin_signal: SAI1_RXD1/g" "$i"
	done

	echo "CAN: remove unused GPIOs and change pinmux"
	for i in $(find boards/dart_mx8mp -name "pin_mux.c"); do
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i "/{pin_num: AC18, peripheral: GPIO5, signal:/,0d" "$i"
	  sed -i '/IOMUXC_SPDIF_EXT_CLK_GPIO5_IO05/,+4d' "$i"

	  sed -i 's/IOMUXC_SPDIF_RX_CAN1_RX/IOMUXC_SAI2_TXC_CAN1_RX/g' "$i"
	  sed -i 's/IOMUXC_SPDIF_TX_CAN1_TX/IOMUXC_SAI2_RXC_CAN1_TX/g' "$i"
	  sed -i 's/pin_num: AD18, peripheral: FLEXCAN1, signal: can_rx, pin_signal: SPDIF_RX/pin_num: AH15, peripheral: FLEXCAN1, signal: can_rx, pin_signal: SAI2_TXC/g' "$i"
	  sed -i 's/pin_num: AE18, peripheral: FLEXCAN1, signal: can_tx, pin_signal: SPDIF_TX/pin_num: AJ16, peripheral: FLEXCAN1, signal: can_tx, pin_signal: SAI2_RXC/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "flexcan*.c"); do
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i '/GPIO5_IO05 is used to control CAN1_STBY/,+3d' "$i"
	done

	echo "Port dts reference name"
	for i in $(find boards/dart_mx8mp -name "board.c"); do
	  sed -i "s/imx8mp-evk-rpmsg.dts/imx8mp-var-common-m7.dtsi/g" "$i"
	done

	echo "Port VDEV0_VRING_BASE"
	for i in $(find boards/dart_mx8mp -name "board.h"); do
	  sed -i 's/(0x55000000U)/(0x40000000U)/g' "$i"
	done


	echo "Port BOARD_NAME and  MANUFACTURER_NAME"
	for i in $(find boards/dart_mx8mp -name "board.h"); do
	  sed -i 's/"MIMX8MP-EVK"/"DART-MX8MQ-PLUS"/g' "$i"
	  sed -i 's/"NXP"/"Variscite"/g' "$i"
	done


	echo "Port *.xml files"
	for i in $(find boards/dart_mx8mp -name "*.xml"); do
	  sed -i "s/evkmimx8mp/dart_mx8mp/g" "$i"
	done

	echo "Port readme.txt files"
	for i in $(find boards/dart_mx8mp -name "readme.txt"); do
	  sed -i "s/EVK-MIMX8M Plus board/DART-MX8MQ-PLUS SoM/g" "$i"
	  sed -i "s/Connect 12V power supply and J-Link Debug Probe to the board, switch SW3 to power on the board/Connect proper power supply and J-Link Debug Probe to the board, switch SW8 to power on the board/g" "$i"
	  sed -i "s/CAN1 instance (J19)/CAN1 instance on DT8 CustomBoard 1.x (J13), CAN1 instance on DT8 CustomBoard 2.x (J16)/g" "$i"
	  sed -i "s/Connect a USB cable between the host PC and the J23 USB port on the target board/Connect a proper cable between the host PC and the J12 header (pins UART2 TX, RX and GND) on the target board./g" "$i"
	  sed -i "s/I2C3_SCL       J21-5         I2C3_SCL      J21-5/I2C3_SCL       J12-18         I2C3_SCL      J12-18/g" "$i"
	  sed -i "s/I2C3_SDA       J21-3         I2C3_SDA      J21-3/I2C3_SDA       J12-20         I2C3_SDA      J12-20/g" "$i"
	  sed -i "s/GND            J21-9         GND           J21-9/GND            J12-15         GND           J12-15/g" "$i"
	  sed -i 's/Connect input signal to the resistance R191 which is around the codec WM8960/Connect input signal to the Test Point/g' "$i"
	  sed -i "s/MISO        J21 - 21                     MISO      J21 - 21/MISO        J16 - 8                     MISO      J16 - 8/g" "$i"
	  sed -i "s/MOSI        J21 - 19                     MOSI      J21 - 19/MOSI        J16 - 6                     MOSI      J16 - 6/g" "$i"
	  sed -i "s/SCK         J21 - 23                     SCK       J21 - 23/SCK         J16 - 2                     SCK       J16 - 2/g" "$i"
	  sed -i "s/SS0         J21 - 24                     SS0       J21 - 24/SS0         J16 - 4                     SS0       J16 - 4/g" "$i"
	  sed -i "s/GND         J21 - 6                      GND       J21 - 6/GND         J16 - 10                      GND       J16 - 10/g" "$i"
	  sed -i 's/ECSPI2/ECSPI1/g' "$i"
	  sed -i 's/instance 2 of the ECSPI/instance 1 of the ECSPI/g' "$i"
	done

	for i in $(find boards/dart_mx8mp -name "clean.sh"); do
	  echo "rm -rf output.map" >> $i
	done

	rm boards/dart_mx8mp/evkmimx8mp.png

	if [ ! -f DART-MIMX8MP_manifest_v3_8.xml ]; then
		cp EVK-MIMX8MP_manifest_v3_8.xml DART-MIMX8MP_manifest_v3_8.xml
		sed -i "s/evkmimx8mp/dart_mx8mp/g" "DART-MIMX8MP_manifest_v3_8.xml"
	fi

	echo "automated porting completed"
	echo
	echo "todo manually"
	echo " - DART-MIMX8MP_manifest_v3_8.xml, remove reference to removed examples: (sai, asrc, pdm, sai_low_power_audio)"
	echo
}
