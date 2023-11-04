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
// P A Abbey & J D Abbey, 31 October 2023
//
//
// Description:
//
// Light or switch toggle button that calls the API to maintain the up to date state.
//
//-----------------------------------------------------------------------------------

using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Properties;

class HomeAssistantToggleMenuItem extends WatchUi.ToggleMenuItem {
    hidden var api_key = Properties.getValue("api_key");
    hidden var strNoInternet as Lang.String;

    function initialize(
        label as Lang.String or Lang.Symbol,
        subLabel as Lang.String or Lang.Symbol or {
            :enabled  as Lang.String or Lang.Symbol or Null,
            :disabled as Lang.String or Lang.Symbol or Null
        } or Null,
        identifier,
        enabled as Lang.Boolean,
        options as {
            :alignment as WatchUi.MenuItem.Alignment,
            :icon as Graphics.BitmapType or WatchUi.Drawable or Lang.Symbol
        } or Null
    ) {
        strNoInternet = WatchUi.loadResource($.Rez.Strings.NoInternet);
        WatchUi.ToggleMenuItem.initialize(label, subLabel, identifier, enabled, options);
        api_key = Properties.getValue("api_key");
    }

    private function setUiToggle(state as Null or Lang.String) as Void {
        if (state != null) {
            if (state.equals("on") && !isEnabled()) {
                setEnabled(true);
                WatchUi.requestUpdate();
            } else if (state.equals("off") && isEnabled()) {
                setEnabled(false);
                WatchUi.requestUpdate();
            }
        }
    }

    // Callback function after completing the GET request to fetch the status.
    //
    function onReturnGetState(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void {
        if (Globals.debug) {
            System.println("HomeAssistantToggleMenuItem onReturnGetState() Response Code: " + responseCode);
            System.println("HomeAssistantToggleMenuItem onReturnGetState() Response Data: " + data);
        }
        if (responseCode == 200) {
            var state = data.get("state") as Lang.String;
            if (Globals.debug) {
                System.println((data.get("attributes") as Lang.Dictionary).get("friendly_name") + " State=" + state);
            }
            if (getLabel().equals("...")) {
                setLabel((data.get("attributes") as Lang.Dictionary).get("friendly_name") as Lang.String);
            }
            setUiToggle(state);
        }
    }

    function getState() as Void {
        var options = {
            :method  => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Authorization" => "Bearer " + api_key
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        if (System.getDeviceSettings().phoneConnected && System.getDeviceSettings().connectionAvailable) {
            var url = Properties.getValue("api_url") + "/states/" + mIdentifier;
            if (Globals.debug) {
                System.println("URL=" + url);
            }
            Communications.makeWebRequest(
                url,
                null,
                options,
                method(:onReturnGetState)
            );
        } else {
            if (Globals.debug) {
                System.println("HomeAssistantToggleMenuItem Note - getState(): No Internet connection, skipping API call.");
            }
            new Alert({
                :timeout => Globals.alertTimeout,
                :font    => Graphics.FONT_SYSTEM_TINY,
                :text    => strNoInternet,
                :fgcolor => Graphics.COLOR_RED,
                :bgcolor => Graphics.COLOR_BLACK
            }).pushView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

    // Callback function after completing the POST request to set the status.
    //
    function onReturnSetState(responseCode as Lang.Number, data as Null or Lang.Dictionary or Lang.String) as Void {
        if (Globals.debug) {
            System.println("HomeAssistantToggleMenuItem onReturnGetState() Response Code: " + responseCode);
            System.println("HomeAssistantToggleMenuItem onReturnGetState() Response Data: " + data);
        }
        if (responseCode == 200) {
            var state;
            var d = data as Lang.Array;
            for(var i = 0; i < d.size(); i++) {
                if ((d[i].get("entity_id") as Lang.String).equals(mIdentifier)) {
                    state = d[i].get("state") as Lang.String;
                    if (Globals.debug) {
                        System.println((d[i].get("attributes") as Lang.Dictionary).get("friendly_name") + " State=" + state);
                    }
                    setUiToggle(state);
                }
            }
        }
    }

    function setState(s as Lang.Boolean) as Void {
        var options = {
            :method  => Communications.HTTP_REQUEST_METHOD_POST,
            :headers => {
                "Content-Type"  => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => "Bearer " + api_key
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        if (System.getDeviceSettings().phoneConnected && System.getDeviceSettings().connectionAvailable) {
            var url;
            if (s) {
                url = Properties.getValue("api_url") + "/services/" + mIdentifier.substring(0, mIdentifier.find(".")) + "/turn_on";
            } else {
                url = Properties.getValue("api_url") + "/services/" + mIdentifier.substring(0, mIdentifier.find(".")) + "/turn_off";
            }
            if (Globals.debug) {
                System.println("URL=" + url);
                System.println("mIdentifier=" + mIdentifier);
            }
            Communications.makeWebRequest(
                url,
                {
                    "entity_id" => mIdentifier
                },
                options,
                method(:onReturnSetState)
            );
        } else {
            if (Globals.debug) {
                System.println("HomeAssistantToggleMenuItem Note - setState(): No Internet connection, skipping API call.");
            }
            new Alert({
                :timeout => Globals.alertTimeout,
                :font    => Graphics.FONT_SYSTEM_TINY,
                :text    => strNoInternet,
                :fgcolor => Graphics.COLOR_RED,
                :bgcolor => Graphics.COLOR_BLACK
            }).pushView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

}
