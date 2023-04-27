.global _start

.equ VGA_ADDR, 0xc8000000
.equ VGA_CHAR_ADDR, 0xc9000000
.equ PS2_KB_ADDR, 0xff200100
MAX_WIDTH: .word 319
MAX_HEIGHT: .word 239
GRID_OFFSET: .word 20		// Cell side
COLOR_GREY: .word 0xD6BA	// Inactive cell color
COLOR_ACTIVE: .word 0x0  // 0xF800
INPUT_DATA: .word 0x0
INPUT_BREAK: .word 0xF000	// Break code
INPUT_UP: .word 0x1D		// W key
INPUT_DOWN: .word 0x1B		// S key
INPUT_LEFT: .word 0x1C		// A key
INPUT_RIGHT: .word 0x23		// D key
INPUT_TOGGLE: .word 0x29	// SPACE key
INPUT_ITER:	.word 0x31		// N key
GoLBoard:
	//  x 0 1 2 3 4 5 6 7 8 9 a b c d e f    y
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // 0
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // 1
	.word 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0 // 2
	.word 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0 // 3
	.word 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0 // 4
	.word 0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0 // 5
	.word 0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0 // 6
	.word 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 // 7
	.word 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 // 8
	.word 0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0 // 9
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // a
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 // b	
// 20x20 sprite
CursorImg:
	.word -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
	.word -1, -1, -1, -1, -1, -1, -1, -1, 0x20A1, 0x2041, 0x2061, 0x2041, 0x2061, -1, -1, -1, -1, -1, -1, -1
	.word -1, -1, -1, -1, -1, -1, 0x1821, 0x1801, 0x1801, 0x1801, 0x1801, 0x1801, 0x1801, 0x1801, 0x1841, -1, -1, -1, -1, -1
	.word -1, -1, -1, -1, 0x2941, 0x1821, 0x1801, 0x2801, 0x6021, 0x8842, 0x9862, 0x8842, 0x6021, 0x2801, 0x1801, 0x1821, -1, -1, -1, -1
	.word -1, -1, -1, -1, 0x1821, 0x1801, 0x5021, 0xA862, 0xC082, 0xC882, 0xC882, 0xC882, 0xC882, 0xA862, 0x3002, 0x1801, 0x31C1, -1, -1, -1
	.word -1, -1, 0x1947, 0x1126, 0x10E5, 0x10E5, 0x2905, 0x2906, 0x2906, 0x3905, 0x68E4, 0xB882, 0xC882, 0xC882, 0x7843, 0x1801, 0x1841, -1, -1, -1
	.word -1, 0x1947, 0x1127, 0x21C9, 0x5B6F, 0x7C72, 0x7493, 0x5C12, 0x53F1, 0x432F, 0x19A9, 0x3906, 0xB882, 0xC882, 0x9864, 0x2002, 0x1821, -1, -1, -1
	.word -1, 0x1147, 0x1167, 0xAE19, 0xFFFF, 0xFFFF, 0xDF7E, 0x9E7B, 0x9E7B, 0x9E7C, 0x6475, 0x1188, 0x78C4, 0xC882, 0xA064, 0x3003, 0x1801, 0x2061, 0x3261, -1
	.word -1, 0x1147, 0x220A, 0xA67B, 0xAEBC, 0x9E7B, 0x965B, 0x965B, 0x965B, 0x965B, 0x6496, 0x220B, 0x58E5, 0xC882, 0xA864, 0x4003, 0x1801, 0x1801, 0x1801, 0x1821
	.word -1, 0x1147, 0x21EA, 0x7538, 0x8DFA, 0x963B, 0x963B, 0x8E1A, 0x8599, 0x6496, 0x4BF4, 0x220B, 0x60E4, 0xC882, 0xA864, 0x4824, 0x2001, 0x8041, 0x6021, 0x1801
	.word -1, 0x1147, 0x1167, 0x3B30, 0x5414, 0x5435, 0x5C35, 0x5414, 0x53F4, 0x53F4, 0x4392, 0x1168, 0x78C4, 0xC882, 0xA863, 0x5825, 0x2801, 0xA863, 0xB063, 0x3001
	.word -1, 0x1147, 0x1126, 0x1167, 0x222B, 0x32CE, 0x3B30, 0x4351, 0x3B30, 0x32AD, 0x19A8, 0x2126, 0xA882, 0xC882, 0xA863, 0x5825, 0x2002, 0x7026, 0x7847, 0x3002
	.word -1, -1, 0x1821, 0x2883, 0x4105, 0x2926, 0x1926, 0x1927, 0x1926, 0x2926, 0x5105, 0xA0A3, 0xC882, 0xC882, 0xA864, 0x5825, 0x2002, 0x7026, 0x7847, 0x3803
	.word -1, -1, 0x1821, 0x4821, 0xC882, 0xB882, 0xB082, 0xB082, 0xB082, 0xB882, 0xC882, 0xC882, 0xC082, 0xC882, 0xA064, 0x5825, 0x2002, 0x7026, 0x7847, 0x3803
	.word -1, -1, 0x1001, 0x4822, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC882, 0x9845, 0x5825, 0x2002, 0x7026, 0x7847, 0x3803
	.word -1, -1, 0x1801, 0x3803, 0xB863, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0x8046, 0x5825, 0x2002, 0x7046, 0x7847, 0x3803
	.word -1, -1, 0x1821, 0x3003, 0x9864, 0xC882, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC082, 0xC882, 0xA064, 0x7847, 0x5825, 0x2002, 0x7046, 0x7847, 0x3803
	.word -1, -1, 0x1821, 0x2802, 0x7846, 0xA863, 0xC082, 0xC882, 0xC882, 0xC882, 0xC882, 0xC082, 0xA864, 0x7846, 0x7847, 0x5825, 0x2002, 0x7046, 0x7847, 0x3003
	.word -1, -1, 0x1821, 0x2002, 0x7026, 0x7847, 0x9045, 0xA064, 0xA863, 0xA864, 0x9864, 0x8846, 0x7847, 0x7847, 0x7847, 0x5024, 0x2002, 0x7046, 0x7046, 0x2802
	.word -1, -1, 0x1821, 0x2001, 0x6826, 0x7847, 0x7847, 0x7847, 0x7847, 0x7847, 0x7847, 0x7847, 0x7847, 0x7847, 0x7847, 0x5024, 0x2802, 0x7847, 0x6025, 0x1801

