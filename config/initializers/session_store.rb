# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Reflector_session',
  :secret      => '16324a65cdb05c2a691811f1a65d76618978d4afe5fcdbbfa36e859a847a00e0ed4c790bdf9c06e017b8a655d362d71688013d9d2a90076292d71ef581e066f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
 ActionController::Base.session_store = :active_record_store
