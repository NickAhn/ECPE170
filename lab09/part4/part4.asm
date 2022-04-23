# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	la $s0, A # Load memory address of A
	la $s1, B # Load memory address of B

	addi $t1, $zero, 0 #i = 0
	addi $t2, $zero, 12 # C
	addi $t6, $zero, 0 # set variable to 0 for for loop

	add $t0, $zero, $s0 # store address for array A into t0
	add $t3, $zero, $s1 # store address for array B into t3

	# for(i=0, i<5, i++)
	forloop:
		bge $t1, 5, endloop # if i>=5, branch to endloop
		lw $t4, 0($t3) # load value in B with an offset of 0 into t4
		add $t5, $t4, $t2 # B[i] + C
		sw $t5, 0($t0) # stores t5 into t0, the address of A
		addi $t1, $t1, 1 # i++
		addi $t0, $t0, 4 # adds 4 to address in A
		addi $t3, $t3, 4 # adds 4 to address in B
		j forloop
	endloop:
	
	addi $t1, $t1, -1 #subtract 1 from i ($t1)
	addi $t0, $t0, -4 #subtract 4 from memory address of A	

	# while(i>=0)
	while:
		blt $t1, 0, endwhile # if i<0, branch to endwhile
		lw $t4, 0($t0) #loading value in A with an offset of 0 into t4
		add $t4, $t4, $t4 #add A[i] with A[i] so same as A[i] * 2
		sw $t4, 0($t0) #stores t4 into A[i]
		addi $t0, $t0, -4 #subtract 4 from memory addres2
		addi $t1, $t1, -1 #subtract 1 from i
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
A: .space 20 # Allocate 20 consecutive bytes for 5-element integer word array A
B: .word 1, 2, 3, 4, 5 # Integer words stored in array B
C: