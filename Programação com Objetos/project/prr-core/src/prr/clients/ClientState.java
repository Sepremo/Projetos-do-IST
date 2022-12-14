package prr.clients;

import java.io.Serializable;
import prr.plans.Plan;

public abstract class ClientState implements Serializable {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202218101243L;

  private Plan plan;
  protected Client client;


  public ClientState( Client client) {
    this.client = client;
  }

  public void setPlan(Plan plan) {
    this.plan = plan;
  }

  public Plan getPlan() {
    return plan;
  }

  // By default the incrementers do nothing
  public void incrementTextCounter() {}
  public void incrementVoiceCounter() {}
  public void incrementVideoCounter() {}

  public abstract void updateState();
  public abstract String status();

  public void normal() {
    client.setState(new NormalClient(client));
  }

  public void gold() {
    client.setState(new GoldClient(client));
  }

  public void platinum() {
    client.setState(new PlatinumClient(client));
  }
}
