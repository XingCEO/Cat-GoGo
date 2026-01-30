#!/usr/bin/env python3
"""
Entry point for PyInstaller bundle
"""
import sys
import os

# Determine if we're running as a PyInstaller bundle
if getattr(sys, 'frozen', False):
    # Running as compiled executable
    bundle_dir = sys._MEIPASS
    exe_dir = os.path.dirname(sys.executable)

    # Set environment variable for database path
    db_path = os.path.join(bundle_dir, 'twse_filter.db')
    if os.path.exists(db_path):
        os.environ['DATABASE_URL'] = f'sqlite+aiosqlite:///{db_path}'
    else:
        os.environ['DATABASE_URL'] = f'sqlite+aiosqlite:///{os.path.join(exe_dir, "twse_filter.db")}'

    # Add bundle directory to path
    sys.path.insert(0, bundle_dir)
    os.chdir(bundle_dir)

# Now import uvicorn and app AFTER path setup
import uvicorn
from main import app

if __name__ == "__main__":
    # Run directly with the app object, not string reference
    uvicorn.run(app, host="127.0.0.1", port=8000, log_level="info")
