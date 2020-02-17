.data

#for reading file
filename: .asciiz "input.txt" #name of file
buffer: .space 1600 #reserves a block of 1600 bytes

#for printing array
space: .asciiz " "
newline: .asciiz "\n"
covSet: .asciiz "Covered set is:"

#readInput's datas
ask_element: .asciiz "\nPlease enter the number of element:"
ask_set: .asciiz "\nPlease enter the number of sets(Including union set. The first set will be taken as union):"
write_element: .asciiz "\nEnter the element:"

#Total sets
numberOfSet: .space 4 #1 element
setSizes: .space 44 #11 element
setX: .space 80 #20 element
subset1: .space 80 #20 element
subset2: .space 80 #20 element
subset3: .space 80 #20 element
subset4: .space 80 #20 element
subset5: .space 80 #20 element
subset6: .space 80 #20 element
subset7: .space 80 #20 element
subset8: .space 80 #20 element
subset9: .space 80 #20 element
subset10: .space 80 #20 element


itsct_array: .space 80 #array that is returned by intersection function
dif_array: .space 80 #array that is returned by difference function
.text

.globl main
main:
	#gets the input from user to total sets
	jal readInput
	#runs the algorithm and prints the covered sets
	jal greedy
	move $a0,$v0
	move $a1,$v1
	#exits
	jal exit
	
#a0:main array to intersec.
#a1:main array's size
#one by one, finds the maximum intersecting set and returns it.
returnMaxIntersect:
	addi $sp, $sp, -48 #stack opening
	sw $ra, 44($sp)
	sw $s0, 40($sp)
	sw $s1, 36($sp)
	sw $s2, 32($sp)
	sw $t0, 28($sp)
	sw $t1, 24($sp)
	sw $t2, 20($sp)
	sw $t3, 16($sp)
	sw $t4, 12($sp)	
	sw $t5, 8($sp)
	sw $t6, 4($sp)
	sw $t7, 0($sp)
	
	la $s0,0($a0) #first in all sets(union set)
	la $t0,setX+80
	la $s1,0($a1) #sets size's
	la $t1,setSizes+4
	lw $s2,numberOfSet #total number of sets(including union set)
	addi $s2,$s2,-1#number of set after the remove union set
	li $t2,0 #counter i
	li $t3,0 #for finding max intersect size
	li $t4,0 #for finding max intersect's array
loop_rmi:
	beq $t2,$s2,exit_rmi
	move $a0,$s0 #intersect array1
	move $a1,$t0 #intersect array2
	la $a2,0($s1) #intersect array1 size
	lw $a3,0($t1) #intersect array2 size
	jal intersect
	slt $t7,$t3,$v1 #checks if $v1 > $t3
	bne $t7,1,pass_change #if $v1 < $t3, goes to pass_change
	move $t3,$v1 #maximum intersect's size
	move $t4,$v0 #maximum intersect
	move $t5,$t0 #array of provides maximum intersect
	move $t6,$t1 #array size of provides maximum intersect
pass_change:
	addi $t1,$t1,4
	addi $t0,$t0,80	
	addi $t2,$t2,1
	j loop_rmi
exit_rmi:
	move $a0,$t5
	lw $a1,0($t6)
	jal print_array #prints the intersect array
	
	move $v0,$t4 #return intersect array
	move $v1,$t3 #return intersect size
	
	lw $t7, 0($sp)
	lw $t6, 4($sp)
	lw $t5, 8($sp)
	lw $t4, 12($sp)
	lw $t3, 16($sp)
	lw $t2, 20($sp)
	lw $t1, 24($sp)
	lw $t0, 28($sp)
	lw $s2, 32($sp)
	lw $s1, 36($sp)
	lw $s0, 40($sp)
	lw $ra, 44($sp)
	addi $sp, $sp, 48 #stack closing
	jr $ra

