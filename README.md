# touchpad-scroll

A small, lightweight utility for adjusting libinput touchpad scroll speed on **X11**.

Many Linux desktops expose the XInput property:

```text
libinput Scrolling Pixel Distance
```

but provide no graphical control for it. `touchpad-scroll` automatically finds a compatible touchpad and applies your preferred scroll distance each time you log in.

## Features

- Automatic compatible-device detection
- No hard-coded XInput device ID
- Per-user configuration
- Automatic startup at login
- No root privileges required after `xinput` is installed
- Installer and uninstaller included
- ShellCheck validation through GitHub Actions

## How the value works

The default scroll distance is commonly `15`.

- **Higher value** = slower scrolling
- **Lower value** = faster scrolling

This project uses `45` by default.

## Requirements

- An X11 desktop session
- `xinput`
- A libinput device exposing `libinput Scrolling Pixel Distance`

Install `xinput` on Debian, Kali, or Ubuntu:

```bash
sudo apt install xinput
```

Check whether your touchpad exposes the required property:

```bash
xinput list
xinput list-props "YOUR TOUCHPAD NAME" | grep "Scrolling Pixel Distance"
```

## Installation

```bash
git clone https://github.com/Carknet/touchpad-scroll.git
cd touchpad-scroll
chmod +x install.sh uninstall.sh set-touchpad-scroll
./install.sh
```

The installer creates:

```text
~/.local/bin/set-touchpad-scroll
~/.config/autostart/touchpad-scroll.desktop
~/.config/touchpad-scroll.conf
```

Log out and back in, or apply the setting immediately:

```bash
~/.local/bin/set-touchpad-scroll
```

## Configuration

Edit:

```bash
nano ~/.config/touchpad-scroll.conf
```

Example:

```bash
SCROLL_DISTANCE=45
```

Apply the new value immediately:

```bash
~/.local/bin/set-touchpad-scroll
```

You may also override the value for one run:

```bash
SCROLL_DISTANCE=30 ~/.local/bin/set-touchpad-scroll
```

## Example output

```text
touchpad-scroll: set "libinput Scrolling Pixel Distance" to 45 on ELAN1300:00 04F3:3032 Touchpad
```

## Troubleshooting

### `xinput is not installed`

Install it using your distribution's package manager, for example:

```bash
sudo apt install xinput
```

### `DISPLAY is not set`

The utility must run inside an active X11 graphical session. It is not currently intended for Wayland.

### No compatible device found

Confirm that a device exposes the required property:

```bash
xinput list --short
```

Then inspect likely touchpad devices:

```bash
xinput list-props "DEVICE NAME"
```

### View log messages

```bash
journalctl --user -t touchpad-scroll
```

Depending on the distribution, messages may instead be available in the system journal:

```bash
journalctl -t touchpad-scroll
```

## Uninstallation

From the cloned repository:

```bash
./uninstall.sh
```

The uninstaller removes the executable and autostart entry, but deliberately keeps your configuration file.

Remove the configuration too when desired:

```bash
rm ~/.config/touchpad-scroll.conf
```

## Limitations

- X11 only
- Changes the first detected device exposing `libinput Scrolling Pixel Distance`
- Availability of the property depends on the installed Xorg/libinput stack

## Project origin

This project began with a simple attempt to slow down touchpad scrolling on Kali Linux. That attempt unexpectedly turned into a full Kali upgrade and eventually revealed that modern libinput/XInput already exposed the exact property needed. The final solution was much smaller than the journey that produced it. 😄

## License

MIT — see [LICENSE](LICENSE).
