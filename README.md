# Auto Install Xfce4 for ChromeOS (Crostini)

A simple installer to set up the Xfce4 desktop environment on ChromeOS using Xephyr, a nested X server that runs inside the Linux container.

## Requirements

- ChromeOS with Linux (Crostini) enabled
- Passwordless sudo (default in Crostini)

## Installation

```bash
git clone https://github.com/EliCJonas/auto-install-xfce4-crostini.git
cd auto-install-xfce4-crostini
./install.sh
```

## What Gets Installed

The installer will:

1. Install required packages: `xserver-xephyr`, `xfce4`, `xfce4-goodies`, `xfce4-settings`
2. Install `task-xfce-desktop` for additional dependencies (then purge the meta-package to prevent autostart issues)
3. Download and install helper scripts to `/usr/local/bin/`:
   - `startxfce` - Launches Xfce4 in Xephyr
   - `stopxfce` - Stops the Xfce4 session
4. Add .desktop files to your applications menu:
   - **Start XFCE** - Launch the desktop
   - **Stop XFCE** - Close the desktop
   - **XFCE Settings** - Configure Xfce4

## Usage

### Starting Xfce4

Either:
- Click the **Start XFCE** icon in your ChromeOS app launcher
- Run `startxfce` in the terminal

### Stopping Xfce4

Either:
- Click the **Stop XFCE** icon in your ChromeOS app launcher
- Run `stopxfce` in the terminal
- Log out from within the Xfce4 session

## Included Files

| File | Description |
|------|-------------|
| `install.sh` | Main installation script |
| `startxfce` | Script to launch Xfce4 in Xephyr on display :2 |
| `stopxfce` | Script to stop the Xfce4 session |
| `StartXFCE.desktop` | Desktop entry for launching Xfce4 |
| `StopXFCE.desktop` | Desktop entry for stopping Xfce4 |
| `XFCESettings.desktop` | Desktop entry for Xfce4 settings |

## Troubleshooting

### Xephyr fails to start

If you see "Xephyr failed to start" during installation or when running `startxfce`:

1. **Restart the Linux container**: Right-click the Terminal icon in your shelf and select **Shut Down Linux**, then reopen Terminal
2. **Check if another X server is using the display**: Run `ps aux | grep Xephyr` to see if Xephyr is already running. Kill it with `stopxfce` or `killall Xephyr`

### Black screen in Xephyr window

If Xephyr opens but shows only a black screen:

1. Xfce4 may not have started. Try running `DISPLAY=:2 startxfce4` manually
2. Check for errors: `DISPLAY=:2 xfce4-session 2>&1`

### "Cannot open display" errors

1. Ensure Xephyr is running: `ps aux | grep Xephyr`
2. Start Xephyr manually: `Xephyr :2 -resizeable &`
3. Then start Xfce4: `DISPLAY=:2 startxfce4`

### Desktop icons or apps don't appear in ChromeOS launcher

1. Log out and log back into ChromeOS
2. Or restart the Linux container

### Permission denied errors during installation

The script requires passwordless sudo, which is standard in Crostini. If you see permission errors:

1. Ensure you're running inside the default Crostini container
2. Try: `sudo apt update` to verify sudo works

### Xfce4 crashes the container on close

This was an issue with the `task-xfce-desktop` meta-package configuring autostart. The installer purges this package after installation to prevent this. If you still experience crashes:

1. Check if `task-xfce-desktop` is installed: `dpkg -l | grep task-xfce-desktop`
2. If installed, remove it: `sudo apt purge task-xfce-desktop`

### Display scaling issues

Xephyr may not match your ChromeOS display scaling. You can:

1. Adjust scaling within Xfce4: **Settings > Appearance > Fonts > DPI**
2. Or resize the Xephyr window (it runs with `-resizeable` by default)

### Audio not working in Xfce4

Audio should work through PulseAudio in Crostini. If not:

1. Install PulseAudio Xfce plugin: `sudo apt install xfce4-pulseaudio-plugin`
2. Add the plugin to your Xfce4 panel

## Uninstallation

To remove Xfce4 and related packages:

```bash
sudo rm /usr/local/bin/startxfce /usr/local/bin/stopxfce
rm ~/.local/share/applications/StartXFCE.desktop
rm ~/.local/share/applications/StopXFCE.desktop
rm ~/.local/share/applications/XFCESettings.desktop
sudo apt purge xfce4 xfce4-goodies xfce4-settings xserver-xephyr
sudo apt autoremove
```

## License

MIT License
