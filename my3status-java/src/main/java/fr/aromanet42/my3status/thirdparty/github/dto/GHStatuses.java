package fr.aromanet42.my3status.thirdparty.github.dto;

import java.util.List;

public class GHStatuses {
    private List<GHStatus> statuses;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHStatuses() {
    }

    public List<GHStatus> getStatuses() {
        return statuses;
    }
}
