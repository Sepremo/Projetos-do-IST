package prr.exceptions;

public class UnsupportedAtOriginException extends Exception {
 
  /**
   * Class serial number.
   */
  private static final long serialVersionUID = 202210161154L;

  private final String key;

  public UnsupportedAtOriginException(String key) {
    this.key = key;
  }

  public String getKey() {
    return key;
  }
}
