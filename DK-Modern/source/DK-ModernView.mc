import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor;
import Toybox.Activity;
import Toybox.Weather;

(:background)
class DK_ModernView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // Layout nepoužíváme - kreslíme přímo
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Vyčištění displeje černou barvou
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        // Získání rozměrů displeje pro centrování
        var width = dc.getWidth();
        var centerX = width / 2;
        var screenCenterY = dc.getHeight() / 2;

        // Získání času
        var clockTime = System.getClockTime();
        var timeStr = Lang.format("$1$:$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);

        // Získání datumu
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateStr = Lang.format("$1$.$2$.", [
            today.day.format("%02d"),
            (today.month).format("%02d")
        ]);

        // Získání tepu
        var heartRate = "--";
        var hrInfo = Activity.getActivityInfo();
        if (hrInfo != null && hrInfo.currentHeartRate != null) {
            heartRate = hrInfo.currentHeartRate.toString();
        } else {
            var hrIterator = ActivityMonitor.getHeartRateHistory(1, true);
            if (hrIterator != null) {
                var sample = hrIterator.next();
                if (sample != null && sample.heartRate != null) {
                    heartRate = sample.heartRate.toString();
                }
            }
        }
        var heartStr = heartRate;

        // Získání kroků
        var steps = ActivityMonitor.getInfo().steps;
        var stepsStr = steps.toString();

        // Získání počasí
        var weatherInfo = Weather.getCurrentConditions();
        var tempStr = "--°C";
        if (weatherInfo != null && weatherInfo.temperature != null) {
            tempStr = weatherInfo.temperature.format("%d") + "°C";
        }

        // Vykreslení vodorovných čar nad a pod časem
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        
        // Horní vodorovná čára
        dc.drawLine(centerX - 100, screenCenterY - 40, centerX + 100, screenCenterY - 40);
        // Horní svislá čára
        dc.drawLine(width/2, screenCenterY - 95, width/2, screenCenterY - 40);
        
        // Spodní vodorovná čára
        dc.drawLine(width/4, screenCenterY + 45, width*3/4, screenCenterY + 45);
        // Spodní svislá čára
        dc.drawLine(width/2, screenCenterY + 45, width/2, screenCenterY + 85);

        // Nastavení bílé barvy pro text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Vykreslení tepu vlevo nahoře a teploty vpravo nahoře
        dc.drawText(width/2 - 10, screenCenterY - 80, Graphics.FONT_XTINY, heartStr, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(width/2 + 10, screenCenterY - 80, Graphics.FONT_XTINY, tempStr, Graphics.TEXT_JUSTIFY_LEFT);

        // Vykreslení času (extra velké písmo, uprostřed)
        dc.drawText(centerX, screenCenterY - 50, Graphics.FONT_NUMBER_HOT, timeStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Vykreslení datumu vlevo dole a kroků vpravo dole
        dc.drawText(width/2 - 10, screenCenterY + 70, Graphics.FONT_XTINY, dateStr, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(width/2 + 10, screenCenterY + 70, Graphics.FONT_XTINY, stepsStr, Graphics.TEXT_JUSTIFY_LEFT);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
