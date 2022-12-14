package prr;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.Serializable;

import java.util.Collection;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

import prr.clients.Client;
import prr.communications.Communication;
import prr.notifications.Notification;
import prr.terminals.Terminal;
import prr.terminals.BasicTerminal;
import prr.terminals.FancyTerminal;
import prr.terminals.BusyTerminal;
import prr.terminals.IdleTerminal;
import prr.terminals.OffTerminal;
import prr.terminals.SilenceTerminal;

import prr.exceptions.DuplicateClientKeyException;
import prr.exceptions.DuplicateTerminalKeyException;
import prr.exceptions.InvalidTerminalKeyException;
import prr.exceptions.NotificationsAlreadyDisabledException;
import prr.exceptions.NotificationsAlreadyEnabledException;
import prr.exceptions.UnknownClientKeyException;
import prr.exceptions.UnknownTerminalKeyException;
import prr.exceptions.UnrecognizedEntryException;

/**
 * Class Store implements a store.
 */
public class Network implements Serializable {

  /**
   * Stores the network's clients, sorted by their id.
   */
  private Map<String, Client> clients = new TreeMap<String, Client>(
    String.CASE_INSENSITIVE_ORDER
  );

  /**
   * Stores the network's terminals, sorted by their id.
   */
  private Map<String, Terminal> terminals = new TreeMap<String, Terminal>(
    String.CASE_INSENSITIVE_ORDER
  );

  private Map<Integer, Communication> communications = new TreeMap<Integer, Communication>();

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202208091753L;

  /**
   * Read text input file and create corresponding domain entities.
   *
   * @param filename name of the text input file
   * @throws UnrecognizedEntryException if some entry (line) in the
   *                                    file is not correct
   * @throws IOException if there is an IO erro while processing the
   *                     text file
   */
  void importFile(String filename)
    throws UnrecognizedEntryException, IOException {
    try (BufferedReader s = new BufferedReader(new FileReader(filename))) {
      String line;
      while ((line = s.readLine()) != null) {
        importFromFields(line.split("\\|"));
      }
    }
  }

  /**
   * Parse and import an entry (line) from a plain text file.
   *
   * @param fields The fields of the entry to import, that were split
   *               by the separator
   * @throws UnrecognizedEntryException if some entry (line) in the
   *                                    file is not correct
   */
  private void importFromFields(String[] fields)
    throws UnrecognizedEntryException {
    switch (fields[0]) {
      case "CLIENT" -> importClient(fields);
      case "BASIC", "FANCY" -> importTerminal(fields);
      case "FRIENDS" -> importTerminalFriends(fields);
      default -> throw new UnrecognizedEntryException(String.join("|", fields));
    }
  }

  /**
   * Parse and import a Client entry from a plain text file.
   * A correct Client entry has the following format:
   * {@code CLIENT|id|name|taxId}
   *
   * @param fields The fields of the Client to import, that were split
   *               by the separator
   * @throws UnrecognizedEntryException if the entry does not have the
   *                                    correct fields for its type
   */
  private void importClient(String[] fields) throws UnrecognizedEntryException {
    try {
      this.registerClient(fields[1], fields[2], fields[3]);
    } catch (DuplicateClientKeyException e) {
      throw new UnrecognizedEntryException(String.join("|", fields));
    }
  }

  /**
   * Parse and import a Terminal entry from a plain text file.
   * A correct Terminal entry has the following format:
   * {@code terminal-type|idTerminal|idClient|state}
   *
   * @param fields The fields of the Terminal to import, that were
   *               split by the separator
   * @throws UnrecognizedEntryException if the entry does not have the
   *                                    correct fields for its type
   */
  private void importTerminal(String[] fields)
    throws UnrecognizedEntryException {
    try {
      this.registerTerminal(fields[0], fields[1], fields[2], fields[3]);
    } catch (
      DuplicateTerminalKeyException
      | UnknownClientKeyException
      | InvalidTerminalKeyException e
    ) {
      throw new UnrecognizedEntryException(String.join("|", fields));
    }
  }

  /**
   * Parse and import terminal's friends entry from a plain text file.
   * A correct Client entry has the following format:
   * {@code FRIENDS|idTerminal|idTerminal1,...,idTerminalN}
   *
   * @param fields The fields of the terminal's friends to import,
   *               that were split by the separator
   * @throws UnrecognizedEntryException if the entry does not have the
   *                                    correct fields for its type
   */
  private void importTerminalFriends(String[] fields)
    throws UnrecognizedEntryException {
    try {
      this.registerTerminalFriends(fields[1], fields[2].split(","));
    } catch (UnknownTerminalKeyException e) {
      throw new UnrecognizedEntryException(String.join("|", fields));
    }
  }

