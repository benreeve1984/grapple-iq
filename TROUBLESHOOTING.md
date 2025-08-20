# Garmin Upload Troubleshooting Guide

## Current Issue
"There was an error processing the manifest file" with no specific details.

## Files to Try (in order)
1. **`grapple-iq-v1.iq`** - Has version="1.0.0" attribute
2. **`grapple-final.iq`** - Cleanest structure
3. **`grapple-iq-minimal.iq`** - Minimal devices

## Common Hidden Issues

### 1. Developer Account Issues
- [ ] Is your developer account fully verified?
- [ ] Have you accepted all developer agreements?
- [ ] Is your account in good standing?
- [ ] Try logging out and back in

### 2. Browser Issues
- [ ] Try in Incognito/Private mode
- [ ] Try different browser (Chrome, Firefox, Safari)
- [ ] Clear ALL cookies for garmin.com
- [ ] Disable browser extensions

### 3. File Upload Issues
- [ ] File must be < 15MB (ours is 13KB ✓)
- [ ] Filename should not have special characters
- [ ] Try renaming to simple name like `app.iq`

### 4. Manifest Requirements (All Met ✓)
```xml
✓ XML declaration: <?xml version="1.0"?>
✓ Namespace: xmlns:iq="http://www.garmin.com/xml/connectiq"
✓ Version: version="3"
✓ UUID format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
✓ Entry point: matches class name
✓ At least one product
✓ Permissions declared
```

## Alternative Upload Methods

### 1. Try the Old Upload Page
Sometimes the legacy upload page works better:
https://apps.garmin.com/en-US/developer/tools/upload

### 2. Use Eclipse Plugin
Download Garmin's Eclipse IDE plugin which can upload directly.

### 3. Contact Support
If nothing works, contact Garmin developer support with:
- Your .iq file
- Screenshot of error
- Browser console log

## Validation Test
Run this locally to check manifest:
```bash
# Validate XML structure
xmllint --noout manifest.xml

# Check for hidden characters
cat manifest.xml | od -c | head

# Verify UTF-8 encoding
file -I manifest.xml
```

## Nuclear Option
1. Create brand new project in VS Code
2. Use Monkey C extension to generate manifest
3. Copy only source files over
4. Build and upload

## What We've Verified ✓
- [x] Valid XML syntax
- [x] Correct namespace
- [x] Proper UUID format
- [x] Entry point matches class
- [x] FitContributor permission
- [x] At least one device
- [x] File builds successfully
- [x] File runs in simulator

The manifest IS valid - the issue is likely account/browser related.