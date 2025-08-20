using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

// Helper module for DataFieldAlert banner notifications
class Alerts {
    
    private var mAlertsSupported as Lang.Boolean;
    
    function initialize() {
        // Check if DataFieldAlert is supported (SDK >= 3.2.0)
        mAlertsSupported = checkAlertSupport();
    }
    
    private function checkAlertSupport() as Lang.Boolean {
        // Check if WatchUi has DataFieldAlert
        if (WatchUi has :DataFieldAlert) {
            return true;
        }
        return false;
    }
    
    // Show a banner alert with text
    function showBanner(text as Lang.String) as Void {
        // DataFieldAlert is shown differently - just log for now
        // The alert would be shown from the compute() function
        System.println("Alert: " + text);
    }
    
    // Show a banner alert with custom duration
    function showBannerWithDuration(text as Lang.String, durationMs as Lang.Number) as Void {
        // DataFieldAlert is shown differently - just log for now
        System.println("Alert: " + text);
    }
}