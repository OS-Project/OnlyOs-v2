.text
.code 32

.equ UART0, 0x44e09000 // UART0 base address. See memory map.


.section ".text"
.global uart_printChar
/* r0 should contain the char to send. */
uart_printChar:
    ldr r1, =UART0
    strb r0, [r1]
    mov pc, lr

.global uart_printStr
/* r0 should contain the address of the string. Stops when encountering 0x00 in the string. */
uart_printStr:
    str_addr .req r3
    mov str_addr, r0

    byte_counter .req r2
    current_dw .req r1
    current_byte .req r0

    b new_dw

    new_dw:
        mov byte_counter, #0
        ldr current_dw, [str_addr]
        and current_byte, current_dw, #0xff // Keep 1 byte
        cmp current_byte, #0
        beq end

    write:
        bl uart_printChar

        // Each char has been dealt with. Proceed to next memory cell.
        cmp byte_counter, #3
        beq new_dw

        lsr current_dw, current_dw, #8
        add byte_counter, byte_counter, #1
        and current_byte, current_dw, #0xff // Keep 1 byte

        cmp current_byte, #0
        bne write

    end:
        .unreq str_addr
        .unreq byte_counter
        .unreq current_dw
        .unreq current_byte
        mov pc, lr
