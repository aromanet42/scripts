package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHPullRequest {
    private GHHead head;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHPullRequest() {
    }

    public GHHead getHead() {
        return head;
    }
}
