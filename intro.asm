title Introductory
; Exercise description:
; add two one-digit numbers stored in memory and display their result
; note: don't care about displaying two-digit results properly

code segment
assume cs: code, ds: data
main:
	; -- data segment to ds
	mov ax, data
	mov ds, ax

	; -- add numbers
	mov al, n1
	add al, n2
	mov bl, al ; move result to bl in order to overwrite al, bl = n1 + n2

	; -- display results
	lea dx, msg
	mov ah, 9 ; dos call for display string
	int 21h   ; dos interrupt

	mov dl, bl ; move result to dl in order to display it
	add dl, 48 ; add the ascii code of zero
	mov ah, 2  ; dos call for display char
	int 21h

	; -- terminate program
	mov ah, 4ch
	int 21h
code ends

data segment
	n1 db 3
	n2 db 5
	msg db "Sum is: $"
data ends

end main
