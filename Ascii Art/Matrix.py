# Skonwertowano automatycznie z: Matrix.bat

import os
import re
import sys
import glob
import shutil
import time
import subprocess

# Kod wyjscia ostatniego polecenia (odpowiednik ERRORLEVEL)
LAST_ERRORLEVEL = 0

# Włączenie obsługi kolorów ANSI i UTF-8 w konsoli Windows
if os.name == 'nt':
    os.system('')
    try:
        import ctypes
        kernel32 = ctypes.windll.kernel32
        # ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004
        # ENABLE_PROCESSED_OUTPUT = 0x0001
        # ENABLE_WRAP_AT_EOL_OUTPUT = 0x0002
        kernel32.SetConsoleMode(kernel32.GetStdHandle(-11), 7)
    except Exception:
        pass

# Zmienne batchowe nieustawiane w skrypcie
# (w batchu nieustawiona zmienna jest pusta)
RANDOM = ""

_DIR_STACK = []

# color 2 - zmiana kolorów konsoli
os.system("color 2")

def run_start():
    while True:
        print(f"{RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM} {RANDOM}")
        # powrót do początku pętli (START)

# Zmienna do śledzenia ERRORLEVEL
LAST_ERRORLEVEL = 0

if __name__ == '__main__':
    try:
        run_start()
    except KeyboardInterrupt:
        print("\nZatrzymano program.")
        sys.exit(0)
