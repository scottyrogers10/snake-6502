BasicUpstart2(main)

		*= $c000 "Main"

		.const CHAR_CHECKER = $66
		.const CHAR_SPACE = $20
		.const CURSOR_VISIBILITY = $cc
		.const SCREEN_BOTTOM_LINE = $07c0
		.const SCREEN_TOP_LINE = $0400

		.var TEMP_ADDR = $fb

main:
		jsr empty_screen
		lda #$01
		sta CURSOR_VISIBILITY	// turn off blinking cursor
		jsr draw_border

game_loop:
		jmp game_loop

/*------------SUBROUTINES------------*/

empty_screen:
		lda #CHAR_SPACE
		ldx #$fa					// 250 byte chunks
!:		sta SCREEN_TOP_LINE-1, x
		sta SCREEN_TOP_LINE+249, x
		sta SCREEN_TOP_LINE+499, x
		sta SCREEN_TOP_LINE+749, x
		dex
		bne !-
		rts

draw_border:
		lda #CHAR_CHECKER			// draw top and bottom borders
		ldx #$28					// 40 columns
!:		sta SCREEN_TOP_LINE-1, x
		sta SCREEN_BOTTOM_LINE-1, x
		dex
		bne !-
		lda #$27
		sta TEMP_ADDR
		lda #$04
		sta TEMP_ADDR+1
		ldx #$18					// 24 rows
!:		lda #CHAR_CHECKER			// draw left and right borders
		ldy #$00
		sta (TEMP_ADDR), y
		iny
		sta (TEMP_ADDR), y
		lda TEMP_ADDR
		clc
		adc #$28					// move over 40 columns (l-r, t-b)
		sta TEMP_ADDR
		lda TEMP_ADDR+1
		adc #$00
		sta TEMP_ADDR+1
		dex
		bne !-
		rts