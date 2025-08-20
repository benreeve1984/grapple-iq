using Toybox.Attention;
using Toybox.System;
using Toybox.Lang;

// Helper module for safe vibration with capability checks
class Haptics {
    
    private var mVibrateSupported as Boolean;
    
    function initialize() {
        // Check if vibration is supported
        mVibrateSupported = checkVibrateSupport();
    }
    
    private function checkVibrateSupport() as Boolean {
        var deviceSettings = System.getDeviceSettings();
        
        // Check if Attention module is available
        if (Attention has :vibrate) {
            // Additional check for vibrate count
            if (deviceSettings has :vibrateOn) {
                return deviceSettings.vibrateOn;
            }
            return true;
        }
        
        return false;
    }
    
    // Safe vibrate with fallback
    function vibrate() as Void {
        if (!mVibrateSupported) {
            return;
        }
        
        try {
            // Try to use vibrate pattern if available
            if (Attention has :vibrate) {
                var vibrateData = [
                    new Attention.VibeProfile(50, 200) // 200ms vibration
                ];
                Attention.vibrate(vibrateData);
            } else if (Attention has :playTone) {
                // Fallback to tone if vibrate not available
                Attention.playTone(Attention.TONE_KEY);
            }
        } catch (e) {
            // Silently handle any errors
        }
    }
    
    // Short vibrate for feedback
    function vibrateShort() as Void {
        if (!mVibrateSupported) {
            return;
        }
        
        try {
            if (Attention has :vibrate) {
                var vibrateData = [
                    new Attention.VibeProfile(25, 100) // 100ms short vibration
                ];
                Attention.vibrate(vibrateData);
            }
        } catch (e) {
            // Silently handle any errors
        }
    }
}