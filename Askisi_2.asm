title Askisi_2
; Exercise description:
; Ask user to enter one digit and then print if it's even, odd or zero.
; Repeat the process 5 times with good input. Reject non-numbers.

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

		mov ah, 8 ; get input, do not show it
		int 21h
		mov n, al
		lea dx, msg_nl
		mov ah, 9
		int 21h

		cmp n, '0'
		jb bad_input ; if n < 0
		cmp n, '9'
		ja bad_input ; if n > 9

		; -- good input, display the number
		mov dl, n
		mov ah, 2
		int 21h

		cmp n, '0'
		je is_zero ; if n = 0

		; -- even or odd?
		mov ax, 0 ; clear ax contents
		mov al, n
		mov bl, 2
		div bl

		cmp ah, 0
		je even ; if n % 2 = 0
		lea dx, msg_odd
		mov ah, 9
		int 21h
		jmp loop_end

		even:
			lea dx, msg_even
			mov ah, 9
			int 21h
			jmp loop_end

		bad_input:
			lea dx, msg_badinput
			mov ah, 9
			int 21h
			jmp loop

		is_zero:
			lea dx, msg_zero
			mov ah, 9
			int 21h

	loop_end:
		inc loop_counter
		cmp loop_counter, 5
		jb loop

	lea dx, msg_bye
	mov ah, 9
	int 21h

	; -- terminate program
	mov ah, 4ch
	int 21h
code ends

data segment
	n db ?
	loop_counter db 0

	msg_nl db 13,10,"$"
	msg_input db "Give me one digit: $"
	msg_badinput db "Bad input. Try again...",13,10,"$"
	msg_zero db " is zero.",13,10,"$"
	msg_even db " is even.",13,10,"$"
	msg_odd db " is odd.",13,10,"$"
	msg_bye db 13,10,"Five times. Bye...",13,10,"$"
data ends

end main
