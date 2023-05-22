package fr.aromanet42.my3status.input;

import com.fasterxml.jackson.annotation.JsonProperty;

public final class InputItem {
    private String name;
    private String instance;

    // used by Jackson
    @SuppressWarnings("unused")
    private InputItem() {
    }

    @JsonProperty("name")
    public String name() {
        return name;
    }

    @JsonProperty("instance")
    public String instance() {
        return instance;
    }
}
