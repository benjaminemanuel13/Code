
    SECTION GAMEPLAY_SEG
    PUBLIC _GamePlayTest
    PUBLIC _sprites
	PUBLIC _pallette

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
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $01, $01, $01, $01, $01, $01, $01, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $01, $D1, $D1, $D1, $D5, $D1, $D1, $D1, $01, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $01, $D1, $D1, $D1, $D1, $D1, $D1, $D1, $01, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $01, $D1, $D6, $FF, $D6, $D1, $D6, $FF, $D6, $D1, $01, $E3, $E3, $E3;
	db  $E3, $E3, $01, $FF, $FF, $01, $FF, $FF, $FF, $01, $FF, $FF, $01, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $01, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $01, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $01, $01, $FF, $FF, $FF, $01, $01, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $01, $01, $51, $01, $01, $01, $51, $01, $01, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $01, $D6, $56, $56, $56, $56, $56, $56, $56, $D6, $01, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $01, $01, $8D, $8D, $92, $8D, $8D, $01, $01, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $01, $51, $51, $51, $51, $51, $01, $E3, $E3, $E3, $E3, $E3;
	db  $E3, $E3, $E3, $E3, $01, $AD, $AD, $01, $AD, $AD, $01, $E3, $E3, $E3, $E3, $E3;


_pallette:
	db $FF
	db $25
	db $72
	db $BB
	db $29, $4E
	db $00
	db $73, $80
	db $97, $45, $69
	db $8D
	db $65
	db $B2, $DB, $6D
