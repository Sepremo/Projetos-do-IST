package prr.terminals;

import prr.notifications.SilentToIdleNotification;

public class SilenceTerminal extends TerminalState {

  private static final long serialVersionUID = 202218101243L;

  public SilenceTerminal(Terminal terminal) {
    super(terminal);
  }

  @Override
  public String getName() {
    return "SILENCE";
  }

  @Override
  public boolean canEndCurrentCommunication() {
    return false;
  }

  @Override
  public boolean canStartCommunication() {
    return true;
  }

  @Override
  public boolean isSilent() {
    return true;
  }

  @Override
  public boolean Off() {
    terminal.setState(new OffTerminal(terminal));
    return true;
  }

  @Override
  public boolean Idle() {
    terminal.setState(new IdleTerminal(terminal));
    terminal.notify(new SilentToIdleNotification(terminal));
    return true;
  }

  @Override
  public boolean Busy() {
    terminal.setState(new BusyTerminal(terminal, this));
    return true;
  }
}
