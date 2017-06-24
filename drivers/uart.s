.text
.code 32

.equ UART0, 0x44e09000 // UART0 base address. See the processor technical reference manual at section 2.1 (memory map).


.section ".text"
.global uart_printChar
/* r0 should contain the char to send. */
uart_printChar:
    ldr r1, =UART0
    strb r0, [r1]
    mov pc, lr

.global uart_printStr
/*
uart_printStr:
    addr .req r3
    byte_index .req r2
    cur_byte .req r1
    data .req r0

    mov addr, data
    ldr data, [addr]

    and cur_byte, data, #0xff
    cmp cur_byte, #0
    beq zz
    mov r4, data
    mov data, cur_byte
    bl uart_printChar
    mov data, r4

    lsr data, data, #8 // Proceed to the next char (8 bits)
    and cur_byte, data, #0xff
    cmp cur_byte, #0
    beq zz
    mov r4, data
    mov data, cur_byte
    bl uart_printChar
    mov data, r4

    lsr data, data, #8 // Proceed to the next char (8 bits)
    and cur_byte, data, #0xff
    cmp cur_byte, #0
    beq zz
    mov r4, data
    mov data, cur_byte
    bl uart_printChar
    mov data, r4

    lsr data, data, #8 // Proceed to the next char (8 bits)
    and cur_byte, data, #0xff
    cmp cur_byte, #0

    bne nz

    zz:
    mov r0, #'0'
    bl uart_printChar
    mov pc, lr

    nz:
    mov r0, #'1'
    bl uart_printChar

    mov pc,lr
*/


/* r0 should contain the address of the string. Stops when it encounters 0x00 in the string. */
/*
uart_printStr:
    addr .req r3
    byte_index .req r2
    cur_byte .req r1
    data .req r0

    mov addr, data

    ldr data, [addr]
    mov byte_index, #0

    write_char:
        // Check for end of string
        and cur_byte, data, #0xff
        cmp cur_byte, #0 // Letters are not displayed. If cmp data, #0, no letter disappears. Check little/big endian
        beq end

        mov r4, data
        //mov data, cur_byte
        bl uart_printChar // r0 already contains the data

        mov data, r4
        lsr data, data, #8 // Proceed to the next char (8 bits)
        add byte_index, byte_index, #1
        cmp byte_index, #4 // End of current word?

        bne write_char

        add addr, addr, #4 // If current word completely processed, proceed to the next one
        mov byte_index, #0 // Reset counter
        ldr data, [addr] // Update current word

        b write_char


    end:
        .unreq addr
        .unreq byte_index
        .unreq cur_byte
        .unreq data
        mov pc, lr
*/

uart_printStr:
    addr .req r1
    data .req r0

    mov addr, data

    write_char:
        ldrb data, [addr], #1

        // Check for end of string
        cmp data, #0
        beq end
        //add data, data, #0x20
        bl uart_printChar // r0 already contains the data
        b write_char

    end:
        .unreq addr
        .unreq data
        mov pc, lr
