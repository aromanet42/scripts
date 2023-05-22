package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.thirdparty.github.GithubApiClient;
import fr.aromanet42.my3status.thirdparty.github.dto.GHCheckRun;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssue;
import fr.aromanet42.my3status.thirdparty.github.dto.GHIssueFixtures;
import fr.aromanet42.my3status.thirdparty.github.dto.GHLabel;
import fr.aromanet42.my3status.thirdparty.github.dto.GHStatus;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class GithubPrTest {
    @InjectMocks
    GithubPr githubPr;

    @Mock
    GithubApiClient githubApiClient;

    @Test
    void getRepositoryName() {
        GHIssue pr = GHIssueFixtures.builder()
                .withRepositoryUrl("https://api.github.com/repos/mirakl/sandbox-devex-java")
                .build();

        assertThat(githubPr.getRepositoryName(pr)).isEqualTo("sandbox-devex-java");
    }

    @Test
    void getRepositoryFullName() {
        GHIssue pr = GHIssueFixtures.builder()
                .withRepositoryUrl("https://api.github.com/repos/mirakl/sandbox-devex-java")
                .build();

        assertThat(githubPr.getRepositoryFullName(pr)).isEqualTo("mirakl/sandbox-devex-java");
    }

    @Test
    void printLabels_should_return_empty_string_if_no_label() {
        GHIssue pr = GHIssueFixtures.builder()
                .withLabels(null)
                .build();

        assertThat(githubPr.printLabels(pr)).isEmpty();
    }

    @Test
    void printLabels_should_print_labels_with_color_and_initial() {
        GHIssue pr = GHIssueFixtures.builder()
                .withLabels(List.of(new GHLabel("fbca04", "Work In Progress")))
                .build();

        assertThat(githubPr.printLabels(pr)).isEqualTo(" (<span foreground='#fbca04'>W</span>)");
    }

    @Test
    void printStatuses_should_return_empty_string_if_no_checks_nor_statuses() {
        when(githubApiClient.getStatuses(anyString(), anyString())).thenReturn(Collections.emptyList());
        when(githubApiClient.getChecks(anyString(), anyString())).thenReturn(Collections.emptyList());

        GHIssue pr = GHIssueFixtures.builder().build();

        assertThat(githubPr.printStatuses(pr, "mirakl/sandbox-devex-java", "460e074"))
                .isEmpty();
    }

    @Test
    void printStatuses_should_return_filter_out_skipped_checks() {
        when(githubApiClient.getStatuses(anyString(), anyString())).thenReturn(Collections.emptyList());
        when(githubApiClient.getChecks(anyString(), anyString())).thenReturn(List.of(
                new GHCheckRun("Echoes - Labels check", "skipped")
        ));

        GHIssue pr = GHIssueFixtures.builder().build();

        assertThat(githubPr.printStatuses(pr, "mirakl/sandbox-devex-java", "460e074"))
                .isEmpty();
    }

    @Test
    void printStatuses_should_return_only_print_one_green_tick_to_avoid_tacking_too_much_place() {
        when(githubApiClient.getStatuses(anyString(), anyString())).thenReturn(List.of(
                new GHStatus("success", "No release in progress")
        ));
        when(githubApiClient.getChecks(anyString(), anyString())).thenReturn(List.of(
                new GHCheckRun("enforce-no-snapshots", "success"),
                new GHCheckRun("CodeQL", "success")
        ));

        GHIssue pr = GHIssueFixtures.builder().build();

        assertThat(githubPr.printStatuses(pr, "mirakl/sandbox-devex-java", "460e074"))
                .isEqualTo(": <span foreground='#00FF00'>✓</span>");
    }

    @Test
    void printStatuses_should_print_explicit_name_for_CI_and_QA() {
        when(githubApiClient.getStatuses(anyString(), anyString())).thenReturn(List.of(
                new GHStatus("success", "testing"),
                new GHStatus("success", "sandbox-dev-java-pr"),
                new GHStatus("success", "sandbox-dev-java-codescan-pr")
        ));
        when(githubApiClient.getChecks(anyString(), anyString())).thenReturn(Collections.emptyList());

        GHIssue pr = GHIssueFixtures.builder().build();

        assertThat(githubPr.printStatuses(pr, "mirakl/sandbox-devex-java", "460e074"))
                .isEqualTo(": <span foreground='#00FF00'>ci</span> <span foreground='#00FF00'>qa</span> <span foreground='#00FF00'>✓</span>");
    }

    @Test
    void printStatuses_should_print_all_statuses_in_color() {
        when(githubApiClient.getStatuses(anyString(), anyString())).thenReturn(List.of(
                new GHStatus("pending", "testing"),
                new GHStatus("success", "ready"),
                new GHStatus("failure", "release-in-progress")
        ));
        when(githubApiClient.getChecks(anyString(), anyString())).thenReturn(List.of(
                new GHCheckRun("CodeQL", "neutral"),
                new GHCheckRun("enforce-no-snapshots", "success"),
                new GHCheckRun("CI", "success")
        ));

        GHIssue pr = GHIssueFixtures.builder().build();

        assertThat(githubPr.printStatuses(pr, "mirakl/sandbox-devex-java", "460e074"))
                .isEqualTo(": <span foreground='#00FF00'>ci</span>" + // CI check
                           " <span foreground='#00FF00'>✓</span>" +  // ready check & codeql, enforce-no-snapshots statuses
                           " <span foreground='#FF0000'>x</span>" +  // release-in-progress
                           " <span foreground='#FFA500'>qa</span>"); // testing
    }

    @Test
    void printStatuses_should_print_only_CI_status_when_pr_is_draft() {
        when(githubApiClient.getStatuses(anyString(), anyString())).thenReturn(List.of(
                new GHStatus("success", "testing"),
                new GHStatus("success", "sandbox-dev-java-pr"),
                new GHStatus("success", "sandbox-dev-java-codescan-pr")
        ));
        when(githubApiClient.getChecks(anyString(), anyString())).thenReturn(Collections.emptyList());

        GHIssue pr = GHIssueFixtures.builder()
                .withDraft(true)
                .build();

        assertThat(githubPr.printStatuses(pr, "mirakl/sandbox-devex-java", "460e074"))
                .isEqualTo(": <span foreground='#00FF00'>ci</span>");
    }
}

