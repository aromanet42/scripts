package fr.aromanet42.my3status.thirdparty.github;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import fr.aromanet42.my3status.thirdparty.github.dto.GHCheckRun;
import fr.aromanet42.my3status.thirdparty.github.dto.GHCheckRuns;
import fr.aromanet42.my3status.thirdparty.github.dto.GHHead;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssue;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssueSearchResult;
import fr.aromanet42.my3status.thirdparty.github.dto.GHLabel;
import fr.aromanet42.my3status.thirdparty.github.dto.GHMyself;
import fr.aromanet42.my3status.thirdparty.github.dto.GHPullRequest;
import fr.aromanet42.my3status.thirdparty.github.dto.GHStatus;
import fr.aromanet42.my3status.thirdparty.github.dto.GHStatuses;
import fr.aromanet42.my3status.thirdparty.github.dto.GHUser;
import org.springframework.aot.hint.annotation.RegisterReflectionForBinding;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;




@Configuration
// "native" app have trouble deserializing JSON. We must register here all DTOs that will be deserialized
@RegisterReflectionForBinding({
        GHCheckRun.class,
        GHCheckRuns.class,
        GHHead.class,
        GHIssue.class,
        GHIssueSearchResult.class,
        GHLabel.class,
        GHMyself.class,
        GHPullRequest.class,
        GHStatus.class,
        GHStatuses.class,
        GHUser.class,
})
public class GithubConfiguration {

    @Bean
    public GithubApiClient githubApiClient(@Value("${REPO_USERNAME}") String username,
                                           // this token is defined in .xsessionrc
                                           @Value("${REPO_TOKEN}") String token) {
        return new GithubApiClient(username, token, githubObjectMapper());
    }


    private ObjectMapper githubObjectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);

        objectMapper.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
        return objectMapper;
    }
}
