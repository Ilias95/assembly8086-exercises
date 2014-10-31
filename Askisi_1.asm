title Askisi_1
; Exercise description:
; n is a one-digit decimal number stored in memory
; compute and display the result of n^2-2*n+1
; note: display two-digit results properly

code segment
assume cs: code, ds: data
main:
	; -- data segment to ds
	mov ax, data
	mov ds, ax

	; -- make calculations
	mov al, n
	mul al
	mov bx, ax ; bx = n*n

	mov al, n
	mov cl, 2
	mul cl     ; ax = 2*n
	sub bx, ax ; bx = n^2-2*n
	inc bx     ; bx = n^2-2*n+1

	; -- split the 2-digit result to two 1-digit numbers
	mov ax, bx ; move result to ax in order to make the division
	mov cl, 10
	div cl     ; divide by 10: quotient in al, remainder in ah
	mov bx, ax ; bh: second digit, bl: first digit

	; -- display results
	lea dx, msg_result
	mov ah, 9
	int 21h

	mov dl, bl
	add dl, 48 ; add the ascii code of zero
	mov ah, 2
	int 21h

	mov dl, bh
	add dl, 48
	mov ah, 2
	int 21h

	; -- terminate program
	mov ah, 4ch
	int 21h
code ends

data segment
	n db 8
	msg_result db "The result is: $"
data ends

end main
