TITLE Project 6A			(Project06.asm.asm)

; Author: L. Herrick
; Assignment Number: Assignment 06
; Assignment Due Date: 6/07/15
; Program Description:  Uses concepts of utilizing the stack,
;						and implementing procedures and macros.
;						Displays introduction and instructions.
;						Prompts the user to enter 10 numbers that
;						would fit in a 32-bit register.  Gets the
;						user input through the getString MACRO.  
;						Validates that the user has entered valid 
;						numbers per program requirements. Converts
;						the input strings into integers.  Finds
;						the sum and average of the input numbers.
;						Converts input numbers, sum number, and 
;						average number into strings.  Displays
;						all number strings to the console.
; Date Created: 5/26/15
; Last Modification Date: 6/4/15

INCLUDE Irvine32.inc

; constants and macros
MAX_SIZE = 11
SDIV	= 10

;------------------------------------------------------
; getString MACRO varName: strAddress
;
; Reads string from input using Irvine's WriteString 
; procedure.
; Receives: the address of the variable to store string
;------------------------------------------------------
getString	MACRO	saveADDRESS, sizeOf
	push	ecx						; save ecx reg
	push	edx						; save edx reg
	mov		edx, saveADDRESS
	mov		ecx, sizeOf
	call	ReadString
	pop		edx						; restore edx
	pop		ecx						; restore ecx
ENDM


;------------------------------------------------------
; displayString MACRO varName: strAddress 
;
; Writes string to the console using Irvine's 
; WriteString procedure.
; Receives: the address of the string. 
;------------------------------------------------------
displayString	MACRO	strAddress
	push	edx						;save the edx reg
	mov		edx, strAddress
	call	WriteString				; write praram to console
	pop		edx						; restore edx
ENDM


;------------------------------------------------------
; doubleCRLF MACRO 
;
; calls carriage return line feed twice
;------------------------------------------------------
; MACRO for double crlf
doubleCRLF	MACRO
	call	CrLf
	call	CrLf
ENDM


.data

; variables used in the program
intro		BYTE	"'Strings to Ints to Strings'	by Lynn Herrick", 0
instruct1	BYTE	"***Instructions: ",0
instruct2	BYTE	"Input ten unsigned digits.  The digits must be within the limit ",0
instruct3	BYTE	"of a 32-bit reg.***",0
prompt_num	BYTE	"Please enter an digit: ",0
errorMess	BYTE	"Error: number is not unsigned, too large, or not a digit.",0
numsHead	BYTE	"Input Numbers: ",0
sumHead		BYTE	"Sum: ",0
avgHead		BYTE	"Average: ",0
spaces		BYTE	", ",0
tempWord	BYTE	10 DUP (?)
tempNum		DWORD	?
extraCalcs	DWORD	0
inputArray	DWORD	10 DUP (?)
inputCount	DWORD	0


.code
main PROC

; introduce program and instructions
	displayString	OFFSET intro			;address of intro as param
	doubleCRLF
	displayString	OFFSET instruct1		; address of instruct1 as param
	displayString	OFFSET instruct2		; address of instruct2 as param
	displayString	OFFSET instruct3		; address of instruct3 as param
	doubleCRLF

; get 10 valid integers from user and store them in an array
	push	OFFSET errorMess
	push	OFFSET inputArray
	push	OFFSET tempNum
	push	MAX_SIZE
	push	OFFSET tempWord
	push	inputCount
	push	OFFSET prompt_num
	call	ReadVal

; display the integers, their sum, and their average
	push	OFFSET spaces
	push	OFFSET avgHead
	push	OFFSET sumHead
	push	OFFSET numsHead
	push	extraCalcs
	push	OFFSET inputArray
	push	tempNum
	push	OFFSET tempWord
	push	inputCount
	call	WriteVal

	exit		; exit to operating system
main ENDP



