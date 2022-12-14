package prr.terminals;

import java.io.Serializable;

import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;
import java.util.TreeMap;
import java.util.stream.Collectors;

import prr.Network;
import prr.clients.Client;
import prr.notifications.Notification;
import prr.communications.Communication;
import prr.communications.TextCommunication;
import prr.communications.VideoCommunication;
import prr.communications.VoiceCommunication;

import prr.exceptions.InvalidCommunicationKeyException;
import prr.exceptions.TerminalIsAlreadyOffException;
import prr.exceptions.TerminalIsAlreadyOnException;
import prr.exceptions.TerminalIsAlreadySilentException;
import prr.exceptions.TerminalIsBusyException;
import prr.exceptions.TerminalIsOffException;
import prr.exceptions.TerminalIsSilentException;
import prr.exceptions.UnknownTerminalKeyException;
import prr.exceptions.UnsupportedAtDestinationException;
import prr.exceptions.UnsupportedAtOriginException;
import prr.exceptions.noOngoingCommunicationException;


/**
 * Abstract terminal.
 */
public abstract class Terminal implements Serializable {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202208091753L;

  private String id;

  private Client client;

  private TerminalState state;

  private Communication ongoing;

  private Map<String, Terminal> friends = 
        new TreeMap<String, Terminal>(String.CASE_INSENSITIVE_ORDER);

  private Map<Integer, Communication> communications =
                                new TreeMap<Integer, Communication>();

  /** List of Clients waiting for a notification from this terminal */
  private Queue<Client> clientsToNotifyInteractive = new LinkedList<>();
  private Queue<Client> clientsToNotifyText = new LinkedList<>();

  public Terminal(String id, Client client) {
    this.id = id;
    this.client = client;
    this.state = new IdleTerminal(this);
  }

  public String getId() {
    return id;
  }

  public Client getClient() {
    return client;
  }

  public TerminalState getState() {
    return state;
  }

  public Communication getOngoing() {
    return ongoing;
  }

  public void setId(String id) {
    this.id = id;
  }

  public void setOngoing(Communication communication) {
    this.ongoing = communication;
  }

  public void setClient(Client client) {
    this.client = client;
  }

  public void setState(TerminalState state) {
    this.state = state;
  }

  public boolean isFriend(String friendId) {
    return this.friends.containsKey(friendId);
  }

  public abstract boolean canVideo();

  public void addFriend(String friendId, Network network)
    throws UnknownTerminalKeyException {
    Terminal friend = network.getTerminalById(friendId);
    if (friend.getId() != this.id) {
      this.friends.put(friend.getId(), friend);
    }
  }

  public void removeFriend(String friendId, Network network)
    throws UnknownTerminalKeyException {
    Terminal friend = network.getTerminalById(friendId);
    if (this.friends.containsKey(friend.id)) {
      this.friends.remove(friend.id);
    }
  }

  public void addCommunication(Communication communication) {
    this.communications.put(communication.getId(), communication);
  }

  public Communication getCommunicationById(int id) {
    Communication c = this.communications.get(id);
    return c;
  }

  public void addTextAttempt(Client client) {
    if (client.hasEnabled() && !clientsToNotifyText.contains(client)) {
      clientsToNotifyText.add(client);
    }
  }

  public void sendTextCommunication(String idReceiver, Network network,
                                    String text)
         throws UnknownTerminalKeyException, TerminalIsOffException {
    Terminal receiver = network.getTerminalById(idReceiver);

    if (receiver.state.isOff()) {
      receiver.addTextAttempt(this.client);
      throw new TerminalIsOffException(idReceiver);
    }
    Communication communication = new TextCommunication(text, this, receiver);
    network.addCommunication(communication);
    this.addCommunication(communication);
    this.client.updateState();
  }

  public abstract String getType();

  public boolean isUnused() {
    return (communications.size() == 0) ? true : false;
  }

  public boolean isSender() {
    if (this.ongoing == null) {
      return false;
    }
    return this.ongoing.getSender() == this;
  }

  /**
   * Checks if this terminal can end the current interactive
   * communication.
   *
   * @return true if this terminal is busy (i.e., it has an
   *         active interactive communication) and it was the
   *         originator of this communication.
   **/
  public boolean canEndCurrentCommunication() {
    return this.state.canEndCurrentCommunication() && this.isSender();
  }

  /**
   * Checks if this terminal can start a new communication.
   *
   * @return true if this terminal is neither off neither busy,
   *         false otherwise.
   **/
  public boolean canStartCommunication() {
    return this.state.canStartCommunication();
  }

  public double getPaid() {
    return this.communications.values()
      .stream()
      .filter(c -> c.isPayed())
      .mapToDouble(comm -> comm.getPrice())
      .sum();
  }

