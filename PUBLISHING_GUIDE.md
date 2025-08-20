# Publishing to Garmin Connect IQ Store

## Prerequisites ✅

### 1. Create Developer Account
1. Go to https://apps.garmin.com/en-US/developer/upload
2. Sign in with your Garmin Connect account
3. Accept developer agreement
4. Fill out developer profile

### 2. Prepare Store Assets

#### Required Files:
- **App Icon**: 512x512px PNG (store listing)
- **Screenshots**: At least 3 (390x390px for round watches)
- **Hero Banner**: 1080x540px (optional but recommended)

Let's create these:

```bash
# App icon is already at: resources/drawables/launcher_icon.svg
# Need to export as 512x512 PNG for store

# Take screenshots in simulator:
# 1. Run app in simulator
# 2. File → Capture Screenshot
# 3. Save 3-5 different states (CLASS mode, COMBAT mode, etc.)
```

#### App Description Template:
```
Title: Grapple IQ - Training Mode Tracker

Short Description (100 chars):
Track CLASS and COMBAT training modes for martial arts. Switch modes with LAP button.

Full Description:
Grapple IQ is a specialized data field for martial arts training that tracks two distinct training modes:

FEATURES:
• CLASS Mode - Technical training and drilling
• COMBAT Mode - Live rolling and sparring  
• Quick mode toggle with LAP button
• Vibration feedback on mode change
• Records mode data to FIT file for analysis
• Clean, large display optimized for training

USAGE:
1. Add to any data screen in your activity
2. Press LAP button to toggle between CLASS and COMBAT
3. Review mode data in Garmin Connect after training

Perfect for:
• Brazilian Jiu-Jitsu
• MMA Training
• Wrestling
• Judo
• Any combat sport with technical and live training phases

Optimized for multi-field data screens. Pair with native HR, Timer, and Lap Time fields for complete training metrics.
```

---

## Build Release Version

### 1. Generate Release Build (.iq file)

```bash
# Build for ALL devices (creates .iq package)
export PATH="$PATH:$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.2.3-2025-08-11-cac5b3b21/bin"

# Create release build
monkeyc -o grapple-iq.iq \
        -f monkey.jungle \
        -y developer_key.der \
        -r

# This creates grapple-iq.iq (the store package)
```

### 2. Test Release Build
```bash
# Test on different devices before submission
monkeydo grapple-iq.iq fenix7
monkeydo grapple-iq.iq fr965
monkeydo grapple-iq.iq venu3
```

---

## Submit to Store

### 1. Upload Process

1. Go to: https://apps.garmin.com/en-US/developer/apps
2. Click "Upload New App"
3. Fill out the form:

#### Basic Information:
- **App Name**: Grapple IQ
- **App Type**: Data Field
- **Category**: Fitness & Health
- **Sub-category**: Training

#### Version Information:
- **Version**: 1.0.0
- **What's New**: Initial release

#### Upload Files:
- **IQ File**: grapple-iq.iq
- **App Icon**: 512x512 PNG
- **Screenshots**: 3-5 images
- **Hero Image**: Optional

#### Pricing:
- **Price**: Free (recommended for first app)
- Or set price ($0.99 - $9.99)

#### App Details:
- Paste description from template above
- Add keywords: martial arts, bjj, mma, training, combat, grappling

### 2. Device Compatibility
- Already set in manifest.xml (100+ devices)
- Review and confirm all checked devices

### 3. Submit for Review
- Click "Submit for Review"
- Review typically takes 2-5 business days
- You'll get email updates on status

---

## Pre-Submission Checklist

- [ ] Test on at least 3 different device types in simulator
- [ ] Verify LAP button works correctly
- [ ] Check memory usage (View → Profiler in simulator)
- [ ] Create compelling screenshots showing both modes
- [ ] Write clear description focusing on benefits
- [ ] Set appropriate version number (1.0.0)
- [ ] Choose free or paid (free gets more downloads)
- [ ] Add relevant keywords for search

---

## Common Review Rejections & Fixes

1. **Memory Issues**: Keep data field under 32KB
2. **Crashes**: Test all edge cases
3. **Poor Description**: Be clear about functionality
4. **Missing Features**: Ensure advertised features work
5. **Icon Issues**: Must be clear at small sizes

---

## After Publishing

1. **Monitor Reviews**: Respond to user feedback
2. **Track Downloads**: Check developer dashboard
3. **Plan Updates**: Fix bugs, add features
4. **Marketing**: Share in BJJ/MMA communities

---

## Quick Commands

```bash
# Build release version
monkeyc -o grapple-iq.iq -f monkey.jungle -y developer_key.der -r

# Test release build
monkeydo grapple-iq.iq fenix7

# Check file size (should be < 100KB)
ls -lh grapple-iq.iq
```

## Support Links

- Developer Portal: https://developer.garmin.com/connect-iq/
- Store Guidelines: https://developer.garmin.com/connect-iq/submit-an-app/
- Developer Forum: https://forums.garmin.com/developer/

Ready to publish! The app is simple, focused, and solves a real problem for martial artists.