/*
#include "drivers/uart/uart.h"
#include "kernel/config.h"
#include "kernel/interrupt/interrupt.h"
*/

void INT_SVC_handler(int r0, int r1, int r2, int r3)
{
    /*
    #ifdef DEBUG
        kprintf("SVC interrupt detected\n");
        kprintf("SVC arguments: r0=%x, r1=%x, r2=%x, r3=%x\n", r0, r1, r2, r3);
    #endif
	switch (r0)
	{
		case 0:
			switch(r1)
			{
				default:
					kprintf("SVC error: error number unknown.\n");
					break;
			}
			break;

		case 100:
			UART_putc(r1);
			break;

		default:
			kprintf("Unknown SVC call\n");
			break;
	}
    */
}

void INT_SVC_call(int r0, int r1, int r2, int r3)
{
	//svc_asm_call(r0, r1, r2, r3);
}

void INT_IRQ_handler()
{
    /*
	#ifdef DEBUG
		kprintf("IRQ interrupt detected\n");
	#endif
	int * INTC_SIR_IRQ = (int *)(0x48200040);
	char activeIRQ = *(INTC_SIR_IRQ) & 0x7F;
	kprintf("IRQ number: %d\n", activeIRQ);


	switch (activeIRQ)
	{
		default:
			kprintf("Unknown IRQ identifier! \n");
	}
    */
}
