# Final Testing Checklist Before Upload

## Test File: `grapple-iq-final-release.iq` (34KB)

### Simulator Testing ✓

#### 1. Basic Display
- [ ] App loads without crashing
- [ ] Shows "DRILL" on initial load
- [ ] Text is readable and centered
- [ ] No graphical glitches

#### 2. Mode Switching
- [ ] Start an activity (Run/Bike/etc)
- [ ] Press LAP button
- [ ] Mode changes from DRILL → COMBAT
- [ ] Vibration feedback occurs
- [ ] Console shows "Mode: COMBAT"
- [ ] Press LAP again
- [ ] Mode changes back to COMBAT → DRILL

#### 3. Heart Rate Display
- [ ] Enable HR simulation (Simulation → FIT Data)
- [ ] Set HR to 150 bpm
- [ ] Display shows "DRILL 150" or "COMBAT 150"
- [ ] HR updates correctly

#### 4. Memory Check
- [ ] View → Profiler → Memory
- [ ] Memory usage stays stable
- [ ] No memory leaks during mode switching
- [ ] Usage under 32KB limit

#### 5. Multi-Field Layout
- [ ] Add to 1-field screen - looks good
- [ ] Add to 2-field screen - text scales properly
- [ ] Add to 4-field screen - still readable

#### 6. Activity Recording
- [ ] Start activity
- [ ] Toggle modes 2-3 times
- [ ] Stop and save activity
- [ ] Check console for FIT field messages

### Console Output Check
Expected messages during testing:
```
Timer started
Mode: COMBAT
Mode: DRILL
Timer stopped
```

### Known Working Features
✅ DRILL/COMBAT mode display
✅ LAP button toggle
✅ Vibration feedback
✅ FIT field recording (training_mode, primary_mode)
✅ HR display integration

### Known Limitations
- DataFieldAlert banners don't show in simulator (normal)
- FIT fields can't be verified in simulator (need real device)
- HR cap alert requires 10+ seconds over threshold

### Pre-Upload Verification
- [x] File size is 34KB (packaged correctly)
- [x] Built with -e -r flags (package + release)
- [x] Manifest has version="1.0.0"
- [x] UUID is unique
- [x] All device IDs are valid

### If All Tests Pass ✅
1. Upload `grapple-iq-final-release.iq` to Garmin
2. File should now be accepted (manifest is embedded)
3. Complete store listing information
4. Submit for review

### If Tests Fail ❌
- Check console for error messages
- Note which test failed
- We'll debug before uploading