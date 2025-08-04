
IDIR =../include
CC=zcc
CFLAGS=+zxn -vn -c -SO3 --list --c-code-in-asm --opt-code-speed -clib=sdcc_iy -pragma-include:zpragma.inc  --max-allocs-per-node300000

ODIR=obj
LDIR =../lib
LIBS=-lm



OBJS = Obj\main.o Obj\Kernel.o Obj\uart.o Obj\IRQs.o Obj\data.o Obj\FrontEnd_Overlay.o Obj\FrontEnd_Asm.o Obj\GamePlay_Overlay.o Obj\GamePlay_Asm.o


hello_world.nex: $(OBJS) 
	$(CC) +zxn -vn -m -clib=sdcc_iy -Cz"--clean" -pragma-include:zpragma.inc -startup=1 $(OBJS) -o hello_world.nex -create-app -subtype=nex -lzxnext_sprite.lib


# Main program at $8000
Obj\main.o: 	main.c FrameWork.h Kernel.h FrontEnd.h GamePlay.h
		$(CC) $(CFLAGS) -o Obj\main.o main.c
Obj\data.o: 	data.c FrameWork.h Kernel.h
		$(CC) $(CFLAGS) -o Obj\data.o data.c


# Kernel section
Obj\Kernel.o: Kernel.asm includes.inc
	$(CC) $(CFLAGS) --codesegPAGE_02_KERNEL_CODE --constsegPAGE_02_KERNEL_CODE -o Obj\Kernel.o Kernel.asm
Obj\IRQs.o: IRQs.asm includes.inc
	$(CC) $(CFLAGS) --codesegPAGE_02_KERNEL_IRQ --constsegPAGE_02_KERNEL_IRQ -o Obj\IRQs.o IRQs.asm

# UART section
Obj\Uart.o: uart.asm
	$(CC) $(CFLAGS) --codesegPAGE_02_UART_CODE --constsegPAGE_02_UART_CODE -o Obj\uart.o uart.asm

# Front End overlay
Obj\FrontEnd_Overlay.o: FrontEnd_Overlay.c FrontEnd.h FrameWork.h Kernel.h
	$(CC) $(CFLAGS) --codesegPAGE_08_FRONTEND_SEG --constsegPAGE_08_FRONTEND_SEG -o Obj\FrontEnd_Overlay.o FrontEnd_Overlay.c 
Obj\FrontEnd_Asm.o: FrontEnd_Asm.asm
	$(CC) $(CFLAGS) --codesegPAGE_08_FRONTEND_SEG --constsegPAGE_08_FRONTEND_SEG -o Obj\FrontEnd_Asm.o FrontEnd_Asm.asm


# Game Play overlay
Obj\GamePlay_Overlay.o: GamePlay_Overlay.c FrameWork.h Kernel.h
	$(CC) $(CFLAGS) --codesegPAGE_06_GAMEPLAY_SEG --constsegPAGE_06_GAMEPLAY_SEG -o Obj\GamePlay_Overlay.o GamePlay_Overlay.c
Obj\GamePlay_Asm.o: GamePlay_Asm.asm
	$(CC) $(CFLAGS) --codesegPAGE_08_FRONTEND_SEG --constsegPAGE_08_FRONTEND_SEG -o Obj\GamePlay_Asm.o GamePlay_Asm.asm	


clean:
	del -f obj\*.o 
	del -f *.lis
	del -f *.bin
	del -f *.nex
	del -f *.map


