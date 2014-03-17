# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new
# config.logger = Logger.new(config.log_path, 50, 1.megabyte)
# config.logger = Logger.new(config.log_path, 'daily')

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

config.action_mailer.perform_deliveries = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
    :address => '10.102.4.25',
    :port=>25,
    :domain=>'al-lighting.com',
    # :user_name=>'laykuan.teh@al-lighting.com',
    # :password=>'Al@72088',
    :authentication=>:none
    # :enable_starttls_auto => true
  }

# config.action_mailer.delivery_method = :smtp
#   config.action_mailer.smtp_settings = {
#   :address  => "smtp.gmail.com",
#   :port  => 587,
#   :domain  => "gmail.com",
#   :user_name  => "abbydebra1",
#   :password  => "saa12345t",
#   :enable_starttls_auto => true,
#   :authentication => :plain
# }