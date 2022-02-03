
.extern stringcomp
.extern fgets, frpints, atoi, merge, mergesort



.text

ldr r4, =inpspace1	
ldr r5, =inpspace3
ldr r8, =inpspace5
ldr r9, =inpspace6

@print the prompt for inputting no of strings in list
mov r0, #1
ldr r1, =prompt1

bl fprints

@input the no of strings in list
mov r0, r4
mov r1, #2
mov r2, #0

bl fgets

bl atoi		@convert the inputted ascii string to integer

cmp r0, #0
ble invalidinp

mov r3, r0	@saving the value of the no of strings 
mov r11, r0	@saving the value of the no of strings 

@print the newline
mov r0, #1
ldr r1, =newline

bl fprints


@print the prompt for inputting the strings in list1
mov r0, #1
ldr r1, =prompt2

bl fprints

ldr r10, =Array1
@Initialising parameters for taking input
mov r0, r5

@inputting strings in list 
inpstrl1:
		mov r1, #100
		mov r2, #0
		bl fgets	
		str r0, [r10]
		mov r1, r0
		bl strlen
		add r0, r1, r0
		add r0, r0, #1	@adding 1 to accomodate for the terminating null character
		add r10, r10, #4	@as each address is of 4 bytes
		sub r3, r3, #1	@decreasing the no of remaining strings by 1 
		cmp r3, #0
		bne inpstrl1




@print the prompt for inputting comparison mode
mov r0, #1
ldr r1, =prompt3

bl fprints

@input the comparison mode
mov r0, r8
mov r1, #2
mov r2, #0

bl fgets

bl atoi		@convert the inputted ascii string to integer

mov r8, r0	@saving the value of the comparison mode

@print the newline
mov r0, #1
ldr r1, =newline

bl fprints

@print the prompt for inputting duplicate removal mode
mov r0, #1
ldr r1, =prompt4

bl fprints

@input the duplicate removal mode
mov r0, r9
mov r1, #2
mov r2, #0

bl fgets

bl atoi		@convert the inputted ascii string to integer

mov r9, r0	@saving the value of the comparison mode

@print the newline
mov r0, #1
ldr r1, =newline

bl fprints

@after this r8 and r9 store the comparison mode and the duplicate removal mode respectively



ldr r2, =Array1     @r2 stores the pointer to the first string in list 1
mov r3, r11         @storing the value of no of strings in unsorted list
mov r4, #0          @counter



bl mergesort        @calling the mergesort function to sort the list



    
@setting parameters to print the merge sorted list
mov r3, r1
mov r10, r0


@print the prompt to print all elements of merged list
mov r0, #1
ldr r1, =prompt7

bl fprints

loopfinal:		@to print the elements of merged list
		cmp r3, #0
		beq terminate
		mov r0, #1
		ldr r1, [r10]
		add r10, r10, #4
		bl fprints
		@print the newline
		mov r0, #1
		ldr r1, =newline
		bl fprints

		sub r3, r3, #1
		b loopfinal
	





terminate:
	@program termination
		mov r0, #0x18
		mov r1, #0
		swi 0x123456


invalidinp:
	@print the prompt for invalid input
		mov r0, #1
		ldr r1, =prompt8
		bl fprints
	b terminate

.data

@ I have taken the maximum length of string to be 32 bytes here, this can be initialised to anything as per the need
inpspace1: .space 2			@space for storing unsorted list size
inpspace2: .space 2		@space for storing unsorted list
inpspace3: .space 100		    @space for storing list1
inpspace4: .space 100	    	@space for storing list2
inpspace5: .space 2		    @space for storing comparison mode
inpspace6: .space 2		    @space for storing duplicate removal mode

Array1:  .space 100		@space for storing array of pointers to strings

@ Prompt Messages

newline:   
	   .asciz "\n"

prompt1:  
	   .asciz "Please Enter the No of Strings in List\n"
prompt2:  
	   .asciz "Please Enter the Strings in List\n"
prompt3:  
	   .asciz "Please Enter the Comparison Mode (0 for case sensitive and 1 for case insensitive)\n"
prompt4:
		.asciz "Please Enter the Duplicate Removal Option (0 for yes and 1 for no) \n"
prompt7:  
	   .asciz "Printing all elements of sorted list\n"
prompt8:  
	   .asciz "\nInvalid Input\n"	




.end