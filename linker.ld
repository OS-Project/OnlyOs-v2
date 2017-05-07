OUTPUT_ARCH(arm)
ENTRY(_start)	/* Entry point of the program */

SYS_STACK_SIZE = 0x100000; /* 1M */
C_STACK_SIZE = 0x100000; /* 1M */
SVC_STACK_SIZE = 0x100000; /* 1M */
IRQ_STACK_SIZE = 1024;

MEMORY
{
    CODE (rwx) : ORIGIN = 0x80000000, LENGTH = 50M
    HEAP (rw) : ORIGIN = ORIGIN(CODE) + LENGTH(CODE), LENGTH = 100M
    STACK (rw) : ORIGIN = ORIGIN(HEAP) + LENGTH(HEAP), LENGTH = 50M
}


SECTIONS
{
    . = ORIGIN(CODE);
    .text :
    {
        _stext = .;
        *(.text.vector_table)
        *(.text.interrupt_handler)
        *(.text.boot)
        *(.text)
        _etext = .;
    } > CODE

    .rodata :
    {
        _srodata = .;
        *(.rodata)
        _erodata = .;
    } > CODE

    .data :
    {
        _sdata = .;
        *(.data)
        _edata = .;
    } > CODE

    .bss :
    {
        _sbss = .;
        *(.bss)
        _ebss = .;
    } > CODE

    .heap :
    {
        _sheap = .;
        . += LENGTH(HEAP);
        _eheap = .;
    } > HEAP

    .stack :
    {
        _sstack = .;
        . += LENGTH(STACK);
        _estack = .;
    } > STACK
}
