// Salomon Aquino
// CS3B - SA_CLEAR_LINE
// 2/21/2026

//*****************************************************************************
// Function SA_CLEAR_LINE: Moves the terminal cursor to the beginning of the 
//                         current line using a Carriage Return.
//
// LR: Return address (preserved)
// All registers except X0 are preserved
//*****************************************************************************

// Pseudocode/algorithm:
//	1. Preserve the return address on the stack.
//	2. Load the address of the local Carriage Return constant.
//	3. Call putstring to move the cursor to the start of the line.
//	4. Restore the return address and return.

.global SA_CLEAR_LINE

SA_CLEAR_LINE:

	.text	// code section
	
	STR LR, [SP, #-16]!		// push return address

	LDR X0, =sUP_AND_RESET	// load local carriage return string
	BL putstring			// print the carriage return

	LDR LR, [SP], #16		// pop return address
	RET						// return

	.data
		// "\033[A" moves cursor UP
		// "\r" moves to the start of line
		sUP_AND_RESET: .asciz "\033[A\r"
	.text

.end
