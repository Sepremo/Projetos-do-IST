package prr.exceptions;

public class InvalidCommunicationKeyException extends Exception{
     /** Serial number for serialization. */
  
  private static final long serialVersionUID = 202210161218L;

  /** The key that had an attempted access */
  private int key;

  /** @param key Unknown key provided. */
  public InvalidCommunicationKeyException(int key) {
    super();
    this.key = key;
  } 

  /**
   * @return the key
   */
  public int getKey() {
    return this.key;
  }
  
}
