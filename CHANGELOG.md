# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-08-07

### Fixed

- Out-of-range scroll distances no longer fail silently. Previously any value
  the driver refused produced a raw `X Error: BadValue`, the autostart entry
  exited non-zero at login, and the touchpad was left on the driver default
  with no indication that the configuration had not been applied. The accepted
  range is now discovered and the configured value clamped into it, with a
  warning naming the range.
- Environment overrides are no longer discarded. `SCROLL_DISTANCE=30
  set-touchpad-scroll` has been documented since 1.0.0 but never worked when a
  configuration file existed, because the file was sourced after the variable
  was read and overwrote it unconditionally. The environment now takes
  precedence over the configuration file.
- Invalid values (non-numeric, zero) are rejected before any device access
  rather than being silently replaced by the configured value.

### Added

- `--probe` reports the range of scroll distances the current driver accepts,
  then restores the existing value.
- `--help`.

### Notes

- The accepted range is not exposed by XInput and cannot be queried; it is
  determined by probing. On the reference hardware (ELAN1300 touchpad,
  xf86-input-libinput 1.5.0) it is 10-50, which matches values reported for
  other libinput touchpads. It is not guaranteed to be the same elsewhere.
- The reference driver also accepts `9999`, an isolated value far outside its
  normal band. Its meaning is undocumented upstream. Because it is isolated,
  range discovery never lands on it and clamping treats it as out of range.

## [1.0.0] - 2026-08-01

### Added

- Automatic detection of an XInput device exposing `libinput Scrolling Pixel Distance`.
- Configurable scroll distance through `~/.config/touchpad-scroll.conf`.
- Per-user autostart installation for X11 desktop sessions.
- Installer and uninstaller scripts.
- ShellCheck validation through GitHub Actions.
- MIT license and project documentation.
