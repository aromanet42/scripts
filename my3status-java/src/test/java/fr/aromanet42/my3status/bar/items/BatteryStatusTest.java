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
class BatteryStatusTest {

    @InjectMocks
    BatteryStatus batteryStatus;

    @Mock
    ProcessExecutor processExecutor;

    @Test
    void getValue_should_return_lightening_if_fully_charged() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                  native-path:          BAT0
                  vendor:               LGC
                  model:                5B10W51831
                  serial:               1581
                  power supply:         yes
                  updated:              jeu. 18 mai 2023 14:59:58 (21 seconds ago)
                  has history:          yes
                  has statistics:       yes
                  battery
                    present:             yes
                    rechargeable:        yes
                    state:               fully-charged
                    warning-level:       none
                    energy:              57,67 Wh
                    energy-empty:        0 Wh
                    energy-full:         58,1 Wh
                    energy-full-design:  57 Wh
                    energy-rate:         0,278313 W
                    voltage:             12,289 V
                    percentage:          99%
                    capacity:            100%
                    technology:          lithium-polymer
                    icon-name:          'battery-full-charged-symbolic'
                """);

        assertThat(batteryStatus.getValue()).isEqualTo("⚡");
    }

    @Test
    void getValue_should_return_lightening_if_charging() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                  native-path:          BAT0
                  vendor:               LGC
                  model:                5B10W51831
                  serial:               1581
                  power supply:         yes
                  updated:              jeu. 18 mai 2023 15:22:01 (2 seconds ago)
                  has history:          yes
                  has statistics:       yes
                  battery
                    present:             yes
                    rechargeable:        yes
                    state:               pending-charge
                    warning-level:       none
                    energy:              53,19 Wh
                    energy-empty:        0 Wh
                    energy-full:         58,1 Wh
                    energy-full-design:  57 Wh
                    energy-rate:         31,251 W
                    voltage:             11,351 V
                    percentage:          91%
                    capacity:            100%
                    technology:          lithium-polymer
                    icon-name:          'battery-full-charging-symbolic'
                  History (charge):
                    1684416120	91,000	pending-charge
                    1684416023	93,000	discharging
                  History (rate):
                    1684416120	31,251	pending-charge
                    1684416120	47,533	pending-charge
                    1684416023	31,251	discharging
                """);

        assertThat(batteryStatus.getValue()).isEqualTo("⚡");
    }

    @Test
    void getValue_should_return_percentage_if_not_charging() throws IOException {
        when(processExecutor.exec(any())).thenReturn("""
                  native-path:          BAT0
                  vendor:               LGC
                  model:                5B10W51831
                  serial:               1581
                  power supply:         yes
                  updated:              jeu. 18 mai 2023 15:18:23 (76 seconds ago)
                  has history:          yes
                  has statistics:       yes
                  battery
                    present:             yes
                    rechargeable:        yes
                    state:               discharging
                    warning-level:       none
                    energy:              56,06 Wh
                    energy-empty:        0 Wh
                    energy-full:         58,1 Wh
                    energy-full-design:  57 Wh
                    energy-rate:         24,016 W
                    voltage:             11,552 V
                    time to empty:       2,3 hours
                    percentage:          96%
                    capacity:            100%
                    technology:          lithium-polymer
                    icon-name:          'battery-full-symbolic'
                  History (charge):
                    1684415903	0,000	unknown
                  History (rate):
                    1684415903	0,000	unknown
                """);

        assertThat(batteryStatus.getValue()).isEqualTo("🔋 96%");
    }
}

