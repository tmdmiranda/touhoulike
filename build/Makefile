AS = nasm
CC = wcl386

SRC_DIR = ../src
vpath %.asm $(SRC_DIR)
vpath %.c   $(SRC_DIR)

ASFLAGS = -f obj
CFLAGS = -l=dos4g

TARGET = game.exe

ASM_SRCS = keyboard.asm 13h.asm
C_SRCS = main.c
OBJS = $(ASM_SRCS:.asm=.obj) $(C_SRCS:.c=.obj)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -fe=$@ $(OBJS)

%.obj: %.asm
	$(AS) $(ASFLAGS) $< -o $@

%.obj: %.c
	$(CC) $(CFLAGS) -c $< -fo=$@

clean:
	rm -f *.obj *.exe *.err
