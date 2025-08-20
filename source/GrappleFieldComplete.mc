using Toybox.Activity;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Attention;

// OPTION 2: Complete field - shows everything in one place
// MODE, HR with alert, Total Time, Lap Time
class GrappleFieldComplete extends WatchUi.DataField {
    
    private const MODE_DRILL = 0;
    private const MODE_COMBAT = 1;
    
    private var mCurrentMode as Lang.Number = MODE_DRILL;
    private var mLines as Lang.Array<Lang.String> = ["DRILL", "HR --", "0:00 / 0:00"];
    
    // HR cap alert
    private var mHrCapBpm as Lang.Number = 160;  // Default 160, configurable
    private var mHrOverCapTime as Lang.Number? = null;
    private const HR_ALERT_DELAY_MS = 10000;  // 10 second delay

    function initialize() {
        DataField.initialize();
        loadSettings();
    }
    
    private function loadSettings() as Void {
        var app = Application.getApp();
        var hrCap = app.getProperty("hrCapBpm");
        if (hrCap != null && hrCap instanceof Lang.Number && hrCap > 0) {
            mHrCapBpm = hrCap;
        }
    }

    function onLayout(dc as Graphics.Dc) as Void {
        // Custom layout for multi-line display
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        // Clear background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // Calculate positions for 3 lines
        var width = dc.getWidth();
        var height = dc.getHeight();
        var lineHeight = height / 3;
        
        // Line 1: Mode (large, white)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, lineHeight * 0.5, Graphics.FONT_LARGE, 
                   mLines[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Line 2: HR (medium, colored based on zone)
        var hrColor = Graphics.COLOR_GREEN;
        if (mHrOverCapTime != null) {
            hrColor = Graphics.COLOR_RED;  // Over cap
        }
        dc.setColor(hrColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, lineHeight * 1.5, Graphics.FONT_MEDIUM,
                   mLines[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Line 3: Times (small, gray)
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, lineHeight * 2.5, Graphics.FONT_SMALL,
                   mLines[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
    function compute(info as Activity.Info) as Void {
        // Line 1: Mode
        mLines[0] = (mCurrentMode == MODE_DRILL) ? "DRILL" : "COMBAT";
        
        // Line 2: Heart Rate with emoji
        var hr = 0;
        if (info has :currentHeartRate && info.currentHeartRate != null) {
            hr = info.currentHeartRate;
        }
        mLines[1] = "HR " + hr;
        
        // Check HR cap
        checkHrCap(hr);
        
        // Line 3: Total Time / Lap Time
        var totalTime = formatDuration(info.timerTime);
        var lapTime = "0:00";
        if (info has :elapsedTime && info.elapsedTime != null) {
            lapTime = formatDuration(info.elapsedTime);
        }
        mLines[2] = totalTime + " / " + lapTime;
    }
    
    private function formatDuration(milliseconds as Lang.Number?) as Lang.String {
        if (milliseconds == null || milliseconds < 0) {
            return "0:00";
        }
        
        var totalSeconds = milliseconds / 1000;
        var hours = totalSeconds / 3600;
        var minutes = (totalSeconds % 3600) / 60;
        var seconds = totalSeconds % 60;
        
        if (hours > 0) {
            return hours + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
        } else {
            return minutes + ":" + seconds.format("%02d");
        }
    }
    
    private function checkHrCap(hr as Lang.Number) as Void {
        if (hr > mHrCapBpm) {
            if (mHrOverCapTime == null) {
                // Start tracking over-cap time
                mHrOverCapTime = System.getTimer();
            } else {
                // Check if we've been over cap long enough
                var overDuration = System.getTimer() - mHrOverCapTime;
                if (overDuration > HR_ALERT_DELAY_MS) {
                    // Vibrate alert
                    if (Attention has :vibrate) {
                        try {
                            // Strong vibration pattern for HR alert
                            var vibrateData = [
                                new Attention.VibeProfile(100, 300),
                                new Attention.VibeProfile(0, 200),
                                new Attention.VibeProfile(100, 300)
                            ];
                            Attention.vibrate(vibrateData);
                        } catch (e) {}
                    }
                    // Reset timer to avoid continuous alerts
                    mHrOverCapTime = System.getTimer();
                }
            }
        } else {
            // HR back under cap
            mHrOverCapTime = null;
        }
    }

    function onTimerLap() as Void {
        // Toggle mode
        mCurrentMode = (mCurrentMode == MODE_DRILL) ? MODE_COMBAT : MODE_DRILL;
        
        // Quick vibrate for mode change
        if (Attention has :vibrate) {
            try {
                var vibrateData = [new Attention.VibeProfile(50, 200)];
                Attention.vibrate(vibrateData);
            } catch (e) {}
        }
        
        System.println("Mode: " + ((mCurrentMode == MODE_DRILL) ? "DRILL" : "COMBAT"));
    }
    
    function onTimerStart() as Void {}
    function onTimerStop() as Void {}
    function onTimerPause() as Void {}
    function onTimerResume() as Void {}
    function onTimerReset() as Void {}
}