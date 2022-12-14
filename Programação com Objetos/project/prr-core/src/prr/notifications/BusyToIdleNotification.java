package prr.notifications;
import prr.terminals.Terminal;


public class BusyToIdleNotification extends Notification{
    
    public BusyToIdleNotification(Terminal terminal){
        super(terminal);
    }

    @Override
    public String getType(){
        return "B2I";
    }
}