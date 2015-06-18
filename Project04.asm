TITLE Project 04		(Project04.asm)

; Author: L. Herrick
; Assignment Number: Assignment 04
; Assignment Due Date: 5/10/15
; Program Description: Program greets user and asks for the user to input the
;					   number of composites they would like to see displayed.
;					   User may not choose a negative number or a number exceeding 400.
;					   If the user chooses a number outside of the limits, they are
;					   given an error message and asked to input new/correct data.
;					   Program then displays the number of composites, with 10 per
;					   line.  Program says goodbye and exits.
;  
; Date Created: 5/1/15
; Last Modification Date: 5/8/15

INCLUDE Irvine32.inc

; constants
UPPER_LIMIT	= 400

.data

; variables used in the program
intro		BYTE	"'Composite Numbers'	by Lynn Herrick", 0
punctuation	BYTE	".",0
space		BYTE	"   ",0
instruct1	BYTE	"***Instructions: ",0
instruct2	BYTE	"Enter a number of composites you would like to see displayed. ",0
instruct3	BYTE	"You may choose any number between and including 1-400 ***",0
prompt_num	BYTE	"Please enter a number between and including 1 to 400: ",0
errorMess	BYTE	"Error: ",0
result		BYTE	"Composites: ",0
goodbye		BYTE	"And that's all for now.  See you next time!",0
userNum		DWORD	?		; user input for composite count
curCompos	DWORD	4		; current composite
curDiv		DWORD	?		; current divisor
fCount		DWORD	0		; counter for factors of a number
cCount		DWORD	0		; counter for composites, compare to userNum
lineCount	DWORD	0		; counter for elements per line


.code
main PROC

; (insert executable instructions here)


; introduction
call	IntroProc

; ask user for num and validate
call	GetInput


; display x composite numbers
call	isComposite

; goodbye
call	GoodbyeProc


	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

IntroProc	PROC
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET instruct1
	call	WriteString
	mov		edx, OFFSET instruct2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct3
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introProc	ENDP


GetInput	PROC
	Input:
	mov		edx, OFFSET prompt_num
	call	WriteString
	call	ReadDec						; get input from user
	mov		userNum, eax
	mov		ebx, 0					
	cmp		eax, ebx					; validate number is > 0
	jle		Error						; if negative or 0 input, error
	mov		eax, userNum
	mov		ebx, UPPER_LIMIT
	cmp		eax, ebx					; validate number is <= 400
	jg		Error						; if above limit, error
	ret									; else, if all is ok, return

	Error:
	mov		edx, OFFSET errorMess
	call	WriteString	
	jmp		Input

GetInput	ENDP


isComposite	PROC

	; set ecx and ax for loop
	mov		ecx, userNum
	mov		ax, 0
	
	; start of for loop
	CalcLoop:
	inc		ax							; increment counter for loop

	SetUpCalc:							; calculations done inside this section
	mov		eax, 0
	mov		fcount, eax					; reset factorial count
	mov		eax, curCompos
	mov		curDiv, eax					; set current divisor equal to current composite

	CountFactorial:						; while current divisor is > 0
	mov		edx, 0
	mov		eax, curCompos
	mov		ebx, curDiv
	div		ebx
	cmp		edx, 0
	je		IncrementFactorial
	
	CompareFactCount:
	mov		eax, curDiv
	dec		eax							; decrement divisor
	mov		curDiv, eax
	cmp		eax, 0
	jg		CountFactorial		
	mov		eax, fCount
	cmp		eax, 2
	je		IncrementCur				; if fcount <= 2 (it's prime), don't display, jump

	; if composite, prep for display by checking line number
	mov		eax, lineCount	
	cmp		eax, 10
	je		NewLine
	jmp		WriteComp

	EndOfLoop:
	LOOP	CalcLoop					; loop back for loop
	ret


	WriteComp:
	inc		lineCount
	mov		eax, curCompos
	call	WriteDec					; write composite to console
	mov		edx, OFFSET space
	call	WriteString					; write a space to console
	mov		eax, curCompos				; increment number being looked at for current composite
	inc		eax
	mov		curCompos, eax
	
	
	LOOP	CalcLoop					; loop back for loop
	ret

	IncrementFactorial:					; increment factorial
	inc		fCount
	jmp		CompareFactCount

	IncrementCur:						; if not going to display, increment current num being checked as composite
	mov		eax, curCompos
	inc		eax
	mov		curCompos, eax
	jmp		SetUpCalc

	NewLine:
	call	CrLf
	mov		eax, 0
	mov		lineCount, eax
	jmp		WriteComp


isComposite	ENDP


GoodbyeProc		Proc
	call	CrLf						; new lines for formatting
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString					; display goodbye message
	call	CrLf
	ret
GoodbyeProc		ENDP


END main