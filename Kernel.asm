
    SECTION KERNEL_CODE
    PUBLIC  _WaitVBlank, _Layer2Enable, _ClsATTR, _ClsULA, _PrintHex, _DMACopy, _UploadSprites, _ReadKeyboard, _InitKernel
    PUBLIC  _Keys, _RawKeys, _RomFont, _Print,  _CopySpriteData, _ReadNextReg,_InitSpriteData,_WipeSprites

    EXTERN  _VBlank, _Port123b, _SpriteData, _SpriteShape

    include "includes.inc"


; ******************************************************************************************************************************
;   Init the Kernel
; ******************************************************************************************************************************
_InitKernel:
    ld      hl,0x3d00
    ld      de,_RomFont
    ld      bc,0x300
    call    DMACopy
    
    ret

    ; ******************************************************************************************************************************
;   Wipe all sprites
; ******************************************************************************************************************************
_WipeSprites:
    ld      ix, _SpriteData
    ld      b,128
    ld      c,64
    ld      de,5
    xor     a   
@InitSprites: 
    ld      (ix+0),a
    ld      (ix+1),a
    ld      (ix+2),a
    ld      (ix+3),c        ; %01000000 - enable byte 4
    ld      (ix+0),a
    add     ix,de
    djnz    @InitSprites
    ret

; ******************************************************************************************************************************
;   Reset all sprite data, including the extra bit for using 5th byte
; ******************************************************************************************************************************
_InitSpriteData:
    ld      ix, _SpriteData
    ld      b,128
    ld      c,64
    ld      de,5
    xor     a   
@InitSprites: 
    ld      (ix+0),a
    ld      (ix+1),a
    ld      (ix+2),a
    ld      (ix+3),c        ; %01000000 - enable byte 4
    ld      (ix+0),a
    add     ix,de
    djnz    @InitSprites
    ret


; ******************************************************************************************************************************
;   Wait for a Vertical Blank (uses VBlank IRQ)
; ******************************************************************************************************************************
_WaitVBlank:
    xor a
    ld  (_VBlank),a

WaitForVBlank:
    ld  a,(_VBlank)
    and a
    jr  z,WaitForVBlank
    ret



; ************************************************************************
;   Enable the 256 colour Layer 2 bitmap
;
;   In:     L=0  off        (fastcall passes bool as a byte in L)
;           L!=0 on
; ************************************************************************
_Layer2Enable:
    ld  a,l
    and a
    jr  z,@Layer2Off
    ld  l,2

@Layer2Off:
    ld  a,(_Port123b)
    or  l
    ld  (_Port123b),a
    ld  bc, $123b
    out (c),a     
    ret                          



; ************************************************************************
;
;   Function:   Clear the spectrum attribute screen
;   In:     L = attribute
;
;   Format: F_B_PPP_III
;
;           F = Flash
;           B = Bright
;           P = Paper
;           I = Ink
;
; ************************************************************************
_ClsATTR:
    ld      a,l
    ld      hl,AttrScreen
    ld      (hl),a
    ld      de,AttrScreen+1
    ld      bc,1000
    ldir
    ret


; ************************************************************************
;
;   Function:   clear the normal spectrum screen
;
; ************************************************************************
_ClsULA:
    xor a
    ld      hl,ULAScreen
    ld      (hl),a
    ld      de,ULAScreen+1
    ld      bc,6143
    ldir
    ret

; ******************************************************************************
; Function: DMACopy
; In:       hl = Src
;           de = Dest
;           bc = size
; ******************************************************************************
_DMACopy:
    pop     hl          ; get return address
    pop     bc          ; get src
    ld      (DMASrc),bc
    pop     bc          ; get dest
    ld      (DMADest),bc
    pop     bc          ; get size
    ld      (DMALen),bc
    push    hl          ; push return address back

DoDMACopy:
    ld  hl,DMACopyProg                  
    ld  bc,DMASIZE*256 + Z80DMAPORT 
    otir
    ret


; ******************************************************************************
; Function: DMACopy
; In:       hl = Src
;           de = Dest
;           bc = size
; ******************************************************************************
DMACopy:
    ld      (DMASrc),hl
    ld      (DMADest),de
    ld      (DMALen),bc
    jp      DoDMACopy


