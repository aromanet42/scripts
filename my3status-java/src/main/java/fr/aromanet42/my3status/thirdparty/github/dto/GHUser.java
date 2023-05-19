package fr.aromanet42.my3status.thirdparty.github.dto;

public class GHUser {
    private String login;

    // used by Jackson
    @SuppressWarnings("unused")
    private GHUser() {
    }

    public String getLogin() {
        return login;
    }
}
