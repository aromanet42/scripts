package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHHead {
    private String sha;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHHead() {
    }

    public String getSha() {
        return sha;
    }
}
