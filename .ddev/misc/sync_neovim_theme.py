import os
import socket as _socket
from pathlib import Path

import pynvim

def is_socket_alive(path, timeout=1.0):
    """Return True if the unix socket at path has a server listening."""
    s = _socket.socket(_socket.AF_UNIX, _socket.SOCK_STREAM)
    s.settimeout(timeout)
    try:
        s.connect(str(path))
        s.close()
        return True
    except (OSError, _socket.timeout):
        return False

for socket_path in Path("/tmp").glob("*.nvim.pipe"):
    if not is_socket_alive(socket_path):
        socket_path.unlink(missing_ok=True)
        continue

    nvim = pynvim.attach("socket", path=socket_path)

    # Set theme environment variables
    for i in range(1, 23):
        color = os.environ[f"COLOR_{i:02}"]
        nvim.command(f":let $COLOR_{i:02}='{color}'")

    color = os.environ[f"BACKGROUND_COLOR"]
    nvim.command(f":let $BACKGROUND_COLOR='{color}'")

    color = os.environ[f"FOREGROUND_COLOR"]
    nvim.command(f":let $FOREGROUND_COLOR='{color}'")

    # reload colorscheme
    colorscheme = os.environ["PROFILE_NAME"]
    nvim.command(f":colorscheme base16-{colorscheme}")

    # reload lightline
    nvim.command(":LightlineReload")
