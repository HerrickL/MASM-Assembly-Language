TITLE Project 03		(Project03.asm)

; Author: L. Herrick
; Assignment Number: Assignment 03
; Assignment Due Date: 5/03/15
; Program Description:  Program displays the name of the program and author.
;						Greets user by their input name and explains the instructions.
;						Program counts and sums all negative numbers entered between
;						and including -1 to -100.  When the user enters any positive
;						number the program quits the input loop and displays the count
;						of negative numbers entered, sum, and average.  If no numbers
;						were entered, a special message is displayed.  Finally there
;						is a farewell message.
; Date Created: 4/24/15
; Last Modification Date: 5/1/15

INCLUDE Irvine32.inc

; constants

LOWER_LIMIT	= -100

.data

; variables used in the program
intro		BYTE	"'Negative Numbers'	by Lynn Herrick", 0
greeting	BYTE	"Hello, ",0
greeting2	BYTE	". I'm programmed by Lynn.",0
punctuation	BYTE	".",0
space		BYTE	" ",0
prompt_Name	BYTE	"Please enter your name: ",0
instruct	BYTE	"***Instructions: ",0
instruct_1	BYTE	"I will count the negative numbers you enter, and calculate the sum and average.",0
instruct_2	BYTE	"When you are done entering negative numbers, enter a positive number to let me know you're done.***",0
prompt_num	BYTE	"Please enter a negative number between and including -1 to -100 (or a positive number to end): ",0
errorMess	BYTE	"Error: ",0
noNums		BYTE	"Uh-oh, you didn't enter any negative numbers.",0
resultCount	BYTE	"Negative numbers entered: ",0
resultSum	BYTE	"Sum of all negative numbers: ",0
resultAvg	BYTE	"Average of all negative numbers: ",0
goodbye		BYTE	"And that's all for now.  Goodbye, ",0
userName	BYTE 100 DUP(0)	; holds user input name
byteCount	DWORD	?		; counter for reading input string
userNum		DWORD	?		; current user input of a number
numCount	DWORD	0		; counter for numbers input
numSum		DWORD	0		; sum of user numbers
numAvg		DWORD	0		; average of user numbers

.code
main PROC

; introduction
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET prompt_Name		; ask for user's name
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString					; get user's name
	mov		byteCount, eax
	mov		edx, OFFSET greeting		; greeting with user name
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET greeting2
	call	WriteString
	call	CrLf
	call	CrLf

; instructions
	mov		edx, OFFSET instruct
	call	WriteString
	mov		edx, OFFSET instruct_1
	call	WriteString
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	call	CrLf

; get user's numbers/calculate loop
GetNums:
	mov		edx, OFFSET prompt_num
	call	WriteString
	call	ReadInt						; get user's input number
	mov		userNum, eax
	mov		ebx, 0
	cmp		eax, ebx
	jge		Calculations				; if not negative, jump to display calculations
	mov		eax, userNum
	cmp		eax, LOWER_LIMIT	
	jl		Error						; else if not within lower limit, jump to error
	mov		eax, numSum
	add		eax, userNum				; else, calculate num and loop
	mov		numSum, eax
	mov		eax, numCount
	inc		eax							; increment count
	mov		numCount, eax
	jmp		GetNums						; loop back


Error:
	mov		edx, OFFSET errorMess
	call	WriteString					; alert user that input was not correct
	jmp		GetNums


Calculations: 
	call	CrLf
	call	CrLf
	mov		eax, numCount
	.IF	eax == 0							; if no numbers were counted
		mov		edx, OFFSET noNums
		call	WriteString					; display uh-oh
	.ELSE									; else, count/sum/avg
		mov		edx, OFFSET resultCount
		call	WriteString
		mov		eax, numCount
		call	WriteDec					; display count	
		call	CrLf	
		mov		edx, OFFSET resultSum
		call	WriteString
		mov		eax, numSum
		cdq									; extend eax to edx for later div
		call	WriteInt					; display sum
		call	CrLf
		mov		ebx, numCount
		idiv	ebx
		mov		numAvg, eax					; calculate average
		mov		edx, OFFSET resultAvg
		call	WriteString
		mov		eax, NumAvg
		call	WriteInt					; display average
	.ENDIF
	call	CrLf
	call	CrLf

; farewell
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET punctuation
	call	WriteString
	call	CrLf

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main