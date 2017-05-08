FILE_NAME = boot
SUBDIRS = kernel

# Configure toolchain
PREFIX=arm-none-eabi
CC=${PREFIX}-gcc
LD=${PREFIX}-ld
AR=${PREFIX}-ar
AS=${PREFIX}-as




# Flags
ASFLAGS=--warn -mcpu=cortex-a8
CFLAGS=-I ../include -Wall -c -nodefaultlibs -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-a8 -march=armv7-a -pedantic -Wextra -std=c99 -O0
LDFLAGS = -T linker.ld -nodefaultlibs -nostdlib -nostartfiles

export # Make variables visible to sub-makefiles


all: $(SUBDIRS)
	@echo "\n### Linkage des sources"
	$(LD) $(LDFLAGS) kernel.out -o ${FILE_NAME}.elf
	$(PREFIX)-nm ${FILE_NAME}.elf -n > ${FILE_NAME}.sections
	$(PREFIX)-objdump -D ${FILE_NAME}.elf > ${FILE_NAME}.list
	$(PREFIX)-objcopy ${FILE_NAME}.elf -O srec ${FILE_NAME}.srec
	$(PREFIX)-objcopy ${FILE_NAME}.elf -O binary ${FILE_NAME}.bin

# For each sub directory, call the makefile inside it.
$(SUBDIRS):
	$(MAKE) -C $@

clean:
	@rm ${FILE_NAME}.* *.out
	$(MAKE) -C kernel clean

.PHONY: $(SUBDIRS)
