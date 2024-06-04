#!/usr/bin/env python3

import os
import random
import socket
import threading
import vlc

VIDEO_DIR = os.path.expanduser("~/Music")  # Directory containing music videos
HOST = "127.0.0.1"  # The server's hostname or IP address
PORT = 49153  # The port used by the server
player = None
media_player = None
isPaused = False
isStopped = True

# Function to shuffle the playlist and play music
def load_music():
    global player, media_player
    video_files = [os.path.join(VIDEO_DIR, filename) for filename in os.listdir(VIDEO_DIR)]
    random.shuffle(video_files)
    instance = vlc.Instance('--no-xlib', '--no-video', '--quiet')
    player = instance.media_list_player_new()
    media_player = instance.media_player_new()
    player.set_media_player(media_player)
    media_list = instance.media_list_new(video_files)
    player.set_media_list(media_list)
    player.play()

def handle_request(conn):
    global player, media_player, isPaused, isStopped
    t = "T"
    f = "F"
    while True:
        try:
            command = conn.recv(1024).decode().strip()
            # Check for valid commands and execute corresponding actions
            if command == "start":
                if player is None:
                    load_music()
                    isStopped = False
                elif isStopped:
                    player.play()
                    isStopped = False
                else:
                    player.stop()
                    isStopped = True
                break
            elif command == "stop":
                if player is not None:
                    player.stop()
                    isStopped = True
                break
            elif command == "pause":
                # Pause playback
                if player is not None:
                    media_player.pause()
                    isPaused = not isPaused
                break
            elif command == "next":
                # Play the next video
                if player is not None:
                    player.next()
                break
            elif command == "prev":
                # Play the previous video
                if player is not None:
                    player.previous()
                break
            elif command == "isStopped":
                if isStopped:
                    conn.sendall(t.encode())
                else:
                    conn.sendall(f.encode())
                break
            elif command == "isPaused":
                if isPaused:
                    conn.sendall(t.encode())
                else:
                    conn.sendall(f.encode())
                break
            elif command == "songName":
                if media_player is not None:
                    media = media_player.get_media()
                    if media is not None:
                        # Get the filename from the media's MRL (Media Resource Locator)
                        mrl = media.get_mrl()
                        filename = os.path.basename(mrl)
                        conn.sendall(filename.encode())
                    else:
                        conn.sendall("No media playing".encode())
                else: 
                    conn.sendall("No media player".encode())
                break
            elif command == "progress":
                if media_player is not None:
                    length = media_player.get_length()  # Get the length of the media in ms
                    time = media_player.get_time()  # Get the current time of the media in ms
                    if length > 0:
                        progress = time / length  # Calculate the progress as a fraction
                        bar_length = 25  # Length of the progress bar
                        filled_length = int(bar_length * progress) + 1
                        bar = '%{F#FFFFFF}━%{F#4DFFFFFF}' * filled_length + '%{F#4DFFFFFF}━' * (bar_length - filled_length)
                        progressbar = f"{bar}"
                        conn.sendall(progressbar.encode())
                    else:
                        conn.sendall("%{F#4DFFFFFF}━━━━━━━━━━━━━━━━━━━━━━━━━".encode())
                else: 
                    conn.sendall("%{F#4DFFFFFF}━━━━━━━━━━━━━━━━━━━━━━━━━".encode())
                break

        except OSError as e:
            break

# Function to start the server and load music
def start_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((HOST, PORT))
        s.listen()
        while True:
            conn, addr = s.accept()
            with conn:
                process_thread = threading.Thread(target=handle_request, args=(conn,))
                process_thread.start()

# Spawn a thread that will start a TCP server and listen for incoming requests
server_thread = threading.Thread(target=start_server)
server_thread.start()

