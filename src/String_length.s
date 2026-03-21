// Salomon Aquino
// CS3B - lab4-1 String_length
// 2/7/2026

  //*****************************************************************************
  //String_length
  //  Function String_length: Provided a pointer to a null terminated string in
  //  X0, will return the string's length in X0
  //
  //  X0: Must point to a null terminated string
  //  LR: Must contain the return address (automatic when BL
  //      is used for the call)
  //  All registers except   X0, X1, and X2 are preserved
  //*****************************************************************************
  
  //Pseudocode/algorithm:
  //	offset = 0
  //	loop:
  //		get value at base address + offset 
  //		if value == null:
  //			break out of loop
  //		else:
  //			increment offset
  //	string length = offset
  // 	return

.global String_length	// initialize String_length

String_length:	// define String_length

	.text		// code section
	
    MOV X1, #0		    // Set initial offset = 0
    MOV X2, X0		    // load string pointer into X2
    
loop_STRING_LENGTH:
    LDRB W2, [X0, X1]	// load char value into W2 by adding the string pointer + offset
    CMP W2, #0          // compare char to null
    B.EQ endOfLoop_STRING_LENGTH      // break out of loop if equal to null
    
    ADD X1, X1, #1      // increment offset
    B loop_STRING_LENGTH				// jump to beginning of loop
    
endOfLoop_STRING_LENGTH:
    MOV X0, X1			// set return value (string length) equal to offset

    RET					// return

.end  // end of program
