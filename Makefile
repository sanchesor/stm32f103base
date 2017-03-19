##################################
# stm32 (stm32f103c8t6) minimal example Makefile 
##################################


CC = arm-eabi-gcc
 
LKR_SCRIPT = LinkerScript.ld

SRC_DIR = src
BIN_DIR = bin
LIB_SRC_DIR = lib\STM32F10x_StdPeriph_Driver\src
LIB_BIN_DIR = lib\STM32F10x_StdPeriph_Driver\bin
CMSIS_SRC_DIR = lib\CMSIS

INCLUDES = -Ilib\CMSIS -Ilib\STM32F10x_StdPeriph_Driver\inc
SYSTEM_LIBS = -L"C:\Program Files\SysGCC\arm-eabi\arm-eabi\lib" -L"C:\Program Files\SysGCC\arm-eabi\lib\gcc\arm-eabi\5.2.0"

# release configuration
CFLAGS  = -c -fno-common -Wall -O3 -mcpu=cortex-m3 -mthumb -mfloat-abi=soft -fmessage-length=0 -ffunction-sections -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER 
LFLAGS = -mcpu=cortex-m3 -mthumb -mfloat-abi=soft -T$(LKR_SCRIPT) -Wl,--gc-sections -lm


LIB_OBJS = \
bin\startup_stm32f10x_md.o \
bin\system_stm32f10x.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_gpio.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_rcc.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_usart.o \


 
all: $(BIN_DIR)\main.elf

$(BIN_DIR)\main.elf: $(BIN_DIR)\main.o $(LIB_OBJS)
	$(CC) $(LFLAGS) -o $(BIN_DIR)\main.elf $(BIN_DIR)\main.o $(LIB_OBJS)  
 
$(BIN_DIR)\main.o: $(SRC_DIR)\main.c 
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(BIN_DIR)\main.o $(SRC_DIR)\main.c 

	
	
$(BIN_DIR)\startup_stm32f10x_md.o: $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(BIN_DIR)\startup_stm32f10x_md.o $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
$(BIN_DIR)\system_stm32f10x.o: $(CMSIS_SRC_DIR)\system_stm32f10x.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(BIN_DIR)\system_stm32f10x.o $(CMSIS_SRC_DIR)\system_stm32f10x.c



$(LIB_BIN_DIR)\stm32f10x_rcc.o: $(LIB_SRC_DIR)\stm32f10x_rcc.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(LIB_BIN_DIR)\stm32f10x_rcc.o $(LIB_SRC_DIR)\stm32f10x_rcc.c
$(LIB_BIN_DIR)\stm32f10x_gpio.o: $(LIB_SRC_DIR)\stm32f10x_gpio.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(LIB_BIN_DIR)\stm32f10x_gpio.o $(LIB_SRC_DIR)\stm32f10x_gpio.c
$(LIB_BIN_DIR)\stm32f10x_usart.o: $(LIB_SRC_DIR)\stm32f10x_usart.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(LIB_BIN_DIR)\stm32f10x_usart.o $(LIB_SRC_DIR)\stm32f10x_usart.c

	
clean:
	if exist $(BIN_DIR)\*.o del $(BIN_DIR)\*.o 
	if exist $(BIN_DIR)\*.elf del $(BIN_DIR)\*.elf
	if exist $(BIN_DIR)\*.bin del $(BIN_DIR)\*.bin
	if exist $(LIB_BIN_DIR)\*.o del $(LIB_BIN_DIR)\*.o 
 

	
IMAGE = bin\\main.elf
OPENOCD_DIR = C:\Program Files\OpenOCD-20160901\bin
install: 
	 "$(OPENOCD_DIR)\openocd.exe" -f "stlink-v2.cfg" -f "stm32f1x.cfg" -c init -c "reset halt" -c "flash write_image erase $(IMAGE)" -c "verify_image $(IMAGE)" -c "reset" -c shutdown
	 
	 
	 
