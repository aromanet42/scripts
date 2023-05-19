package fr.aromanet42.my3status.bar.items.github;

public enum PRCheckStatus {
    PENDING("#FFA500", "?"),
    SUCCESS("#00FF00", "✓"),
    FAILED("#FF0000", "x"),

    ;

    private final String color;
    private final String defaultName;

    PRCheckStatus(String color, String defaultName) {
        this.color = color;
        this.defaultName = defaultName;
    }

    public String getColor() {
        return color;
    }

    public String getDefaultName() {
        return defaultName;
    }

    public static PRCheckStatus fromStatus(String status) {
        return switch (status) {
            case "pending" -> PENDING;
            case "failure" -> FAILED;
            default -> SUCCESS;
        };
    }

    public static PRCheckStatus fromCheck(String checkConclusion) {
        if (checkConclusion == null) {
            return PENDING;
        }
        if ("failure".equals(checkConclusion)) {
            return FAILED;
        }
        return SUCCESS;
    }
}
