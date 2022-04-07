#!/usr/bin/python3

# Usage:
#  ./display.py --help
#  ./display.py --port=??? --url=????
#
# Example commands:
#  ./display.py --port=80 --url=http://ut-images.s3.amazonaws.com/wp-content/uploads/2009/09/SED_wall_1920x1200.jpg
#  ./display.py --port=80 --url=http://www.personal.psu.edu/users/m/e/mel992/space_shuttle_13.jpg

'''
The HTTP Request sent to the server must be printed out on the screen
The HTTP Response received from the server must be printed out on the screen (just the header, not the data)
The entire response from the server must be downloaded in increments of max_recv bytes per system call to recv(). (This is a variable defined in the boilerplate code, and is a reasonable value such as 64kB).
Downloaded files must be saved to local disk with the same file name as on the server. 
Downloaded files must be displayed on screen by invoking the eog image viewer utility (see code at the end of the boilerplate file to do this)'''

import argparse
import re
import string
import socket
import sys
import os
from subprocess import call
from urllib.parse import urlparse

# Size of receive buffer.
# Maximum number of bytes to get from network in one recv() call
max_recv = 64*1024

# Setup configuration
parser = argparse.ArgumentParser(description='Download client for ECPE 170')
parser.add_argument('--url', 
                    action='store',
                    dest='url', 
                    required=True,
                    help='URL of file to download')
parser.add_argument('--port', 
                    action='store',
                    dest='port', 
                    required=True,
                    help='Port number of web server')

args = parser.parse_args()
url = args.url
port = int(args.port)

print("Running download client")
print("Download url: %s" % url)
print("Download port number: %i" % port)

# Split URL into "host", "path", and "filename" variables.
# http://www.google.com/images/srpr/logo3w.png
#  * host=www.google.com
#  * path=/images/srpr
#  * file=logo3w.png

u = urlparse(url)
print("Parsing URL:")
print(" * scheme=%s" % u.scheme)
print(" * netloc=%s" % u.netloc)
print(" * path+file=%s" % u.path)
print(" * path=%s" % os.path.dirname(u.path))
print(" * file=%s" %os.path.basename(u.path))
print()

# Download file (image) from http://host/path/filename
host = u.netloc
path = os.path.dirname(u.path) + '/'
filename = os.path.basename(u.path)

print("Preparing to download object from http://" + host + path + filename)


# *****************************
# STUDENT WORK: 
#  (1) Build the HTTP request string to send to the server
#      and *print it* on the screen.
#
#      Requirements:
#        HTTP 1.1
#        Use the Host header
#        Request the connection be closed after response sent.
#
#      Tip: What is the important sequence of characters that
#      must be provided at the end of the HTTP client request
#      to the server? (otherwise, the server won't begin processing)
# *****************************
request_str = "GET " + path + filename + " HTTP/1.1\r\nHost: " + host + "\r\nConnection: close\r\n\r\n"
print("\n", request_str)



# *****************************
# STUDENT WORK: 
#  (2) Create a TCP socket (SOCK_STREAM)
#  (3) Connect to the remote host using the socket
#  (4) Send the HTTP request to the remote host.
#      Tip: Look at the demo client program to see how
#      to convert a unicode string to a byte array
#      prior to transmitting it.
# *****************************

tcp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
tcp_socket.connect((host,port)) # A pair (host, port) is used for the AF_INET address family
print("Connection established")

# sending HTTP request
raw_bytes = bytes(request_str,'ascii') # convert unicode to ascii
try:
    # Send the string
    # Note: send() might not send all the bytes!
    # You should loop, or use sendall()
    bytes_sent = tcp_socket.send(raw_bytes)
except socket.error as msg:
    print("Error: send() failed")
    print("Description: " + str(msg))
    sys.exit()

print("Sent %d bytes to server" % bytes_sent)

# *****************************
# STUDENT WORK: 
#  (5) Receive everything the remote host sends us
#      in chunks of 'max_recv' bytes (64kB).
#      When the server finishes sending us the data,
#      it will close the socket. That is detected locally
#      by receiving an array of length ZERO
#      (i.e. no bytes received)
#  (6) Close the socket - finished with the network now
# *****************************

'''
The return value is a pair (conn, address) where conn is a new socket object usable to send and receive
data on the connection, and address is the address bound to the socket on the other end of the connection.'''
# (client_s, client_addr) = tcp_socket.accept()

try:
    temp = tcp_socket.recv(max_recv)
    raw_bytes = temp
    while len(temp) != 0:
        temp = tcp_socket.recv(max_recv)
        raw_bytes += temp


except socket.error as msg:
    print("Error: unable to recv()")
    print("Description: " + str(msg))
    sys.exit()

# string_unicode = raw_bytes.decode('ascii')
print("Received %d bytes from client" % len(raw_bytes))
# print("Message contents: %s" % string_unicode)

try:
    tcp_socket.close()
    tcp_socket.close()
except socket.error as msg:
    print("Error: unable to close() socket")
    print("Description: " + str(msg))
    sys.exit()

print("Sockets closed, now exiting")


# *****************************
# STUDENT WORK: 
#  (7) Split the response into two parts:
#        1.) The part before the \r\n\r\n sequence - the HEADER
#        2.) The part after the \r\n\r\n sequence - the DATA
#  (8) Print the HEADER out on the screen - it's ASCII text
#  (9) Save the DATA to disk as a binary file. Somewhere
#      in the /tmp directory would be a great spot.
# *****************************
# 7
split = raw_bytes.split(b"\r\n\r\n")
header, data = split[0], split[1]
print("\n- Printing HEADER: ")
print(header)

saved_filename = "/tmp/"+filename
f = open(saved_filename, "w+b")
f.write(data)
f.close()

# *****************************
# END OF STUDENT WORK
# *****************************

# Assuming you downloaded the image, and placed its path/filename
# in the variable 'saved_filename', use the 'eog' utility to 
# display the image on screen
call(["eog", saved_filename])
