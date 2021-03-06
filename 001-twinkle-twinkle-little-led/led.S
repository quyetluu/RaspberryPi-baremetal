/* Copyright (C) 2015 Goswin von Brederlow <goswin-v-b@web.de>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

/* Turn the activity LED repeadetly on and off forever
 *----------------------------------------------------------------
 * This is about the simplest example to give using just 48 bytes.
 * The code assumes the LED is already configured by the firmware,
 * which is the case so far. You can see it blink briefly when you
 * power on when the firmware initializes it. If you don't see the
 * later examples for how to fully configure it.
 */

#ifndef MODEL
#error MODEL not defined
#endif

#if MODEL == 0
#define PERIPHERAL_BASE 0x20000000 // Raspberry Pi Peripheral Base Address
#define GPBASE            0x200000 // $20200000
#define GPSETx                0x1C // $2020001C GPSET0
#define GPCLRx                0x28 // $20200028 GPCLR0
#define PIN                     16 // LED is connected to pin 16
#endif

#if MODEL == 1
#define PERIPHERAL_BASE 0x20000000 // Raspberry Pi B+ Peripheral Base Address
#define GPBASE            0x200000 // $20200000
#define GPSETx                0x20 // $20200020 GPSET1
#define GPCLRx                0x2C // $2020002C GPCLR1
#define PIN                     15 // LED is connected to pin 47 (32 + 15)
#endif

#if MODEL == 2
#define PERIPHERAL_BASE 0x3F000000 // Raspberry Pi 2 Peripheral Base Address
#define GPBASE            0x200000 // $3F200000
#define GPSETx                0x20 // $3F200020 GPSET1
#define GPCLRx                0x2C // $3F20002C GPCLR1
#define PIN                     15 // LED is connected to pin 47 (32 + 15)
#endif

#ifndef PERIPHERAL_BASE
#error MODEL must be one of 0 (RPi), 1 (RPi b+) or 2 (RPi 2)
#endif

.global _start

_start:
	mov r0,#PERIPHERAL_BASE
	orr r0,#GPBASE		// R0 = PERIPHERAL_BASE + GPBASE

	mov r2,#1<<PIN		// bit for the LED pin
Loop:
	str r2,[r0,#GPSETx]	// set bit

	mov r1,#0x100000	// wait a while
WaitA:
	subs r1,#1
	bne WaitA

	str r2,[r0,#GPCLRx]	// clear bit
	
	mov r1,#0x100000	// wait a while
WaitB:
	subs r1,#1
	bne WaitB

	b Loop			// again and again
