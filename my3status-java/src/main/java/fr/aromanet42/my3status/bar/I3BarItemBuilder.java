package fr.aromanet42.my3status.bar;

public class I3BarItemBuilder {
    private String name;
    private String instance;
    private String fullText;
    private String color;
    private Runnable onClickCommand;
    private String markup;

    public static I3BarItemBuilder builder() {
        return new I3BarItemBuilder();
    }

    public I3BarItemBuilder withName(String name) {
        this.name = name;
        return this;
    }

    public I3BarItemBuilder withInstance(String instance) {
        this.instance = instance;
        return this;
    }

    public I3BarItemBuilder withFullText(String fullText) {
        this.fullText = fullText;
        return this;
    }

    public I3BarItemBuilder withColor(String color) {
        this.color = color;
        return this;
    }

    public I3BarItemBuilder withMarkup(String markup) {
        this.markup = markup;
        return this;
    }

    public I3BarItemBuilder withOnClick(Runnable onClick) {
        this.onClickCommand = onClick;
        return this;
    }

    public I3BarItem build() {
        return new I3BarItem(
                name,
                instance,
                fullText,
                color,
                markup,
                onClickCommand
        );
    }
}
