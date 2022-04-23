# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	la $s0, string # load string to s0

	li $v0, 8 # set $v0 to 8 to read_string
	la $a0, string # store mem. address of string input buffer to string
	li $a1, 256 # max ch argument it will take
	syscall #get input

	li $t0, 0 #index

	while: 
		lb $t0, 0($s0) #$s1 = message [i]
		beq $t0, 0, notFound
		beq $t0, 101, found #string[i] == 'e'
		addi $s0, $s0, 1 #address + 1
		j while

	notFound:
		li $v0, 4 #sets v0 to 4 to print_string
		la $a0, eNotFound# load message to a0
		syscall # print nomatchmsg
		j end #end program

	found:
		li $v0, 4 # sets v0 to 4 to print_string
		la $a0, msg1 # load 1st message
		syscall # print msg1

		li $v0, 1 # set v0 to 1 to print_int
		sw $s0, result #save result in memory
		add $a0, $zero, $s0 #load match address
		syscall # print match address

		li $v0, 4 # set v0 to 4 to print_string
		la $a0, msg2 # load msg2 to a0
		syscall # print msg2

	end:

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

string: .space 256 # string[256]
msg1: .asciiz "First match at address "
msg2: .asciiz "\nThe matching character is e"
eNotFound: .asciiz "No match found"
result: .word 0
