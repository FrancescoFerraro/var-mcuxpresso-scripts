#!/bin/bash

# -e  Exit immediately if a command exits with a non-zero status.
set -e

function make_som_mx8mn()
{
	echo "removed: <sed -i 's/0x80000000/0x7E000000/g'> please verify if all demos work"

	#remove audio example
	rm -r boards/som_mx8mn/driver_examples/sai
	rm -r boards/som_mx8mn/driver_examples/pdm
	rm -r boards/som_mx8mn/demo_apps/sai_low_power_audio
	rm -r boards/som_mx8mn/driver_examples/asrc

	echo "Replace UART4 console with UART3"
	for i in $(find boards/som_mx8mn -name "board.c"); do
	  sed -i 's/kCLOCK_Uart4/kCLOCK_Uart3/g' "$i"
	  #sed -i 's/0x80000000/0x7E000000/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "board.h"); do
	  sed -i 's/UART4_BASE/UART3_BASE/g' "$i"
	  sed -i 's/4U/3U/g' "$i"
	  sed -i 's/kCLOCK_RootUart4/kCLOCK_RootUart3/g' "$i"
	  sed -i 's/UART4_IRQn/UART3_IRQn/g' "$i"
	  sed -i 's/UART4_IRQHandler/UART3_IRQHandler/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "clock_config.c"); do
	  sed -i 's/kCLOCK_RootUart4/kCLOCK_RootUart3/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_UART4_RXD_UART4_RX/IOMUXC_UART3_RXD_UART3_RX/g' "$i"
	  sed -i 's/IOMUXC_UART4_TXD_UART4_TX/IOMUXC_UART3_TXD_UART3_TX/g' "$i"
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	  sed -i 's/pin_num: F19, peripheral: UART4, signal: uart_rx, pin_signal: UART4_RXD/pin_num: E18, peripheral: UART3, signal: uart_rx, pin_signal: UART3_RXD/g' "$i"
	  sed -i 's/pin_num: F18, peripheral: UART4, signal: uart_tx, pin_signal: UART4_TXD/pin_num: D18, peripheral: UART3, signal: uart_tx, pin_signal: UART3_TXD/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "*uart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "uart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "*usart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	  sed -i 's/USART4/USART3/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "uart*sdma*.c"); do
	  sed -i 's/(28)/(26)/g' "$i"
	  sed -i 's/(29)/(27)/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "pin_mux.h"); do
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "RTE_Device.h"); do
	  sed -i 's/USART4/USART3/g' "$i"
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	  sed -i 's/RTE_USART3_SDMA_TX_REQUEST  (29)/RTE_USART3_SDMA_TX_REQUEST  (27)/g' "$i"
	  sed -i 's/RTE_USART3_SDMA_RX_REQUEST  (28)/RTE_USART3_SDMA_RX_REQUEST  (26)/g' "$i"
	done

	echo "Adjust Led output"
	for i in $(find boards/som_mx8mn -name "pin_mux.c"); do
	  sed -i "s/IOMUXC_ECSPI2_MOSI_GPIO5_IO11/IOMUXC_SAI2_RXD0_GPIO4_IO23/g" "$i"
	done

	for i in $(find boards/som_mx8mn -name "gpio_led_output.c"); do
	  sed -i 's/GPIO5/GPIO4/g' "$i"
	  sed -i 's/11U/23U/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "pin_mux.c"); do
	  sed -i "s/pin_num: B8, peripheral: GPIO5, signal: 'gpio_io, 11', pin_signal: ECSPI2_MOSI/pin_num: AC24, peripheral: GPIO4, signal: 'gpio_io, 23', pin_signal: SAI2_RXD0/" "$i"
	done

	echo "Replace ECSPI2 with ECSPI1"
	for i in $(find boards/som_mx8mn -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_ECSPI2_SCLK_ECSPI2_SCLK/IOMUXC_ECSPI1_SCLK_ECSPI1_SCLK/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_MOSI_ECSPI2_MOSI/IOMUXC_ECSPI1_MOSI_ECSPI1_MOSI/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_MISO_ECSPI2_MISO/IOMUXC_ECSPI1_MISO_ECSPI1_MISO/g' "$i"
	  sed -i 's/IOMUXC_ECSPI2_SS0_ECSPI2_SS0/IOMUXC_ECSPI1_SS0_ECSPI1_SS0/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  # ECSPI1_DeinitPins in the loopback demos deinitialize only UART pins
	  sed -i 's/IOMUXC_UART4_RXD_GPIO5_IO28/IOMUXC_UART3_RXD_GPIO5_IO26/g' "$i"
	  sed -i 's/IOMUXC_UART4_TXD_GPIO5_IO29/IOMUXC_UART3_TXD_GPIO5_IO27/g' "$i"

	  sed -i 's/pin_num: A8, peripheral: ECSPI2, signal: ecspi_miso, pin_signal: ECSPI2_MISO/pin_num: A7, peripheral: ECSPI1, signal: ecspi_miso, pin_signal: ECSPI1_MISO/g' "$i"
	  sed -i 's/pin_num: B8, peripheral: ECSPI2, signal: ecspi_mosi, pin_signal: ECSPI2_MOSI/pin_num: B7, peripheral: ECSPI1, signal: ecspi_mosi, pin_signal: ECSPI1_MOSI/g' "$i"
	  sed -i 's/pin_num: E6, peripheral: ECSPI2, signal: ecspi_sclk, pin_signal: ECSPI2_SCLK/pin_num: D6, peripheral: ECSPI1, signal: ecspi_sclk, pin_signal: ECSPI1_SCLK/g' "$i"
	  sed -i "s/pin_num: A6, peripheral: ECSPI2, signal: 'ecspi_ss, 0', pin_signal: ECSPI2_SS0/pin_num: B6, peripheral: ECSPI1, signal: 'ecspi_ss, 0', pin_signal: ECSPI1_SS0/g" "$i"

	  # ECSPI1_DeinitPins in the loopback demos deinitialize only UART pins
	  sed -i "s/pin_num: F19, peripheral: GPIO5, signal: 'gpio_io, 28', pin_signal: UART4_RXD/pin_num: E18, peripheral: GPIO5, signal: 'gpio_io, 26', pin_signal: UART3_RXD/g" "$i"
	  sed -i "s/pin_num: F18, peripheral: GPIO5, signal: 'gpio_io, 29', pin_signal: UART4_TXD/pin_num: D18, peripheral: GPIO5, signal: 'gpio_io, 27', pin_signal: UART3_TXD/g" "$i"
	done

	for i in $(find boards/som_mx8mn -name "*ecspi*.c"); do
	  sed -i 's/ECSPI2/ECSPI1/g' "$i"
	  sed -i 's/kCLOCK_RootEcspi2/kCLOCK_RootEcspi1/g' "$i"
	  sed -i 's/Driver_SPI2/Driver_SPI1/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "pin_mux.h"); do
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "RTE_Device.h"); do
	  sed -i 's/RTE_SPI2/RTE_SPI1/g' "$i"
	  sed -i 's/DMA_TX_CH_REQUEST  (3U)/DMA_TX_CH_REQUEST  (1U)/g' "$i"
	  sed -i 's/DMA_RX_CH_REQUEST  (2U)/DMA_RX_CH_REQUEST  (0U)/g' "$i"
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	done

	echo "Replace I2C3 to I2C4"
	for i in $(find boards/som_mx8mn -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_I2C3_SCL_I2C3_SCL/IOMUXC_I2C4_SCL_I2C4_SCL/g' "$i"
	  sed -i 's/IOMUXC_I2C3_SDA_I2C3_SDA/IOMUXC_I2C4_SDA_I2C4_SDA/g' "$i"
	  sed -i 's/IOMUXC_I2C3_SCL_GPIO5_IO18/IOMUXC_I2C4_SCL_GPIO5_IO20/g' "$i"
	  sed -i 's/IOMUXC_I2C3_SDA_GPIO5_IO19/IOMUXC_I2C4_SDA_GPIO5_IO21/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/pin_num: E10, peripheral: I2C3, signal: i2c_scl, pin_signal: I2C3_SCL/pin_num: D13, peripheral: I2C4, signal: i2c_scl, pin_signal: I2C4_SCL/g' "$i"
	  sed -i 's/pin_num: F10, peripheral: I2C3, signal: i2c_sda, pin_signal: I2C3_SDA/pin_num: E13, peripheral: I2C4, signal: i2c_sda, pin_signal: I2C4_SDA/g' "$i"
	  sed -i "s/pin_num: E10, peripheral: GPIO5, signal: 'gpio_io, 18', pin_signal: I2C3_SCL/pin_num: D13, peripheral: GPIO5, signal: 'gpio_io, 20', pin_signal: I2C4_SCL/g" "$i"
	  sed -i "s/pin_num: F10, peripheral: GPIO5, signal: 'gpio_io, 19', pin_signal: I2C3_SDA/pin_num: E13, peripheral: GPIO5, signal: 'gpio_io, 21', pin_signal: I2C4_SDA/g" "$i"
	done

	for i in $(find boards/som_mx8mn -name "*i2c*.c"); do
	  sed -i 's/I2C3/I2C4/g' "$i"
	  sed -i 's/kCLOCK_RootI2c3/kCLOCK_RootI2c4/g' "$i"
	  sed -i 's/Driver_I2C3/Driver_I2C4/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "pin_mux.h"); do
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "RTE_Device.h"); do
	  sed -i 's/RTE_I2C3/RTE_I2C4/g' "$i"
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	done

	echo "Adjust VDEV0_VRING_BASE"
	for i in $(find boards/som_mx8mn -name "board.h"); do
	  sed -i 's/(0xB8000000U)/(0x40000000U)/g' "$i"
	done

	echo "Adjust *cm7_*.ld files"
	for i in $(find boards/som_mx8mn -name "*cm7_ddr_ram.ld"); do
	  sed -i 's/m_interrupts          (RX)  : ORIGIN = 0x80000000, LENGTH = 0x00000240/m_interrupts          (RX)  : ORIGIN = 0x7E000000, LENGTH = 0x00000240/g' "$i"
	  sed -i 's/m_text                (RX)  : ORIGIN = 0x80000240, LENGTH = 0x001FFDC0/m_text                (RX)  : ORIGIN = 0x7E000240, LENGTH = 0x001FFDC0/g' "$i"
	  sed -i 's/m_data                (RW)  : ORIGIN = 0x80200000, LENGTH = 0x00200000/m_data                (RW)  : ORIGIN = 0x7E200000, LENGTH = 0x00200000/g' "$i"
	  sed -i 's/m_data2               (RW)  : ORIGIN = 0x80400000, LENGTH = 0x00C00000/m_data2               (RW)  : ORIGIN = 0x7E400000, LENGTH = 0x00C00000/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "*cm7_ram.ld"); do
	  sed -i 's/m_data2               (RW)  : ORIGIN = 0x80000000, LENGTH = 0x01000000/m_data2               (RW)  : ORIGIN = 0x7E000000, LENGTH = 0x01000000/g' "$i"
	done

	for i in $(find boards/som_mx8mn -name "*cm7_flash.ld"); do
	  sed -i 's/m_data2               (RW)  : ORIGIN = 0x80000000, LENGTH = 0x01000000/m_data2               (RW)  : ORIGIN = 0x7E000000, LENGTH = 0x01000000/g' "$i"
	done

	echo "Adjust BOARD_NAME and  MANUFACTURER_NAME"
	for i in $(find boards/som_mx8mn -name "board.h"); do
	  sed -i 's/MIMX8MN-EVK/DART-MX8MN/g' "$i"
	  sed -i 's/"NXP"/"Variscite"/g' "$i"
	done

	echo "Adjust *.xml files"
	for i in $(find boards/som_mx8mn -name "*.xml"); do
	  sed -i "s/evkmimx8mn/som_mx8mn/g" "$i"
	done

	echo "Adjust readme.txt files"
	for i in $(find boards/som_mx8mn -name "readme.txt"); do
	  sed -i "s/MIMX8MN6-EVK board/VAR-SOM-MX8M-NANO SoM/g" "$i"
	  sed -i "s/MIMX8MN6-EVK  board/VAR-SOM-MX8M-NANO SoM/g" "$i"
	  sed -i "s/Connect 12V power supply and J-Link Debug Probe to the board, switch SW101 to power on the board/Connect proper power supply and J-Link Debug Probe to the board, switch SW7 to power on the board/g" "$i"
	  sed -i 's/Connect a USB cable between the host PC and the J901 USB port on the target board/Connect a proper cable between the host PC and the J18 header, (pins UART3 TX, RX and GND) on the target board/g' "$i"
	  sed -i 's/I2C3_SCL       J1003-5         I2C3_SCL      J1003-5/For I2C4 connection, refer to: https:\/\/variwiki.com\/index.php?title=MCUXpresso\&release=MCUXPRESSO_2.10.0_V1.0_VAR-SOM-MX8M-NANO#Demos_pins/g' "$i"
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i "/I2C3_SDA       J1003-3         I2C3_SDA      J1003-3/,+1d" "$i"
	  sed -i 's/MISO        J1003 - 21                     MISO      J1003 - 21/For ECSPI1 connection, refer to: https:\/\/variwiki.com\/index.php?title=MCUXpresso\&release=MCUXPRESSO_2.10.0_V1.0_VAR-SOM-MX8M-NANO#Demos_pins/g' "$i"
	  sed -i "/MOSI        J1003 - 19                     MOSI      J1003 - 19/,+3d" "$i"
	  sed -i "s/Use oscilloscope to probe the signal on J1003-19 (On Base board)./For GPIO output pin refer to: https:\/\/variwiki.com\/index.php?title=MCUXpresso\&release=MCUXPRESSO_2.10.0_V1.0_VAR-SOM-MX8M-NANO#Demos_pins/g" "$i"
	  sed -i 's/I2C3/I2C4/g' "$i"
	  sed -i 's/ECSPI2/ECSPI1/g' "$i"
	  sed -i 's/instance 2 of the ECSPI/instance 1 of the ECSPI/g' "$i"
	  sed -i 's/12V power supply/proper power supply/g' "$i"
	  sed -i "s/Connect input signal to J1001-43 Test Point/Connect input signal to the Test Point/g" "$i"
	  sed -i "s/RPMSG Share Base Addr is 0xb8000000/RPMSG Share Base Addr is 0x40000000/g" "$i"
	done

	for i in $(find boards/som_mx8mn -name "clean.sh"); do
	  echo "rm -rf output.map" >> $i
	done

	rm boards/som_mx8mn/evkmimx8mn.png

	if [ ! -f SOM-MIMX8MN_manifest_v3_8.xml ]; then
		cp EVK-MIMX8MN_manifest_v3_8.xml SOM-MIMX8MN_manifest_v3_8.xml
		sed -i "s/evkmimx8mn/som_mx8mn/g" "SOM-MIMX8MN_manifest_v3_8.xml"
	fi

	echo "automated porting completed"
	echo
	echo "todo manually"
	echo " - SOM-MIMX8MN_manifest_v3_8.xml, remove reference to removed examples: (sai, pdm, sai_low_power_audio, asrc)"
	echo " - PWM:"
	echo "   driver_examples/pwm/pwm.c"
	echo "   apply patch https://github.com/varigit/freertos-variscite/commit/8a11af8449d570a1b207ad771c567305b23a242e.patch"
	echo
}
