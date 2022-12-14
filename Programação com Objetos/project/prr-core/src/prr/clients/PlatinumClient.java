package prr.clients;

import prr.plans.PlanThree;

public class PlatinumClient extends ClientState {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202218101243L;

  private int textCounter = 0;
  

  public PlatinumClient( Client client) {
    super(client);
    setPlan(new PlanThree());
  }

  @Override
  public void updateState() {
    if (client.getPaid() - client.getDebts() < 0) 
      normal(); 
    else if (textCounter >= 2)
      gold();
  }

  @Override
  public void incrementTextCounter() { textCounter++; }

  @Override
  public void incrementVoiceCounter() { textCounter = 0; }

  @Override
  public void incrementVideoCounter() { textCounter = 0; }

  @Override
  public String status() {
    return "PLATINUM";
  }
}
