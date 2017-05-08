.section ".text.vector_table"
.global vector_table
vector_table:
	b _start
	b undefined_handler // Undefined instruction
	b svc_handler
	b prefetch_handler // Prefetch abort
	b data_handler // Data abort
	nop
	b irq_handler
	nop // FIQ

.section ".text.interrupt_handler"
.global svc_asm_call
.extern INT_IRQ_handler

fiq_handler:
	mov r0, #77
	b kexit

irq_handler:
        // Done auto: spsr = cpsr. Ref: p456
        stmfd sp!, {r0-r12,lr} // Save registers
        mrs r11, spsr // Save context

        // r0 contains the interrupt id
        ldr r0, =0x48200040 // Ref: p183 (Interrupt controller), p470
        and r0, r0, #0b1111111 // Ref: p475

        // Branch table
	    ldr pc,=INT_IRQ_handler

        // Interrupt has been taken care of. Enable new interrupts
        mov r0, #0x1
        ldr r1, =0x48200048 // Ref: p457
        str r0, [r1]
        dsb // Data synchronization barrier. Ref: p458

        msr cpsr, r11 // Restore context
        ldmfd sp!, {r0-r12, lr} // Restore the saved registers from the stack
        subs pc, lr, #4
        // Done auto: cpsr = spsr; pc=lr. Ref: p458

prefetch_handler:
	mov r0, #33
	b kexit

data_handler:
	mov r0, #44
	b kexit

undefined_handler:
	mov r0, #11
	b kexit

/*
    Inspired from: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0203j/Cacdfeci.html
*/
svc_handler:
    .equ T_bit, 0x20 // TODO: add reference. Thumb bit 5 of cpsr/spsr.

	// Save registers. Since this is a intentional call, only save preserved registers (ABI)
	stmfd sp!, {r4-r11,lr} // Increment sp accordingly using '!'.

    // Save spsr
	mrs r4, spsr // Get spsr.
	stmfd sp!, {r4, r5} // Save spsr and an other register to keep a 8-byte aligned stack.

    // Get svc number just for fun
    stmfd sp!, {r0,r1} // Save argument of svc call. Add an other register to keep a 8-byte aligned stack.
    tst r0, #T_bit             // Occurred in Thumb state?
    ldrneh r0, [lr,#-2]        // Yes: Load halfword and...
    bicne r0, r0, #0xFF00      // ...extract comment field
    ldreq r0, [lr,#-4]         // No: Load word and...
    biceq r0, r0, #0xFF000000
    ldmfd sp!, {r0,r1} // Restore argument.

	// Call the handler. Return argument are in r0 and r1 according to ABI.
	//ldr pc,=INT_SVC_handler

    mov r0, #'a'
    bl uart_printChar

	// Restore spsr
	ldmfd sp!, {r4, r5}
	msr spsr, r4

    // Restore context
	ldmfd sp!, {r4-r11,lr}
    movs pc,lr // Exit the handler and return to code. See page A2-20 of the ARM Architecture Manual.

svc_asm_call:
	svc #0
	mov pc, lr
