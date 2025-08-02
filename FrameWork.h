//
//	Mainn Framework definitions
//
#ifndef __FRAMEWORK_H__
#define __FRAMEWORK_H__

#include <arch/zxn.h>

#define BREAK  { __asm defb 0xFD,0x00 __endasm; }
#define EXIT   { __asm defb 0xDD,0x00 __endasm; }
#define NextReg(r,v)	ZXN_NEXTREG_helper(r,v)
#define NextRegA(r,var)	ZXN_NEXTREGA_helper(r,var)

typedef	uint8_t		uint8;
typedef	int8_t		int8;
typedef	uint16_t	uint16;
typedef	int16_t		int16;
typedef	uint32_t	uint32;
typedef	int32_t		int32;

#define	SetState(state)	GameState=state

typedef enum eGameStateType
{
	State_InitFrontEnd = 1,		// init the front end
	State_FrontEnd,			// Process front end
	State_QuitFrontEnd,		// quit the front end

	State_InitGame,			// ini the game
	State_Game,			// process the game
	State_QuitGame,			// quot the game
}eGameState;


#endif // __FRAMEWORK_H__


