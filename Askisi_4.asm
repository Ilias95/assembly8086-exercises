title Askisi_4
; Exercise description:
; Ask user to enter a string and store it. Stop after storing 40
; characters or when user hits '#'. Ask again for a char to find.
; Print how many matches of the char found on the given string.

CODE SEGMENT PUBLIC
assume cs: CODE, ds: DATA, ss:STACKSEG

main proc near
	; -- DATA segment to ds
	mov ax, data
	mov ds, ax

	; -- ask user input
	lea dx, msg_input
	mov ah, 9
	int 21h

	mov cx, 80 ; loop counter
	loop_input:
		mov ah, 1 ; get input and show it
		int 21h
		mov char, al

		cmp char, '#'
		jne save_to_buffer ; if char != '#'

		; -- '#' pressed
		cmp chars_saved, 0
		jne input_end ; if chars_saved != 0

		lea dx, msg_noinput
		mov ah, 9
		int 21h
		jmp terminate

		save_to_buffer:
			mov al, char
			mov bx, chars_saved
			mov buffer[bx], al

		inc chars_saved
		loop loop_input

	input_end:
	call find

	terminate: ; -- terminate program
	mov ah, 4ch
	int 21h
main endp

find proc near
	; -- ask user to give find char
	lea dx, msg_inputchar
	mov ah, 9
	int 21h

	mov ah, 1 ; get input and show it
	int 21h

	mov bx, 0 ; use bx as array index
	loop_find:
		cmp al, buffer[bx]
		jne nomatch ; if al != buffer[bx]

		inc times_found

		nomatch:

		inc bx
		cmp bx, chars_saved
		je display_results

		jmp loop_find

	display_results:
		cmp times_found, 0
		jne print_number ; if times_found != 0

		lea dx, msg_notfound
		mov ah, 9
		int 21h
		jmp end_proc

		print_number:
			lea dx, msg_timesfound
			mov ah, 9
			int 21h

			; -- split the 2-digit result to two 1-digit numbers
			mov ax, times_found ; move result to ax in order to make the division
			mov cl, 10
			div cl              ; divide by 10: quotient in al, remainder in ah
			mov bx, ax          ; bh: second digit, bl: first digit

			cmp bl, 0
			je print_second_digit ; if bl = 0

			mov dl, bl
			add dl, '0'
			mov ah, 2
			int 21h

			print_second_digit:

			mov dl, bh
			add dl, '0'
			mov ah, 2
			int 21h

	end_proc:
	ret
find endp

CODE ENDS

DATA SEGMENT
	char db ?
	times_found dw 0
	chars_saved dw 0
	buffer db 80 dup(?)

	msg_input db "Give me a string: $"
	msg_noinput db 13,10,"You entered nothing. Bye...",13,10,"$"
	msg_inputchar db 13,10,"Give me a char to find: $"
	msg_notfound db 13,10,"Char not found in the given string.$"
	msg_timesfound db 13,10,"Times found: $"
DATA ENDS

STACKSEG SEGMENT STACK
	db 256 dup(0)
STACKSEG ENDS

end main
