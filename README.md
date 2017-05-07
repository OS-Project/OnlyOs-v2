# OnlyOS
The operating system

# Compilation instruction
Each part of the os is a directory. The root Makefile call each subdir's Makefile, and then link everything together.


# Todo
Comment Makefiles.
https://stackoverflow.com/questions/14880419/share-variables-between-makefiles  
https://stackoverflow.com/questions/12697012/passing-variables-from-include-directive-to-sub-make

# Kernel
- [ ] kexit() or call to _exit() syscall ?
- [x] Disable interrupts in exit function


# Boot
- [x] Disable fiq, enable irq.
- [x] Check flags values for processor modes in the doc.
- [x] Check flags values for irq and fiq in the doc.
- [x] Stack implementation: FA, FD, EA, ED? Currently ED.
- [x] Init stacks for all modes. Stack sizes in boot.s must match the linker script.
- [x] Clear .bss section.
- [x] Call main function: do not use branch. Address may be out of range.
- [ ] Prefetch abort and data abort modes differences?
- [ ] Branch prediction p59 Cortex Guide.

# Linker script
- [ ] Output arch options in linker script
- [ ] Program entry-point details: is it a symbol?
- [ ] Stack sizes justification.  
- [ ]


# Interrupts/Exceptions handling
- [x] Interruption table.
- [x] Svc call.
- [x] Svc handler
- [x] Abort handler
- [x] Undefined instruction handler
- [ ] Irq handler
- [x] Fiq handler: print message.

|    Value   | r0 Code       |     r1                     |   r2                   | return (r0)            |
| ---------- | ------------- | -------------------------- | ---------------------- | ---------------------- |
| error      | 0x00000       |  Error number              | Undefined              | 0 if success, else 1   |
| UART_putc  | 0x00100       |  the char to push          | Null                   | 0 if success, else 1   |
| minit      | 0x00200       |  process heap_start adress | Null                   | 0 if success, else 1   |
| kmalloc    | 0x00201       |  process heap_start adress | Null                   | adress of memory block |


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
How to compile a new source ?
-----------------------------
Create a file "makesrc" in the directory of the source(s) file(s) and add the name of the sources inside.
The script will automaticaly reconize the files and compile them.

Bugs for asm source files.

Questions
---------
- fichier tempo en C
- [ ] Compilation: use arm instruction (-marm option in gcc)
- [x] Difference .code 32 and .arm: none.


How to compile newlib ?
-----------------------
./configure --target=arm-none-eabi --enable-interwork --enable-multilib --with-gnu-as --with-gnu-ld --disable-shared --disable-libssp --disable-libada --disable-newlib-supplied-syscalls --enable-lite-exit --disable-newlib-multithread

sources : https://gcc.gnu.org/ml/gcc-help/2012-08/msg00190.html
./configure --target=arm-none-eabi --enable-interwork --enable-multilib --with-newlib --disable-nls --disable-shared --disable-threads --with-gnu-ld --with-gnu-as --disable-libssp --disable-libmudflap --disable-libgomp --with-dwarf2 -v --disable-werror --with-cpu=cortex-a8 --with-mode=thumb --enable-target-optspace --with-fpu=fpv4-sp-d16 --with-float=soft --enable-languages=c,c++ --disable-newlib-multithread

# Configure toolchain
PREFIX=arm-none-eabi

# Compiler, Linker and Archiver with respect to the toolchain
CC=${PREFIX}-gcc
CPP=${PREFIX}-g++
LD=${PREFIX}-ld
AR=${PREFIX}-ar
AS=${PREFIX}-as
BIN=$(PREFIX)-objcopy

# Source code paths
BOOT_SRC=${ROOT}/boot
ARCH_SRC=${ROOT}/arch
DRIVER_SRC=${ROOT}/drivers
KERNEL_SRC=${ROOT}/kernel
HAL_SRC=${ARCH_SRC}/arm/hal
SYSCALLS_SRC=${ROOT}/syscalls

BIN_SRC=${ROOT}/bin/${C_MODE}
BIN_LIBS_SRC=${BIN_SRC}/libs

# Files paths
LINKER_PATH = ${ROOT}/build/linker.ld

# Include paths
IPATH=-I ${ROOT}/include/arch/arm \
      -I ${ROOT}/include/arch/arm/hal/hw \
      -I ${ROOT}/include \
      -I ${ROOT}/build

LPATH = -L${ROOT}/build

# Flags
CCFLAGS = -Wall ${IPATH} -nodefaultlibs -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-a8 -march=armv7-a -pedantic -Wextra -std=c99 -O0

#|------------|--------------------------------------------|--------------|
#| Cortex-A*  | [-mthumb] -march=armv7-a                   | armv7-ar     |
#| (No FP)    |                                            | /thumb       |
#|------------|--------------------------------------------|--------------|
#| Cortex-A*  | [-mthumb] -march=armv7-a -mfloat-abi=softfp| armv7-ar     |
#| (Soft FP)  | -mfpu=vfpv3-d16                            | /thumb       |
#|            |                                            | /softfp      |
#|------------|--------------------------------------------|--------------|
#| Cortex-A*  | [-mthumb] -march=armv7-a -mfloat-abi=hard  | armv7-ar     |
#| (Hard FP)  | -mfpu=vfpv3-d16                            | /thumb       |
#|            |                                            | /fpu
#|------------|--------------------------------------------|--------------|

