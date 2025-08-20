using Toybox.Activity;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Attention;

class GrappleDataField extends WatchUi.DataField {
    
    // Mode constants
    private const MODE_CLASS = 0;
    private const MODE_COMBAT = 1;
    
    // Current mode
    private var mCurrentMode as Lang.Number = MODE_CLASS;
    
    // HR cap settings
    private var mHrCapBpm as Lang.Number? = null;
    private var mHrCapExceededStartTime as Lang.Number? = null;
    private const HR_CAP_DEBOUNCE_MS = 10000; // 10 seconds
    
    // Field label and value
    private var mValue as Lang.String;

    function initialize() {
        DataField.initialize();
        mValue = "CLASS";
        
        // Load settings
        loadSettings();
    }
    
    private function loadSettings() as Void {
        var app = Application.getApp();
        var hrCap = app.getProperty("hrCapBpm");
        if (hrCap != null && hrCap instanceof Lang.Number && hrCap > 0) {
            mHrCapBpm = hrCap as Lang.Number;
        }
    }

    // Layout - use simple centered text
    function onLayout(dc as Graphics.Dc) as Void {
        View.setLayout(Rez.Layouts.Layout(dc));
        
        // Find the label and value fields
        var labelView = View.findDrawableById("label");
        var valueView = View.findDrawableById("value");
        
        // Update label text
        if (labelView != null && labelView has :setText) {
            labelView.setText("MODE");
        }
    }

    // Update display
    function onUpdate(dc as Graphics.Dc) as Void {
        // Find the value field
        var valueView = View.findDrawableById("value");
        if (valueView != null && valueView has :setText) {
            valueView.setText(mValue);
        }
        
        // Call parent
        View.onUpdate(dc);
    }
    
    // Compute is called every second during activity
    function compute(info as Activity.Info) as Void {
        // HR cap check (if configured)
        checkHeartRateCap(info);
        
        // Build display string
        var modeName = (mCurrentMode == MODE_CLASS) ? "CLASS" : "COMBAT";
        var hr = 0;
        if (info has :currentHeartRate && info.currentHeartRate != null) {
            hr = info.currentHeartRate as Lang.Number;
        }
        
        mValue = modeName + " " + hr;
    }

    // Handle LAP button press
    function onTimerLap() as Void {
        System.println("onTimerLap called!");
        
        // Toggle mode on LAP press
        if (mCurrentMode == MODE_CLASS) {
            mCurrentMode = MODE_COMBAT;
            System.println("Switched to COMBAT mode");
        } else {
            mCurrentMode = MODE_CLASS;
            System.println("Switched to CLASS mode");
        }
        
        // Vibrate to confirm mode change
        if (Attention has :vibrate) {
            try {
                var vibrateData = [
                    new Attention.VibeProfile(50, 200) // 200ms vibration
                ];
                Attention.vibrate(vibrateData);
                System.println("Vibration triggered");
            } catch (e) {
                System.println("Vibration failed: " + e.getErrorMessage());
            }
        } else {
            System.println("Vibration not supported");
        }
    }
    
    // Timer lifecycle methods
    function onTimerStart() as Void {
        System.println("Timer started");
    }
    
    function onTimerStop() as Void {
        System.println("Timer stopped");
    }
    
    function onTimerPause() as Void {
        System.println("Timer paused");
    }
    
    function onTimerResume() as Void {
        System.println("Timer resumed");
    }
    
    function onTimerReset() as Void {
        System.println("Timer reset");
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
                    // Vibrate for HR cap alert
                    if (Attention has :vibrate) {
                        try {
                            var vibrateData = [
                                new Attention.VibeProfile(50, 400) // 400ms for HR alert
                            ];
                            Attention.vibrate(vibrateData);
                            System.println("HR cap alert vibration");
                        } catch (e) {
                            // Vibration failed
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