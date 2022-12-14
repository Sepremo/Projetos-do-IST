package prr.communications;

import java.io.Serializable;
import prr.terminals.Terminal;

public abstract class Communication implements Serializable {

  private static int IdCounter = 1;
  private int id;
  private Terminal receiver;
  private Terminal sender;
  private double price = 0;
  private boolean finished = false;
  private boolean payed = false;
  private static final double FRIEND_DISCOUNT = 0.5;

  private static final long serialVersionUID = 202218101243L;

  public Communication(Terminal sender, Terminal receiver) {
    this.id = IdCounter++;
    this.receiver = receiver;
    this.sender = sender;
  }

  public boolean isOnGoing() {
    return !this.finished;
  }

  public void setFinished() {
    this.finished = true;
  }

  public void setPayed() {
    this.payed = true;
  }

  public boolean isPayed() {
    return this.payed;
  }

  public double getDiscount() {
    return FRIEND_DISCOUNT;
  }

  public void setPrice(double price) {
    this.price = price;
  }

  public double getPrice() {
    return this.price;
  }

  public int getId() {
    return id;
  }

  public Terminal getSender() {
    return this.sender;
  }

  public Terminal getReceiver() {
    return this.receiver;
  }

  public String getStatus() {
    return this.isOnGoing() ? "ONGOING" : "FINISHED";
  }

  public abstract void calculatePrice();

  public abstract int getUnits();

  public abstract String getType();

  public double finish(int duration) {
    this.setFinished();
    this.calculatePrice();
    return this.price;
  }

  public boolean hasDiscount() {
    return this.sender.isFriend(this.receiver.getId());
  }

  @Override
  public String toString() {
    return ( this.getType() + "|" + this.id + "|" + this.sender.getId() 
    + "|" + this.receiver.getId() + "|" + this.getUnits() + "|" +
      Math.round(this.price) +  "|" + this.getStatus()
    );
  }
}
