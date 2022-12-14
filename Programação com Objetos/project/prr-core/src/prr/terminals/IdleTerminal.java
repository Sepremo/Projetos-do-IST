package prr.terminals;


public class IdleTerminal extends TerminalState {

  private static final long serialVersionUID = 202218101243L;

  public IdleTerminal(Terminal terminal) {
    super(terminal);
  }

  @Override
  public String getName() {
    return "IDLE";
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
  public boolean isIdle() {
    return true;
  }

  @Override
  public boolean Off() {
    terminal.setState(new OffTerminal(terminal));
    return true;
  }

  @Override
  public boolean Silence() {
    terminal.setState(new SilenceTerminal(terminal));
    return true;
  }

  @Override
  public boolean Busy() {
    terminal.setState(new BusyTerminal(terminal, this));
    return true;
  }
}