; ***************************************************************
;Procedure: gets and read 10 string representations of numbers 
;			input by a user, convert them to integers and store 
;			them in an array. Uses getString MACRO.
;receives:  Must have an error message, the address of an
;			empty array, the address to store a temp number, 
;			the max size of digits allowed in a single number, 
;			the address to store a temp string, a counter for 
;			numbers a user should enter, and an address to a 
;			string prompt describing what the user should input 
;			all on the stack.
;returns:	user input in variable inputArray
;preconditions: none
;registers changed: al, edx, ebx, eax, ecx, edi, esi 
; ***************************************************************
ReadVal		PROC
	push	ebp								; preserve stack
	mov		ebp, esp
	mov		edi, [ebp+28]					; edi is pointing to inputArray

getNum:
	displayString	[ebp+8]					; prompt_num is param
	mov		eax, [ebp+20]					; MAX_SIZE is in eax
	inc		eax								; inc for error validation purposes
	mov		edx, [ebp+16]
	getString	edx, eax					; address of tempWord and padded size as params

validate1:		
	call	strLength						; validate number isn't too large for 32-bit reg (10- chars)
	.IF		eax > [ebp+20]
		jmp error
	.ENDIF

	mov		ecx, eax						; length of input string is now in ecx
	mov		esi, [ebp+16]					; esi is pointing to tempWord
	xor		eax, eax						; clear reg

clearTemp:	
	mov		ebx, [ebp+24]					; address of tempNum in ebx
	mov		eax, [ebx]
	mov		ebx, 0							; set 10ths place back to 0
	mul		ebx								; adjust position in tempNum
	mov		ebx, [ebp+24]
	mov		[ebx], eax						; you are now at the start of tempNum, rewrite
	mov		eax, 0				
	mov		ebx, [ebp+24]					; address of tempNum in ebx
	add		[ebx], eax						; rewrite val of tempNum to 0

calculate:									; start of inner loop
	mov		ebx, [ebp+24]
	mov		eax, [ebx]
	mov		ebx, 10
	mul		ebx								; adjust position in tempNum
	mov		ebx, [ebp+24]
	mov		[ebx], eax
	LODSB									; move single byte into al reg
	sub		al, 48							; ascii char to digit

validate2:									; validate string has only digits
	.IF al > 9
		jmp error							; not a digit, jump to error message
	.ENDIF

transfer:
	mov		ebx, [ebp+24]
	add		[ebx], al						; move digit in al into tempNum
	mov		eax, [ebx]
	loop	calculate						; loop back, still building digit

validate3:									; is digit > 2147483647 
	.IF	CARRY?
		jmp error
	.ENDIF
	
	mov		[edi], eax						; tempNum is element in inputArray
	mov		eax, 4
	add		edi, eax						; increment edi to point to next dword
	mov		eax, [ebp+12]					; inputCount in eax
	inc		eax
	mov		[ebp+12], eax

	.IF  eax >= 10							; loop is complete, jump to end
		jmp	theEnd
	.ELSE
		jmp getNum	
	.ENDIF

error:										; error message
	mov		edx, [ebp+32]
	call	WriteString
	call	CrLf
	jmp		getNum

theEnd:
	pop		ebp
	ret		28
ReadVal		ENDP



; ***************************************************************
;Procedure: takes an array of integers, finds the sum and average,
;			and converts and displays all numbers (including sum 
;			and avg) in string format. Uses displayString MACRO.
;recieves:  the address to a string varaible for implementing
;			space formating, the address of a string header
;			for displaying the average, the address of a 
;			string header for displaying the sum, the address of 
;			a string header for displaying the list of numbers,
;			a temp variable to store numbers in during calculation
;			process, the address of an array holding numbers,
;			a temp variable to store the extra calculation 
;			numbers (sum and later the average), the address
;			of a temp variable to store strings ready for 
;			display.
;returns:   none
;preconditions:  users have input numbers into an array
;registers changed: al, edx, ebx, eax, ecx, edi, esi 
; ***************************************************************
WriteVal	PROC
	push	ebp								; preserve stack
	mov		ebp, esp
		
	call	CrLf
	displayString [ebp+28]					; address of numsHead as param
	call	CrLf
	mov		esi, [ebp+20]					; esi is pointing to address of inputArray	

