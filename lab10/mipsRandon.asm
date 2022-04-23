#m_w = <choose-initializer>; /* must not be zero */ 
#m_z = <choose-initializer>; /* must not be zero */
#uint32_t get_random()
#{
#   m_z = 36969 * (m_z & 65535) + (m_z >> 16);
#   m_w = 18000 * (m_w & 65535) + (m_w >> 16); 
#   return (m_z << 16) + m_w; /* 32-bit result */
#   }


# uint32_t random_in_range(uint32_t low, uint32_t high)
#{
#uint32_t range = high - low + 1;
#uint32_t rand_num = get_random();

#return (rand_num % range) + low;

#}




.text

	.globl	main
	
	
main:	
	

	jal get_random		
	move $s1,$v0		# Save the random number


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



	
	# Start .data segment (data!)
	.data
W:	.word 123
Z:	.word 456