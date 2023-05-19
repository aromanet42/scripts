package fr.aromanet42.my3status;

import fr.aromanet42.my3status.bar.I3BarConfiguration;
import fr.aromanet42.my3status.bar.items.GithubPr;
import fr.aromanet42.my3status.thirdparty.github.GithubConfiguration;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;
import org.springframework.context.annotation.Import;

import java.util.List;

@SpringBootApplication
@Import({
        JacksonAutoConfiguration.class,
        I3BarConfiguration.class,
        GithubConfiguration.class,
})
public class Runner implements ApplicationRunner {
    private final GithubPr githubPr;

    public Runner(GithubPr githubPr) {
        this.githubPr = githubPr;
    }


    public static void main(String[] args) {
        SpringApplication.run(Runner.class, args);
    }

    @Override
    public void run(ApplicationArguments args) {
        List<String> arguments = args.getNonOptionArgs();

        if (arguments.contains("github")) {
            githubPr.recalculate();
            System.out.println(githubPr.getItems());
            System.exit(0);
        }
    }
}
