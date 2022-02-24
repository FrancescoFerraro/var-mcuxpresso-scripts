#!/bin/bash

# -e  Exit immediately if a command exits with a non-zero status.
set -e

function make_dart_mx8mm()
{

	echo "removed: <sed -i 's/0x80000000/0x7E000000/g'> please verify if all demos work"

	#remove audio example
	rm -r boards/dart_mx8mm/driver_examples/sai
	rm -r boards/dart_mx8mm/driver_examples/pdm
	rm -r boards/dart_mx8mm/demo_apps/sai_low_power_audio
	rm -r boards/dart_mx8mm/driver_examples/uart/hardware_flow_control

	echo "Replace UART4 console with UART3"
	for i in $(find boards/dart_mx8mm -name "board.c"); do
	  sed -i 's/kCLOCK_Uart4/kCLOCK_Uart3/g' "$i"
	  #sed -i 's/0x80000000/0x7E000000/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "board.h"); do
	  sed -i 's/UART4_BASE/UART3_BASE/g' "$i"
	  sed -i 's/4U/3U/g' "$i"
	  sed -i 's/kCLOCK_RootUart4/kCLOCK_RootUart3/g' "$i"
	  sed -i 's/UART4_IRQn/UART3_IRQn/g' "$i"
	  sed -i 's/UART4_IRQHandler/UART3_IRQHandler/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "clock_config.c"); do
	  sed -i 's/kCLOCK_RootUart4/kCLOCK_RootUart3/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.c"); do
	  sed -i 's/IOMUXC_UART4_RXD_UART4_RX/IOMUXC_UART3_RXD_UART3_RX/g' "$i"
	  sed -i 's/IOMUXC_UART4_TXD_UART4_TX/IOMUXC_UART3_TXD_UART3_TX/g' "$i"
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	  sed -i 's/pin_num: F19, peripheral: UART4, signal: uart_rx, pin_signal: UART4_RXD/pin_num: E18, peripheral: UART3, signal: uart_rx, pin_signal: UART3_RXD/g' "$i"
	  sed -i 's/pin_num: F18, peripheral: UART4, signal: uart_tx, pin_signal: UART4_TXD/pin_num: D18, peripheral: UART3, signal: uart_tx, pin_signal: UART3_TXD/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "*uart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "uart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "*usart*.c"); do
	  sed -i 's/UART4/UART3/g' "$i"
	  sed -i 's/USART4/USART3/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "uart*sdma*.c"); do
	  sed -i 's/(28)/(26)/g' "$i"
	  sed -i 's/(29)/(27)/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.h"); do
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "RTE_Device.h"); do
	  sed -i 's/USART4/USART3/g' "$i"
	  sed -i 's/UART4_InitPins/UART3_InitPins/g' "$i"
	  sed -i 's/UART4_DeinitPins/UART3_DeinitPins/g' "$i"
	  sed -i 's/RTE_USART3_SDMA_TX_REQUEST  (29)/RTE_USART3_SDMA_TX_REQUEST  (27)/g' "$i"
	  sed -i 's/RTE_USART3_SDMA_RX_REQUEST  (28)/RTE_USART3_SDMA_RX_REQUEST  (26)/g' "$i"
	done

	echo "Replace ECSPI2 with ECSPI1"
	for i in $(find boards/dart_mx8mm -name "pin_mux.c"); do
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
	  # ECSPI1_DeinitPins is bugged from NXP !!
	  #Delete lines after a pattern (excluding the line with the pattern):
	  sed -i "/void ECSPI1_DeinitPins/{n;N;N;d}" "$i"
	  #Add lines from dart_mx8mm/ECSPI1_DeinitPins.c
	  sed -i "/void ECSPI1_DeinitPins/r dart_mx8mm/ECSPI1_DeinitPins.c" "$i"
	done

	for i in $(find boards/dart_mx8mm -name "*ecspi*.c"); do
	  sed -i 's/ECSPI2/ECSPI1/g' "$i"
	  sed -i 's/kCLOCK_RootEcspi2/kCLOCK_RootEcspi1/g' "$i"
	  sed -i 's/Driver_SPI2/Driver_SPI1/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.h"); do
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	  #Add lines from dart_mx8mm/ECSPI1_DeinitPins.h
	  sed -i "/ECSPI2_DEINITPINS_UART4_TXD_GPIO_PIN_MASK                    (1U << 29U)/r dart_mx8mm/ECSPI1_DeinitPins.h" "$i"
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i "/ECSPI2_DEINITPINS_UART4_RXD_GPIO_PIN_MASK                    (1U << 28U)/,+3d" "$i"
	done

	for i in $(find boards/dart_mx8mm -name "RTE_Device.h"); do
	  sed -i 's/RTE_SPI2/RTE_SPI1/g' "$i"
	  sed -i 's/DMA_TX_CH_REQUEST  (3U)/DMA_TX_CH_REQUEST  (1U)/g' "$i"
	  sed -i 's/DMA_RX_CH_REQUEST  (2U)/DMA_RX_CH_REQUEST  (0U)/g' "$i"
	  sed -i 's/ECSPI2_InitPins/ECSPI1_InitPins/g' "$i"
	  sed -i 's/ECSPI2_DeinitPins/ECSPI1_DeinitPins/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.c"); do
	  sed -i 's/pin_num: A8, peripheral: ECSPI2, signal: ecspi_miso, pin_signal: ECSPI2_MISO/pin_num: A7, peripheral: ECSPI1, signal: ecspi_miso, pin_signal: ECSPI1_MISO/g' "$i"
	  sed -i 's/pin_num: B8, peripheral: ECSPI2, signal: ecspi_mosi, pin_signal: ECSPI2_MOSI/pin_num: B7, peripheral: ECSPI1, signal: ecspi_mosi, pin_signal: ECSPI1_MOSI/g' "$i"
	  sed -i 's/pin_num: E6, peripheral: ECSPI2, signal: ecspi_sclk, pin_signal: ECSPI2_SCLK/pin_num: D6, peripheral: ECSPI1, signal: ecspi_sclk, pin_signal: ECSPI1_SCLK/g' "$i"
	  sed -i "s/pin_num: A6, peripheral: ECSPI2, signal: 'ecspi_ss, 0', pin_signal: ECSPI2_SS0/pin_num: B6, peripheral: ECSPI1, signal: 'ecspi_ss, 0', pin_signal: ECSPI1_SS0/g" "$i"
	  # ECSPI1_DeinitPins is bugged from NXP
	  #Add lines from dart_mx8mm/ECSPI1_DeinitPins.txt
	  sed -i "/pin_num: F18, peripheral: GPIO5, signal: 'gpio_io, 29', pin_signal: UART4_TXD/r dart_mx8mm/ECSPI1_DeinitPins.txt" "$i"
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i "/pin_num: F19, peripheral: GPIO5, signal: 'gpio_io, 28', pin_signal: UART4_RXD/,+1d" "$i"
	done

	echo "Replace I2C3 to I2C4"
	for i in $(find boards/dart_mx8mm -name "pin_mux.c"); do
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

	for i in $(find boards/dart_mx8mm -name "*i2c*.c"); do
	  sed -i 's/I2C3/I2C4/g' "$i"
	  sed -i 's/kCLOCK_RootI2c3/kCLOCK_RootI2c4/g' "$i"
	  sed -i 's/Driver_I2C3/Driver_I2C4/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.h"); do
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	  sed -i 's/I2C3_DEINITPINS_I2C3_SCL_GPIO_PIN_MASK                       (1U << 18U)/I2C4_DEINITPINS_I2C4_SCL_GPIO_PIN_MASK                       (1U << 20U)/g' "$i"
	  sed -i 's/I2C3_DEINITPINS_I2C3_SDA_GPIO_PIN_MASK                       (1U << 19U)/I2C4_DEINITPINS_I2C4_SDA_GPIO_PIN_MASK                       (1U << 21U)/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "RTE_Device.h"); do
	  sed -i 's/RTE_I2C3/RTE_I2C4/g' "$i"
	  sed -i 's/I2C3_InitPins/I2C4_InitPins/g' "$i"
	  sed -i 's/I2C3_DeinitPins/I2C4_DeinitPins/g' "$i"
	done

	echo "PWM:"
	echo "driver_examples/pwm/pwm.c boards/evkmimx8mm-test/driver_examples/pwm/pwm.c"
	echo "apply patch https://github.com/varigit/freertos-variscite/commit/8a11af8449d570a1b207ad771c567305b23a242e.patch"
	echo

	echo "Adjust Led output"
	for i in $(find boards/dart_mx8mm -name "pin_mux.c"); do
	  sed -i "s/IOMUXC_ECSPI2_MOSI_GPIO5_IO11/IOMUXC_SAI1_RXD1_GPIO4_IO03/g" "$i"
	done

	for i in $(find boards/dart_mx8mm -name "gpio_led_output.c"); do
	  sed -i 's/GPIO5/GPIO4/g' "$i"
	  sed -i 's/11U/3U/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.c"); do
	  sed -i "s/pin_num: B8, peripheral: GPIO5, signal: 'gpio_io, 11', pin_signal: ECSPI2_MOSI/pin_num: B8, peripheral: GPIO4, signal: 'gpio_io, 03', pin_signal: SAI1_RXD1/" "$i"
	done

	for i in $(find boards/dart_mx8mm -name "pin_mux.h"); do
	  sed -i "s/BOARD_INITPINS_ECSPI2_MOSI_GPIO_PIN_MASK                     (1U << 11U)/BOARD_INITPINS_SAI1_RXD1_GPIO_PIN_MASK                     (1U << 3U)/" "$i"
	done

	echo "Adjust VDEV0_VRING_BASE"
	for i in $(find boards/dart_mx8mm -name "board.h"); do
	  sed -i 's/(0xB8000000U)/(0x40000000U)/g' "$i"
	done

	echo "Adjust *cm4_*.ld files"
	for i in $(find boards/dart_mx8mm -name "*cm4_ddr_ram.ld"); do
	  sed -i 's/m_interrupts          (RX)  : ORIGIN = 0x80000000, LENGTH = 0x00000240/m_interrupts          (RX)  : ORIGIN = 0x7E000000, LENGTH = 0x00000240/g' "$i"
	  sed -i 's/m_text                (RX)  : ORIGIN = 0x80000240, LENGTH = 0x001FFDC0/m_text                (RX)  : ORIGIN = 0x7E000240, LENGTH = 0x001FFDC0/g' "$i"
	  sed -i 's/m_data                (RW)  : ORIGIN = 0x80200000, LENGTH = 0x00200000/m_data                (RW)  : ORIGIN = 0x7E200000, LENGTH = 0x00200000/g' "$i"
	  sed -i 's/m_data2               (RW)  : ORIGIN = 0x80400000, LENGTH = 0x00C00000/m_data2               (RW)  : ORIGIN = 0x7E400000, LENGTH = 0x00C00000/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "*cm4_ram.ld"); do
	  sed -i 's/m_data2               (RW)  : ORIGIN = 0x80000000, LENGTH = 0x01000000/m_data2               (RW)  : ORIGIN = 0x7E000000, LENGTH = 0x01000000/g' "$i"
	done

	for i in $(find boards/dart_mx8mm -name "*cm4_flash.ld"); do
	  sed -i 's/m_data2               (RW)  : ORIGIN = 0x80000000, LENGTH = 0x01000000/m_data2               (RW)  : ORIGIN = 0x7E000000, LENGTH = 0x01000000/g' "$i"
	done

	echo "Adjust BOARD_NAME and  MANUFACTURER_NAME"
	for i in $(find boards/dart_mx8mm -name "board.h"); do
	  sed -i 's/MIMX8MM-EVK/DART-MX8MM/g' "$i"
	  sed -i 's/"NXP"/"Variscite"/g' "$i"
	done

	echo "Adjust *.xml files"
	for i in $(find boards/dart_mx8mm -name "*.xml"); do
	  sed -i "s/evkmimx8mm/dart_mx8mm/g" "$i"
	done

	echo "Adjust readme.txt files"
	for i in $(find boards/dart_mx8mm -name "readme.txt"); do
	  sed -i "s/MIMX8MM6-EVK board/DART-MX8MM SoM/g" "$i"
	  sed -i "s/MIMX8MM6-EVK  board/DART-MX8MM SoM/g" "$i"
	  sed -i "s/Connect 12V power supply and J-Link Debug Probe to the board, switch SW101 to power on the board/Connect proper power supply and J-Link Debug Probe to the board, switch SW8(DT8CustomBoard)\/SW7(SymphonyBoard) to power on the board/g" "$i"
	  sed -i 's/Connect a USB cable between the host PC and the J901 USB port on the target board/Connect a proper cable between the host PC and the J12 header(DT8CustomBoard)\/J18 header(SymphonyBoard), (pins UART3 TX, RX and GND) on the target board/g' "$i"
	  sed -i 's/I2C3_SCL       J1003-5         I2C3_SCL      J1003-5/For I2C4 connection, refer to: https:\/\/variwiki.com\/index.php?title=MCUXpresso\&release=MCUXPRESSO_2.10.0_V1.0_DART-MX8M-MINI#Demos_pins/g' "$i"
	  #Delete lines after a pattern (including the line with the pattern):
	  sed -i "/I2C3_SDA       J1003-3         I2C3_SDA      J1003-3/,+1d" "$i"
	  sed -i 's/MISO        J1003 - 21                     MISO      J1003 - 21/For ECSPI1 connection, refer to: https:\/\/variwiki.com\/index.php?title=MCUXpresso\&release=MCUXPRESSO_2.10.0_V1.0_DART-MX8M-MINI#Demos_pins/g' "$i"
	  sed -i "/MOSI        J1003 - 19                     MOSI      J1003 - 19/,+3d" "$i"
	  sed -i "s/Use oscilloscope to probe the signal on J1003-19 (On Base board)./For GPIO output pin refer to: https:\/\/variwiki.com\/index.php?title=MCUXpresso\&release=MCUXPRESSO_2.10.0_V1.0_DART-MX8M-MINI#Demos_pins/g" "$i"
	  sed -i 's/I2C3/I2C4/g' "$i"
	  sed -i 's/ECSPI2/ECSPI1/g' "$i"
	  sed -i 's/instance 2 of the ECSPI/instance 1 of the ECSPI/g' "$i"
	  sed -i 's/12V power supply/proper power supply/g' "$i"
	  sed -i "s/Connect input signal to J1001-43 Test Point/Connect input signal to the Test Point/g" "$i"
	  sed -i "s/RPMSG Share Base Addr is 0xb8000000/RPMSG Share Base Addr is 0x40000000/g" "$i"
	done

	for i in $(find boards/dart_mx8mm -name "clean.sh"); do
	  echo "rm -rf output.map" >> $i
	done

	rm boards/dart_mx8mm/evkmimx8mm.png

	if [ ! -f DART-MIMX8MM_manifest_v3_8.xml ]; then
		cp EVK-MIMX8MM_manifest_v3_8.xml DART-MIMX8MM_manifest_v3_8.xml
		sed -i "s/evkmimx8mm/dart_mx8mm/g" "DART-MIMX8MM_manifest_v3_8.xml"
	fi

	echo "automated porting completed"
	echo
	echo "todo manually"
	echo " - DART-MIMX8MM_manifest_v3_8.xml, remove reference to removed examples: (sai, pdm, sai_low_power_audio). hardware_flow_control"
	echo " - boards/dart_mx8mm/driver_examples/gpt/capture/readme.txt"
	echo "   # #### Please note this application can't run if WM8904 is mounted ####"
	echo "   # GPT1_CAPTURE1/2 functions are only available from SAI3 pads used by WM8904."
	echo "   # This pads are exported to the external connector only if WM8904 is not mounted."
	echo "   # Prepare the Demo"
	echo " - apply the patch: https://github.com/varigit/freertos-variscite/commit/8a11af8449d570a1b207ad771c567305b23a242e"
}
