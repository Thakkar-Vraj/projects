//****************** ECE319K_Lab2.s ***************
// Your solution to Lab 2 in assembly code
// Author: Vraj Thakkar
// Last Modified: 01/29/2025
// ECE319K Spring 2025 (ECE319H students do Lab2H)
// I/O port addresses
    .include "../inc/msp.s"

        .data
        .align 2
// Declare global variables here if needed
// with the .space assembly directive


        .text
        .thumb
        .align 2
        .global EID
EID:    .string "VST362" // replace ZZZ123 with your EID here
        .align 2

// this allow your Lab2 programs to the Lab2 grader
        .global Lab2Grader
// this allow the Lab2 grader to call your Lab2 program
        .global Lab2
// these two allow your Lab2 programs to all your Lab3 solutions
        .global Debug_Init
        .global Dump

// Switch input: PB2 PB1 or PB0, depending on EID
// LED output:   PB18 PB17 or PB16, depending on EID
// logic analyzer pins PB18 PB17 PB16 PB2 PB1 PB0
// analog scope pin PB20
Lab2:
// Initially the main program will
//   set bus clock at 80 MHz,
//   reset and power enable both Port A and Port B
// Lab2Grader will
//   configure interrupts  on TIMERG0 for grader or TIMERG7 for TExaS
//   initialize ADC0 PB20 for scope,
//   initialize UART0 for grader or TExaS
     MOVS R0,#3
// 0 for info,
// 1 debug with logic analyzer,
// 2 debug with scope,
// 3 debug without scope or logic analyzer
// 10 for grade
     BL   Lab2Grader

        BL   Debug_Init // your Lab3 (ignore this line while doing Lab 2)
        BL   Lab2Init


// make switch an input, LED an output
// PortB is already reset and powered
// Set IOMUX for your input and output
// Set GPIOB_DOE31_0 for your output (be friendly)
Lab2Init:
// ***do not reset/power Port A or Port B, already done****
LDR R1, =IOMUXPB3
     LDR R2, =0x00040081
     LDR R3, [R1]
     ORRS R2, R2, R3
     STR R2, [R1]
     LDR R1, =IOMUXPB16
     LDR R2, =0x00000081
     LDR R3, [R1]
     ORRS R2, R2, R3
     STR R2, [R1]
     LDR R1, =GPIOB_DOE31_0
     LDR R2, =0x00010000
     LDR R3, [R1]
     ORRS R2, R2, R3
     STR R2, [R1]


loop1:
     LDR R4, =1280000
     BL Delay
     BL LEDON
     LDR R4, =320000
     BL Dump
     BL Delay
     BL LEDOFF
     BL Dump
     BL CheckSwitch
     CMP R4, #1
     BEQ loop2
     B    loop1

loop2:
     LDR R4, =960000
     BL Delay
     BL LEDON
     LDR R4, =640000
     BL Dump
     BL Delay
     BL LEDOFF
     BL Dump
     BL CheckSwitch
     CMP R4, #1
     BEQ loop3
     B    loop2

loop3:
     LDR R4, =480000
     BL Delay
     BL LEDON
     LDR R4, =1120000
     BL Dump
     BL Delay
     BL LEDOFF
     BL Dump
     BL CheckSwitch
     CMP R4, #1
     BEQ loop4
     B    loop3

loop4:
     LDR R4, =320000
     BL Delay
     BL LEDON
     LDR R4, =1280000
     BL Dump
     BL Delay
     BL LEDOFF
     BL Dump
     BL CheckSwitch
     CMP R4, #1
     BEQ loop1
     B    loop4

CheckSwitch:
     LDR R4, =GPIOB_DIN31_0
     LDR R1, [R4]
     LDR R2, =0x08
     ANDS R1, R1, R2
     LSRS R4, R1, #3
     BX LR

Delay:
       SUBS R4,R4,#2
dloop: SUBS R4,R4,#4 
       NOP
       BHS  dloop
       BX   LR

LEDON:
     LDR R1, =GPIOB_DOUT31_0
     LDR R3, [R1]
     LDR R2, =0x00010000
     ORRS R2, R2, R3
     STR R2, [R1]
     BX LR


LEDOFF:
     LDR R1, =GPIOB_DOUT31_0
     LDR R3, [R1]
     LDR R2, =0x00010000
     BICS R2, R2, R3
     STR R2, [R1]
     BX LR

        BL   Debug_Init // your Lab3 (ignore this line while doing Lab 2)
        BL   Lab2Init

   BX   LR



   .end
