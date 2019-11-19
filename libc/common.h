// common.h -- Defines typedefs and some global functions.
//             From JamesM's kernel development tutorials.


#ifndef COMMON_H
#define COMMON_H
#include "../std/stdint.h"
#include "../drivers/cscreen.h"


typedef          int   s32int;
typedef unsigned short u16int;
typedef          short s16int;
typedef unsigned char  u8int;
typedef          char  s8int;


//void outb(u16int port, u8int value);
//u8int inb(u16int port);
//u16int inw(u16int port);

//Is this used?
//Should I eliminate this?
//I feel like this is important, but i don't fully underdstand and am Pretty mad about
#define PANIC(msg) panic(msg, __FILE__, __LINE__);
#define ASSERT(b) ((b) ? (void)0 : panic_assert(__FILE__, __LINE__, #b))

extern void panic(const char *message, const char *file, uint32_t line);
extern void panic_assert(const char *file, uint32_t line, const char *desc);

#endif // COMMON_H
