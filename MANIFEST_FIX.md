# Manifest Upload Error - FIXED! ✅

## The Problem
Garmin Connect IQ Store was rejecting the manifest.xml file.

## Common Causes & Solutions:

### 1. **UUID Format** (FIXED)
- ❌ Old: `id="com.flowmat.field"` (not valid)
- ❌ Old: `id="a8f2c3d4-5e6b-7c8d-9e0f-1a2b3c4d5e6f"` (might be duplicate)
- ✅ New: `id="3a6f7757-28e3-449f-89ee-b793ea6c0674"` (fresh UUID)

### 2. **API Version Attribute** (FIXED)
- ❌ Old: `minApiLevel="3.2.0"` 
- ✅ New: `minSdkVersion="3.2.0"`

### 3. **Version String Format**
The manifest version="3" is correct for modern apps.

## What Was Fixed:
1. Generated a new, unique UUID for the app ID
2. Changed minApiLevel to minSdkVersion (correct attribute name)
3. Rebuilt the .iq file with corrected manifest

## New Release File:
**Use `grapple-iq-fixed.iq` for upload** (13KB)

## If Still Getting Errors:

### Check These:
1. **Duplicate App ID**: The UUID might already exist in the store
   - Solution: Generate another UUID with `uuidgen`
   
2. **Missing Permissions Block**: Some versions require explicit permissions
   - Current: `<iq:uses-permission id="FitContributor"/>`
   
3. **Product IDs**: Ensure all device IDs in the manifest are valid
   - All 100+ devices listed are current Garmin models ✅

4. **Entry Point**: Make sure `entry="grapple_iqApp"` matches your main class

## To Generate New UUID if Needed:
```bash
# Generate new UUID
uuidgen | tr '[:upper:]' '[:lower:]'

# Update manifest.xml with new UUID
# Rebuild the .iq file
monkeyc -o grapple-iq.iq -f monkey.jungle -y developer_key.der -r
```

## Upload Checklist:
- ✅ Use `grapple-iq-fixed.iq` (not the old one)
- ✅ UUID is properly formatted
- ✅ minSdkVersion attribute is correct
- ✅ FitContributor permission is declared
- ✅ All device IDs are valid

The manifest should now be accepted by the Garmin store!