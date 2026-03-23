// Salomon Aquino
// CS3B - SA_PRINT_COMPLETE_LINE
// 2/21/2026

//*****************************************************************************
// Function SA_PRINT_COMPLETE_LINE: Converts an integer and prints Binary -> Arrow -> Decimal.
//
// X0: Signed integer value to convert
// X1: Pointer to Binary Input 
// X2: Pointer to Arrow Buffer
// X3: Pointer to Decimal Destination Buffer
// LR: Return address
//*****************************************************************************

// Pseudocode/algorithm:
//	1. Preserve return address and all string pointers.
//	2. Convert the integer value into a decimal C-string.
//	3. Print the binary input string.
//	4. Print the arrow string.
//	5. Print the converted decimal string.
//	6. Restore return address and return.
		
.global SA_PRINT_COMPLETE_LINE	// initialize SA_PRINT_COMPLETE_LINE

SA_PRINT_COMPLETE_LINE:	// define SA_PRINT_COMPLETE_LINE

	.text	// code section
	
	STR LR, [SP, #-16]!		// push return address
	STR X3, [SP, #-16]!		// push decimal buffer
	STR X2, [SP, #-16]!		// push arrow buffer
	STR X1, [SP, #-16]!		// push binary input
	STR X0, [SP, #-16]!		// push decimal value

	// Fix the binary input by replacing the newline with a null 
	MOV X5, X1				// copy binary pointer to X5
find_newline:
	LDRB W6, [X5]			// load byte
	CMP W6, #10				// check for newline
	B.EQ found_newline			// if found, jump to found_newline
	ADD X5, X5, #1			// increment pointer
	B find_newline				// loop
found_newline:
	MOV W6, #0				// get null value
	STRB W6, [X5]			// store null over newline

	// Convert Integer to String
	LDR X0, [SP], #16		// pop decimal value into X0
	LDR X1, [SP, #32]		// get decimal buffer pointer (X3)
	BL int2cstr				// convert integer to string

	// Print the sequence
	LDR X0, [SP], #16		// pop binary input into X0
	BL putstring			// print binary input

	LDR X0, [SP], #16		// pop arrow buffer into X0
	BL putstring			// print arrow

	LDR X0, [SP], #16		// pop decimal buffer into X0
	BL putstring			// print decimal string

	LDR LR, [SP], #16		// pop return address
	RET
	
.end	// end of program
