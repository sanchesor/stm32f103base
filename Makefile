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
bin\system_stm32f10x.o 


LIB_SRCS = $(wildcard $(LIB_SRC_DIR)\*.c)
LIB_OBJS2 = $(LIB_SRCS:.c=.o)
 
all: $(BIN_DIR)\main.elf

$(BIN_DIR)\main.elf: $(BIN_DIR)\main.o $(LIB_OBJS) $(LIB_OBJS2)
	echo "main"
	echo $(LIB_OBJS2)
	$(CC) $(LFLAGS) -o $(BIN_DIR)\main.elf $(BIN_DIR)\main.o $(LIB_OBJS) $(LIB_OBJS2)
 
$(BIN_DIR)\main.o: $(SRC_DIR)\main.c 
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(BIN_DIR)\main.o $(SRC_DIR)\main.c 
	
	
$(BIN_DIR)\startup_stm32f10x_md.o: $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(BIN_DIR)\startup_stm32f10x_md.o $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
$(BIN_DIR)\system_stm32f10x.o: $(CMSIS_SRC_DIR)\system_stm32f10x.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(BIN_DIR)\system_stm32f10x.o $(CMSIS_SRC_DIR)\system_stm32f10x.c



$(LIB_SRC_DIR)\*.o: $(LIB_SRC_DIR)\*.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $@ $<
	
test:
	echo $(LIB_OBJS2)


$(LIB_BIN_DIR)\stm32f10x_rcc.o: $(LIB_SRC_DIR)\stm32f10x_rcc.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(LIB_BIN_DIR)\stm32f10x_rcc.o $(LIB_SRC_DIR)\stm32f10x_rcc.c
$(LIB_BIN_DIR)\stm32f10x_gpio.o: $(LIB_SRC_DIR)\stm32f10x_gpio.c
	$(CC) $(CFLAGS) $(INCLUDES)  -o $(LIB_BIN_DIR)\stm32f10x_gpio.o $(LIB_SRC_DIR)\stm32f10x_gpio.c

	
clean:
	if exist $(BIN_DIR)\*.o del $(BIN_DIR)\*.o 
	if exist $(BIN_DIR)\*.elf del $(BIN_DIR)\*.elf
	if exist $(BIN_DIR)\*.bin del $(BIN_DIR)\*.bin
	if exist $(LIB_BIN_DIR)\*.o del $(LIB_BIN_DIR)\*.o 
	echo $(LIB_SRCS)
	echo $(LIB_OBJS2)
 

	

IMAGE = $(BIN_DIR)\\main.elf
OPENOCD_DIR = C:\Program Files\OpenOCD-20160901\bin
OPENOCD_SCRIPTS = -s "C:\Program Files\OpenOCD-20160901\tcl" -s "C:\Program Files\OpenOCD-20160901\tcl\interface"
install: 
	 "$(OPENOCD_DIR)\openocd.exe" $(OPENOCD_SCRIPTS) -f "stlink-v2.cfg" -f "stm32f1x.cfg" -c init -c "reset halt" -c "flash write_image erase $(IMAGE)" -c "verify_image $(IMAGE)" -c "reset" -c shutdown
	 
	 
	 
