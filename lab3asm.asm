    .ORIG x3000
    
; Name: Akshay Karthik
; Date: 10/27/2024
; Lab #3
;
;

; BLOCK 1
; Register R0 is loaded with x4000, which will serve as a pointer to the numbers.
;  

	LD R0,PTR
	ADD R1, R0, #1
	
    
; BLOCK 2
; This is the code that sorts in ascending order.
; You can break up this block into sub-blocks.
; 
    BLOCK2LOOP
    LDR R2, R0, #0
    LD R4, MASK
    AND R5, R2, R4
    
    BRZ FIRSTZERO
    BLOCKZEROLOOP
    LDR R2, R0, #0
    LDR R3, R1, #0
    LD R4, MASK
    AND R5, R3, R4
    
    BRZ SECONDZERO
    JSR COMPARE
    ADD R4, R4, #0
    BRP SWAP
    ADD R1, R1, #1
    
    BR BLOCKZEROLOOP
    
    SECONDZERO
    ADD R0, R0, #1
    ADD R1, R0, #1
    BR BLOCK2LOOP
    
    SWAP
    STR R2, R1, #0
    STR R3, R0, #0
    ADD R1, R1, #1
    BR BLOCKZEROLOOP
    
    FIRSTZERO
    HALT
    
    COMPARE
    ST R2, R_2
    ST R3, R_3
    ST R5, R_5
    ST R6, R_6
    ST R7, R_7
    LD R4, MASK2
    AND R5, R2, R4
    AND R6, R3, R4
    ADD R4, R5, #0
    
    JSR ROTATE
    ADD R5, R4, #0
    ADD R4, R6, #0
    JSR ROTATE
    ADD R6, R4, #0
    
    NOT R5, R5 
    ADD R5, R5, #1
    ADD R5, R5, R6
    
    BRP END
    AND R4, R4, #0
    ADD, R4, R4, #1
    BR LOADREGST 
    
    END
    AND R4, R4, #0
    BR LOADREGST 
    
    LOADREGST 
    LD R2, R_2
    LD R3, R_3
    LD R5, R_5
    LD R6, R_6
    LD R7, R_7
    
    RET
    
    ROTATE
    ST R1, R_1

;BLOCK 3
;In this block Number 2 is rotated so that the bits are in R3[7:0].
;
    AND R1, R1, #0 ; Reset the bits to zero
    ADD R1, R1, #8 ; Set to 8 because you are rotating the bit 8 times. It serves as a counter.
    
    LOOP
    BRZ NEWBLOCK ; If the R4 or Counter equals zero then rotate to a new block
    ADD R4, R4, #0
    
    BRN NEGATIVENUM ;Negative Branch Negative Number
    
    ADD R4, R4, R4 ; Add R3 to itself to help with the rotation of the bits
    ADD R1, R1, #-1 ; Make sure the counter decreases by negative one
    BR LOOP ; Branch Loop
    
    NEGATIVENUM
    ADD R4, R4, R4
    ADD R4, R4, #1
    ADD R1, R1 #-1
    
    BR LOOP
	NEWBLOCK
	LD R1, R_1
	
	RET

    HALT
    
    
PTR .FILL x4000
MASK .FILL x00FF
MASK2 .FILL xFF00
R_1     .FILL   x0000
R_2     .FILL   x0000
R_3     .FILL   x0000
R_5     .FILL   x0000
R_6     .FILL   x0000
R_7     .FILL   x0000

    .END
    
;.ORIG x4000

;.FILL x6A07
;.FILL x445C
;.FILL x1848
;.FILL x282A
;.FILL x370D
;.FILL x4808
;.FILL x6923
;.FILL x5441
;.FILL x441C
;.FILL x0000

;.END