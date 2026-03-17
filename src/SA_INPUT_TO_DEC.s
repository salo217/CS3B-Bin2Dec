// Salomon Aquino
// CS3B - Bin2Dec SA_INPUT_TO_DEC
// 3/16/2026

//*****************************************************************************
//SA_INPUT_TO_DEC
//  Function SA_INPUT_TO_DEC: Provided a pointer to a string of binary digits 
//  in X0, will convert the string into a 64-bit signed integer.
//
//  X0: Must point to a null terminated string of '0's and '1's
//  LR: Must contain the return address (automatic when BL is used)
//  Registers X0, X1, X2, X3, and X5 are modified
//*****************************************************************************

//Pseudocode/algorithm:
//  peek at first character
//  if first character is '1', set total to -1 (Negative Baseline)
//  else, set total to 0 (Positive Baseline)
//  skip the first character
//  loop through remaining characters:
//      check if total is about to overflow
//      multiply total by 2
//      convert character to digit and add to total
//  if overflow occurs, set total to 0 and trigger overflow flag
//  return total in X0

.global SA_INPUT_TO_DEC // initialize SA_INPUT_TO_DEC

SA_INPUT_TO_DEC:   // define SA_INPUT_TO_DEC

    .text   // code section

    LDRB W3, [X0]           // peek at the first character
    CMP W3, #0              // check if string is empty
    B.EQ return_zero        // if empty, return 0

    CMP W3, #'1'            // check if first bit is '1'
    B.EQ set_negative       // if so, use negative baseline

    MOV X1, #0              // set positive baseline (0)
    B start_loop            // proceed to loop

set_negative:
    MOV X1, #-1             // set negative baseline (-1)

start_loop:
    ADD X0, X0, #1          // skip the first character
    MOV X5, #2              // set multiplier to 2

main_loop:
    LDRB W3, [X0], #1       // get next character and increment pointer
    CMP W3, #0              // check for null terminator
    B.EQ return_result      // if null, we are done

    // Overflow check: ensure we can safely double the number
    ASR X2, X1, #62         // check if bits 63 and 62 match
    CMP X2, #0              // if both are 0, it is safe
    B.EQ proceed
    CMP X2, #-1             // if both are 1, it is safe
    B.NE overflow_error     // otherwise, overflow will occur

proceed:
    MUL X1, X1, X5          // total = total * 2
    SUB W3, W3, #'0'        // convert ASCII to digit
    ADD X1, X1, X3          // total = total + digit
    B main_loop             // repeat

overflow_error:
    LDR X2, =0x7FFFFFFFFFFFFFFF
    ADDS X2, X2, #1         // force the V (overflow) flag
    MOV X1, #0              // set result to 0
    B return_result

return_zero:
    MOV X1, #0              // handle empty string case

return_result:
    MOV X0, X1              // move result to X0
    RET                     // return

.end // end of program
