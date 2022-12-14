package prr.clients;

import prr.plans.PlanTwo;

public class GoldClient extends ClientState {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202218101243L;

  private int videoCounter = 0;

  public GoldClient( Client client) {
    super(client);
    setPlan(new PlanTwo());
  }

  @Override
  public void updateState() {
    if (client.getPaid() - client.getDebts() < 0) 
      normal(); 
    else if (videoCounter >= 5) 
      platinum();
  }

  @Override
  public void incrementTextCounter() { videoCounter = 0; }

  @Override
  public void incrementVoiceCounter() { videoCounter = 0; }

  @Override
  public void incrementVideoCounter() { videoCounter++; }

  @Override
  public String status() {
    return "GOLD";
  }
}
