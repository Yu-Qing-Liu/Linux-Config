use futures::stream::AbortHandle;
use futures::stream::Abortable;
use rand::seq::SliceRandom;
use rand::thread_rng;
use rodio::{Decoder, OutputStream, Source, Sink};
use std::cmp::max;
use std::fs::File;
use std::io::BufReader;
use std::net::{Ipv4Addr, SocketAddrV4};
use std::path::PathBuf;
use std::sync::Arc;
use std::time::Duration;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpListener;
use tokio::sync::Mutex;
use tokio::task;
use walkdir::WalkDir;

const ADDR: Ipv4Addr = Ipv4Addr::new(127, 0, 0, 1);
const PORT: u16 = 8003;

fn get_music_files() -> Vec<PathBuf> {
    let home_dir = dirs::home_dir().unwrap();
    let path = format!("{}/Music/", home_dir.to_str().unwrap());
    let supported_extensions = [".mp3", ".wav", ".flac", ".ogg", ".m4a"];
    let mut music_files = Vec::new();
    for entry in WalkDir::new(path)
        .follow_links(true)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let f_name = entry.file_name().to_string_lossy();
        for ext in supported_extensions {
            if f_name.ends_with(ext) {
                music_files.push(entry.path().to_path_buf());
            }
        }
    }
    let mut rng = thread_rng();
    music_files.shuffle(&mut rng);
    return music_files;
}

async fn play(
    index_lock: Arc<Mutex<usize>>,
    music_files_lock: Arc<Mutex<Vec<PathBuf>>>,
    sink_lock: Arc<Mutex<Sink>>,
) {
    let mut music_files = music_files_lock.lock().await;
    let mut index = index_lock.lock().await;
    while !music_files.is_empty() && *index < music_files.len() {
        let sink = sink_lock.lock().await;
        let file = BufReader::new(File::open(&music_files[*index]).unwrap());
        let source = Decoder::new(file).unwrap();
        let duration = source.total_duration().unwrap_or(Duration::new(0, 0));
        sink.stop();
        sink.append(source);
        drop(sink);
        drop(index);
        drop(music_files);
        tokio::time::sleep(duration).await;
        index = index_lock.lock().await;
        music_files = music_files_lock.lock().await;
        *index += 1;
    }
    if music_files.is_empty() || *index >= music_files.len() {
        println!("No music files available to play.");
    }
}

async fn stop(sink_lock: &Arc<Mutex<Sink>>) {
    let sink = sink_lock.lock().await;
    sink.stop();
}

async fn pause(sink_lock: &Arc<Mutex<Sink>>) {
    let sink = sink_lock.lock().await;
    sink.pause();
}

async fn resume(sink_lock: &Arc<Mutex<Sink>>) {
    let sink = sink_lock.lock().await;
    sink.play();
}

async fn handle_progress(
    sink_lock: Arc<Mutex<Sink>>,
    music_files_lock: Arc<Mutex<Vec<std::path::PathBuf>>>,
    current_index_lock: Arc<Mutex<usize>>,
) -> String {
    let music_files = music_files_lock.lock().await;
    let current_index = current_index_lock.lock().await;
    let sink = sink_lock.lock().await;
    let current_time = sink.get_pos();
    let file = File::open(&music_files[*current_index]).unwrap();
    let duration = mp3_duration::from_file(&file).unwrap_or(Duration::from_secs(0));
    if duration > Duration::from_secs(0) {
        let progress = f64::min(1.0, current_time.as_secs_f64() / duration.as_secs_f64());
        let bar_length = 25;
        let filled_length = (bar_length as f64 * progress).round() as usize;
        let empty_length = bar_length - filled_length;
        let bar = format!(
            "{}{}{}",
            "━".repeat(filled_length),
            "━".repeat(empty_length),
            "\n"
        );
        return bar;
    } else {
        return "━━━━━━━━━━━━━━━━━━━━━━━━━\n".to_string();
    }
}

