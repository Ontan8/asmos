org 0x7c00
bits 16

;nasm macro containing the hexadecimal codes equivalent to c++'s endline
%define ENDL 0x0D, 0x0A

start:
	jmp main

;prints a string on the screen
;parameters are: ds:si which points to the stirng
puts: 
	;saves the registers that need to be modified
	push si
	push ax
.loop:
	lodsb	;loads the next character in al
	or al, al	;verifies if the next character is null
	jz .done	;if null then exit the loop

	;below is the bios interrupt to display text on the screen. the ascii character to write is selected from the al register. 
	mov ah, 0x0e	;call bios interrupt
	mov bh, 0	;set to page number (text modes) used in graphics modes so can be ignored for now
	int 0x10	;an interrupt to print text on the screen of the bios
	jmp .loop	;if not null - stay in the loop
.done:
	pop ax
	pop si
	ret


main:
	;setup data segments // the data segments and extra segments are initialized // 
	;since we cannot write to them directly, and intermediary register is used for initialization, in this case the ax register
	mov ax, 0
	mov ds, ax	;cant write to ds/es directly
	mov es, ax

	;ss is the stack segment and sp is the stack pointer
	mov ss, ax
	mov sp, 0x7C00	;stack grows downwards from where we are loaded in memory
	
	mov si, msg_hello
	call puts
	hlt

.halt:
	jmp .halt

msg_hello: db "Hello world!", ENDL, 0

times 510-($-$$) db 0
dw 0AA55h
