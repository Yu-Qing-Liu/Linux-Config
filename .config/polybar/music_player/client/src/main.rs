use std::env;
use std::io::Write;
use std::net::Shutdown;
use std::net::{Ipv4Addr, SocketAddrV4, TcpStream};

const ADDR: Ipv4Addr = Ipv4Addr::new(127, 0, 0, 1);
const PORT: u16 = 8001;

fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <message>", args[0]);
        return Ok(());
    }
    let message = &args[1];
    if let Ok(mut stream) = TcpStream::connect(SocketAddrV4::new(ADDR, PORT)) {
        stream.write(message.as_bytes())?;
        stream.shutdown(Shutdown::Both).unwrap();
    }
    Ok(())
}
