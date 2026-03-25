// Lillian Le
// CS3B - Group Project Bin2Dec
// 3/23/26

// Algorithm/Pseudocode:
// 1) Preserve LR (X30) to stack
// 2) Call getstring
// 3) LOOP until null terminator is encountered
// 3.1) Check individual characters in input buffer
// 3.2) If null terminator, jump to end of loop
// 3.3) If 'q', set return value to #0 and jump to end of function
// 3.4) If 'c', set bits_buffer to all 0's using LL_SET
// 3.5) If X0 is equal to #0, then skip next if statement
// 3.6) If '1' or '0', check if counter >= 0
//      If yes, then push value into bits_buffer and update counter
//      If no, then skip character
// 3.7) Increment pointer
// 3.8) Loop to top of loop
// 4) Flip bits in bits_buffer
// 5) Sign extend bits_buffer using LL_SET
// 6) Set return value to address of bits_buffer
// 7) Restore LR to stack
// 8) Return from function

//**********************************************************************
//LL_GET_INPUT
// Function LL_GET_INPUT: this function will get the entire input buffer
// from the user and process it to handle only valid characters (q, c, 1, 0,
// ENTER) If X0 is set to #0, then it will only handle q, c, and ENTER. 
// 
// The function will return either the address of the bits buffer or a #0, 
// signifiying tothe program to quit.
// X0 : flag to handle specific valid characters
//**********************************************************************

.global LL_GET_INPUT // provide function starting address

LL_GET_INPUT:
	.EQU STDIN,     0   // standard input
	.EQU STDOUT,    1   // standard output
	.EQU SYS_read,  63  // Linux read()
	.EQU SYS_write, 64  // Linux write()
	.EQU SYS_exit,  93  // exit() supervisor call code

	.text  // code section
	// Preserve LR
	STR LR, [SP,#-16]!       // push LR onto stack

	// Save X0 into X7
	MOV X7, X0               // Move X0 to X7
	
	// Call getstring
	LDR X0, =sz_input_buffer // set X0 to input buffer
	MOV X1, #64              // set X1 to max characters read (+1 for '\0')
	BL getstring             // jump to getstring function
	
	// Loop until null terminator is encountered
	// W1 is pointer to character
	// set X6 (counter) to 15
	MOV X6, #15              // set X6 to 15
	
LL_GET_INPUT_LOOP:
	// Check if char == '\0'
	LDRB W1, [X0]            // load char from input buffer
	CMP  W1, #0              // compare char to '\0'
	B.EQ LL_GET_INPUT_L_END  // if char is equal to '\0', then jump to label
	
	// Check if char == 'q'
	CMP  W1, #'q'             // compare char to 'q'
	B.EQ LL_GET_INPUT_QUIT   // if char is equal to '\0', then jump to label
	
	// Check if char == 'c'
	CMP  W1, #'c'             // compare char to 'q'
	B.NE LL_GET_INPUT_NC     // if char is not equal to '\0', then jump to label
	
	// clear bits buffer
	STR X0, [SP, #-16]!      // push X0 to stack (preserve char pointer value)
	
	LDR X0, =sz_bits_buffer  // move address of bits_buffer to X0
	MOV X1, #0               // move char null terminator into X1
	MOV X2, #17              // move size of bits_buffer into X2
	BL LL_SET                // call LL_SET function
	
	// Reset counter to #15
	MOV X6, #15              // set X6 to 15

	// Restore X0 from stack
	LDR X0, [SP], #16       // pop X0 from stack
	
	B LL_GET_INPUT_SKIP     // jump to label/skip next check
	
LL_GET_INPUT_NC:
	// Check if X7 == 0
	CMP X7, #0               // compare X7 to #0
	B.EQ LL_GET_INPUT_SKIP   // if X7 == #0, jump to label
	
	// Check if char == '1' or == '0'
	CMP W1, #'1'             // compare W0 to #'1'
	B.EQ LL_GET_INPUT_BIT    // if X0 == #'1', jump to label
	
	CMP W1, #'0'             // compare W0 to #'0'
	B.NE LL_GET_INPUT_SKIP   // if X0 != #'0', jump to label
	
LL_GET_INPUT_BIT:	
	// check if counter < 0
	CMP X6, #0               // compare X6 to 0
	B.LT LL_GET_INPUT_SKIP   // if X6 < 0, skip character 
	
	// push value into buffer
	// (placed in reverse order starting from the end of buffer)
	LDR  X4, =sz_bits_buffer // move address of sz_bits_buffer to X4
	STRB W1, [X4, X6]        // store W1 into address of bits_buffer + counter
	
	// update counter
	SUB X6, X6, #1           // subtract 1 to X6
	
LL_GET_INPUT_SKIP:	
	// Increment char pointer
	ADD X0, X0, #1           // add 1 to X0
	
	// Loop to top of loop
	B LL_GET_INPUT_LOOP      // jump to LL_GET_INPUT_LOOP label

LL_GET_INPUT_L_END:

	// Flip bits in bits_buffer **EDIT THIS SECTION !!!
	// set start (X2) and end pointer (X3)
	LDR X2, =sz_bits_buffer  // load address of sz_bits_buffer
	ADD X2, X2, X6           // add X6 (counter) to address (start of buffer)
	LDR X3, =sz_bits_buffer  // load address of sz_bits_buffer
	ADD X3, X3, #15          // add #15 to address (end of buffer minus \0)
	
// start while loop
LL_w_loop:
	// save value of start pointer to X4
	LDRB	W4, [X2]        // load start pointer value ([X2]) to X4
	// save value of end pointer to X5
	LDRB 	W5, [X3]        // load start pointer value ([X3]) to X5
	// swap values of start pointer and end pointer
	STRB	W5, [X2]        // store end pointer value (X5) to start pointer (X2)
	STRB	W4, [X3]        // store start pointer value (X4) to end pointer (X3)
	// increment start pointer
	ADD		X2, X2, #1      // increment start pointer by 1
	// decrement end pointer
	SUB		X3, X3, #1      // decrement end pointer by 1
	// loop while start pointer < end pointer
	CMP		X2, X3          // compare start pointer (X2) to end pointer (X3)
	B.LT	LL_w_loop       // loop if X2 is less than X3
// end while loop

	// Sign extend bits_buffer
	LDR X0, =sz_bits_buffer // set X0 to address of buffer bits
	MOV X1, #'0'            // set X1 to #'0'
	MOV X2, X6              // set X2 to X6 (counter)
	BL LL_SET               // call LL_SET function
	
	// Set return value to address of bits_buffer
	LDR X0, =sz_bits_buffer  // move address of bits_buffer to X0
	B LL_GET_INPUT_END       // jump to end of function
	
LL_GET_INPUT_QUIT:
	// QUIT
	MOV X0, #0               // set X0 to #0
	
LL_GET_INPUT_END:	
	// Restore LR from stack
	LDR LR, [SP], #16        // pop LR from stack
	
	// return from function
	RET // return from function

	.data  // data section
	sz_input_buffer: .skip 66
	sz_bits_buffer:  .skip 17
	
.end  // end of program
