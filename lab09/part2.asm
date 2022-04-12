# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:

    lw $s0, A # Load A to s0
    lw $s1, B # Load B to s1
    lw $s2, C # Load C to s2

    #if(A>B || C < 5)
    bge $s0, $s1, if # if A > B jump to if. Or
    blt $s2, 5, if # if C < 5 jump to if

    # else if((A > B) && ((C+1) == 7))
    elif:
        ble $s0, $s1, else # if A <= B, jump to else
        addi $t1, $s2, 1 #adding 1 to C
        bne $t1, 7, else # if ~(A == 7), jump to else
        li $t0, 2 # Load immediate 2 to t0
    j endif # end if statement

    else:
        li $t0, 3 # Load immediate 3 to $t0
        j endif # end if statement
        
    if:
        li $t0, 1 # Load 1 to t0
        j endif # end if statement


    endif:    

    #Switch Case
    beq $t0, 1, one # if t0 == 0
    beq $t0, 2, two # if t0 == 2

    #default
    li $t0, 0 # Z = 0
    j done # jump to done

    # case 1
    one:
    li $t0, -1 # Z = -1
    j done # jump to done

    # case 2
    two: 
    li $t0, -2 # Z = -2
    j done # jump to done

    #done with Switch/case statements. Assign t0 to Z and end program
    done: 
    sw $t0, Z
	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"

	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
	#For example:
	#value:	.word 12
A: .word 10
B: .word 15
C: .word 6
Z: .word 0
