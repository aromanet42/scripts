package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.bar.I3BarItemBuilder;
import fr.aromanet42.my3status.process.ProcessExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

@Component
public class ControlCenter {
    private static final Logger LOGGER = LoggerFactory.getLogger(ControlCenter.class);
    private final ProcessExecutor processExecutor;
    private I3BarItem item;

    public ControlCenter(ProcessExecutor processExecutor) {
        this.processExecutor = processExecutor;
    }

    @Scheduled(fixedDelay = 1, timeUnit = TimeUnit.HOURS)
    public void recalculate() {
        LOGGER.debug("Recalculate ControlCenter");
        item = I3BarItemBuilder.builder()
                .withName("control-center")
                .withFullText("💻")
                .withOnClick(this::onClick)
                .build();
    }

    public I3BarItem getItem() {
        return item;
    }

    private void onClick() {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder()
                    .command("gnome-control-center");
            processBuilder.environment().put("XDG_CURRENT_DESKTOP", "GNOME");
            processExecutor.exec(processBuilder);
        } catch (Exception e) {
            LOGGER.error("Error while executing command for ControlCenter", e);
        }

    }
}
