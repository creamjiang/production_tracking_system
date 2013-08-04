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


# See everything in the log (default is :info)
 config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new
#config.logger = Logger.new(config.log_path, 50, 1.megabyte)

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!