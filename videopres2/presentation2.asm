# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
    # register map:
    # $t0 = i
    # $t1 = array element
    # $s0 = array address    
    # $s1 = save return value


    li $v0, 1 # set v0 to 1 to print_int
    li $t0, 0 # i = 0
    la $s0, array # load address of array

    # loop to print all values of array
    forloop:
        bge $t0, 5, endloop
        lw $t1, 0($s0) # load array element
        move $a0, $t1

        # print Array[$i] = %i
        li $v0, 4 # set v0 to 4 to print_string
        la $a0, msg1 # print Array[
        syscall

        li $v0, 1 # print_int
        move $a0, $t0 # load i to a0
        syscall

        li $v0, 4 # print_string
        la $a0, msg2 # load "]="
        syscall

        li $v0, 1 # print_int
        move $a0, $t1 # print element in array[i]
        syscall

        la $v0, 4 # print_string
        la $a0, newline
        syscall

        addi $t0, $t0, 1 # i++
        addi $s0, $s0, 4 # go to the next element of array
        j forloop
    endloop:

    #load arguments for function arraySum
    la $a0, array
    li $a1, 5
    jal arraySum
    move $s1, $v0 # move return value to s1

    #print Sum of the array
    li $v0, 4 # print_string
    la $a0, msgSum #"Sum of array is "
    syscall

    li $v0, 1 # print_int
    move $a0, $s1 # print result of arraySum
    syscall



	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"

	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

# args: $a0 = array, $a1 = arraySize
arraySum:
    beq $a1, 0, if
    #else
    addi $sp,$sp,-4		# Adjust stack pointer
	sw $ra,0($sp)		# Save $ra

    lw $t0, 0($a0) # load value of head of the array

    addi $sp, $sp, -4 # Adjust stack pointer
    sw $t0, 0($sp) # save t0

    addi $a0, $a0, 4 # go to next element of array
    addi $a1, $a1, -1 # arraySize-1

    jal arraySum 
    lw $t0, 0($sp) # load *array from stack
    addi $sp, $sp, 4 # Adjust stack pointer
    add $v0, $v0, $t0 #add *array to result

    lw $ra, 0($sp) # load ra from stack
    addi $sp, $sp, 4 # Adjust stack pointer
    jr $ra

    if:
    li $v0, 0 # return value = 0
    jr $ra # end function



	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
	#For example:
	#value:	.word 12
array: .word 2, 3, 5, 7, 11
msg1: .asciiz "Array["
msg2: .asciiz "]="
newline: .asciiz "\n" 

msgSum: .asciiz "Sum of array is "
