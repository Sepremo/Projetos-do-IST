package prr.terminals;

import prr.clients.Client;

public class FancyTerminal extends Terminal {

  private static final long serialVersionUID = 202218101243L;

  public FancyTerminal(String id, Client client) {
    super(id, client);
  }

  @Override
  public boolean canVideo() {
    return true;
  }

  @Override
  public String getType() {
    return "FANCY";
  }
}
