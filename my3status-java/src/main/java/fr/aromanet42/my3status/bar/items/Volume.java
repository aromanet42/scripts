package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.bar.I3BarItemBuilder;
import fr.aromanet42.my3status.process.ProcessExecutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Arrays;
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class Volume {
    private static final Logger LOGGER = LoggerFactory.getLogger(Volume.class);
    private static final Pattern VOLUME_PATTERN = Pattern.compile("\\[(\\d+)%].*\\[(on|off)]");
    private final ProcessExecutor processExecutor;
    private I3BarItem item;

    public Volume(ProcessExecutor processExecutor) {
        this.processExecutor = processExecutor;
    }

    @Scheduled(fixedDelay = 5, timeUnit = TimeUnit.SECONDS)
    public void recalculate() {
        LOGGER.debug("Recalculate Volume");
        try {
            item = I3BarItemBuilder.builder()
                    .withName("volume")
                    .withFullText(getVolume() + " - " + getMicro())
                    .build();
        } catch (IOException e) {
            LOGGER.error("Error while retrieving volume info", e);
        }
    }

    String getVolume() throws IOException {
        Optional<VolumeInfo> volumeInfoOptional = amixers("Master", "PCM");
        if (volumeInfoOptional.isEmpty()) {
            return "";
        }

        VolumeInfo volumeInfo = volumeInfoOptional.get();
        if (volumeInfo.muted) {
            return "🔇 " + volumeInfo.volume + "% (muted)";
        }
        return "🔊 " + volumeInfo.volume + "%";
    }

    String getMicro() {
        Optional<VolumeInfo> volumeInfoOptional = amixers("Capture", "Mic");
        if (volumeInfoOptional.isEmpty()) {
            return "";
        }

        VolumeInfo micInfo = volumeInfoOptional.get();
        boolean isMuted = micInfo.muted || "0".equals(micInfo.volume);
        return "🎤 " + (isMuted ? "OFF" : "ON");
    }


    private Optional<VolumeInfo> amixers(String... name) {
        return Arrays.stream(name)
                .map(this::amixer)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .findFirst();
    }

    private Optional<VolumeInfo> amixer(String name) {
        try {
            String amixerResult = processExecutor.exec(new ProcessBuilder()
                    .command("amixer", "sget", name)
            );
            if (amixerResult.contains("Unable to find")) {
                return Optional.empty();
            }

            Matcher matcher = VOLUME_PATTERN.matcher(amixerResult);
            if (matcher.find()) {
                return Optional.of(new VolumeInfo(
                        matcher.group(1),
                        "off".equals(matcher.group(2))
                ));
            }

            return Optional.empty();
        } catch (IOException e) {
            return Optional.empty();
        }
    }

    public I3BarItem getItem() {
        return item;
    }

    private record VolumeInfo(
            String volume,
            boolean muted
    ) {
    }
}
