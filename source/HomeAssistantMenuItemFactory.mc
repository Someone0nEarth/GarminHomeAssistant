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
// P A Abbey & J D Abbey & Someone0nEarth, 17 November 2023
//
//
// Description:
//
// MenuItems Factory.
//
//-----------------------------------------------------------------------------------

using Toybox.Application;
using Toybox.Lang;
using Toybox.WatchUi;

class HomeAssistantMenuItemFactory {
    private var mMenuItemOptions          as Lang.Dictionary;
    private var mLabelToggle              as Lang.Dictionary;
    private var strMenuItemTap            as Lang.String;
    private var bRepresentTypesWithLabels as Lang.Boolean;
    private var mTapTypeIcon              as WatchUi.Bitmap;
    private var mGroupTypeIcon            as WatchUi.Bitmap;
    private var mHomeAssistantService     as HomeAssistantService;

    private static var instance;

    private function initialize() {
        mLabelToggle = {
            :enabled  => WatchUi.loadResource($.Rez.Strings.MenuItemOn)  as Lang.String,
            :disabled => WatchUi.loadResource($.Rez.Strings.MenuItemOff) as Lang.String
        };
        bRepresentTypesWithLabels = Application.Properties.getValue("types_representation") as Lang.Boolean;

        var menuItemAlignment = Application.Properties.getValue("menu_alignment") as Lang.Boolean;
        if(menuItemAlignment){
            mMenuItemOptions = {
                :alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_RIGHT
            };
        } else {
            mMenuItemOptions = {
                :alignment => WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT
            };
        }

        strMenuItemTap = WatchUi.loadResource($.Rez.Strings.MenuItemTap);
        mTapTypeIcon = new WatchUi.Bitmap({
            :rezId => $.Rez.Drawables.TapTypeIcon,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_CENTER
        });

        mGroupTypeIcon = new WatchUi.Bitmap({
            :rezId => $.Rez.Drawables.GroupTypeIcon,
            :locX  => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY  => WatchUi.LAYOUT_VALIGN_CENTER
        });
        mHomeAssistantService = new HomeAssistantService();
    }

    static function create() as HomeAssistantMenuItemFactory {
        if (instance == null) {
            instance = new HomeAssistantMenuItemFactory();
        }
        return instance;
    }

    function toggle(label as Lang.String or Lang.Symbol, identifier as Lang.Object or Null) as WatchUi.MenuItem {
        var subLabel = null;

        if (bRepresentTypesWithLabels == true){
            subLabel=mLabelToggle;
        }
     
        return new HomeAssistantToggleMenuItem(
            label,
            subLabel,
            identifier,
            false,
            mMenuItemOptions
        );
    }

    function tap(
        label      as Lang.String or Lang.Symbol,
        identifier as Lang.Object or Null,
        service    as Lang.String or Null,
        confirm    as Lang.Boolean
    ) as WatchUi.MenuItem {
        if (bRepresentTypesWithLabels) {
            return new HomeAssistantMenuItem(
                label,
                strMenuItemTap,
                identifier,
                service,
                confirm,
                mMenuItemOptions,
                mHomeAssistantService
            );
        } else {
            return new HomeAssistantIconMenuItem(
                label,
                null,
                identifier,
                service,
                confirm,
                mTapTypeIcon,
                mMenuItemOptions,
                mHomeAssistantService
            );
        }
    }

    function group(definition as Lang.Dictionary) as WatchUi.MenuItem {
        if (bRepresentTypesWithLabels) {
            return new HomeAssistantViewMenuItem(definition);
        } else {
            return new HomeAssistantViewIconMenuItem(definition, mGroupTypeIcon, mMenuItemOptions);
        }
    }
}