_start:
	BL		GoL_draw_grid_ASM		// Draw background grid
	LDR		A1, COLOR_ACTIVE
	BL		GoL_draw_board_ASM		// Draw current pixels
	MOV		V1, #0					// Cursor pos x
	MOV		V2, #0					// Cursor pos y
	MOV		V3, #0					// Next iteration boolean
	// V4-V5 are scratch registers
.loop:
	LDR		A1, =INPUT_DATA
	BL		read_PS2_data_ASM
	CMP		A1, #1					// Poll input update
	BNE		.skip_input_polling
	LDR		A1, INPUT_DATA			// Get input char
	LDR		A2, INPUT_BREAK
	TST		A1, A2
	BNE		.skip_input_polling		// Skip polling if break code
	MOV		V4, V1					// Remember prev positions
	MOV		V5, V2
	LDR		A2, INPUT_UP			// Check if UP input
	CMP		A1, A2
	SUBEQ	V2, V2, #1
	LDR		A2, INPUT_DOWN			// Check if DOWN input
	CMP		A1, A2
	ADDEQ	V2, V2, #1
	LDR		A2, INPUT_LEFT			// Check if LEFT input
	CMP		A1, A2
	SUBEQ	V1, V1, #1
	LDR		A2, INPUT_RIGHT			// Check if RIGHT input
	CMP		A1, A2
	ADDEQ	V1, V1, #1
	LDR		A2, INPUT_ITER			// Check if ITER input
	CMP		A1, A2
	MOVEQ	V3, #1
	LDR		A2, INPUT_TOGGLE		// Check if SPACE input
	CMP		A1, A2
	MOVEQ	A1, V4
	MOVEQ	A2, V5
	BLEQ	GoL_toggle_gridxy_ASM
	CMP		V1, #0					// Check if x >= 0
	MOVLO	V1, #0
	CMP		V1, #15					// Check if x <= 15
	MOVHI	V1, #15
	CMP		V2, #0					// Check if y >= 0
	MOVLO	V2, #0
	CMP		V2, #11					// Check if y <= 11
	MOVHI	V2, #11
	MOV		A1, V4					// Restore prev cursor positions
	MOV		A2, V5
	BL		GoL_udpate_gridxy_ASM	// Update cell of prev cursor pos
