package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.bar.I3BarItem;
import fr.aromanet42.my3status.bar.I3BarItemBuilder;
import fr.aromanet42.my3status.bar.items.github.PRCheck;
import fr.aromanet42.my3status.bar.items.github.PRCheckStatus;
import fr.aromanet42.my3status.process.ProcessExecutor;
import fr.aromanet42.my3status.thirdparty.github.GithubApiClient;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssue;
import fr.aromanet42.my3status.thirdparty.github.dto.GHLabel;
import fr.aromanet42.my3status.thirdparty.github.dto.GHPullRequest;
import fr.aromanet42.my3status.thirdparty.github.dto.GHUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Component
public class GithubPr {
    private static final Logger LOGGER = LoggerFactory.getLogger(GithubPr.class);
    private static final String I3BAR_ITEM_NAME = "github-pr";
    private final GithubApiClient githubApiClient;
    private final ProcessExecutor processExecutor;
    private List<I3BarItem> item = new ArrayList<>();

    public GithubPr(GithubApiClient githubApiClient, ProcessExecutor processExecutor) {
        this.githubApiClient = githubApiClient;
        this.processExecutor = processExecutor;
    }

    @Scheduled(fixedDelay = 30, timeUnit = TimeUnit.SECONDS)
    public void recalculate() {
        LOGGER.debug("Recalculate GithubPr");

        try {
            item = buildItems();
            LOGGER.debug("GithubPr done");
        } catch (Exception e) {
            LOGGER.error("Error while calculating Github PRs", e);
        }

    }

    private List<I3BarItem> buildItems() {
        String loggedUser = githubApiClient.getLoggedUser();
        if (loggedUser.isEmpty()) {
            return List.of(I3BarItemBuilder.builder()
                    .withName(I3BAR_ITEM_NAME)
                    .withColor(I3BarItem.RED)
                    .withFullText("%s needs REPO_USERNAME and REPO_TOKEN in ~/.xsessionrc file".formatted(I3BAR_ITEM_NAME))
                    .build());
        }

        return githubApiClient.listPRs(loggedUser).stream()
                .filter(pr -> involvesUser(pr, loggedUser))
                .map(this::buildI3BarItem)
                .toList();
    }

    private boolean involvesUser(GHIssue pr, String userLogin) {
        Set<String> assignees = pr.getAssignees().stream()
                .map(GHUser::getLogin)
                .collect(Collectors.toSet());

        try {
            return pr.getUser().getLogin().equals(userLogin) || assignees.contains(userLogin);
        } catch (Exception e) {
            LOGGER.error("Error while fetching PR user", e);
            return false;
        }
    }

    String getRepositoryName(GHIssue pr) {
        String repositoryUrl = pr.getRepositoryUrl();
        return repositoryUrl.substring(repositoryUrl.lastIndexOf("/") + 1);
    }

    String getRepositoryFullName(GHIssue pr) {
        return pr.getRepositoryUrl().replaceAll("https://api.github.com/repos/", "");
    }


    private I3BarItem buildI3BarItem(GHIssue pr) {
        return I3BarItemBuilder.builder()
                .withName("github-pr")
                .withInstance(String.valueOf(pr.getId()))
                .withFullText(getPRBarValue(pr))
                .withMarkup("pango") // to be able for format full_text with colors
                .withOnClick(() -> this.openPRInBrowser(pr))
                .build();
    }

    private String getPRBarValue(GHIssue pr) {
        String repositoryFullName = getRepositoryFullName(pr);
        GHPullRequest detailedPR = githubApiClient.getPR(repositoryFullName, pr.getNumber());
        String commitSha = detailedPR.getHead().getSha();

        String output = getRepositoryName(pr) + "#" + pr.getNumber();
        if (pr.isDraft()) {
            output = span("#666", output);
        }

        output = output + printStatuses(pr, repositoryFullName, commitSha);
        output = output + printLabels(pr);

        return output;
    }

    String printStatuses(GHIssue pr, String repositoryFullName, String commitSha) {
        List<PRCheck> statuses = new ArrayList<>();
        statuses.addAll(githubApiClient.getStatuses(repositoryFullName, commitSha).stream()
                .map(s -> new PRCheck(s.getContext(), PRCheckStatus.fromStatus(s.getState())))
                .toList());
        statuses.addAll(githubApiClient.getChecks(repositoryFullName, commitSha).stream()
                .filter(s -> !Objects.equals(s.getConclusion(), "skipped"))
                .map(s -> new PRCheck(s.getName(), PRCheckStatus.fromCheck(s.getConclusion())))
                .toList());

        List<String> filteredStatuses = filterStatuses(pr.isDraft(), statuses);
        if (filteredStatuses.isEmpty()) {
            return "";
        }

        return ": " + filteredStatuses.stream()
                .sorted()
                .collect(Collectors.joining(" "));
    }

    private List<String> filterStatuses(boolean isDraft, List<PRCheck> checks) {
        List<String> result = new ArrayList<>();

        boolean hasAlreadySuccessStatus = false;
        for (PRCheck check : checks) {
            String name = mapCheckName(check);
            if (isDraft && !name.equals("ci")) {
                // skip draft statuses unless it is "ci"
                continue;
            }

            if (name.equals(PRCheckStatus.SUCCESS.getDefaultName())) {
                if (hasAlreadySuccessStatus) {
                    // keep only first success status
                    continue;
                }
                hasAlreadySuccessStatus = true;
            }

            result.add(span(check.status().getColor(), name));
        }

        return result;
    }

    private String mapCheckName(PRCheck prCheck) {
        if (prCheck.name().equals("CI")) {
            return "ci";
        }
        if (prCheck.name().endsWith("-pr") && !prCheck.name().endsWith("codescan-pr")) {
            return "ci";
        }
        if (prCheck.name().contains("test")) {
            return "qa";
        }
        return prCheck.status().getDefaultName();
    }

    String printLabels(GHIssue pr) {
        if (pr.getLabels() == null || pr.getLabels().isEmpty()) {
            return "";
        }

        String labels = pr.getLabels().stream()
                .sorted(Comparator.comparing(GHLabel::getName))
                .map(label -> span("#" + label.getColor(), label.getName().substring(0, 1)))
                .collect(Collectors.joining());
        return " (" + labels + ")";
    }

    private String span(String color, String content) {
        return "<span foreground='%s'>%s</span>".formatted(color, content);
    }

    private void openPRInBrowser(GHIssue pr) {
        try {
            processExecutor.exec(new ProcessBuilder()
                    .command("google-chrome-stable", "-newtab", pr.getHtmlUrl())
            );
        } catch (Exception e) {
            LOGGER.error("Error while handling onClick on PR " + pr.getId(), e);
        }
    }

    public List<I3BarItem> getItems() {
        return item;
    }

}
