package fr.aromanet42.my3status.thirdparty.github.dto;

import java.util.List;

public class GHCheckRuns {
    private List<GHCheckRun> checkRuns;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHCheckRuns() {
    }

    public List<GHCheckRun> getCheckRuns() {
        return checkRuns;
    }
}
