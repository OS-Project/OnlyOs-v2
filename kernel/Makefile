CFLAGS=-I ../include -c -nodefaultlibs -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-a8 -march=armv7-a -pedantic -Wextra -std=c99 -O0
SUBDIRS = boot interrupt
FILE_NAME = kernel


all: $(SUBDIRS) kernel.c
	@echo "Compiling kernel..."
	arm-none-eabi-gcc $(CFLAGS) kernel.c -o kernel.out
	arm-none-eabi-ar r ../kernel.out interrupt.out boot.out kernel.out

# For each sub directory, call the makefile inside it.
$(SUBDIRS):
	$(MAKE) -C $@

clean:
	@rm *.out


.PHONY: $(SUBDIRS)
