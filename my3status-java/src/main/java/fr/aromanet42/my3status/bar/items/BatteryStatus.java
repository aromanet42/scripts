package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.bar.I3BarItemBuilder;
import fr.aromanet42.my3status.process.ProcessExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class BatteryStatus {
    private static final Logger LOGGER = LoggerFactory.getLogger(BatteryStatus.class);
    private static final Pattern STATE_PATTERN = Pattern.compile("state:\\s*([a-z-]+)");
    private static final Pattern PERCENTAGE_PATTERN = Pattern.compile("percentage:\\s*([0-9]+%)");
    private final ProcessExecutor processExecutor;
    private I3BarItem item;

    public BatteryStatus(ProcessExecutor processExecutor) {
        this.processExecutor = processExecutor;
    }

    @Scheduled(fixedDelay = 5, timeUnit = TimeUnit.SECONDS)
    public void recalculate() {
        LOGGER.debug("Recalculate BatteryStatus");
        I3BarItemBuilder itemBuilder = I3BarItemBuilder.builder()
                .withName("battery");

        try {
            itemBuilder.withFullText(getValue());
        } catch (Exception e) {
            LOGGER.error("Error while retrieving battery info", e);
            itemBuilder.withFullText("Error while retrieving battery info")
                    .withColor(I3BarItem.RED);
        }

        item = itemBuilder.build();
    }

    String getValue() throws IOException {
        String output = processExecutor.exec(new ProcessBuilder()
                .command("upower", "-i", "/org/freedesktop/UPower/devices/battery_BAT0"));
        Matcher stateResult = STATE_PATTERN.matcher(output);
        Matcher percentageResult = PERCENTAGE_PATTERN.matcher(output);

        if (!stateResult.find()) {
            throw new RuntimeException("No STATE_PATTERN match");
        }
        if (!percentageResult.find()) {
            throw new RuntimeException("No PERCENTAGE_PATTERN match");
        }

        String state = stateResult.group(1);
        String percentage = percentageResult.group(1);

        if (state.equals("fully-charged") || state.equals("pending-charge")) {
            return "⚡";
        }
        return "🔋 " + percentage;
    }

    public I3BarItem getItem() {
        return item;
    }

}