.skip_input_polling:
	CMP		V3, #1					// Check if a game iteration occurs
	BNE		.skip_game_life_iter
	MOV		V3, #0					// Reset game iteration
	MOV		A1, #4
	MOV		A2, #5
	BL		GoL_update_board_ASM	// Update the board state
	BL		GoL_collapse_board_ASM	// Draw the new board
.skip_game_life_iter:
	MOV		A1, V1
	MOV		A2, V2
	LDR		A3, =CursorImg
	BL		GoL_sprite_gridxy_ASM	// Draw the cursor
	B		.loop
end:
	B       end

// Collapse the intermediate steps of the board GoLBoard and draw new cells
GoL_collapse_board_ASM:
	PUSH	{V1-V3, LR}
	MOV		V1, #15					// init x
	MOV		V2, #11					// init y
	LDR		V3, =GoLBoard
.GoL_collapse_board_ASM_loop:
	MOV		A1, #16
	MLA		A1, A1, V2, V1			// 16 * y + x
	MOV		A2, #4
	MLA		A2, A1, A2, V3			// 4*(16 * y + x) + GoLBoard
	LDR		A1, [A2]				// Current state of cell
	CMP		A1, #1					// if value of 0 or 1 -> nothing
	BLS		.GoL_collapse_board_ASM_loop_end
	CMP		A1, #2					// If value of 2 -> 1
	MOVEQ	A1, #1
	CMP		A1, #3					// If value of 3 -> 0
	MOVEQ	A1, #0
	STR		A1, [A2]				// Save collapsed value
	MOV		A1, V1
	MOV		A2, V2
	BL		GoL_udpate_gridxy_ASM	// Draw single updated cell
.GoL_collapse_board_ASM_loop_end:
	// For loop control:
	ADDS	A1, V1, V2
	BEQ		.GoL_collapse_board_ASM_end	// Check if termination reached
	CMP		V1, #0						// Check if end of row reached
	MOVEQ	V1, #15						// set x = 15
	SUBEQ	V2, #1						// y -= 1
	SUBNE	V1, #1						// x -= 1
	B		.GoL_collapse_board_ASM_loop
.GoL_collapse_board_ASM_end:
	POP		{V1-V3, LR}
	BX		LR
	
// Update the board GoLBoard with game of life logic
// Intermediate cells can have values [0, 3]
// 0 - inactive; 1 - active; 2 - newly active, prev unactive; 3 - newly unactive, prev active
GoL_update_board_ASM:
	PUSH	{V1-V4, LR}
	MOV		V1, #15					// init x
	MOV		V2, #11					// init y
.GoL_update_board_ASM_loop:
	LDR		V3, =GoLBoard
	MOV		A1, #16
	MLA		A1, A1, V2, V1		// 16 * y + x
	MOV		A2, #4
	MLA		V4, A1, A2, V3		// 4*(16 * y + x) + GoLBoard
	LDR		V3, [V4]			// Current state of cell
	MOV		A1, V1
	MOV		A2, V2
	BL		GoL_neighbours_gridxy_ASM	// Current neighbours of cell
	// Game logic:
	CMP		V3, #0
	BEQ		.GoL_update_board_ASM_logic_inactive
	// Curent state is active
	CMP		A1, #1		// Check if <= 1 neighbours
	MOVLS	V3, #3		// State of curr inactive, prev active
	BLS		.GoL_update_board_ASM_end_logic
	CMP		A1, #3		// Check if <= 3 neighbours
	MOVLS	V3, #1		// State of curr active
	// Otherwise, if > 3 neighbours
	MOVHI	V3, #3		// State of curr inactive, prec active
	B		.GoL_update_board_ASM_end_logic
