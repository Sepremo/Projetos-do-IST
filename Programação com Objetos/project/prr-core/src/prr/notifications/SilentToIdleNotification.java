package prr.notifications;
import prr.terminals.Terminal;


public class SilentToIdleNotification extends Notification{
    
    public SilentToIdleNotification(Terminal terminal){
        super(terminal);
    }

    @Override
    public String getType(){
        return "S2I";
    }
}