package prr.app.terminal;

import prr.Network;
import prr.terminals.Terminal;
import pt.tecnico.uilib.menus.CommandException;
// Add more imports if needed

/**
 * Perform payment.
 */
class DoPerformPayment extends TerminalCommand {

	DoPerformPayment(Network context, Terminal terminal) {
		super(Label.PERFORM_PAYMENT, context, terminal);
		addIntegerField("id", Prompt.commKey());
	}

	@Override
	protected final void execute() throws CommandException {
                try {
					_receiver.payCommunication(integerField("id"));
				} catch (prr.exceptions.InvalidCommunicationKeyException e) { 
					_display.popup(Message.invalidCommunication());
				}
	}
}