#inputs:setX,setSizes
#performs the algorithm and prints the smallest covering sets
greedy:	
	addi $sp,$sp,-28 #stack opening
	sw $ra,24($sp)
	sw $t0,20($sp)
	sw $t1,16($sp)
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3,0($sp)
	#saves the address of setX and setSizes arrays
	la $s0,setX
	lw $s1,setSizes
greedy_loop:   
	beq $s1,$0,exit_greedy     
	move $a0,$s0
	move $a1,$s1
	#gets the maximum argument of intersects
	jal returnMaxIntersect
	move $t2,$v0
	move $t3,$v1
	#takes difference from the intersect array 
	move $a1,$t2 #max intersect array
	move $a3,$t3 #max intersect array size
	move $a0,$s0 #main array
	move $a2,$s1 #main array size
	jal difference
	#Assigns it to x
	move $s0,$v0
	move $s1,$v1
	j greedy_loop
exit_greedy:
	lw $s3,0($sp)
	lw $s2,4($sp)
	lw $s1,8($sp)
	lw $s0,12($sp)
	lw $t1,16($sp)
	lw $t0,20($sp)
	lw $ra,24($sp)
	addi $sp,$sp,28#stack closing
	jr $ra
	
#reads input from user and initialize the sets			
readInput:
	addi $sp, $sp, -44 #stack opening
	sw $ra, 40($sp)
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $t0, 24($sp)
	sw $t1, 20($sp)
	sw $t2, 16($sp)
	sw $t3, 12($sp)
	sw $t4, 8($sp)
	sw $t5, 4($sp)		
	sw $t7, 0($sp)

	la $s0,setSizes #size array's adress
	la $s1,setX #setX array's adress
	la $s2,numberOfSet #number of sets
	
	la $t0, 0($s0) #for traversing sizes of arrays
	la $t7, 0($s1) #for traversing all of sets
	
	li $v0,4
	la $a0,ask_set
	syscall
	
	li $v0,5
	syscall
	sw $v0,0($s2)
	
	li $t3,0 #counter i
input_loop:
	lw $t2,0($s2)
	beq $t2,$t3,exit_input #if equals number of set then exit_input

	li $v0,4
	la $a0,ask_element
	syscall
	
	li $v0,5
	syscall
	sw $v0,0($t0)
	li $t4,0 #counter j
	move $t1,$t7
	
element_loop:#inner loop
	lw $t5,0($t0)
	beq $t5,$t4,exit_element
	
	li $v0,4
	la $a0,write_element
	syscall
	
	li $v0,5
	syscall
	sw $v0,0($t1)
	
	addi $t4,$t4,1
	addi $t1,$t1,4
	j element_loop
exit_element:
	#inner loop ends
	addi $t0,$t0,4
	addi $t3,$t3,1
	addi $t7,$t7,80
	j input_loop
exit_input:
	#outer loop ends
	#returning setSizes and setX
	la $v0,0($s0)
	la $v1,0($s1)
	
	lw $t7, 0($sp)
	lw $t5, 4($sp)	
	lw $t4, 8($sp)
	lw $t3, 12($sp)
	lw $t2, 16($sp)
	lw $t1, 20($sp)
	lw $t0, 24($sp)
	lw $s2, 28($sp)
	lw $s1, 32($sp)
	lw $s0, 36($sp)
	lw $ra, 40($sp)	
	addi $sp, $sp, 44 #stack closing
	jr $ra
	
	
#reads the whole file then prints and returns file
#v0:returns file's content buffer
readfile:
	##OPEN FILE
	li $v0, 13 #system call for open file
	la $a0, filename #system call input 
	li $a1, 0 #for reading
	li $a2, 0
	syscall 
	move $s0,$v0 #save file descriptor return value from system call
	
	##READ FILE
	li $v0, 14 #system call for read file
	move $a0, $s0 #input file descriptor for system call
	la $a1, buffer #buffer's adress(input)
	li $a2, 400 #buffer length(input length)
	syscall
	
	##PRINT FILE
	li $v0, 1 #system call for print
	la $v0, buffer #returns the read file
	jr $ra
	
