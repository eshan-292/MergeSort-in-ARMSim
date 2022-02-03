# MergeSort-in-ARMSim
A program in ARM assembly language for arranging a sequence of character strings in dictionary order


# **Introduction**
The program sorts an unsorted list using the mergesort algorithm. The main function handles the input output and calls the mergesort function to perform the sorting operation. The mergesort function takes pointers to the unsorted operand list of strings, size of the list, comparison mode (case sensitive or insensitive) and a duplicate removal option as parameters and returns the pointer to the sorted list as well as its size. 


## **Running Instructions**:
First load the main.s, mergesort.s, merge.s, stringcomparison.s and UsefulFunctions.s files together. Then run the main.s file. Write the strings in the list (press enter to indicate the end of each string), sizes of the two lists , comparison mode, and duplicate removal option (don’t press enter after typing the number), as you are prompted for. After this , the program would output the contents of the sorted list.


### **NOTE-1**:
I am using a mac machine (I have installed ARMSim on Windows using Parallels), so in order to run my code on a windows machine, you will have to replace cmp r0,0x0D in the fgets code by cmp r0, #’\n’ and cmp r0,0x0A by cmp r0, #’\r’ to make it work. (as my system gives 0x0D code on pressing RETURN key).

### **NOTE-2**:
Also I have used AngelSWI operations, and therefore enabled them in preferences (enabling both Angel and Legacy operations leads to ambiguous behaviour, so while running the code please ensure that only AngelSWI operations are enabled in preferences).


### **NOTE-3**:
Design Decision:- There were two choices to implement reallocation of space. I decided to implement the first model, wherein the caller (mergesort function in this case ) does the reallocation of space instead of the callee (merge function in this case). I chose this to preserve the generality of the merge function, so that it can be used elsewhere too.


# **Brief Description of Code**
The program invokes fgets and fprints functions from the UsefulFunctions.s file for performing input and output operations. For string comparison, it uses the stringcomparison function defined in the stage-1. The mergesort function recursively sorts the two halves of a list (left and right), and merges them (using the merge function from stage-2) to obtain the final sorted list. This goes on until both the halves are left with 1 element each, at this stage we simply merge these two 1 element lists. Also after calling the merge function (which returns a new list), I have reallocated the space of the two halves by storing the new sorted list in that space (effectively sorting in place). I have taken care of the case when user inputs invalid size for the list by prompting the user and thereby gracefully terminating the program (to avoid crashes). For more detailed description of each statement and the implementation, please look at the comments in the code.


## Description of merge function
The merge function iterates over the two lists simultaneously, comparing current strings in both the lists, adding the lesser of the two (say in list X) into the merged list, and moving the iterator forward for the list X. For the case when both the strings are equal, if the duplicate removal option is selected, then one of the equal strings is added to the merged list, and the iterators of both the lists are moved forward. If the duplicate removal option is not selected, then both the equal strings are added and their iterators moved forward. As soon as one of the list becomes empty, the remaining contents of the other list are added as it is to the merged list (this works because both the lists are already sorted)


## Description of stringcomp function
For string comparison, the function stringcomp compares the strings character by character, till it finds one to be greater, or else they are equal (if every character is same in both). For the case insensitive comparison, my program first converts all the uppercase characters into lowercase characters (in both the strings) and then compares the strings just like the case sensitive comparison.
