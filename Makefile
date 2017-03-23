##################################
# stm32 (stm32f103c8t6) minimal example Makefile 
##################################


CC = arm-eabi-gcc
 

SRC_DIR = src
BIN_DIR = bin

LIB_BASE_DIR = lib\STM32F10x_StdPeriph_Driver

LIB_SRC_DIR = $(LIB_BASE_DIR)\src
LIB_BIN_DIR = $(LIB_BASE_DIR)\bin
CMSIS_SRC_DIR = lib\CMSIS

INCLUDES = -Ilib\CMSIS -I$(LIB_BASE_DIR)\inc
SYSTEM_LIBS = -L"C:\Program Files\SysGCC\arm-eabi\arm-eabi\lib" -L"C:\Program Files\SysGCC\arm-eabi\lib\gcc\arm-eabi\5.2.0"

# release configuration
CFLAGS  = -c -fno-common -Wall -O3 -mcpu=cortex-m3 -mthumb -mfloat-abi=soft -fmessage-length=0 -ffunction-sections -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER 
LFLAGS = -mcpu=cortex-m3 -mthumb -mfloat-abi=soft -TLinkerScript.ld -Wl,--gc-sections -lm


COMMON_OBJS = \
bin\startup_stm32f10x_md.o \
bin\system_stm32f10x.o 



_TMP_SLASH_LIB_SRCS = $(wildcard $(LIB_SRC_DIR)/*.c)
_TMP_SLASH_LIB_OBJS = $(patsubst $(LIB_SRC_DIR)/%.c,$(LIB_BIN_DIR)/%.o,$(_TMP_SLASH_LIB_SRCS))

LIB_SRCS = $(subst /,\,$(_TMP_SLASH_LIB_SRCS))
LIB_OBJS = $(subst /,\,$(_TMP_SLASH_LIB_OBJS))

 
# $(info lib_srcs = $(LIB_SRCS))
# $(info lib_o = $(LIB_OBJS))

all: $(BIN_DIR)\main.elf

$(BIN_DIR)\main.elf: $(BIN_DIR)\main.o $(COMMON_OBJS) $(LIB_OBJS)
	$(CC) $(LFLAGS) -o $(BIN_DIR)\main.elf $(BIN_DIR)\main.o $(COMMON_OBJS) $(LIB_OBJS)
 
$(BIN_DIR)\main.o: $(SRC_DIR)\main.c 
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BIN_DIR)\main.o $(SRC_DIR)\main.c 
	
	
$(BIN_DIR)\startup_stm32f10x_md.o: $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BIN_DIR)\startup_stm32f10x_md.o $(CMSIS_SRC_DIR)\startup_stm32f10x_md.S
$(BIN_DIR)\system_stm32f10x.o: $(CMSIS_SRC_DIR)\system_stm32f10x.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BIN_DIR)\system_stm32f10x.o $(CMSIS_SRC_DIR)\system_stm32f10x.c



$(LIB_OBJS): $(LIB_BIN_DIR)\\%.o: $(LIB_SRC_DIR)\\%.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<
	
test:
	echo $(LIB_OBJS)


	
clean:
	if exist $(BIN_DIR)\*.o del $(BIN_DIR)\*.o 
	if exist $(BIN_DIR)\*.elf del $(BIN_DIR)\*.elf	
	if exist $(LIB_BIN_DIR)\*.o del $(LIB_BIN_DIR)\*.o 
 


IMAGE = $(BIN_DIR)\\main.elf
OPENOCD_DIR = C:\Program Files\OpenOCD-20160901\bin
OPENOCD_SCRIPTS = -s "C:\Program Files\OpenOCD-20160901\tcl" -s "C:\Program Files\OpenOCD-20160901\tcl\interface"
install: 
	 "$(OPENOCD_DIR)\openocd.exe" $(OPENOCD_SCRIPTS) -f "stlink-v2.cfg" -f "stm32f1x.cfg" -c init -c "reset halt" -c "flash write_image erase $(IMAGE)" -c "verify_image $(IMAGE)" -c "reset" -c shutdown
	 
	 
	 
