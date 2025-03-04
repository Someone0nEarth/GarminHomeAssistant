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
// P A Abbey & J D Abbey & Someone0nEarth, 31 October 2023
//
//
// Description:
//
// Home Assistant centralised constants.
//
//-----------------------------------------------------------------------------------

using Toybox.Lang;

class Globals {
    // Enable printing of messages to the debug console (don't make this a Property
    // as the messages can't be read from a watch!)
    static const scDebug        = false;
    static const scAlertTimeout = 2000; // ms
    static const scTapTimeout   = 1000; // ms
}
