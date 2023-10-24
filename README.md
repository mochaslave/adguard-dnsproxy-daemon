# DNS Proxy Daemon

This is a simple showcase of [Adguard DNS Proxy](https://github.com/AdguardTeam/dnsproxy) run as a daemon in macOS.

Since I want to use Adguard DNS Proxy to replace the default DNS server, I need to run it as a daemon for easy management startup, auto restart, logs rotation, etc.

Running it using the root user is optional. Only you want it to listen on port 53 (privilege port actually).

## Setup

I assume you have already downloaded the latest Adguard DNS Proxy binary and written your configuration file. Here is my:

- /opt/adguard-dnsproxy/dnsproxy
- /opt/adguard-dnsproxy/config.yaml
- /var/log/dnsproxy.log

### Startup Script

Copy the `startup.sh` to any where you like. I put it in `/opt/adguard-dnsproxy/startup.sh`.

Mack sure it executable.

> If you want to use another path, please change the `dnsproxy.plist` accordingly.

### Launchd(8) Plist

Copy the `dnsproxy.plist` to `/Library/LaunchDaemons/dnsproxy.plist`. Then load it into system domain.

```sh
sudo launchctl bootstrap system /Library/LaunchDaemons/dnsproxy.plist
```

The destination directory depends on what user you want to execute with. I use root user here. More details can be found in `man launchd`. Also, [Lingon X](https://www.peterborgapps.com/lingon/) and [LaunchControl](https://www.soma-zone.com/LaunchControl/) are excellent GUI tools to manage launchd(8) plists.

Here is some commands to manage the daemon:

```sh
# Load the daemon
sudo launchctl bootstrap system /Library/LaunchDaemons/dnsproxy.plist
# Unload the daemon
sudo launchctl bootout system /Library/LaunchDaemons/dnsproxy.plist
# Enable the daemon
sudo launchctl enable system/dnsproxy
# Disable the daemon
sudo launchctl disable system/dnsproxy
```

### Logs Rotation

Copy the `dnsproxy.conf` to `/etc/newsyslog.d/dnsproxy.conf`. Then restart the `newsyslog` daemon.

```sh
sudo launchctl stop com.apple.newsyslog
sudo launchctl start com.apple.newsyslog
# Test rotate setting
sudo newsyslog -nvv
```
