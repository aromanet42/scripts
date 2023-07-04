package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHCheckRun {
    private String name;
    private String conclusion;
    private String externalId;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHCheckRun() {
    }

    public GHCheckRun(String name, String conclusion) {
        this.name = name;
        this.conclusion = conclusion;
    }

    public String getName() {
        return name;
    }

    public String getConclusion() {
        return conclusion;
    }

    public String getExternalId() {
        return externalId;
    }
}
