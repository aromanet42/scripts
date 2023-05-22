package fr.aromanet42.my3status.thirdparty.github.dto;

import java.util.List;

public class GHIssueSearchResult {
    private List<GHIssue> items;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHIssueSearchResult() {
    }

    public List<GHIssue> getItems() {
        return items;
    }
}
