import struct
import socket
import telnetlib

# def recvuntil(x,y):
#   r=''
#   try:
#     while 1:
#       s = x.recv(len(y))
#       if s==y:
#         return r
#       else:
#         r+=s
#   except:
#     pass
def p32(x):
  return struct.pack('I',x)
def p64(x):
  return struct.pack('Q',x)
def remote(x,y):
  s = socket(socket.AF_INET, socket.SOCK_STREAM)
  return s.connect(x,y)
def interactive(s):
  t = telnetlib.Telnet()
  t.sock = s
  t.interact()
def main():
  #exploit go here
  
main()
