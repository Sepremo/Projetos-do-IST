package prr.communications;

import prr.terminals.Terminal;

public class TextCommunication extends Communication {

  private String text;

  public TextCommunication(String text, Terminal sender,
                                                 Terminal receiver) {
    super(sender, receiver);
    this.text = text;
    this.setFinished();
    this.calculatePrice();
    this.getSender().getClient().incrementTextCounter();
  }

  @Override
  public int getUnits() {
    return text.length();
  }

  public String getText() {
    return text;
  }

  @Override
  public void calculatePrice() {
    setPrice(getSender().getClient().getState().getPlan().getTextPrice(this));
  }

  @Override
  public String getType() {
    return "TEXT";
  }
}