.GoL_update_board_ASM_logic_inactive:
	// Current state is inative
	CMP		A1, #3		// Check if 3 neighbours
	MOVEQ	V3, #2		// State of curr active, prev inactive
	// Otherwise cell remains inactive
.GoL_update_board_ASM_end_logic:
	STR		V3, [V4]	// Store new state
	// For loop control:
	ADDS	A1, V1, V2
	BEQ		.GoL_update_board_ASM_end	// Check if termination reached
	CMP		V1, #0						// Check if end of row reached
	MOVEQ	V1, #15						// set x = 15
	SUBEQ	V2, #1						// y -= 1
	SUBNE	V1, #1						// x -= 1
	B		.GoL_update_board_ASM_loop
.GoL_update_board_ASM_end:
	POP		{V1-V4, LR}
	BX		LR

// Cound neighbours around cell at location (x, y)
// A1 - x-coordinate in the range [0, 15]
// A2 - y-coordinate in the range [0, 11]
// A1 - Return neighbour count [0, 8]
GoL_neighbours_gridxy_ASM:
	PUSH	{V1-V6}
	LDR		V1, =GoLBoard
	MOV		V2, #0					// Count
	MOV		V3, #-1					// X offset
	MOV		V4, #-1					// Y offset
.GoL_neighbours_gridxy_ASM_loop:
	MLA		A3, V3, V4, V3
	ADDS	A3, A3, V4				// Check if x_offset, y_offset = 0
	BEQ		.GoL_neighbours_gridxy_ASM_loop_end
	ADD		V5, A1, V3				// X global grid
	CMP		V5, #0
	BLO		.GoL_neighbours_gridxy_ASM_loop_end
	CMP		V5, #15
	BHI		.GoL_neighbours_gridxy_ASM_loop_end
	ADD		V6, A2, V4				// Y global grid
	CMP		V6, #0
	BLO		.GoL_neighbours_gridxy_ASM_loop_end
	CMP		V6, #11
	BHI		.GoL_neighbours_gridxy_ASM_loop_end
	MOV		A3, #16
	MLA		A4, V6, A3, V5			// y*16 + x
	MOV		A3, #4
	MLA		A4, A4, A3, V1			// (y*16 + x)*4 + base addr
	LDR		A4, [A4]
	CMP		A4, #1					// Check if neighbour cell curr active
	ADDEQ	V2, V2, #1				// count++
	CMP		A4, #3					// Check if neighbour cell prev active
	ADDEQ	V2, V2, #1				// count++
.GoL_neighbours_gridxy_ASM_loop_end:
	MLA		A3, V3, V4, V3
	ADD		A3, A3, V4
	CMP		A3, #3					// Check if x_offset, y_offset = 1
	BEQ		.GoL_neighbours_gridxy_ASM_end
	CMP		V3, #1
	MOVEQ	V3, #-1					// set x = -1
	ADDEQ	V4, V4, #1				// y += 1
	ADDNE	V3, V3, #1				// x += 1
	B		.GoL_neighbours_gridxy_ASM_loop
.GoL_neighbours_gridxy_ASM_end:
	MOV		A1, V2					// Return the count
	POP		{V1-V6}
	BX		LR

// Fills a specific grid location (x, y) with a sprite
// A1 - x-coordinate in the range [0, 15]
// A2 - y-coordinate in the range [0, 11]
// A3 - sprite image address
GoL_sprite_gridxy_ASM:
	PUSH	{V1-V5, LR}
	CMP		A1, #0						// Check if x >= 0
	BLO		.GoL_sprite_gridxy_ASM_end
	CMP		A1, #15						// Check if x <= 15
	BHI		.GoL_sprite_gridxy_ASM_end
	CMP		A2, #0						// Check if y >= 0
	BLO		.GoL_sprite_gridxy_ASM_end
	CMP		A2, #11						// Check if y <= 11
	BHI		.GoL_sprite_gridxy_ASM_end
	LDR		V2, GRID_OFFSET				// Grid offset
	MUL		V1, A1, V2					// grid x-pos = x_grid * offset
	MUL		V2, A2, V2					// grid y-pos = y_grid * offset
	MOV		V3, A3						// img base adr
	MOV		V4, #19						// img init pixel x-pos
	MOV		V5, #19						// img init pixel y-pos
