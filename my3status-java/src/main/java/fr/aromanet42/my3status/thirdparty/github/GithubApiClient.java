package fr.aromanet42.my3status.thirdparty.github;

import com.fasterxml.jackson.databind.ObjectMapper;
import fr.aromanet42.my3status.thirdparty.HttpClientUtils;
import fr.aromanet42.my3status.thirdparty.github.dto.GHCheckRun;
import fr.aromanet42.my3status.thirdparty.github.dto.GHCheckRuns;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssue;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssueSearchResult;
import fr.aromanet42.my3status.thirdparty.github.dto.GHMyself;
import fr.aromanet42.my3status.thirdparty.github.dto.GHPullRequest;
import fr.aromanet42.my3status.thirdparty.github.dto.GHStatus;
import fr.aromanet42.my3status.thirdparty.github.dto.GHStatuses;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

public class GithubApiClient {
    private static final Logger LOGGER = LoggerFactory.getLogger(GithubApiClient.class);
    private final HttpClient httpClient;
    private final String authorizationHeader;
    private final ObjectMapper objectMapper;

    public GithubApiClient(String username,
                           String token,
                           ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newHttpClient();
        authorizationHeader = HttpClientUtils.basicHeader(username, token);
    }

    public String getLoggedUser() {
        try {
            GHMyself myself = get("https://api.github.com/user", GHMyself.class);
            LOGGER.debug("Github connected: {}", myself.getLogin());
            return myself.getLogin();
        } catch (Exception e) {
            LOGGER.error("Github error", e);
            return "";
        }
    }

    public List<GHIssue> listPRs(String loggedUser) {
        try {
            return get("https://api.github.com/search/issues?q=involves:%s+is:open+type:pr".formatted(loggedUser), GHIssueSearchResult.class)
                    .getItems();
        } catch (Exception e) {
            LOGGER.error("Error while searching PRs", e);
            return new ArrayList<>();
        }
    }

    public GHPullRequest getPR(String repositoryName, long number) {
        return get("https://api.github.com/repos/%s/pulls/%s".formatted(repositoryName, number), GHPullRequest.class);
    }

    public List<GHStatus> getStatuses(String repositoryFullName, String sha) {
        return get("https://api.github.com/repos/%s/status/%s".formatted(repositoryFullName, sha), GHStatuses.class)
                .getStatuses();
    }

    public List<GHCheckRun> getChecks(String repositoryFullName, String sha) {
        return get("https://api.github.com/repos/%s/commits/%s/check-runs".formatted(repositoryFullName, sha), GHCheckRuns.class)
                .getCheckRuns();
    }

    private <T> T get(String url, Class<T> responseClass) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .header("Authorization", this.authorizationHeader)
                    .header("Accept", "application/vnd.github.v3+json")
                    .uri(URI.create(url))
                    .GET()
                    .build();

            HttpResponse<String> httpResponse = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            String responseBody = httpResponse.body();
            return objectMapper.readValue(responseBody, responseClass);
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException("Error while calling Github API", e);
        }
    }
}
