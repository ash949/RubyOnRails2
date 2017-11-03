class UserMailer < ApplicationMailer
  def contact_form(name, email, message)
    @message = message
    mail( from: email,
          to: 'hamzaashoor949@hotmail.com',
          subject: "#{name} has just send you a contact form message" )
  end

  def welcome(client_name, client_email)
    @message = "#{client_name}, you have successfully signed up to H-ASH PC Store<br><br>Have a nice day :D"
    mail( from: 'H.ASH.shop@outlook.com',
          to: client_email,
          subject: "Hi #{client_name}, H-ASH PC Store welcomes you")
  end
end
