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
// Menu button that triggers a service.
//
//-----------------------------------------------------------------------------------

using Toybox.Lang;
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Application.Properties;

class HomeAssistantIconMenuItem extends WatchUi.IconMenuItem {
    hidden var mHomeAssistantService     as HomeAssistantService;

    function initialize(
        label as Lang.String or Lang.Symbol,
        subLabel as Lang.String or Lang.Symbol or Null,
        identifier as Lang.Object or Null,
        service as Lang.String or Null,
        icon as Graphics.BitmapType or WatchUi.Drawable,
        options as {
            :alignment as WatchUi.MenuItem.Alignment
        } or Null
    ) {
        WatchUi.IconMenuItem.initialize(
            label,
            subLabel,
            identifier,
            icon,
            options
        );

        mHomeAssistantService = new HomeAssistantService(service, identifier);

    }

    function callService() as Void {
        mHomeAssistantService.call();
    }

}
