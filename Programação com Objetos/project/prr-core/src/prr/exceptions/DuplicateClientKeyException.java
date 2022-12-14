package prr.exceptions;

public class DuplicateClientKeyException extends Exception {
 
  /**
   * Class serial number.
   */
  private static final long serialVersionUID = 202210161148L;

  private final String key;

  public DuplicateClientKeyException(String key) {
    this.key = key;
  }

  public String getKey() {
    return key;
  }
}


