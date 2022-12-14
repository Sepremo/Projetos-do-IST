package prr.exceptions;

public class UnknownTerminalKeyException extends Exception{
     /** Serial number for serialization. */
  
  private static final long serialVersionUID = 202210161218L;

  /** The key that had an attempted access */
  private String key;

  /** @param key Unknown key provided. */
  public UnknownTerminalKeyException(String key) {
    super();
    this.key = key;
  }

  /**
   * @param key   Unknown key provided.
   * @param cause What exception caused this one.
   */
  public UnknownTerminalKeyException(String key, Exception cause) {
    super(cause);
    this.key = key;
  }

  /**
   * @return the key
   */
  public String getKey() {
    return this.key;
  }
}
