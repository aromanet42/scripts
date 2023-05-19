package fr.aromanet42.my3status.thirdparty.github.dto;

import java.util.List;

public class GHIssue {
    String id;
    long number;
    String htmlUrl;
    String repositoryUrl;
    GHUser user;
    List<GHUser> assignees;
    boolean draft;
    List<GHLabel> labels;

    // used by Jackson
    @SuppressWarnings("unused")
    GHIssue() {
    }

    public String getId() {
        return id;
    }

    public long getNumber() {
        return number;
    }

    public String getHtmlUrl() {
        return htmlUrl;
    }

    public String getRepositoryUrl() {
        return repositoryUrl;
    }

    public GHUser getUser() {
        return user;
    }

    public List<GHUser> getAssignees() {
        return assignees;
    }

    public boolean isDraft() {
        return draft;
    }

    public List<GHLabel> getLabels() {
        return labels;
    }
}
