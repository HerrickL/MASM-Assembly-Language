TITLE Project 02		(Project02.asm)

; Author: L. Herrick
; Assignment Number: Assignment 02
; Assignment Due Date: 4/19/15
; Program Description:  Program asks user to input their name and greets them.  Program
;						asks user to input a number between and including 1-46.  Validation
;						is conducted on the input number.  If validation is not passed,
;						and error message is given and the user is asked to input the number
;						again with the given limits.  When validation is passed, the program
;						calculates the fibonacci sequence displaying the index results from
;						1 - user input number.  These numbers are displayed in rows based
;						off of the amount of digits in their number (Ex: 5 has 1 digit so it
;						would be in row 1, while 233 has three digits so it would be in row 3).
;						Because of the nature of the sequence, some rows will have more numbers
;						in them than others.  Numbers are put into "columns" by using different 
;						spacing.  Numbers are left-aligned within the column.  A goodbye message
;						is printed to the console using the user's input name.
; Date Created: 4/10/15
; Last Modification Date: 4/17/15

INCLUDE Irvine32.inc

; constants

LOWER_LIMIT	= 0

.data
; variables used in the program

intro_EC1	BYTE	"**EC: Program displays numbers in aligned columns.",0
intro		BYTE	"'Fibonacci Numbers'	by Lynn Herrick", 0
greeting	BYTE	"Hello, ",0
greeting2	BYTE	". I'm programmed by Lynn.",0
punctuation	BYTE	".",0
space		BYTE	" ",0
prompt_Name	BYTE	"Please enter your name: ",0
num_Rules	BYTE	"Please enter a number between and including 1-46.",0
prompt_Num	BYTE	"Please enter how many fibonacci numbers you would like displayed: ",0
ec_allign	BYTE	"Numbers assigned to rows based off of amount of digits in number:",0
hex_intro1	BYTE	"Just for fun, did you know that your number of ",0
hex_intro2	BYTE	" is ",0
hex_intro3	BYTE	" in hexidecimal?- Incredible!",0
goodbye		BYTE	"And that's that.  Goodbye, ",0
errorMess	BYTE	"Error: ",0
userName	BYTE 100 DUP(0)	; holds user input name
byteCount	DWORD	?		; counter for reading input string
userNum		DWORD	?		; used to store user's input for how many increments
fibNumCur	DWORD	1		; used to print current iteration of fib num
fibNumprev	DWORD	1		; used to hold previous fib num
fibCount	DWORD	0		; incremented to count iterations of fib
spaceCount	DWORD	2		; used to compute spaces for column alignment
newLineFlag	DWORD	0		; used to flag when a new line is needed for alignment


.code
main PROC

; introduction
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_EC1
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET prompt_Name		; ask for user's name
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString				; get user's name
	mov		byteCount, eax
	mov		edx, OFFSET greeting	; greeting with user name
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET greeting2
	call	WriteString
	call	CrLf
	call	CrLf

; userInstructions
	mov		edx, OFFSET num_Rules
	call	WriteString
	call	CrLf
	

; getUserData
GetData:
	mov		edx, OFFSET prompt_Num
	call	WriteString
	call	ReadInt					; get user input for how many fib nums
	mov		userNum, eax
	call	CrLf
	call	CrLf

;validate user input
	mov		eax, userNum
	mov		ebx, UPPER_LIMIT
	cmp		eax, ebx
	jge		Error					; if user num is greater than or equal to 47, error
	mov		ebx, LOWER_LIMIT
	cmp		eax, ebx
	jle		Error					; if user num is less than or equal to 0, error
	mov		edx, OFFSET ec_allign
	call	WriteString				; explain extra credit allignment
	call	CrLf
	mov		ax, 0
	mov		ecx, userNum


DisplayFibs:
	;update count
	inc 	ax

	;if first 2
	mov		eax, fibCount
	inc		eax
	mov		fibCount, eax

	.IF 	eax < 3
		mov		eax, fibNumCur
		call	WriteDec	

	;else if calculate fib
	.ELSE
		mov		eax, fibNumCur
		add		eax, fibNumPrev			; calculate new fib
		mov		ebx, fibNumCur
		mov		fibNumPrev, ebx			; re-assign prev fib	
		mov		fibNumCur, eax			; re-assign current fib
		mov		eax, fibNumCur
		call	WriteDec				; display fib
	.ENDIF
	;section added for Extra Credit and to fit limits for loop
	jmp		MakeSpaces

;section added for Extra Credit and to fit limits for loop
WriteSpaces:
	mov		edx, OFFSET space
	.WHILE spaceCount > 0				; loop - write spaces
		call	WriteString
		dec		spaceCount
	.ENDW
		
	mov		eax, newLineFlag
	.IF		newLineFlag == 1			; start a new line if needed
		call	CrLf
	.ENDIF
	
	LOOP	DisplayFibs					;LOOP as per assignment requirements


; farewell
Farewell:
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET punctuation
	call	WriteString
	call	CrLf

	exit		; exit to operating system


;loop if error from input validation
Error:
	mov		edx, OFFSET errorMess
	call	WriteString
	mov		edx, OFFSET num_Rules
	call	WriteString
	call	CrLf
	jmp		GetData


;settings for row, settings for spaces to set collumn allignment
MakeSpaces:
	mov		eax, fibCount
	.IF		eax <= 6					; ROW 1
		.IF		eax == 6				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 11					; set space count
		mov		spaceCount, eax
	.ELSEIF	eax <= 11					;ROW 2
		.IF		eax == 11				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 10
		mov		spaceCount, eax
	.ELSEIF	eax <= 16					; ROW 3
		.IF		eax == 16				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 9					; set space count
		mov		spaceCount, eax
	.ELSEIF	eax <= 20					; ROW 4
		.IF		eax == 20				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 8					; set space count
		mov		spaceCount, eax
	.ELSEIF	eax <= 25					; ROW 5
		.IF		eax == 25				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 7					; set space count
		mov		spaceCount, eax
	.ELSEIF	eax <= 30					; ROW 6
		.IF		eax == 30				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 6					; set space count
		mov		spaceCount, eax
	.ELSEIF	eax <= 35					; ROW 7
		.IF		eax == 35				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 5					; set space
		mov		spaceCount, eax
	.ELSEIF	eax <= 39					; ROW 8
		.IF		eax == 39				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 4					; set space count
		mov		spaceCount, eax
	.ELSEIF	eax <= 44					; ROW 9
		.IF		eax == 44				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 3					; set space count
		mov		spaceCount, eax
	.ELSE								; ROW 10
		.IF		eax == 46				;if end of set, flag new line
			mov		eax, 1
			mov		newLineFlag, eax
		.ELSE	
			mov		eax, 0
			mov		newLineFlag, eax	;else, set flag to false
		.ENDIF
		mov		eax, 2					; set space count
		mov		spaceCount, eax
	.ENDIF

	jmp		WriteSpaces

main ENDP

; (insert additional procedures here)

END main