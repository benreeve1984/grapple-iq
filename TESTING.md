# Testing Guide for Grapple IQ Data Field

## Simulator Setup Complete ✅

The data field is now running in the Fenix 7 simulator. Here's how to test it:

## Testing in the Simulator

### 1. View the Data Field
- The simulator should show the data field displaying "CLASS HR 0"
- This is the initial state (CLASS mode with no HR data)

### 2. Test Mode Switching
- **Press the LAP button** (usually the back/lap button on the watch)
- The display should change to "COMBAT HR 0"
- You should see a console message: "Mode changed to: COMBAT"
- The device should vibrate (simulated)
- Press LAP again to toggle back to CLASS mode

### 3. Simulate Heart Rate Data
In the simulator:
1. Go to **Simulation → FIT Data → Simulate Data**
2. Enable **Heart Rate** simulation
3. Set a heart rate value (e.g., 150 bpm)
4. The display should update to show "CLASS HR 150" or "COMBAT HR 150"

### 4. Test HR Cap Alert
1. The HR cap is set to 160 bpm by default (in properties.xml)
2. Set simulated HR to 165 bpm
3. Wait 10 seconds
4. The device should vibrate to alert you that HR exceeded the cap

### 5. Test Activity Recording
1. In the simulator: **Activity → Start Activity**
2. Choose any activity type (e.g., Run)
3. Add the data field to a data screen
4. Start the activity
5. Press LAP to toggle modes during the activity
6. Stop and save the activity
7. Check the FIT file for custom fields (mode_code, mode_lap_code)

## Console Output
Monitor the console in the simulator for:
- Mode change messages
- Any error messages
- Alert notifications

## Keyboard Shortcuts for Simulator
- **Enter/Return**: Start button
- **Backspace**: Back/Lap button  
- **Up/Down arrows**: Navigate menus
- **Escape**: Back/Stop

## Building for Different Devices

To test on other devices:
```bash
# Build for Forerunner 965
monkeyc -o grapple-iq.prg -f monkey.jungle -y developer_key.der -d fr965

# Build for Venu 3
monkeyc -o grapple-iq.prg -f monkey.jungle -y developer_key.der -d venu3

# Run in simulator
monkeydo grapple-iq.prg fr965
```

## Troubleshooting

### If the app crashes:
- Check the console for error messages
- Verify the manifest.xml has correct permissions
- Ensure all required resources exist

### If LAP doesn't toggle:
- Make sure you're pressing the correct button (Back/Lap)
- Check console for "Mode changed to:" messages
- Verify the activity is started

### If HR cap alert doesn't work:
- Verify HR is above 160 bpm for >10 seconds
- Check console output for debugging
- Ensure vibration is enabled in simulator settings

## Next Steps

1. Test with different HR values
2. Test mode persistence across laps
3. Export FIT file and verify custom fields
4. Test on physical device (sideload the .prg file)