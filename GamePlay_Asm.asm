
    SECTION GAMEPLAY_SEG
    PUBLIC _GamePlayTest
    PUBLIC _sprites

    include "includes.inc"

_GamePlayTest:
    push    af
    ld      a,1
    nop
    ld      a,2
    pop     af
    ret

    dw _GamePlayTest
    db "Hello"

_sprites:
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $E3, $FF, $FF, $FF, $FF, $E3, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3
	db  $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3
	db  $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3
	db  $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3
	db  $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3
	db  $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3
	db  $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3
	db  $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $FF, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $E3, $FF, $FF, $FF, $FF, $E3, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3

	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $E3, $88, $88, $88, $88, $E3, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3
	db  $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3
	db  $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3
	db  $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3
	db  $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3
	db  $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3
	db  $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3
	db  $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $88, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $E3, $88, $88, $88, $88, $E3, $E3, $E3, $E3, $E3, $E3
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3
