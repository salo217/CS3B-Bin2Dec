// Lillian Le
// CS3B - Lab6-1 - getstring function
// 3/5/2026
// The purpose of this assignment is to write a function that gets a
// string input from the console/terminal and test it using a self-made driver.
// Algorithm/Pseudocode:
// 1) Preserve parameters to the stack
// 2) Save max buffer length to another register
// 3) Set parameters to read in input
// 4) Call Linux read() system call to read in input
// 5) Check if last character read in is a next line character
// 5.1) If yes, then change it into a null terminator character
// 5.2) If no, then move the pointer to end of buffer and store null terminator
// 6) Restore pararmeters from stack
// 7) Return from function
// Inputs:    X0 - points to first byte of buffer to receive the string
//            X1 - max length of buffer (including a byte for null terminator)
// Outputs:   X0 - points to first character in input string
// Variables: X2 - max chars read parameter for read()
//            X3 - max length of buffer (including a byte for null terminator)
//            X4 - max length of buffer
//            X8 - Linux system call number parameter for read()

//**********************************************************************
//getstring
//  Function getstring: Will read a string of characters up to a specified length
//  from the console and save it in a specified buffer as a C-String (i.e. null
//  terminated).
//
//  X0: Points to the first byte of the buffer to receive the string.
//      This must be preserved (i.e. X0 should still point to the buffer when
//      this function returns).
//  X1: The maximum length of the buffer pointed to by X0 (note this length 
//      should account for the null termination of the read string (i.e. C-String)
//  LR: Must contain the return address (automatic when BL is used for the call)
//  All AAPCS mandated registers are preserved.
//**********************************************************************
.global getstring // provide program starting address

getstring:
	.EQU STDIN,     0   // standard input
	.EQU STDOUT,    1   // standard output
	.EQU SYS_read,  63  // Linux read()
	.EQU SYS_write, 64  // Linux write()
	.EQU SYS_exit,  93  // exit() supervisor call code

	.text  // code section
	// preserve X0 to the stack
	STR	X0, [SP, #-16]!  // Push address of first byte of buffer (X0) onto stack 
	
	// save max input buffer chars to X3
	MOV X3, X1           // move max length of buffer to X3
	SUB X4, X3, #1       // subtract 1 from max length of buffer, store in X4
	
	// read in input
	MOV X1, X0           // move buffer address into X1
	MOV	X0, STDIN        // file descriptor for stdin
	MOV X2, X4           // max number of chars read by read() in X2
	MOV X8, SYS_read     // Linux read() system call number
	SVC 0                // call Linux to read the string
	
	// Check if last character in input buffer is '\n'
	// if last char is '\n', change to '\0' 
	// else, move pointer and store '\0'
	SUB  X0, X0, #1      // subtract 1 from X0
	LDRB W4, [X1, X0]    // load last char from input buffer
	CMP  W4, '\n'        // compare last char to '\n'
	B.NE gs_not_nl       // if last char is not '\n', then jump to label
	
	STRB WZR, [X1, X0]   // replace last char with null terminator
	B gs_end_fn          // branch to end of function
	
gs_not_nl:	
	// move pointer to end of buffer and store '\0'
	STRB WZR, [X1,X3]    // store null terminator at end of buffer
	
gs_end_fn: 	
	// restore X0 from stack
	LDR	X0, [SP], #16    // Pop X0 from stack
	
	RET // return from function

	.data  // data section

.end  // end of program
