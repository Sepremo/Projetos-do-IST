package prr.communications;

import prr.terminals.Terminal;

public class VideoCommunication extends Communication {

  private int duration = 0;

  public VideoCommunication(Terminal sender, Terminal receiver) {
    super(sender, receiver);
  }

  public void setDuration(int duration) {
    this.duration = duration;
  }

  @Override
  public double finish(int duration) {
    this.setDuration(duration);
    this.getSender().getClient().incrementVideoCounter();
    return super.finish(duration);
  }

  @Override
  public int getUnits() {
    return duration;
  }

  @Override
  public String getType() {
    return "VIDEO";
  }

  @Override
  public void calculatePrice() {
    double price = 
    getSender().getClient().getState().getPlan().getVideoPrice(this);
    if (this.hasDiscount()) {
      price = price * this.getDiscount();
    }
    setPrice(price);
  }
}
