#include <stdio.h>
void vuln() {
	setbuf(stdin, 0);
	setbuf(stdout, 0);
	setbuf(stderr, 0);
	char str[20];
	fgets(str, 20, stdin);
	printf(str);
}

int main(){
	vuln();
}
