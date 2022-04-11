# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	# Z = (A+B) + (C-D) + (E+F) - (A-C);
	# (A+B)
	li $s0, 15 # Load immediate value 15 (A) to s0
	li $s1, 10 # Load immediate value 10 (B) to s1
	add $t0, $s0, $s1 # (A+B)

	# (C-D)
	li $s2, 7 # Load immediate value 7 (C) to s2
	li $s1, 2 # Load immediate value 2 (D) to s1
	sub $t1, $s2, $s1 # (C-D)

	# (E+F)
	li $s1, 18 # Load immediate value 18 (E) to s1
	li $s3, -3 # Load immediate value -3 (F) to s3
	add $t2, $s1, $s3 # (E+F)

	# (A-C)
	sub $t3, $s0, $s2	
	
	# (A+B) + (C-D)
	add $t4, $t0, $t1

	# $t4 + (E+F)
	add $t4, $t4, $t2

	# $t4 - (A-C)
	sub $t4, $t4, $t3

	# Store result to Z
	sw $t4, Z


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
Z: .word 0;
