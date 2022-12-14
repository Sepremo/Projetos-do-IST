package prr.app.terminal;

import prr.Network;
import prr.terminals.Terminal;
import prr.app.exceptions.UnknownTerminalKeyException;

import pt.tecnico.uilib.menus.CommandException;


/**
 * Add a friend.
 */
class DoAddFriend extends TerminalCommand {

	DoAddFriend(Network context, Terminal terminal) {
		super(Label.ADD_FRIEND, context, terminal);
		addStringField("id", Prompt.terminalKey());
	}

	@Override
	protected final void execute() throws CommandException {   
		try {
			_receiver.addFriend(stringField("id"),_network);
		} catch (prr.exceptions.UnknownTerminalKeyException e) {
			throw new UnknownTerminalKeyException(e.getKey());
		}
	}
}
