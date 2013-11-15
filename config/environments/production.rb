# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

#ExceptionNotifier.exception_recipients = %w(angmeng@gmail.com)                  # Accepts multiple e-mail addresses
#ExceptionNotifier.sender_address       = %("APP Error" <yeongwei.tan@al-lighting.com>) # Replace APP with Application Name
#ExceptionNotifier.email_prefix         = "[APP] "                               # Replace APP with Application Name
#ExceptionNotifier.consider_local       = "132.241.xxx.xxx"                      # Accepts comma separated list of IPs
ExceptionNotification::Notifier.exception_recipients = %w(laykuan.teh@al-lighting.com lim.am@icode-solution.com)
# defaults to exception.notifier@default.com
ExceptionNotification::Notifier.sender_address = %("Application Error" <app.error@al-lighting.com>)
# defaults to "[ERROR] "
ExceptionNotification::Notifier.email_prefix = "[APP Error] "

# See everything in the log (default is :info)
config.log_level = :error

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new
# config.logger = Logger.new(config.log_path, 50, 1.megabyte)
config.logger = Logger.new(config.log_path, 'daily')

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
    :user_name=>'laykuan.teh',
    :password=>'Al@72088',
    #:authentication=>:none,
    # :enable_starttls_auto => true
  }