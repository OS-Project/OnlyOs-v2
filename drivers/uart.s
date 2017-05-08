.text
.code 32

.section ".text"
.global uart_printChar
uart_printChar:
    ldr r1, =0x44e09000 // UART0 base address. See memory map.
    strb r0, [r1]
    mov pc, lr
