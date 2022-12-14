package prr.exceptions;

public class TerminalIsBusyException extends Exception {
 
  /**
   * Class serial number.
   */
  private static final long serialVersionUID = 202210161154L;

  private final String key;

  public TerminalIsBusyException(String key) {
    this.key = key;
  }

  public String getKey() {
    return key;
  }
}
