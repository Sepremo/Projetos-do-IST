package prr.clients;

import prr.plans.PlanOne;

public class NormalClient extends ClientState {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202218101243L;

  public NormalClient( Client client) {
    super(client);
    setPlan(new PlanOne());
  }

  @Override
  public void updateState() {
    if (client.getPaid() - client.getDebts() > 500) 
      gold();
  }

  @Override
  public String status() {
    return "NORMAL";
  }
}
