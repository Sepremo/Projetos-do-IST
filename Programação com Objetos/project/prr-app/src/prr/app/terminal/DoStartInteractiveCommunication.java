package prr.app.terminal;

import prr.Network;
import prr.app.exceptions.UnknownTerminalKeyException;
import prr.terminals.Terminal;
import pt.tecnico.uilib.forms.Form;
import pt.tecnico.uilib.menus.CommandException;

/**
 * Command for starting communication.
 */
class DoStartInteractiveCommunication extends TerminalCommand {

	DoStartInteractiveCommunication(Network context, Terminal terminal) {
		super(Label.START_INTERACTIVE_COMMUNICATION, context, terminal, receiver -> receiver.canStartCommunication());
		addStringField("id", Prompt.terminalKey());
		addOptionField("type", Prompt.commType(), "VIDEO", "VOICE");
	}

	@Override
	protected final void execute() throws CommandException {
		try {
			_receiver.startInteractiveCommunication(stringField("id"),_network, stringField("type"));
			} catch (prr.exceptions.UnknownTerminalKeyException e) {
				throw new UnknownTerminalKeyException(e.getKey());
			} catch (prr.exceptions.TerminalIsOffException eOff) {
				_display.popup(Message.destinationIsOff(eOff.getKey()));
			} catch (prr.exceptions.TerminalIsBusyException eBusy) {
				_display.popup(Message.destinationIsBusy(eBusy.getKey()));
			} catch (prr.exceptions.TerminalIsSilentException eSilent) {
				_display.popup(Message.destinationIsSilent(eSilent.getKey()));
			} catch (prr.exceptions.UnsupportedAtOriginException eOrigin){
				_display.popup(Message.unsupportedAtOrigin(eOrigin.getKey(), stringField("type")));
			}
			catch (prr.exceptions.UnsupportedAtDestinationException eDestination){
				_display.popup(Message.unsupportedAtDestination(eDestination.getKey(), stringField("type")));
			}
	}
}
