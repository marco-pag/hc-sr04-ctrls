/*
 * Simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "sleep.h"
#include "xil_printf.h"

#define HC_BASE_ADDR    (0x43C00000)
#define HC_CTRL         (*(volatile unsigned int *)(HC_BASE_ADDR))
#define HC_DIST         (*(volatile unsigned int *)(HC_BASE_ADDR + 0x4))

int main()
{
    unsigned int dist_cm;

    init_platform();

    xil_printf("Start\n\r");

    HC_CTRL = 1U;

    while (1) {
        dist_cm = HC_DIST;
        xil_printf("Distance: %u mm\n\r", dist_cm);

        usleep(100 * 1000);
    }

    cleanup_platform();
    
    return 0;
}

