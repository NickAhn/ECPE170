#!/usr/bin/env python3

# Python DNS query client
#
# Example usage:
#   ./dns.py --type=A --name=www.pacific.edu --server=8.8.8.8
#   ./dns.py --type=AAAA --name=www.google.com --server=8.8.8.8

# Should provide equivalent results to:
#   dig www.pacific.edu A @8.8.8.8 +noedns
#   dig www.google.com AAAA @8.8.8.8 +noedns
#   (note that the +noedns option is used to disable the pseduo-OPT
#    header that dig adds. Our Python DNS client does not need
#    to produce that optional, more modern header)


from re import I

import argparse
import ctypes
import random
import socket
import struct
import sys

def main():
    # sending 2 variables, response is the sum of these variables

    # Setup configuration
    server_ip = "54.148.163.48" 
    port = 3456
    server_address = (server_ip, port)

    # Create UDP socket
    # ---------
    udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


    # Generate request message
    # ---------
    message = bytearray()

    # putting one byte value to message (value of 1)
    message += struct.pack("B", 1) # Protocol version number 1 = version 1

    # create numbers for request message
    A = 3
    B = 2

    #put values to message
    message += struct.pack("!i", A) # !i = Big Endian integer (size = 4)
    message += struct.pack("!i", B)

    message += struct.pack("!i", 7) # Number of characters in my name 

    #My name in ascii characters (Nicolas)
    message += struct.pack("B", 78)
    message += struct.pack("B", 105)
    message += struct.pack("B", 99)
    message += struct.pack("B", 111)
    message += struct.pack("B", 108)
    message += struct.pack("B", 97)
    message += struct.pack("B", 115)

    # Send request message to server
    # (Tip: Use sendto() function for UDP)
    # ---------
    udp.sendto(message, server_address)

    # Receive message from server
    # (Tip: use recvfrom() function for UDP)
    # ---------
    (raw_bytes, answer_address) = udp.recvfrom(4096) #max recv
    print(raw_bytes)

    # Close socket
    # ---------
    udp.close()



    # Receive message from server and unpack it
    # args: format string (size of each part), the thing being unpacked
    response = struct.unpack("!Bhl", raw_bytes) #returns a list of all the parts of the message

    if response[1] == 1:
        print("Success")
        print(f"{A}+{B}={response[2]}")
    else:
        print("Failure")
    


if __name__ == "__main__":
    sys.exit(main())