.GoL_sprite_gridxy_ASM_loop:
	MOV		A1, #4						// byte size
	MOV		A3, #20						// row size
	MLA		A3, V5, A3, V4				// img rel pixel adr = y*20 + x
	MLA		A3, A3, A1, V3				// img pixel adr = 4*rel adr + base adr
	LDR		A3, [A3]					// Load img pixel
	CMP		A3, #-1						// Check if color is transparent
	BEQ		.GoL_sprite_gridxy_ASM_no_draw
	ADD		A1, V1, V4					// x-coord in grid
	ADD		A2, V2, V5					// y-coord in grid
	BL		VGA_draw_point_ASM			// Draw pixel
.GoL_sprite_gridxy_ASM_no_draw:
	ADDS	A1, V4, V5					// Check for ending condition x + y = 0
	BEQ		.GoL_sprite_gridxy_ASM_end
	CMP		V4, #0						// if y != 0 && x == 0
	MOVEQ	V4, #19						// Reset x = 19
	SUBEQ	V5, #1						// y -= 1
	SUBNE	V4, #1						// x -= 1 if x != 0
	B		.GoL_sprite_gridxy_ASM_loop
.GoL_sprite_gridxy_ASM_end:
	POP		{V1-V5, LR}
	BX		LR		

// Draw the cells at locations specified in GoLBoard
// A1 - 16-bit color
GoL_draw_board_ASM:
	PUSH		{V1-V3, LR}
	LDR			V1, =GoLBoard
	MOV			V2, #15				// x-coord
	MOV			V3, #11				// y-coord
	MOV			A3, A1				// 16-bit color
.GoL_draw_board_ASM_loop:
	MOV			A1, #16
	MLA			A1, A1, V3, V2		// 16 * y + x
	MOV			A2, #4
	MLA			A1, A1, A2, V1		// 4*(16 * y + x) + GoLBoard
	LDR			A1, [A1]
	CMP			A1, #0				// Check if cell if filled
	MOVNE		A1, V2
	MOVNE		A2, V3
	BLNE		GoL_fill_gridxy_ASM
	ADDS		A1, V2, V3			// Check if last cell
	BEQ			.GoL_draw_board_ASM_end
	CMP			V2, #0
	MOVEQ		V2, #15				// Change row pos
	SUBEQ		V3, #1
	SUBNE		V2, #1				// Change col pos
	B			.GoL_draw_board_ASM_loop	// Loop back
.GoL_draw_board_ASM_end:
	POP			{V1-V3, LR}
	BX			LR
	
// Toggle the state at a specific grid location (x, y)
// No visual update is performed. Use GoL_udpate_gridxy_ASM to update visuals.
// A1 - x-coordinate in the range [0, 15]
// A2 - y-coordinate in the range [0, 11]
GoL_toggle_gridxy_ASM:
	PUSH	{LR}
	MOV		A3, #16
	MLA		A4, A2, A3, A1			// y*16 + x
	LDR		A1, =GoLBoard
	MOV		A2, #4
	MLA		A3, A4, A2, A1			// (y*16 + x)*4 + base addr
	LDR		A4, [A3]
	CMP		A4, #1					// Check cell state
	MOVEQ	A4, #0					// Toggle state
	MOVNE	A4, #1
	STR		A4, [A3]				// Store new state
	POP		{LR}
	BX		LR

// Update a specific grid location (x, y) with a color
// This function is the same as GoL_fill_gridxy_ASM but the color is implied
// A1 - x-coordinate in the range [0, 15]
// A2 - y-coordinate in the range [0, 11]
GoL_udpate_gridxy_ASM:
	PUSH	{V1-V2, LR}
	MOV		V1, A1					// Temp store x and y for end
	MOV		V2, A2
	MOV		A3, #16
	MLA		A4, A2, A3, A1			// y*16 + x
	LDR		A1, =GoLBoard
	MOV		A2, #4
	MLA		A3, A4, A2, A1			// (y*16 + x)*4 + base addr
	LDR		A3, [A3]
	CMP		A3, #1					// Check cell state
	LDREQ	A3, COLOR_ACTIVE
	LDRNE	A3, COLOR_GREY
	MOV		A1, V1					// x
	MOV		A2, V2					// y
	BL		GoL_fill_gridxy_ASM		// Update color
	POP		{V1-V2, LR}
	BX		LR

