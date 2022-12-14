package prr.exceptions;

/** Exception for unknown terminals. */
public class InvalidTerminalKeyException extends Exception {

	/** Serial number for serialization. */
	private static final long serialVersionUID = 202208091753L;
	private String key;

	/** @param key Unknown terminal to report. */
	public InvalidTerminalKeyException(String key) {
		this.key = key;
	}

  public String getKey() {
    return key;
  }

}