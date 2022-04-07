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
from dns_tools import dns, dns_header_bitfields  # Custom module for boilerplate code

import argparse
import ctypes
import random
import socket
import struct
import sys

def main():

    # Setup configuration
    parser = argparse.ArgumentParser(description='DNS client for ECPE 170')
    parser.add_argument('--type', action='store', dest='qtype',
                        required=True, help='Query Type (A or AAAA)')
    parser.add_argument('--name', action='store', dest='qname',
                        required=True, help='Query Name')
    parser.add_argument('--server', action='store', dest='server_ip',
                        required=True, help='DNS Server IP')

    args = parser.parse_args()
    qtype = args.qtype
    qname = args.qname
    server_ip = args.server_ip
    port = 53
    server_address = (server_ip, port)

    if qtype not in ("A", "AAAA"):
        print("Error: Query Type must be 'A' (IPv4) or 'AAAA' (IPv6)")
        sys.exit()

    # Create UDP socket
    # ---------
    # STUDENT TO-DO
    # ---------
    udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


    # Generate DNS request message
    # ---------
    # STUDENT TO-DO
    # ---------
    message = bytearray()

    ## Creating Header for DNS request message
    #MessageID
    message += struct.pack("!H", random.randint(0, 65535)) #!H refers to big-endian unsigned int

    # bits conversion
    header = dns_header_bitfields()
    header.qr = 0 # qr value is 0 for query
    header.opcode = 0 # Value of 0 represents standard query.
    header.aa = 0
    header.tc = 0
    header.rd = 1
    header.ra = 0 
    header.reserved = 0
    header.rcode = 0
    message += bytes(header)

    message += struct.pack("!H", 1)
    message += struct.pack("!H", 0) # ANCount (we're doing a message request, so 0)
    message += struct.pack("!H", 0) # NSCount (ignore value)
    message += struct.pack("!H", 0) # ARCount (ignore)

    ## DNS Question Section
    # encoding: <Number of digits> bytes
    qnameBytes = qname.split(".")
    for name in qnameBytes:
        message += struct.pack("!B", len(name))
        message += name.encode()
    message += struct.pack("!B", 0)

    # QType
    qtypeValue = 1 if qtype == "A" else 28
    print(qtypeValue)
    message += struct.pack("!H", qtypeValue) 
    
    # QClass
    message += struct.pack("!H", 1)
    # print("\n MESSAGE: ", message)

    # Send request message to server
    # (Tip: Use sendto() function for UDP)
    # ---------
    # STUDENT TO-DO
    # ---------
    udp.sendto(message, server_address)

    # Receive message from server
    # (Tip: use recvfrom() function for UDP)
    # ---------
    # STUDENT TO-DO
    # ---------
    (raw_bytes, answer_address) = udp.recvfrom(4096) #max recv
    print(raw_bytes)

    # Close socket
    # ---------
    # STUDENT TO-DO
    # ---------
    udp.close()

    # Decode DNS message and display to screen
    dns.decode_dns(raw_bytes)


if __name__ == "__main__":
    sys.exit(main())
