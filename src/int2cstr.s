// Salomon Aquino
// CS3B - lab5-2 int2cstr
// 2/21/2026
// converts a signed integer into a cstring

//*****************************************************************************
// Function int2cstr: Provided a signed integer, will convert it to a C-String 
//                    stored stored in memory pointed to by a provided pointer
//                    that must be large enough to hold the converted value. 
//                    Usually a string of 21 bytes is more than sufficient to allow  
//                    for a sign as well as the largest possible value a word could be.
//
// X0: Contains the binary (signed) value to be converted to a C-String
// X1: Must point to address large enough to hold the converted value.
// LR: Contains the return address (automatic when BL is used)
// Registers X0 - X8 are modified and not preserved
//******************************************************************************

// Algorithm/Pseudocode
//
// Set offset = 0
// do_while:
//      divide current number by 10 and get remainder
//      set current number equal to quotient
//      if remainder is negative:
//          make remainder positive
//      convert remainder to char and store at buffer[offset]
//      increment offset
// add '-' to end of cstring
// reverse the order of cstring
// add null to end of cstring
// return


.global int2cstr	// initialize String_length

int2cstr:	        // define String_length

	.text		    // code section

    MOV X5, #0              // set sign flag = 0
    MOV X3, #0              // set offset = 0
    MOV X7, #10             // set X7 = 10 (constant)
    CMP X0, #0
    B.GE skipSignFlag       // if value is not negative, jump to digitLoop

    MOV X5, #1              // set sign flag if value is negative

    skipSignFlag:

    digitLoop:

    SDIV X6, X0, X7        // divide num by 10 and store quotient
    MSUB X2, X6, X7, X0    // get remainder by using num - (quotient * 10)
    MOV X0, X6              // make num = quotient
    CMP X2, #0              // check if remainder is positive or negative
    B.GE skipNegate         // skip negate if already positive

    NEG X2, X2              // Negate the remainder

    skipNegate: 

    ADD     X2, X2, #'0'    // convert digit to ASCII
    STRB    W2, [X1, X3]    // store char at buffer[offset]
    ADD     X3, X3, #1      // offset++

    CMP X0, #0              // check if quotient = 0
    B.NE digitLoop          // jump to start if not equal to 0



    CMP X5, #1              // check if sign flag = 1
    B.NE skipNegativeSign   // if not, don't add '-' to cstring

    MOV     W2, #'-'        // ASCII '-'
    STRB    W2, [X1, X3]    // store at buffer[offset]
    ADD     X3, X3, #1      // increment offset

    skipNegativeSign:

    SUB X3, X3, #1          // X3 = last used index
    MOV X8, X3              // X8 = right index
    MOV X9, #0              // X9 = left index

    reverse_loop:

    CMP X9, X8              // while left < right
    B.GE reverse_done

    LDRB W10, [X1, X9]      // temp = buf[left]
    LDRB W11, [X1, X8]      // right
    STRB W11, [X1, X9]      // swap
    STRB W10, [X1, X8]

    ADD X9, X9, #1
    SUB X8, X8, #1
    B   reverse_loop

    reverse_done:

    ADD X3, X3, #1          // increment offset
    MOV W2, #0              // get null value
    STRB W2, [X1, X3]       // add null terminator to cstring

    RET		                // return

.end  // end of program
