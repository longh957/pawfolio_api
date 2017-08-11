# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
#
ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :address => "smtp.sendgrid.net",
  :port => 587,
  :domain => 'pawfol.io',
  :authentication => :plain,
  :enable_starttls_auto => true
}

Rails.application.initialize!
