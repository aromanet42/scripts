package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHLabel {
    private String color;
    private String name;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHLabel() {
    }

    public GHLabel(String color, String name) {
        this.color = color;
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public String getName() {
        return name;
    }
}
