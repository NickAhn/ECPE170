# A Stub to develop assembly code using QtSPIM

	# Declare main as a global function
	.globl main 

	# All program code is placed after the
	# .text assembler directive
	.text 		

# The label 'main' represents the starting point
main:
	lw $t0, Z # Loading Z to t0 (int Z=2)
	lw $t1, i # Loading I to t1 (int i=0)

	while: #while(1)
		bgt $t1, 20, dowhile #if(i>20), end loop and go to dowhile
		addi $t0, $t0, 1 #Z++
		addi $t1, $t1, 2 #i+=2
		j while #jump back to while

	dowhile:
		addi $t0, $t0, 1 #Z++
		blt $t0, 100, dowhile # while(Z<100), jump back to dowhile
	
	#while(i>0)
	whiletwo:
		ble $t1, 0, exit # if i<0, end loop and go to exit
		addi $t0, $t0, -1 #Z--
		addi $t1, $t1, -1 #i--
		j whiletwo
	
	exit:
	
	sw $t0, Z # save value of t0 to Z
	sw $t1, i # save value of t1 to i



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

Z: .word 2
i: .word 0