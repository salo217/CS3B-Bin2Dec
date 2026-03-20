// Salomon Aquino
// CS3B - lab4-1 putstring 
// 2/7/2026

  //*****************************************************************************
  //putstring
  //  Function putstring: Provided a pointer to a null terminated string in
  //  X0, will output the string on the console
  //
  //  X0: Must point to a null terminated string
  //  LR: Must contain the return address (automatic when BL
  //      is used for the call)
  //  All registers except   X0, X1, X2, X3, and X8 are preserved
  //*****************************************************************************

  //Pseudocode/algorithm:
  //	call String_length to get length of given string
  //	set the string parameter
  //	set number of bytes to write equal to string length
  //	set type = stdout for write call
  // 	set call number equal to write
  //	call syscall
  //	return

.global putstring // initialize putstring

putstring:	// define putstring

    .text   // code section
    
    MOV X3, X0                  // store string pointer before it gets overrided

    STR LR, [SP, #-16]!         // push return address to stack
    BL String_length            // get the string length
    LDR LDR, [SP], #16          // pop return address from stack

    MOV X1, X3                  // load string pointer parameter
    MOV X2, X0                  // set number of bytes to write equal to string length
    MOV X0, #1                  // set type = stdout
    MOV X8, #64                 // set syscall number to write
    SVC 0                       // call syscall

    RET                         // return

.end  // end of program
