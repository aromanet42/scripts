package fr.aromanet42.my3status.process;

import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class ProcessExecutor {

    public String exec(ProcessBuilder processBuilder) throws IOException {
        Process process = processBuilder.start();
        return new String(process.getInputStream().readAllBytes());
    }
}
