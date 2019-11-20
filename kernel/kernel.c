#include "../cpu/isr.h"
#include "kernel.h"
#include "../libc/string.h"
#include "../libc/mem.h"
#include "../drivers/cscreen.h"
#include <stdint.h>
#include "../memory/kheap.h"
#include "../memory/paging.h"

void main() {
    isr_install();
    irq_install();
	//non maskable exception
	//breakpoint exception3
    asm("int $2");  
    asm("int $3");  //Interrupt Handler should throw a message for us to see

    _cscreen();

	

    _prints("Type something, it will go through the kernel\n"
        "Type END to halt the CPU or PAGE to request a kmalloc()\n> ");
	

  		
    _prints("Hello, Page init end here\n");
	_prints("Page init starts here");
   // initialise_paging();  
   //uint32_t *ptr = (uint32_t*)0xA0000000;
   // uint32_t do_page_fault = *ptr;


}

void user_input(char *input) {
    // if (strcmp(input, "END") == 0) {
    //     _prints("Stopping the CPU. Bye!\n");
    //     asm volatile("hlt");
    // } else if (strcmp(input, "PAGE") == 0) {
    //     /* Lesson 22: Code to test kmalloc, the rest is unchanged */
    //      uint32_t phys_addr;
    //      //Is this throwing an error?
    //      uint32_t page = kmalloc_int(1000, 1, &phys_addr);
    //      char page_str[16] = "";
    //      hex_to_ascii(page, page_str);
    //      char phys_str[16] = "";
    //      hex_to_ascii(phys_addr, phys_str);
    //     _prints("Page: ");
    //     _prints(page_str);
    //     _prints(", physical address: ");
    //     _prints(phys_str);
    //     _prints("\n");
    // }
    _prints("You said: ");
    _prints(input);
    _prints("\n> ");
}
