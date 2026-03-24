// Lillian Le
// CS3B - Group Project Bin2Dec
// 3/23/26

// Algorithm/Pseudocode:
// 1) Preserve X0 to stack
// 2) LOOP until counter (X2) is less than or equal to 0
// 2.1) Store X1 at address of pointer (X0)
// 2.2) Increment pointer
// 2.3) Decrement counter
// 3) Restore X0 from stack
// 4) Return from function

//**********************************************************************
//LL_SET
// Function LL_SET: this function sets a specified number of characters in
// memory to a specified character. Returns the address of first byte set
// 
// Parameters
// X0 : address of first byte to set
// X1 : character to set
// X2 : number of characters to set
// Register X2 is modified
//**********************************************************************
.global LL_SET // provide function starting address

LL_SET:
	.EQU STDIN,     0   // standard input
	.EQU STDOUT,    1   // standard output
	.EQU SYS_read,  63  // Linux read()
	.EQU SYS_write, 64  // Linux write()
	.EQU SYS_exit,  93  // exit() supervisor call code

	.text  // code section
	// Preserve X0 to stack
	STR X0, [SP,#-16]!      // push X0 onto stack
	
	// Loop while X2 != 0
LL_SET_LOOP:	
	// Check if X2 <= 0
	CMP X2, #0              // compare X2 to #0
	B.LE LL_SET_LOOP_END    // jump to LL_SET_LOOP_END if equal to #0
	
	// Store W1 at address of X0
	STRB W1, [X0]           // store byte at W1 into address of X0
	
	// Increment X0 (pointer)
	ADD X0, X0, #1          // add #1 to X0
	
	// Decrement X2 (counter)
	SUB X2, X2, #1          // subtract #1 from X2
	
	// Loop to top of loop
	B LL_SET_LOOP           // jump to LL_SET_LOOP label
	
LL_SET_LOOP_END:

	// Restore X0 from stack
	LDR X0, [SP], #16       // pop X0 from stack
	
	// return from function
	RET // return from function

.end  // end of program
