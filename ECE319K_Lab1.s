//****************** ECE319K_Lab1.s ***************
// Your solution to Lab 1 in assembly code
// Author: Vraj Thakkar
// Last Modified: 01/24/2025
// Spring 2025
        .data
        .align 2
// Declare global variables here if needed
// with the .space assembly directive

        .text
        .thumb
        .align 2
        .global EID
EID:    .string "VST362" // replace ZZZ123 with your EID here

        .global Phase
        .align 2
Phase:  .long 10 
// Phase= 0 will display your objective and some of the test cases, 
// Phase= 1 to 5 will run one test case (the ones you have been given)
// Phase= 6 to 7 will run one test case (the inputs you have not been given)
// Phase=10 will run the grader (all cases 1 to 7)
        .global Lab1
// Input: R0 points to the list
// Return: R0 as specified in Lab 1 assignment and terminal window
// According to AAPCS, you must save/restore R4-R7
// If your function calls another function, you must save/restore LR
Lab1: PUSH {R4-R7,LR}
       // your solution goes here
       LDR R1, =0
       LDR R2, =EID
       LDRB R4, [R2]
outerloop: 
       LDR R2, =EID
       LDR R3,[R0]
       CMP R3, R1
       BEQ done
innerloop:
       LDRB R4, [R2]
       CMP R4, R1
       BEQ found
       LDRB R5, [R3]
       CMP R4, R5
       BNE notsame
       ADDS R2, #1
       ADDS R3, #1
       B innerloop
notsame:
       ADDS R0, #8
       B outerloop

found:
        ADDS R0, #4
        LDR R0, [R0]
        B EndLab1



done:
        MOVS R0, #0
        SUBS R0, #1
        B EndLab1





myEID:  .long EID
EndLab1:
      POP  {R4-R7,PC} // return


        .align 2
        .global myClass
myClass: .long pAB123  // pointer to EID
         .long 95      // Score
         .long pXYZ1   // pointer to EID
         .long 96      // Score
         .long pAB5549 // pointer to EID
         .long 94      // Score
         .long 0       // null pointer means end of list
         .long 0
pAB123:  .string "AB123"
pXYZ1:   .string "XYZ1"
pAB5549: .string "AB5549"

        .end
