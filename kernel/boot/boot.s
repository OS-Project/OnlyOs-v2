.text
.code 32

.global _start
.global _estack
.global _sbss
.global _ebss

.equ  UND_STACK_SIZE, 0x8
.equ  ABT_STACK_SIZE, 0x8
.equ  FIQ_STACK_SIZE, 0x8
.equ  IRQ_STACK_SIZE, 0x100
.equ  SVC_STACK_SIZE, 0x30

.equ  MODE_UND, 0x1B
.equ  MODE_USR, 0x10
.equ  MODE_FIQ, 0x11
.equ  MODE_IRQ, 0x12
.equ  MODE_SVC, 0x13
.equ  MODE_ABT, 0x17
.equ  MODE_SYS, 0x1F

.equ FIQ_BIT, 0x40
.equ IRQ_BIT, 0x80


.include "interrupt.s"

.section ".text.boot"
.extern uart_printChar
.global _start
_start:

    // Disable irq and fiq.
    cpsid i
    cpsid f

    /* Init the stacks for each processor mode. */
	stack_init:
        // FIXME: full descending stack
		// Stack is empty descending.
		ldr r0, =_estack
    	msr cpsr_c, #MODE_UND | IRQ_BIT | FIQ_BIT
   		mov sp, r0
		sub r0, r0, #UND_STACK_SIZE

		msr cpsr_c, #MODE_SVC | IRQ_BIT | FIQ_BIT
    	mov sp, r0
		sub r0, r0, #SVC_STACK_SIZE

    	msr cpsr_c, #MODE_ABT | IRQ_BIT | FIQ_BIT
    	mov sp, r0
		sub r0, r0, #ABT_STACK_SIZE

    	msr cpsr_c, #MODE_IRQ | IRQ_BIT | FIQ_BIT
    	mov sp, r0
		sub r0, r0, #IRQ_STACK_SIZE

    	msr cpsr_c, #MODE_FIQ | IRQ_BIT | FIQ_BIT
    	mov sp, r0
		sub r0, r0, #FIQ_STACK_SIZE

    	// Kernel mode
    	msr cpsr_c, #MODE_SYS | IRQ_BIT | FIQ_BIT
    	mov sp, r0

    /* Init the .bss segment to zero. Required for C support. */
	bss_init:
        	ldr r0, =_sbss
        	ldr r1, =_ebss
        	cmp r0,r1

        	beq vector_init
        	mov r4, #0

		write_zero:
        		strb r4, [r0]
        		add r0, r0,#1
        		cmp r0, r1
			bne write_zero

    /* Vector table init. */
	vector_init:
		ldr r0,=vector_table
		mcr p15, #0, r0, c12, c0, #0

		add r1, r0, #4 // Points to undefined_handler call in the vector table

		ldr r0,=0x4030CE24 // p4913

		ldmia r1!, {r2-r8}
		stmia r0!, {r2-r8}

	call_main:
        mov r0, #'\n'
        bl uart_printChar

        ldr r0, =init_done
		bl uart_printStr

        mov r0, #'\n'
        bl uart_printChar

    halt:
        b halt

.section ".text"
.global dump_regs
/* Display on the uart a dump of all registers. */
dump_regs:
    // Preserve r0, r1
    mov r0, #'r'
    bl uart_printChar
    mov r0, #'0'
    bl uart_printChar
    mov r0, #':'
    bl uart_printChar
    // Recover r0
    mov pc, lr

.section ".rodata"
.align
init_done: .asciz "ABCDEF"
.int 0
