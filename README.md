# Bash Service Health Monitor

## Overview
Monitors system services, attempts recovery, and logs results.

## Features
- Reads services from `services.txt`
- Detects failures using `systemctl`
- Auto-restarts services
- Logs events to `/var/log/health_monitor.log`
- Displays summary report
- Supports `--dry-run` mode

## Requirements
- Linux system with `systemctl`
- Bash shell
- Root/sudo privileges

## Files Included
- `monitor.sh` → Main script  
- `services.txt` → List of services  
- `screenshot.png` → Output screenshot  

## Usage

### Make script executable
```bash
chmod +x monitor.sh
```

### Run script
```bash
sudo ./monitor.sh
```

### Dry Run
```bash
./monitor.sh --dry-run
```

## Log Format
```
YYYY-MM-DD HH:MM:SS | SERVICE | STATUS | SEVERITY
```

## Summary Output
- Total Checked  
- Healthy  
- Recovered  
- Failed  

## Author
Udit Katiyar