ASFLAGS = --warn -mcpu=cortex-a8
LDFLAGS = ${LPATH} -nodefaultlibs -nostdlib -nostartfiles


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
    * Installing executables on Linux
    * Installing executables on Mac OS X
    * Installing executables on Windows
    * Invoking GCC
    * Architecture options usage
    * C Libraries usage
    * Linker scripts & startup code
    * Samples
    * GDB Server for CMSIS-DAP based hardware debugger

    * Installing executables on Linux *
    Unpack the tarball to the install directory, like this:
    $ cd $install_dir && tar xjf gcc-arm-none-eabi-*-yyyymmdd-linux.tar.bz2

    For 64 bit system, 32 bit libc and libncurses are required to run the tools.
    In addition, if you want to use gdb python build (arm-none-eabi-gdb-py), you'd
    install 32 bit python2.7. Please refer
    https://answers.launchpad.net/gcc-arm-embedded/+faq/2601

    For some Ubuntu releases, the toolchain can also be installed via
    Launchpad PPA at https://launchpad.net/~team-gcc-arm-embedded/+archive/ubuntu/ppa.

    * Installing executables on Mac OS X *
    Unpack the tarball to the install directory, like this:
    $ cd $install_dir && tar xjf gcc-arm-none-eabi-*-yyyymmdd-mac.tar.bz2

    * Installing executables on Windows *
    Run the installer (gcc-arm-none-eabi-*-yyyymmdd-win32.exe) and follow the
    instructions.

    The toolchain in windows zip package is a backup to windows installer for
    those who cannot run installer.  We need decompress the zip package
    in a proper place and then invoke it following instructions in next section.

    To use gdb python build (arm-none-eabi-gdb-py), you need install 32 bit
    python2.7 no matter 32 or 64 bit Windows. Please get the package from
    https://www.python.org/download/.

    * Invoking GCC *
    On Linux and Mac OS X, either invoke with the complete path like this:
    $ $install_dir/gcc-arm-none-eabi-*/bin/arm-none-eabi-gcc

    Or set path like this:
    $ export PATH=$PATH:$install_dir/gcc-arm-none-eabi-*/bin
    $ arm-none-eabi-gcc

    On Windows (although the above approaches also work), it can be more
    convenient to either have the installer register environment variables, or run
    INSTALL_DIR\bin\gccvar.bat to set environment variables for the current cmd.

    For windows zip package, after decompression we can invoke toolchain either with
    complete path like this:
    TOOLCHAIN_UNZIP_DIR\bin\arm-none-eabi-gcc
    or run TOOLCHAIN_UNZIP_DIR\bin\gccvar.bat to set environment variables for the
    current cmd.

    * Architecture options usage *

    This toolchain is built and optimized for Cortex-A/R/M bare metal development.
    the following table shows how to invoke GCC/G++ with correct command line
    options for variants of Cortex-A/R and Cortex-M architectures.

    --------------------------------------------------------------------------
    |   ARM core | Command Line Options                       | multilib     |
    | / ARM arch |                                            |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M0+ | -mthumb -mcpu=cortex-m0plus                | armv6-m      |
    | Cortex-M0  | -mthumb -mcpu=cortex-m0                    |              |
    | Cortex-M1  | -mthumb -mcpu=cortex-m1                    |              |
    |            |--------------------------------------------|              |
    |            | -mthumb -march=armv6-m                     |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M3  | -mthumb -mcpu=cortex-m3                    | armv7-m      |
    |            |--------------------------------------------|              |
    |            | -mthumb -march=armv7-m                     |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M4  | -mthumb -mcpu=cortex-m4                    | armv7e-m     |
    | (No FP)    |--------------------------------------------|              |
    |            | -mthumb -march=armv7e-m                    |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M4  | -mthumb -mcpu=cortex-m4 -mfloat-abi=softfp | armv7e-m     |
    | (Soft FP)  | -mfpu=fpv4-sp-d16                          | /softfp      |
    |            |--------------------------------------------|              |
    |            | -mthumb -march=armv7e-m -mfloat-abi=softfp |              |
    |            | -mfpu=fpv4-sp-d16                          |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M4  | -mthumb -mcpu=cortex-m4 -mfloat-abi=hard   | armv7e-m     |
    | (Hard FP)  | -mfpu=fpv4-sp-d16                          | /fpu         |
    |            |--------------------------------------------|              |
    |            | -mthumb -march=armv7e-m -mfloat-abi=hard   |              |
    |            | -mfpu=fpv4-sp-d16                          |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M7  | -mthumb -mcpu=cortex-m7                    | armv7e-m     |
    | (No FP)    |--------------------------------------------|              |
    |            | -mthumb -march=armv7e-m                    |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M7  | -mthumb -mcpu=cortex-m7 -mfloat-abi=softfp | armv7e-m     |
    | (Soft FP)  | -mfpu=fpv5-sp-d16                          | /softfp      |
    |            |--------------------------------------------| /fpv5-sp-d16 |
    |            | -mthumb -march=armv7e-m -mfloat-abi=softfp |              |
    |            | -mfpu=fpv5-sp-d16                          |              |
    |            |--------------------------------------------|--------------|
    |            | -mthumb -mcpu=cortex-m7 -mfloat-abi=softfp | armv7e-m     |
    |            | -mfpu=fpv5-d16                             | /softfp      |
    |            |--------------------------------------------| /fpv5-d16    |
    |            | -mthumb -march=armv7e-m -mfloat-abi=softfp |              |
    |            | -mfpu=fpv5-d16                             |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-M7  | -mthumb -mcpu=cortex-m7 -mfloat-abi=hard   | armv7e-m     |
    | (Hard FP)  | -mfpu=fpv5-sp-d16                          | /fpu         |
    |            |--------------------------------------------| /fpv5-sp-d16 |
    |            | -mthumb -march=armv7e-m -mfloat-abi=hard   |              |
    |            | -mfpu=fpv5-sp-d16                          |              |
    |            |--------------------------------------------|--------------|
    |            | -mthumb -mcpu=cortex-m7 -mfloat-abi=hard   | armv7e-m     |
    |            | -mfpu=fpv5-d16                             | /fpu         |
    |            |--------------------------------------------| /fpv5-d16    |
    |            | -mthumb -march=armv7e-m -mfloat-abi=hard   |              |
    |            | -mfpu=fpv5-d16                             |              |
    |------------|--------------------------------------------|--------------|
    | ARMv8-M    | -mthumb -march=armv8-m.base                | armv8-m.base |
    | Baseline   |                                            |              |
    |------------|--------------------------------------------|--------------|
    | ARMv8-M    | -mthumb -march=armv8-m.main                | armv8-m.main |
    | Mainline   |                                            |              |
    | (No FP)    |                                            |              |
    |------------|--------------------------------------------|--------------|
    | ARMv8-M    | -mthumb -march=armv8-m.main                | armv8-m.main |
    | Mainline   | -mfloat-abi=softfp -mfpu=fpv5-sp-d16       | /softfp      |
    | (Soft FP)  |                                            | /fpv5-sp-d16 |
    |            |--------------------------------------------|--------------|
    |            | -mthumb -march=armv8-m.main                | armv8-m.main |
    |            | -mfloat-abi=softfp -mfpu=fpv5-d16          | /softfp      |
    |            |                                            | /fpv5-d16    |
    |------------|--------------------------------------------|--------------|
    | ARMv8-M    | -mthumb -march=armv8-m.main                | armv8-m.main |
    | Mainline   | -mfloat-abi=hard -mfpu=fpv5-sp-d16         | /fpu         |
    | (Hard FP)  |                                            | /fpv5-sp-d16 |
    |            |--------------------------------------------|--------------|
    |            | -mthumb -march=armv8-m.main                | armv8-m.main |
    |            | -mfloat-abi=hard -mfpu=fpv5-d16            | /fpu         |
    |            |                                            | /fpv5-d16    |
    |------------|--------------------------------------------|--------------|
    | Cortex-R4  | [-mthumb] -march=armv7-r                   | armv7-ar     |
    | Cortex-R5  |                                            | /thumb       |
    | Cortex-R7  |                                            |              |
    | Cortex-R8  |						  |		 |
    | (No FP)    |                                            |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-R4  | [-mthumb] -march=armv7-r -mfloat-abi=softfp| armv7-ar     |
    | Cortex-R5  | -mfpu=vfpv3-d16                            | /thumb       |
    | Cortex-R7  |                                            | /softfp      |
    | Cortex-R8  |						  |		 |
    | (Soft FP)  |                                            |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-R4  | [-mthumb] -march=armv7-r -mfloat-abi=hard  | armv7-ar     |
    | Cortex-R5  | -mfpu=vfpv3-d16                            | /thumb       |
    | Cortex-R7  |                                            | /fpu         |
    | Cortex-R8  |						  |		 |
    | (Hard FP)  |                                            |              |
    |------------|--------------------------------------------|--------------|
    | Cortex-A*  | [-mthumb] -march=armv7-a                   | armv7-ar     |
    | (No FP)    |                                            | /thumb       |
    |------------|--------------------------------------------|--------------|
    | Cortex-A*  | [-mthumb] -march=armv7-a -mfloat-abi=softfp| armv7-ar     |
    | (Soft FP)  | -mfpu=vfpv3-d16                            | /thumb       |
    |            |                                            | /softfp      |
    |------------|--------------------------------------------|--------------|
    | Cortex-A*  | [-mthumb] -march=armv7-a -mfloat-abi=hard  | armv7-ar     |
    | (Hard FP)  | -mfpu=vfpv3-d16                            | /thumb       |
    |            |                                            | /fpu         |
    --------------------------------------------------------------------------

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
