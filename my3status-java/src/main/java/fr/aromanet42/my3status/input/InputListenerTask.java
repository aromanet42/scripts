package fr.aromanet42.my3status.input;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.core.task.TaskExecutor;
import org.springframework.stereotype.Component;

@Component
public class InputListenerTask implements ApplicationListener<ContextRefreshedEvent> {
    private final TaskExecutor taskExecutor;
    private final InputListener inputListener;

    public InputListenerTask(TaskExecutor taskExecutor, InputListener inputListener) {
        this.taskExecutor = taskExecutor;
        this.inputListener = inputListener;
    }


    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        taskExecutor.execute(inputListener);
    }
}
