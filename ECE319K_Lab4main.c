/* ECE319K_Lab4main.c
 * Traffic light FSM
 * ECE319H students must use pointers for next state
 * ECE319K students can use indices or pointers for next state
 * Put your names here or look silly Vraj Thakkar, Alan Schwartz
  */
#include <ti/devices/msp/msp.h>
#include "../inc/LaunchPad.h"
#include "../inc/Clock.h"
#include "../inc/UART.h"
#include "../inc/Timer.h"
#include "../inc/Dump.h"  // student's Lab 3
#include "ti/devices/msp/m0p/mspm0g350x.h"
#include <stdio.h>
#include <string.h>
#define goSouth 1
#define goWest 0
#define waitWestForSouth 2
#define waitSouthForWalk 3
#define goWalk 4
#define offWalk 5
#define duringWalk1 6
#define allRedForSouth 7
#define duringWalk2 8
#define duringWalk3 9
#define duringWalk4 10
#define allRedForWest 11
#define waitWestForWalk 12
#define waitSouthForWest 13 
  struct state{
    uint32_t westbit;
    uint32_t southbit;
    uint32_t walkbit;
    uint32_t delay;
    uint32_t nextState[8];
  };
  typedef struct state state_t;
  state_t FSM[14] = {
  // goWest state
  {1, 4, 16, 200, {goWest, goWest, waitWestForSouth, waitWestForSouth, waitWestForWalk, waitWestForWalk, waitWestForSouth, waitWestForSouth}},
  
  // goSouth state
  {4, 1, 16, 200, {goSouth, waitSouthForWest, goSouth, waitSouthForWest, waitSouthForWalk, waitSouthForWalk, waitSouthForWalk, waitSouthForWalk}},
  
  // waitWestForSouth state
  {2, 2, 16, 50, {allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth}},
  
  // waitSouthForWalk state
  {2, 2, 16, 50, {goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk}},
  
  // goWalk state
  {4, 4, 1, 50, {duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1}},
  
  // offWalk state
  {4, 4, 16, 200, {offWalk, allRedForWest, allRedForSouth, allRedForWest, goWalk, allRedForWest, allRedForSouth, allRedForWest}},
  
  // duringWalk1 state
  {4, 4, 16, 50, {duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2}},
  
  // allRedForSouth state
  {4, 4, 16, 50, {goSouth, goSouth, goSouth, goSouth, goSouth, goSouth, goSouth, goSouth}},
  
  // duringWalk2 state
  {4, 4, 0, 50, {duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3}},
  
  // duringWalk3 state
  {4, 4, 16, 50, {duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4}},
  
  // duringWalk4 state
  {4, 4, 0, 50, {offWalk, offWalk, offWalk, offWalk, offWalk, offWalk, offWalk, offWalk}},
  
  // allRedForWest state
  {4, 4, 16, 50, {goWest, goWest, goWest, goWest, goWest, goWest, goWest, goWest}},
  
  // waitWestForWalk state
  {2, 4, 16, 50, {goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk}},
  
  // waitSouthForWest state
  {4, 2, 16, 50, {allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest}}
};
// put both EIDs in the next two lines
const char EID1[] = "VST362"; //  ;replace abc123 with your EID
const char EID2[] = "AS237333"; //  ;replace abc123 with your EID
// Hint implement Traffic_Out before creating the struct, make struct match your Traffic_Out
// initialize all 6 LED outputs and 3 switch inputs
// assumes LaunchPad_Init resets and powers A and B
void Traffic_Init(void){ // assumes LaunchPad_Init resets and powers A and B
 // write this 
  IOMUX->SECCFG.PINCM[PB17INDEX] = 0x00040081;
  IOMUX->SECCFG.PINCM[PB16INDEX] = 0x00040081;
  IOMUX->SECCFG.PINCM[PB15INDEX] = 0x00040081;
  IOMUX->SECCFG.PINCM[PB2INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB1INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB0INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB8INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB7INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB6INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB22INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB26INDEX] = 0x00000081;
  IOMUX->SECCFG.PINCM[PB27INDEX] = 0x00000081;
  GPIOB->DOESET31_0=0x0C4001C7;
}
/* Activate LEDs
* Inputs: west is 3-bit value to three east/west LEDs
*         south is 3-bit value to three north/south LEDs
*         walk is 3-bit value to 3-color positive logic LED on PB22,PB26,PB27
* Output: none
* - west =1 sets west green
* - west =2 sets west yellow
* - west =4 sets west red
* - south =1 sets south green
* - south =2 sets south yellow
* - south =4 sets south red
* - walk=0 to turn off LED
* - walk bit 22 sets blue color
* - walk bit 26 sets red color
* - walk bit 27 sets green color
* Feel free to change this. But, if you change the way it works, change the test programs too
* Be friendly*/
void Traffic_Out(uint32_t west, uint32_t south, uint32_t walk){
    GPIOB->DOUTCLR31_0=0x0C4001C7;
    GPIOB->DOUT31_0=GPIOB->DOUT31_0|=(south);
    GPIOB->DOUT31_0=GPIOB->DOUT31_0|=(west<<6);
    GPIOB->DOUT31_0=GPIOB->DOUT31_0|=(walk<<22);
    }
    
