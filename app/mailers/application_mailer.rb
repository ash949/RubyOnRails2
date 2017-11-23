# application mailer (super class for application's mailer)
class ApplicationMailer < ActionMailer::Base
  default from: 'hamzaashoor949@hotmail.com'
  layout 'mailer'
end
