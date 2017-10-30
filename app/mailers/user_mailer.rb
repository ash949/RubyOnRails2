class UserMailer < ApplicationMailer
  def contact_form(name, email, message)
    @message = message
    mail( from: email,
          to: 'hamzaashoor949@hotmail.com',
          subject: "#{name} has just send you a contact form message" )
  end
end
