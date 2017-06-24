# OnlyOS-v2
This is a simple Os for the BeagleBone black. This is the continuation of a previous work on the subject (OnlyOs).


# Todo
Add sd card formatting script.
Add reference for the compilation options document.

# Compilation
Each part of the os is a directory. The root Makefile call each subdir's Makefile, and then link everything together.
See the Makefile at the root of this directory for compilation flags.
- Cortex-A* (No FP): [-mthumb] -march=armv7-a
- Cortex-A* (Soft FP): [-mthumb] -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16
- Cortex-A* (Hard FP): [-mthumb] -march=armv7-a -mfloat-abi=hard -mfpu=vfpv3-d16
- [ ] Compilation: use arm instruction (-marm option in gcc)
- In the .list, there are strange instructions at the end of section .text.boot (near halt func)

# Linker script
- [ ] Output arch options in linker script
- [ ] Program entry-point details: is it a symbol?
- [ ] Stack sizes justification.


# Assembly
- Difference between ".code 32" and ".arm": none.
- Stack if full descending: the Procedure Call Standard for the ARM Architecture (AAPCS), and ARM and Thumb C and C++ compilers always use a full descending stack. The PUSH and POP instructions assume a full descending stack. (http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0473c/Cacbgchh.html)


# Boot
- [ ] Disable fiq, enable irq.
- [x] Check flags values for processor modes in the doc.
- [x] Check flags values for irq and fiq in the doc.
- [x] Init stacks for all modes. Stack sizes in boot.s must match the linker script.
- [x] Clear .bss section.
- [ ] Call main function: do not use branch. Address may be out of range.
- [ ] Prefetch abort and data abort modes differences?
- [ ] Branch prediction p59 Cortex Guide.


# Interrupts/Exceptions handling
- Always save spsr, as an other exception might occur, hence resulting in the loss of spsr.
- [x] Interruption table.
- [x] Svc call.
- [x] Svc handler
- [ ] Abort handler
- [ ] Undefined instruction handler
- [ ] Irq handler
- [ ] Fiq handler: print message.
- Check exceptions handlers.
- Add routine to indicates the current processor state.

|    Value   | r0 Code       |     r1                     |   r2                   | return (r0)            |
| ---------- | ------------- | -------------------------- | ---------------------- | ---------------------- |
| error      | 0x00000       |  Error number              | Undefined              | 0 if success, else 1   |
| UART_putc  | 0x00100       |  the char to push          | Null                   | 0 if success, else 1   |
| minit      | 0x00200       |  process heap_start adress | Null                   | 0 if success, else 1   |
| kmalloc    | 0x00201       |  process heap_start adress | Null                   | adress of memory block |


# Kernel
- [ ] kexit() or call to _exit() syscall ?
- [x] Disable interrupts in exit function


# Filesystem driver
- [ ] File system (must code diskio.c)


# UART driver
- [ ] uart_init(): causes crashes
- [X] Mettre uart_strLen dans un fichier util
- [X] Séparer les fichiers du syscalls.c
- Operational mode configuration necesssary?
- uart_write_byte(): is UART_LSR_TX_SR_E necessary?
- uart_write_byte(): alternate version using diferrent register?
- uart_read_byte(): alternate version for signed values?


# Misc
How to compile newlib ?
-----------------------
./configure --target=arm-none-eabi --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-shared --disable-libssp --disable-libada --disable-newlib-supplied-syscalls --enable-lite-exit --disable-newlib-multithread

sources : https://gcc.gnu.org/ml/gcc-help/2012-08/msg00190.html
./configure --target=arm-none-eabi --enable-interwork --enable-multilib --with-newlib --disable-nls --disable-shared --disable-threads --with-gnu-ld --with-gnu-as --disable-libssp --disable-libmudflap --disable-libgomp --with-dwarf2 -v --disable-werror --with-cpu=cortex-a8 --with-mode=thumb --enable-target-optspace --with-fpu=fpv4-sp-d16 --with-float=soft --enable-languages=c,c++ --disable-newlib-multithread


# Unified commands
%.o: %.c
	@echo "Compilation de $<"
	@$(CC) $(CCFLAGS) -c $< -o $@

%.o: %.cpp
	@echo "Compilation de $<"
	@$(CPP) $(CCFLAGS) -c $< -o $@

%.o: %.s
	@echo "Assemblage de $<"
	@$(AS) $(ASFLAGS) $< -o $@

INIT_MAKE:
	@echo "Initialisation pour la compilation..."













GNU Tools for ARM Embedded Processors
Version: 5

Table of Contents
* C Libraries usage
* Linker scripts & startup code
* Samples
* GDB Server for CMSIS-DAP based hardware debugger

* C Libraries usage *

This toolchain is released with two prebuilt C libraries based on newlib:
one is the standard newlib and the other is newlib-nano for code size.
To distinguish them, we rename the size optimized libraries as:

  libc.a --> libc_nano.a
  libg.a --> libg_nano.a

To use newlib-nano, users should provide additional gcc compile and link time
option:
 --specs=nano.specs

At compile time, a 'newlib.h' header file especially configured for newlib-nano
will be used if --specs=nano.specs is passed to the compiler.

Nano.specs also handles two additional gcc libraries: libstdc++_nano.a and
libsupc++_nano.a, which are optimized for code size.

For example:
$ arm-none-eabi-gcc src.c --specs=nano.specs $(OTHER_OPTIONS)

This option can also work together with other specs options like
--specs=rdimon.specs

Please note that, unlike previous versions of this toolchain, --specs=nano.specs
is now both a compiler and linker option.  Be sure to include in both compiler
and linker options if compiling and linking are separated.

** additional newlib-nano libraries usage

Newlib-nano is different from newlib in addition to the libraries' name.
Formatted input/output of floating-point number are implemented as weak symbol.
If you want to use %f, you have to pull in the symbol by explicitly specifying
"-u" command option.

  -u _scanf_float
  -u _printf_float

e.g. to output a float, the command line is like:
$ arm-none-eabi-gcc --specs=nano.specs -u _printf_float $(OTHER_LINK_OPTIONS)

For more about the difference and usage, please refer the README.nano in the
source package.

Users can choose to use or not use semihosting by following instructions.
** semihosting
If you need semihosting, linking like:
$ arm-none-eabi-gcc --specs=rdimon.specs $(OTHER_LINK_OPTIONS)

** non-semihosting/retarget
If you are using retarget, linking like:
$ arm-none-eabi-gcc --specs=nosys.specs $(OTHER_LINK_OPTIONS)

* Linker scripts & startup code *

Latest update of linker scripts template and startup code is available on
http://www.arm.com/cmsis

* Samples *
Examples of all above usages are available at:
$install_dir/gcc-arm-none-eabi-*/share/gcc-arm-none-eabi/samples

Read readme.txt under it for further information.

* GDB Server for CMSIS-DAP based hardware debugger *
CMSIS-DAP is the interface firmware for a Debug Unit that connects
the Debug Port to USB.  More detailed information can be found at
http://www.keil.com/support/man/docs/dapdebug/.

A software GDB server is required for GDB to communicate with CMSIS-DAP based
hardware debugger.  The pyOCD is an implementation of such GDB server that is
written in Python and under Apache License.

For those who are using this toolchain and have board with CMSIS-DAP based
debugger, the pyOCD is our recommended gdb server.  More information can be
found at https://github.com/mbedmicro/pyOCD.