// Fills a specific grid location (x, y) with a color
// A1 - x-coordinate in the range [0, 15]
// A2 - y-coordinate in the range [0, 11]
// A3 - 16-bit color of the cell
GoL_fill_gridxy_ASM:
	PUSH	{V1-V4, LR}
	CMP		A1, #0						// Check if x >= 0
	BLO		.GoL_fill_gridxy_ASM_end
	CMP		A1, #15						// Check if x <= 15
	BHI		.GoL_fill_gridxy_ASM_end
	CMP		A2, #0						// Check if y >= 0
	BLO		.GoL_fill_gridxy_ASM_end
	CMP		A2, #11						// Check if y <= 11
	BHI		.GoL_fill_gridxy_ASM_end
	MOV		V1, A1
	MOV		V2, A2
	LDR		V3, GRID_OFFSET
	MOV		V4, #1						// Grid contour offset
	MLA		A1, V2, V3, V4				// y1 = y * GRID_OFFSET
	LSL		A1, A1, #16
	MLA		A1, V1, V3, A1				// x1 = x * GRID_OFFSET
	ADD		A1, V4						// Contour offset
	MLA		A2, V2, V3, V3				// y2 = (y+1) * GRID_OFFSET
	SUB		A2, A2, V4					// Contour offset
	LSL		A2, A2, #16
	MLA		A2, V1, V3, A2
	ADD		A2, A2, V3					// x2 = (x+1) * GRID_OFFSET
	SUB		A2, A2, V4					// Contour offset
	BL		VGA_draw_rect_ASM			// Draw the cell
.GoL_fill_gridxy_ASM_end:
	POP		{V1-V4, LR}
	BX		LR

// Draw a rectangle of a specified color
// A1 - top-left corner (x1, y1) where the hw [0, 15] are for x1 and [16, 31] are for y1
// A2 - bottom-right (x2, y2) where the hw [0, 15] are for x2 and [16, 31] are for y2
// A3 - 16-bit color
VGA_draw_rect_ASM:
	PUSH	{V1-V5, LR}
	LSR		V1, A1, #16		// y1
	LSL		A1, A1, #16
	LSR		V2, A1, #16		// x1
	LSR		V3, A2, #16		// y2
	LSL		A2, A2, #16
	LSR		V4, A2, #16		// x2	
	MOV		V5, #1			// Default left to right dir
	CMP		V4, V2
	MOVLO	V5, #-1			// Right to left dir	
.VGA_draw_rect_ASM_loop:
	MOV		A1, V1
	LSL		A1, A1, #16
	ADD		A1, A1, V2
	MOV		A2, V3
	LSL		A2, A2, #16
	ADD		A2, A2, V2
	BL		VGA_draw_line_ASM		// Color is maintained in A3
	CMP		V4, V2					// Check if loop ended
	BEQ		.VGA_draw_rect_ASM_end
	ADD		V2, V2, V5				// x += -1 or x += 1
	B		.VGA_draw_rect_ASM_loop
.VGA_draw_rect_ASM_end:
	POP		{V1-V5, LR}
	BX		LR

// Draw vertical and horizontal lines to form a grid
GoL_draw_grid_ASM:
	PUSH	{V1-V3, LR}
	LDR		A1, COLOR_GREY
	BL		VGA_fill_pixelbuff_ASM	// Fill the screen with white
	LDR		V2, GRID_OFFSET			// Grid offset
	MOV		A3, #0					// Line color (black)
	// Draw columns
	MOV		V1, #0					// x-pos
	LDR		V3, MAX_WIDTH			// max x-pos
.GoL_draw_grid_ASM_col:
	// y1 = 0
	MOV		A1, V1					// x1
	LDR		A2, MAX_HEIGHT			// y2 = MAX_HEIGHT
	LSL		A2, A2, #16
	ADD		A2, A2, V1				// x2
	BL		VGA_draw_line_ASM
	ADD		V1, V1, V2				// x += grid_offset
	CMP		V1, V3
	BHI		.GoL_draw_grid_ASM_col_end
	B		.GoL_draw_grid_ASM_col
