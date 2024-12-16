import tkinter as tk
import tkinter.font
import subprocess

def close_window():
    root.destroy()

def list_user_services():
    try:
        # Run systemctl command to list user services
        output = subprocess.check_output(['systemctl', '--user', 'list-units', '--type=service', '--all']).decode('utf-8')
        text_output.delete('1.0', tk.END)
        text_output.insert(tk.END, output)
    except subprocess.CalledProcessError as e:
        text_output.delete('1.0', tk.END)
        text_output.insert(tk.END, f"Error: {e.output.decode('utf-8')}")

    root.after(1000, list_user_services)

# Create a Tkinter window
root = tk.Tk(className="systemdList")
root.title("systemd")
root.wait_visibility(root)
root.attributes('-alpha', 0.65)

# Set window size
window_width = 800
window_height = 300

# Configure window background color
root.configure(bg="black")

# Create a Text widget to display output
text_output = tk.Text(root, wrap=tk.WORD, bg="black", fg="white")
text_output.pack(fill=tk.BOTH, expand=False, padx=20, pady=10)

Desired_font = tkinter.font.Font(family = "Mono", size = 9, weight = "bold")
text_output.configure(font = Desired_font)

list_user_services()

# Run the Tkinter main loop
root.mainloop()
