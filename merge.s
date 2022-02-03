@merge :- merges two sorted lists of strings maintaining the sorting order
@r4 and r5 store the pointers to the sorted operand lists
@r11 and r12 store the no of elements in list 1 and list 2 respectively
@r8: comparison mode
@r9: duplicate removal option
@returns:
@r0 - address of merged list
@r1- size of merged list

.global merge

.extern stringcomp


.text

merge:

stmfd	sp!, {r2-r12,lr}

ldr r10, =Array3		@for storing the merged list

ldr r6, [r4]		@r4 and r5 store the list1 and list2 pointer arrays
ldr r7, [r5]		@r6 and r7 store the current iterator
mov r3, #0			@use r3 for storing size of merged list


loop:
	@ldr r6, [r4, #4]!
	@ldr r7, [r5, #4]!
	cmp r11, #0
	beq laststep1
	cmp r12, #0
	beq laststep2
	mov r0, r6
	mov r1, r7
	bl stringcomp
	cmp r0, #-1
	beq less
	cmp r0, #1
	beq greater
	cmp r0, #0		
	beq equal
	@bl loop

less:
	ldr r1, [r4]			@store the pointer to current string in r10(merged list)
	@str r4, [r10]
	str r1, [r10]
	@ldr r1, [r10, #4]!		@equivalent to add r10, r10, #4 (that is move to the next address (where the next string pointer to a string will be stored))
	add r10, r10, #4 
	ldr r6, [r4, #4]!		@move to the next string in the list
	sub r11, r11, #1			@reduce the size of list by 1
	add r3, r3, #1			@add 1 to the size of merged list
	b loop
	
greater:
		ldr r1, [r5]			@store the pointer to current string in r10(merged list)
		@str r5, [r10]
		str r1, [r10]
		@ldr r1, [r10, #4]!		@equivalent to add r10, r10, #4 (that is move to the next address (where the next string pointer to a string will be stored))
		add r10, r10, #4
		ldr r7, [r5, #4]!		@move to the next string in the list
		sub r12, r12, #1		@reduce the size of list by 1
		add r3, r3, #1			@add 1 to the size of merged list
		b loop

equal:
	cmp r9, #0
	beq rmdup
	@do both the tasks of less and greater, that is, add both the current elements of list 1 and 2 (both are equal), and correspondingly change the sizes of all three lists
	ldr r1, [r4]			@store the pointer to current string in r10(merged list)
	@str r4, [r10]
	str r1, [r10]
	@ldr r1, [r10, #4]!		@equivalent to add r10, r10, #4 (that is move to the next address (where the next string pointer to a string will be stored))
	add r10, r10, #4 
	ldr r6, [r4, #4]!		@move to the next string in the list
	sub r11, r11, #1			@reduce the size of list by 1
	add r3, r3, #1			@add 1 to the size of merged list
	ldr r1, [r5]			@store the pointer to current string in r10(merged list)
	@str r5, [r10]
	str r1, [r10]
    add r10, r10, #4 
	@ldr r1, [r10, #4]!		@equivalent to add r10, r10, #4 (that is move to the next address (where the next string pointer to a string will be stored))	
	ldr r7, [r5, #4]!		@move to the next string in the list
	sub r12, r12, #1		@reduce the size of list by 1
	add r3, r3, #1			@add 1 to the size of merged list
	b loop

rmdup:
	@do both the tasks of less and greater, that is, add both the current elements of list 1 and 2 (both are equal), and correspondingly change the sizes of all three lists
	ldr r1, [r4]			@store the pointer to current string in r10(merged list)
	@str r4, [r10]
	str r1, [r10]
	@ldr r1, [r10, #4]!		@equivalent to add r10, r10, #4 (that is move to the next address (where the next pointer to a string will be stored))
	add r10, r10, #4 
	ldr r6, [r4, #4]!		@move to the next string in the list
	sub r11, r11, #1			@reduce the size of list by 1
	add r3, r3, #1			@add 1 to the size of merged list
	
	@ldr r1, [r10, #4]!		@equivalent to add r10, r10, #4 (that is move to the next address (where the next pointer to a string will be stored))	
	ldr r7, [r5, #4]!		@move to the next string in the list
	sub r12, r12, #1		@reduce the size of list by 1
	b loop


laststep1:		@list 1 size has become 0
		sub r5, r5, #4
		loop1:
			cmp r12, #0
			beq endprog
			ldr r1, [r5, #4]!			@store the pointer to current string in r10(merged list)
			str r1, [r10]				@added this to check if it works now
            add r10, r10, #4 
			sub r12, r12, #1
			add r3, r3, #1			@add 1 to the size of merged list
			b loop1

laststep2:
		sub r4, r4, #4
		loop2:
			cmp r11, #0
			beq endprog	
			ldr r1, [r4, #4]!
			str r1, [r10]				@added this to check if it works now
            add r10, r10, #4 
			sub r11, r11, #1
			add r3, r3, #1			@add 1 to the size of merged list
			b loop2

endprog:
	@ldr r1, [r3]       this cleared my understanding of the address vs contents 
    mov r1, r3
	ldr r0, =Array3
    ldmfd	sp!, {r2-r12,pc}

.data

Array3:	 .space 200		@space for storing array of pointers to strings


.end