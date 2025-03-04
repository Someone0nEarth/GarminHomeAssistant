//-----------------------------------------------------------------------------------
//
// Distributed under MIT Licence
//   See https://github.com/house-of-abbey/GarminHomeAssistant/blob/main/LICENSE.
//
//-----------------------------------------------------------------------------------
//
// GarminHomeAssistant is a Garmin IQ application written in Monkey C and routinely
// tested on a Venu 2 device. The source code is provided at:
//            https://github.com/house-of-abbey/GarminHomeAssistant.
//
// P A Abbey & J D Abbey & Someone0nEarth, 19 November 2023
//
//
// Description:
//
// Calling a Home Assistant confirmation dialogue view.
//
//-----------------------------------------------------------------------------------

using Toybox.Lang;
// Required for callback method definition
typedef Method as Toybox.Lang.Method;
using Toybox.WatchUi;
using Toybox.Timer;
using Toybox.Application.Properties;

class HomeAssistantConfirmation extends WatchUi.Confirmation {

    function initialize() {
        WatchUi.Confirmation.initialize(WatchUi.loadResource($.Rez.Strings.Confirm));
    }

}

class HomeAssistantConfirmationDelegate extends WatchUi.ConfirmationDelegate {
    private var mConfirmMethod;
    private var mTimer;

    function initialize(callback as Method() as Void) {
        WatchUi.ConfirmationDelegate.initialize();
        mConfirmMethod = callback;
        var timeoutSeconds = Properties.getValue("confirm_timeout") as Lang.Number; 
        if (timeoutSeconds > 0) {
            mTimer = new Timer.Timer();
            mTimer.start(method(:onTimeout), timeoutSeconds * 1000, true);
        }
    }

    function onResponse(response) as Lang.Boolean {
        getApp().getQuitTimer().reset();
        if (mTimer) {
            mTimer.stop();
        }
        if (response == WatchUi.CONFIRM_YES) {
            mConfirmMethod.invoke();
        }
        return true;
    }

    function onTimeout() as Void {
        mTimer.stop();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
