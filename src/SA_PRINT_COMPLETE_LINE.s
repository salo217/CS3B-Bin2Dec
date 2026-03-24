// Salomon Aquino
// CS3B - SA_PRINT_COMPLETE_LINE
// 2/21/2026

//*****************************************************************************
// Function SA_PRINT_COMPLETE_LINE: Converts an integer and prints: -> (Decimal)
//
// X0: Signed integer value to convert
// X1: Pointer to Arrow Buffer
// X2: Pointer to Decimal Destination Buffer
// LR: Return address
//*****************************************************************************

// Pseudocode/algorithm:
//	1. Preserve return address and all string pointers.
//	2. Convert the integer value into a decimal C-string.
//	3. Print the arrow string.
//	4. Print the converted decimal string.
//	5. Restore return address and return.
		
.global SA_PRINT_COMPLETE_LINE	// initialize SA_PRINT_COMPLETE_LINE

SA_PRINT_COMPLETE_LINE:	// define SA_PRINT_COMPLETE_LINE

	.text	// code section
	
	STR LR, [SP, #-16]!		// push return address
	STR X2, [SP, #-16]!		// push decimal buffer
	STR X1, [SP, #-16]!		// push arrow buffer
	//STR X1, [SP, #-16]!		// push binary input
	STR X0, [SP, #-16]!		// push decimal value

	LDR X0, [SP], #16		// pop decimal value into X0
	LDR X1, [SP, #16]		// get decimal buffer pointer (X3)
	BL int2cstr				// convert integer to string

	LDR X0, [SP], #16		// pop arrow buffer into X0
	BL putstring			// print arrow

	LDR X0, [SP], #16		// pop decimal buffer into X0
	BL putstring			// print decimal string

	LDR LR, [SP], #16		// pop return address
	RET
	
.end	// end of program