#a0:searching array
#a1:searching value
#a2:array size
#searchs the array then if find returns index of value,else returns -1
linear_search:
	addi $sp, $sp, -24 #stack opening
	sw $ra, 20($sp)
	sw $s1, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)	
	
	la $s1, 0($a0)# assigns array1's address to s1 register(LA ASSIGNS THE ADDRESS OF .WORD)
	move $t0, $a1 #searching value
	li $t1, 0 #counter
	move $t2, $a2 #arraysize (LW ASSIGNS THE CONTENT OF .WORD)
loop:	beq $t1, $t2,not_found #if there is not find value
	lw $t3, 0($s1) #s1 register's content assigns to t3 #burda bi sıkıntı olabilir
	beq $t0, $t3,found #if found value and searching value is same then jumps found.
	addi $t1, $t1,1 #counter adds by one
	addi $s1, $s1,4 ##go to next element of array
	j loop 
not_found: 
	li $v0, -1 #returns -1
	j exit_ls
found:	move $v0, $t1 #returns index of found value
	j exit_ls
exit_ls:lw $t3, 0($sp)
	lw $t2, 4($sp)
	lw $t1, 8($sp)
	lw $t0, 12($sp)
	lw $s1, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24 #stack closing
	jr $ra

#a0:array1
#a1:array2
#a2:array1's size
#a3:array2's size
#takes the intersects of two given arrays and returns v0,v1 as array and size	
intersect:
	addi $sp, $sp, -40 #stack opening
	sw $ra, 36($sp)
	sw $s0, 32($sp)
	sw $s1, 28($sp)
	sw $s2, 24($sp)
	sw $s3, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)	
	sw $t4, 0($sp)
	
	la $s0, 0($a0) #sets the s0 to (array1)a0's content
	la $s1, 0($a1) #sets the s1 to (array2)a1's content
	move $s2, $a2 #sets the (a2)array1's size to s2
	move $s3, $a3 #sets the (a3)array2's size to s3
	li $t0, 0 #counter i
	li $t1, 0 #counter j
	li $t4, 0 #for save the array
loop_intersect:
	beq $s2, $t0,exit_intersect
	la $a0, 0($s1) #searching array(array2)
	lw $a1, 0($s0)  #searching value(array1[i])
	move $a2, $s3 #searching array's size(array2Size)
	jal linear_search
	li $t2, -1 #not equal to -1
	bne  $v0, $t2, fill_set
continue_loop:
	addi $t0, $t0, 1 #counter i++
	addi $s0, $s0, 4
	j loop_intersect
fill_set:
	lw $t3,0($s0) 
	sw $t3,itsct_array($t4)
	addi $t1,$t1,1 #counter j++ (size)
	addi $t4,$t4,4
	j continue_loop
exit_intersect:
	la $v0, itsct_array #array returns
	move $v1,$t1 #size returns
	
	lw $t4, 0($sp)
	lw $t3, 4($sp)
	lw $t2, 8($sp)
	lw $t1, 12($sp)
	lw $t0, 16($sp)
	lw $s3, 20($sp)
	lw $s2, 24($sp)
	lw $s1, 28($sp)
	lw $s0, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40 #stack closing
	jr $ra

#a0:array1
#a1:array2
#a2:array1's size
#a3:array2's size
#takes the difference of two given arrays and returns v0,v1 as array and size	
difference:
	addi $sp, $sp, -40 #stack opening
	sw $ra, 36($sp)
	sw $s0, 32($sp)
	sw $s1, 28($sp)
	sw $s2, 24($sp)
	sw $s3, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)	
	sw $t4, 0($sp)
	
	la $s0, 0($a0) #sets the s0 to (array1)a0's content
	la $s1, 0($a1) #sets the s1 to (array2)a1's content
	move $s2, $a2 #sets the (a2)array1's size to s2
	move $s3, $a3 #sets the (a3)array2's size to s3
	li $t0, 0 #counter i
	li $t1, 0 #counter j
	li $t4, 0 #for save the array
