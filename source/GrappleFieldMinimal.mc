using Toybox.Activity;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;
using Toybox.Attention;
using Toybox.FitContributor;

// OPTION 1: Minimal field - just shows DRILL/COMBAT
// Use with native Garmin fields for HR, Time, Lap Time
class GrappleFieldMinimal extends WatchUi.DataField {
    
    private const MODE_DRILL = 0;
    private const MODE_COMBAT = 1;
    
    private var mCurrentMode as Lang.Number = MODE_DRILL;
    private var mValue as Lang.String = "DRILL";
    
    // FIT Contributor fields
    private var mModeField as FitContributor.Field?;
    private var mSessionModeField as FitContributor.Field?;

    function initialize() {
        DataField.initialize();
        
        // Create FIT fields - these will write to the activity FIT file
        createFitFields();
    }
    
    private function createFitFields() as Void {
        // Create field that records mode every second (record-level)
        mModeField = createField(
            "training_mode",           // Field name in FIT file
            0,                         // Field ID
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType => FitContributor.MESG_TYPE_RECORD, :units => ""}
        );
        
        // Create session summary field
        mSessionModeField = createField(
            "primary_mode",            // Session summary
            1,
            FitContributor.DATA_TYPE_UINT8,
            {:mesgType => FitContributor.MESG_TYPE_SESSION, :units => ""}
        );
    }

    function onLayout(dc as Graphics.Dc) as Void {
        View.setLayout(Rez.Layouts.Layout(dc));
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var valueView = View.findDrawableById("value");
        if (valueView != null && valueView has :setText) {
            // Just show the mode - big and clear
            valueView.setText(mValue);
        }
        View.onUpdate(dc);
    }
    
    function compute(info as Activity.Info) as Void {
        // Update display value
        mValue = (mCurrentMode == MODE_DRILL) ? "DRILL" : "COMBAT";
        
        // Write current mode to FIT file (recorded every second)
        if (mModeField != null) {
            mModeField.setData(mCurrentMode);
        }
    }

    function onTimerLap() as Void {
        // Toggle mode
        mCurrentMode = (mCurrentMode == MODE_DRILL) ? MODE_COMBAT : MODE_DRILL;
        
        // Vibrate feedback
        if (Attention has :vibrate) {
            try {
                var vibrateData = [new Attention.VibeProfile(50, 200)];
                Attention.vibrate(vibrateData);
            } catch (e) {}
        }
        
        System.println("Mode: " + ((mCurrentMode == MODE_DRILL) ? "DRILL" : "COMBAT"));
    }
    
    function onTimerStart() as Void {
        // Set initial session mode when activity starts
        if (mSessionModeField != null) {
            mSessionModeField.setData(mCurrentMode);
        }
    }
    
    // Helper to create FIT field safely
    private function createField(
        displayName as Lang.String,
        fieldId as Lang.Number,
        dataType as FitContributor.DataType,
        options as Lang.Dictionary
    ) as FitContributor.Field? {
        try {
            // Create field only if FitContributor is available
            if (FitContributor has :createField) {
                return FitContributor.createField(displayName, fieldId, dataType, options);
            }
        } catch (e) {
            // FIT contributor not available on this device
            System.println("FIT field creation failed: " + e.getErrorMessage());
        }
        return null;
    }
    function onTimerStop() as Void {}
    function onTimerPause() as Void {}
    function onTimerResume() as Void {}
    function onTimerReset() as Void {}
}