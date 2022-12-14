package prr.terminals;

import java.io.Serializable;

public abstract class TerminalState implements Serializable {

  private static final long serialVersionUID = 202218101243L;

  protected Terminal terminal;

  public TerminalState(Terminal terminal) {
    this.terminal = terminal;
  }

  public abstract String getName();

  public abstract boolean canEndCurrentCommunication();

  public abstract boolean canStartCommunication();

  public boolean isOff() {
    return false;
  }

  public boolean isIdle() {
    return false;
  }

  public boolean isSilent() {
    return false;
  }

  public boolean isBusy() {
    return false;
  }

  public void free() {}

  public boolean Off() {
    return false;
  }

  public boolean Idle() {
    return false;
  }

  public boolean Silence() {
    return false;
  }

  public boolean Busy() {
    return false;
  }
}
