use std::env;
use std::io::{BufRead, BufReader, BufWriter, Write};
use std::net::{Ipv4Addr, Shutdown, SocketAddrV4, TcpStream};

const ADDR: Ipv4Addr = Ipv4Addr::new(127, 0, 0, 1);
const PORT: u16 = 8001;

fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        return Ok(());
    }
    let command = &args[1];

    // Connect to the server
    let mut stream = TcpStream::connect(SocketAddrV4::new(ADDR, PORT))?;

    // Handle different commands
    match command.as_str() {
        "start" | "stop" | "next" | "prev" | "pause" => {
            // Send command to server
            stream.write_all(command.as_bytes())?;
            stream.shutdown(Shutdown::Both)?;
            return Ok(());
        }
        "stopped" | "paused" | "song" | "progress" => {
            // Send command to server and wait for a response
            stream.write_all(command.as_bytes())?;
            stream.flush()?;
            let mut reader = BufReader::new(&stream);
            let incoming = {
                let mut it = vec![];
                let _ = reader.read_until(b'\n', &mut it);
                it
            };
            let display_msg = String::from_utf8_lossy(&incoming);
            let display_msg = display_msg.trim();
            println!("{}", display_msg);
            stream.shutdown(Shutdown::Both)?;
            return Ok(());
        }
        _ => {
            return Ok(());
        }
    }
}
