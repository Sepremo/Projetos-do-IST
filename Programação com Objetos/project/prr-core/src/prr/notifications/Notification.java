package prr.notifications;

import java.io.Serializable;
import prr.terminals.Terminal;


public abstract class Notification implements Serializable {
    
    private Terminal terminal;

    public Notification(Terminal terminal){
        this.terminal = terminal;
    }


    public abstract String getType();

    public String toString(){
        return getType() + "|" + terminal.getId();
    }
}