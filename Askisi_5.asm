title Askisi_5
; Exercise description:
; Add two one-digit hex numbers and display the result in hex.
; Use a register to pass the two numbers as parameters to a
; subprogram that make calculations and display the result.

CODE SEGMENT PUBLIC
assume cs: CODE, ds: DATA, ss:STACKSEG

main proc near
	; -- DATA segment to ds
	mov ax, data
	mov ds, ax

	mov ax, 0
	add al, first_dig
	add al, second_dig

	; split the 2-digit result to two 1-digit numbers
	mov cl, 16
	div cl ; divide by 16: quotient in al, remainder in ah

	; move first digit (al) in first four bytes of dl, and second (ah) to the last four
	mov dl, al

	mov cl, 4
	shl dl, cl

	add dl, ah

	; dl as param
	call display_hex

	; -- terminate program
	mov ah, 4ch
	int 21h
main endp

; params: dl
; first four bits of dl contains first digit and rest bits the second
display_hex proc near
	mov bh, 0  ; temporarily hold a digit
	mov bl, dl ; use it to copy parameter's result

	lea dx, msg_result
	mov ah, 9
	int 21h

	; move first four digits of bl to bh
	mov cx, 4
	loop_shift:
		rol bl, 1
		rcl bh, 1
		loop loop_shift

	cmp bh, 0
	je second_digit

	mov dl, bh
	cmp dl, 9
	ja is_digit

	add dl, '0'
	jmp print_first

	is_digit:
	add dl, 55 ; 'A'-10

	print_first:
		mov ah, 2
		int 21h

	second_digit:

	; move rest digits of bl to bh
	mov bh, 0

	mov cx, 4
	loop_shift_second:
		rol bl, 1
		rcl bh, 1
		loop loop_shift_second
	; bl now at its initial state

	mov dl, bh
	cmp dl, 9
	ja second_is_digit

	add dl, '0'
	jmp print_second

	second_is_digit:
	add dl, 55 ; 'A'-10

	print_second:
		mov ah, 2
		int 21h

	mov dl, bl ; restore dl before returning
	ret
display_hex endp

CODE ENDS

DATA SEGMENT
	first_dig db 0Fh
	second_dig db 0Dh

	msg_result db "Result: $"
DATA ENDS

STACKSEG SEGMENT STACK
	db 256 dup(0)
STACKSEG ENDS

end main
