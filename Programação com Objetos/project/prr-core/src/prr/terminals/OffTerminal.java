package prr.terminals;

import prr.notifications.OffToIdleNotification;
import prr.notifications.OffToSilentNotification;

public class OffTerminal extends TerminalState {

  private static final long serialVersionUID = 202218101243L;

  public OffTerminal(Terminal terminal) {
    super(terminal);
  }

  @Override
  public String getName() {
    return "OFF";
  }

  @Override
  public boolean canEndCurrentCommunication() {
    return false;
  }

  @Override
  public boolean canStartCommunication() {
    return false;
  }

  @Override
  public boolean isOff() {
    return true;
  }

  @Override
  public boolean Idle() {
    terminal.setState(new IdleTerminal(terminal));
    terminal.notify(new OffToIdleNotification(terminal));
    return true;
  }

  @Override
  public boolean Silence() {
    terminal.setState(new SilenceTerminal(terminal));
    // Turning Silent only allows you too send them texts
    terminal.notifyTexters(new OffToSilentNotification(terminal));
    return true;
  }
}
