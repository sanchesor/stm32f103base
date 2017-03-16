##################################
# stm32 minimal example Makefile
##################################

MACRO_DEFS = -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER 

CC = arm-eabi-gcc
LD = arm-eabi-ld
CP = arm-eabi-objcopy
 
LKR_SCRIPT = LinkerScript.ld

SRC_DIR = src
BIN_DIR = bin
LIB_SRC_DIR = lib\STM32F10x_StdPeriph_Driver\src
LIB_BIN_DIR = lib\STM32F10x_StdPeriph_Driver\bin
CMSIS_SRC_DIR = lib\CMSIS

 
INCLUDES = -Ilib\CMSIS -Ilib\STM32F10x_StdPeriph_Driver\inc
CFLAGS  = -c -fno-common -O0 -g -mcpu=cortex-m3 -mthumb -mfloat-abi=soft
LFLAGS  = -nostartfiles -T$(LKR_SCRIPT)
CPFLAGS = -Obinary
SYSTEM_LIBS = -L"C:\Program Files\SysGCC\arm-eabi\arm-eabi\lib" -L"C:\Program Files\SysGCC\arm-eabi\lib\gcc\arm-eabi\5.2.0"


LIB_OBJS = \
bin\startup_stm32f10x_md.o \
bin\system_stm32f10x.o \
bin\syscalls.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_gpio.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_rcc.o \

 
all: $(BIN_DIR)\main.bin
 
$(BIN_DIR)\main.o: $(SRC_DIR)\main.c 
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\main.o $(SRC_DIR)\main.c 
 
$(BIN_DIR)\main.elf: $(BIN_DIR)\main.o $(LIB_OBJS)
	$(LD) $(LFLAGS) -o $(BIN_DIR)\main.elf $(BIN_DIR)\main.o $(LIB_OBJS) $(SYSTEM_LIBS)  
 
$(BIN_DIR)\main.bin: $(BIN_DIR)\main.elf
	$(CP) $(CPFLAGS) $(BIN_DIR)\main.elf $(BIN_DIR)\main.bin

	
$(BIN_DIR)\startup_stm32f10x_md.o: $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\startup_stm32f10x_md.o $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
$(BIN_DIR)\system_stm32f10x.o: $(CMSIS_SRC_DIR)\system_stm32f10x.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\system_stm32f10x.o $(CMSIS_SRC_DIR)\system_stm32f10x.c
$(BIN_DIR)\syscalls.o: $(CMSIS_SRC_DIR)\syscalls.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\syscalls.o $(CMSIS_SRC_DIR)\syscalls.c
	

$(LIB_BIN_DIR)\stm32f10x_rcc.o: $(LIB_SRC_DIR)\stm32f10x_rcc.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(LIB_BIN_DIR)\stm32f10x_rcc.o $(LIB_SRC_DIR)\stm32f10x_rcc.c
$(LIB_BIN_DIR)\stm32f10x_gpio.o: $(LIB_SRC_DIR)\stm32f10x_gpio.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(LIB_BIN_DIR)\stm32f10x_gpio.o $(LIB_SRC_DIR)\stm32f10x_gpio.c

	
clean:
	if exist $(BIN_DIR)\*.o del $(BIN_DIR)\*.o 
	if exist $(BIN_DIR)\*.elf del $(BIN_DIR)\*.elf
	if exist $(BIN_DIR)\*.bin del $(BIN_DIR)\*.bin
	if exist $(LIB_BIN_DIR)\*.o del $(LIB_BIN_DIR)\*.o 
 



	
IMAGE = main.elf
OPENOCD_DIR = C:\Program Files\OpenOCD-20160901\bin
install: 
	 "$(OPENOCD_DIR)\openocd.exe" -f "stlink-v2.cfg" -f "stm32f1x.cfg" -c init -c "reset halt" -c "flash write_image erase $(IMAGE)" -c "verify_image $(IMAGE)" -c "reset" -c shutdown
	 
	 
	 
	
LIB_SRCS = \
lib\STM32F10x_StdPeriph_Driver\src\misc.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_adc.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_bkp.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_can.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_cec.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_crc.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_dac.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_dbgmcu.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_dma.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_exti.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_flash.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_fsmc.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_gpio.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_i2c.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_iwdg.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_pwr.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_rcc.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_rtc.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_sdio.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_spi.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_tim.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_usart.c \
lib\STM32F10x_StdPeriph_Driver\src\stm32f10x_wwdg.c 


LIB_DEPS = \
lib\STM32F10x_StdPeriph_Driver\bin\misc.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_adc.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_bkp.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_can.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_cec.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_crc.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_dac.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_dbgmcu.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_dma.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_exti.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_flash.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_fsmc.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_gpio.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_i2c.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_iwdg.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_pwr.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_rcc.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_rtc.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_sdio.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_spi.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_tim.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_usart.d \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_wwdg.d 





	
#	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -mfloat-abi=soft -DSTM32F1 -DNUCLEO_F103RB -DSTM32F103RBTx -DSTM32 -DUSE_STDPERIPH_DRIVER -DSTM32F10X_MD -I"F:\hotep\SystemWorkbench\workspace\p1\inc" -I"F:\hotep\SystemWorkbench\workspace\p1\CMSIS\core" -I"F:\hotep\SystemWorkbench\workspace\p1\CMSIS\device" -I"F:\hotep\SystemWorkbench\workspace\p1\StdPeriph_Driver\inc" -I"F:\hotep\SystemWorkbench\workspace\p1\Utilities\STM32F1xx-Nucleo" -O3 -Wall -fmessage-length=0 -ffunction-sections -c -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"