loop_difference:
	beq $s2, $t0,exit_difference
	la $a0, 0($s1) #searching array(array2)
	lw $a1, 0($s0)  #searching value(array1[i])
	move $a2, $s3 #searching array's size(array2Size)
	jal linear_search
	li $t2, -1 #not equal to -1
	beq  $v0, $t2, fill_set_dif
continue_loop_dif:
	addi $t0, $t0, 1 #counter i++
	addi $s0, $s0, 4
	j loop_difference
fill_set_dif:
	lw $t3,0($s0) 
	sw $t3,dif_array($t4)
	addi $t1,$t1,1 #counter j++ (size)
	addi $t4,$t4,4
	j continue_loop_dif
exit_difference:
	la $v0, dif_array #array returns
	move $v1,$t1 #size returns
	
	lw $t4, 0($sp)
	lw $t3, 4($sp)
	lw $t2, 8($sp)
	lw $t1, 12($sp)
	lw $t0, 16($sp)
	lw $s3, 20($sp)
	lw $s2, 24($sp)
	lw $s1, 28($sp)
	lw $s0, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40 #stack closing
	jr $ra

#a0:array1
#a1:array2
#a2:array1's size
#a3:array2's size
#takes the union of two given arrays and returns v0,v1 as array and size	
union:
	addi $sp, $sp, -40 #stack opening
	sw $ra, 36($sp)
	sw $s0, 32($sp)
	sw $s1, 28($sp)
	sw $s2, 24($sp)
	sw $s3, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)	
	sw $t4, 0($sp)
	
	move $t1, $a1 #copy from array2(a1) t0 t1
	move $t2, $a3 #copy from array2(a3)'s size to t2
	jal difference
	move $s0, $v0 #loads difference array to s0
	move $s2, $v1 #loads difference array's size to s2
	sll $s1, $s2, 2 #size*4
	add $t0, $s0, $s1 #Moves t0 to the end of the array(v0+size*4)
	li $t3, 0 #counter
loop_union:
	beq $t3, $t2, exit_union
	lw $t7, 0($t1)
	sw $t7,0($t0) #t0'a t1'İ kaydeder
		
	addi $t3,$t3,1 
	addi $t0, $t0, 4
	addi $t1, $t1, 4 
	j loop_union
exit_union:
	add $v1,$t3,$s2 #return array size 
	move $v0,$s0 #return array
	
	lw $t4, 0($sp)
	lw $t3, 4($sp)
	lw $t2, 8($sp)
	lw $t1, 12($sp)
	lw $t0, 16($sp)
	lw $s3, 20($sp)
	lw $s2, 24($sp)
	lw $s1, 28($sp)
	lw $s0, 32($sp)
	lw $ra, 36($sp)
	addi $sp, $sp, 40 #stack closing
	jr $ra
	
#a0:array
#a1:array_size
#Gets the array and size then print the console
print_array:
	addi $sp, $sp, -20 #stack opening
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $t0, 4($sp)
	sw $t1, 0($sp)

	move $s0, $a0 #copy from $a0 to $s0 array
	move $s1, $a1 #copy from $a1 to $s1 array_size
	li $t0, 0 #counter
	
	li $v0, 4
	la $a0, covSet
	syscall
print_loop: #printing loop
	beq $t0, $s1,exit_print
	
	lw $t1, 0($s0)
	li $v0, 1
	la $a0, 0($t1)
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0,$t0,1
	addi $s0,$s0,4
	j print_loop
exit_print:
	li $v0, 4
	la $a0, newline
	syscall

	lw $t1, 0($sp)
	lw $t0, 4($sp)
	lw $s1, 8($sp)
	lw $s0, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20  #stack closing
	jr $ra
	
#exiting function
exit:
    	li $v0, 10
   	syscall 
