package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.bar.I3BarItemBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

@Component
public class DateItem {
    private static final Logger LOGGER = LoggerFactory.getLogger(DateItem.class);
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
            .withZone(ZoneId.of("Europe/Paris"));
    private I3BarItem item;

    @Scheduled(fixedDelay = 45, timeUnit = TimeUnit.SECONDS)
    public void recalculate() {
        LOGGER.debug("Recalculate Date");
        item = I3BarItemBuilder.builder()
                .withName("date")
                .withFullText(DATE_TIME_FORMATTER.format(Instant.now()))
                .build();
    }

    public I3BarItem getItem() {
        return item;
    }
}
