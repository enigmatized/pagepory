C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c graphics/*.c memory/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h libc/*.h graphics/*.h memory/*.h)
# Nice syntax for file extension replacement
OBJ = ${C_SOURCES:.c=.o cpu/interrupt.o} 
OBJ1 = ${C_SOURCES:.c=.o} 
#Setting up assembler files
AS := nasm
ASFILES := $(wildcard boot/*.asm cpu/*.asm )
ASOBJECTS := $(ASFILES:.asm=.o)
#Everything as an object
OBJALL = $(ASOBJECTS) $(SOURCES_C)
# Change this if your cross-compiler is somewhere else
CC = gcc
GDB = i386 gdb
# -m32 to target i386
# -g: Use debugging symbols in gcc
# We add -fno-pie
CFLAGS = -fno-pie -g -ffreestanding -Wall -Wextra -fno-exceptions -m32
#linker
LDFLAGS=-Tlink.ld -m elf_i386

# First rule is run by default
os-image.bin: boot/bootsect.bin kernel.bin
	cat $^ > os-image.bin

# '--oformat binary' deletes all symbols as a collateral, so we don't need
# to 'strip' them manually on this case
kernel.bin: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

dip.o: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -N -e start -o $@ -Ttext 0x1000 dip.o boot/kernel_entry.o ${OBJ}
# Used for debugging purposes
kernel.elf: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ 

run: os-image.bin
	qemu-system-i386 -fda os-image.bin

# pad the binary to 512 bytes
img: os-image.bin
	dd if=/dev/zero bs=1024 count=128 of=porygon.img
	dd if=os-image.bin of=porygon.img conv=notrunc
	echo "porygon.img created, you may now run bochs"
	
bochs: img
	bochs

ultron.bin: $(OBJ1)
	ld $(LDFLAGS) -o $@ $^

tall: $(OBJALL) small

bootblock: boot/kernel_entry.asm ${OBJ}
	#$(CC) $(CFLAGS) -fno-pic -O -nostdinc -I. -c kernel/kernel.c
	$(CC) $(CFLAGS) -fno-pic -nostdinc -I. -c boot/kernel_entry.asm
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x1000 -o bootblock.o boot/kernel_entry.o ${OBJ}
	#$(OBJDUMP) -S bootblock.o > bootblock.asm
	#$(OBJCOPY) -S -O binary -j .text bootblock.o bootblock
	#./sign.pl bootblock

small:
	$(LD) $(LDFLAGS) -o kernel.bin $(OBJALL)
# Open the connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	qemu-system-i386 -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -c $< -o $@

#this could be the problem
#asm.o is not correct format
%.o: %.asm
	nasm -f elf $< -o $@



#%.o: %.asm
#	nasm $< -f elf -o $@

#%.bin: %.asm
#	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf *.img
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o libc/*.o graphics/*.o memory/*.o

all: $(OBJ1) link

link:
	ld $(LDFLAGS) -o kernell $(OBJ1)

