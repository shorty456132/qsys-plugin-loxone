# Loxone Miniserver — Q-SYS Plugin

Controls and monitors a Loxone Miniserver via its HTTP Web Services API. Supports up to 8 digital virtual I/O controls (On/Off/Pulse with state feedback) and up to 4 analog virtual I/O controls, with configurable periodic polling.

---

## Setup

1. Drag the plugin into your Q-SYS Designer schematic.
2. Go to the **Setup** page and enter:
   - **IP Address** — Loxone Miniserver IP (e.g. `192.168.1.100`)
   - **Username** — Loxone user (default: `admin`)
   - **Password** — Loxone password (default: `admin`)
3. In **Plugin Properties**, configure:
   - **HTTP Port** — default `80` (use `443` for HTTPS)
   - **Use HTTPS** — enable for Miniserver Gen.2 with TLS
   - **Digital Control Count** — number of digital I/O rows to show (1–8, default 4)
   - **Analog Control Count** — number of analog I/O rows to show (0–4, default 2)
   - **Poll Interval** — status poll frequency in seconds (1–60, default 5)
4. Click **Test Connection** to verify connectivity and view PLC state.
5. Click **Connect** to start polling.

---

## Pages

### Control Page
- **Connection** — Connect toggle and status indicator
- **Digital Controls** — Up to 8 rows, each with:
  - **Control Name** — Loxone virtual input/output name (must match Loxone Config exactly)
  - **On / Off / Pulse** — Send digital commands to the Miniserver
  - **State** — LED showing current output state (polled)
- **Analog Controls** — Up to 4 rows, each with:
  - **Control Name** — Loxone virtual input/output name
  - **Value** — Float value to send (type any number, e.g. `21.5`, `7.2`, `0`)
  - **Send** — Transmit the value to the Miniserver
  - **State** — Current polled value from the Miniserver

### Setup Page
- **Connection Settings** — IP Address, Username, Password, Test Connection
- **Device Info** — Device Name and Firmware Version (auto-fetched on connect)
- **Debug** — Toggle verbose TX/RX logging to Q-SYS debugger

---

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| HTTP Port | integer | 80 | HTTP port (use 443 for HTTPS) |
| Use HTTPS | boolean | false | Enable HTTPS for Gen.2 Miniservers |
| Digital Control Count | integer | 4 | Number of digital I/O rows (0–8) |
| Analog Control Count | integer | 2 | Number of analog I/O rows (0–4) |
| Poll Interval | integer | 5 | Polling interval in seconds (1–60) |

---

## Controls

| Control | Type | Pin | Description |
|---|---|---|---|
| IPAddress | Text | Input | Miniserver IP address |
| Username | Text | — | Loxone username |
| Password | Text | — | Loxone password |
| Status | Indicator/Status | Output | Connection/polling status |
| Connect | Button/Toggle | Input | Start/stop status polling |
| Test Connection | Button/Trigger | Input | Verify connectivity, show PLC state |
| Debug Print | Button/Toggle | — | Enable verbose debug logging |
| DeviceName | Indicator/Text | Output | Miniserver device name |
| DeviceFirmware | Indicator/Text | Output | Miniserver firmware version |
| Digital Name 1–8 | Text | — | Loxone virtual I/O control name |
| Digital On 1–8 | Button/Trigger | Input | Send "On" to digital control |
| Digital Off 1–8 | Button/Trigger | Input | Send "Off" to digital control |
| Digital Pulse 1–8 | Button/Trigger | Input | Send "Pulse" to digital control |
| Digital State 1–8 | Indicator/LED | Output | Current digital output state |
| Analog Name 1–4 | Text | — | Loxone virtual I/O control name |
| Analog Value 1–4 | Text | Both | Float value to send |
| Analog Send 1–4 | Button/Trigger | Input | Transmit analog value |
| Analog State 1–4 | Indicator/Text | Output | Current polled analog value |

---

## Protocol Notes

- **Transport**: HTTP GET (or HTTPS for Gen.2 Miniservers)
- **Authentication**: HTTP Basic Auth via `User`/`Password` fields in `HttpClient.Download`
- **Commands**: `GET /dev/sps/io/<ControlName>/On|Off|Pulse|<value>`
- **Status polling**: `GET /dev/sps/io/<ControlName>/state`
- **Response format**: `<LL control="..." value="1" Code="200"/>`
- **Control names**: Must match exactly what is defined in Loxone Config. Spaces and special characters are URL-encoded automatically.
- **Limitation**: Web Services API supports physical inputs/outputs only, not function blocks.

---

## Loxone Config Name Rules

- Names must match exactly as configured in Loxone Config
- Spaces are supported (auto URL-encoded to `%20`)
- Avoid special characters (`&`, `#`, `?`) in Loxone Config for simplicity
- Case-sensitive matching on the Miniserver

---

*Loxone Miniserver Q-SYS Plugin v1.0.0 — Based on Loxone Web Services API*
