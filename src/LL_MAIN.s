// Lillian Le
// CS3B - Group Project Bin2Dec
// 3/23/26
// Bin2Dec Program: The Bin2Dec program will __
// Algorithm/Pseudocode:
// 1) LOOP until 'q' is entered
// 1.1) Call LL_GET_INPUT (only 1, 0, q, c, and ENTER as valid characters)
// 1.2) If return value equals #0, then jump to QUIT
// 1.3) Call SA_INPUT_TO_DEC
// 1.4) Call SA_PRINT_COMPLETE_LINE
// 1.5) Call LL_GET_INPUT (only q, c, and ENTER as valid characters)
// 1.6) If return value equals #0, then jump to QUIT
// 1.7) Loop to top of loop
// 2) QUIT
// 2.1) Call SA_CLEAR_LINE
// 2.2) Terminate program


.global _start // provide program starting address

_start:
	.EQU STDIN,     0   // standard input
	.EQU STDOUT,    1   // standard output
	.EQU SYS_read,  63  // Linux read()
	.EQU SYS_write, 64  // Linux write()
	.EQU SYS_exit,  93  // exit() supervisor call code

	.text  // code section
MAIN_LOOP:
	// Call LL_GET_INPUT
	BL LL_GET_INPUT          // jump to LL_GET_INPUT function
	
	// If X0 == #0, jump to MAIN_QUIT label
	CMP X0, #0               // compare X0 (return value) to #0
	B.EQ MAIN_QUIT           // jump to MAIN_QUIT if equal to #0
	
	// Preserve X0 to the stack
	STR X0, [SP,#-16]!       // push X0 onto stack
	
	// Call SA_INPUT_TO_DEC
	BL SA_INPUT_TO_DEC       // jump to SA_INPUT_TO_DEC function
	
	// Call SA_PRINT_COMPLETE_LINE
	LDR LR, [SP], #16        // pop X0 from stack into X1 (set pointer to binary)
	MOV X2, =sz_arrow_buffer // set X2 to pointer to arrow buffer
	MOV X3, =sz_dec_buffer   // set X3 to pointer to decimal buffer
	
	BL SA_PRINT_COMPLETE_LINE // jump to SA_PRINT_COMPLETE_LINE function
	
	// Call LL_GET_INPUT (set for only q,c, and ENTER as valid chars)
	MOV X0, #0               // set X0 to #0
	BL LL_GET_INPUT          // jump to LL_GET_INPUT function

	// If X0 == #0, jump to MAIN_QUIT label
	CMP X0, #0               // compare X0 (return value) to #0
	B.EQ MAIN_QUIT           // jump to MAIN_QUIT if equal to #0
	
	// Loop to top of MAIN_LOOP
	B MAIN_LOOP              // jump to top of loop
	
MAIN_QUIT:
	// Call SA_CLEAR_LINE
	BL SA_CLEAR_LINE         // jump to SA_CLEAR_LINE function
	
	// Terminate the program
	MOV X0, #0               // set return code to 0
	MOV X8, #SYS_exit        // set exit() supervisor call code 
	SVC 0                    // call Linux to exit

	.data  // data section
	sz_arrow_buffer: .asciz "->"
	sz_dec_buffer:   .skip  7
	
.end  // end of program
