title Askisi_6
; Exercise description:
; Write a function that returns the sum of an array of integers.

CODE SEGMENT PUBLIC
assume cs: CODE, ds: DATA, ss:STACKSEG

main proc near
	; -- DATA segment to ds
	mov ax, data
	mov ds, ax

	; pass parameters to subprogram via stack
	lea dx, array
	push dx
	mov dx, 10 ; array length
	push dx
	lea dx, sum
	push dx

	call sum_pin
	add sp, 6 ; restore sp, 3 arguments

	; pass ax, bl registers as parameters to subprogram
	mov ax, sum
	mov bl, 10 ; display in decimal
	call print_num

	terminate: ; -- terminate program
	mov ah, 4ch
	int 21h
main endp

; sum all elements of the given array
; arguments:
; bp+6 - array of ints, by ref
; bp+4 - array length, by value
; bp+2 - sum, by ref
sum_pin proc near
	mov bp, sp
	mov bl, [bp+6]
	mov si, [bp+2]

	mov cx, [bp+4]
	loop_sum:
		mov di, cx
		mov al, [bl][di-1]
		add [si], al
		loop loop_sum

	ret
sum_pin endp

; print a number
; arguments:
; ax - number to display, by value
; dx - system base, by value
print_num proc
	mov bp,sp

	cmp ax, 0
	je nomore

	mov dx, 0
	div bx
	push dx
	xor dx, dx

	call print_num

	nomore:
		cmp ah, 0
		jne display
		cmp bp, sp
		je exit

	display:
		pop dx
		add dl, '0'
		mov ah, 2
		int 21h

	exit:
	ret
print_num endp

CODE ENDS

DATA SEGMENT
	array db 5, 2, 4, 6, 9, 12, 5, 6, 34, 10
	sum dw 0
DATA ENDS

STACKSEG SEGMENT STACK
	db 256 dup(0)
STACKSEG ENDS

end main
