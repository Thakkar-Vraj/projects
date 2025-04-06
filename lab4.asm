    .ORIG x3000
    
; Name: Vraj Thakkar
; Date: 11/12/2024
; Lab #4
;

; BLOCK 1
; Register R0 is loaded with m[x6000].
; This will serve as the pointer to the head node of the linked list.
;  

	LDI R1, PTR1


    BR  BLOCK2
PTR1    .FILL   x6000


    
    
; BLOCK 2
; 
; In this block you will prompt the user for the Building Abbreviation and Room Number 
; by printing on the monitor the string “Type the room to be reserved and press Enter: ” 
; and wait for the user to input a string followed by <Enter> (ASCII: x0A). 
; (Assume that there is no case where the user input exceeds the maximum number of characters).

BLOCK2  LEA R0, PROMPT
        PUTS
        
        LEA R0, USERINPUT
        LEA R4, USERINPUT
LOOP    GETC

; Check if the user inputs an Enter, whose ASCII code is x0A.
; If it is not Enter, then store the character at the reserved block of memory labeled USERINPUT
; The reserved block of memory is 11 locations (maximum of 10 characters, and null terminator).
; In this block you must also display each character that the user types.

    LD R2, CHECKENTER
    LD R5, PTRC
    ADD R3, R2, R0
    AND R3, R5, R3
    BRZ ENDLOOP
    STR R0, R4, #0
    ADD R4, R4, #1
    BR LOOP
    






        

ENDLOOP 
    LDI R1, PTR1
    BRZ BLOCK4
    BR BLOCK3
PROMPT  .STRINGZ    "Type the room to be reserved and press Enter: "  
USERINPUT   .BLKW   xB
CHECKENTER  .FILL X00F6
PTRC    .FILL XFEFF



; Block 3: In this block you will check if there is a match between the entered 
; user string with an entry in the linked list.
; Your program must search the list of currently available rooms to find a match for the 
; entered Building Abbreviation and Room Number. The list stores all the currently available rooms. 
; You will find a match only if the room is in the list. It is possible to not find a match in the list. 

; If your program finds a match, then it must print out “<Building Abbreviation and Room Number> 
; is currently available!” (eg., “GSB 2.126 is currently available!”)

; Note that if there is a match, it must branch to DONE.
; If there is no match, it must branch to BLOCK4
BLOCK3
    LDR R6, R1, #1
    LEA R4, USERINPUT
COMPARELOOP
    LDR R5, R4, #0
    BRZ MATCH
    LDR R7, R6, #0
    ADD R4, R4, #1
    ADD R6, R6, #1
    NOT R5, R5
    ADD R5, R5, #1
    ADD R7, R7, R5
    BRZ COMPARELOOP
    LDR R1, R1, #0
    BRZ BLOCK4
    BR BLOCK3





MATCH
    LEA R4, USERINPUT
PRINTLOOP
    LDR R0, R4, #0
    BRZ PRINTSTRING
    OUT
    ADD R4, R4, #1
    BR PRINTLOOP
PRINTSTRING    
    LEA R0, MATCHLIST
    PUTS
    BR DONE
    









        
MATCHLIST  .STRINGZ    " is currently available!"

; Block 4: You will enter this block only if there was no match with the linked list. 
; In this block you must print out “<Building Abbreviation and Room Number> is NOT currently available.” 
; (eg., “GSB 2.126 is NOT currently available.”).
;

BLOCK4
    LEA R4, USERINPUT
PRINTLOOP2
    LDR R0, R4, #0
    BRZ PRINTSTRING2
    OUT
    ADD R4, R4, #1
    BR PRINTLOOP2
PRINTSTRING2
    LEA R0, NOMATCHTLIST
    PUTS


















NOMATCHTLIST  .STRINGZ    " is NOT currently available."








DONE    HALT
    

    .END

