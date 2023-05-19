package fr.aromanet42.my3status.bar;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

//https://i3wm.org/docs/i3bar-protocol.html
public record I3BarItem(
        @JsonProperty("name")
        String name,
        @JsonProperty("instance")
        String instance,
        @JsonProperty("full_text")
        String fullText,
        @JsonProperty("color")
        String color,
        @JsonProperty("markup")
        String markup,
        @JsonIgnore
        Runnable onClick
) {

        public static final String RED = "#FF0000";
}
