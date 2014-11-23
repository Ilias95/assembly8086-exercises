title Ask4_1314_T3T4

CODE SEGMENT PUBLIC
assume cs: CODE, ds: DATA, ss:STACKSEG

main proc near
	; -- DATA segment to ds
	mov ax, data
	mov ds, ax

	call get_input

	cmp numbers_entered, 0
	jne calculate_sum

	lea dx, msg_noinput
	mov ah, 9
	int 21h
	jmp terminate

	calculate_sum:

	mov bx, 0
	loop_sum:
		mov al, buffer[bx]
		add sum, al

		inc bx
		cmp bl, numbers_entered
		jb loop_sum

	call compute_average

	; -- print sum
	lea dx, msg_sum
	mov ah, 9
	int 21h

	; -- split the 3-digit result
	mov ax, 0
	mov al, sum
	mov cl, 100
	div cl
	mov bx, ax

	cmp bl, 0
	je firt_iszero

	mov dl, bl
	add dl, '0'
	mov ah, 2
	int 21h
	jmp second_division

	firt_iszero:
		mov first_zero, 1

	second_division:
	mov ax, 0
	mov al, bh
	mov cl, 10
	div cl
	mov bx, ax

	cmp bl, 0
	jne print_second_digit

	cmp first_zero, 1
	je print_third_digit

	print_second_digit:
	mov dl, bl
	add dl, '0'
	mov ah, 2
	int 21h

	print_third_digit:

	mov dl, bh
	add dl, '0'
	mov ah, 2
	int 21h

	; -- print average
	lea dx, msg_average
	mov ah, 9
	int 21h

	; -- split the 2-digit result to two 1-digit numbers
	mov ax, 0
	mov al, average     ; move result to ax in order to make the division
	mov cl, 10
	div cl              ; divide by 10: quotient in al, remainder in ah
	mov bx, ax          ; bh: second digit, bl: first digit

	cmp bl, 0
	je average_second_digit ; if bl = 0

	mov dl, bl
	add dl, '0'
	mov ah, 2
	int 21h

	average_second_digit:

	mov dl, bh
	add dl, '0'
	mov ah, 2
	int 21h

	terminate: ; -- terminate program
	mov ah, 4ch
	int 21h
main endp

get_input proc near
	; -- ask user input
	lea dx, msg_input
	mov ah, 9
	int 21h

	loop_input:
		mov ah, 8 ; get input without show it
		int 21h

		cmp al, '*'
		je input_end

		cmp al, '0'
		jb loop_input
		cmp al, '9'
		ja loop_input

		; -- valid input
		; -- print number
		mov dl, al
		mov ah, 2
		int 21h

		sub al, '0'
		mov bx, 0
		mov bl, numbers_entered
		mov buffer[bx], al
		inc numbers_entered

		cmp numbers_entered, 15
		jb loop_input

	input_end:
	ret
get_input endp

compute_average proc near
	mov ax, 0
	mov al, sum
	mov bl, numbers_entered
	div bl
	mov average, al

	ret
compute_average endp

CODE ENDS

DATA SEGMENT
	sum db 0
	numbers_entered db 0
	average db ?
	first_zero db 0
	buffer db 15 dup(?)

	msg_input db "Give me a string of numbers: $"
	msg_noinput db 13,10,"You entered nothing. Bye...",13,10,"$"
	msg_sum db 13,10,"Sum is: $"
	msg_average db 13,10,"Average is: $"
DATA ENDS

STACKSEG SEGMENT STACK
	db 256 dup(0)
STACKSEG ENDS

end main
