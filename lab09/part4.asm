# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	la $s1, A # Load memory address of A
	la $s2, B # Load memory address of B
	li $t0, 0 # i = 0

	# for(i=0, i<5, i++)
	forloop:
		bge $t0, 5, endloop # if i>=5, branch to endloop
		lw $t2, ($s2) # B[i]
		addi $t2, $t2, 12 # B[i] + 12
		sw $t1, ($s1) # A[i] = B[i] + 12

		addi $s1, $s1, 4 # next element of A[i]
		addi $s2, $s2, 4 # next element of B[i]
		addi $t0, $t0, 1 # i++
		j forloop
	endloop:
	
	addi $t0, $t0, -1 # i--
	addi $s1, $s1, -4 # previous element of A[i]
	addi $s2, $s2, -4 # previous element of B[i]

	# while(i>=0)
	while:
		blt $t0, 0, endwhile # if i<0, branch to endwhile
		lw $t2, ($s1) #$t2 = A[i]
		mul $t2, $t2, 2 #A[i] * 2
		sw $t2, ($s1) # A[i] = A[i]*2

		addi $t0, $t0, -1 #i--
		addi $s1, $s1, -4 # previous element of A
		j while
	endwhile:


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
A: .word 0:5 # Allocate 20 consecutive bytes for 5-element integer word array A
B: .word 1, 2, 3, 4, 5 # Integer words stored in array B
C: