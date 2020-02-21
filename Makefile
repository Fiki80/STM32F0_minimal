TARGET = main
LD_SCRIPT = stm32f030f4.ld
MCU_SPEC = cortex-m0 

TOOL = ./build
CC = $(TOOL) arm-none-eabi-gcc
AS = $(TOOL) arm-none-eabi-as
LD = $(TOOL) arm-none-eabi-ld
OC = $(TOOL) arm-none-eabi-objcopy
OD = $(TOOL) arm-none-eabi-objdump
OS = $(TOOL) arm-none-eabi-size

ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
ASFLAGS += -fmessage-length=0

CFLAGS += -mcpu=$(MCU_SPEC) 
CFLAGS += -mthumb
CFLAGS += -Wall
CFLAGS += -g
CFLAGS += -fmessage-length=0
CFLAGS += --specs=nosys.specs 

LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += -Wl,-Map=$(TARGET).map
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -T$(LSCRIPT)

VEC_TBL = ./vector_table.S 
AS_SRC = ./core.S
C_SRC = ./main.c

OBJS =  $(VEC_TBL:.S=.o)
OBJS += $(AS_SRC:.S=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all clean

all: $(TARGET).bin

%.o : %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
	rm -f $(TARGET).bin
	rm -f $(TARGET).map
