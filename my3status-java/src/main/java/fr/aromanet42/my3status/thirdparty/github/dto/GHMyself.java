package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHMyself {
    private String login;
    // used by Jackson
    @SuppressWarnings("unused")
    private GHMyself() {
    }

    public String getLogin() {
        return login;
    }
}
