# Heart Rate Alert Setup Guide

## Two Options for Your Training Setup

### Option 1: Multi-Field Screen (RECOMMENDED) 
**Best for flexibility and native Garmin features**

#### Screen Setup:
1. In your activity profile, create a data screen with 4 fields:
   - **Field 1**: Grapple Mode (your custom field - shows CLASS/COMBAT)
   - **Field 2**: Heart Rate (native)
   - **Field 3**: Timer (total time)
   - **Field 4**: Lap Time

#### HR Alert Setup (Native Garmin):
1. Go to activity settings → Alerts → Heart Rate Alert
2. Set custom HR zone:
   - High Alert: 160 bpm (or your threshold)
   - Alert Type: Vibrate + Tone
   - Repeat: Every 30 seconds

**Advantages:**
- ✅ Clean, focused display
- ✅ Native HR zones work perfectly
- ✅ Can customize each field position
- ✅ Battery efficient
- ✅ Works with Garmin's training features

---

### Option 2: All-in-One Custom Field
**Everything in one field**

Display shows:
```
COMBAT
HR 152
12:34 / 3:21
```

#### To Use This Version:
1. Edit `grapple-iqApp.mc`
2. Change to: `return [ new GrappleFieldComplete() ];`
3. Rebuild and deploy

#### Configure HR Cap:
- Edit `properties.xml`: Set `hrCapBpm` value (default 160)
- Alert triggers after 10 seconds above threshold
- Triple vibration pattern for alerts

**Advantages:**
- ✅ All info in one glance
- ✅ Custom HR alert logic
- ✅ Mode-specific HR thresholds possible

**Disadvantages:**
- ❌ Smaller text (everything squeezed)
- ❌ Can't rearrange elements
- ❌ Duplicate of native features

---

## My Recommendation

**Use Option 1 (Multi-Field) because:**

1. **Better Display**: Each metric gets proper space
2. **Native Features**: Garmin's HR zones are battle-tested
3. **Flexibility**: Rearrange fields as needed
4. **Future-Proof**: Your custom field focuses on what's unique (CLASS/COMBAT mode)
5. **Battery**: Native fields are more efficient

Your custom field should do ONE thing well: **Track training mode and record it to FIT file**.

Let Garmin handle HR, time, and alerts - they've already perfected it.

---

## Quick Setup Steps

1. **For Testing Now**: Keep using `GrappleDataField` (current version)
2. **For Production**: Switch to `GrappleFieldMinimal` (cleaner)
3. **Configure Garmin HR Alert**: Set to 160 bpm in activity settings
4. **Create 4-field screen**: Mode, HR, Time, Lap Time

This gives you the best of both worlds!