  /**
   * Register a new client in this network, which will be created
   * from the given parameters.
   *
   * @param id      The key of the Client
   * @param name    The name of the Client
   * @param taxId 	The tax Id of the Client
   * @throws DuplicateClientKeyException if a Client with the given
   *                             key (case-insensitive) already exists
   */
  public void registerClient(String id, String name, String taxId)
    throws DuplicateClientKeyException {
    if (this.clients.containsKey(id)) {
      throw new DuplicateClientKeyException(id);
    }

    Client client = new Client(id, name, Integer.parseInt(taxId));
    addClient(client);
  }

  /**
   * Register a new terminal in this network, which will be created
   * from the given parameters.
   *
   * @param id      The key of the terminal to register
   * @param idClient  The client who has this terminal
  
   * @throws DuplicateTerminalKeyException if a terminal with the given 
   *                             key (case-insensitive) already exists
   */
  public void registerTerminal(
    String type,
    String id,
    String idClient,
    String State
  )
    throws DuplicateTerminalKeyException, UnknownClientKeyException,
                                         InvalidTerminalKeyException {
    if (!this.clients.containsKey(idClient)) {
      throw new UnknownClientKeyException(idClient);
    }

    if (!(id.matches("[0-9]+") && id.length() == 6)) {
      throw new InvalidTerminalKeyException(id);
    }

    if (this.terminals.containsKey(id)) {
      throw new DuplicateTerminalKeyException(id);
    }

    Terminal terminal = null;
    switch (type) {
      case "BASIC" -> terminal = new BasicTerminal(id, getClientById(idClient));
      case "FANCY" -> terminal = new FancyTerminal(id, getClientById(idClient));
    }

    switch (State) {
      case "IDLE", "ON" -> terminal.setState(new IdleTerminal(terminal));
      case "OFF" -> terminal.setState(new OffTerminal(terminal));
      case "SILENCE" -> terminal.setState(new SilenceTerminal(terminal));
      //case "BUSY" -> terminal.setState(new BusyTerminal(terminal));
    }

    this.addTerminal(terminal);
    //add the terminal to its client's terminal map
    getClientById(idClient).addTerminal(terminal);
  }

  /**
   * Register terminal's new friends in this network, which will be
   * added from the map of terminals of the Network
   *
   * @param id      The key of the terminal to register friends
   * @param friends The list of id's of the new friends of this terminal
   *
   * @throws UnknownTerminalKeyException if a terminal with the given
   *                                  key doesn't exist in the Network
   */
  public void registerTerminalFriends(String id, String[] friends)
    throws UnknownTerminalKeyException {
    Terminal terminal = getTerminalById(id);

    if (terminal == null) {
      throw new UnknownTerminalKeyException(id);
    }

    for (String friendId : friends) {
      if (!this.terminals.containsKey(friendId)) {
        throw new UnknownTerminalKeyException(id);
      }
      //add the friend to terminal's friend map
      terminal.addFriend(friendId, this);
    }
  }

  /**
   * Get client given its key.
   *
   * @param id The key of the client to retrieve
   * @return the Client corresponding to the key
   * @throws UnknownCLientKeyException if the client with the given
   *                                  key doesn't exist in the Network
   */
  public Client getClientById(String id) throws 
                                            UnknownClientKeyException {
    Client c = this.clients.get(id);

    if (c == null) {
      throw new UnknownClientKeyException(id);
    }
    return c;
  }

  /**
   * Get all clients in the Network
   * @return the Collection of clients
   */
  public Collection<Client> getAllClients() {
    return this.clients.values();
  }

  /**
   * Get all clients with debt in the Network
   * @return the Collection of clients with debt
   */
  public Collection<Client> getAllClientsWithDebt() {
    return this.clients.values()
      .stream()
      .filter(c -> c.hasDebt())
      // c1 and c2 switched to reverse the output order
      .sorted((c1, c2) -> c2.compareDebts(c1))
      .collect(Collectors.toList());
  }

  /**
   * Get all clients without debt in the Network
   * @return the Collection of clients without debt
   */
  public Collection<Client> getAllClientsWithoutDebt() {
    return this.clients.values()
      .stream()
      .filter(c -> (!c.hasDebt()))
      .collect(Collectors.toList());
  }

  /**
   * Get all communications from client
   * @param  id The key of the client to retrieve communications from
   * @return the Collection of communications from the client
   * @throws UnknownCLientKeyException if the client with the given
   *                                  key doesn't exist in the Network
   */
  public Collection<Communication> getAllCommunicationsFromClient(String id)
    throws UnknownClientKeyException {
    Client client = getClientById(id);
    return this.communications.values()
      .stream()
      .filter(communication -> (client.isSender(communication)))
      .collect(Collectors.toList());
  }

