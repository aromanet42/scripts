package fr.aromanet42.my3status.input;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.I3BarService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.Objects;
import java.util.Optional;
import java.util.Scanner;

@Service
public class InputListener implements Runnable {
    private static final Logger LOGGER = LoggerFactory.getLogger(InputListener.class);
    private final ObjectMapper objectMapper;

    public InputListener(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    @Override
    public void run() {
        LOGGER.info("Starting InputListener");

        Scanner inputScanner = new Scanner(System.in);

        while (inputScanner.hasNext()) {
            processInput(inputScanner.nextLine());
        }
    }

    private void processInput(String input) {
        LOGGER.debug("Raw input: {}", input);
        String cleanInput = cleanInput(input);

        if (!StringUtils.hasText(cleanInput)) {
            return;
        }

        InputItem inputItem;
        try {
            inputItem = objectMapper.readValue(cleanInput, InputItem.class);
        } catch (JsonProcessingException e) {
            LOGGER.error("Error while scanning input", e);
            return;
        }

        Optional<I3BarItem> i3BarItemOptional = I3BarService.I3_BAR.stream()
                .filter(item -> Objects.equals(item.name(), inputItem.name())
                                && Objects.equals(item.instance(), inputItem.instance()))
                .findFirst();

        if (i3BarItemOptional.isEmpty()) {
            LOGGER.error("No item found with name '{}' and instance '{}'", inputItem.name(), inputItem.instance());
            return;
        }

        I3BarItem i3BarItem = i3BarItemOptional.get();

        if (i3BarItem.onClick() == null) {
            LOGGER.error("Item {} was clicked but no 'onClick' command was found", inputItem.name());
            return;
        }

        LOGGER.debug("Running onClick command for item {}", inputItem.name());
        i3BarItem.onClick().run();
    }

    private String cleanInput(String input) {
        // input is an infinite JSON array: it can starts with "[" (first array item) or "," (next array items)
        return input.replaceAll("^\\[", "")
                .replaceAll("^,", "");
    }
}
