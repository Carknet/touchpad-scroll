# touchpad-scroll

A small X11/libinput helper that sets a custom touchpad scroll distance at login.

It searches for the first XInput device exposing the property:

```text
libinput Scrolling Pixel Distance
```

A higher value means slower scrolling. The default value is often `15`; this project uses `45` by default.

## Requirements

- X11 session
- `xinput`
- A libinput touchpad exposing `libinput Scrolling Pixel Distance`

On Debian, Kali, or Ubuntu:

```bash
sudo apt install xinput
```

## Install

```bash
git clone https://github.com/Carknet/touchpad-scroll.git
cd touchpad-scroll
chmod +x install.sh uninstall.sh set-touchpad-scroll
./install.sh
```

Log out and back in, or test immediately with:

```bash
~/.local/bin/set-touchpad-scroll
```

## Change the speed

Edit this line in `~/.local/bin/set-touchpad-scroll`:

```bash
SCROLL_DISTANCE=45
```

- Higher value: slower scrolling
- Lower value: faster scrolling

Then run:

```bash
~/.local/bin/set-touchpad-scroll
```

## Verify

```bash
xinput list-props "ELAN1300:00 04F3:3032 Touchpad" | grep "Scrolling Pixel Distance"
```

Or inspect all compatible devices:

```bash
xinput list --id-only | while read -r id; do
  xinput list-props "$id" 2>/dev/null | grep -H "Scrolling Pixel Distance"
done
```

## Uninstall

```bash
./uninstall.sh
```

## Notes

This is intentionally a simple per-user X11 solution. It does not patch libinput, install a system-wide quirk, or require root after `xinput` is installed.