  /**
   * Get all communications to client
   * @param  id The key of the client to retrieve communications from
   * @return the Collection of communications to the client
   * @throws UnknownCLientKeyException if the client with the given
   *                                  key doesn't exist in the Network
   */
  public Collection<Communication> getAllCommunicationsToClient(String id)
    throws UnknownClientKeyException {
    Client client = getClientById(id);
    return this.communications.values()
      .stream()
      .filter(communication -> (client.isReceiver(communication)))
      .collect(Collectors.toList());
  }

  /**
   * Get terminal given its key.
   * @param  id The key of the terminal to retrieve
   * @return the Terminal corresponding to the key
   * @throws UnknownTerminalKeyException iif the terminal with the
   *                            given key doesn't exist in the Network
   */
  public Terminal getTerminalById(String id)
                                  throws UnknownTerminalKeyException {
    Terminal t = this.terminals.get(id);

    if (t == null) {
      throw new UnknownTerminalKeyException(id);
    }
    return t;
  }

  /**
   * Add terminal to Network
   * @param terminal The terminal to add
   */
  public void addTerminal(Terminal terminal) {
    this.terminals.put((terminal.getId()), terminal);
  }

  /**
   * Add client to Network
   * @param client The client to add
   */
  public void addClient(Client client) {
    this.clients.put(client.getId(), client);
  }

  /**
   * Get all the terminals in the Network
   * @return the Collection of terminals
   */
  public Collection<Terminal> getAllTerminals() {
    return this.terminals.values();
  }

  /**
   * Get all the unused terminals in the Network
   * @return the Collection of terminals that have no communications
   */
  public Collection<Terminal> getAllUnusedTerminals() {
    return this.terminals.values()
      .stream()
      .filter(t -> t.isUnused())
      .collect(Collectors.toList());
  }

  /**
   * Get all the terminals with positive balance in the Network
   * @return the Collection of terminals that have positive
   *                                 balance in the Network
   */
  public Collection<Terminal> getAllTerminalsWithPositiveBalance() {
    return this.terminals.values()
      .stream()
      .filter(t -> t.getBalance() > 0)
      .collect(Collectors.toList());
  }

  /**
   * Add Communication to Network
   * @param communication The communication to add
   */
  public void addCommunication(Communication communication) {
    this.communications.put(communication.getId(), communication);
  }

  /**
   * Get all the communications in the Network
   * @return the Collection of communications
   */
  public Collection<Communication> getAllCommunications() {
    return this.communications.values();
  }

  /**
   * Disable Client's notifications
   * @param  id The key of the client to disable notifications
   * @throws UnknownTerminalKeyException
   * @throws NotificationsAlreadyDisabledException
   */

  public void disableClientNotifications(String id)
    throws UnknownClientKeyException, NotificationsAlreadyDisabledException {
    Client client = this.getClientById(id);
    if (
      !client.disableClientNotifications()
    ) throw new NotificationsAlreadyDisabledException();
  }

  /**
   * Enable Client's notifications
   * @param  id The key of the client to enable notifications
   * @throws UnknownTerminalKeyException
   * @throws NotificationsAlreadyDisabledException
   */
  public void enableClientNotifications(String id)
    throws UnknownClientKeyException, NotificationsAlreadyEnabledException {
    Client client = this.getClientById(id);
    if (
      !client.enableClientNotifications()
    ) throw new NotificationsAlreadyEnabledException();
  }

  /**
   * Get the global debts in the Network
   * @return sum of all the clients in the Network debts
   */

  public double getGlobalDebts() {
    return this.clients.values()
      .stream()
      .mapToDouble(client -> client.getDebts())
      .sum();
  }

  /**
   * Get the global paid in the Network
   * @return sum of all the clients in the Network paid values
   */

  public double getGlobalPaid() {
    return this.clients.values()
      .stream()
      .mapToDouble(client -> client.getPaid())
      .sum();
  }

  /**
   * Get the debts from a client in the Network
   * @param  id The key of the client to get debts from
   * @throws UnknownClientKeyException
   * @return sum of all the client's debts
   */

  public double getClientDebts(String id) throws 
                                          UnknownClientKeyException {
    Client client = getClientById(id);
    return client.getDebts();
  }

  /**
   * Get the paid values from a client in the Network
   * @param  id The key of the client to get paid values from
   * @throws UnknownClientKeyException
   * @return sum of all the client's paid values
   */

  public double getClientPaid(String id) throws UnknownClientKeyException {
    Client client = getClientById(id);
    return client.getPaid();
  }

  /**
   * Get notifications from a client
   * @param  id The key of the client to get notifications from
   * @throws UnknownClientKeyException
   * @return all of the Client's notifications
   */

  public Collection<Notification> getClientNotifications(String id)
                                    throws UnknownClientKeyException {
    Client client = getClientById(id);
    Collection<Notification> notifications = client.getAllNotifications();
    client.resetNotifications();
    return notifications;
  }
}
