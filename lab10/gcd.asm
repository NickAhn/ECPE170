# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:


#n1 = $s0
#call function
#add arguments low and high to registers $a0 $a1
	li a0, 1 # load low to a0
	li a1, 10000 # load high to high
	jal randominrange
	move 


	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"

	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	#funcitons here

randominrange:
	#a0 = low
	#a1 = high
	#t0 = range
	#t1 = rand_num
	#t2 = return value

	# PUSH $ra to stack
	addi $sp, $sp, -4 #adjust stack pointer
	sw $ra, 0($sp) # Save $ra

	# range = high - low + 1
	sub $t0, $a1, $a0 #high - low
	addi $t0, $t0, 1 #adding 1 to range

	# rand_num = get_random()
	jal get_random	# calling get_random()
	move $t1, $v0 # save return value of get_random in $t1

	# get_random() = (rand_num % range) + low
	divu $t1, $t0 # rand_num % range
	mfhi $t2 # move remainder of mod in t3
	add $t2, $t2, $a0 # add low to return value
	move $v0, $t2 # move return value to v0

	# POP from stack
	lw $ra, 0($sp) # Restore $ra
	addi $sp, $sp, 4 # Adjust stack pointer

	# Return
	jr $ra 


# Generate random number
get_random:
	# Register map:
	#  $s0 = Z
	#  $s1 = W

	# PUSH onto stack
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $ra,0($sp)		# Save $ra
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $a0,0($sp)		# Save $a0
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $a1,0($sp)		# Save $a1
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $s0,0($sp)		# Save $s0
	addi $sp,$sp,-4		# Adjust stack pointer
	sw $s1,0($sp)		# Save $s1

	li $t0,36969		# $t0 = constant (36969)
	li $t1,18000		# $t1 = constant (18000)
	li $t2,65535		# $t2 = constant (65535)

	lw $s0,Z		# Load global Z from memory
	lw $s1,W		# Load global W from memory

	and $t3,$s0,$t2		# (Z & 65535)
	mul $t3,$t0,$t3		# 36969 * (Z & 65535)  (only lower 32 bits)
	srl $t4,$s0,16		# (Z >> 16)
	addu $s0,$t3,$t4	# Z = 36969 * (Z & 65535) + (Z >> 16)
	sw $s0,Z		# Save global Z

	and $t3,$s1,$t2		# (W & 65535)
	mul $t3,$t1,$t3		# 18000 * (Z & 65535)  (only lower 32 bits)
	srl $t4,$s1,16		# (W >> 16)
	addu $s1,$t3,$t4	# W = 18000 * (Z & 65535) + (W >> 16)
	sw $s1,W		# Save global W	

	sll $t3,$s0,16		# Z << 16
	addu $t3,$t3,$s1	# (Z << 16) + W
	
	# For demo range 0-99
	
	li $t4, 100
	divu $t3, $t4
	mfhi $t3

	# Return result stored in $v0
	move $v0,$t3

	# POP from stack
	lw $s1,0($sp)		# Restore $s1
	addi $sp,$sp,4		# Adjust stack pointer
	lw $s0,0($sp)		# Restore $s0
	addi $sp,$sp,4		# Adjust stack pointer
	lw $a1,0($sp)		# Restore $a1
	addi $sp,$sp,4		# Adjust stack pointer
	lw $a0,0($sp)		# Restore $a0
	addi $sp,$sp,4		# Adjust stack pointer
	lw $ra,0($sp)		# Restore $ra
	addi $sp,$sp,4		# Adjust stack pointer

	# Return
	jr $ra




	# All memory structures are placed after the
	# .data assembler directive
	.data

	# The .word assembler directive reserves space
	# in memory for a single 4-byte word (or multiple 4-byte words)
	# and assigns that memory location an initial value
	# (or a comma separated list of initial values)
	#For example:
	#value:	.word 12
W:	.word 123
Z:	.word 456