/* Read sensors
 * Input: none
 * Output: sensor values
 * - bit 0 is west car sensor
 * - bit 1 is south car sensor
 * - bit 2 is walk people sensor
* Feel free to change this. But, if you change the way it works, change the test programs too
 */
uint32_t Traffic_In(void){
    return ((GPIOB->DIN31_0 & 0x00038000) >> 15);
}
// use main1 to determine Lab4 assignment
void Lab4Grader(int mode);
void Grader_Init(void);
int main1(void){ // main1
  Clock_Init80MHz(0);
  LaunchPad_Init();
  Lab4Grader(0); // print assignment, no grading
  while(1){
  }
}
// use main2 to debug LED outputs
// at this point in ECE319K you need to be writing your own test functions
// modify this program so it tests your Traffic_Out  function
int main2(void){ // main2
  Clock_Init80MHz(0);
  LaunchPad_Init();
  Grader_Init(); // execute this line before your code
  LaunchPad_LED1off();
  Traffic_Init(); // your Lab 4 initialization
  if((GPIOB->DOE31_0 & 0x20)==0){
    UART_OutString("access to GPIOB->DOE31_0 should be friendly.\n\r");
  }
  UART_Init();
  UART_OutString("Lab 4, Spring 2025, Step 1. Debug LEDs\n\r");
  UART_OutString("EID1= "); UART_OutString((char*)EID1); UART_OutString("\n\r");
  UART_OutString("EID2= "); UART_OutString((char*)EID2); UART_OutString("\n\r");
  while(1){
    // write code to test your Traffic_Out
    if((GPIOB->DOUT31_0&0x20) == 0){
      UART_OutString("DOUT not friendly\n\r");
    }
  }
}
// use main3 to debug the three input switches
// at this point in ECE319K you need to be writing your own test functions
// modify this program so it tests your Traffic_In  function
int main3(void){ // main3
  uint32_t last=0,now;
  Clock_Init80MHz(0);
  LaunchPad_Init();
  Traffic_Init(); // your Lab 4 initialization
  Debug_Init();   // Lab 3 debugging
  UART_Init();
  __enable_irq(); // UART uses interrupts
  UART_OutString("Lab 4, Spring 2025, Step 2. Debug switches\n\r");
  UART_OutString("EID1= "); UART_OutString((char*)EID1); UART_OutString("\n\r");
  UART_OutString("EID2= "); UART_OutString((char*)EID2); UART_OutString("\n\r");
  while(1){
    now = Traffic_In(); // Your Lab4 input
    if(now != last){ // change
      UART_OutString("Switch= 0x"); UART_OutUHex(now); UART_OutString("\n\r");
      Debug_Dump(now);
    }
    last = now;
    Clock_Delay(800000); // 10ms, to debounce switch
  }
}
// use main4 to debug using your dump
// proving your machine cycles through all states
int main4(void){// main4
uint32_t input;
  Clock_Init80MHz(0);
  LaunchPad_Init();
  LaunchPad_LED1off();
  Traffic_Init(); // your Lab 4 initialization
 // set initial state
  Debug_Init();   // Lab 3 debugging
  UART_Init();
  __enable_irq(); // UART uses interrupts
  UART_OutString("Lab 4, Spring 2025, Step 3. Debug FSM cycle\n\r");
  UART_OutString("EID1= "); UART_OutString((char*)EID1); UART_OutString("\n\r");
  UART_OutString("EID2= "); UART_OutString((char*)EID2); UART_OutString("\n\r");
// initialize your FSM
  SysTick_Init();   // Initialize SysTick for software waits

  while(1){
      // 1) output depending on state using Traffic_Out
      // call your Debug_Dump logging your state number and output
      // 2) wait depending on state
      // 3) hard code this so input always shows all switches pressed
      // 4) next depends on state and input
  }
}
// use main5 to grade
int main(void){// main5
  Clock_Init80MHz(0);
  LaunchPad_Init();
  Grader_Init(); // execute this line before your code
  LaunchPad_LED1off();
  Traffic_Init(); // your Lab 4 initialization
// initialize your FSM
  SysTick_Init();   // Initialize SysTick for software waits
  struct state{
    uint32_t westbit;
    uint32_t southbit;
    uint32_t walkbit;
    uint32_t delay;
    uint32_t nextState[8];
  };
  typedef struct state state_t;
  state_t FSM[14] = {
  // goWest state
  {1, 4, 16, 200, {goWest, goWest, waitWestForSouth, waitWestForSouth, waitWestForWalk, waitWestForWalk, waitWestForSouth, waitWestForSouth}},
  
  // goSouth state
  {4, 1, 16, 200, {goSouth, waitSouthForWest, goSouth, waitSouthForWest, waitSouthForWalk, waitSouthForWalk, waitSouthForWalk, waitSouthForWalk}},
  
  // waitWestForSouth state
  {2, 4, 16, 100, {allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth, allRedForSouth}},
  
  // waitSouthForWalk state
  {4, 2, 16, 100, {goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk}},
  
  // goWalk state
  {4, 4, 49, 100, {duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1, duringWalk1}},
  
  // offWalk state
  {4, 4, 16, 200, {offWalk, allRedForWest, allRedForSouth, allRedForWest, goWalk, allRedForWest, allRedForSouth, allRedForWest}},
  
  // duringWalk1 state
  {4, 4, 16, 100, {duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2, duringWalk2}},
  
  // allRedForSouth state
  {4, 4, 16, 100, {goSouth, goSouth, goSouth, goSouth, goSouth, goSouth, goSouth, goSouth}},
  
  // duringWalk2 state
  {4, 4, 0, 100, {duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3, duringWalk3}},
  
  // duringWalk3 state
  {4, 4, 16, 100, {duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4, duringWalk4}},
  
  // duringWalk4 state
  {4, 4, 0, 100, {offWalk, offWalk, offWalk, offWalk, offWalk, offWalk, offWalk, offWalk}},
  
  // allRedForWest state
  {4, 4, 16, 100, {goWest, goWest, goWest, goWest, goWest, goWest, goWest, goWest}},
  
  // waitWestForWalk state
  {2, 4, 16, 100, {goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk, goWalk}},
  
  // waitSouthForWest state
  {4, 2, 16, 100, {allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest, allRedForWest}}
};
  Lab4Grader(1); // activate UART, grader and interrupts
    uint32_t CS=goSouth;
    uint32_t in=0;
    while(1){
      Traffic_Out(FSM[CS].westbit, FSM[CS].southbit, FSM[CS].walkbit);
      SysTick_Wait10ms((FSM[CS].delay));
      in=Traffic_In();
      CS=FSM[CS].nextState[in];
  }
}