  public double getDebts() {
    return this.communications.values()
      .stream()
      .filter(c -> !c.isPayed())
      .mapToDouble(comm -> comm.getPrice())
      .sum();
  }

  public double getBalance() {
    return this.getPaid() - this.getDebts();
  }

  public boolean hasDebt() {
    for (Communication c : communications.values()) {
      if (!c.isPayed()) {
        return true;
      }
    }
    return false;
  }

  /**
   * Adds a client to the ArrayList of clients to be notified
   * once this terminal's state changes
   *
   * @param client
   */
  public void addInteractiveAttempt(Client client) {
    if (client.hasEnabled() && !clientsToNotifyInteractive.contains(client)) {
      clientsToNotifyInteractive.add(client);
    }
  }

  public void startInteractiveCommunication(String idReceiver,
                                        Network network, String type )
    throws UnknownTerminalKeyException, TerminalIsOffException,
     TerminalIsBusyException, TerminalIsSilentException, 
     UnsupportedAtDestinationException, UnsupportedAtOriginException {
    Terminal receiver = network.getTerminalById(idReceiver);

    if (receiver == this) {
      return;
    }

    if (receiver.getState().isOff()) {
      receiver.addInteractiveAttempt(this.client);
      throw new TerminalIsOffException(idReceiver);
    }
    if (receiver.getState().isBusy()) {
      receiver.addInteractiveAttempt(this.client);
      throw new TerminalIsBusyException(idReceiver);
    }
    if (receiver.getState().isSilent()) {
      receiver.addInteractiveAttempt(this.client);
      throw new TerminalIsSilentException(idReceiver);
    }

    Communication communication = null;

    if (type.equals("VIDEO")) {
      if (!this.canVideo()) {
        throw new UnsupportedAtOriginException(this.id);
      } else if ((!receiver.canVideo())) {
        throw new UnsupportedAtDestinationException(idReceiver);
      } else {
        communication = new VideoCommunication(this, receiver);
      }
    } else {
      communication = new VoiceCommunication(this, receiver);
    }

    network.addCommunication(communication);
    this.addCommunication(communication);

    this.Busy();
    receiver.Busy();

    receiver.setOngoing(communication);
    this.setOngoing(communication);
  }

  public double endInteractiveCommunication(int duration) {
    double price = this.ongoing.finish(duration);
    this.client.updateState();
    this.free();
    this.ongoing.getReceiver().free();
    this.ongoing.getReceiver().setOngoing(null);
    this.ongoing = null;
    return price;
  }

  public void payCommunication(int id) throws 
                                InvalidCommunicationKeyException {
    Communication c = getCommunicationById(id);

    if (c != null && !c.isPayed() && !c.isOnGoing()) {
      c.setPayed();
    } else {
      throw new InvalidCommunicationKeyException(id);
    }
    this.client.updateState();
  }

  public void free() {
    //turn terminal back to its previous state (before busy)
    this.state.free();
  }

  public void Busy() {
    this.state.Busy();
  }

  public void Off() throws TerminalIsAlreadyOffException {
    if (this.state.isOff()) {
      throw new TerminalIsAlreadyOffException();
    }
    this.state.Off();
  }

  public void Idle() {
    this.state.Idle();
  }

  public void On() throws TerminalIsAlreadyOnException {
    if (this.state.isIdle()) {
      throw new TerminalIsAlreadyOnException();
    }
    this.Idle();
  }

  public void Silence() throws TerminalIsAlreadySilentException {
    if (this.state.isSilent()) {
      throw new TerminalIsAlreadySilentException();
    }
    this.state.Silence();
  }

  public String showOngoingCommunication()
    throws noOngoingCommunicationException {
    if (this.ongoing == null) {
      throw new noOngoingCommunicationException();
    }
    return this.ongoing.toString();
  }

  public void notifyTexters(Notification notification) {
    while (clientsToNotifyText.size() > 0) {
      Client client = clientsToNotifyText.remove();
      client.notify(notification);
    }
  }

  public void notify(Notification notification) {
    notifyTexters(notification);
    while (clientsToNotifyInteractive.size() > 0) {
      Client client = clientsToNotifyInteractive.remove();
      client.notify(notification);
    }
  }

  @Override
  public String toString() {
    return ( getType() + "|" + this.id + "|" + client.getId() + "|" +
      state.getName() + "|" + Math.round(getPaid()) + "|" +
      Math.round(getDebts()) + (
        //if the terminal doesn't have friends this field is ignored
        friends.size() == 0 ? "" : 
        //separate friends ids by comma
        "|" + friends.keySet().stream().collect(Collectors.joining(","))
      )
    );
  }
}