.GoL_draw_grid_ASM_col_end:
	// Draw rows
	MOV		V1, #0					// y-pos
	LDR		V3, MAX_HEIGHT			// max y-pos
.GoL_draw_grid_ASM_row:
	MOV		A2, V1					// y2
	LSL		A2, A2, #16
	LDR		A1, MAX_WIDTH
	ADD		A2, A2, A1				// x2 = MAX_WIDTH
	MOV		A1, V1					// y1
	LSL		A1, A1, #16				// x0 = 0
	BL		VGA_draw_line_ASM
	ADD		V1, V1, V2				// y += grid_offset
	CMP		V1, V3
	BHI		.GoL_draw_grid_ASM_row_end
	B		.GoL_draw_grid_ASM_row
.GoL_draw_grid_ASM_row_end:
	POP		{V1-V3, LR}
	BX		LR
		
// Draw a horizontal or vertical line of a specified color
// A1 - pixel (x1, y1) where the hw [0, 15] are for x1 and [16, 31] are for y1
// A2 - pixel (x2, y2) where the hw [0, 15] are for x2 and [16, 31] are for y2
// A3 - 16-bit color
VGA_draw_line_ASM:
	PUSH	{V1-V4, LR}
	LSR		V1, A1, #16					// Put y1 in V1
	LSL		A1, A1, #16
	LSR		V2, A1, #16					// Isolate x1 in V2
	LSR		V3, A2, #16					// Put y2 in V3
	LSL		A2, A2, #16
	LSR		V4, A2, #16					// Isolate x2 in V4
	CMP		V1, V3						// y1==y2 ?
	BEQ		.draw_horizontal_line_mode
	CMP		V2, V4						// x1==x2 ?
	BEQ		.draw_vertical_line_mode
	B		.no_draw_mode
.draw_horizontal_line_mode:
	// y1==y2
	MOV		V3, #0						// Draw direction in V3
	CMP		V4, V2						// x2-x1
	MOVHI	V3, #1						// Draw left to right
	MOVLO	V3, #-1						// Draw right to left
	MOV		A2, V1						// y for VGA_draw_point_ASM
	MOV		A1, V2						// Set init position to x1
.draw_horizontal_line_mode_loop:
	BL		VGA_draw_point_ASM			// A1 = x, A2 = y, A3 = c
	CMP		A1, V4						// Finished to draw line?
	BEQ		.no_draw_mode
	ADD		A1, A1, V3					// Go to next pixel on row
	B		.draw_horizontal_line_mode_loop
.draw_vertical_line_mode:
	// x1==x2
	MOV		V4, #0						// Draw direction in V4
	CMP		V3, V1						// y2-y1
	MOVHI	V4, #1						// Draw top to down
	MOVLO	V4, #-1						// Draw down to top
	MOV		A1, V2						// x for VGA_draw_point_ASM
	MOV		A2, V1						// Set init position to y1
.draw_vertical_line_mode_loop:
	BL		VGA_draw_point_ASM			// A1 = x, A2 = y, A3 = c
	CMP		A2, V3						// Finished to draw line?
	BEQ		.no_draw_mode
	ADD		A2, A2, V4					// Go to next pixel on column
	B		.draw_vertical_line_mode_loop
.no_draw_mode:
	POP		{V1-V4, LR}
	BX		LR

// Checks if RVALID is true and stores the ASCII key in the specified data pointer
// A1 - Data pointer to store result
// Returns RVALID in A1
read_PS2_data_ASM:
	PUSH	{V1-V2}
	LDR		V2, =PS2_KB_ADDR		// Get the base keyboard address
	LDR		V1, [V2]
	LSR		V1, V1, #15				// [PS2_KB_ADDR] << 15 & 0x01
	ANDS	V1, V1, #0x1			// Get RVALID
	LDRNEH	V2, [V2]
	STRNEH	V2, [A1]				// Store char in data pointer only if RVALID == 1
	MOV		A1, V1					// Return RVALID
	POP		{V1-V2}
	BX		LR

