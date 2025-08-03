//  ***************************************************************************************
//
//                              Simple Game framework
//
//  ***************************************************************************************
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

#include "Kernel.h"
#include "FrontEnd.h"
#include "data.h"

#include "GamePlay.h"

#include "/zxnext_sprite/zxn/include/newlib/zxnext_sprite.h"

#pragma output CRT_ORG_CODE = 0x0000


    uint16  counter;

//  ***************************************************************************************
//  Init the Game
//  ***************************************************************************************
void GP_Init( void )
{
    ClsATTR(8);
    ClsULA();
    InitSpriteData();
    
    LoadSprites();

    // Set game process state when ready
    SetState(State_Game);
} 

//  ***************************************************************************************
//  Process the game
//  ***************************************************************************************
void GP_Process( void )
{
    if( Keys[VK_2]!=0)
    {
        Keys[VK_2] = 0;
        SetState(State_QuitGame);
    }

    counter++;
} 

//  ***************************************************************************************
//  Render the game
//  ***************************************************************************************
void GP_Render( void )
{
    Print(0,48,"GP_Render - [2] to Quit\n");

    

    // (Slot, x, y, pattern?, attributes, visible)
    set_sprite_attributes(0, 116, 100, 0, 0x00, true);

    //set_sprite_attributes(1, 100, 100, 0, 0x00, true);
    //set_sprite_attributes(2, 130, 100, 0, 0x00, true);
} 

//  ***************************************************************************************
//  Quiit the game and cleanup
//  ***************************************************************************************
void GP_Quit( void )
{
    Print(0,58,"GP_Quit\n");

    // Set game process state when ready
    SetState(State_InitFrontEnd);
} 

void LoadSprites()
{
    extern const unsigned char sprites[];
    extern const unsigned char pallette[];

    set_sprite_palette(pallette, 17, 0);

    int number_sprites = 1;

    for(int i; i < number_sprites; i++)
    {
        set_sprite_slot(i);
        set_sprite_pattern(sprites + (i * 256));
    }
}

