class ApplicationMailer < ActionMailer::Base
  default from: ENV["gmail_uname"]
  layout "mailer"
end
