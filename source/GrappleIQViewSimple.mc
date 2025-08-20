using Toybox.Activity;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Attention;
using Toybox.Time;

class GrappleIQViewSimple extends WatchUi.SimpleDataField {
    
    // Mode constants
    private const MODE_DRILL = 0;
    private const MODE_COMBAT = 1;
    
    // Current mode
    private var mCurrentMode as Lang.Number = MODE_DRILL;
    
    // HR cap settings
    private var mHrCapBpm as Lang.Number? = null;
    private var mHrCapExceededStartTime as Lang.Number? = null;
    private const HR_CAP_DEBOUNCE_MS = 10000; // 10 seconds
    
    // Last lap press time (to prevent double trigger)
    private var mLastLapTime as Lang.Number = 0;

    function initialize() {
        SimpleDataField.initialize();
        // Don't set label here - let it be automatic based on mode
        
        // Load settings
        loadSettings();
    }
    
    private function loadSettings() as Void {
        // Load HR cap setting from app properties
        var app = Application.getApp();
        var hrCap = app.getProperty("hrCapBpm");
        if (hrCap != null && hrCap instanceof Lang.Number && hrCap > 0) {
            mHrCapBpm = hrCap as Lang.Number;
        }
    }

    function onTimerLap() as Void {
        // Debounce lap presses
        var currentTime = System.getTimer();
        if (currentTime - mLastLapTime < 1000) {
            return;
        }
        mLastLapTime = currentTime;
        
        // Toggle mode on LAP press
        if (mCurrentMode == MODE_DRILL) {
            mCurrentMode = MODE_COMBAT;
        } else {
            mCurrentMode = MODE_DRILL;
        }
        
        // Vibrate to confirm mode change
        if (Attention has :vibrate) {
            try {
                var vibrateData = [
                    new Attention.VibeProfile(50, 200) // 200ms vibration
                ];
                Attention.vibrate(vibrateData);
            } catch (e) {
                // Vibration not supported
            }
        }
        
        // Log mode change
        var modeName = (mCurrentMode == MODE_DRILL) ? "DRILL" : "COMBAT";
        System.println("Mode changed to: " + modeName);
    }

    function compute(info as Activity.Info) as Lang.Numeric or Time.Duration or Lang.String or Null {
        // HR cap check (if configured)
        checkHeartRateCap(info);
        
        // Build display string
        var modeName = (mCurrentMode == MODE_DRILL) ? "DRILL" : "COMBAT";
        var hr = 0;
        if (info has :currentHeartRate && info.currentHeartRate != null) {
            hr = info.currentHeartRate as Lang.Number;
        }
        
        return modeName + "  HR " + hr;
    }
    
    private function checkHeartRateCap(info as Activity.Info) as Void {
        // Only check if HR cap is configured
        if (mHrCapBpm == null) {
            return;
        }
        
        var currentHr = null;
        if (info has :currentHeartRate) {
            currentHr = info.currentHeartRate;
        }
        
        if (currentHr == null) {
            // No HR data, reset debounce
            mHrCapExceededStartTime = null;
            return;
        }
        
        if (currentHr > mHrCapBpm) {
            // HR exceeds cap
            if (mHrCapExceededStartTime == null) {
                // Start debounce timer
                mHrCapExceededStartTime = System.getTimer();
            } else {
                // Check if debounce period exceeded
                var exceededDuration = System.getTimer() - mHrCapExceededStartTime;
                if (exceededDuration > HR_CAP_DEBOUNCE_MS) {
                    // Vibrate for HR cap alert (only once per exceeded period)
                    if (Attention has :vibrate) {
                        try {
                            var vibrateData = [
                                new Attention.VibeProfile(50, 400) // 400ms vibration for HR alert
                            ];
                            Attention.vibrate(vibrateData);
                        } catch (e) {
                            // Vibration not supported
                        }
                    }
                    // Reset to prevent continuous vibration
                    mHrCapExceededStartTime = System.getTimer();
                }
            }
        } else {
            // HR back below cap, reset debounce
            mHrCapExceededStartTime = null;
        }
    }
}