arrBusiness:								; iterate through array
	mov		eax, [ebp+24]					; extraCalc is in eax
	add		eax, [esi]						; add array element to sum (extraCalc)
	mov		[ebp+24], eax						
	xor		edx, edx						; clear edx for remainders
	xor		ecx, ecx						; clear ecx for loop counter
	mov		eax, [esi]					
	mov		edi, [ebp+12]					; tempWord is in edi
findCounter:								; convert number to string
	xor		edx, edx						; clear remainder
	mov		ebx, 10					
	div		ebx								; div current array num to find 10ths place
	inc		ecx								; inc ecx to update amount of 10ths places
	.IF	 eax > 0
		jmp	findCounter
	.ENDIF

buildString:
	xor		edx, edx
	mov		eax, [esi]
	mov		[ebp+16], ecx					; use tempNum to save outter loop counter
tensPlace:
	xor		edx, edx
	div		ebx								; div until current character
	loop	tensPlace
	mov		ecx, [ebp+16]					; use tempNum to restore outter loop counter
	mov		eax, edx
	add		al, 48							; adjust to ascii char	
	CLD
	STOSB									; write char to string
	loop	buildString
	mov		al, 0							; string null terminator
	STOSB
	mov		edx, [ebp+12]

numDisplay:

	displayString	[ebp+12]				; display string

	mov		eax, 4
	add		esi, eax						; increment esi to point to next dword
	mov		eax, [ebp+8]					; inputCount in eax
	inc		eax
	mov		[ebp+8], eax

	.IF  eax < 10							; loop is complete, jump to end
		displayString	[ebp+40]
		jmp arrBusiness
	.ELSE
		call	CrLf	
	.ENDIF

otherCalcs:

	mov		eax, [ebp+24]					; sumNum in eax
	mov		edi, [ebp+12]
	xor		ecx, ecx		
sumCounter:									; convert number to string
	xor		edx, edx						; clear remainder
	mov		ebx, 10					
	div		ebx								; div current array num to find 10ths place
	inc		ecx								; inc ecx to update amount of 10ths places
	.IF	 eax > 0
		jmp	sumCounter
	.ENDIF

sumString:
	xor		edx, edx
	mov		eax, [ebp+24]
	mov		[ebp+16], ecx					; use tempNum to save outter loop counter
sumDiv:
	xor		edx, edx
	div		ebx								; div until current character
	loop	sumDiv
	mov		ecx, [ebp+16]					; use tempNum to restore outter loop counter
	mov		eax, edx
	add		al, 48							; adjust to ascii char	
	CLD
	STOSB									; write char to string
	loop	sumString
	mov		al, 0							; string null terminator
	STOSB
	mov		edx, [ebp+12]

DisplaySum:
		call	CrLf
		displayString [ebp+32]				; address of sumHead as param
		displayString [ebp+12]
		call crlf


findAvg:
	xor		edx, edx						; clear reg prior to div
	mov		eax, [ebp+24]					; sumNum in eax
	mov		ebx, 10
	div		ebx
	mov		[ebp+24], eax					; sumNum now holds average
	mov		edi, offset tempWord
	xor		ecx, ecx		
avgCounter:									; convert number to string
	xor		edx, edx						; clear remainder				
	div		ebx								; div current array num to find 10ths place
	inc		ecx								; inc ecx to update amount of 10ths places
	.IF	 eax > 0
		jmp	avgCounter
	.ENDIF

avgString:
	xor		edx, edx
	mov		eax, [ebp+24]
	mov		[ebp+16], ecx					; use tempNum to save outter loop counter
avgDiv:
	xor		edx, edx
	div		ebx								; div until current character
	loop	avgDiv
	mov		ecx, [ebp+16]					; use tempNum to restore outter loop counter
	mov		eax, edx
	add		al, 48							; adjust to ascii char	
	CLD
	STOSB									; write char to string
	loop	avgString
	mov		al, 0							; string null terminator
	STOSB
	mov		edx, OFFSET tempWord

DisplayAvg:
		call	CrLf
		displayString	[ebp+36]			; address of avgHead as param
		displayString	OFFSET tempWord		; display average num
		call	CrLf

theEnd:
	pop		ebp
	ret		36
WriteVal	ENDP

END main