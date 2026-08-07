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
- Automatic discovery of the range your driver accepts, with clamping instead
  of silent failure
- Per-user configuration, overridable per run from the environment
- Automatic startup at login
- No root privileges required after `xinput` is installed
- Installer and uninstaller included
- ShellCheck validation through GitHub Actions

## How the value works

The default scroll distance is commonly `15`.

- **Higher value** = slower scrolling
- **Lower value** = faster scrolling

This project uses `45` by default.

### The accepted range is not what you might expect

XInput does not publish a minimum or maximum for this property, and there is
no API to ask. The driver simply refuses anything outside its accepted band
with a raw `BadValue` error. The band varies by device and driver — on the
reference hardware here (ELAN1300, xf86-input-libinput 1.5.0) it is **10-50**,
and other libinput touchpads have been reported with the same limits.

So `SCROLL_DISTANCE=60` does not give you slower scrolling than `50`. It gives
you a rejected request. Before 1.1.0 that failed silently at login and left
you on the driver default, which is easy to mistake for "the setting stopped
working".

Find your own range:

```bash
set-touchpad-scroll --probe
```

```text
touchpad-scroll: libinput Scrolling Pixel Distance accepts 10-50 on
ELAN1300:00 04F3:3032 Touchpad (currently 50, driver default 15)
```

`--probe` walks the property through candidate values and restores your
existing setting when it finishes. Values outside the discovered range are
clamped, with a warning naming the range, rather than being dropped.

If `50` is still too fast for you, this property has nothing more to give —
you need Xorg-level `libinput` configuration instead.

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

You may also override the value for one run. The environment takes precedence
over the configuration file:

```bash
SCROLL_DISTANCE=30 ~/.local/bin/set-touchpad-scroll
```

(This was documented in 1.0.0 but did not actually work — the configuration
file was sourced afterwards and overwrote it. Fixed in 1.1.0.)

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

### The setting seems to have stopped working

Almost always this means the configured value is outside the range your driver
accepts — often because you raised it looking for slower scrolling and crossed
the limit. Run `set-touchpad-scroll --probe` to see the range, and check the
log:

```bash
journalctl -t touchpad-scroll --no-pager | tail
```

From 1.1.0 the value is clamped and a warning logged. Earlier versions failed
silently.

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
- The accepted range depends on your driver and device, and is discovered by
  probing rather than queried
- The reference driver also accepts the isolated value `9999`, far outside its
  normal band. Its meaning is undocumented upstream; range discovery never
  lands on it and clamping treats it as out of range.

## Project origin

This project began with a simple attempt to slow down touchpad scrolling on Kali Linux. That attempt unexpectedly turned into a full Kali upgrade and eventually revealed that modern libinput/XInput already exposed the exact property needed. The final solution was much smaller than the journey that produced it. 😄

## License

MIT — see [LICENSE](LICENSE).
