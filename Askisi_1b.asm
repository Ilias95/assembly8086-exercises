title Askisi_1b
; Exercise description:
; n is a one-digit decimal number stored in memory
; compute and display the result of (n+1)^2-n^2+2
; note: display two-digit results properly

code segment
assume cs: code, ds: data
main:
	; -- data segment to ds
	mov ax, data
	mov ds, ax

	; -- make calculations
	mov al, n
	inc al
	mul al
	mov bx, ax ; bx = (n+1)^2

	mov al, n
	mul al     ; ax = n^2
	sub bx, ax ; bx = (n+1)^2 - n^2
	add bx, 2  ; bx = (n+1)^2 - n^2 + 2

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
	n db 7
	msg_result db "The result is: $"
data ends

end main
