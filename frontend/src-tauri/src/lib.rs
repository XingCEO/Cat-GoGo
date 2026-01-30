use std::process::Command;
use std::env;
use tauri::Manager;

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_process::init())
        .setup(|_app| {
            #[cfg(debug_assertions)]
            {
                _app.handle().plugin(
                    tauri_plugin_log::Builder::default()
                        .level(log::LevelFilter::Info)
                        .build(),
                )?;
            }

            // Get the path to the executable, sidecar is in the same directory
            let exe_path = env::current_exe().expect("Failed to get executable path");
            let exe_dir = exe_path.parent().expect("Failed to get executable directory");
            let sidecar_path = exe_dir.join("python-backend");

            std::thread::spawn(move || {
                match Command::new(&sidecar_path).spawn() {
                    Ok(_child) => {
                        log::info!("Python backend started on port 8000");
                    }
                    Err(e) => {
                        log::error!("Failed to start Python backend: {}", e);
                    }
                }
            });

            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
