# Changelog

## [1.0.4] - 2026-03-15

### Fixed
- **`FetchDeviceInfo()`**: Removed fallback endpoint loops for device name and firmware version. Each now uses a single correct Loxone API endpoint (`/dev/cfg/device` and `/dev/cfg/version` respectively).
- **`ParseLL()`**: Removed fallback whitespace-trimming format parser. Function now strictly parses the Loxone LL XML response format (`Code="..."` + `value="..."`), returning `nil, nil` for any unrecognized response.

## [1.0.0] - Initial Release

- Controls and monitors a Loxone Miniserver via HTTP Web Services API.
- Supports digital (On/Off/Pulse) and analog virtual I/O.
- HTTP Basic Auth via Username/Password credentials.
- Configurable polling interval for status updates.
- Device name and firmware version display.
- Test Connection button to verify connectivity and PLC state.
- Debug Print toggle for TX/RX logging.
