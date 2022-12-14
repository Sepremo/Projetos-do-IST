package prr.notifications;
import prr.terminals.Terminal;


public class OffToSilentNotification extends Notification{
    
    public OffToSilentNotification(Terminal terminal) {
        super(terminal);
    }

    @Override
    public String getType(){
        return "O2S";
    }
}
