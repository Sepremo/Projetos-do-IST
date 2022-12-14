package prr.communications;

import prr.terminals.Terminal;

public class VoiceCommunication extends Communication {

  private int duration = 0;

  public VoiceCommunication(Terminal sender, Terminal receiver) {
    super(sender, receiver);
  }

  public void setDuration(int duration) {
    this.duration = duration;
  }

  @Override
  public double finish(int duration) {
    this.setDuration(duration);
    this.getSender().getClient().incrementVoiceCounter();
    return super.finish(duration);
  }

  @Override
  public int getUnits() {
    return duration;
  }

  @Override
  public String getType() {
    return "VOICE";
  }

  @Override
  public void calculatePrice() {
    double price = 
    getSender().getClient().getState().getPlan().getVoicePrice(this);
    if (this.hasDiscount()) {
      price = price * this.getDiscount();
    }
    setPrice(price);
  }
}
