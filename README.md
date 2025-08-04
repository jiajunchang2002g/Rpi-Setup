# setup_full.sh

## Description
This script performs the following setup tasks on a Raspberry Pi running Raspberry Pi OS or similar Debian-based system:

1. Updates package lists.
2. Installs `vim`.
3. Installs [Oh My Bash](https://github.com/ohmybash/oh-my-bash) in unattended mode.
4. Creates a readonly, executable startup script that logs "Hello!" with a timestamp to `~/hello_log.txt`.
5. Sets up an autostart `.desktop` file in `~/.config/autostart` to run the hello script automatically at graphical login.

## Usage

1. Make the script executable:
   ```bash
   chmod +x setup_full.sh

2. Run the script:

   ```bash
   ./setup_full.sh

3. After the next GUI login, the hello startup script will run automatically and append a message to `~/hello_log.txt`.

## Notes

* Requires an internet connection to install packages and Oh My Bash.
* Assumes the user has sudo privileges (for package installation).
* The hello startup script is set to be executable and readonly (permissions 555).
* The autostart is set up via a `.desktop` file in `~/.config/autostart`.
* Oh My Bash is installed in unattended mode to avoid user prompts.
* Designed for Raspberry Pi OS with desktop environment.

# setup_static_ipv6.sh

## Description
This script configures a static IPv6 address on the Ethernet interface (`eth0`) on a Raspberry Pi or other Linux system using `dhcpcd`. It also creates a systemd service to ensure the configuration is applied correctly after boot, which restarts the DHCP client daemon (`dhcpcd`) multiple times with delays.

### What it does:
1. Adds the following lines to `/etc/dhcpcd.conf` (if not already present):
```

interface eth0
static ip6\_address=fd00::eb:14/64

````

2. Creates a systemd service file `/lib/systemd/system/ipv6.service` which:
- Waits for the network to be up.
- Waits an additional 60 seconds.
- Restarts the `dhcpcd` service three times with delays to ensure the static IPv6 address is applied properly.

3. Reloads the systemd daemon and enables the new service to start at boot.

## Usage

1. Make the script executable:
  ```bash
  chmod +x setup_static_ipv6.sh
  ````

2. Run the script with sudo privileges:

   ```bash
   sudo ./setup_static_ipv6.sh
   ```

3. Reboot the system to apply the changes:

   ```bash
   sudo reboot
   ```

## Notes

* The static IPv6 address is set to `fd00::eb:14/64` — modify the script if you want a different address.
* The systemd service is designed to fix timing issues that might cause `dhcpcd` to ignore the static config on boot.
* Requires sudo privileges to edit system files and enable services.

---
