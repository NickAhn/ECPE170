# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	# $s0 = i
	# $s1 = n1
	# $s2 = n2
	li $s0, 0 # int i = 0

	loop:
		bge $s0, 10, endloop
		#n1 = $s1
		#n2 = $s2
		
		# n1 = random_in_range(1,10000);
		li $a0, 1 # load low to a0
		li $a1, 10000 # load high to high
		jal randominrange
		move $s1, $v0 # move return value of randominrange to t1

		# n2 = random_in_range(1,10000)
		li $a0, 1 # load low to a0
		li $a1, 10000 # load high to high
		jal randominrange
		move $s2, $v0 # move return value of randominrange to t1

		# print " G.C.D of "
		li $v0, 4 # set v0 to 4 to print_string
		la $a0, msg1
		syscall 

		# print n1
		li $v0, 1 # set v0 to 1 to print_int
		move $a0, $s1 #load n1 to a0
		syscall

		# print " and "
		li $v0, 4 # set v0 to 4 to print_string
		la $a0, msg2
		syscall 

		# print n2
		li $v0, 1 #set v0 to 1 to print_int
		move $a0, $s2 # load n2 to a0
		syscall

		# print "is"
		li $v0, 4 # set v0 to 4 to print_string
		la $a0, msg3
		syscall

		# print gcd(n1,n2)
		move $a0, $s1 # load n1 to a0
		move $a1, $s2 # load n2 to a1
		jal gcd
		move $a0, $v0 # moving return value of gcd to a0
		li $v0, 1
		syscall

		# print period
		li $v0, 4 # set v0 to 4 to print_string
		la $a0, period

		addi $s0, 1 # i++
		j loop # jump back to loop

	endloop:

	# Exit the program by means of a syscall.
	# There are many syscalls - pick the desired one
	# by placing its code in $v0. The code for exit is "10"
	li $v0, 10 # Sets $v0 to "10" to select exit syscall
	syscall # Exit

	#funcitons here

randominrange:
	#a0 = low
	#a1 = high
	#t7 = range
	#t1 = rand_num
	#t2 = return value

	# PUSH $ra to stack
	addi $sp, $sp, -4 #adjust stack pointer
	sw $ra, 0($sp) # Save $ra
	addi $sp, $sp, -4 # Adjust Stack Pointer
	sw $a0, 0($sp) # save a0

	# range = high - low + 1
	sub $t7, $a1, $a0 #high - low
	addi $t7, $t7, 1 #adding 1 to range

	# rand_num = get_random()
	jal get_random	# calling get_random()
	move $t1, $v0 # save return value of get_random in $t1

	# POP a0
	lw $a0, 0($sp) # restore a0
	addi $sp, $sp, 4 # adjust stack pointer

	# get_random() = (rand_num % range) + low
	divu $t1, $t7 # rand_num % range
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


gcd:
	# n1 = a0
	# n2 = a1
	# PUSH from stack
	addi $sp, $sp, -4 # Adjust Stack Pointer
	sw $ra, 0($sp) # Save $ra

	beq $a1, 0, else 
		divu $a0, $a1 # n1 % n2
		mfhi $a0 # move remainder of mod to a1
		move $t0, $a0 
		move $a0, $a1 # making first argument = n2
		move $a1, $t0 # move t0 to a1
		jal gcd # gcd(n2, n1%n2)
		j endif

	else:
		move $v0, $a0 # move value of a0 to v0	
	endif:
		# POP from stack
		lw $ra, 0($sp) # Restore $ra
		addi $sp, $sp, 4 # Adjust Stack Pointer

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
W:	.word 50000
Z:	.word 60000
msg1: .asciiz "\n G.C.D of "
msg2: .asciiz " and "
msg3: .asciiz " is "
period: .asciiz "."