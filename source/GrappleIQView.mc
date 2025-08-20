using Toybox.Activity;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.FitContributor;

class GrappleIQView extends WatchUi.DataField {
    
    // Mode constants
    private const MODE_CLASS = 0;
    private const MODE_COMBAT = 1;
    
    // Current mode
    private var mCurrentMode as Number = MODE_CLASS;
    
    // FIT contributor fields
    private var mModeCodeField as FitContributor.Field?;
    private var mModeLapCodeField as FitContributor.Field?;
    private var mGoalModeField as FitContributor.Field?;
    private var mZ1TargetMinField as FitContributor.Field?;
    
    // HR cap settings (configured via Connect IQ settings)
    private var mHrCapBpm as Number? = null;
    private var mHrCapExceededStartTime as Number? = null;
    private const HR_CAP_DEBOUNCE_MS = 10000; // 10 seconds
    
    // Helper modules
    private var mFitSchema as FitSchema;
    private var mHaptics as Haptics;
    private var mAlerts as Alerts;
    
    // Last second for 1Hz updates
    private var mLastSecond as Number = -1;

    function initialize() {
        DataField.initialize();
        
        // Initialize helper modules
        mFitSchema = new FitSchema();
        mHaptics = new Haptics();
        mAlerts = new Alerts();
        
        // Load settings from app properties
        loadSettings();
        
        // Create FIT contributor fields
        createFitFields();
    }
    
    private function loadSettings() as Void {
        // Load HR cap setting from app properties
        var hrCap = Application.getApp().getProperty("hrCapBpm");
        if (hrCap != null && hrCap instanceof Number && hrCap > 0) {
            mHrCapBpm = hrCap;
        }
    }
    
    private function createFitFields() as Void {
        // Record-level mode_code field (updated every second)
        mModeCodeField = mFitSchema.createField(
            "mode_code",
            0, // fieldId
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType => FitContributor.MESG_TYPE_RECORD, :units => ""}
        );
        
        // Lap-level mode_lap_code field
        mModeLapCodeField = mFitSchema.createField(
            "mode_lap_code",
            1, // fieldId
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType => FitContributor.MESG_TYPE_LAP, :units => ""}
        );
        
        // Session-level goal_mode field
        mGoalModeField = mFitSchema.createField(
            "goal_mode",
            2, // fieldId
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units => ""}
        );
        
        // Session-level z1_target_min field
        mZ1TargetMinField = mFitSchema.createField(
            "z1_target_min",
            3, // fieldId
            FitContributor.DATA_TYPE_UINT16,
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units => "s"}
        );
    }

    function onLayout(dc as Graphics.Dc) as Void {
        // Layout will be loaded from resources based on field count
        var layoutName = "Layout";
        View.setLayout(Rez.Layouts[layoutName](dc));
    }

    function onShow() as Void {}

    function onHide() as Void {}

    function onTimerStart() as Void {
        // Set session fields on start from app settings
        var goalMode = Application.getApp().getProperty("goalMode");
        if (goalMode == null || !(goalMode instanceof Number)) {
            goalMode = 1; // Default: hybrid mode
        }
        
        var z1TargetMin = Application.getApp().getProperty("z1TargetMin");
        if (z1TargetMin == null || !(z1TargetMin instanceof Number)) {
            z1TargetMin = 180; // Default: 180 seconds
        }
        
        if (mGoalModeField != null) {
            mGoalModeField.setData(goalMode);
        }
        
        if (mZ1TargetMinField != null) {
            mZ1TargetMinField.setData(z1TargetMin);
        }
        
        // Reload settings in case they changed
        loadSettings();
    }

    function onTimerStop() as Void {}

    function onTimerPause() as Void {}

    function onTimerResume() as Void {}

    function onTimerLap() as Void {
        // Toggle mode on LAP press
        if (mCurrentMode == MODE_CLASS) {
            mCurrentMode = MODE_COMBAT;
        } else {
            mCurrentMode = MODE_CLASS;
        }
        
        // Vibrate to confirm mode change
        mHaptics.vibrate();
        
        // Show DataFieldAlert banner
        var modeName = (mCurrentMode == MODE_CLASS) ? 
            WatchUi.loadResource(Rez.Strings.ModeClass) : 
            WatchUi.loadResource(Rez.Strings.ModeCombat);
        
        mAlerts.showBanner("Mode: " + modeName);
        
        // Update lap field immediately
        if (mModeLapCodeField != null) {
            mModeLapCodeField.setData(mCurrentMode);
        }
    }

    function onTimerReset() as Void {}

    function compute(info as Activity.Info) as Lang.Numeric or Lang.Duration or Lang.String or Null {
        // Get current time in seconds
        var currentSecond = System.getTimer() / 1000;
        
        // 1Hz update logic (every second)
        if (currentSecond != mLastSecond) {
            mLastSecond = currentSecond;
            
            // Update FIT contributor fields
            if (mModeCodeField != null) {
                mModeCodeField.setData(mCurrentMode);
            }
            
            if (mModeLapCodeField != null) {
                mModeLapCodeField.setData(mCurrentMode);
            }
            
            // HR cap check (if configured)
            checkHeartRateCap(info);
        }
        
        // Build display string
        var modeName = (mCurrentMode == MODE_CLASS) ? "CLASS" : "COMBAT";
        var hr = (info.currentHeartRate != null) ? info.currentHeartRate : 0;
        
        return modeName + "  HR " + hr;
    }
    
    private function checkHeartRateCap(info as Activity.Info) as Void {
        // Only check if HR cap is configured
        if (mHrCapBpm == null) {
            return;
        }
        
        var currentHr = info.currentHeartRate;
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
                    mHaptics.vibrate();
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