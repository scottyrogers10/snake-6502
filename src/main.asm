BasicUpstart2(main)

		*= $c000 "Main"

		.const CHAR_CHECKER 		= $66
		.const CHAR_SNAKE_HEAD		= $57
		.const CHAR_SPACE 			= $20
		.const CURSOR_VISIBILITY 	= $cc
		.const CURRENT_KEY_PRESSED	= $cb
		.const KEY_CODE_D			= $12
		.const RASTER_LINE			= $d012
		.const SCREEN_BOTTOM_LINE 	= $07c0
		.const SCREEN_TOP_LINE 		= $0400

		.var snake_head				= $fb
		.var temp_addr 				= $fd

main:
		jsr empty_screen
		jsr draw_border
		jsr draw_snake

game_loop:
		jsr wait
		jsr process_input
		jsr draw_snake_head
		jmp game_loop

//------------------------------------------------------------------------
// GAME LOOP SUBROUTINES

wait:
!:		lda RASTER_LINE
		cmp #$ff
		bne !-
		rts

process_input:
		lda CURRENT_KEY_PRESSED
		cmp #KEY_CODE_D
		beq !+
		rts
!:		lda snake_head
		clc
		adc #$01
		sta snake_head
		rts

draw_snake_head:
		lda #CHAR_SNAKE_HEAD
		ldy #$00
		sta (snake_head), y
		rts

//------------------------------------------------------------------------
// INIT SUBROUTINES

empty_screen:
		lda #$01
		sta CURSOR_VISIBILITY		// turn off blinking cursor
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
		sta temp_addr
		lda #$04
		sta temp_addr+1
		ldx #$18					// 24 rows
!:		lda #CHAR_CHECKER			// draw left and right borders
		ldy #$00
		sta (temp_addr), y
		iny
		sta (temp_addr), y
		lda temp_addr
		clc
		adc #$28					// move over 40 columns (l-r, t-b)
		sta temp_addr
		lda temp_addr+1
		adc #$00
		sta temp_addr+1
		dex
		bne !-
		rts

draw_snake:
		lda #$f4
		sta snake_head
		lda #$05
		sta snake_head+1
		lda #CHAR_SNAKE_HEAD
		ldy #$00
		sta (snake_head), y
		rts