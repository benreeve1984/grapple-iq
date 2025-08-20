# Grapple IQ - Garmin Connect IQ Data Field

A data field for tracking martial arts training sessions with CLASS and COMBAT modes.

## Features

- **Two Training Modes**: CLASS (0) and COMBAT (1)
- **Mode Toggle**: Press LAP button to switch between modes
- **Visual Feedback**: Vibration and banner alert on mode change
- **FIT Data Recording**: Captures mode data at record, lap, and session levels
- **Heart Rate Cap Alert**: Optional vibration alert when HR exceeds threshold for >10 seconds
- **Display**: Shows current mode and heart rate (e.g., "COMBAT HR 152")

## FIT Contributor Fields

The data field records the following custom FIT fields:

- `mode_code` (UINT8, RECORD): Current mode recorded every second
- `mode_lap_code` (UINT8, LAP): Mode for each lap
- `goal_mode` (UINT8, SESSION): Training goal (0=Class, 1=Hybrid, 2=Combat)
- `z1_target_min` (UINT16, SESSION): Zone 1 target duration in seconds

## Settings

Configure via Garmin Connect IQ app settings:

- **HR Cap (BPM)**: Heart rate threshold for alerts (optional)
- **Goal Mode**: Training goal (Class Only/Hybrid/Combat Only)
- **Z1 Target**: Zone 1 target duration in seconds

## Project Structure

```
grapple-iq/
├── manifest.xml           # App configuration
├── monkey.jungle         # Build configuration
├── source/
│   ├── GrappleIQApp.mc   # Main application
│   ├── GrappleIQView.mc  # Data field implementation
│   ├── FitSchema.mc      # FIT contributor helper
│   ├── Haptics.mc        # Vibration helper
│   └── Alerts.mc         # Banner alert helper
└── resources/
    ├── strings/          # Text resources
    ├── layouts/          # UI layouts
    ├── drawables/        # Icons
    └── settings/         # App settings
```

## Building

1. Install Garmin Connect IQ SDK
2. Add desired device products to manifest.xml
3. Build using Connect IQ VS Code extension or command line:
   ```bash
   monkeyc -o grapple-iq.prg -f monkey.jungle -y developer_key
   ```

## Requirements

- Min SDK: 3.2.0
- Permissions: FitContributor
- App Type: Data Field

## Usage

1. Install the data field on your Garmin device
2. Add to a data screen in your activity profile
3. Start activity - begins in CLASS mode
4. Press LAP to toggle between CLASS and COMBAT modes
5. View recorded FIT data after activity

## Compatible Devices

This data field is compatible with most modern Garmin watches including:
- Fenix series (5 Plus, 6, 7, 8)
- Forerunner series (245, 255, 265, 745, 945, 955, 965, 970)
- Epix series
- Venu series
- Instinct series
- MARQ series
- Vivoactive series

See `manifest.xml` for the full list of supported devices.

## Development

### Prerequisites

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
- [Visual Studio Code](https://code.visualstudio.com/) with [Monkey C extension](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c)
- Java Runtime Environment

### Setup

1. Clone the repository
2. Open in VS Code with Monkey C extension
3. Configure SDK path in VS Code settings
4. Generate developer key (if not already done):
   ```bash
   openssl genrsa -out developer_key.pem 4096
   openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out developer_key.der -nocrypt
   ```

### Testing

Use the Connect IQ simulator to test the data field:
1. Build for simulator: `Ctrl+Shift+P` → "Monkey C: Build for Device"
2. Run in simulator: `Ctrl+Shift+P` → "Monkey C: Run App"

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Author

FlowMat - Grappling training optimization through data