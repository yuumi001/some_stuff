#include <stdio.h>
#include <string.h>
int main(){
	setbuf(stdin, 0);
	setbuf(stdout, 0);
	setbuf(stderr, 0);
	alarm(10);
	int printf_offset = 0x58380;
	int system_offset = 0x4a4e0;
	int (*func)(const char *restrict format) = printf;
	char name[32];
	memset(name, 32, 0);
	printf("[ + ] I'll give you this\n");
	printf("[ + ] executing 'cat source.c' ...\n");
        system("cat source.c");
	printf("[ + ] printf: %p\n", func);
	printf("[ + ] printf offset: %p\n[ + ] system offset: %p\n", printf_offset, system_offset);
	printf("[ + ] executing gets(name) ...\n");
	printf("[ + ] What's your name?\n");
	printf("[ + ] input > ");
	gets(name);
	func(name);
	return 0;
}
