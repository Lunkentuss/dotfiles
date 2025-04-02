#!/usr/bin/env python

import os
import subprocess
from pathlib import Path
from typing import Dict, Optional

import yaml

TERMINAL_ENCODING = "UTF-8"
CONFIG_FILE = Path(os.environ["XDG_CONFIG_HOME"]) / "bluetoothctlw.yml"


def exit_error(msg: str):
    print(f"ERROR: {msg}")
    exit(1)


def run_shell(
    command: str, input: Optional[str] = None, error_msg: Optional[str] = None
) -> str:
    input_bytes = bytes(input, TERMINAL_ENCODING) if input is not None else None
    completed_process = subprocess.run(
        command, input=input_bytes, stdout=subprocess.PIPE, shell=True
    )
    rc = completed_process.returncode
    if rc != 0:
        exit_error(
            error_msg
            or f"Command [{command}] failed to run successfully, return code {rc}"
        )
    return str(completed_process.stdout, TERMINAL_ENCODING)


def check_if_command_exists(command: str) -> None:
    run_shell(f"command -v {command}", error_msg=f"Command {command} cant be found")


def main(config_file: Path):
    check_if_command_exists("fzf")
    check_if_command_exists("bluetoothctl")
    if not config_file.exists():
        exit_error(f"Config file [{config_file}] is missing")
    with open(CONFIG_FILE, "r") as f:
        config = yaml.safe_load(f.read())

    mac_adresses: Dict[str, str] = config["devices"]

    device = run_shell("fzf", input="\n".join(mac_adresses.keys()))
    mac_adress = mac_adresses[device.removesuffix("\n")]
    print("Power on bluetoothctl")
    run_shell(f"bluetoothctl power on")
    print("Trusting device")
    run_shell(f"bluetoothctl trust {mac_adress}")
    print("Disconnect device if already disconnected")
    run_shell(f"bluetoothctl disconnect {mac_adress}")
    print("Connect device")
    run_shell(f"bluetoothctl connect {mac_adress}")


if __name__ == "__main__":
    main(CONFIG_FILE)
