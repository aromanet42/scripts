package fr.aromanet42.my3status.bar;

import fr.aromanet42.my3status.input.InputItem;
import org.springframework.aot.hint.annotation.RegisterReflectionForBinding;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
public class I3BarConfiguration {

    @Profile("!development")
    @EnableScheduling
    @EnableAsync
    // "native" app have trouble deserializing JSON. We must register here all DTOs that will be deserialized
    @RegisterReflectionForBinding({InputItem.class})
    @Configuration
    public static class ProductionConfiguration {

    }

}
