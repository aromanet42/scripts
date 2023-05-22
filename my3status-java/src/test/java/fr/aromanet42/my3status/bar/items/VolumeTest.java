package fr.aromanet42.my3status.bar.items;

import fr.aromanet42.my3status.process.ProcessExecutor;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.io.IOException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class VolumeTest {

    @InjectMocks
    Volume volume;

    @Mock
    ProcessExecutor processExecutor;

    @Test
    void getVolume_should_print_muted() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                Simple mixer control 'PCM',0
                  Capabilities: pvolume pswitch pswitch-joined
                  Playback channels: Front Left - Front Right - Rear Left - Rear Right - Front Center - Woofer - Side Left - Side Right
                  Limits: Playback 0 - 80
                  Mono:
                  Front Left: Playback 65 [81%] [-9.00dB] [off]
                  Front Right: Playback 65 [81%] [-9.00dB] [off]
                  Rear Left: Playback 65 [81%] [-9.00dB] [off]
                  Rear Right: Playback 65 [81%] [-9.00dB] [off]
                  Front Center: Playback 65 [81%] [-9.00dB] [off]
                  Woofer: Playback 65 [81%] [-9.00dB] [off]
                  Side Left: Playback 65 [81%] [-9.00dB] [off]
                  Side Right: Playback 65 [81%] [-9.00dB] [off]
                                
                """);

        assertThat(volume.getVolume()).isEqualTo("🔇 81% (muted)");
    }

    @Test
    void getVolume_should_print_volume() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                Simple mixer control 'PCM',0
                  Capabilities: pvolume pswitch pswitch-joined
                  Playback channels: Front Left - Front Right - Rear Left - Rear Right - Front Center - Woofer - Side Left - Side Right
                  Limits: Playback 0 - 80
                  Mono:
                  Front Left: Playback 65 [81%] [-9.00dB] [on]
                  Front Right: Playback 65 [81%] [-9.00dB] [on]
                  Rear Left: Playback 65 [81%] [-9.00dB] [on]
                  Rear Right: Playback 65 [81%] [-9.00dB] [on]
                  Front Center: Playback 65 [81%] [-9.00dB] [on]
                  Woofer: Playback 65 [81%] [-9.00dB] [on]
                  Side Left: Playback 65 [81%] [-9.00dB] [on]
                  Side Right: Playback 65 [81%] [-9.00dB] [on]
                """);

        assertThat(volume.getVolume()).isEqualTo("🔊 81%");
    }

    @Test
    void getMicro_should_print_micro() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                Simple mixer control 'Mic',0
                  Capabilities: cvolume cvolume-joined cswitch cswitch-joined
                  Capture channels: Mono
                  Limits: Capture 0 - 18944
                  Mono: Capture 18944 [100%] [0.00dB] [on]
                """);

        assertThat(volume.getMicro()).isEqualTo("🎤 ON");
    }

    @Test
    void getMicro_should_print_muted_micro() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                Simple mixer control 'Mic',0
                  Capabilities: cvolume cvolume-joined cswitch cswitch-joined
                  Capture channels: Mono
                  Limits: Capture 0 - 18944
                  Mono: Capture 18944 [100%] [0.00dB] [off]
                """);

        assertThat(volume.getMicro()).isEqualTo("🎤 OFF");
    }
}

