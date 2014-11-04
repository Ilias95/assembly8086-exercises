title Askisi_3
; Exercise description:
; Ask user to enter a string and save only letter, dots and spaces.
; Stop after storing 40 characters or when user hits enter.
; Print the string again after converting uppercasse letters to
; lowercase and vice versa.

code segment
assume cs: code, ds: data
main:
	; -- data segment to ds
	mov ax, data
	mov ds, ax

	; -- ask user input
	lea dx, msg_input
	mov ah, 9
	int 21h

	mov cx, 40 ; loop counter
	loop_input:
		mov ah, 1 ; get input and show it
		int 21h
		mov char, al

		cmp char, 13
		jne validation ; if char != enter

		; -- enter key pressed
		cmp chars_saved, 0
		jne display_text ; if chars_saved != 0

		lea dx, msg_noinput
		mov ah, 9
		int 21h
		jmp terminate

		validation: ; --

		cmp char, ' '
		je save_to_buffer ; if char = ' '
		cmp char, '.'
		je save_to_buffer ; if char = '.'

		cmp char, 'A'
		jb check_if_lower ; if char < 'A'
		cmp char, 'Z'
		ja check_if_lower ; if char > 'Z'
		jmp save_to_buffer ; char is uppercase

		check_if_lower:
			cmp char, 'a'
			jb loop_input ; if char < 'a'
			cmp char, 'z'
			ja loop_input ; id char > 'z'

		save_to_buffer:
			mov al, char
			mov bx, chars_saved
			mov buffer[bx], al

		inc chars_saved

		loop loop_input

	display_text:
		lea dx, msg_converted
		mov ah, 9
		int 21h

		mov bx, 0 ; use bx as array index
		loop_convert:
			mov dl, buffer[bx]

			cmp dl, ' '
			je print_char ; if dl = ' '
			cmp dl, '.'
			je print_char ; if dl = '.'

			cmp dl, 'Z'
			ja lower_to_upper ; if dl > 'Z'

			;; -- upper to lower
			add dl, 32
			jmp print_char

			lower_to_upper:
				sub dl, 32

			print_char:
					mov ah, 2  ; print char
					int 21h

			inc bx
			cmp bx, chars_saved
			je terminate

			jmp loop_convert

	terminate: ; -- terminate program
	mov ah, 4ch
	int 21h
code ends

data segment
	char db ?
	chars_saved dw 0
	buffer db 40 dup(?)

	msg_nl db 13,10,"$"
	msg_input db "Give me input: $"
	msg_noinput db 13,10,"You entered nothing. Bye...",13,10,"$"
	msg_converted db 13,10,"Your text after conversion: $"
data ends

end main
