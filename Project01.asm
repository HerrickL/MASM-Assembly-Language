TITLE Assignment 01			(Project01.asm)

; Author: L. Herrick
; Assignment Number: Assignment 01
; Assignment Due Date: 4/12/15
; Program Description:  Program asks user for two numbers that will be calculated
;						based off of each other.  If first num is smaller than 
;						second num, an error message is displayed and the user
;						is asked to enter new numbers.  If first num is larger
;						than second, program calculates the addition, subtraction
;						multiplication, and division of these two numbers such that
;						num1 + num2 = sum, num1 - num2 = dif, num1*num = prod,
;						num1/num2 = integerQuotient remainder or floating-point
;						quotient.  Program asks user if they would like to 
;						continue or end.  User enters 0 to or any other number
;						to continue.  Program is not required to handle negative
;						numbers.
; Date Created: 4/3/15
; Last Modification Date: 4/10/15

INCLUDE Irvine32.inc


.data
;variables used in the program

userEnd		DWORD	?		;decides when the while loops ends
userNum1	DWORD	?		;first integer to be entered by user
userNum2	DWORD	?		;second integer to be entered by user
changeToF	REAL8	0.00	;used to change int to float
roundFloat1	REAL8	1000.0	;used to round the float during multiplication, also used to round into int
roundFloat2	REAL8	1000.0	;used to div back into float when rounding float
userFloat1	REAL8	?		;float of userNum1
userSum		DWORD	?		;sum to be calculated using user numbers
userDif		DWORD	?		;difference to be calculated using user numbers
userProd	DWORD	?		;product to be calculated using user numbers
userQuot	DWORD	?		;quotient to be calculated using user numbers
userRemain	DWORD	?		;remainder to be calculated using user numbers
userFloatR	REAL8	?		;floating-point version of quotient
intro_1		BYTE	"'Simple Arithmetic'	by Lynn Herrick", 0
intro_2		BYTE	"Enter two numbers and this program will display the sum, difference, product, and quotient with remainder of your numbers.", 0
intro_EC1	BYTE	"**EC: Program repeates until the user chooses to quit.", 0
intro_EC2	BYTE	"**EC: Program validates the second number to be less than the first.", 0
intro_EC3	BYTE	"**EC: Program calculates and displays the quotient as a floating-point number, rounded to the nearest .001.", 0
prompt_1	BYTE	"First calculation number: ", 0
prompt_2	BYTE	"Second calculation number: ", 0
error_1		BYTE	"Error: first number must be larger than the second number.",0
whileQ_1	BYTE	"Should we continue? 0 = No, any other num = Yes.",0  
whileQ_2	BYTE	"Enter a decision number: ",0
result_S	BYTE	" + ", 0
result_D	BYTE	" - ", 0
result_P	BYTE	" x ", 0
result_Q	BYTE	" / ", 0
result_R	BYTE	" remainder ", 0
result_or	BYTE	" or ",0
result_2	BYTE	" = ", 0
continue	DWORD	0		;to be compared, any # greater will continue loop			
goodBye		BYTE	"That's all! Goodbye.", 0
 

.code
main PROC

;Display introduction
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro_EC1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_EC2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_EC3
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf

;Get data from user
startWhile:
	call	CrLf
	mov		edx, OFFSET prompt_1	;ask user for num1
	call	WriteString
	call	ReadInt					;get num1
	mov		userNum1, eax
	mov		edx, OFFSET prompt_2	;ask user for num2
	call	WriteString
	call	ReadInt					;get num2
	mov		userNum2, eax

;validate data
	mov		eax, userNum1
	mov		ebx, userNum2
	cmp		eax, ebx				;validate num1 > num2
	jl		Error					;if num1 < num2, jump to error section

;Calculate the required values
	mov		eax, userNum1
	mov		ebx, userNum2
	add		ebx, eax				;num1 + num2
	mov		userSum, ebx

	mov		eax, userNum1
	mov		ebx, userNum2
	sub		eax, ebx				;num1 - num2
	mov		userDif, eax
	
	mov		eax, userNum1
	mov		ebx, userNum2
	mul		ebx						;num1 * num2
	mov		userProd, eax

	mov		eax, userNum1
	mov		ebx, userNum2
	div		ebx						;num1/num2 integer arith
	mov		userQuot, eax
	mov		userRemain, edx

	fld		changeToF				
	fiadd	userNum1				;add 0.00 to num1 to change from int to float
	fstp	userFloat1
	fld		userFloat1
	fidiv	userNum2				;div by usernum2 to get floating-point quotient
	fstp	userFloatR

	fld		userFloatR
	fmul	roundFloat1				;multiply float by 1000 in preparation of round
	frndint							;round float to int
	fdiv	roundFloat2				;divide float by 1000 to achieve float rounded to nearest .001
	fstp	userFloatR

;Display the results
	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET result_S
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	mov		eax, userSum			;display result of sum (formated: userNum1 + userNum2 = userSum)
	call	WriteDec
	call	CrLf

	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET result_D
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	mov		eax, userDif			;display result of difference (formated: userNum1 - userNum2 = userDif)
	call	WriteDec
	call	CrLf

	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET result_P
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	mov		eax, userProd			;display result of multiplication (formated: userNum1 x userNum2 = userProd)
	call	WriteDec
	call	CrLf

	mov		eax, userNum1
	call	WriteDec
	mov		edx, OFFSET result_Q
	call	WriteString
	mov		eax, userNum2
	call	WriteDec
	mov		edx, OFFSET result_2
	call	WriteString
	mov		eax, userQuot
	call	WriteDec
	mov		edx, OFFSET result_R
	call	WriteString
	mov		eax, userRemain			;Display result of division (formated: userNum1 / userNum2 = userQuot remainder userRemain)
	call	WriteDec
	mov		edx, OFFSET result_or
	call	WriteString
	fld		userFloatR
	call	WriteFloat				;Display extra credit float (formated: or floating-point quotient)

	call	CrLf
	call	CrLf

;continue while loop?
	mov		edx, OFFSET whileQ_1	;displays loop instructions
	call	WriteString
	call	CrLf
	mov		edx, OFFSET whileQ_2	;asks user for a decision
	call	WriteString
	call	ReadInt					;gets user decision
	mov		ebx, continue
	jne		startWhile				;if user decision does not equal 0, jump to StartWhile
	je		ending					;else if user decision equals 0, jump to ending

;Display a goodbye message
ending:
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	exit		; exit to operating system

;Error messages
Error:
	mov		edx, OFFSET error_1
	call	WriteString				;display error for num2 > num1
	call	CrLf
	jmp		startWhile				;jump to start of loop to re-enter nums

main ENDP

END main