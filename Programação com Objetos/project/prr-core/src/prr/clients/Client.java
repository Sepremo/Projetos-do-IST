package prr.clients;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;
import java.util.TreeMap;
import prr.communications.Communication;
import prr.notifications.Notification;
import prr.notifications.NotificationDeliveryMethod;
import prr.terminals.Terminal;

public class Client implements Serializable {

  private String id;
  private String name;
  private int taxId;
  private ClientState state = new NormalClient(this);

  private Map<String, Terminal> terminals = new TreeMap<String, Terminal>(
    String.CASE_INSENSITIVE_ORDER
  );

  private boolean enabledClientNotifications = true;
  private Queue<Notification> notifications = new LinkedList<>();

  /** stores the predefined method to add to the notification List  */
  private NotificationDeliveryMethod notificationDeliveryMethod = notification ->
    notifications.add(notification);

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202218101241L;

  public Client(String id, String name, int taxId) {
    this.id = id;
    this.name = name;
    this.taxId = taxId;
  }

  public String getId() {
    return this.id;
  }

  public String getStateName() {
    return this.state.status();
  }

  public ClientState getState() {
    return this.state;
  }

  public void setState(ClientState state) {
    this.state = state;
  }

  public void addTerminal(Terminal terminal) {
    this.terminals.put(terminal.getId(), terminal);
  }

  public void notify(Notification notification) {
    notificationDeliveryMethod.deliver(notification);
  }

  public void setNotificationDeliveryMethod(
    NotificationDeliveryMethod deliveryMethod
  ) {
    this.notificationDeliveryMethod = deliveryMethod;
  }

  public void resetNotifications() {
    this.notifications = new LinkedList<Notification>();
  }

  public Collection<Notification> getAllNotifications() {
    return notifications;
  }

  public double getPaid() {
    return terminals
      .values()
      .stream()
      .mapToDouble(terminal -> terminal.getPaid())
      .sum();
  }

  public double getDebts() {
    return terminals
      .values()
      .stream()
      .mapToDouble(terminal -> terminal.getDebts())
      .sum();
  }

  public int compareDebts(Client client) {
    Double d1 = this.getDebts();
    Double d2 = client.getDebts();
    return d1.compareTo(d2);
  }

  public boolean hasDebt() {
    return getDebts() > 0;
  }

  public boolean isSender(Communication communication) {
    return this.id.equals(communication.getSender().getClient().getId());
  }

  public boolean isReceiver(Communication communication) {
    return this.id.equals(communication.getReceiver().getClient().getId());
  }

  public boolean hasEnabled() {
    return enabledClientNotifications;
  }

  public void incrementTextCounter() {
    this.state.incrementTextCounter();
  }

  public void incrementVoiceCounter() {
    this.state.incrementVoiceCounter();
  }

  public void incrementVideoCounter() {
    this.state.incrementVideoCounter();
  }

  public void updateState() {
    this.state.updateState();
  }

  public boolean enableClientNotifications() {
    // If the notifications are already enabled
    if (enabledClientNotifications) return false;
    enabledClientNotifications = true;
    return true;
  }

  public boolean disableClientNotifications() {
    // If the notifications are already disabled
    if (!enabledClientNotifications) return false;
    enabledClientNotifications = false;
    return true;
  }

  public String getNotificationsStatus() {
    return hasEnabled() ? "YES" : "NO";
  }

  @Override
  public String toString() {
    return (
      "CLIENT|" + this.id + "|" + this.name + "|" + this.taxId + "|" +
      getStateName() + "|" + this.getNotificationsStatus() + "|" +
      (terminals.size()) + "|" + Math.round(getPaid()) + "|" +
      Math.round(getDebts())
    );
  }
}