; ******************************************************************************
; 
; Function: Upload a set of sprites
; In:   E = sprite shape to start at
;       D = number of sprites
;       HL = shape data
;
; ******************************************************************************
_UploadSprites:
    pop     bc          ; pop return address
    pop     de          ; get Start Shape
    pop     hl          ; get number of shapes
    ld      d,l
    pop     hl          ; get shape address
    push    bc          ; restore reeturn address

    ; Upload sprite graphics
    ld      a,e     ; get start shape
    ld      e,0     ; each pattern is 256 bytes

@AllSprites:               
    ; select pattern 2
    ld      bc, $303B
    out     (c),a

    ; upload ALL sprite sprite image data
    ld      bc, SpriteShapePort
@UpLoadSprite:           
    outi

    dec     de
    ld      a,d
    or      e               
    jr      nz, @UpLoadSprite
    ret

; ******************************************************************************
;
;   Print HEX to the screen
;   L  = hex value tp print
;   DE= address to print to (normal specturm screen)
;
; ******************************************************************************
_PrintHex:   
        pop     hl          ; get return address
        dec     sp          ; realign AF - Thanks z88dk! 
        pop     af          ; get AF
        pop     de          ; get dest address
        push    hl          ; push return address back

        push    af
        swapnib
        call    DrawHexCharacter
        inc     e           ; next character on screen

        pop af
        and $0f  

        ; fall through (call)

;
; A = NIBBLE hex value to print (0 to 15 only)
; DE= address to print to (normal specturm screen)
; uses: a,hl,de
;
DrawHexCharacter:   
        and $0f
        ld  hl,HexCharset
        add a,a
        add a,a             ; *8
        add a,a
        add hl,a

        ; data is aligned to 256 bytes
        ldws
        ldws
        ldws
        ldws
        ldws
        ldws
        ldws
        ldws
        
        ld  a,d
        sub 8           ; move back to the top of the screen character
        ld  d,a
        ret

TextSample:
        db  "Hello World 12\nEat Pooh\nTesting\n",0

; ******************************************************************************
;
;   Print(X,Y,"Text")
;
; ******************************************************************************
_Print:
    pop     bc              ; return address
    pop     de              ; get YX (D=Y,E=X)
    pixelad
    pop     de              ; get text
    push    bc

@DrawAll:
    ld      a,(de)
    cp      10
    jr      z,@NewLine
    and     a
    ret     z               ; ,0 terminated

    sub     32
    and     a
    jr      nz,@Skip
    inc     hl
    jr      @NextChar

@NewLine:
    ld      b,8
@down8:
    pixeldn
    djnz    @down8
    ld      l,0
    jr      @NextChar

@Skip:
    call    DrawCharacter

@NextChar:
    inc     de
    jp      @DrawAll

;
; A = NIBBLE hex value to print (0 to 15 only)
; HL= address to print to (normal specturm screen)
; uses: a,hl,de
;
DrawCharacter:   
    push    de
    push    hl
    ld      d,0                 ; char * 8
    sla     a
    rl      d
    sla     a
    rl      d
    sla     a
    rl      d
    ld      e,a
    add     de,_RomFont         ; add on base

    ld      b,8
@WholeChar:
    ld      a,(de)
    ld      (hl),a
    pixeldn
    inc     de
    djnz    @WholeChar

    pop     hl
    pop     de
    inc     hl
    ret


; ******************************************************************************
; Function: Scan the whole keyboard
; ******************************************************************************
_ReadKeyboard:
        ld  b,39
        ld  hl,_Keys
        xor a
@lp1:   ld  (hl),a
        inc hl
        djnz    @lp1

        ld  iy,_Keys
        ld  bc,$fefe            ; Caps,Z,X,C,V
        ld  hl,_RawKeys
@ReadAllKeys:   
        in  a,(c)
        ld  (hl),a
        inc hl      
        
        ld  d,5
        ld  e,$ff
@DoAll: 
        srl a
        jr  c,@notset
        ld  (iy+0),e
@notset:
        inc iy
        dec d
        jr  nz,@DoAll

        ld  a,b
        sla a
        jr  nc,ExitKeyRead
        or  1
        ld  b,a
        jp  @ReadAllKeys
ExitKeyRead:
        ret