async fn handle_client(
    mut stream: tokio::net::TcpStream,
    music_files_lock: Arc<Mutex<Vec<PathBuf>>>,
    current_index_lock: Arc<Mutex<usize>>,
    stopped_lock: Arc<Mutex<bool>>,
    paused_lock: Arc<Mutex<bool>>,
    sink_lock: Arc<Mutex<Sink>>,
    current_task_lock: Arc<Mutex<Option<AbortHandle>>>,
) {
    let mut buf = vec![0; 1024]; // Buffer to read incoming data

    loop {
        // Read incoming command
        let n = match stream.read(&mut buf).await {
            Ok(0) => {
                return;
            }
            Ok(n) => n,
            Err(_) => {
                return;
            }
        };
        let command = String::from_utf8_lossy(&buf[..n]).to_string();
        let mut stopped = stopped_lock.lock().await;
        let mut paused = paused_lock.lock().await;
        match command.as_str() {
            "start" => {
                if *stopped {
                    // Start command
                    *stopped = false;
                    *paused = false;
                    let mut current_index = current_index_lock.lock().await;
                    *current_index = 0;
                    // Cancel any running play task if exists
                    let mut current_task = current_task_lock.lock().await;
                    if let Some(handle) = current_task.take() {
                        handle.abort(); // Abort the previous task if any
                    }
                    // Play the first song
                    let music_files_lock_clone = Arc::clone(&music_files_lock);
                    let sink_lock_clone = Arc::clone(&sink_lock);
                    let current_index_lock_clone = Arc::clone(&current_index_lock);
                    let (abort_handle, abort_registration) = AbortHandle::new_pair();
                    let play_future = Abortable::new(
                        play(
                            current_index_lock_clone,
                            music_files_lock_clone,
                            sink_lock_clone,
                        ),
                        abort_registration,
                    );
                    *current_task = Some(abort_handle);
                    tokio::spawn(async move {
                        let _ = play_future.await;
                    });
                } else {
                    // Stop command
                    *stopped = true;
                    // Reshuffle
                    let mut music_files = music_files_lock.lock().await;
                    *music_files = get_music_files();
                    // Stop the playlist
                    stop(&sink_lock).await;
                }
            }
            "pause" => {
                // Pause command
                if *paused {
                    // Continue song
                    *paused = false;
                    resume(&sink_lock).await;
                } else {
                    *paused = true;
                    pause(&sink_lock).await;
                }
            }
            "next" => {
                // Next command
                let mut current_index = current_index_lock.lock().await;
                *current_index += 1;
                let music_files = music_files_lock.lock().await;
                if *current_index < music_files.len() {
                    // Cancel any running play task if exists
                    let mut current_task = current_task_lock.lock().await;
                    if let Some(handle) = current_task.take() {
                        handle.abort(); // Abort the previous task if any
                    }
                    // Play the next song
                    let music_files_lock_clone = Arc::clone(&music_files_lock);
                    let sink_lock_clone = Arc::clone(&sink_lock);
                    let current_index_lock_clone = Arc::clone(&current_index_lock);
                    let (abort_handle, abort_registration) = AbortHandle::new_pair();
                    let play_future = Abortable::new(
                        play(
                            current_index_lock_clone,
                            music_files_lock_clone,
                            sink_lock_clone,
                        ),
                        abort_registration,
                    );
                    *current_task = Some(abort_handle);
                    tokio::spawn(async move {
                        let _ = play_future.await;
                    });
                } else {
                    *stopped = true;
                    // Stop the playlist
                    stop(&sink_lock).await;
                }
            }
            "prev" => {
                // Prev command
                let mut current_index = current_index_lock.lock().await;
                *current_index = max(*current_index, 1) - 1;
                let mut current_task = current_task_lock.lock().await;
                if let Some(handle) = current_task.take() {
                    handle.abort(); // Abort the previous task if any
                }
                // Play the previous song
                let music_files_lock_clone = Arc::clone(&music_files_lock);
                let sink_lock_clone = Arc::clone(&sink_lock);
                let current_index_lock_clone = Arc::clone(&current_index_lock);
                let (abort_handle, abort_registration) = AbortHandle::new_pair();
                let play_future = Abortable::new(
                    play(
                        current_index_lock_clone,
                        music_files_lock_clone,
                        sink_lock_clone,
                    ),
                    abort_registration,
                );
                *current_task = Some(abort_handle);
                tokio::spawn(async move {
                    let _ = play_future.await;
                });
            }
            "stopped" => {
                // Return stop status
                let message = if *stopped {
                    "\n"
                } else {
                    "\n"
                };
                let _ = stream.write_all(&message.as_bytes()).await;
            }
            "paused" => {
                // Return pause status
                let message = if *paused {
                    "󰐎\n"
                } else {
                    "\n"
                };
                let _ = stream.write_all(&message.as_bytes()).await;
            }
            "song" => {
                // Return song name
                let music_files = music_files_lock.lock().await;
                let current_index = current_index_lock.lock().await;
                let name = &music_files[*current_index]
                    .file_name()
                    .unwrap()
                    .to_string_lossy()
                    .to_string();
                let message = format!("{}\n", name);
                let _ = stream.write_all(&message.as_bytes()).await;
            }
            "progress" => {
                // Return the song's progress bar
                let progress_bar = handle_progress(
                    sink_lock.clone(),
                    music_files_lock.clone(),
                    current_index_lock.clone(),
                )
                .await;
                let _ = stream.write_all(progress_bar.as_bytes()).await;
            }
            _ => {}
        }
    }
}

#[tokio::main]
async fn main() {
    let music_files = Arc::new(Mutex::new(get_music_files()));
    let current_index = Arc::new(Mutex::new(0));
    let stopped = Arc::new(Mutex::new(true));
    let paused = Arc::new(Mutex::new(false));
    let current_task: Arc<Mutex<Option<AbortHandle>>> = Arc::new(Mutex::new(None));

    // Initialize rodio stream and sink
    let (_stream, stream_handle) = OutputStream::try_default().unwrap();
    let sink = Arc::new(Mutex::new(Sink::try_new(&stream_handle).unwrap()));

    // Async TcpListener
    let listener = TcpListener::bind(SocketAddrV4::new(ADDR, PORT))
        .await
        .unwrap();

    loop {
        let (stream, _) = listener.accept().await.unwrap();

        // Clone shared state for the new client connection
        let music_files_clone = Arc::clone(&music_files);
        let current_index_clone = Arc::clone(&current_index);
        let stopped_clone = Arc::clone(&stopped);
        let paused_clone = Arc::clone(&paused);
        let sink_clone = Arc::clone(&sink);
        let current_task_clone = Arc::clone(&current_task);

        // Spawn a task to handle the client connection asynchronously
        task::spawn(handle_client(
            stream,
            music_files_clone,
            current_index_clone,
            stopped_clone,
            paused_clone,
            sink_clone,
            current_task_clone,
        ));
    }
}
