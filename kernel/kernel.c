int kmain();
int kinit();
void kexit();

int kmain()
{
   	kinit();
    kexit(0);
}


int kinit()
{
    //dinit(true);
    //kprintf("[INIT] ### Drivers initialisation done\n");
    //kprintf("[INIT] ### Start memory initilisation\n");
    return 0;
}


void kexit(int err_num)
{
	// Disable irq
	//__asm__("cpsid i");
    /*
	switch (err_num)
	{
		case EXIT_SUCCESS:
			kprintf("Kernel exited without error\n");
			break;

		case 11:
			kprintf("Undefined instruction exception happened but it is not implemented\n");
			break;

		case 33:
			kprintf("Prefetch abort exception happened but it is not implemented\n");
			break;

		case 44:
			kprintf("Data abort exception happened but it is not implemented\n");
			break;

		case 77:
			kprintf("FIQ happened but it is not implemented\n");
			break;

		default:
			kprintf("Kernel exited with error : %d\n", err_num);
	}
	while(1);
    */
}
