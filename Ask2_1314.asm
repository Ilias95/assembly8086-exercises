title Ask2_1314_T1T2
; Exercise description:
; Ask user to enter an ascii char.
; Print if char is an uppercase letter, lowercase letter or other symbol.
; Repeat process until user input is the symbol '#' and print the total of
; uppercase and lowercase letters entered.

code segment
assume cs: code, ds: data
main:
	; -- data segment to ds
	mov ax, data
	mov ds, ax

	loop:
		; -- ask user input
		lea dx, msg_input
		mov ah, 9
		int 21h

		mov ah, 1 ; get input and show it
		int 21h
		mov d, al
		lea dx, msg_nl
		mov ah, 9
		int 21h

		cmp d, '#'
		je display_results ; if d = '#'

		cmp d, 'A'
		jb check_if_lower ; if d < 'A'
		cmp d, 'Z'
		ja check_if_lower ; if d > 'Z'

		; -- is uppercase
		lea dx, msg_isupper
		mov ah, 9
		int 21h

		inc upper_leters
		jmp loop

		check_if_lower:
			cmp d, 'a'
			jb other_symbol ; if d < 'a'
			cmp d, 'z'
			ja other_symbol ; id d > 'z'

		; -- is lowercase
		lea dx, msg_islower
		mov ah, 9
		int 21h

		inc lower_leters
		jmp loop

		other_symbol:
			lea dx, msg_other
			mov ah, 9
			int 21h

		jmp loop

	display_results:

	lea dx, msg_uppertotal
	mov ah, 9
	int 21h
	mov dl, upper_leters
	add dl, 48
	mov ah, 2
	int 21h
	lea dx, msg_nl
	mov ah, 9
	int 21h

	lea dx, msg_lowertotal
	mov ah, 9
	int 21h
	mov dl, lower_leters
	add dl, 48
	mov ah, 2
	int 21h
	lea dx, msg_nl
	mov ah, 9
	int 21h

	; -- terminate program
	mov ah, 4ch
	int 21h
code ends

data segment
	d db ?
	upper_leters db 0
	lower_leters db 0

	msg_nl db 13,10,"$"
	msg_input db "Give me an ascii char: $"
	msg_isupper db "You typed an uppercase letter.",13,10,"$"
	msg_islower db "You typed an lowercase letter.",13,10,"$"
	msg_other db "Other symbol.",13,10,"$"
	msg_uppertotal db "Total of uppercase letters: $"
	msg_lowertotal db "Total of lowercase letters: $"
data ends

end main
