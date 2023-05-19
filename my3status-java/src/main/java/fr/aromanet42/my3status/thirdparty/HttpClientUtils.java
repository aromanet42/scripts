package fr.aromanet42.my3status.thirdparty;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class HttpClientUtils {
    public static String basicHeader(String username, String password) {
        String decodedHeader = username + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(decodedHeader.getBytes(StandardCharsets.UTF_8));
    }
}
