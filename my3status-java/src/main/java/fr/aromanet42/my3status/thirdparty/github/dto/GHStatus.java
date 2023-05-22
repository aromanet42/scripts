package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHStatus {
    private String state;
    private String context;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHStatus() {
    }

    public GHStatus(String state, String context) {
        this.state = state;
        this.context = context;
    }

    public String getState() {
        return state;
    }

    public String getContext() {
        return context;
    }
}
