package prr.terminals;

import prr.notifications.BusyToIdleNotification;


public class BusyTerminal extends TerminalState {

  private static final long serialVersionUID = 202218101243L;
  private TerminalState previousState;

  public BusyTerminal(Terminal terminal) {
    super(terminal);
  }

  public BusyTerminal(Terminal terminal, TerminalState previous) {
    super(terminal);
    previousState = previous;
  }

  @Override
  public String getName() {
    return "BUSY";
  }

  @Override
  public boolean canEndCurrentCommunication() {
    return true;
  }

  @Override
  public boolean canStartCommunication() {
    return false;
  }

  @Override
  public boolean isBusy() {
    return true;
  }

  @Override
  public boolean Idle() {
    terminal.setState(new IdleTerminal(terminal));
    terminal.notify(new BusyToIdleNotification(terminal));
    return true;
  }

  @Override
  public boolean Silence() {
    terminal.setState(new SilenceTerminal(terminal));
    return true;
  }

  @Override
  public void free() {
    if (previousState.isIdle()) {
      Idle();
    } else {
      Silence();
    }
  }
}
