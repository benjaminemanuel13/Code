//
//      ZX Spectrum Next z88dk simple example
//

// Nightly Builds
// http://nightly.z88dk.org/

#pragma output REGISTER_SP = 0xbfff

#include <arch/zxn.h>           // ZX Spectrum Next architecture specfic functions
#include <stdint.h>             // standard names for ints with no ambiguity 
#include <z80.h>
#include <im2.h>
#include <intrinsic.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <input.h>
#include <errno.h>

#include "FrameWork.h"
#include "Kernel.h"
#include "data.h"
#include "FrontEnd.h"
#include "GamePlay.h"


// ****************************************************************************************
//  Handle the main loop and state changes
// ****************************************************************************************
void MainLoop(void)
{
    SetState(State_InitFrontEnd);
    while(1)
    {        
        WaitVBlank();
        CopySpriteData();
        ReadKeyboard();

        // Do game states
        switch(GameState)
        {
            case State_InitFrontEnd:
            {
                NextReg(0x50,8);
                FE_Init();
                break;
            }
            case State_FrontEnd:
            {
                NextReg(0x50,8);
                FE_Process();
                FE_Render();
                break;
            }
            case State_QuitFrontEnd:
            {
                NextReg(0x50,8);
                FE_Quit();
                break;
            }
            case State_InitGame:
            {
                NextReg(0x50,6);
                GP_Init();
                break;
            }
            case State_Game:
            {
                NextReg(0x50,6);
                GP_Process();
                GP_Render();
                break;
            }
            case State_QuitGame:
            {
                NextReg(0x50,6);
                GP_Quit();
                break;
            }
            default:{
                SetState(State_InitFrontEnd);
            }
        }
    }
}



// ************************************************************************************************************************
//  Main program start
// ************************************************************************************************************************
int  main(void)
{
    BREAK;
    intrinsic_label(Main_Label);

    NextReg(0x7,3);           // 28Mhz
    NextReg(0x8,0x4A);        // Disable RAM contention, enable DAC and turbosound
    NextReg(0x5,0x04);        // 60Hz mode
    NextReg(0x15,0x03);       // layer order - and sprites on
    NextReg(0x4b,0xe3);       // sprite transparency


    NextReg(0x57,2);          // page in kernel
    InitKernel();
    SetUpIRQs();

    Layer2Enable(false);
    ClsATTR(56);                // white paper, black ink
    ClsULA();

    PrintHex(0x12,0x4000);
    DMACopy(0x4000,0x4800,0x800);
    UploadSprites(0,0x04,(uint16*) 0x5678);

    MainLoop();

    // never return
    while(1){}
}


