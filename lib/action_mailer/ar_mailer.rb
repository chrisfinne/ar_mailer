require 'action_mailer'

##
# Adds sending email through an ActiveRecord table as a delivery method for
# ActionMailer.
#

class ActionMailer::ARMailer < ActionMailer::Base

  def self.inherited(sub)
    logger.warn('The ActionMailer::ARMailer class has been deprecated. Will be removed in version 2.1. Just use ActionMailer::Base.')
  end

end

class ActionMailer::Base

  @@email_class = :Email

  ##
  # Current email class for deliveries.

  def self.email_class
    Object.const_get(@@email_class)
  end

  ##
  # Sets the email class for deliveries.

  def self.email_class=(klass)
    @@email_class = case klass.class.to_s
    when 'Class'
      klass.name.to_sym
    when 'Symbol'
      klass
    else
      raise "email_class should either be a Symbol or Class."
    end
  end

  ##
  # Adds +mail+ to the Email table.  Only the first From address for +mail+ is
  # used.

  def perform_delivery_activerecord(mail)
    email_class = self.class.email_class
    mail.destinations.each do |destination|
      email_class.create :mail => mail.encoded, :to => destination,
                           :from => mail.from.first
    end
  end

end

