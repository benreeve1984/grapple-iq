using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.System;

// Helper module for DataFieldAlert banner notifications
class Alerts {
    
    private var mAlertsSupported as Boolean;
    
    function initialize() {
        // Check if DataFieldAlert is supported (SDK >= 3.2.0)
        mAlertsSupported = checkAlertSupport();
    }
    
    private function checkAlertSupport() as Boolean {
        // Check if WatchUi has DataFieldAlert
        if (WatchUi has :DataFieldAlert) {
            return true;
        }
        return false;
    }
    
    // Show a banner alert with text
    function showBanner(text as String) as Void {
        if (!mAlertsSupported) {
            // Fallback: just log to console
            System.println("Alert: " + text);
            return;
        }
        
        try {
            // Create and show DataFieldAlert
            if (WatchUi has :DataFieldAlert) {
                var alert = new WatchUi.DataFieldAlert(text);
                WatchUi.pushView(alert, null, WatchUi.SLIDE_IMMEDIATE);
            }
        } catch (e) {
            // Silently handle any errors
            System.println("Failed to show alert: " + text);
        }
    }
    
    // Show a banner alert with custom duration
    function showBannerWithDuration(text as String, durationMs as Number) as Void {
        if (!mAlertsSupported) {
            System.println("Alert: " + text);
            return;
        }
        
        try {
            if (WatchUi has :DataFieldAlert) {
                // Note: Duration control may not be available in all SDK versions
                var alert = new WatchUi.DataFieldAlert(text);
                WatchUi.pushView(alert, null, WatchUi.SLIDE_IMMEDIATE);
            }
        } catch (e) {
            System.println("Failed to show alert: " + text);
        }
    }
}