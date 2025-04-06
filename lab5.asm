; Name: Vraj Thakkar
; Date: 11/19/24
; Lab #5
;


; BLOCK 1
; OPERATING SYSTEM CODE

.ORIG x500
        
        LD R0, VEC  ; VEC contains x1080 which is the address in the interrupt vector table that needs to contains the startung address of the ISR.
        LD R1, ISR  ; ISR contains the starting address of the ISR.
        ; (1) Initialize interrupt vector table with the starting address of ISR.
        STR R1, R0, #0


        ; (2) Set bit 14 of KBSR. [To Enable Interrupt]
        LD  R2, MASK
        LDI R3, KBSRPTR
        
        NOT R3, R3
        AND R3, R2, R3
        NOT R3, R3
        
        STI R3, KBSRPTR
        
    

        ; (3) Set up system stack to enter user space. So that PC can return to the main user program at x3000.
	      ;     R6 is the Stack Pointer. Remember to Push PC and PSR in the right order. Hint: Refer State Graph
        LD  R3, PSR
        LD  R4, PC
        LD  R6, PC
        
        ADD R6, R6, #-1
        STR R3, R6, #0
        ADD R6, R6, #-1
        STR R4, R6, #0
        
        
        ; (4) Enter user Program.
        RTI
        
VEC     	.FILL x0180
ISR     	.FILL x1700
KBSRPTR		.FILL xFE00
MASK    	.FILL xBFFF
PSR     	.FILL x8002
PC      	.FILL x3000
ENABLEBIT   	.FILL   x4000

.END


; BLOCK 2
; INTERRUPT SERVICE ROUTINE

.ORIG x1700

; Callee save

ST R0, SAVER0
ST R1, SAVER1
ST R2, SAVER2
ST R3, SAVER3
ST R7, SAVER7

; CHECK THE KIND OF CHARACTER TYPED AND PRINT THE APPROPRIATE PROMPT

    LDI R0, KBDR
    
LOOP1
    LDI R1, DSR
    BRZP    LOOP1
    STI R0, DDR
    
CHECKLCX
    LD R5, ASCII_LCX
    ADD R2, R0, R5
    BRNP CHECKUCX
    LEA R4, STRING4
    BR PUTSMYWAYX

CHECKUCX
    LD R5, ASCII_UCX
    ADD R2, R0, R5
    BRNP CHECKZERO
    LEA R4, STRING4
    BR PUTSMYWAYX
CHECKZERO
    LD R5, ASCII_NUM1
    ADD R2, R0, R5
    BRZP CHECKNINE
    LEA R4, STRING3
    BR PUTSMYWAY
CHECKNINE
    LD R5, ASCII_NUM2
    ADD R2, R0, R5
    BRP CHECKUCA
    LEA R4, STRING2
    BR PUTSMYWAY

CHECKUCA
    LD R5, ASCII_UC1
    ADD R2, R0, R5
    BRZP CHECKUCZ
    LEA R4, STRING3
    BR PUTSMYWAY

CHECKUCZ
    LD R5, ASCII_UC2
    ADD R2, R0, R5
    BRP CHECKLCA
    LEA R4, STRING1
    BR PUTSMYWAY  

CHECKLCA
    LD R5, ASCII_LC1
    ADD R2, R0, R5
    BRZP CHECKLCZ
    LEA R4, STRING3
    BR PUTSMYWAY

CHECKLCZ
    LD R5, ASCII_LC2
    ADD R2, R0, R5
    BRP ERROR
    LEA R4, STRING1
    BR PUTSMYWAY

ERROR
    LEA R4, STRING3
    BR PUTSMYWAY
    
    
PUTSMYWAY
    LDI R5 DSR
    BRZP PUTSMYWAY
    LDR R5, R4, #0
    BRZ end
    STI R5, DDR
    ADD R4, R4, #1
    BR PUTSMYWAY
PUTSMYWAYX
    LDI R5 DSR
    BRZP PUTSMYWAYX
    LDR R5, R4, #0
    BRZ ENDHALT
    STI R5, DDR
    ADD R4, R4, #1
    BR PUTSMYWAYX
      
ENDHALT
    HALT
    
GETOUT
    RTI
    
end LD R0, SAVER0
    LD R1, SAVER1
    LD R2, SAVER2
    LD R3, SAVER3 
    LD R7, SAVER7
    RTI



ASCII_NUM1 .FILL x-30
ASCII_LC1  .FILL x-61
ASCII_UC1  .FILL x-41

KBSR2 .FILL xFE00
KBDR  .FILL xFE02
DSR   .FILL xFE04
DDR   .FILL xFE06

SAVER0 .BLKW x1
SAVER1 .BLKW x1
SAVER2 .BLKW x1
SAVER3 .BLKW x1
SAVER7 .BLKW x1

STRING1 .STRINGZ "\nUser has entered a letter of the alphabet!\n"
STRING2 .STRINGZ "\nUser has entered a decimal digit!\n"
STRING3 .STRINGZ "\nERROR: User input is invalid!\n"
STRING4 .STRINGZ "\n---------- User has Exit the Program ----------\n"

ASCII_LCX   .FILL X-78
ASCII_UCX   .FILL X-58
ASCII_NUM2  .FILL X-39
ASCII_UC2   .FILL X-5A
ASCII_LC2   .FILL X-7A
.END




; BLOCK 3
; USER PROGRAM

.ORIG x3000

UPPER_LOOP  LEA R0, MESSAGE
            PUTS
            LD  R1, COUNT
            
LOOP_MAIN   ADD R1, R1, #-1
            BRP LOOP_MAIN
            LD R1, COUNT
LOOP_MAIN2
            ADD R1, R1, #-1
            BRP LOOP_MAIN2
            LD R1, COUNT
LOOP_MAIN3
            ADD R1, R1, #-1
            BRNP LOOP_MAIN3
            BR UPPER_LOOP
            
            
            
            

; MAIN USER PROGRAM
; PRINT THE MESSAGE "Enter a character…" WITH A DELAY LOGIC





COUNT .FILL xFFFF
MESSAGE .STRINGZ  "Enter a character…\n"
.END