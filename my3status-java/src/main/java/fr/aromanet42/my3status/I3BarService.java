package fr.aromanet42.my3status;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.bar.items.BatteryStatus;
import fr.aromanet42.my3status.bar.items.ControlCenter;
import fr.aromanet42.my3status.bar.items.DateItem;
import fr.aromanet42.my3status.bar.items.GithubPr;
import fr.aromanet42.my3status.bar.items.Volume;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Profile;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Service
@Profile("!development")
public class I3BarService implements ApplicationListener<ContextRefreshedEvent> {
    private static final Logger LOGGER = LoggerFactory.getLogger(I3BarService.class);
    public static List<I3BarItem> I3_BAR = new ArrayList<>();
    private final ObjectMapper objectMapper;
    private final DateItem date;
    private final ControlCenter controlCenter;
    private final BatteryStatus batteryStatus;
    private final Volume volume;
    private final GithubPr githubPr;

    public I3BarService(ObjectMapper objectMapper,
                        DateItem date,
                        ControlCenter controlCenter,
                        BatteryStatus batteryStatus,
                        Volume volume,
                        GithubPr githubPr) {
        this.objectMapper = objectMapper;
        this.date = date;
        this.controlCenter = controlCenter;
        this.batteryStatus = batteryStatus;
        this.volume = volume;
        this.githubPr = githubPr;
    }

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        LOGGER.info("Starting I3Bar");

        // Send the header so that i3bar knows we want to use JSON:
        System.out.println("{\"version\":1, \"click_events\": true}");
        // Begin the endless array.
        System.out.println("[");

        // We send an empty first array of blocks to make the loop simpler:
        System.out.println("[]");
    }

    @Scheduled(fixedDelay = 2, initialDelay = 1, timeUnit = TimeUnit.SECONDS)
    public void run() {
        I3_BAR = bar();

        try {
            System.out.print(",");
            String i3bar = objectMapper.writeValueAsString(I3_BAR);
            LOGGER.trace("Output: {}", i3bar);
            System.out.println(i3bar);
        } catch (JsonProcessingException e) {
            LOGGER.error("Error while serializing i3Bar", e);
        }
    }

    private List<I3BarItem> bar() {
        List<I3BarItem> items = new ArrayList<>(githubPr.getItems());
        items.add(volume.getItem());
        items.add(batteryStatus.getItem());
        items.add(date.getItem());
        items.add(controlCenter.getItem());
        return items;
    }
}
