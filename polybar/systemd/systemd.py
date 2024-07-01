import tkinter as tk

def close_window():
    root.destroy()

# Create a Tkinter window
root = tk.Tk()

# Hide the title bar (make the window titleless)
root.overrideredirect(True)

# Set window size
window_width = 400
window_height = 400

# Calculate the position to center the window on the screen
screen_width = root.winfo_screenwidth()
screen_height = root.winfo_screenheight()
x = (screen_width - window_width) // 2
y = (screen_height - window_height) // 2

# Set window geometry to center the window
root.geometry(f"{window_width}x{window_height}+{x}+{y}")

# Configure window background color
root.configure(bg="white")

# Create a button widget
close_button = tk.Button(root, text="Close", command=close_window)
close_button.pack(pady=10)  # Adjust the padding as needed

# Run the Tkinter main loop
root.mainloop()

