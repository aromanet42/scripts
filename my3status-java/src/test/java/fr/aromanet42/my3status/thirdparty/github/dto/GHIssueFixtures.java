package fr.aromanet42.my3status.thirdparty.github.dto;

import java.util.List;

public class GHIssueFixtures {

    private final GHIssue ghIssue = new GHIssue();

    public static GHIssueFixtures builder() {
        return new GHIssueFixtures();
    }

    public GHIssueFixtures withRepositoryUrl(String repositoryUrl) {
        this.ghIssue.repositoryUrl = repositoryUrl;
        return this;
    }

    public GHIssueFixtures withLabels(List<GHLabel> labels) {
        this.ghIssue.labels = labels;
        return this;
    }

    public GHIssueFixtures withDraft(boolean draft) {
        this.ghIssue.draft = draft;
        return this;
    }

    public GHIssue build() {
        return ghIssue;
    }

}

