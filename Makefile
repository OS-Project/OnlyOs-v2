FILE_NAME = boot
SUBDIRS = kernel

# Flags
LDFLAGS = -T linker.ld -nodefaultlibs -nostdlib -nostartfiles
CFLAGS=-I ../include -c -nodefaultlibs -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-a8 -march=armv7-a -pedantic -Wextra -std=c99 -O0
#include ${ROOT}/build/makedefs

#SRC = ${shell python scripts/create_src_list.py}
#OBJ = $(SRC:.c=.o)

export # Make variables visible to sub-makefiles


all: $(SUBDIRS)
	@echo "\n### Linkage des sources"
	arm-none-eabi-ld $(LDFLAGS) kernel.out -o ${FILE_NAME}.elf
	arm-none-eabi-nm ${FILE_NAME}.elf -n > ${FILE_NAME}.sections
	arm-none-eabi-objdump -D ${FILE_NAME}.elf > ${FILE_NAME}.list
	arm-none-eabi-objcopy ${FILE_NAME}.elf -O srec ${FILE_NAME}.srec
	arm-none-eabi-objcopy ${FILE_NAME}.elf -O binary ${FILE_NAME}.bin


# For each sub directory, call the makefile inside it.
$(SUBDIRS):
	$(MAKE) -C $@

clean:
	@rm ${FILE_NAME}.* *.out

.PHONY: $(SUBDIRS)

#include ${ROOT}/build/makefuncs