; ******************************************************************************
; Function: Copy sprite data (x,y etc) to BRAM (assumes extended data)
; In:   hl = Src
;       d = slot
;       a = count
;       
;
;   |*|*||0011 0000 0011 1011| 0x303b  |Sprite slot, flags
;   | |*||XXXX XXXX 0101 0111| 0x57    |Sprite attributes
;   | |*||XXXX XXXX 0101 1011| 0x5b    |Sprite pattern

; ******************************************************************************
_CopySpriteData:
        ld      hl,_SpriteData
        ld      (DMASpSrc),hl                       ; 16
        ld      bc,$303b
        out     (c),d
        ld      hl,640                              ; 128 * 5
        ld      (DMASpLen),hl                       ; store size
        ld      hl,DMASpriteCopyProg                ; 10
        ld      bc,Z80DMAPORT+(DMASPCOPYSIZE*256)   ; 10
        otir                                        ; 21*20  + 240*4
        ret

; ******************************************************************************
; Function: Read a next register
;           uint16 v = ReadNextReg(uint16 reg)
; ******************************************************************************
_ReadNextReg:
        pop     de          ; get return address
        pop     hl

        ; read MSB of raster first
        ld      bc,$243b    ; select NEXT register
        out     (c),l
        inc     b           ; $253b to access (read or write) value
        in      l,(c)
        ld      h,0
        push    de          ; push return address back
        ret                 ; return in HL


; ******************************************************************************************************************************
; ******************************************************************************************************************************
; ******************************************************************************************************************************
;       Kernel Data
; ******************************************************************************************************************************
; ******************************************************************************************************************************
; ******************************************************************************************************************************
DMASpriteCopyProg:
        db $C3          ; R6-RESET DMA
        db $C7          ; R6-RESET PORT A Timing
        db $CB          ; R6-SET PORT B Timing same as PORT A

        db $7D          ; R0-Transfer mode, A -> B
DMASpSrc:
        dw $1234        ; R0-Port A, Start address               (source address)
DMASpLen:    
        dw 240          ; R0-Block length                        (length in bytes)

        db $54          ; R1-Port A address incrementing, variable timing
        db $02          ; R1-Cycle length port A
      
        db $78          ; R2-Port B address fixed, variable timing Write to a "PORT"
        db $02          ; R2-Cycle length (2) port B
      
        db $AD          ; R4-Continuous mode  (use this for block tansfer)
DMASpDest:
        dw $0057        ; R4-Dest address (Sprite DATA)          (destination port)
          
        db $82          ; R5-Restart on end of block, RDY active LOW
     
        db $CF          ; R6-Load
        db $B3          ; R6-Force Ready
        db $87          ; R6-Enable DMA
ENDSPDMA:
        defc    DMASPCOPYSIZE   = ENDSPDMA-DMASpriteCopyProg





HexCharset:
        db %00000000    ;char30  '0'
        db %00111100
        db %01000110
        db %01001010
        db %01010010
        db %01100010
        db %00111100
        db %00000000
        db %00000000    ;char31 '1'
        db %00011000
        db %00101000
        db %00001000
        db %00001000
        db %00001000
        db %00111110
        db %00000000
        db %00000000    ;char32 '2'
        db %00111100
        db %01000010
        db %00000010
        db %00111100
        db %01000000
        db %01111110
        db %00000000
        db %00000000    ;char33 '3'
        db %00111100
        db %01000010
        db %00001100
        db %00000010
        db %01000010
        db %00111100
        db %00000000
        db %00000000    ;char34 '4'
        db %00001000
        db %00011000
        db %00101000
        db %01001000
        db %01111110
        db %00001000
        db %00000000
        db %00000000    ;char35 '5'
        db %01111110
        db %01000000
        db %01111100
        db %00000010
        db %01000010
        db %00111100
        db %00000000
        db %00000000    ;char36 '6'
        db %00111100
        db %01000000
        db %01111100
        db %01000010
        db %01000010
        db %00111100
        db %00000000
        db %00000000    ;char37 '7'
        db %01111110
        db %00000010
        db %00000100
        db %00001000
        db %00010000
        db %00010000
        db %00000000
        db %00000000    ;char38 '8'
        db %00111100
        db %01000010
        db %00111100
        db %01000010
        db %01000010
        db %00111100
        db %00000000
        db %00000000    ;char39 '9'
        db %00111100
        db %01000010
        db %01000010
        db %00111110
        db %00000010
        db %00111100
        db %00000000
        db %00000000    ;char41 'A'
        db %00111100
        db %01000010
        db %01000010
        db %01111110
        db %01000010
        db %01000010
        db %00000000
        db %00000000    ;char42 'B'
        db %01111100
        db %01000010
        db %01111100
        db %01000010
        db %01000010
        db %01111100
        db %00000000
        db %00000000    ;char43 'C'
        db %00111100
        db %01000010
        db %01000000
        db %01000000
        db %01000010
        db %00111100
        db %00000000
        db %00000000    ;char44 'D'
        db %01111000
        db %01000100
        db %01000010
        db %01000010
        db %01000100
        db %01111000
        db %00000000
        db %00000000    ;char45 'E'
        db %01111110
        db %01000000
        db %01111100
        db %01000000
        db %01000000
        db %01111110
        db %00000000
        db %00000000    ;char46 'F'
        db %01111110
        db %01000000
        db %01111100
        db %01000000
        db %01000000
        db %01000000
        db %00000000


