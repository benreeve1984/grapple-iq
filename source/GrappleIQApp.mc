using Toybox.Application;
using Toybox.FitContributor;

class GrappleIQApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {}

    function onStop(state) {}

    function getInitialView() {
        return [new GrappleIQView()];
    }
}