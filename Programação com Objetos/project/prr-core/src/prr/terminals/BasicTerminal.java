package prr.terminals;

import prr.clients.Client;

public class BasicTerminal extends Terminal {

  private static final long serialVersionUID = 202218101243L;

  public BasicTerminal(String id, Client client) {
    super(id, client);
  }

  @Override
  public boolean canVideo() {
    return false;
  }

  @Override
  public String getType() {
    return "BASIC";
  }
}
