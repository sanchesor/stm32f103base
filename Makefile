##################################
# stm32 (stm32f103c8t6) minimal example Makefile 
##################################


CC = arm-eabi-gcc
CP = arm-eabi-objcopy
 
LKR_SCRIPT = LinkerScript.ld

SRC_DIR = src
BIN_DIR = bin
LIB_SRC_DIR = lib\STM32F10x_StdPeriph_Driver\src
LIB_BIN_DIR = lib\STM32F10x_StdPeriph_Driver\bin
CMSIS_SRC_DIR = lib\CMSIS

MACRO_DEFS = -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER 
INCLUDES = -Ilib\CMSIS -Ilib\STM32F10x_StdPeriph_Driver\inc
CFLAGS  = -c -fno-common -Wall -O0 -g -mcpu=cortex-m3 -mthumb -mfloat-abi=soft 
LFLAGS  = -T$(LKR_SCRIPT) -Wl,--gc-sections
CPFLAGS = -Obinary
SYSTEM_LIBS = -L"C:\Program Files\SysGCC\arm-eabi\arm-eabi\lib" -L"C:\Program Files\SysGCC\arm-eabi\lib\gcc\arm-eabi\5.2.0"


LIB_OBJS = \
bin\startup_stm32f10x_md.o \
bin\system_stm32f10x.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_gpio.o \
lib\STM32F10x_StdPeriph_Driver\bin\stm32f10x_rcc.o \

 
all: $(BIN_DIR)\main.bin
 
$(BIN_DIR)\main.o: $(SRC_DIR)\main.c 
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\main.o $(SRC_DIR)\main.c 

	
$(BIN_DIR)\main.elf: $(BIN_DIR)\main.o $(LIB_OBJS)
	$(CC) $(LFLAGS) -o $(BIN_DIR)\main.elf $(BIN_DIR)\main.o $(LIB_OBJS)  
 
$(BIN_DIR)\main.bin: $(BIN_DIR)\main.elf
	$(CP) $(CPFLAGS) $(BIN_DIR)\main.elf $(BIN_DIR)\main.bin

	
$(BIN_DIR)\startup_stm32f10x_md.o: $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\startup_stm32f10x_md.o $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
$(BIN_DIR)\system_stm32f10x.o: $(CMSIS_SRC_DIR)\system_stm32f10x.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(BIN_DIR)\system_stm32f10x.o $(CMSIS_SRC_DIR)\system_stm32f10x.c



$(LIB_BIN_DIR)\stm32f10x_rcc.o: $(LIB_SRC_DIR)\stm32f10x_rcc.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(LIB_BIN_DIR)\stm32f10x_rcc.o $(LIB_SRC_DIR)\stm32f10x_rcc.c
$(LIB_BIN_DIR)\stm32f10x_gpio.o: $(LIB_SRC_DIR)\stm32f10x_gpio.c
	$(CC) $(CFLAGS) $(INCLUDES) $(MACRO_DEFS) -o $(LIB_BIN_DIR)\stm32f10x_gpio.o $(LIB_SRC_DIR)\stm32f10x_gpio.c

	
clean:
	if exist $(BIN_DIR)\*.o del $(BIN_DIR)\*.o 
	if exist $(BIN_DIR)\*.elf del $(BIN_DIR)\*.elf
	if exist $(BIN_DIR)\*.bin del $(BIN_DIR)\*.bin
	if exist $(LIB_BIN_DIR)\*.o del $(LIB_BIN_DIR)\*.o 
 



	
IMAGE = bin\\main.elf
OPENOCD_DIR = C:\Program Files\OpenOCD-20160901\bin
install: 
	 "$(OPENOCD_DIR)\openocd.exe" -f "stlink-v2.cfg" -f "stm32f1x.cfg" -c init -c "reset halt" -c "flash write_image erase $(IMAGE)" -c "verify_image $(IMAGE)" -c "reset" -c shutdown
	 
	 
	 




