@string comparison function
@it takes in r0, r1, r2 as parameters with
@r0=address of first string
@r1=address of second string
@r2=address where comparison mode is stored 
@Result: Returns the following value in r0:
@		0 : if both strings are equal
@		1:  if 1st string is greater 
@		-1: if 1st string is lesser


.global stringcomp

.extern atoi

.text

stringcomp:

stmfd	sp!, {r1-r9,lr}
@string comparison

mov r6, lr		@save the value of lr

@preserve the values of r0, r1
mov r3, r0
mov r4, r1

@checking what is the comparison mode
@ldrb r7, [r2, #0]
mov r0, r2
bl atoi
@mov r8, #0
@sub r7, r7, #'0'		@use atoi to convert input string(since fgets takes input as string) to integer
cmp r0, #0
beq compmode0	@if the comparison mode is 0, then directly branch to comparison else proceed to conversion


@for case insensitive mode we need to first convert both strings to lowercase and then compare like case sensitive

@initialising r7 and r8 according to the loop
ldrb r7, [r0, #-1]!
ldrb r8, [r1, #-1]!

@loop for changing uppercase to lowercase in string1
loop:
	ldrb r7, [r0, #1]!
	mov r5, #'a'
	cmp r7, #0x0D		@checking if string1 has reached its end
	beq loop1		@if yes then move to string2
	cmp r7, r5		@checking if the current character is uppercase or not
	bge loop		@if not then continue
	add r7, r7, #32		@if yes then change it to lowercase
	strb r7, [r0, #0]
	bl loop 

@loop for changing uppercase to lowercase in string2
loop1:
	ldrb r8, [r1, #1]!
	mov r9, #'a'
	cmp r8, #0x0D		@checking if string2 has reached its end
	beq compmode0		@if yes then move to comparison
	cmp r8, r5		@checking if the current character is uppercase or not
	bge loop1		@if not then continue
	add r8, r8, #32		@if yes then change it to lowercase
	strb r8, [r1, #0]
	bl loop1		


@comparison of strings

compmode0:

@initialising r7 and r8 according to the loop
ldrb r7, [r3, #-1]!
ldrb r8, [r4, #-1]!

cmpfun:

ldrb r7, [r3, #1]!
ldrb r8, [r4, #1]!
cmp r7, r8		@comparing corresponding characters in the string 1 and string 2
beq eq			@if they are equal then move to further checkpoints
bgt greater		@else if any one is greater then return the value accordingly
blt less

greater:	
	@control comes here only if 1st string is greater 
	mov r0, #1
	ldmfd	sp!, {r1-r9,pc}
	@mov pc, lr		@return control to main file

less:
	@control comes here only if 1st string is lesser
	mov r0, #-1
	ldmfd	sp!, {r1-r9,pc}
	@mov pc, r6		@return control to main file

eq: 
	@control comes here only if both strings are equal
	cmp r7, #0x0D		@checking if string1 has reached its end 
	beq eq1			@if yes then move to further checkpoints
	bl eq2   		@else move to further checkpoints
eq1:
	cmp r8, #0x0D		@checking if string 2 has reached its end knowing that 1st string has reached its end
	beq eq3			@if yes then both strings are equal so return the value accordingly
	bl less 		@else string 1 is lesser so return the value accordingly
eq2:
	cmp r8, #0x0D		@checking if string 2 has reached its end knowing that 1st string has not reached its end
	beq greater  		@if yes then string 1 is greater so return the value accordingly
	bl cmpfun		@else continue comparison
eq3:
	@if both the strings are equal
	mov r0, #0
	ldmfd	sp!, {r1-r9,pc}
	@mov pc, r6		@return control to main file
@program termination
ldmfd	sp!, {r1-r9,pc}
@mov pc, r6
@mov r0, #0x18
@mov r1, #0
@swi 0x123456
.data

.end