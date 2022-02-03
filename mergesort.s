@mergesort - takes in an unsorted list and returns the sorted list
@r2 stores the pointer to the first string in the unsorted list
@r3 stores the number of strings in the list
@r8 stores the comparison mode
@r9: stores the duplicate removal option
@returns  r0 - address to the first string in the sorted list
@         r1- size of the sorted list


.global mergesort

.extern stringcomp
.extern fgets, frpints, atoi, merge



.text


mergesort:
   stmfd	sp!, {r2-r12,lr}        @preserving the contents of the register by pushing into the stack
    mov r3, r3, ASR #1      @division by 2 so that r3 now stores the length of the first string
    @sub r4, r3, #1      
    mov r7, #4
    mul r4, r3, r7
    add r5, r2, r4          @now r5 stores the pointer to the first string of list 2
    sub r6, r11, r3         @r6 stores the no of remaining strings which is equal to the length of list 2
    cmp r3, #1              @checking if only a single element is left in the left half of the list
    beq equal1
    mov r11, r3
    bl mergesort
    equal1:
    cmp r6, #1     @checking if only a single element is left in the right half of the list
    beq equal2
    mov r10,r2     @preserving the values of r2 and r3
    mov r12,r3
    mov r2,r5      @setting up the values of r2 and r3 for mergesort
    mov r3,r6
    mov r11, r6
    bl mergesort
    mov r2, r10
    mov r3, r12
    equal2:         @control reaches here only when both the left and the right halves of the list are sorted
        
        mov r4, r2      
        mov r11,r3
        mov r12, r6 
        
        bl merge        @merge the sorted lists
       
        mov r8, r0      @preserving the value of r0 and r1 as it is to be returned
        mov r9, r1    
        mov r10, r2     @preserving the value of r2  
        sub r0, r0, #4
        
        replace:        @loop for storing the merged list back into the addresses where the two lists were                 @not optimised for duplicate removal case
            ldr r7, [r0, #4]!
            str r7, [r2]
            add r2, r2, #4
            sub r1, r1, #1      @reduce the size of merged sorted list by 1 (used as an iterator)
            cmp r1, #0
            bne replace
        mov r12, r0     @preserving the current position (iterator) in the list
        mov r0, r8      @restoring the preserved values
        mov r1, r9
        mov r2, r10

        add r11, r3, r6     @storing the number of elements in the unsorted list into r11
       
        @correcting the value of r5  
        mov r7, #4
        mul r4, r3, r7
        add r6, r2, r4          
        ldr r7, [r6]            @use this ldr str combination to transfer values stored in registers
        str r7, [r5]


        cmp r11, r1         @checking if size of sorted list is equal to that of unsorted list
        bne unequal


    ldmfd	sp!, {r2-r12,pc}        @restoring the contents of the registers

    unequal:                   @loop to store the remaining addresses with empty strings
        sub r11, r11, r1        @now r11 has the no of iterations to be performed
        @add r12, r12, #4        @r12 has the current pointer 
        ldr r7, =emptystring
        str r7, [r12, #4]!
        sub r11, r11, #1        @decreasing the number of lists remaining by 1
        cmp r11, #0
        bne unequal
        ldmfd	sp!, {r2-r12,pc}        @restoring the contents of the registers

  

.data 
    emptystring: 
            .asciz ""