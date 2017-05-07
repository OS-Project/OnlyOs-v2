CFLAGS=-I ../../include -c -nodefaultlibs -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-a8 -march=armv7-a -pedantic -Wextra -std=c99 -O0

all: interrupt.c
	@echo "Compiling interrupt..."
	arm-none-eabi-gcc $(CFLAGS) interrupt.c -o ../interrupt.out

clean:
	@rm *.out
