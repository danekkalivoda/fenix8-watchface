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
        
        // Nastavení bílé barvy pro text
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Získání času
        var clockTime = System.getClockTime();
        var timeStr = Lang.format("$1$:$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);

        // Získání datumu - použijeme format() pro zaručení dvoumístného formátu
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateStr = Lang.format("$1$.$2$.", [
            today.day.format("%02d"),
            (today.month + 1).format("%02d")  // Gregorian používá měsíce 0-11, format() zajistí dvoumístný formát
        ]);

        // Získání stavu baterie
        var battery = System.getSystemStats().battery;
        var batteryStr = battery.format("%d") + "%";

        // Získání počtu kroků
        var steps = ActivityMonitor.getInfo().steps;
        var stepsStr = steps.toString();

        // Získání počasí
        var weatherInfo = Weather.getCurrentConditions();
        var tempStr = "--°C";
        if (weatherInfo != null && weatherInfo.temperature != null) {
            tempStr = weatherInfo.temperature.format("%d") + "°C";
        }

        // Získání srdečního tepu
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

        // Vykreslení času (velké písmo, uprostřed nahoře)
        var centerX = dc.getWidth() / 2;
        dc.drawText(centerX, 40, Graphics.FONT_LARGE, timeStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Vykreslení datumu (menší písmo, pod časem)
        dc.drawText(centerX, 80, Graphics.FONT_MEDIUM, dateStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Vykreslení tepu (menší písmo, pod datumem)
        dc.drawText(centerX, 120, Graphics.FONT_MEDIUM, heartStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Vykreslení kroků (menší písmo, pod tepem)
        dc.drawText(centerX, 160, Graphics.FONT_MEDIUM, stepsStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Vykreslení teploty (menší písmo, pod kroky)
        dc.drawText(centerX, 200, Graphics.FONT_MEDIUM, tempStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Vykreslení stavu baterie (malé písmo, úplně dole)
        dc.drawText(centerX, 240, Graphics.FONT_SMALL, batteryStr, Graphics.TEXT_JUSTIFY_CENTER);
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
