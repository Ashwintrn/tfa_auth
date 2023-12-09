class ApplicationMailer < ActionMailer::Base
  default from: ENV["GMAIL_UNAME"]
  layout "mailer"
end
