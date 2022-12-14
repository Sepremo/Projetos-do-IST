package prr.notifications;
import prr.terminals.Terminal;


public class OffToIdleNotification extends Notification{
    
    public OffToIdleNotification(Terminal terminal) {
        super(terminal);
    }

    @Override
    public String getType(){
        return "O2I";
    }
}