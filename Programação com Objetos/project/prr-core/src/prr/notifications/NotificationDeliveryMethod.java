package prr.notifications;

import java.io.Serializable;


@FunctionalInterface // Has a single abstract method
public interface NotificationDeliveryMethod extends Serializable {

  void deliver(Notification notification);
  
}