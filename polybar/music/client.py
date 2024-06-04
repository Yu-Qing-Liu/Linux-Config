#!/usr/bin/env python3

import socket
import sys

HOST = "127.0.0.1"  # The server's hostname or IP address
PORT = 65432  # The port used by the server

# Function to send a command to the server
def send_command(command):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            s.sendall(command.encode())
            s.close()
    except Exception as e:
        print("Error:", e)

def send_query(command):
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            s.sendall(command.encode())
            data = s.recv(1024).decode().strip()
            if not data:
                exit(1)
            if command == "isStopped":
                if data == "F":
                    print("%{T5}%{T1} ")
                else:
                    print("%{T5}%{T1} ")
            elif command == "isPaused":
                if data == "F":
                    print("%{T5}%{T1} ")
                else:
                    print("%{T5}󰐎%{T1} ")
            elif command == "songName":
                print(data + " ")
            elif command == "progress":
                print(data)
            s.close()

    except Exception as e:
        print("Error:", e)

if len(sys.argv) < 2:
    print("Invalid command. Usage:")
    sys.exit(1)

command = sys.argv[1]

if command in ["start", "stop", "pause", "next", "prev"]:
    send_command(command)
elif command in ["isStopped", "isPaused", "songName", "progress"]:
    send_query(command)
else:
    print("Invalid command. Usage:")
    sys.exit(1)