// Draws a point on the screen at the specified (x, y) coordinates with a color
// A1 - x-coordinate between the range [0, 319]
// A2 - y-coordinate between the range [0, 239]
// A3 - 16-bit color
VGA_draw_point_ASM:
	PUSH	{V1}
	CMP		A1, #0						// Check if x >= 0
	BLO		.VGA_draw_point_ASM_end
	LDR		V1, MAX_WIDTH
	CMP		A1, V1						// Check if x <= 319
	BHI		.VGA_draw_point_ASM_end
	CMP		A2, #0						// Check if y >= 0
	BLO		.VGA_draw_point_ASM_end
	LDR		V1, MAX_HEIGHT
	CMP		A2, V1						// Check if y <= 239
	BHI		.VGA_draw_point_ASM_end
	LDR		V1, =VGA_ADDR				// Load base address VGA
	ORR		V1, V1, A1, LSL#1			// X-coord address
	ORR		V1, V1, A2, LSL#10			// Y-coord address
	STRH	A3, [V1]					// Store pixel color
.VGA_draw_point_ASM_end:
	POP		{V1}
	BX		LR
	
// Clears the VGA display pixels
VGA_clear_pixelbuff_ASM:
	PUSH	{LR}
	MOV		A1, #0		// Black color
	BL		VGA_fill_pixelbuff_ASM
	POP		{LR}
	BX		LR
	
// Fill up the VGA display pixels with a color
// A1 - 16-bit color to fill up the display
VGA_fill_pixelbuff_ASM:
	PUSH	{LR}
	LDR		A2, MAX_HEIGHT					// Init y-coord	
	MOV		A3, A1							// Load color
.VGA_fill_pixelbuff_ASM_y:
	CMP		A2, #-1							// End loop condition
	BEQ		.VGA_fill_pixelbuff_ASM_end
	LDR		A1, MAX_WIDTH					// Init x-coord
.VGA_fill_pixelbuff_ASM_x:
	BL		VGA_draw_point_ASM				// Draw pixel
	SUBS	A1, A1, #1						// x -= 1
	SUBLO	A2, A2, #1						// y -= 1 if x < 0
	BLO		.VGA_fill_pixelbuff_ASM_y
	B		.VGA_fill_pixelbuff_ASM_x
.VGA_fill_pixelbuff_ASM_end:
	POP		{LR}
	BX		LR

// Write ASCII character at coord x and y on the VGA display
// A1 - x-coordinate between the range [0, 79]
// A2 - y-coordinate between the range [0, 59]
// A3 - ASCII code to display
VGA_write_char_ASM:
	CMP		A1, #0						// Check if x >= 0
	BXLO	LR
	CMP		A1, #79						// Check if x <= 79
	BXHI	LR
	CMP		A2, #0						// Check if y >= 0
	BXLO	LR
	CMP		A1, #59						// Check if x <= 59
	BXHI	LR
	PUSH	{V1}
	LDR		V1, =VGA_CHAR_ADDR			// Load base char address
	ORR		V1, V1, A1					// Set x-coord
	ORR		V1, V1, A2, LSL#7			// Set y-coord
	STRB	A3, [V1]					// Store ASCII code
	POP		{V1}
	BX		LR
	
// Clears the VGA display chars
VGA_clear_charbuff_ASM:
	PUSH	{LR}
	MOV		A2, #59							// Init y-coord	
	MOV		A3, #0							// Empty char
.VGA_clear_charbuff_ASM_y:
	CMP		A2, #-1							// End loop condition
	BEQ		.VGA_clear_charbuff_ASM_end
	MOV		A1, #79							// Init x-coord
.VGA_clear_charbuff_ASM_x:
	BL		VGA_write_char_ASM				// Draw character
	SUBS	A1, A1, #1						// x -= 1
	SUBLO	A2, A2, #1						// y -= 1 if x < 0
	BLO		.VGA_clear_charbuff_ASM_y
	B		.VGA_clear_charbuff_ASM_x
.VGA_clear_charbuff_ASM_end:
	POP		{LR}
	BX		LR
