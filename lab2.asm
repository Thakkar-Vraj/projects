    .ORIG x3000
    
; Name: Vraj
; Date: Thakkar
; Lab #2
;

; BLOCK 1
; Register R0 is loaded with x7500.
; Register R1 is loaded with the address of the location where the number is located.
; 

	LD R0,PTR
	LDR R1,R0, #0
; 
; The two 8-bit numbers are now loaded into R1.

    LDR R1, R1, #0

    
    
; BLOCK 2
; In this block, the two unsigned numbers in bits [15:8] and [7:0] on register R1, are first isolated by using masks.
; Mask1 is loaded into R4. The mask is then used to isolate Number 1, which is then loaded into R2.
; Mask2 is loaded into R4. The mask is then used to isolate Number 2, which is then loaded into R3.
; 
; 
	LD R4, MASK1
	AND R2, R1, R4





	LD R4, MASK2	
    AND R3, R1, R4








; BLOCK 3
; In this block Number 2 is rotated so that the bits are in R3[7:0].

    LD R4 CHECKBIT1
    LD R6 VALUE1
    LD R5 VALUE1
    LD R7 ADD4
BIT1 
    AND R5, R3, R4
    BRZ IFZERO
    LD R4 CHECKBIT2
    AND R5, R5, X0000
    ADD R6, R6, R7
    LD R7 ADD3
    BRNP BIT2
IFZERO 
    AND R5, R5, X0000
    LD R4 CHECKBIT2
    LD R7 ADD3
BIT2 
    AND R5, R3, R4
    BRZ IFZERO2
    LD R4 CHECKBIT3
    AND R5, R5, X0000
    ADD R6, R6, R7
    LD R7 ADD2
    BRNP BIT3
IFZERO2 
    LD R4 CHECKBIT3
    AND R5, R5, X0000
    LD R7 ADD2
BIT3 
    AND R5, R3, R4
    BRZ IFZERO3
    LD R4 CHECKBIT4
    AND R5, R5, X0000
    ADD R6, R6, R7
    LD R7 ADD1
    BRNP BIT4
IFZERO3
    LD R4 CHECKBIT4
    AND R5, R5, X0000
    LD R7 ADD1
BIT4
    AND R5, R3, R4
    BRZ IFZERO4
    LD R4 CHECKBIT5
    AND R5, R5, X0000
    ADD R6, R6, R7
    BRNP BIT5
IFZERO4 
    LD R4 CHECKBIT5
    AND R5, R5, X0000
BIT5 
    AND R5, R3, R4
    BRZ IFZERO5
    LD R4 CHECKBIT6
    AND R5, R5, X0000
    ADD R6, R6, #8
    BRNP BIT6
IFZERO5
    LD R4 CHECKBIT6
    AND R5, R5, X0000
BIT6 
    AND R5, R3, R4
    BRZ IFZERO6
    LD R4 CHECKBIT7
    AND R5, R5, X0000
    ADD R6, R6, #4
    BRNP BIT7
IFZERO6 
    LD R4 CHECKBIT7
    AND R5, R5, X0000
BIT7 
    AND R5, R3, R4
    BRZ IFZERO7
    LD R4 CHECKBIT8
    AND R5, R5, X0000
    ADD R6, R6, #2
    BRNP BIT8
IFZERO7 
    LD R4 CHECKBIT8
    AND R5, R5, X0000
BIT8 
    AND R5, R3, R4
    BRZ IFZERO8
    AND R5, R5, X0000
    ADD R6, R6, #1
    BRNP STORENUM2
IFZERO8
    
STORENUM2
    AND R3, R3, x0
    ADD, R3, R3, R6





; BLOCK 4
; The numbers are added. The result is stored at the location whose address is in x750A.

    LD R5, ENDLOCATION
    LDR R1, R5 #0
    ADD R2, R2, R3
    STR R2, R1, #0











    HALT
    
    
PTR     .FILL   x7500
MASK1	.FILL	x00FF
MASK2	.FILL	xFF00
ENDLOCATION .FILL X750A
CHECKBIT1    .FILL X8000
CHECKBIT2   .FILL X4000
CHECKBIT3   .FILL X2000
CHECKBIT4   .FILL X1000
CHECKBIT5   .FILL X0800
CHECKBIT6   .FILL X0400
CHECKBIT7   .FILL X0200
CHECKBIT8   .FILL X0100
VALUE1  .FILL X0000
ADD1    .FILL X0010
ADD2    .FILL X0020
ADD3    .FILL X0040
ADD4    .FILL X0080
    .END

