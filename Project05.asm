TITLE Project 05		(Project05.asm)

; Author: L. Herrick
; Assignment Number: Assignment 05
; Assignment Due Date: 5/24/15
; Program Description:  Program displays program's name and programmer's
;						name.  Displays instructions to enter a number 
;						between (and including) 10 to 200.  Validates the
;						user's number.  Creates an array of random numbers,
;						ranged between 100 and 999, that is the size of 
;						the user's input.  Displays the unsorted array, 
;						sorts the array in decending order, finds and 
;						displays the median of the array, displays the 
;						sorted array.
; Date Created: 5/15/15
; Last Modification Date: 5/22/15

INCLUDE Irvine32.inc

; constants
MIN = 10
MAX = 200
LOW_LIMIT = 100
HIGH_LIMIT = 999

.data

; variables used in the program
intro		BYTE	"'Sorted Random Numbers'	by Lynn Herrick", 0
instruct1	BYTE	"***Instructions: ",0
instruct2	BYTE	"Input how many numbers, from 10 to 200 (inlcusive), should be ",0
instruct3	BYTE	"generated. ***",0
prompt_num	BYTE	"Please enter a number from 10-200: ",0
errorMess	BYTE	"Error: ",0
unsorted	BYTE	"Unsorted Array: ",0
sorted		BYTE	"Sorted Array: ",0
median		BYTE	"Median: ",0
randArray	DWORD	MAX DUP(?)
count		DWORD	?

.code
main PROC

	push	OFFSET instruct3
	push	OFFSET instruct2
	push	OFFSET instruct1
	push	OFFSET intro
	call	IntroProc				; introduction
	
	push	MIN
	push	MAX
	push	OFFSET errorMess
	push	OFFSET prompt_num
	push	OFFSET count
	call	GetInput				; get user input input
	
	push	OFFSET randArray
	push	count
	call	Randomize				; rand seed
	call	FillArr					; fill array with ran nums
	
	push	OFFSET unsorted
	call	DisplayArray			; display unsorted array
	
	push	OFFSET randArray	
	push	count
	call	SortArray				; sort array, descending

	push	OFFSET median
	call	FindMed					; find and display median
	
	push	OFFSET sorted
	call	DisplayArray			; display sorted array

	exit							; exit to operating system
main ENDP


; ***************************************************************
;Procedure to introduce the program.
;receives: intro, instruct1, instruct2, and instruct3
;on the stack
;returns: none
;preconditions:  none
;registers changed: edx
; ***************************************************************
IntroProc	PROC
	push	ebp
	mov		ebp,esp
	mov		edx, [ebp+8]			; intro is in edx
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, [ebp+12]			; instruct1 is in edx
	call	WriteString
	mov		edx, [ebp+16]			; instruct2 is in edx
	call	WriteString
	call	CrLf
	mov		edx, [ebp+20]			; instruct3 is in edx
	call	WriteString
	call	CrLf
	call	CrLf
	pop		ebp
	ret		16
IntroProc	ENDP


; ***************************************************************
;Procedure to get and validate user input
;receives: address of global variable 'count' on stack
;returns: user input in global variable 'count'
;preconditions:  none
;registers changed: eax, ebx, edx
; ***************************************************************
GetInput	PROC
	push	ebp
	mov		ebp,esp

Get:
	mov		edx, [ebp+12]					; prompt_num in edx
	call	WriteString
	call	ReadDec							; collect input
	mov		ebx, eax
	cmp		eax, [ebp+24]					; MIN in eax, validate input >= 10
	jl		Error
	mov		eax, ebx
	cmp		eax, [ebp+20]					; MAX in eax, validate input <= 200
	jg		Error
	mov		eax, ebx
	mov		ebx, [ebp+8]					; access address of 'count' on stack
	mov		[ebx], eax						; store input at that address
	call	CrLf
	call	CrLf
	pop		ebp	
	ret		20

Error:
	mov		edx, [ebp+16]
	call	WriteString	
	jmp		Get

GetInput	ENDP


; ***************************************************************
;Procedure to fill array with random numbers
;receives: address of array and value of count (size) on stack
;returns: filled array
;preconditions:  count is initialized
;registers changed: ecx, edi, eax, edx 
; ***************************************************************
FillArr		PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+8]				; count in ecx
	mov		edi, [ebp+12]				; address of array in edi

LoopFill:
	mov		eax, HIGH_LIMIT				; upper limit
	sub		eax, LOW_LIMIT				; sub lower limit
	inc		eax
	call	RandomRange					; eax in [0...899]
	add		eax, LOW_LIMIT
	mov		[edi], eax					; store rand num in array
	add		edi, 4						; increment position in array
	loop	LoopFill
	
	pop		ebp
	ret		
FillArr		ENDP


; ***************************************************************
;Procedure to display array elements
;receives: address of array and value of count (size) on stack
;returns: last count element of array
;preconditions:  count is initialized, array is initialized
;registers changed: edx, ecx, esi, ebx, eax, al
; ***************************************************************
DisplayArray	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+8]
	call	WriteString					; Display title of array
	call	CrLf
	mov		ecx, [ebp+12]				; count in ecx		
	mov		esi, [ebp+16]				; address of array in esi
	mov		ebx, 0						; count for line breaks

displayEle:
	inc		ebx
	mov		eax, [esi]
	call	WriteDec
	mov		al, ' '						; spaces between numbers
	call	WriteChar
	call	WriteChar
	call	WriteChar
	add		esi, 4						; update position in array
	.IF		ebx == 10
		call	CrLf
		mov		ebx, 0
	.ENDIF
	loop	displayEle

	call	CrLf
	call	CrLf
	pop		ebp
	ret		12
DisplayArray	ENDP


; ***************************************************************
;Procedure to sort array elements in descending order
;receives: address of array and value of count (size) on stack
;returns: last count element of array
;preconditions:  count is initialized, array is initialized
;registers changed: edx, edi, ecx, eax, ebx
; ***************************************************************
SortArray		PROC
	push	ebp
	mov		ebp, esp
	mov		edx, 1					; edx = bool (true)

	.WHILE	edx == 1
		mov		edi, [ebp+12]		; address of array in edi
		mov		edx, 0				; set bool to false
		mov		ecx, [ebp+8]		; count in ecx
		dec		ecx					; dec for proper loop length
		bubbleSort:
			mov		eax, [edi]		; eax = cur
			mov		ebx, [edi+4]	; ebx = next
			.IF	eax < ebx			; if cur > next
				mov	[edi+4], eax	; swap
				mov	[edi], ebx
				mov	edx, 1			; swap bool is true
			.ENDIF
			add		edi, 4			; increment element pointer
			loop	bubbleSort
	.ENDW
	pop		ebp
	ret		
SortArray		ENDP


; ***************************************************************
;Procedure to find and display median from elements in array
;receives: address of array and value of count (size) on stack
;returns: median value in global variable 'median'
;preconditions:  count is initialized, array is initialized
;registers changed: edx, ecx, edi
; ***************************************************************
FindMed		PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+12]		; count in ecx	
	mov		esi, [ebp+16]		; address of array in edi
	mov		edx, [ebp+8]		; median title in edx
	call	WriteString			; Display title of array
	mov		edx, 0				; clear edx
	mov		ebx, 2
	div		ebx					; find half of count
	mov		ebx, 4				
	mul		ebx					; mul to reach DWORD size
	add		esi, eax		
	mov		eax, [esi]			; median in eax
	call	WriteDec			; display median
	call	CrLf
	call	CrLf
	pop		ebp
	ret		4
FindMed		ENDP

END main