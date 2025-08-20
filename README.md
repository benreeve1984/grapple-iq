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