; ******************************************************************************
; Writable DMA Program
; ******************************************************************************
DMACopyProg:
            db  $C3             ; R6-RESET DMA
            db  $C7             ; R6-RESET PORT A Timing
            db  $CB             ; R6-SET PORT B Timing same as PORT A
        
            db  $7D             ; R0-Transfer mode, A -> B
DMASrc:     dw  $0000           ; R0-Port A, Start address      (source address)
DMALen:     dw  6912            ; R0-Block length           (length in bytes)
        
            db  $54             ; R1-Port A address incrementing, variable timing
            db  $02             ; R1-Cycle length port A
                
            db  $50             ; R2-Port B address fixed, variable timing
            db  $02             ; R2-Cycle length port B
                
            db  $AD             ; R4-Continuous mode  (use this for block tansfer)
DMADest:    dw  $4000           ; R4-Dest address           (destination address)
                
            db  $82             ; R5-Restart on end of block, RDY active LOW
            
            db  $CF             ; R6-Load
            db  $B3             ; R6-Force Ready
            db  $87             ; R6-Enable DMA
ENDDMA:

            defc DMASIZE = ENDDMA-DMACopyProg

_Keys:      ds  40
_RawKeys:   ds  8
_RomFont:   ds  0x300       ; copy of the ROM font
            incbin  "ROMFONT.FNT"

            ; xxxxxxxx
            ; yyyyyyyy
            ; PPPP_XM_YM_R_X8/PR
            ; V_E_NNNNNN
            ; H_N6_T_XX_YY_Y8
            ; +- 0_1_N6_XX_YY_PO
            ; +- 0_1_N6_0000_PO

_SpriteData: ds  128*5           ; raw sprite data

_SpriteShape:
            db  $e3,$e3,$e3,$e3,$e3,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$ff,$ff,$e3,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$e3,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$ff,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$ff,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$ff,$ff,$ff,$e3,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$ff,$ff,$ff,$ff,$e3,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$e3,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$ff,$ff,$ff,$e3,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$ff,$ff,$e3,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $e3,$ff,$ff,$ff,$e3,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3

            db  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
            db  $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$ff
            db  $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$00,$ff
            db  $ff,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00,$ff
            db  $ff,$00,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$ff,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$00,$ff,$00,$00,$00,$00,$ff,$00,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$00,$00,$ff,$00,$00,$ff,$00,$00,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$ff,$00,$00,$00,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$ff,$00,$00,$00,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$00,$00,$ff,$00,$00,$ff,$00,$00,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$00,$ff,$00,$00,$00,$00,$ff,$00,$00,$00,$00,$ff
            db  $ff,$00,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$ff,$00,$00,$00,$ff
            db  $ff,$00,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$00,$00,$ff
            db  $ff,$00,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$00,$ff
            db  $ff,$ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$ff,$ff
            db  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff

            db  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$00,$00,$00,$00,$00,$00,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3
            db  $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$e3,$e3,$e3,$e3,$e3,$e3,$e3,$e3

_EndKernel:


